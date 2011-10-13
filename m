Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab1JMNz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 09:55:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755474Ab1JMNzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 09:55:25 -0400
Date: Thu, 13 Oct 2011 09:54:40 -0400
From: Jason Baron <jbaron@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH RFC V4 06/10] jump_label: add
 arch_jump_label_transform_static() to optimise non-live code updates
Message-ID: <20111013135439.GA2455@redhat.com>
References: <cover.1318464169.git.jeremy.fitzhardinge@citrix.com>
 <16f652166605c973e9817177b6ba6a081e3e5b3f.1318464413.git.jeremy.fitzhardinge@citrix.com>
 <1318501954.24856.5.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318501954.24856.5.camel@twins>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 12:32:34PM +0200, Peter Zijlstra wrote:
> On Wed, 2011-10-12 at 17:08 -0700, Jeremy Fitzhardinge wrote:
> > From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > 
> > When updating a newly loaded module, the code is definitely not yet
> > executing on any processor, so it can be updated with no need for any
> > heavyweight synchronization.
> > 
> > This patch adds arch_jump_label_static() which is implemented as
> > arch_jump_label_transform() by default, but architectures can override
> > it if it avoids, say, a call to stop_machine().
> > 
> > Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > Acked-by: Jason Baron <jbaron@redhat.com>
> > ---
> >  include/linux/jump_label.h |    2 ++
> >  kernel/jump_label.c        |   18 +++++++++++++++---
> >  2 files changed, 17 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
> > index 12e804e..56594e4 100644
> > --- a/include/linux/jump_label.h
> > +++ b/include/linux/jump_label.h
> > @@ -45,6 +45,8 @@ extern void jump_label_lock(void);
> >  extern void jump_label_unlock(void);
> >  extern void arch_jump_label_transform(struct jump_entry *entry,
> >  				      enum jump_label_type type);
> > +extern void arch_jump_label_transform_static(struct jump_entry *entry,
> > +					     enum jump_label_type type);
> >  extern int jump_label_text_reserved(void *start, void *end);
> >  extern void jump_label_inc(struct jump_label_key *key);
> >  extern void jump_label_dec(struct jump_label_key *key);
> > diff --git a/kernel/jump_label.c b/kernel/jump_label.c
> > index 059202d5..ff2028f 100644
> > --- a/kernel/jump_label.c
> > +++ b/kernel/jump_label.c
> > @@ -104,6 +104,18 @@ static int __jump_label_text_reserved(struct jump_entry *iter_start,
> >  	return 0;
> >  }
> >  
> > +/* 
> > + * Update code which is definitely not currently executing.
> > + * Architectures which need heavyweight synchronization to modify
> > + * running code can override this to make the non-live update case
> > + * cheaper.
> > + */
> > +void __weak arch_jump_label_transform_static(struct jump_entry *entry,
> > +					    enum jump_label_type type)
> > +{
> > +	arch_jump_label_transform(entry, type);	
> > +}
> > +
> >  static void __jump_label_update(struct jump_label_key *key,
> >  				struct jump_entry *entry,
> >  				struct jump_entry *stop, int enable)
> > @@ -135,8 +147,8 @@ static __init int jump_label_init(void)
> >  		struct jump_label_key *iterk;
> >  
> >  		iterk = (struct jump_label_key *)(unsigned long)iter->key;
> > -		arch_jump_label_transform(iter, jump_label_enabled(iterk) ?
> > -					  JUMP_LABEL_ENABLE : JUMP_LABEL_DISABLE);
> > +		arch_jump_label_transform_static(iter, jump_label_enabled(iterk) ?
> > +						 JUMP_LABEL_ENABLE : JUMP_LABEL_DISABLE);
> >  		if (iterk == key)
> >  			continue;
> >  
> > @@ -208,7 +220,7 @@ void jump_label_apply_nops(struct module *mod)
> >  		return;
> >  
> >  	for (iter = iter_start; iter < iter_stop; iter++)
> > -		arch_jump_label_transform(iter, JUMP_LABEL_DISABLE);
> > +		arch_jump_label_transform_static(iter, JUMP_LABEL_DISABLE);
> >  }
> >  
> 
> So I got myself a little confused wrt the early jump_label_apply_nops()
> call and the MODULE_COMING notifiers.
> 
> It looks to me like jump_label_apply_nops() is called way early and is
> in fact called before _any_ of the module code has had a chance of
> running. However it simply NOPs out all jump_labels.
> 

yes.

> The jump_label_add_module() thing, which is ran on the MODULE_COMING
> callback will then set up stuff and do the proper patch-up.
> 

yes, only for the enabled ones.

> Now the only bit of the module text that can be ran between those two
> calls appears to be the module argument parsing stuff, but since
> jump_labels are non-functional it can't rely on them, so why do we do
> the early patch up again?
> 
> 

The 'early patch' is for putting in the 'ideal' no-ops into the module
code. These 'ideal' no-ops are discovered at run-time, not boot-time.

The code is optimized (hopefully) for the most common case. The
jump labels are by nature expected to be off, and by patching them early
like this, at least for x86, we can avoid the stop machine calls. So its
the combination of most are expected to be off and no sense to call extra
stop machines that lead the code to its present state.

Thanks,

-Jason
