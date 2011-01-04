Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650Ab1ADGE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 01:04:59 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:22122 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751099Ab1ADGE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 01:04:57 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAEBFIk15Ldpx/2dsb2JhbACkNXS7ToVKBJAq
Date: Tue, 4 Jan 2011 17:04:52 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, mfasheh@suse.com,
        joel.becker@oracle.com, swhiteho@redhat.com
Subject: Re: [patch 7/8] fs: fix or note I_DIRTY handling bugs in
 filesystems
Message-ID: <20110104060452.GC3402@amd>
References: <20101218014634.943276411@kernel.dk>
 <20101218015117.652706340@kernel.dk>
 <20101229150108.GA13358@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101229150108.GA13358@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 29, 2010 at 10:01:09AM -0500, Christoph Hellwig wrote:
> As mentioned last round I think the exporting of inode_lock and pusing
> of the I_DIRTY* complexities into the filesystems can be avoided.  See

Yes I did see that, I hoped to continue discussion of that detail.

Let me start out by saying OK I will agree to hold off that change
until inode_lock is removed at least, and concentrate on just the
fixes.

However I strongly believe that filesystems should be able to access
and manipulate the inode dirty state directly. If you agree with that,
then I think they should be able to access the lock required for that.
Filesystems will want to keep their internal state in synch with vfs
visible state most likely (eg. like your hfsplus patches), and _every_
time we do "loose" coupling between state bits like this (eg. page and
buffer state; page and pte state; etc), it turns out to be a huge mess
of races and subtle code and ordering.


> the patch below, which compiles and passes xfstests for xfs, but
> otherwise isn't quite done yet.  The only code change vs the opencoded
> variant in the patch is that we do a useless inode_lock roundtrip

I dislike this style, except where it has some real advantages like
get_block case. I prefer just to make the existing inode_writeback_begin
into a "__special" variant, and make inode_writeback_begin just do the
locking and masking for filesystems.


> for a non-dirty inode on gfs2, which is I think is acceptable,
> especially once we have the lock split anyway.

The bigger issue IMO is if filesystems want to be smarter with dirty
bit handling and keep more internal state in sync with it. I don't
see any problem at all with allowing them to lock the dirty state.
(but will hold off the patch for now, as said).
 
Thanks,
Nick

