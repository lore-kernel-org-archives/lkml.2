Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab1LBATV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 19:19:21 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43377 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744Ab1LBATU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 19:19:20 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 2 Dec 2011 09:18:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH] jump_label: jump_label for boot options.
Message-Id: <20111202091805.7c74d0a4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1322750927.30977.25.camel@frodo>
References: <20111201115353.563f79fc.kamezawa.hiroyu@jp.fujitsu.com>
	<1322750927.30977.25.camel@frodo>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Dec 2011 09:48:47 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 2011-12-01 at 11:53 +0900, KAMEZAWA Hiroyuki wrote:
> > I tried to use jump_label for handling memcg's boot options which sets
> > global variable true/false and never changes after boot. And found jump_table
> > is larger than expected. This patch is a trial to allow to place jump_table
> > in .init section. How do you think ?
> > 
> > This patch is based on linux-next.
> > 
> > ==
> > >From ed8996892c21d4fec642e4fc80bd3ebdd8a48836 Mon Sep 17 00:00:00 2001
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Date: Thu, 1 Dec 2011 11:08:23 +0900
> > Subject: [PATCH] jump_label for boot options.
> > 
> > Some boot options exists for enable/disable a functionality which cannot be modified
> > after boot. Using jump_label for such behavior seems atractive but if caller
> > of statch_branch() is too much, jump_table can be unexpectedly big.
> 
> s/statch/static/
> 
will fix.

> > 
> > This patch adds static_branch_init_once(), which places its jump_table
> > in init section and never be updated after boot.
> 
> I don't like the name static_branch_init_once(). Although I suck at
> picking names myself :-p  Maybe just remove the 'init'.
> static_branch_once(), or remove the 'once'. static_branch_init()
> 

ok.

> Your name may be the best, but I'm hoping another name will come up.
> static_branch_init_once() just doesn't seem right.
> 
I don't think my sense of naming is good.

> 
> > For MODULES, using usual static_branch().
> 
> Why not for modules? It can be forced at module load time, and then
> removed.
> 

It can be. I just don't investigate how module's init section is handled.

<snip>


> > +/*
> > + * Use this when you call static_branch() in __init function or
> > + * jump_label is only modified by initcalls. jump_label information
> > + * will be discarded after boot. But please be careful. jump_label_key
> > + * definition itself should *not* be in __init section because a MODULE
> > + * may call static_branch_init_once().
> > + *
> > + * Useful for changing behavior by boot option.
> > + */
> > +#ifndef MODULE
> > +static __always_inline bool static_branch_init_once(struct jump_label_key *key)
> > +{
> > +	return arch_static_branch_init_once(key);
> > +}
> > +#else
> > +static __always_inline bool static_branch_init_once(struct jump_label_key *key)
> > +{
> > +	return static_branch(key);
> > +}
> > +#endif
> 
> I still think modules should be able to do this, and then just remove it
> later.
> 

Hm, ok, I'll look into and prepare an another patch.


> > +
> >  extern struct jump_entry __start___jump_table[];
> >  extern struct jump_entry __stop___jump_table[];
> > +extern struct jump_entry __start___jump_table_at_init[];
> > +extern struct jump_entry __stop___jump_table_at_init[];
> >  
> >  extern void jump_label_init(void);
> >  extern void jump_label_lock(void);
> > @@ -54,6 +77,12 @@ extern void jump_label_dec(struct jump_label_key *key);
> >  extern bool jump_label_enabled(struct jump_label_key *key);
> >  extern void jump_label_apply_nops(struct module *mod);
> >  
> > +/*
> > + * For jump_label in init section.
> > + * This will call jump_label_inc() for usual section, too.
> > + */
> > +extern void jump_label_inc_once(struct jump_label_key *key);
> > +
> >  #else  /* !HAVE_JUMP_LABEL */
> >  
> >  #include <linux/atomic.h>
> > @@ -75,6 +104,11 @@ static __always_inline bool static_branch(struct jump_label_key *key)
> >  	return false;
> >  }
> >  
> > +static __always_inline bool static_branch_init_once(struct jump_label_key *key)
> > +{
> > +	return static_branch(key);
> > +}
> > +
> >  static inline void jump_label_inc(struct jump_label_key *key)
> >  {
> >  	atomic_inc(&key->enabled);
> > @@ -102,6 +136,11 @@ static inline int jump_label_apply_nops(struct module *mod)
> >  {
> >  	return 0;
> >  }
> > +
> > +static inline void jump_label_inc_once(struct jump_label_key *key)
> > +{
> > +	jump_label_inc(key);
> > +}
> >  #endif	/* HAVE_JUMP_LABEL */
> >  
> >  #endif	/* _LINUX_JUMP_LABEL_H */
> > diff --git a/kernel/jump_label.c b/kernel/jump_label.c
> > index 66ff710..f0e8231 100644
> > --- a/kernel/jump_label.c
> > +++ b/kernel/jump_label.c
> > @@ -134,15 +134,11 @@ static void __jump_label_update(struct jump_label_key *key,
> >  	}
> >  }
> >  
> > -void __init jump_label_init(void)
> > +void __init jump_label_transform_all(struct jump_entry *iter_start,
> > +				     struct jump_entry *iter_stop)
> >  {
> > -	struct jump_entry *iter_start = __start___jump_table;
> > -	struct jump_entry *iter_stop = __stop___jump_table;
> > -	struct jump_label_key *key = NULL;
> >  	struct jump_entry *iter;
> > -
> > -	jump_label_lock();
> > -	jump_label_sort_entries(iter_start, iter_stop);
> > +	struct jump_label_key *key = NULL;
> >  
> >  	for (iter = iter_start; iter < iter_stop; iter++) {
> >  		struct jump_label_key *iterk;
> > @@ -159,6 +155,24 @@ void __init jump_label_init(void)
> >  		key->next = NULL;
> >  #endif
> >  	}
> > +
> > +}
> > +
> > +
> > +void __init jump_label_init(void)
> > +{
> > +	struct jump_entry *iter_start = __start___jump_table;
> > +	struct jump_entry *iter_stop = __stop___jump_table;
> > +
> > +
> > +	jump_label_lock();
> > +	jump_label_sort_entries(iter_start, iter_stop);
> > +	jump_label_transform_all(iter_start, iter_stop);
> 
> Nit, I'd add a space here.
> 

ok. I'll fix.

Thanks,
-Kame


