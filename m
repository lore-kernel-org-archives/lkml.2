Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab0JOUuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:50:51 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:53424 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932308Ab0JOUuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:50:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAKNauEx5Ld+3/2dsb2JhbAChJHLBJoVJBIUMij4
Date: Sat, 16 Oct 2010 07:50:45 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <npiggin@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
Message-ID: <20101015205045.GA20476@amd>
References: <20101013123008.GA6067@amd>
 <20101013232319.GZ4681@dastard>
 <20101014090609.GB3144@amd>
 <20101014144159.GA11972@infradead.org>
 <20101015001443.GA3146@amd>
 <20101015031343.GG4681@dastard>
 <20101015033017.GA6750@amd>
 <20101015034451.GA6827@amd>
 <20101015064150.GB7511@amd>
 <20101015105943.GE32255@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101015105943.GE32255@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 09:59:43PM +1100, Dave Chinner wrote:
> On Fri, Oct 15, 2010 at 05:41:50PM +1100, Nick Piggin wrote:
> > You're worried about mere mortals reviewing and understanding it...
> > I don't really know. If you understand inode locking today, you
> > can understand the inode scaling series quite easily. Ditto for
> > dcache. rcu-walk path walking is trickier, but it is described in
> > detail in documentation and changelog.
> > 
> > And you can understand the high level approach without exactly
> > digesting every detail at once. The inode locking work goes to
> > break up all global locks:
> > 
> > - a single inode object is protected (to the same level as
> >   inode_lock) with i_lock. This makes it really trivial for
> >   filesystems to lock down the object without taking a global
> >   lock.
> 
> Which is unnecessarily wide, and results in i_lock  having to have
> list locks nested inside it, and that leads to the lock
> inversion try-lock mess that several people have complained about.

Gee, you keep repeating this so often that you have me doubting
myself a tiny bit, so I have to check.

$ grep spin_trylock fs/inode.c fs/fs-writeback.c
fs/inode.c:             if (!spin_trylock(&inode->i_lock)) {
fs/inode.c:             if (!spin_trylock(&old->i_lock)) {
fs/inode.c:             if (!spin_trylock(&old->i_lock)) {
fs/fs-writeback.c:      if (!spin_trylock(&inode->i_lock)) {
fs/fs-writeback.c:      if (!spin_trylock(&inode->i_lock)) {
fs/fs-writeback.c:      if (!spin_trylock(&inode->i_lock)) {

This is your unmaintainable mess?  You decided to rewrite your own
vfs-scale tree because I wanted i_lock to protect the icache state (and
offered you very good reason for)?

Well, surely they must be horrible complex and unmaintainable
beasts....

repeat:
	/*
	 * Don't use RCU walks, common case of no old inode
	 * found requires hash lock.
	 */
        spin_lock_bucket(b);
        hlist_bl_for_each_entry(old, node, &b->head, i_hash) {
                if (old->i_ino != ino)
                        continue;
                if (old->i_sb != sb)
                        continue;
                if (old->i_state & (I_FREEING|I_WILL_FREE))
                        continue;
                if (!spin_trylock(&old->i_lock)) {
                        spin_unlock_bucket(b);
                        cpu_relax();
                        goto repeat;
                }

Nope, no big deal. The rest are much the same. So thanks for the
repeated suggestion, but I'll actually prefer to keep my regular i_lock
locking scheme where you don't need to look up the documentation and
think hard about coherency between protected and unprotected parts of
the inode whenever you use it. I didn't stumble upon my locking design
by chance.

If you think a few trylocks == impending doom, then xfs is looking
pretty poorly at this point. So I would ask that you stop making things
up about my patch series. If you dislike the trylocks so much that you
think it is worth breaking the i_lock regularity or using RCU or
whatever, then please propose them as incremental patches to the end
of my series where you can see they logically will fit. You know I will
argue that locking consistency is more important for maintainability
than these few trylocks, however.

