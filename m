Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341Ab1LIQen (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 11:34:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65389 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab1LIQem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 11:34:42 -0500
X-Authority-Analysis: v=2.0 cv=Z6Nu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=gD6wIu1_qO8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=OuxOXVFEkB8nHXOm0_YA:9 a=AfP_9zIVLT-n_2nyaFUA:7 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [RFC][PATCH 3/3] x86: Add workaround to NMI iret woes
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Paul Turner <pjt@google.com>
In-Reply-To: <1323398616.30977.167.camel@frodo>
References: <20111208193003.112037550@goodmis.org>
	 <20111208193136.366941904@goodmis.org>  <1323373012.30977.123.camel@frodo>
	 <1323398616.30977.167.camel@frodo>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Dec 2011 11:34:38 -0500
Message-ID: <1323448478.1937.26.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-08 at 21:43 -0500, Steven Rostedt wrote:

> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index a8e3eb8..906a02a 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -723,4 +723,9 @@ void __init trap_init(void)
>  	cpu_init();
>  
>  	x86_init.irqs.trap_init();
> +
> +#ifdef CONFIG_X86_64
> +	memcpy(&nmi_idt_table, &idt_table, IDT_ENTRIES * 16);
> +	set_nmi_gate(1, &debug);

Frederic Weisbecker told me on IRC that int3 is 3 #bp, not 1 #db. I need
to also add that:

	set_nmi_gate(3, &int3)

Mathieu says we need to worry about MCEs, so maybe we can add that stack
as well.

	set_nmi_gate(18, &machine_check);


If we make NMIs not modify any stack, then we can remove the "NMI
executing variable" on the stack. As any nested NMIs will see that it
preempted an NMI by just checking the stack. We have to check it anyway,
and by removing another check, this may be good to do.

-- Steve

> +#endif
>  }
> 


