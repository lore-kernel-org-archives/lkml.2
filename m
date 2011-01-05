Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab1AEVPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 16:15:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864Ab1AEVPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 16:15:47 -0500
Date: Wed, 5 Jan 2011 16:14:44 -0500
From: Jason Baron <jbaron@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: peterz@infradead.org, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
        rostedt@goodmis.org, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] jump label: introduce static_branch()
Message-ID: <20110105211444.GD2896@redhat.com>
References: <cover.1294239591.git.jbaron@redhat.com> <2d8c38bd7ca93e162aedb8e7acfc8bdb96d85de2.1294239591.git.jbaron@redhat.com> <20110105171516.GB1692@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110105171516.GB1692@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 06:15:18PM +0100, Frederic Weisbecker wrote:
> On Wed, Jan 05, 2011 at 10:43:12AM -0500, Jason Baron wrote:
> > diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
> > index 152f7de..0ad9c2e 100644
> > --- a/include/linux/jump_label.h
> > +++ b/include/linux/jump_label.h
> > @@ -22,6 +22,11 @@ struct module;
> >  
> >  #ifdef HAVE_JUMP_LABEL
> >  
> > +static __always_inline bool static_branch(struct jump_label_key *key)
> > +{
> > +	return __static_branch(key);
> 
> Not very important, but __static_branch() would be more self-explained
> if it was called arch_static_branch().
> 
> > +}
> > +
> >  extern struct jump_entry __start___jump_table[];
> >  extern struct jump_entry __stop___jump_table[];
> >  
> > @@ -42,11 +47,12 @@ struct jump_label_key {
> >  	int state;
> >  };
> >  
> > -#define JUMP_LABEL(key, label)			\
> > -do {						\
> > -	if (unlikely(((struct jump_label_key *)key)->state))		\
> > -		goto label;			\
> > -} while (0)
> > +static __always_inline bool static_branch(struct jump_label_key *key)
> > +{
> > +	if (unlikely(key->state))
> > +		return true;
> > +	return false;
> > +}
> >  
> >  static inline int jump_label_enabled(struct jump_label_key *key)
> >  {
> > @@ -78,14 +84,4 @@ static inline void jump_label_unlock(void) {}
> >  
> >  #endif
> >  
> > -#define COND_STMT(key, stmt)					\
> > -do {								\
> > -	__label__ jl_enabled;					\
> > -	JUMP_LABEL_ELSE_ATOMIC_READ(key, jl_enabled);		\
> > -	if (0) {						\
> > -jl_enabled:							\
> > -		stmt;						\
> > -	}							\
> > -} while (0)
> > -
> >  #endif
> > diff --git a/include/linux/jump_label_ref.h b/include/linux/jump_label_ref.h
> > index 8a76e89..5178696 100644
> > --- a/include/linux/jump_label_ref.h
> > +++ b/include/linux/jump_label_ref.h
> > @@ -7,19 +7,23 @@
> >  struct jump_label_key_counter {
> >  	atomic_t ref;
> >  	struct jump_label_key key;
> > -}
> > +};
> >  
> >  #ifdef HAVE_JUMP_LABEL
> >  
> > -#define JUMP_LABEL_ELSE_ATOMIC_READ(key, label, counter) JUMP_LABEL(key, label)
> > +static __always_inline bool static_branch_else_atomic_read(struct jump_label_key *key, atomic_t *count)
> > +{
> > +	return __static_branch(key);
> > +}
> 
> How about having only static_branch() but the key would be handled only
> by ways of get()/put().
> 
> Simple boolean key enablement would work in this scheme as well as branches
> based on refcount. So that the users could avoid maintaining both key and count,
> this would be transparently handled by the jump label API.
> 
> Or am I missing something?
> 

right. this is a good point. I had a 'jump_label_inc()',
'jump_label_dec()' essentially providing this. However, when jump labels
are disabled we didn't want to incur an atomic_read() everywhere.
Furthermore, the use of the atomic_t type within jump_label.h, causes
#include dependencies problems, since atomic.h ends up including
jump_label.h...

Thus, what I've proposed here, is to the have the very simple
jump_label_enable()/disable(), and leave reference counting to the
caller.

thanks,

-Jason
