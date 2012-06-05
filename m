Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761346Ab2FECdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 22:33:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31431 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757656Ab2FECdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 22:33:20 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=kQhizq87umwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VwQbUJbxAAAA:8 a=3qcsbkVXvIztR7fdD_QA:9 a=PUjeQqilurYA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=dqwK4W77FH9SKdUB:21 a=WUXEr15yQlhUexkX:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338863597.13348.532.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] powerpc/ftrace: Do not trace restore_interrupts()
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        stable@vger.kernel.org
Date: Mon, 04 Jun 2012 22:33:17 -0400
In-Reply-To: <1338863274.13348.530.camel@gandalf.stny.rr.com>
References: <1338863274.13348.530.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 22:27 -0400, Steven Rostedt wrote:
> As I was adding code that affects all archs, I started testing function
> tracer against PPC64 and found that it currently locks up with 3.4
> kernel. I figured it was due to tracing a function that shouldn't be, so
> I went through the following process to bisect to find the culprit:
> 
>  cat /debug/tracing/available_filter_functions > t
>  num=`wc -l t`
>  sed -ne "1,${num}p" t > t1
>  let num=num+1
>  sed -ne "${num},$p" t > t2
>  cat t1 > /debug/tracing/set_ftrace_filter
>  echo function /debug/tracing/current_tracer
>  <failed? bisect t1, if not bisect t2>
> 
> It finally came down to this function: restore_interrupts()
> 
> I'm not sure why this locks up the system. It just seems to prevent
> scheduling from occurring. Interrupts seem to still work, as I can ping
> the box. But all user processes freeze.
> 
> When restore_interrupts() is not traced, function tracing works fine.
> 
> Cc: stable@kernel.org

This is what I get for cut-and-pasting from a random git commit. That
should be:

Cc: stable@vger.kernel.org

-- Steve

> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
> index 641da9e..64eec59 100644
> --- a/arch/powerpc/kernel/irq.c
> +++ b/arch/powerpc/kernel/irq.c
> @@ -277,7 +277,7 @@ EXPORT_SYMBOL(arch_local_irq_restore);
>   * NOTE: This is called with interrupts hard disabled but not marked
>   * as such in paca->irq_happened, so we need to resync this.
>   */
> -void restore_interrupts(void)
> +void notrace restore_interrupts(void)
>  {
>  	if (irqs_disabled()) {
>  		local_paca->irq_happened |= PACA_IRQ_HARD_DIS;
> 


