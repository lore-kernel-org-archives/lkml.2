Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab0JOU4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:56:51 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:64190 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756291Ab0JOU4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:56:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAKNauEx5Ld+3/2dsb2JhbAChJHLBJoVJBIUMij4
Date: Sat, 16 Oct 2010 07:56:44 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
Message-ID: <20101015205644.GB20476@amd>
References: <20101013232319.GZ4681@dastard>
 <20101014090609.GB3144@amd>
 <20101014144159.GA11972@infradead.org>
 <20101015001443.GA3146@amd>
 <20101015031343.GG4681@dastard>
 <20101015033017.GA6750@amd>
 <20101015034451.GA6827@amd>
 <20101015064150.GB7511@amd>
 <20101015105943.GE32255@dastard>
 <20101015205045.GA20476@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101015205045.GA20476@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 07:50:45AM +1100, Nick Piggin wrote:
> On Fri, Oct 15, 2010 at 09:59:43PM +1100, Dave Chinner wrote:
> > On Fri, Oct 15, 2010 at 05:41:50PM +1100, Nick Piggin wrote:
> > > You're worried about mere mortals reviewing and understanding it...
> > > I don't really know. If you understand inode locking today, you
> > > can understand the inode scaling series quite easily. Ditto for
> > > dcache. rcu-walk path walking is trickier, but it is described in
> > > detail in documentation and changelog.
> > > 
> > > And you can understand the high level approach without exactly
> > > digesting every detail at once. The inode locking work goes to
> > > break up all global locks:
> > > 
> > > - a single inode object is protected (to the same level as
> > >   inode_lock) with i_lock. This makes it really trivial for
> > >   filesystems to lock down the object without taking a global
> > >   lock.
> > 
> > Which is unnecessarily wide, and results in i_lock  having to have
> > list locks nested inside it, and that leads to the lock
> > inversion try-lock mess that several people have complained about.
> 
> Gee, you keep repeating this so often that you have me doubting
> myself a tiny bit, so I have to check.
> 
> $ grep spin_trylock fs/inode.c fs/fs-writeback.c
> fs/inode.c:             if (!spin_trylock(&inode->i_lock)) {
> fs/inode.c:             if (!spin_trylock(&old->i_lock)) {
> fs/inode.c:             if (!spin_trylock(&old->i_lock)) {
> fs/fs-writeback.c:      if (!spin_trylock(&inode->i_lock)) {
> fs/fs-writeback.c:      if (!spin_trylock(&inode->i_lock)) {
> fs/fs-writeback.c:      if (!spin_trylock(&inode->i_lock)) {
> 
> This is your unmaintainable mess?  You decided to rewrite your own

The other thing that strikes my mind is that maybe you're looking
at intermediate steps in the series, which admittedly grow ugly
before they start to get clean.

This was a deliberate choice in how I set out the patch series, to
show very clearly every small step where and how locking was being
changed along the way. It is made so it can be followed (from the
patch series) by fs developers or anyone porting code to it almost.
It is absolutely not supposed to look pretty or be run with only
the first steps done. It is supposed to be verifiable, auditable,
and bisectable.

I've split it up like this since I first posted anything to any
list and asked for comments. If you object to that now, I find it
a bit rich. I will change the way it is done if Al tells me to,
but ugly in the intermediate steps don't mean a thing if you're
ignoring the end result.

