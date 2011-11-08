Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab1KHDDG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 22:03:06 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62572 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab1KHDDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 22:03:01 -0500
Date: Tue, 8 Nov 2011 11:02:50 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org,
        sergey.senozhatsky@gmail.com, bp@alien8.de,
        Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>, casteyde.christian@free.fr
Subject: Re: [PATCH 1/4] lockdep: lock_set_subclass() fix
Message-ID: <20111108030250.GC11439@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1320398790-21663-1-git-send-email-yong.zhang0@gmail.com>
 <1320398790-21663-2-git-send-email-yong.zhang0@gmail.com>
 <1320669279.18053.29.camel@twins>
 <CAOMGZ=EC0eHahfHy2K=5HwBwOCWEdF6u-mDaeLhb4GQVKVxLLA@mail.gmail.com>
 <1320682230.17809.11.camel@twins>
 <20111108025847.GB11439@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111108025847.GB11439@zhy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 10:58:47AM +0800, Yong Zhang wrote:
> On Mon, Nov 07, 2011 at 05:10:29PM +0100, Peter Zijlstra wrote:
> > On Mon, 2011-11-07 at 16:28 +0100, Vegard Nossum wrote:
> > > 1. Initialise the thing completely before doing the copy, or
> > > 2. Ignore the warning.
> > > 
> > > The memset() patch (f59de8992aa6dc85e81aadc26b0f69e17809721d) attempts
> > > to do the first, i.e. to clear the whole struct in lockdep_init_map().
> > > 
> > > I think nr. 1 is the best way to go in principle, but I don't know
> > > what it takes for this to work properly. The blanket-clear memset()
> > > presumably doesn't work because it clears out something that was
> > > already initialised by the caller (right?).
> > > 
> > > Yong Zhang, can you think of a way to avoid the race you described,
> > > perhaps by memset()ing only the right/relevant parts of struct
> > > lockdep_map in lockdep_init_map()?
> > 
> > We could move the key and name pointer to the start of the structure and
> > memset everything after that, however wouldn't that leave kmemcheck with
> > the same problem? It wouldn't know those two pointers would be
> > initialized properly.
> > 
> > > Peter Zijlstra, if you prefer, we can also just tell kmemcheck that
> > > this particular copy is fine, but it means that kmemcheck will not be
> > > able to detect any real bugs in this code. It can be done with
> > > something like:
> 
> We should take ->calss_cache more carefully, because if we memset() it
> unconditionnally we will have no chance to set it anymore. Thus the
> performace brought by ->class_cache will be gone.
> 
> 1) for lock_set_subclass(): we can't initialize ->class_cache because
>    it's still valid and we need it.
> 2) for lock_set_class(): we have to initialize ->class_cache because
>    it's invalid anymore.
> 
> Maybe we could unconditionally set it we look_up_lock_class() find the
> class?
> 
> > 
> > Something like this, although it would be best to come up with a nicer
> > way to write it..
> > 
> > ---
> >  include/linux/lockdep.h |    2 +-
> >  kernel/lockdep.c        |    3 ++-
> >  2 files changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
> > index b6a56e3..7d66268 100644
> > --- a/include/linux/lockdep.h
> > +++ b/include/linux/lockdep.h
> > @@ -148,9 +148,9 @@ void clear_lock_stats(struct lock_class *class);
> >   * This is embedded into specific lock instances:
> >   */
> >  struct lockdep_map {
> > +	const char			*name;
> >  	struct lock_class_key		*key;
> >  	struct lock_class		*class_cache[NR_LOCKDEP_CACHING_CLASSES];
> > -	const char			*name;
> >  #ifdef CONFIG_LOCK_STAT
> >  	int				cpu;
> >  	unsigned long			ip;
> > diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> > index e69434b..81855cf 100644
> > --- a/kernel/lockdep.c
> > +++ b/kernel/lockdep.c
> > @@ -2948,7 +2948,8 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
> >  void lockdep_init_map(struct lockdep_map *lock, const char *name,
> >  		      struct lock_class_key *key, int subclass)
> >  {
> > -	memset(lock, 0, sizeof(*lock));
> > +	kmemcheck_mark_initialized(lock, 2*sizeof(void *));
> > +	memset(&lock->class_cache[0], 0, sizeof(*lock)-2*sizeof(void *));
> 
> That means ->key have chance to be 0 at some time, right? Then I think it'll
> lead to another false positive warning like what Borislav has reported:
> http://marc.info/?l=linux-kernel&m=132039877026653
> 
> The reason is some rq->lock could carry a wrong key at certain time.
> 
> 	CPU A				CPU B
>   lock_set_subclass(lockA)
>     __lock_set_class(lockA)
>       lockdep_init_map(lockA)
>         memset() /* ->key = NULL */
>       				__lock_acquire(lockA)
> 				  register_lock_class(lockA)
> 				    look_up_lock_class(lockA)
> 				      if (unlikely(!lock->key))
> 				              lock->key = (void *)lock;
> 	->key = key;
> 				/* lockA maybe carry wrong class in later running
> 				 * due to ->class_cache
> 				 */

And lockA could also carry different key:

	CPU A				CPU B
  lock_set_subclass(lockA)
    __lock_set_class(lockA)
      lockdep_init_map(lockA)
        memset() /* ->key = NULL */
      				__lock_acquire(lockA)
				  register_lock_class(lockA)
				    look_up_lock_class(lockA)
				      if (unlikely(!lock->key))
	->key = key;
				              lock->key = (void *)lock;
				/* lockA maybe carry wrong key in later running
				 * due to ->class_cache
				 */

Thanks,
Yong

> 
> 
> Then when another lock_set_subclass() comes:
>         CPU A                           CPU B
>   lock_set_subclass(lockA);
>     lock_set_class(lockA);
>       				__lock_acquire(lockA)
>                                   /* lockA->class_cache[] is not set,
> 				   * different subclass */
>                                   register_lock_class(lockA);
>                                      look_up_lock_class(lockA); /* retrun NULL */
>       lockdep_init_map(lockA);
>         memset(lockA); /* ->key = NULL */
>                                   if (!static_obj(lock->key))
>                                   /* we get warning here */
> 
> 
> So maybe the simplest way is just annotating ->lock like this:
> 	kmemcheck_mark_initialized(lock, sizeof(*lock));
> 
> Thanks,
> Yong

-- 
Only stand for myself
