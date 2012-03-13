Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab2CMFUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 01:20:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49907 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413Ab2CMFUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 01:20:43 -0400
Date: Tue, 13 Mar 2012 06:20:16 +0100
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
Message-ID: <20120313052016.GA27824@elte.hu>
References: <20120223110245.12459.7391.sendpatchset@srdronam.in.ibm.com>
 <20120227091212.GA7092@elte.hu>
 <20120308131824.GC13284@linux.vnet.ibm.com>
 <20120308134809.GB28488@elte.hu>
 <20120309062853.GD13284@linux.vnet.ibm.com>
 <20120309073348.GA15570@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120309073348.GA15570@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:
> 
> > * Ingo Molnar <mingo@elte.hu> [2012-03-08 14:48:09]:
> > 
> > > 
> > > * Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:
> > > 
> > > > @@ -233,9 +233,11 @@ static inline void __user *arch_compat_alloc_user_space(long len)
> > > >  
> > > >  	if (test_thread_flag(TIF_IA32)) {
> > > >  		sp = task_pt_regs(current)->sp;
> > > > +#ifdef CONFIG_X86_64
> > > >  	} else {
> > > >  		/* -128 for the x32 ABI redzone */
> > > >  		sp = __this_cpu_read(old_rsp) - 128;
> > > > +#endif
> > > >  	}
> > > >  
> > > >  	return (void __user *)round_down(sp - len, 16);
> > > 
> > > So 'sp' is undefined if that TIF check fails?
> > > 
> > > Also, on a 32-bit kernel the TIF check probably fails all the 
> > > time, because we don't set TIF_IA32 (and don't know that flag).
> > 
> > > 
> > > It would probably be better to make the whole helper inline 
> > > #ifdef 64-bit, it does not look very useful on 32-bit.
> > > 
> > 
> > arch_compat_alloc_user_space gets called from compat_alloc_user_space
> > which is arch agnostic and exported too.
> > 
> > So I will change this to
> > 
> > void __user *arch_compat_alloc_user_space(long len)
> > {
> >   	if (is_ia32_compat_task(current))
> >   		sp = task_pt_regs(current)->sp;
> > #ifdef CONFIG_X86_64
> >   	else
> >   		/* -128 for the x32 ABI redzone */
> >   		sp = __this_cpu_read(old_rsp) - 128;
> > #endif
> >   
> >   	return (void __user *)round_down(sp - len, 16);
> > }
> > 
> > where is_ia32_compat_task() is the new macro that you 
> > suggested we put in compat.h which would return true if the 
> > task is 32 bit emulated on x86_64 or running on i386 machine.
> > 
> > Hence we can avoid the case where sp is not set.
> 
> Ok - looks good at first glance.

It does not look good on a second glance though, once I checked 
your latest patches.

arch_compat_alloc_user_space() is arch agnostic on 
*CONFIG_COMPAT=y* kernels.

It's generally not available on 32-bit builds - CONFIG_COMPAT is 
a facility to provide 32-bit syscall compatibility on 64-bit 
kernels. Such a facility is not needed on 32-bit kernels.

So providing this:

> void __user *arch_compat_alloc_user_space(long len)
> {
>	if (is_ia32_compat_task(current))
>               sp = task_pt_regs(current)->sp;

on 32-bit systems makes little sense.

So ... instead of adding is_compat_task() to compat.h it would 
be better to add it to another x86 header (processor.h might be 
good but I have not checked very hard) and maybe name it 
is_32bit_task() or so, to make sure there's no confusion with 
CONFIG_COMPAT=y methods.

I.e. you could drop this patch altogether:

  x86/trivial: Fix 'old_rsp' undefined build failure when including asm/compat.h

And rework the is_ia32_compat_task() patch to use another header 
and to use the is_32bit_task() name. Also, you should double 
check whether the x32 execution model needs special 
consideration as well:

 #define TIF_IA32		17	/* IA32 compatibility process */
 #define TIF_X32		30	/* 32-bit native x86-64 binary */

otherwise uprobe will not work with x32 tasks properly.

Thanks,

	Ingo
