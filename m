Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab2I1CZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 22:25:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35969 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754952Ab2I1CZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 22:25:32 -0400
Message-ID: <50650A7E.90807@zytor.com>
Date: Thu, 27 Sep 2012 19:25:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Seiji Aguchi <seiji.aguchi@hds.com>
CC: "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "x86@kernel.org" <x86@kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [PATCH v4] trace,x86: add x86 irq vector tracepoints
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41385F33C@USINDEM103.corp.hds.com> <50612729.2080307@zytor.com> <A5ED84D3BB3A384992CBB9C77DEDA4D41386426D@USINDEM103.corp.hds.com>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D41386426D@USINDEM103.corp.hds.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 03:33 PM, Seiji Aguchi wrote:
> Hi,
> 
>> ... except the cost can be reduced to zero *AND* be made into a more general mechanism by simply hooking the IDT.
> 
> Thank you for giving me the comment.
> In my understanding,  we can introduce a more general mechanism by sandwiching an existing handler between tracepoints.
> The pseudo code is like this:
> 
> @@ -17,7 +18,7 @@ static void default_threshold_interrupt(void)
>  
>  void (*mce_threshold_vector)(void) = default_threshold_interrupt;
>  
> -asmlinkage void smp_threshold_interrupt(void)
> +static void do_smp_threshold_interrupt(void)
>  {
>  	irq_enter();
>  	exit_idle();
> @@ -27,3 +28,10 @@ asmlinkage void smp_threshold_interrupt(void)
>  	/* Ack only at the end to avoid potential reentry */
>  	ack_APIC_irq();
>  }
> +
> +asmlinkage void smp_threshold_interrupt(void) {
> +	trace_arch_irq_vector_entry(THRESHOLD_APIC_VECTOR);
> +	do_smp_threshold_interrupt();
> +	trace_arch_irq_vector_exit(THRESHOLD_APIC_VECTOR);
> +}
> 
> If I misunderstand something, please let me know.
> 

Quite.

These functions are being invoked from the IDT, which is an indirect
pointer structure.  When not being traced, there is absolutely no reason
why it should go through a thunk with tracepoints.

	-hpa



