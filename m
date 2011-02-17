Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab1BQJ7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 04:59:12 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:50460 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754463Ab1BQJ7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 04:59:07 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Thomas Gleixner'" <tglx@linutronix.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Greg KH'" <greg@kroah.com>
References: <02f301cbcb48$bebea4c0$3c3bee40$@mprc.pku.edu.cn> <alpine.LFD.2.00.1102161018370.26192@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1102161018370.26192@localhost6.localdomain6>
Subject: RE: [PATCHv2 09/11] unicore32 core architecture: timer and time handling
Date: Thu, 17 Feb 2011 17:58:43 +0800
Message-ID: <006a01cbce89$4463e570$cd2bb050$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQH8AKscRheQ/HHApBgo+X/sOK9QJQEXJc2Qk5xStYA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Wednesday, February 16, 2011 5:21 PM
> To: Guan Xuetao
> Cc: linux-kernel@vger.kernel.org; linux-arch@vger.kernel.org; Arnd Bergmann; 'Greg KH'
> Subject: Re: [PATCHv2 09/11] unicore32 core architecture: timer and time handling
> 
> On Sun, 13 Feb 2011, Guan Xuetao wrote:
> > +static struct clock_event_device ckevt_puv3_osmr0 = {
> > +	.name		= "osmr0",
> > +	.features	= CLOCK_EVT_FEAT_ONESHOT,
> > +#ifdef CONFIG_ARCH_FPGA
> > +	.shift		= 18, /* correct shift val: 16, but warn_on_slowpath */
> > +#else
> > +	.shift          = 30,
> > +#endif
> 
> Please get rid of this.
> 
> > +void __init time_init(void)
> > +{
> > +	OST_OIER = 0;		/* disable any timer interrupts */
> > +	OST_OSSR = 0;		/* clear status on all timers */
> > +
> > +	ckevt_puv3_osmr0.mult =
> > +		div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC, ckevt_puv3_osmr0.shift);
> 
> And use clockevents_calc_mult_shift() instead of this.

That's  ok.
Please see following patch:

From: GuanXuetao <gxt@mprc.pku.edu.cn>
Date: Thu, 17 Feb 2011 17:50:43 +0800
Subject: [PATCH] unicore32: apply clockevents_calc_mult_shift()
   to get rid of shift assignment and mult calculation for osmr0
   -- by advice with Thomas Gleixner

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/kernel/time.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/unicore32/kernel/time.c b/arch/unicore32/kernel/time.c
index 8090d76..8bb4b81 100644
--- a/arch/unicore32/kernel/time.c
+++ b/arch/unicore32/kernel/time.c
@@ -66,11 +66,6 @@ puv3_osmr0_set_mode(enum clock_event_mode mode, struct clock_event_device *c)
 static struct clock_event_device ckevt_puv3_osmr0 = {
 	.name		= "osmr0",
 	.features	= CLOCK_EVT_FEAT_ONESHOT,
-#ifdef CONFIG_ARCH_FPGA
-	.shift		= 18, /* correct shift val: 16, but warn_on_slowpath */
-#else
-	.shift          = 30,
-#endif
 	.rating		= 200,
 	.set_next_event	= puv3_osmr0_set_next_event,
 	.set_mode	= puv3_osmr0_set_mode,
@@ -101,8 +96,8 @@ void __init time_init(void)
 	OST_OIER = 0;		/* disable any timer interrupts */
 	OST_OSSR = 0;		/* clear status on all timers */
 
-	ckevt_puv3_osmr0.mult =
-		div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC, ckevt_puv3_osmr0.shift);
+	clockevents_calc_mult_shift(&ckevt_puv3_osmr0, CLOCK_TICK_RATE, 5);
+
 	ckevt_puv3_osmr0.max_delta_ns =
 		clockevent_delta2ns(0x7fffffff, &ckevt_puv3_osmr0);
 	ckevt_puv3_osmr0.min_delta_ns =
-- 
1.6.2.2

> 
> Thanks,
> 
> 	tglx

Thanks Thomas.

Guan Xuetao

