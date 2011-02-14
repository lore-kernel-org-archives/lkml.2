Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab1BNLDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 06:03:47 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61192 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab1BNLDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 06:03:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FSZ/gafD51hbqYr9I3x0jit7nMdUWU059SvE4g4BSNRjGo5qJ6i57vbpMKA+SaqkCK
         nwhmqLu3tZ3aWq29oz6dd4QcjDUj0mEk5Q9uWAg5EpOJtUEljOiBQugMYTz01/CdHzXg
         kGHresaZAfUafp3W49++iZ21AIwnoEWcuexko=
Date: Mon, 14 Feb 2011 12:03:39 +0100
From: Tejun Heo <tj@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andy Walls <awalls@md.metrocast.net>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, stoth@kernellabs.com
Subject: Re: cx23885-input.c does in fact use a workqueue....
Message-ID: <20110214110339.GC18742@htj.dyndns.org>
References: <1297647322.19186.61.camel@localhost>
 <20110214043355.GA28090@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110214043355.GA28090@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Feb 13, 2011 at 08:33:55PM -0800, Dmitry Torokhov wrote:
> > The cx23885 driver does in fact schedule work for IR input handling:
> > 
> > Here's where it is scheduled for CX23888 chips:
> > 
> > http://git.linuxtv.org/media_tree.git?a=blob;f=drivers/media/video/cx23885/cx23885-ir.c;h=7125247dd25558678c823ee3262675570c9aa630;hb=HEAD#l76
> > 
> > Here's where it is scheduled for CX23885 chips:
> > 
> > http://git.linuxtv.org/media_tree.git?a=blob;f=drivers/media/video/cx23885/cx23885-core.c;h=359882419b7f588b7c698dbcfb6a39ddb1603301;hb=HEAD#l1861

Ah, sorry about missing those.

> > The two different chips are handled slightly differently because
> > 
> > a. the CX23888 IR unit is accessable via a PCI register block.  The IR
> > IRQ can be acknowledged with direct PCI register accesses in an
> > interrupt context, and the IR pulse FIFO serviced later in a workqueue
> > context.
> > 
> > b. the CX23885 IR unit is accessed over an I2C bus.  The CX23885 A/V IRQ
> > has to be masked in an interrupt context (with PCI registers accesses).
> > Then the CX23885 A/V unit's IR IRQ is ack'ed over I2C in a workqueue
> > context and the IR pulse FIFO is also serviced over I2C in a workqueue
> > context.
> > 
> > 
> > So what should be done about the flush_scheduled_work()?  I think it
> > belongs there.
> > 
> 
> Convert to using threaded irq?

Or

1. Just flush the work items explicitly using flush_work_sync().

2. Create a dedicated workqueue to serve as flushing domain.

The first would look like the following.  Does this look correct?

Thanks.

diff --git a/drivers/media/video/cx23885/cx23885-input.c b/drivers/media/video/cx23885/cx23885-input.c
index 199b996..e27cedb 100644
--- a/drivers/media/video/cx23885/cx23885-input.c
+++ b/drivers/media/video/cx23885/cx23885-input.c
@@ -229,6 +229,9 @@ static void cx23885_input_ir_stop(struct cx23885_dev *dev)
 		v4l2_subdev_call(dev->sd_ir, ir, rx_s_parameters, &params);
 		v4l2_subdev_call(dev->sd_ir, ir, rx_g_parameters, &params);
 	}
+	flush_work_sync(&dev->cx25840_work);
+	flush_work_sync(&dev->ir_rx_work);
+	flush_work_sync(&dev->ir_tx_work);
 }
 
 static void cx23885_input_ir_close(struct rc_dev *rc)

-- 
tejun
