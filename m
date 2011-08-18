Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab1HRPIF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 11:08:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46704 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755057Ab1HRPIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 11:08:02 -0400
Date: Thu, 18 Aug 2011 11:08:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Per Forlin <per.forlin@linaro.org>
cc: balbi@ti.com, Per Forlin <per.forlin@stericsson.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Michal Nazarewicz <mina86@mina86.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linaro-dev@lists.linaro.org>
Subject: Re: [PATCH v4] usb: gadget: storage_common: make FSG_NUM_BUFFERS
 variable size
In-Reply-To: <CAJ0pr197cyGDH8fr6dwNVx-vhKJqBqODskJOxQWo6uHHfdV3aA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1108181059420.1912-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Aug 2011, Per Forlin wrote:

> On 18 August 2011 13:14, Felipe Balbi <balbi@ti.com> wrote:
> > Hi,
> >
> > On Thu, Aug 18, 2011 at 11:28:46AM +0200, Per Forlin wrote:
> >> From: Per Forlin <per.forlin@linaro.org>
> >>
> >> FSG_NUM_BUFFERS is set to 2 as default.
> >> Usually 2 buffers are enough to establish a good buffering pipeline.
> >> The number may be increased in order to compensate a for bursty VFS
> >> behaviour.
> >>
> >> Here follows a description of system that may require more than
> >> 2 buffers.
> >>  * CPU ondemand governor active
> >>  * latency cost for wake up and/or frequency change
> >>  * DMA for IO
> >>
> >> Use case description.
> >>  * Data transfer from MMC via VFS to USB.
> >>  * DMA shuffles data from MMC and to USB.
> >>  * The CPU wakes up every now and then to pass data in and out from VFS,
> >>    which cause the bursty VFS behaviour.
> >>
> >> Test set up
> >>  * Running dd on the host reading from the mass storage device
> >>  * cmdline: dd if=/dev/sdb of=/dev/null bs=4k count=$((256*100))
> >>  * Caches are dropped on the host and on the device before each run
> >>
> >> Measurements on a Snowball board with ondemand_govenor active.
> >>
> >> FSG_NUM_BUFFERS 2
> >> 104857600 bytes (105 MB) copied, 5.62173 s, 18.7 MB/s
> >> 104857600 bytes (105 MB) copied, 5.61811 s, 18.7 MB/s
> >> 104857600 bytes (105 MB) copied, 5.57817 s, 18.8 MB/s
> >>
> >> FSG_NUM_BUFFERS 4
> >> 104857600 bytes (105 MB) copied, 5.26839 s, 19.9 MB/s
> >> 104857600 bytes (105 MB) copied, 5.2691 s, 19.9 MB/s
> >> 104857600 bytes (105 MB) copied, 5.2711 s, 19.9 MB/s
> >>
> >> There may not be one optimal number for all boards. This is why
> >> the number is added to Kconfig. If selecting USB_DEBUG this value may be
> >> set by a module parameter as well.
> >>
> >> Signed-off-by: Per Forlin <per.forlin@linaro.org>
> >
> > Alan, are you ok with the change ? I'm not sure tying the parameter to
> > CONFIG_USB_DEBUG is a good idea, maybe CONFIG_USB_GADGET_DEBUG or
> > CONFIG_USB_FILE_STORAGE_TEST is better ?
> >
> The reason for the module parameter is to enable runtime calibration
> of the optimal num_buffers. If the DEBUG-code adds
> overhead that affects the performance the calibration will be
> incorrect. I haven't measured the overhead of USB_DEBUG.

I'm basically okay with this, subject to issues that Michal brought up.  
I think the name of the module parameter should be num_buffers rather
than fsg_num_buffers (use module_param_named) -- the "fsg" prefix will
look odd when applied to the mass-storage gadget, and besides, since
it's a module parameter we already know what module it will be applied
to.  Also, the new module parameter should be documented in the
comments near the start of the source file.

Maybe USB_DEBUG isn't the best option for enabling the module 
parameter.  As far as I'm concerned, Per can change

	#ifdef CONFIG_USB_DEBUG

to

	#if 0	/* Change to #if 1 to enable testing of this parameter */

Editing the source file once and rebuilding it is not any harder than 
changing a Kconfig option and rebuilding the entire USB stack.

Alan Stern

