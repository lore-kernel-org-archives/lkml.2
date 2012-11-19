Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab2KSSZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 13:25:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24148 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab2KSSZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 13:25:03 -0500
X-Authority-Analysis: v=2.0 cv=EshQXFgA c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Wu0uEauASpgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=gAuBvx7K2IcA:10 a=wwHIiQH4v5X_0wXo_rYA:9 a=PUjeQqilurYA:10 a=oecteszsiUWkFZaQ:21 a=UG-qWlhjwG-6bD6z:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1353349500.6276.9.camel@gandalf.local.home>
Subject: Re: [PATCH] arch_check_bp_in_kernelspace: fix the range check
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Amnon Shiloh <u3557@miso.sublimeip.com>, linux-kernel@vger.kernel.org
Date: Mon, 19 Nov 2012 13:25:00 -0500
In-Reply-To: <20121119174728.GA11365@redhat.com>
References: <20121109182943.GA2789@redhat.com>
	 <20121109183026.GA2719@redhat.com> <20121119174728.GA11365@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-19 at 18:47 +0100, Oleg Nesterov wrote:
> On 11/09, Oleg Nesterov wrote:
> >
> > On 11/09, Oleg Nesterov wrote:
> > >
> > > Note: TASK_SIZE doesn't look right at least on x86, I think it should
> > > be replaced by TASK_SIZE_MAX.
> > > ...
> > > --- x/arch/x86/kernel/hw_breakpoint.c
> > > +++ x/arch/x86/kernel/hw_breakpoint.c
> > > @@ -200,7 +200,7 @@ int arch_check_bp_in_kernelspace(struct
> > >  	va = info->address;
> > >  	len = get_hbp_len(info->len);
> > >
> > > -	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
> > > +	return (va >= TASK_SIZE) || ((va + len - 1) >= TASK_SIZE);
> >
> > But actully I'd like to ask another question.
> >
> > Can't we add the additional !in_gate_area_no_mm() check to allow
> > the hw breakpoints in vsyscall?
> >
> > Quoting Amnon:
> >
> > 	My service needs to catch the system-calls of its traced son.
> > 	Almost all system-calls are caught with PTRACE_SYSCALL, but not those
> > 	using the vsyscall page - especially "gettimeofday()" and "time()".
> >
> > 	...
> >
> > 	However, the code in "arch/x86/kernel/ptrace.c" forbids catching kernel
> > 	addresses.
> >
> > I tend to agree with Amnon...
> >
> > What do you think?
> 
> ping ;)
> 
> I agree the patch I sent is very minor (although it looks like the trivial
> bugfix to me).
> 
> Just I think Amnon has a point, shouldn't we change this change like below?
> (on top of this fixlet).
> 
> Oleg.
> 
> --- x/arch/x86/kernel/hw_breakpoint.c
> +++ x/arch/x86/kernel/hw_breakpoint.c
> @@ -188,6 +188,11 @@ static int get_hbp_len(u8 hbp_len)
>  	return len_in_bytes;
>  }
>  
> +static inline bool bp_in_gate(unsigned long start, unsigned long end)
> +{
> +	return in_gate_area_no_mm(start) && in_gate_area_no_mm(end);
> +}
> +
>  /*
>   * Check for virtual address in kernel space.
>   */
> @@ -200,7 +205,8 @@ int arch_check_bp_in_kernelspace(struct 
>  	va = info->address;
>  	len = get_hbp_len(info->len);
>  
> -	return (va >= TASK_SIZE) || ((va + len - 1) >= TASK_SIZE);
> +	return ((va >= TASK_SIZE) || ((va + len - 1) >= TASK_SIZE)) &&
> +		!bp_in_gate(va, va + len - 1);

So we want to allow non privileged to add a breakpoint in a vsyscall
area even if it happens to lay in kernel space?

Is this really what we want? I mean, isn't syscall tracing in the kernel
done by a flag set to the task's structure. If the task has a flag set,
then it does the slow (ptrace) path which handles the breakpoint for the
user.

But here, there's no prejudice between tasks. All tasks will now hit the
breakpoint regardless of if it is being traced or not.

-- Steve


>  }
>  
>  int arch_bp_generic_fields(int x86_len, int x86_type,


