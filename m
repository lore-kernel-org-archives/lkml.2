Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab2FNICe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:02:34 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64024 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab2FNIC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:02:29 -0400
Message-ID: <4FD99A91.9040801@linaro.org>
Date: Thu, 14 Jun 2012 09:02:25 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        grant.likely@secretlab.ca, Alessandro Zummo <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, stable@vger.kernel.org
Subject: Re: [PATCH 01/14] rtc: ab8500-rtc: IRQF_ONESHOT when requesting a
 threaded IRQ
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org> <1339428307-3850-2-git-send-email-lee.jones@linaro.org> <201206111531.20468.arnd@arndb.de> <4FD70481.6020207@linaro.org> <20120613152558.e6025b04.akpm@linux-foundation.org> <4FD98F69.3010302@linaro.org> <20120614003006.68d77b37.akpm@linux-foundation.org>
In-Reply-To: <20120614003006.68d77b37.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/06/12 08:30, Andrew Morton wrote:
> On Thu, 14 Jun 2012 08:14:49 +0100 Lee Jones<lee.jones@linaro.org>  wrote:
> 
>> On 13/06/12 23:25, Andrew Morton wrote:
>>> On Tue, 12 Jun 2012 09:57:37 +0100
>>> Lee Jones<lee.jones@linaro.org>   wrote:
>>>
>>>> The kernel now forces IRQs to be ONESHOT if no IRQ handler is passed.
>>>
>>> What does this mean.  The kernel crashes?  The registration fails?  A
>>> warning is emitted?
>>>
>>> When fixing a bug, please fully describe the consequences of that bug.
>>>
>>>> Cc: stable@vger.kernel.org
>>>
>>> Especially when suggesting a -stable backport.
>>
>> No problem. I'll try to remember that for next time.
>>
>> I see that you've taken the patch into your tree however. So do you want
>> me to update the commit log and resubmit, or are you going to 'let this
>> one slide'?
> 
> Please read my emails - they're very nice!  "What does this mean.  The
> kernel crashes?  The registration fails?  A warning is emitted?".  You
> answer that, I copy-n-paste into changelog and we're done.

Ah, you're a star!

Registration fails:

> __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
> {
<snip>
> 	if (new->flags & IRQF_ONESHOT) {
<snip>
> 	} else if (new->handler == irq_default_primary_handler) {
> 		/*
> 		 * The interrupt was requested with handler = NULL, so
> 		 * we use the default primary handler for it. But it
> 		 * does not have the oneshot flag set. In combination
> 		 * with level interrupts this is deadly, because the
> 		 * default primary handler just wakes the thread, then
> 		 * the irq lines is reenabled, but the device still
> 		 * has the level irq asserted. Rinse and repeat....
> 		 *
> 		 * While this works for edge type interrupts, we play
> 		 * it safe and reject unconditionally because we can't
> 		 * say for sure which type this interrupt really
> 		 * has. The type flags are unreliable as the
> 		 * underlying chip implementation can override them.
> 		 */
> 		pr_err("Threaded irq requested with handler=NULL and !ONESHOT for irq %d\n", irq);
> 		ret = -EINVAL;
> 		goto out_mask;
> 	}
<snip>

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515 
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
