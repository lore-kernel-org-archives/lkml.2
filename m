Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab1LNX3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 18:29:12 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61244 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab1LNX3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 18:29:11 -0500
Message-ID: <4EE93142.9060904@gmail.com>
Date: Wed, 14 Dec 2011 17:29:06 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, shawn.guo@freescale.com,
        Kukjin Kim <kgene.kim@samsung.com>, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>, Barry Song <baohua.song@csr.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/9] irq: convert generic-chip to use irq_domain
References: <1323876538-20406-1-git-send-email-robherring2@gmail.com> <1323876538-20406-4-git-send-email-robherring2@gmail.com> <CACxGe6sqTx4h3vPgq+XrAoqLTiDMB-vcS5C9GgYssdsSYV_0qA@mail.gmail.com> <4EE913C7.1060901@gmail.com> <CACxGe6uTp_=G4ODqzJdOTou2gzAM9LX8xHtKkeL8Safq0+B2rw@mail.gmail.com>
In-Reply-To: <CACxGe6uTp_=G4ODqzJdOTou2gzAM9LX8xHtKkeL8Safq0+B2rw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 03:26 PM, Grant Likely wrote:
> On Wed, Dec 14, 2011 at 2:23 PM, Rob Herring <robherring2@gmail.com> wrote:
>>
>>
>> On 12/14/2011 03:14 PM, Grant Likely wrote:
>>> On Wed, Dec 14, 2011 at 8:28 AM, Rob Herring <robherring2@gmail.com> wrote:
>>>> From: Rob Herring <rob.herring@calxeda.com>
>>>>
>>>> Add irq domain support to irq generic-chip. This enables users of
>>>> generic-chip to support dynamic irq assignment needed for DT interrupt
>>>> binding. Users must be converted to use irq_data.hwirq for determining
>>>> local interrupt numbers rather than using the Linux irq number.
>>>>
>>>> irq_base is kept for now as there are a few users of it. Once they
>>>> are converted to use the irq domain, it can be removed.
>>>>
>>>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>>> ---
>>>>  include/linux/irq.h       |    2 +-
>>>>  kernel/irq/Kconfig        |    1 +
>>>>  kernel/irq/generic-chip.c |   57 ++++++++++++++++++++++++++++----------------
>>>>  3 files changed, 38 insertions(+), 22 deletions(-)
>>>>
>>>> diff --git a/include/linux/irq.h b/include/linux/irq.h
>>>> index bff29c5..9ba8a30 100644
>>>> --- a/include/linux/irq.h
>>>> +++ b/include/linux/irq.h
>>>> @@ -664,7 +664,7 @@ struct irq_chip_generic {
>>>>        raw_spinlock_t          lock;
>>>>        void __iomem            *reg_base;
>>>>        unsigned int            irq_base;
>>>> -       unsigned int            irq_cnt;
>>>> +       struct irq_domain       *domain;
>>>
>>> Instead of making domain a pointer, why not embed the structure inside
>>> irq_chip_generic?  I don't see a reason for keeping it separate.
>>>
>>
>> There is a circular header dependency between irq.h and irq_domain.h.
>> Maybe I just need to put the include of irq_domain.h just above here
>> rather than the top of the file.
> 
> Yes, try that.  I'd rather get the dependency problem sorted out.
> Alternately, problematic bit of irq_domain.h can be moved to another
> header.
> 
Things always start out so simple...

Removing irq.h from irqdomain.h fixes my original problem. However, that
breaks on x86 since x86 has it's own struct irq_domain. Some ifdef'ing
could fix it since x86 doesn't use irq_chip_generic. Didn't you have
converting x86 in your original irq domain patches?

Rob
