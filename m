Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab1CGTZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 14:25:45 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:38849 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754317Ab1CGTZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 14:25:44 -0500
Message-ID: <4D75317F.2090501@metafoo.de>
Date: Mon, 07 Mar 2011 20:26:55 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Bill Gatliff <bgat@billgatliff.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PWM v6 1/3] PWM: Implement a generic PWM framework
References: <1299385050-13674-1-git-send-email-bgat@billgatliff.com>	<1299385050-13674-2-git-send-email-bgat@billgatliff.com>	<4D7326B0.6050706@metafoo.de>	<4D732B25.2010708@metafoo.de> <AANLkTinJM4YNL-H-QKtsqTWwRksK=__KUCgY5wDP-c+E@mail.gmail.com>
In-Reply-To: <AANLkTinJM4YNL-H-QKtsqTWwRksK=__KUCgY5wDP-c+E@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2011 05:28 PM, Bill Gatliff wrote:
> Lars:
> 
> On Sun, Mar 6, 2011 at 12:35 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>> On 03/06/2011 07:16 AM, Lars-Peter Clausen wrote:
>>> On 03/06/2011 05:17 AM, Bill Gatliff wrote:
>>>> +
>>>> +
>>>> +pwm_set_handler() -- Defines an end-of-period callback.  The indicated
>>>> +function will be invoked in a worker thread at the end of each PWM
>>>> +period, and can subsequently invoke pwm_config(), etc.  Must be used
>>>> +with extreme care for high-speed PWM outputs.  Set the handler
>>>> +function to NULL to un-set the handler.
>>>> +
>>
>> This looks like a poor man's IRQ handler implementation. In my opinion something
>> like pwm_to_irq would be better suited interface.
> 
> Not sure what you mean here.  Can you elaborate?
> 
> 
> b.g.

I was thinking about an interface similar to gpio_to_irq. So you could map a
PWM device to a IRQ number and use the existing the existing genirq framework
to manage the callback handler.

The hardware will quite likely inform the software about when the period has
ended through an interrupt.
So what you basically will end up doing in almost every PWM device driver
implementation is to call pwm_handler() from its interrupt handler.

I for example have a SoC with an PWM unit where at least for some channels an
IRQ number from the main interrupt controller is directly mapped to PWM
channel. In such an case I could simply return the IRQ number directly instead
of implementing a IRQ handler which does nothing but calls pwm_handler().
For other case where the IRQ is muxed onto multiple PWM device you can use an
irq_chip.

I think there are still some problems with your current callback handler
implementation that could prove to be racy. Also each driver has to keep track
whether the handler should be invoked or not.
All these problems should go away with a genirq based implementation.

Maybe I'm on the wrong track here though. Could you explain what your expected
use case is for this part of the API? For example what would a driver using a
PWM device normally be doing in the handler it passed to the PWM device?

Oh and another thing, will it be mandatory for a PWM driver to provide callback
functionality and what if the underlying hardware does not support it?

- Lars
