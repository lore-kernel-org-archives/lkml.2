Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab1EPQQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 12:16:21 -0400
Received: from lunge.queued.net ([66.23.231.200]:48738 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756537Ab1EPQQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 12:16:20 -0400
X-Greylist: delayed 531 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 May 2011 12:16:20 EDT
Date: Mon, 16 May 2011 09:07:18 -0700
From: Andres Salomon <dilinger@queued.net>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Daniel Drake <dsd@laptop.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/11] x86, olpc-xo1-sci: Add GPE handler and ebook
 switch functionality
Message-ID: <20110516090718.66b5368a@debxo>
In-Reply-To: <20110516090813.GA26487@linutronix.de>
References: <1304166750-31125-1-git-send-email-dsd@laptop.org>
	<1304166750-31125-8-git-send-email-dsd@laptop.org>
	<20110516090813.GA26487@linutronix.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 May 2011 11:08:13 +0200
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> * Daniel Drake | 2011-04-30 13:32:26 [+0100]:
> 
> >diff --git a/arch/x86/platform/olpc/olpc-xo1-sci.c
> >b/arch/x86/platform/olpc/olpc-xo1-sci.c index 8fbf961..9de2a00 100644
> >--- a/arch/x86/platform/olpc/olpc-xo1-sci.c
> >+++ b/arch/x86/platform/olpc/olpc-xo1-sci.c
> >@@ -104,6 +177,37 @@ static int __devinit setup_sci_interrupt(struct
> >platform_device *pdev)
> > 	return r;
> > }
> > 
> >+static int __devinit setup_ec_sci(void)
> >+{
> >+	int r;
> >+
> >+	r = gpio_request(OLPC_GPIO_ECSCI, "OLPC-ECSCI");
> >+	if (r)
> >+		return r;
> >+
> >+	gpio_direction_input(OLPC_GPIO_ECSCI);
> >+
> >+	/* Clear pending EC SCI events */
> >+	cs5535_gpio_set(OLPC_GPIO_ECSCI, GPIO_NEGATIVE_EDGE_STS);
> >+	cs5535_gpio_set(OLPC_GPIO_ECSCI, GPIO_POSITIVE_EDGE_STS);
> 
> why not use the gpio framework here, i.e. gpio_set_value()?

The gpio framework is designed to work with toggling GPIO lines.
To deal with that, the cs5535 gpio driver (when toggling a GPIO line)
would set or clear CS5535_OUTPUT_VAL.  The cs5535 hardware, however,
can have a whole range of values set per a single GPIO line; amongst
these, positive and negative edge status.  Most users of the cs5535
GPIOs don't care about that, but those that do (like this SCI driver)
must use the custom cs5535 GPIO functions to set/clear it.

> 
> >+
> >+	/* Enable EC SCI events */
> >+	cs5535_gpio_set(OLPC_GPIO_ECSCI, GPIO_EVENTS_ENABLE);
> >+
> >+	/* Set the SCI to cause a PME event on group 7 */
> >+	cs5535_gpio_setup_event(OLPC_GPIO_ECSCI, 7, 1);
> >+
> >+	/* And have group 7 also fire the SCI interrupt */
> >+	cs5535_gpio_set_irq(7, sci_irq);
> 
> What do you do here? Could this be hidden behind a gpio irq_chip or is
> this too olpc specific?
> 
> Sebastian

