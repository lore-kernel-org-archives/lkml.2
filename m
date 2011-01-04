Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab1ADHwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 02:52:54 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:3864 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750897Ab1ADHwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 02:52:53 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEANpdIk15Ldpx/2dsb2JhbACkNnS7R4VKBJAq
Date: Tue, 4 Jan 2011 18:52:48 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, mfasheh@suse.com,
        joel.becker@oracle.com, swhiteho@redhat.com
Subject: Re: [patch 7/8] fs: fix or note I_DIRTY handling bugs in
 filesystems
Message-ID: <20110104075248.GB4090@amd>
References: <20101218014634.943276411@kernel.dk>
 <20101218015117.652706340@kernel.dk>
 <20101229150108.GA13358@infradead.org>
 <20110104060452.GC3402@amd>
 <20110104063944.GA1910@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110104063944.GA1910@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 01:39:44AM -0500, Christoph Hellwig wrote:
> On Tue, Jan 04, 2011 at 05:04:52PM +1100, Nick Piggin wrote:
> > However I strongly believe that filesystems should be able to access
> > and manipulate the inode dirty state directly. If you agree with that,
> > then I think they should be able to access the lock required for that.
> > Filesystems will want to keep their internal state in synch with vfs
> > visible state most likely (eg. like your hfsplus patches), and _every_
> > time we do "loose" coupling between state bits like this (eg. page and
> > buffer state; page and pte state; etc), it turns out to be a huge mess
> > of races and subtle code and ordering.
> 
> I've probably done the two most complicated fsync implementations in xfs
> and hfsplys myself, and I'd really prefer the interface to be as simple
> as possible.

Agree and as I said I'll change inode_writeback_begin/end to do the
locking and just return the dirty bit mask etc.


>  The way the I_DIRTY_* flags and the datasync parameter to
> ->fsync interact are almost a receipe for getting it wrong, which in
> fact most implementations that tried to be smart did.  See gfs2 and
> ocfs2 comments in this threads for classic examples.

Right if you want a helper to get the correct mask of bits required
that's fine and I agree, but locking is a different issue too: if
filesystems are trying to keep private state in sync with vfs state,
then they _need_ to do it properly with the proper locking. I think
your hfsplus implementation had a bug or two in this area didn't it?
(although I ended up getting side tracked with all these bugs half
way through looking at that).


> If we actually get filesystems that need to do smarts in
> checking/clearing the I_DIRTY_* flag we can discuss proper interfaces
> for it - duplicating guts of i_state manipulations sounds like a
> relatively bad idea for that.

I disagree, but we'll explore it further later.

It is a couple of lines to check and clear dirty bits.  Not rocket
science and I think it is far better to make it explicit what is
happening to the filesystem. The disconnect between what the vfs is
doing and what the filesystems throught should be happening is what
caused all these bugs to start with.

Anyway, long story short, I'll drop the inode_lock export and move the
locking and manipulation into inode_writeback_begin/end for now.

Thanks,
Nick

