Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab1KHH5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 02:57:17 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48591 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab1KHH5Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 02:57:16 -0500
Subject: Re: [PATCH 1/4] lockdep: lock_set_subclass() fix
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org,
        sergey.senozhatsky@gmail.com, bp@alien8.de,
        Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>, casteyde.christian@free.fr
Date: Tue, 08 Nov 2011 08:56:55 +0100
In-Reply-To: <20111108025847.GB11439@zhy>
References: <1320398790-21663-1-git-send-email-yong.zhang0@gmail.com>
	 <1320398790-21663-2-git-send-email-yong.zhang0@gmail.com>
	 <1320669279.18053.29.camel@twins>
	 <CAOMGZ=EC0eHahfHy2K=5HwBwOCWEdF6u-mDaeLhb4GQVKVxLLA@mail.gmail.com>
	 <1320682230.17809.11.camel@twins> <20111108025847.GB11439@zhy>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320739015.2244.0.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-08 at 10:58 +0800, Yong Zhang wrote:
> >  struct lockdep_map {
> > +     const char                      *name;
> >       struct lock_class_key           *key;
> >       struct lock_class               *class_cache[NR_LOCKDEP_CACHING_CLASSES];
> > -     const char                      *name;
> >  #ifdef CONFIG_LOCK_STAT
> >       int                             cpu;
> >       unsigned long                   ip;
> > diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> > index e69434b..81855cf 100644
> > --- a/kernel/lockdep.c
> > +++ b/kernel/lockdep.c
> > @@ -2948,7 +2948,8 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
> >  void lockdep_init_map(struct lockdep_map *lock, const char *name,
> >                     struct lock_class_key *key, int subclass)
> >  {
> > -     memset(lock, 0, sizeof(*lock));
> > +     kmemcheck_mark_initialized(lock, 2*sizeof(void *));
> > +     memset(&lock->class_cache[0], 0, sizeof(*lock)-2*sizeof(void *));
> 
> That means ->key have chance to be 0 at some time, right? 

How? We only memset from class_cache onwards, leaving name and key
untouched.
