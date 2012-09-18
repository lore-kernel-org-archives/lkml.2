Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab2IREvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 00:51:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:58676 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466Ab2IREvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 00:51:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,441,1344236400"; 
   d="scan'208";a="193935112"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: anish singh <anish198519851985@gmail.com>
CC: "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: RE: [PATCH] genirq: Add the IRQS_ONESHOT support for edge interrupt
Thread-Topic: [PATCH] genirq: Add the IRQS_ONESHOT support for edge interrupt
Thread-Index: AQHNlVZ/4ADZPiUe1EW60mvngnup+5ePh4Tg
Date: Tue, 18 Sep 2012 04:51:19 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A181E13@SHSMSX101.ccr.corp.intel.com>
References: <1347972841.4312.2.camel@cliu38-desktop-build>
 <CAK7N6vqKp0Tcdr0CP4grq12C8-Oe05+uCEyos=mLMitwpet+Zw@mail.gmail.com>
In-Reply-To: <CAK7N6vqKp0Tcdr0CP4grq12C8-Oe05+uCEyos=mLMitwpet+Zw@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8I4pUpJ023971

> Just curios about the problem you are facing without this code?
The issue I meet is in my calling request_threaded_irq()[edge interrupt], even with IRQS_ONESHOT,
When irq thread is handling, the interrupt is still coming, and the primary handler is called,
It cause possible spin recursive locks if irq handler and irq thread use the same spin lock.

> -----Original Message-----
> From: anish singh [mailto:anish198519851985@gmail.com]
> Sent: Tuesday, September 18, 2012 12:31 PM
> To: Liu, Chuansheng
> Subject: Re: [PATCH] genirq: Add the IRQS_ONESHOT support for edge interrupt
> 
> On Tue, Sep 18, 2012 at 6:24 PM, Chuansheng Liu
> <chuansheng.liu@intel.com> wrote:
> > In handle_edge_irq(), currently do not care about the flag IRQS_ONESHOT,
> > but there are many edge interrupt handler with irq thread need it indeed,
> > so implement here.
> Just curios about the problem you are facing without this code?
> >
> > Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> > ---
> >  kernel/irq/chip.c |    8 +++++++-
> >  1 files changed, 7 insertions(+), 1 deletions(-)
> >
> > diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> > index eebd6d5..8e4e49a 100644
> > --- a/kernel/irq/chip.c
> > +++ b/kernel/irq/chip.c
> > @@ -497,7 +497,13 @@ handle_edge_irq(unsigned int irq, struct irq_desc
> *desc)
> >         kstat_incr_irqs_this_cpu(irq, desc);
> >
> >         /* Start handling the irq */
> > -       desc->irq_data.chip->irq_ack(&desc->irq_data);
> > +       if (desc->istate & IRQS_ONESHOT) {
> > +               mask_ack_irq(desc);
> > +               handle_irq_event(desc);
> > +               cond_unmask_irq();
> > +               goto out_unlock;
> > +       } else
> > +               desc->irq_data.chip->irq_ack(&desc->irq_data);
> >
> >         do {
> >                 if (unlikely(!desc->action)) {
> > --
> > 1.7.0.4
> >
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
