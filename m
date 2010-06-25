Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab0FYGqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 02:46:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:37999 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab0FYGqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 02:46:00 -0400
Date: Fri, 25 Jun 2010 16:45:56 +1000
From: Nick Piggin <npiggin@suse.de>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Frank Mayhar <fmayhar@google.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 16/52] fs: dcache RCU for multi-step operaitons
Message-ID: <20100625064556.GT10441@laptop>
References: <20100624030212.676457061@suse.de>
 <20100624030728.129875799@suse.de>
 <1277400397.15264.34.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277400397.15264.34.camel@work-vm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 10:26:37AM -0700, John Stultz wrote:
> On Thu, 2010-06-24 at 13:02 +1000, npiggin@suse.de wrote:
> > plain text document attachment (fs-dcache_lock-multi-step.patch)
> > The remaining usages for dcache_lock is to allow atomic, multi-step read-side
> > operations over the directory tree by excluding modifications to the tree.
> > Also, to walk in the leaf->root direction in the tree where we don't have
> > a natural d_lock ordering.
> > 
> > This could be accomplished by taking every d_lock, but this would mean a
> > huge number of locks and actually gets very tricky.
> > 
> > Solve this instead by using the rename seqlock for multi-step read-side
> > operations. Insert operations are not serialised. Delete operations are
> > tricky when walking up the directory our parent might have been deleted
> > when dropping locks so also need to check and retry for that.
> > 
> > XXX: hmm, we could of course just take the rename lock if there is any worry
> > about livelock. Most of these are slow paths.
> 
> I'll try to point out exactly the spot I think we were hitting in the
> -rt tree (once the dcache_lock is removed).
> 
> 
> > @@ -1030,9 +1056,15 @@ EXPORT_SYMBOL(have_submounts);
> >   */
> >  static int select_parent(struct dentry * parent)
> >  {
> > -	struct dentry *this_parent = parent;
> > +	struct dentry *this_parent;
> >  	struct list_head *next;
> > -	int found = 0;
> > +	unsigned seq;
> > +	int found;
> > +
> > +rename_retry:
> > +	found = 0;
> > +	this_parent = parent;
> > +	seq = read_seqbegin(&rename_lock);
> > 
> >  	spin_lock(&dcache_lock);
> >  	spin_lock(&this_parent->d_lock);
> > @@ -1043,7 +1075,6 @@ resume:
> >  		struct list_head *tmp = next;
> >  		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
> >  		next = tmp->next;
> > -		BUG_ON(this_parent == dentry);
> > 
> >  		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
> >  		dentry_lru_del_init(dentry);
> > @@ -1084,17 +1115,33 @@ resume:
> >  	 */
> >  	if (this_parent != parent) {
> >  		struct dentry *tmp;
> > -		next = this_parent->d_u.d_child.next;
> > +		struct dentry *child;
> > +
> >  		tmp = this_parent->d_parent;
> > +		rcu_read_lock();
> >  		spin_unlock(&this_parent->d_lock);
> > -		BUG_ON(tmp == this_parent);
> > +		child = this_parent;
> >  		this_parent = tmp;
> 
> Ok. So right here, we get preempted, or dput() is called by another cpu
> on the child dentry, or the child->d_u.d_child.next dentry and its
> d_kill'ed.
> 
> >  		spin_lock(&this_parent->d_lock);
> > +		/* might go back up the wrong parent if we have had a rename
> > +		 * or deletion */
> > +		if (this_parent != child->d_parent ||
> > +				// d_unlinked(this_parent) || XXX
> > +				read_seqretry(&rename_lock, seq)) {
> > +			spin_unlock(&this_parent->d_lock);
> > +			spin_unlock(&dcache_lock);
> > +			rcu_read_unlock();
> > +			goto rename_retry;
> > +		}
> > +		rcu_read_unlock();
> > +		next = child->d_u.d_child.next;
> 
> Then at this point, next may point to junk. 

But see the test above it. We ensure that child->d_parent still points
to this_parent with this_parent d_lock held. Oh, I'm not clearing
d_parent! d_kill() should have
  dentry->d_parent = NULL;
when it removes dentry from the list.

That should fix it I'd hope.

Thanks,
Nick

