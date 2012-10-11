Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab2JKCrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:47:11 -0400
Received: from us-mx3.synaptics.com ([12.239.217.85]:44798 "EHLO
	us-mx3.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab2JKCrF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:47:05 -0400
X-PGP-Universal: processed;
	by securemail.synaptics.com on Wed, 10 Oct 2012 19:14:09 -0700
From: Christopher Heiny <Cheiny@synaptics.com>
To: Joe Perches <joe@perches.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>
Subject: RE: [RFC PATCH 02/06] input/rmi4: Core files
Thread-Topic: [RFC PATCH 02/06] input/rmi4: Core files
Thread-Index: AQHNo3hsaE1c+pCGsk+IENeTeYD9uJesqCEAgAbGfFQ=
Date: Thu, 11 Oct 2012 02:49:02 +0000
Message-ID: <BFABBC009FBA1C43B207B15FD485ABD922C22B7B@USW-MAIL1.synaptics-inc.local>
References: <1349496603-20775-1-git-send-email-cheiny@synaptics.com>
	 <1349496603-20775-3-git-send-email-cheiny@synaptics.com>,<1349525982.2008.86.camel@joe-AO722>
In-Reply-To: <1349525982.2008.86.camel@joe-AO722>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.10.35]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Fri, 2012-10-05 at 21:09 -0700, Christopher Heiny wrote:
> []
> 
> Just some trivial comments:

Thanks - see below for responses.

> > diff --git a/drivers/input/rmi4/rmi_driver.c
> > b/drivers/input/rmi4/rmi_driver.c
> []
> 
> > @@ -0,0 +1,1529 @@
> 
> []
> 
> > +static ssize_t delay_write(struct file *filp, const char __user *buffer,
> > +                        size_t size, loff_t *offset) {
> > +     struct driver_debugfs_data *data = filp->private_data;
> > +     struct rmi_device_platform_data *pdata =
> > +                     data->rmi_dev->phys->dev->platform_data;
> > +     int retval;
> > +     char local_buf[size];
> > +     unsigned int new_read_delay;
> > +     unsigned int new_write_delay;
> > +     unsigned int new_block_delay;
> > +     unsigned int new_pre_delay;
> > +     unsigned int new_post_delay;
> > +
> > +     retval = copy_from_user(local_buf, buffer, size);
> > +     if (retval)
> > +             return -EFAULT;
> > +
> > +     retval = sscanf(local_buf, "%u %u %u %u %u", &new_read_delay,
> > +                     &new_write_delay, &new_block_delay,
> > +                     &new_pre_delay, &new_post_delay);
> > +     if (retval != 5) {
> > +             dev_err(&data->rmi_dev->dev,
> > +                     "Incorrect number of values provided for delay.");
> > +             return -EINVAL;
> > +     }
> > +     if (new_read_delay < 0) {
> 
> These are unnecessary tests as unsigned values are never < 0.

Right.  Thought we'd taken care of most of the silliness like that, but obviously missed some.  We'll recheck the codebase.

[snip]


> > +static ssize_t phys_read(struct file *filp, char __user *buffer, size_t
> > size, +                 loff_t *offset) {
> > +     struct driver_debugfs_data *data = filp->private_data;
> > +     struct rmi_phys_info *info = &data->rmi_dev->phys->info;
> > +     int retval;
> > +     char local_buf[size];
> 
> size comes from where?  possible stack overflow?

Hmmmm.  Good point.  We'll look at this.

[snip]

> []
> 
> > +     list_for_each_entry(entry, &data->rmi_functions.list, list)
> > +             if (entry->irq_mask)
> > +                     process_one_interrupt(entry, irq_status,
> > +                                           data);
> 
> style nit, it'd be nicer with braces.

I agree with you, but checkpatch.pl doesn't. :-(

> 
> > diff --git a/drivers/input/rmi4/rmi_driver.h
> > b/drivers/input/rmi4/rmi_driver.h
> []
> 
> > @@ -0,0 +1,438 @@
> > 
> > +
> > +#define tricat(x, y, z) tricat_(x, y, z)
> > +
> > +#define tricat_(x, y, z) x##y##z
> 
> I think these tricat macros are merely obfuscating
> and don't need to be used.

tricat is used internally by another collection of macros that helps generate sysfs files.  In particular, it's used to generate the RMI4 register name symbols.