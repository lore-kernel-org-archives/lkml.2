Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab0I1AZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 20:25:27 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46643 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab0I1AZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 20:25:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=JMF+xQBP3tLtClN+ULo/cUMBt9m6JsgQdoF3/ntCmh+t6+eHPi4iEqJcLfCy6AJabn
         zNIAsJt917tycQ0QCCwiSCEoXy5o9qvpj8ergUuEENClPzVBuyaWzSjxOrWA/osOvFTd
         SYGR0vHGTzoLd33+PnOPrk8KbFoOhrQQugh98=
MIME-Version: 1.0
In-Reply-To: <20100927154809.GI2560@sortiz-mobl>
References: <1285120171-3030-1-git-send-email-tom.leiming@gmail.com>
	<20100927154809.GI2560@sortiz-mobl>
Date: Tue, 28 Sep 2010 08:25:24 +0800
Message-ID: <AANLkTikjGD32hPhwPhZfETZX9H+--_SduTtqgyuqY_72@mail.gmail.com>
Subject: Re: [PATCH] mfd: speedup twl4030 irq response time and decrease irq
 disable time
From: Ming Lei <tom.leiming@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-omap@vger.kernel.org, Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Balaji T K <balajitk@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

     Thanks for your comment.

2010/9/27 Samuel Ortiz <sameo@linux.intel.com>:
> Hi Tom,
>
> On Wed, Sep 22, 2010 at 09:49:31AM +0800, tom.leiming@gmail.com wrote:
>> From: Ming Lei <tom.leiming@gmail.com>
>>
>> This patch sets scheduler policy of twl4030 irq thread
>> (twl4030_irq_thread) as SCHED_FIFO to speedup irq response
>> time, just like taken by kernel threaded irq in irq_thread
>> (kernel/irq/manage.c). Also higher priority than that of
>> threaded irq is taken to avoid preemption from twl4030
>> subchips's threaded irq handler, so pih irq disable time may
>> be decreased.
> Wouldn't converting your twl4030_irq_thread() to the threaded IRQ framework
> fix that problem ?

IRQ_DISABLED flag is set by disable_irq_nosync called from PIH handler,
then thread function can't be executed in irq thread function, so we can't
convert this to threaded IRQ framework simply.

>
>> The pih irq is disabled in handle_twl4030_pih which may
>> wakeup twl4030 irq thread, and the pih irq will be enabled
>> again until complete of all sih irqs' handling in twl4030
>> irq thread.
>>
>> Also for each one interrupt line of twl4030 subchip, only
>> two irq events can be buffered by twl4030(4.4.2.3 of TPS65950 TRM).
> Could you explain how is that related to the patch below ?

We need to decrease PIH irq disable time as far as possible to
make twl4030 subchip happy, or else some irqs may be lost, right?

This patch will decrease PIH irq disable time:

        - set schedule policy of twl4030_irq_thread as SCHED_FIFO, so
it will get running timeslice quicker than before

       - set priority of  twl4030_irq_thread higher than irq_thread of
subchips to prevent it from being preempted by subchips' irq thread.


-- 
Lei Ming
