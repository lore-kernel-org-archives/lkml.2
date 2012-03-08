Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab2CHNVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 08:21:01 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53175 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270Ab2CHNU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 08:20:59 -0500
Date: Thu, 8 Mar 2012 18:48:24 +0530
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
Message-ID: <20120308131824.GC13284@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120223110245.12459.7391.sendpatchset@srdronam.in.ibm.com>
 <20120227091212.GA7092@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120227091212.GA7092@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030813-7182-0000-0000-000000FE8251
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  
> >  #include <linux/kdebug.h>
> >  #include <asm/insn.h>
> >  
> > +#ifdef CONFIG_X86_32
> > +#define is_32bit_app(tsk) 1
> > +#else
> > +#define is_32bit_app(tsk) (test_tsk_thread_flag(tsk, TIF_IA32))
> > +#endif
> 
> Small detail, we prefer to use this variant:
> 
> #ifdef X
> # define foo()
> #else
> # define bar()
> #endif
> 
> to give the construct more visual structure.
> 
> Also, please put it into asm/compat.h and use it at other places 
> within arch/x86/ as well, there's half a dozen similar patterns 
> of TIP_IA32 tests in arch/x86/. Please make this a separate 
> patch, preceding this patch.

I am facing a problem doing the above.
I did some changes in arch/x86/kernel/signal.c and included compat.h 
and compilation fails on tip tree that the commit 
d1a797f388

In file included from ../arch/x86/kernel/signal.c:42:
../arch/x86/include/asm/compat.h: In function ‘arch_compat_alloc_user_space’:
../arch/x86/include/asm/compat.h:238: error: ‘old_rsp’ undeclared (first use in this function)
../arch/x86/include/asm/compat.h:238: error: (Each undeclared identifier is reported only once
../arch/x86/include/asm/compat.h:238: error: for each function it appears in.)
../arch/x86/include/asm/compat.h:238: warning: type defaults to ‘int’ in declaration of ‘pfo_ret__’            


I see old_rsp declared only under CONFIG_X86_64 in asm/processor.h 

The below helps resolve the problem.
---------
diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
index 9c9b6dc..147e790 100644
--- a/arch/x86/include/asm/compat.h
+++ b/arch/x86/include/asm/compat.h
@@ -233,9 +233,11 @@ static inline void __user *arch_compat_alloc_user_space(long len)
 
 	if (test_thread_flag(TIF_IA32)) {
 		sp = task_pt_regs(current)->sp;
+#ifdef CONFIG_X86_64
 	} else {
 		/* -128 for the x32 ABI redzone */
 		sp = __this_cpu_read(old_rsp) - 128;
+#endif
 	}
 
 	return (void __user *)round_down(sp - len, 16);


-----------

But I wanted to check if there is any reason why we cant include asm/compat.h in arch/x86/kernel/signal.c.

-- 
Thanks and Regards
Srikar

