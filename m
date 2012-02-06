Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab2BFKl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 05:41:26 -0500
Received: from smtp-out-106.synserver.de ([212.40.185.106]:1035 "EHLO
	smtp-out-106.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab2BFKlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 05:41:25 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 23040
Message-ID: <4F2FAE93.5020205@metafoo.de>
Date: Mon, 06 Feb 2012 11:42:27 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: =?UTF-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] genirq: Race condition in ONESHOT IRQ handler disabling
 IRQ forever
References: <20271.35831.227679.177366@ipc1.ka-ro>
In-Reply-To: <20271.35831.227679.177366@ipc1.ka-ro>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2012 09:14 AM, =?utf-8?Q?Lothar_Wa=C3=9Fmann?= wrote:
> Hi,
> 
> I already sent this to <linux-kernel@vger.kernel.org> on Feb. 1, 2012
> but did not get any response there. So resending to a wider audience
> with improved subject line:
> 
> there is a race condition in the threaded IRQ handler code for oneshot
> interrupts that may lead to disabling an IRQ indefinitely. IRQs are
> masked before calling the hard-irq handler and are unmasked only after
> the soft-irq handler has been run. Thus if the hard-irq handler
> returns IRQ_HANDLED instead of IRQ_WAKE_THREAD, meaning the soft-irq
> will not be called, the interrupt will remain masked forever.
> 
> This can happen due to a short pulse on the interrupt line, that
> triggers the interrupt logic, but goes undetected by the hard-irq
> handler. The problem can be reproduced with the TSC2007 touch
> controller driver that uses ONESHOT interrupts.
> 
> The problem arises also with interrupt controllers that latch a level
> triggered IRQ until it is acknowledged (like the i.MX28 does).
> In this case the IRQ status bit will remain asserted after the
> soft-irq finishes and retrigger the interrupt while the interrupt line
> is already deasserted.
> 
> The following patch would solve the problem, but I'm not sure whether
> it's the Right Thing(TM) to do. Especially wrt. shared interrupts.
> 
> diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
> index 470d08c..93beadb 100644
> --- a/kernel/irq/handle.c
> +++ b/kernel/irq/handle.c
> @@ -146,6 +146,11 @@ handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
>  			/* Fall through to add to randomness */
>  		case IRQ_HANDLED:
>  			random |= action->flags;
> +			/* unmask the IRQ that has been left masked
> +			 * due to race condition
> +			 */
> +			if (res == IRQ_HANDLED && (action->flags & IRQF_ONESHOT))
> +				unmask_irq(desc);
>  			break;
>  
>  		default:

I think a better fix is to check the return value of handle_irq_event in
handle_level_irq and if the IRQ_WAKE_THREADED bit is not set unmask the irq.

The same should probably also be done for handle_fasteoi_irq.

