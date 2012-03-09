Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab2CIHe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 02:34:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53021 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099Ab2CIHeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 02:34:25 -0500
Date: Fri, 9 Mar 2012 08:33:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>, Josh Stone <jistone@redhat.com>
Subject: Re: [PATCH] uprobes/core: handle breakpoint and signal step
 exception.
Message-ID: <20120309073348.GA15570@elte.hu>
References: <20120223110245.12459.7391.sendpatchset@srdronam.in.ibm.com>
 <20120227091212.GA7092@elte.hu>
 <20120308131824.GC13284@linux.vnet.ibm.com>
 <20120308134809.GB28488@elte.hu>
 <20120309062853.GD13284@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120309062853.GD13284@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:

> * Ingo Molnar <mingo@elte.hu> [2012-03-08 14:48:09]:
> 
> > 
> > * Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:
> > 
> > > @@ -233,9 +233,11 @@ static inline void __user *arch_compat_alloc_user_space(long len)
> > >  
> > >  	if (test_thread_flag(TIF_IA32)) {
> > >  		sp = task_pt_regs(current)->sp;
> > > +#ifdef CONFIG_X86_64
> > >  	} else {
> > >  		/* -128 for the x32 ABI redzone */
> > >  		sp = __this_cpu_read(old_rsp) - 128;
> > > +#endif
> > >  	}
> > >  
> > >  	return (void __user *)round_down(sp - len, 16);
> > 
> > So 'sp' is undefined if that TIF check fails?
> > 
> > Also, on a 32-bit kernel the TIF check probably fails all the 
> > time, because we don't set TIF_IA32 (and don't know that flag).
> 
> > 
> > It would probably be better to make the whole helper inline 
> > #ifdef 64-bit, it does not look very useful on 32-bit.
> > 
> 
> arch_compat_alloc_user_space gets called from compat_alloc_user_space
> which is arch agnostic and exported too.
> 
> So I will change this to
> 
> void __user *arch_compat_alloc_user_space(long len)
> {
>   	if (is_ia32_compat_task(current))
>   		sp = task_pt_regs(current)->sp;
> #ifdef CONFIG_X86_64
>   	else
>   		/* -128 for the x32 ABI redzone */
>   		sp = __this_cpu_read(old_rsp) - 128;
> #endif
>   
>   	return (void __user *)round_down(sp - len, 16);
> }
> 
> where is_ia32_compat_task() is the new macro that you 
> suggested we put in compat.h which would return true if the 
> task is 32 bit emulated on x86_64 or running on i386 machine.
> 
> Hence we can avoid the case where sp is not set.

Ok - looks good at first glance.

Thanks,

	Ingo
