Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab0FUNf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 09:35:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:40647 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620Ab0FUNf4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 09:35:56 -0400
Subject: Re: [patch 11/33] fs: dcache scale subdirs
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       john stultz <johnstul@us.ibm.com>, John Kacur <jkacur@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20100617165329.GA6138@laptop>
References: <20090904065142.114706411@nick.local0.net>
	 <20090904065535.609317663@nick.local0.net>
	 <1276787615.27822.426.camel@twins>  <20100617165329.GA6138@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 21 Jun 2010 15:35:22 +0200
Message-ID: <1277127322.1875.516.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-18 at 02:53 +1000, Nick Piggin wrote:

> > Right, so this isn't going to work well, this dentry recursion is
> > basically unbounded afaict, so the 2nd subdir will also be locked using
> > DENRTY_D_LOCKED_NESTED, resulting in the 1st and 2nd subdir both having
> > the same (sub)class and lockdep doesn't like that much.
> 
> No it's a bit of a trucky loop, but it is not unbounded. It takes the
> parent, then the child, then it may continue again with the child as
> the new parent but in that case it drops the parent lock and tricks
> lockdep into not barfing.

Ah, indeed the thing you pointed out below should work.

> > Do we really need to keep the whole path locked? One of the comments
> > seems to suggest we could actually drop some locks and re-acquire.
> 
> As far as I can tell, RCU should be able to cover it without taking more
> than 2 locks at a time. John saw some issues in the -rt tree (I haven't
> reproduced yet) so he's locking the full chains there but I hope that
> won't be needed.

Right, so I was staring at the -rt splat, so its John who created that
wreckage?

static int select_parent(struct dentry * parent)
{
	struct dentry *this_parent;
	struct list_head *next;
	unsigned seq;
	int found;

rename_retry:
	found = 0;
	this_parent = parent;
	seq = read_seqbegin(&rename_lock);

	spin_lock(&this_parent->d_lock);
repeat:
	next = this_parent->d_subdirs.next;
resume:
	while (next != &this_parent->d_subdirs) {
		struct list_head *tmp = next;
		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
		next = tmp->next;

		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
		dentry_lru_del_init(dentry);
		/* 
		 * move only zero ref count dentries to the end 
		 * of the unused list for prune_dcache
		 */
		if (!atomic_read(&dentry->d_count)) {
			dentry_lru_add_tail(dentry);
			found++;
		}

		/*
		 * We can return to the caller if we have found some (this
		 * ensures forward progress). We'll be coming back to find
		 * the rest.
		 */
		if (found && need_resched()) {
			spin_unlock(&dentry->d_lock);
			goto out;
		}

		/*
		 * Descend a level if the d_subdirs list is non-empty.
		 * Note that we keep a hold on the parent lock while
		 * we descend, so we don't have to reacquire it on
		 * ascend.
		 */
		if (!list_empty(&dentry->d_subdirs)) {
			this_parent = dentry;
			goto repeat;
		}

		spin_unlock(&dentry->d_lock);
	}
	/*
	 * All done at this level ... ascend and resume the search.
	 */
	if (this_parent != parent) {
		struct dentry *tmp;
		struct dentry *child;

		tmp = this_parent->d_parent;
		child = this_parent;
		next = child->d_u.d_child.next;
		spin_unlock(&this_parent->d_lock);
		this_parent = tmp;
		goto resume;
	}

out:
	/* Make sure we unlock all the way back up the tree */
	while (this_parent != parent) {
		struct dentry *tmp = this_parent->d_parent;
		spin_unlock(&this_parent->d_lock);
		this_parent = tmp;
	}
	spin_unlock(&this_parent->d_lock);
	if (read_seqretry(&rename_lock, seq))
		goto rename_retry;
	return found;
}


> > >                 /*
> > >                  * Descend a level if the d_subdirs list is non-empty.
> > >                  */
> > >                 if (!list_empty(&dentry->d_subdirs)) {
> > > +                       spin_unlock(&this_parent->d_lock);
> > > +                       spin_release(&dentry->d_lock.dep_map, 1, _RET_IP_);
> > >                         this_parent = dentry;
> > > +                       spin_acquire(&this_parent->d_lock.dep_map, 0, 1, _RET_IP_);
> > >                         goto repeat;
> 
>                             ^^^ That's what we do when descending.

You can write that as:
  lock_set_subclass(&this_parent->d_lock.dep_map, 0, _RET_IP_);

See kernel/sched.c:double_unlock_balance().



