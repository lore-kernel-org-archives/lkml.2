Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab1ADJ2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 04:28:49 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:8017 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751206Ab1ADJ2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 04:28:48 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAHd2Ik15Ldpx/2dsb2JhbACkNXS7eIVKBJAt
Date: Tue, 4 Jan 2011 20:28:42 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, mfasheh@suse.com,
        joel.becker@oracle.com, swhiteho@redhat.com
Subject: Re: [patch 7/8] fs: fix or note I_DIRTY handling bugs in
 filesystems
Message-ID: <20110104092842.GA4746@amd>
References: <20101218014634.943276411@kernel.dk>
 <20101218015117.652706340@kernel.dk>
 <20101229150108.GA13358@infradead.org>
 <20110104060452.GC3402@amd>
 <20110104063944.GA1910@infradead.org>
 <20110104075248.GB4090@amd>
 <20110104091347.GA2760@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110104091347.GA2760@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 04:13:48AM -0500, Christoph Hellwig wrote:
> On Tue, Jan 04, 2011 at 06:52:48PM +1100, Nick Piggin wrote:
> > Right if you want a helper to get the correct mask of bits required
> > that's fine and I agree, but locking is a different issue too: if
> > filesystems are trying to keep private state in sync with vfs state,
> > then they _need_ to do it properly with the proper locking. I think
> > your hfsplus implementation had a bug or two in this area didn't it?
> > (although I ended up getting side tracked with all these bugs half
> > way through looking at that).
> 
> It's not locking, but ordering that was the issue.  It's an issue caused

Right, but ordering should probably not be an issue if filesystem could
manage the dirty state and locking by itself. 


> by the VFS interfaces, but not really related to the area you work
> on currently.  If ->dirty_inode told us what was dirtied it would be

Well it's one side of the issue, the other side is indeed the dirtying
side.


> a lot simpler.  Alternatively we should just stop requiring filesystems
> to participate in the I_DIRTY_SYNC/DATASYNC protocol.  In general it's
> much easier for the filesystem to keep that state by itself in proper
> granularity.  But I lost the fight to have the timestamp updates go
> through proper methods instead of just writing into the VFS inode and
> marking the inode dirty long ago, so we'll have to live with it.

I wouldn't mind revisiting that, once these correctness fixes are in
(and yes that's another good reason to hold off with allowing
filesystems to do the i_state locking just yet).

Allowing the filesystem to entirely manage the setting and clearing of
dirty bits would be a good idea. Then just have a single bit that
specifies they want background writeout to run a callback together when
it does data writeout for that inode. Everything else would be done in
the fs.

Page dirtying has similarly silly conventions like having the caller
clear dirty before calling into ->writepage, which means the filesystem
has to have hacks like redirty_page_for_io and has a hard time keeping
page dirty state in sync with page private metadata. (completely
different issue but similar general problem of having things half
managed by one side and half by the other).

