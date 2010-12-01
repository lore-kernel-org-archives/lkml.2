Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab0LAEIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 23:08:40 -0500
Received: from kroah.org ([198.145.64.141]:47027 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753Ab0LAEIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 23:08:39 -0500
Date: Tue, 30 Nov 2010 20:06:28 -0800
From: Greg KH <greg@kroah.com>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] staging: ft1000: Use misc device instead self
 created device.
Message-ID: <20101201040628.GA5672@kroah.com>
References: <1290515373-16145-1-git-send-email-marek.belisko@open-nandra.com>
 <1290515373-16145-3-git-send-email-marek.belisko@open-nandra.com>
 <4CEBC751.6090906@gmail.com>
 <AANLkTimWb1KxhUph+bCELJ1nshnTScB1sU+hb=9CTceb@mail.gmail.com>
 <4CEC3211.7050503@gmail.com>
 <AANLkTin6Am=17wyMZJRu9bYk5-QTYqZhGtZqV_sDwJW4@mail.gmail.com>
 <20101129194414.GB14086@kroah.com>
 <AANLkTi=3Ut-fsLGAQ8MjZus4Q0U4weqsLXeOtjwOrHVJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=3Ut-fsLGAQ8MjZus4Q0U4weqsLXeOtjwOrHVJ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 09:08:07PM +0100, Belisko Marek wrote:
> On Mon, Nov 29, 2010 at 8:44 PM, Greg KH <greg@kroah.com> wrote:
> > On Wed, Nov 24, 2010 at 10:16:36AM +0100, Belisko Marek wrote:
> >> On Tue, Nov 23, 2010 at 10:28 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> >> > On 11/23/2010 03:00 PM, Belisko Marek wrote:
> >> >> On Tue, Nov 23, 2010 at 2:53 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> >> >>> On 11/23/2010 01:29 PM, Marek Belisko wrote:
> >> >>>> Use simple misc device for ioctl driver funtionality testing.
> >> >>>>
> >> >>>> Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
> >> >>>> ---
> >> >>>>  drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c |   90 ++++++++++++++++++---
> >> >>>>  1 files changed, 77 insertions(+), 13 deletions(-)
> >> >>>>
> >> >>>> diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
> >> >>>> index 1aec926..d1784a3 100644
> >> >>>> --- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
> >> >>>> +++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
> >> >>>> @@ -32,6 +32,7 @@
> >> >>>>  #include <linux/poll.h>
> >> >>>>  #include <linux/netdevice.h>
> >> >>>>  #include <linux/delay.h>
> >> >>>> +#include <linux/miscdevice.h>
> >> >>>>
> >> >>>>  #include <linux/fs.h>
> >> >>>>  #include <linux/kmod.h>
> >> >>>> @@ -78,6 +79,47 @@ static struct file_operations ft1000fops =
> >> >>>>       .llseek         = no_llseek,
> >> >>>>  };
> >> >>>>
> >> >>>> +struct ft1000_misc_device {
> >> >>>> +     struct miscdevice dev;
> >> >>>> +     int inf_id;
> >> >>>> +};
> >> >>>> +
> >> >>>> +#define FREE_ID (0xFF)
> >> >>>> +
> >> >>>> +/* we support just 3 devices */
> >> >>>> +#define MAX_DEVICE 3
> >> >>>
> >> >>> No, why this should be converted to miscdevice? Leave it as chrdev.
> >> >> Is there any problem with using miscdev?
> >> >
> >> > Yes, if you want more than a single device per system.
> >> >
> >> >> Old interface create /dev nodes with
> >> >> calling kernel thread and some usermode_helper or whatever.
> >> >
> >> > Yes, that's crap indeed. But doesn't judge for miscdevice.
> >> >
> >> >> Just convert to misc dev
> >> >> where this is done automatically.
> >> >
> >> > So the only thing you need to do is to send a uevent to udev appropriately.
> >> Could be used something like:
> >> register_chrdev(0,"ft1000", &fops)
> >> class = class_create(THIS_MODULE, "ft1000");
> >> device_create(class, NULL, MKDEV(major, i), NULL, "ft1000%d", i);
> >> Then will be created different devices for every plugged device.
> >> This should have effect of automatic device node creation also suppose.
> >
> > Please don't create new classes.
> >
> > Is this a USB device?  If so, why not just use the USB major number?
> Yes it is USB device.
> > Just ask me and I can reserve you a USB minor number for your driver.
> Idea behind existing code is that for every plugged device you will have created
> /dev node. NUmber of devices was limited by number of plugged devices.
> But who will plug more
> then one device which just used for internet connection? So maybe I
> should implement some
> limit and would be nice if you could reserve me some USB minors (lest
> say max. 3 devices?).

Send me a patch using the USB major number, and I'll add an additional
one that reserves the proper minor number for your driver.

thanks,

greg k-h
