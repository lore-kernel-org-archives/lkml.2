Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab1ACPDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 10:03:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932114Ab1ACPDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 10:03:18 -0500
Subject: Re: [patch 7/8] fs: fix or note I_DIRTY handling bugs in
 filesystems
From: Steven Whitehouse <swhiteho@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, mfasheh@suse.com,
        joel.becker@oracle.com
In-Reply-To: <20101229150108.GA13358@infradead.org>
References: <20101218014634.943276411@kernel.dk>
	 <20101218015117.652706340@kernel.dk> <20101229150108.GA13358@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 03 Jan 2011 15:03:29 +0000
Message-ID: <1294067009.2429.109.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2010-12-29 at 10:01 -0500, Christoph Hellwig wrote:
> As mentioned last round I think the exporting of inode_lock and pusing
> of the I_DIRTY* complexities into the filesystems can be avoided.  See
> the patch below, which compiles and passes xfstests for xfs, but
> otherwise isn't quite done yet.  The only code change vs the opencoded
> variant in the patch is that we do a useless inode_lock roundtrip
> for a non-dirty inode on gfs2, which is I think is acceptable,
> especially once we have the lock split anyway.
> 
> The other thing I don't like yet is passing the datasync flag - the
> callback shouldn't care about what we were called with, but rather
> about which bits it needs to sync out - which the dirty flag already
> tells us about.
> 
> IMHO the behaviour in ocfs2 and gfs2 that relies on it is plain wrong:
> 
>  - ocfs2 really should always force the journal if any bit we care about
>    in the inode is dirty, and only do the pure cache flush is nothing
>    we care about is dirty (similar to the more complex code in XFS)
>  - gfs2 seems really weird.  Doesn't it need to do any log force
>    if an inode has a pending transaction?  Currently it only does for
>    stuffed inodes, and if datasync was set, which seems weird.  Also
>    I can't see why we'd never want to call into ->write_inode to write
>    out the inode for the datasync case - except for not catching
>    timestamp updates fdatasync really isn't any different from fsync.
> 
The algorithm was intended to be:

 - With "journaled data" files
   - Do a log flush conditional upon the inode's glock
   - The core code then writes back any dirty pages

 - With regular files/directories
  - If datasync is not set, we need to write back the metadata including
timestamp updates, so that is done via ->write_inode. Note that an extra
complication here is that we need to get the glock on the inode if we
don't already have it in order to check and conditionally update the
atime.The call to ->write_inode includes an implicit (conditional) log
flush.
 - If datasync is set, we assume that only the data pages need to be
written out. My understanding of datasync was that it was only supposed
to write out data and never any of the metadata. The reason for the call
to flush the log for "stuffed" files is that the data shares a disk
block with the inode metadata, so we cannot avoid the log flush in this
case, since we must unpin the block to write it back.

There is something strange going on here though since there should be a
metadata sync included as well I think - I'm just working back through
the changes to see where that was lost at the moment,

Steve.


