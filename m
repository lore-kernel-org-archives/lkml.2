Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab1KHIOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 03:14:43 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:54662 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab1KHIOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 03:14:42 -0500
Date: Tue, 8 Nov 2011 16:14:33 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org,
        sergey.senozhatsky@gmail.com, bp@alien8.de,
        Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>, casteyde.christian@free.fr
Subject: Re: [PATCH 1/4] lockdep: lock_set_subclass() fix
Message-ID: <20111108081433.GA3746@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1320398790-21663-1-git-send-email-yong.zhang0@gmail.com>
 <1320398790-21663-2-git-send-email-yong.zhang0@gmail.com>
 <1320669279.18053.29.camel@twins>
 <CAOMGZ=EC0eHahfHy2K=5HwBwOCWEdF6u-mDaeLhb4GQVKVxLLA@mail.gmail.com>
 <1320682230.17809.11.camel@twins>
 <20111108025847.GB11439@zhy>
 <1320739015.2244.0.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1320739015.2244.0.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 08:56:55AM +0100, Peter Zijlstra wrote:
> On Tue, 2011-11-08 at 10:58 +0800, Yong Zhang wrote:
> > >  struct lockdep_map {
> > > +     const char                      *name;
> > >       struct lock_class_key           *key;
> > >       struct lock_class               *class_cache[NR_LOCKDEP_CACHING_CLASSES];
> > > -     const char                      *name;
> > >  #ifdef CONFIG_LOCK_STAT
> > >       int                             cpu;
> > >       unsigned long                   ip;
> > > diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> > > index e69434b..81855cf 100644
> > > --- a/kernel/lockdep.c
> > > +++ b/kernel/lockdep.c
> > > @@ -2948,7 +2948,8 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
> > >  void lockdep_init_map(struct lockdep_map *lock, const char *name,
> > >                     struct lock_class_key *key, int subclass)
> > >  {
> > > -     memset(lock, 0, sizeof(*lock));
> > > +     kmemcheck_mark_initialized(lock, 2*sizeof(void *));
> > > +     memset(&lock->class_cache[0], 0, sizeof(*lock)-2*sizeof(void *));
> > 
> > That means ->key have chance to be 0 at some time, right? 
> 
> How? We only memset from class_cache onwards, leaving name and key
> untouched.

Hmm, we don't touch key in your patch. My eyes was keeping on ->name.
Sorry.

But how do we deal with ->class_cache? Always set it in
loop_up_lock_class()?

Thanks,
Yong
