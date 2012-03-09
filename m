Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab2CIGbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 01:31:37 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:38255 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab2CIGbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 01:31:35 -0500
Date: Fri, 9 Mar 2012 11:58:53 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
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
Message-ID: <20120309062853.GD13284@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120223110245.12459.7391.sendpatchset@srdronam.in.ibm.com>
 <20120227091212.GA7092@elte.hu>
 <20120308131824.GC13284@linux.vnet.ibm.com>
 <20120308134809.GB28488@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120308134809.GB28488@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030906-1780-0000-0000-000003D50EF1
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000256; HX=3.00000185; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00120434; UDB=6.00029107; UTC=2012-03-09
 06:31:34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2012-03-08 14:48:09]:

> 
> * Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:
> 
> > @@ -233,9 +233,11 @@ static inline void __user *arch_compat_alloc_user_space(long len)
> >  
> >  	if (test_thread_flag(TIF_IA32)) {
> >  		sp = task_pt_regs(current)->sp;
> > +#ifdef CONFIG_X86_64
> >  	} else {
> >  		/* -128 for the x32 ABI redzone */
> >  		sp = __this_cpu_read(old_rsp) - 128;
> > +#endif
> >  	}
> >  
> >  	return (void __user *)round_down(sp - len, 16);
> 
> So 'sp' is undefined if that TIF check fails?
> 
> Also, on a 32-bit kernel the TIF check probably fails all the 
> time, because we don't set TIF_IA32 (and don't know that flag).

> 
> It would probably be better to make the whole helper inline 
> #ifdef 64-bit, it does not look very useful on 32-bit.
> 

arch_compat_alloc_user_space gets called from compat_alloc_user_space
which is arch agnostic and exported too.

So I will change this to

void __user *arch_compat_alloc_user_space(long len)
{
  	if (is_ia32_compat_task(current))
  		sp = task_pt_regs(current)->sp;
#ifdef CONFIG_X86_64
  	else
  		/* -128 for the x32 ABI redzone */
  		sp = __this_cpu_read(old_rsp) - 128;
#endif
  
  	return (void __user *)round_down(sp - len, 16);
}

where is_ia32_compat_task() is the new macro that you suggested we put
in compat.h which would return true if the task is 32 bit emulated on
x86_64 or running on i386 machine.

Hence we can avoid the case where sp is not set.

-- 
Thanks and Regards
Srikar

