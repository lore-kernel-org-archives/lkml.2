Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab1LIPUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 10:20:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34231 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab1LIPUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 10:20:36 -0500
X-Authority-Analysis: v=2.0 cv=FIuZNpUs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=gD6wIu1_qO8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=DKMjefQI8IyOm-eevEIA:9 a=pXNr_5M2yGUkTFahz_EA:7 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
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
Date: Fri, 09 Dec 2011 10:20:34 -0500
Message-ID: <1323444034.1937.20.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-08 at 21:43 -0500, Steven Rostedt wrote:

> diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
> index b9c8628..d35f554 100644
> --- a/arch/x86/kernel/nmi.c
> +++ b/arch/x86/kernel/nmi.c
> @@ -407,13 +407,29 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
>  dotraplinkage notrace __kprobes void
>  do_nmi(struct pt_regs *regs, long error_code)
>  {
> +	int update_debug_stack = 0;
> +
>  	nmi_enter();
>  
> +	/*
> +	 * If we interrupted a breakpoint, it is possible that
> +	 * the nmi handler will have breakpoints too. We need to
> +	 * change the IDT such that breakpoints that happen here
> +	 * continue to use the NMI stack.
> +	 */
> +	if (unlikely(is_debug_stack(regs->sp))) {

For kicks, I made the update happen every NMI, but also changed the IDT
entry of the NMI to also not change the stack. Then I was able to move a
lot of the hacks from assembly into C code, just before the nmi_enter()
above. It seems it can work too. I didn't finish it, I just wanted to
see if it was doable. But I'm not sure we want to change the IDT (twice)
for all NMIs.

-- Steve


> +		zero_debug_stack();
> +		update_debug_stack = 1;
> +	}
> +	
>  	inc_irq_stat(__nmi_count);
>  
>  	if (!ignore_nmis)
>  		default_do_nmi(regs);
>  
> +	if (unlikely(update_debug_stack))
> +		reset_debug_stack();
> +
>  	nmi_exit();
>  }


