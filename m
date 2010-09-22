Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab0IVTYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 15:24:40 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:64228 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001Ab0IVTYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 15:24:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEACf1mUxGGN6i/2dsb2JhbACiK3LFQ4VBBI8w
Date: Wed, 22 Sep 2010 15:19:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jason Baron <jbaron@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, rusty@rustcorp.co.au,
        rostedt@goodmis.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        hpa@zytor.com, tglx@linutronix.de, roland@redhat.com, rth@redhat.com,
        mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] Rewrite jump_label.c to use binary search
Message-ID: <20100922191936.GA28463@Krystal>
References: <1285150102-5506-1-git-send-email-andi@firstfloor.org> <1285150102-5506-2-git-send-email-andi@firstfloor.org> <20100922113114.GA14179@Krystal> <4a8f3ad8416ed61cba1746883da1f839.squirrel@www.firstfloor.org> <589c3dd38437c80704d8224523efbccc.squirrel@www.firstfloor.org> <20100922150250.GB4897@Krystal> <20100922152833.GD2816@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100922152833.GD2816@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 15:07:56 up 168 days,  4:58,  4 users,  load average: 0.06, 0.06,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
> On Wed, Sep 22, 2010 at 11:02:50AM -0400, Mathieu Desnoyers wrote:
> > * Andi Kleen (andi@firstfloor.org) wrote:
> > > 
> > > >
> > > >>> +	for (; entry < stop && entry->key == key; entry++)
> > > >>> +		if (kernel_text_address(entry->code))
> > > >>
> > > >> This does not work for modules I'm afraid, only for the core kernel. You
> > > >> should test for __module_text_address() somewhere.
> > > >
> > > > I thought it was shared now, but ok.
> > > 
> > > Double checked. This is ok because kernel_text_address()
> > > already checks for modules. You were probably thinking
> > > of __kernel_text_address()
> > 
> > Ah right,
> > 
> > Although we have another problem:
> > 
> > __module_text_address() includes module init text, which defeats the
> > purpose of the check put in there by Jason.
> > 
> > So the check works for the core kernel, but not for modules.
> > 
> > Mathieu
> > 
> 
> it works for modules too...it does:
> 
> struct module *__module_text_address(unsigned long addr)
> {
>         struct module *mod = __module_address(addr);
>         if (mod) {
>                 /* Make sure it's within the text section. */
>                 if (!within(addr, mod->module_init, mod->init_text_size)
>                     && !within(addr, mod->module_core,
> mod->core_text_size))
>                         mod = NULL;
>         }
>         return mod;
> }
> 
> and then in kernel/module.c we have :
> 
> 
>         module_free(mod, mod->module_init);
>         mod->module_init = NULL;
> 
> 
> So, I was relying on the fact module_init gets set to NULL after the
> free happens. However, there a small race there in that the vfree()
> happens before module_init() is set to NULL. So that is probably most
> easily fixed be wrapping those two lines with the jump_label_mutex.

It's both module_init = NULL _and_ init_text_size = 0 that make sure
the test "within(addr, mod->module_init, mod->init_text_size)" is valid.
Just the "module_init = NULL" can cause problems with addresses in the
low range of kernel addresses. With a long enough module init section,
the offset from NULL can end up (temporarily) in the kernel address
range.

But this is all wrong: __module_text_address is relying on
preempt_disable() to ensure coherency of this test is just racy, as you
point out above. So we either do the RCU synchronization properly, or
hold the module_mutex around the module text address test _and_ actual
access to the module init section.

Thanks,

Mathieu

> 
> thanks,
> 
> -Jason
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
