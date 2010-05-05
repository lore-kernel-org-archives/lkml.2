Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934907Ab0EEOb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 10:31:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33507 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934196Ab0EEObZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 10:31:25 -0400
X-Authority-Analysis: v=1.1 cv=Sj+DEJq9TvmrEz0yYf786F+83+V8ZKDvY/KsKt+Cs/8= c=1 sm=0 a=YcwJHCUm4PYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=iqwmNQvO6rCrzDBlu6YA:9 a=6bEIuhDOUQBfQdbtd8Ybj8yi63MA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: Tracing of power:power_start events doesn't work
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ronny =?ISO-8859-1?Q?Tsch=FCter?= <Ronny.Tschueter@tu-dresden.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4BE17C90.2020205@tu-dresden.de>
References: <4BDECD66.2010906@tu-dresden.de>
	 <1273019517.22438.10.camel@gandalf.stny.rr.com>
	 <4BE17C90.2020205@tu-dresden.de>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 05 May 2010 10:31:21 -0400
Message-ID: <1273069881.22438.17.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-05 at 16:11 +0200, Ronny Tschüter wrote:

>   /*
>    * Include the apic definitions for x86 to have the APIC timer related 
> defines
> @@ -796,6 +797,18 @@ static int acpi_idle_bm_check(void)
>    */
>   static inline void acpi_idle_do_entry(struct acpi_processor_cx *cx)
>   {
> +    switch (cx->type) {
> +    case ACPI_STATE_C1:
> +        trace_power_start(POWER_CSTATE, 1);
> +        break;
> +    case ACPI_STATE_C2:
> +        trace_power_start(POWER_CSTATE, 2);
> +        break;
> +    case ACPI_STATE_C3:
> +        trace_power_start(POWER_CSTATE, 3);
> +        break;
> +    }
> +

Depending on gcc, the above can bloat the code since each call to
trace_power_start() is a macro expanded. Try to call it just once.
Perhaps one of the following:


	trace_power_start(POWER_CSTATE,
		cx->type == ACPI_STATE_C1 ? 1 :
		cx->type == ACPI_STATE_C2 ? 2 :
		3);

Or make a local variable instead, although the above would compile out
completely if tracing is not enabled.


	int type:

	switch (cx->type) {
	case ACPI_STATE_C1:
		type = 1;
		break;
	case ACPI_STATE_C2:
		type = 2;
		break;
	case ACPI_STATE_C3:
		type = 3;
		break;
	}
	trace_power_start(POWER_CSTATE, type);

-- Steve

>       /* Don't trace irqs off for idle */
>       stop_critical_timings();
>       if (cx->entry_method == ACPI_CSTATE_FFH) {
> 


