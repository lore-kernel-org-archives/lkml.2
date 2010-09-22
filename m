Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab0IVONQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 10:13:16 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:51048 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753102Ab0IVONP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 10:13:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEALqpmUxGGN6i/2dsb2JhbACiLnLDUoVBBI8w
Date: Wed, 22 Sep 2010 10:03:11 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, jbaron@redhat.com, rostedt@goodmis.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
        roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] Add for_each_module iterator function
Message-ID: <20100922140310.GA30730@Krystal>
References: <1285150102-5506-1-git-send-email-andi@firstfloor.org> <alpine.LFD.2.00.1009221424590.2416@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1009221424590.2416@localhost6.localdomain6>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:02:05 up 167 days, 23:52,  2 users,  load average: 0.12, 0.12,
	0.04
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner (tglx@linutronix.de) wrote:
> 
> 
> On Wed, 22 Sep 2010, Andi Kleen wrote:
> 
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > This is a generic function to iterate over all modules.
> > To be used in the next patch.
> > 
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > ---
> >  include/linux/module.h |    1 +
> >  kernel/module.c        |   10 ++++++++++
> >  2 files changed, 11 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/module.h b/include/linux/module.h
> > index 403ac26..809b6db 100644
> > --- a/include/linux/module.h
> > +++ b/include/linux/module.h
> > @@ -410,6 +410,7 @@ struct module *__module_address(unsigned long addr);
> >  bool is_module_address(unsigned long addr);
> >  bool is_module_percpu_address(unsigned long addr);
> >  bool is_module_text_address(unsigned long addr);
> > +void for_each_module(void (*op)(struct module *, void *arg), void *arg);
> >  
> >  static inline int within_module_core(unsigned long addr, struct module *mod)
> >  {
> > diff --git a/kernel/module.c b/kernel/module.c
> > index eba1341..b8fb3e6 100644
> > --- a/kernel/module.c
> > +++ b/kernel/module.c
> > @@ -384,6 +384,16 @@ struct module *find_module(const char *name)
> >  }
> >  EXPORT_SYMBOL_GPL(find_module);
> >  
> > +void for_each_module(void (*op)(struct module *, void *arg), void *arg)
> > +{
> > +	struct module *mod;
> > +
> > +	preempt_disable();
> 
>   That wants rcu_read_lock()

Then we might need to add synchronize_rcu() call when modules are
unloaded. For now, there is only synchronize_sched().

Mathieu

> 
> > +	list_for_each_entry_rcu(mod, &modules, list)
> > +		op(mod, arg);
> > +	preempt_enable();
> 
> Thanks,
> 
> 	tglx

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
