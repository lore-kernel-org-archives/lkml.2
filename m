Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932983Ab1KGQ11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:27:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:56558 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271Ab1KGQ1Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:27:25 -0500
Subject: Re: [PATCH 1/4] lockdep: lock_set_subclass() fix
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Tejun Heo <tj@kernel.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org,
        sergey.senozhatsky@gmail.com, bp@alien8.de,
        Ingo Molnar <mingo@elte.hu>, David Rientjes <rientjes@google.com>,
        casteyde.christian@free.fr
Date: Mon, 07 Nov 2011 17:26:19 +0100
In-Reply-To: <20111107162159.GC13699@google.com>
References: <1320398790-21663-1-git-send-email-yong.zhang0@gmail.com>
	 <1320398790-21663-2-git-send-email-yong.zhang0@gmail.com>
	 <1320669279.18053.29.camel@twins>
	 <CAOMGZ=EC0eHahfHy2K=5HwBwOCWEdF6u-mDaeLhb4GQVKVxLLA@mail.gmail.com>
	 <1320682230.17809.11.camel@twins> <20111107162159.GC13699@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320683179.17809.22.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-07 at 08:21 -0800, Tejun Heo wrote:

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
> 
> Probably fat comment explaining the ordering requirement here w/

yes.

> #define LOCKDEP_MAP_INIT_OFFSET		offsetof(struct lockdep_map, class_cache)
> 
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
> And something like the following?
> 
> 	memset((void *)lock + LOCKDEP_MAP_INIT_OFFSET, 0,
> 		sizeof(*lock) - LOCKDEP_MAP_INIT_OFFSET);

Much better indeed!
