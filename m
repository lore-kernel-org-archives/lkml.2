Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830Ab2EXR5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 13:57:45 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41322 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757651Ab2EXR5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 13:57:44 -0400
Date: Thu, 24 May 2012 13:57:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Joe Perches <joe@perches.com>
cc: Kay Sievers <kay@vrfy.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Jason Baron <jbaron@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Greg KH <greg@kroah.com>
Subject: Re: Excessive latency for dev_dbg?
In-Reply-To: <1337805903.1747.0.camel@joe2Laptop>
Message-ID: <Pine.LNX.4.44L0.1205241348300.1186-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012, Joe Perches wrote:

> cc'ing Kay.
> 
> On Wed, 2012-05-23 at 16:37 -0400, Alan Stern wrote:
> > I just tried doing some testing of 3.4.  Sequences of literally
> > adjacent dev_dbg() calls -- with local interrupts disabled -- show up
> > in the log buffer spaced at time intervals between 1 and 4
> > milliseconds!
> > 
> > This is with CONFIG_DYNAMIC_DEBUG not enabled, and CONFIG_PRINTK_TIME,
> > CONFIG_PREEMPT, CONFIG_HIGH_RES_TIMERS, and CONFIG_HPET_TIMER all set
> > to y.
> > 
> > What's going on here?  Did printk suddenly slow down a lot?  Or has the
> > timer code gone crazy?

Okay, I did a little more directed testing.  It turns out the same
thing happens with a 3.3 kernel, so I can't even call it a regression.  
And it's not directly related to dev_dbg, because the same thing 
happens with dev_info.  But it does look peculiar.

Here's the test patch:


--- usb-3.4.orig/drivers/usb/gadget/dummy_hcd.c
+++ usb-3.4/drivers/usb/gadget/dummy_hcd.c
@@ -997,6 +997,19 @@ static int dummy_udc_probe(struct platfo
 	if (rc < 0)
 		goto err_dev;
 	platform_set_drvdata(pdev, dum);
+
+	spin_lock_irq(&dum->lock);
+	dev_info(&pdev->dev, "dev_info 1\n");
+	dev_info(&pdev->dev, "dev_info 2\n");
+	dev_info(&pdev->dev, "dev_info 3\n");
+	dev_dbg(&pdev->dev, "dev_dbg 1\n");
+	dev_dbg(&pdev->dev, "dev_dbg 2\n");
+	dev_dbg(&pdev->dev, "dev_dbg 3\n");
+	printk(KERN_INFO "printk 1\n");
+	printk(KERN_INFO "printk 2\n");
+	printk(KERN_INFO "printk 3\n");
+	spin_unlock_irq(&dum->lock);
+
 	return rc;
 
 err_dev:


Here's the output under 3.3 (note: UP machine but with CONFIG_SMP 
enabled):

[  102.784488] dummy_udc dummy_udc: dev_info 1
[  102.786776] dummy_udc dummy_udc: dev_info 2
[  102.788054] dummy_udc dummy_udc: dev_info 3
[  102.788054] dummy_udc dummy_udc: dev_dbg 1
[  102.788054] dummy_udc dummy_udc: dev_dbg 2
[  102.788054] dummy_udc dummy_udc: dev_dbg 3
[  102.788054] printk 1
[  102.788054] printk 2
[  102.788054] printk 3

And here's the output under 3.4:

[  166.521453] dummy_udc dummy_udc: dev_info 1
[  166.524026] dummy_udc dummy_udc: dev_info 2
[  166.524026] dummy_udc dummy_udc: dev_info 3
[  166.524026] dummy_udc dummy_udc: dev_dbg 1
[  166.524026] dummy_udc dummy_udc: dev_dbg 2
[  166.524026] dummy_udc dummy_udc: dev_dbg 3
[  166.524026] printk 1
[  166.524026] printk 2
[  166.524026] printk 3

In fact, 3.4 looks slightly better than 3.3, in that there's no
measurable delay between the "dev_info 2" and "dev_info 3" lines.

But what's going on with the first two dev_info lines?  A 2.6 ms delay 
during which nothing happens?  Or incorrect timestamps?

.config files are available upon request.

Alan Stern

