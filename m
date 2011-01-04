Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305Ab1ADGjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 01:39:49 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59464 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab1ADGjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 01:39:48 -0500
Date: Tue, 4 Jan 2011 01:39:44 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, mfasheh@suse.com,
        joel.becker@oracle.com, swhiteho@redhat.com
Subject: Re: [patch 7/8] fs: fix or note I_DIRTY handling bugs in filesystems
Message-ID: <20110104063944.GA1910@infradead.org>
References: <20101218014634.943276411@kernel.dk>
 <20101218015117.652706340@kernel.dk>
 <20101229150108.GA13358@infradead.org>
 <20110104060452.GC3402@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110104060452.GC3402@amd>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 05:04:52PM +1100, Nick Piggin wrote:
> However I strongly believe that filesystems should be able to access
> and manipulate the inode dirty state directly. If you agree with that,
> then I think they should be able to access the lock required for that.
> Filesystems will want to keep their internal state in synch with vfs
> visible state most likely (eg. like your hfsplus patches), and _every_
> time we do "loose" coupling between state bits like this (eg. page and
> buffer state; page and pte state; etc), it turns out to be a huge mess
> of races and subtle code and ordering.

I've probably done the two most complicated fsync implementations in xfs
and hfsplys myself, and I'd really prefer the interface to be as simple
as possible.  The way the I_DIRTY_* flags and the datasync parameter to
->fsync interact are almost a receipe for getting it wrong, which in
fact most implementations that tried to be smart did.  See gfs2 and
ocfs2 comments in this threads for classic examples.

If we actually get filesystems that need to do smarts in
checking/clearing the I_DIRTY_* flag we can discuss proper interfaces
for it - duplicating guts of i_state manipulations sounds like a
relatively bad idea for that.  Note that my fsync_helper still gives
filesystems a lot of information, just not in a redundant and confusing
way.  The dirty argument still tells if datasync-relevant or
non-datasyns relevant (aka timestampts) metadata was dirty, so if a
filesystem needs to write them back in different ways it still can.

