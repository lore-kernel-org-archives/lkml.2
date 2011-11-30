Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420Ab1K3CIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:08:23 -0500
Received: from mga14.intel.com ([143.182.124.37]:40183 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757072Ab1K3CIU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:08:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,595,1315206000"; 
   d="scan'208";a="80457913"
Date: Wed, 30 Nov 2011 10:08:24 +0800
From: Feng Tang <feng.tang@intel.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kwlee@mtekvision.com" <kwlee@mtekvision.com>,
        "Clark, Joel" <joel.clark@intel.com>
Subject: Re: [PATCH 1/2] Input: tsc2007 - Disable irq when the irq thread is
 handling data
Message-ID: <20111130100824.535c7e16@feng-i7>
In-Reply-To: <20111129092208.GA21758@core.coreip.homeip.net>
References: <1322554378-348-1-git-send-email-feng.tang@intel.com>
	<20111129092208.GA21758@core.coreip.homeip.net>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

Thanks for the review.

On Tue, 29 Nov 2011 17:22:08 +0800
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> Hi Feng,
> 
> On Tue, Nov 29, 2011 at 04:12:57PM +0800, Feng Tang wrote:
> > The TSC2007 data sheet say in some case the HW may fire some false
> > interrrupt, which I also met during integrating one TSC2007 device.
> > So add the disable_irq/enable_irq protection around data handling.
> 
> IRQF_ONESHOT should prevent IRQ from firing again while thread is
> servicing it. Did you actually observe it not working?

You are right, the tsc's threaded IRQ function is not re-entered, and
the driver is working actually. My bad not stating the problem clearly.
The real problem I want solve is, many platforms including ours use a
GPIO line as the tsc2007's IRQ line, and when these extra tsc2007 IRQ 
is triggered on the gpio line, that GPIO controller will fire up extra
noise IRQ accordingly, causing its ISR to be called. And my patch is
 trying to let the GPIO controller driver disable that specific IRQ pin
from tsc2007. As disable_irq will call GPIO irq_chip's irq_disable() or
mask() hook.

By grep the tsc2007_platform_data in kernel, I see most of the most of
the tsc2007 platforms are using GPIO line as tsc2007 IRQ ine. So this
should be a general problem.

Following is patch with updated log and comments.

Thanks,
Feng

-----------------

>From 16585020d27a066d2908959e370ea4f8905a0d34 Mon Sep 17 00:00:00 2001
From: Feng Tang <feng.tang@intel.com>
Date: Tue, 29 Nov 2011 15:48:42 +0800
Subject: [PATCH 1/2] Input: tsc2007 - Disable irq when the irq thread is handling data

The TSC2007 data sheet say in some case the HW may fire some false
interrrupt, which I also met during integrating one TSC2007 device.
Most of the tsc2007 platforms including ours are using a gpio line as
tsc2007's irq line, so calling disable_irq_nosync() to actually
prevent the gpio controller from firing IRQ for tsc2007 in such case.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 drivers/input/touchscreen/tsc2007.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/input/touchscreen/tsc2007.c b/drivers/input/touchscreen/tsc2007.c
index 1f674cb..03c1961 100644
--- a/drivers/input/touchscreen/tsc2007.c
+++ b/drivers/input/touchscreen/tsc2007.c
@@ -171,6 +171,18 @@ static irqreturn_t tsc2007_soft_irq(int irq, void *handle)
 	struct ts_event tc;
 	u32 rt;
 
+	/*
+	 * Disable the irq, as it may fire several other IRQs during
+	 * this thread is handling data, as suggested by the TSC2007
+	 * datasheet, p19, "Touch Detect" chapter.
+	 *
+	 * Most of the tsc2007 platforms are using a gpio line as
+	 * tsc2007's irq line, so calling disable_irq_nosync() will
+	 * actually prevent the gpio controller from firing IRQ for
+	 * this tsc2007 line in such case.
+	 */
+	disable_irq_nosync(irq);
+
 	while (!ts->stopped && tsc2007_is_pen_down(ts)) {
 
 		/* pen is down, continue with the measurement */
@@ -221,6 +233,7 @@ static irqreturn_t tsc2007_soft_irq(int irq, void *handle)
 	if (ts->clear_penirq)
 		ts->clear_penirq();
 
+	enable_irq(irq);
 	return IRQ_HANDLED;
 }
 
-- 
1.7.1
> 
> Thanks.
> 
> > 
> > Signed-off-by: Feng Tang <feng.tang@intel.com>
> > ---
> >  drivers/input/touchscreen/tsc2007.c |    8 ++++++++
> >  1 files changed, 8 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/input/touchscreen/tsc2007.c
> > b/drivers/input/touchscreen/tsc2007.c index 1f674cb..789f216 100644
> > --- a/drivers/input/touchscreen/tsc2007.c
> > +++ b/drivers/input/touchscreen/tsc2007.c
> > @@ -171,6 +171,13 @@ static irqreturn_t tsc2007_soft_irq(int irq,
> > void *handle) struct ts_event tc;
> >  	u32 rt;
> >  
> > +	/*
> > +	 * Disable the irq, as it may fire several other IRQs
> > during
> > +	 * this thread is handling data, as suggested by the
> > TSC2007
> > +	 * datasheet, p19, "Touch Detect" chapter
> > +	 */
> > +	disable_irq_nosync(irq);
> > +
> >  	while (!ts->stopped && tsc2007_is_pen_down(ts)) {
> >  
> >  		/* pen is down, continue with the measurement */
> > @@ -221,6 +228,7 @@ static irqreturn_t tsc2007_soft_irq(int irq,
> > void *handle) if (ts->clear_penirq)
> >  		ts->clear_penirq();
> >  
> > +	enable_irq(irq);
> >  	return IRQ_HANDLED;
> >  }
> >  
> > -- 
> > 1.7.1
> > 
> > 
> 
