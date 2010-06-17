Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933080Ab0FQQxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 12:53:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34470 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756881Ab0FQQxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 12:53:35 -0400
Date: Fri, 18 Jun 2010 02:53:29 +1000
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       john stultz <johnstul@us.ibm.com>, John Kacur <jkacur@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 11/33] fs: dcache scale subdirs
Message-ID: <20100617165329.GA6138@laptop>
References: <20090904065142.114706411@nick.local0.net>
 <20090904065535.609317663@nick.local0.net>
 <1276787615.27822.426.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276787615.27822.426.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 05:13:35PM +0200, Peter Zijlstra wrote:
> On Fri, 2009-09-04 at 16:51 +1000, npiggin@suse.de wrote:
> > @@ -932,6 +984,7 @@ static int select_parent(struct dentry *
> >         int found = 0;
> >  
> >         spin_lock(&dcache_lock);
> > +       spin_lock(&this_parent->d_lock);
> >  repeat:
> >         next = this_parent->d_subdirs.next;
> >  resume:
> > @@ -939,8 +992,9 @@ resume:
> >                 struct list_head *tmp = next;
> >                 struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
> >                 next = tmp->next;
> > +               BUG_ON(this_parent == dentry);
> >  
> > -               spin_lock(&dentry->d_lock);
> > +               spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
> 
> Right, so this isn't going to work well, this dentry recursion is
> basically unbounded afaict, so the 2nd subdir will also be locked using
> DENRTY_D_LOCKED_NESTED, resulting in the 1st and 2nd subdir both having
> the same (sub)class and lockdep doesn't like that much.

No it's a bit of a trucky loop, but it is not unbounded. It takes the
parent, then the child, then it may continue again with the child as
the new parent but in that case it drops the parent lock and tricks
lockdep into not barfing.

 
> Do we really need to keep the whole path locked? One of the comments
> seems to suggest we could actually drop some locks and re-acquire.

As far as I can tell, RCU should be able to cover it without taking more
than 2 locks at a time. John saw some issues in the -rt tree (I haven't
reproduced yet) so he's locking the full chains there but I hope that
won't be needed.

> 
> >                 dentry_lru_del_init(dentry);
> >                 /* 
> >                  * move only zero ref count dentries to the end 
> > @@ -950,33 +1004,45 @@ resume:
> >                         dentry_lru_add_tail(dentry);
> >                         found++;
> >                 }
> > -               spin_unlock(&dentry->d_lock);
> >  
> >                 /*
> >                  * We can return to the caller if we have found some (this
> >                  * ensures forward progress). We'll be coming back to find
> >                  * the rest.
> >                  */
> > -               if (found && need_resched())
> > +               if (found && need_resched()) {
> > +                       spin_unlock(&dentry->d_lock);
> >                         goto out;
> > +               }
> >  
> >                 /*
> >                  * Descend a level if the d_subdirs list is non-empty.
> >                  */
> >                 if (!list_empty(&dentry->d_subdirs)) {
> > +                       spin_unlock(&this_parent->d_lock);
> > +                       spin_release(&dentry->d_lock.dep_map, 1, _RET_IP_);
> >                         this_parent = dentry;
> > +                       spin_acquire(&this_parent->d_lock.dep_map, 0, 1, _RET_IP_);
> >                         goto repeat;

                            ^^^ That's what we do when descending.


