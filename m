Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761664Ab2J3BL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 21:11:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:65457 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755746Ab2J3BL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 21:11:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,675,1344236400"; 
   d="scan'208";a="240059211"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
CC: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] x86/ioapic: Fix the vector_irq[] is corrupted randomly
Thread-Topic: [PATCH] x86/ioapic: Fix the vector_irq[] is corrupted randomly
Thread-Index: AQHNthMCR3b6FfBCd0iln70bxTFINZfRCIQg
Date: Tue, 30 Oct 2012 01:11:53 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A1B78F3@SHSMSX101.ccr.corp.intel.com>
References: <1351527341.15558.1445.camel@cliu38-desktop-build>
 <1351542245.12459.39.camel@sbsiddha-desk.sc.intel.com>
In-Reply-To: <1351542245.12459.39.camel@sbsiddha-desk.sc.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9U1CJge010080



> -----Original Message-----
> From: Siddha, Suresh B
> Sent: Tuesday, October 30, 2012 4:24 AM
> To: Liu, Chuansheng
> Cc: mingo@redhat.com; hpa@zytor.com; tglx@linutronix.de;
> yinghai@kernel.org; x86@kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] x86/ioapic: Fix the vector_irq[] is corrupted randomly
> 
> On Tue, 2012-10-30 at 00:15 +0800, Chuansheng Liu wrote:
> > Not all irq chips are IO-APIC chip.
> >
> > In our system, there are many demux GPIO interrupts except for the
> > io-apic chip interrupts, and these GPIO interrupts are belonged
> > to other irq chips, the chip data is not type of struct irq_cfg
> > either.
> >
> > But in function __setup_vector_irq(), it listed all allocated irqs,
> > and presume all irq chip is ioapic_chip and the chip data is type
> > of struct irq_cfg, it possibly causes the vector_irq is corrupted
> > randomly.
> >
> > For example, one irq 258 is not io-apic chip irq, in __setup_vector_irq(),
> > the chip data is forced to be used as struct irq_cfg, then the value
> > cfg->domain and cfg->vector are wrong to be used to write vector_irq:
> > 		vector = cfg->vector;
> > 		per_cpu(vector_irq, cpu)[vector] = irq;
> >
> > This patch use the .flags to identify if the irq chip is io-apic.
> 
> I have a feeling that your gpio driver is abusing the 'chip_data' in the
> struct irq_data. Shouldn't the driver be using 'handler_data' instead?
Not abusing.

There are many driver codes which has their own chip and chip_data.
For example,
langwell_gpio.c, the chip_data type is struct lnw_gpio;
gpio_omap.c, the chip_data type is struct gpio_bank;

In these cases, if we abused the gpio chip_data type with struct irq_cfg,
we will get very wrong cfg->vector, the value maybe 1 or 1000, anyway,
it is a random value.
> 
> From include/linux/irq.h:
>  * @handler_data:       per-IRQ data for the irq_chip methods
>  * @chip_data:          platform-specific per-chip private data for the chip
>  *                      methods, to allow shared chip implementations
> 
> Also, how are these routed to the processors and the mechanism of the
> vector assignment for these irq's? I presume irq_cfg is needed for the
> setup and the interrupt migration from one cpu to another.
Normally gpio chip just has only one base irq is related with io-apic interrupt,
other allocated *VIRTUAL* irqs are based on this base irq, so no vector assign to them.

But in code __setup_vector_irq(), it list all allocated irqs which include the *VIRTUAL* irqs,
It causes this case that chip_data type is abused.

> 
> What am I missing?
> 
> thanks,
> suresh

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
