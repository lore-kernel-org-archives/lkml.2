Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab1KZVoa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 16:44:30 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43010 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab1KZVo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 16:44:29 -0500
From: Federico Vaga <federico.vaga@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Alessandro Rubini <rubini@gnudd.com>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, dcobas@cern.ch, siglesia@cern.ch,
        manohar.vanga@cern.ch
Subject: Re: [RFC PATCH 2/7] include/linux: add headers for drivers/zio
Date: Sat, 26 Nov 2011 22:46:48 +0100
Message-ID: <1491684.cGqJrVR8Lo@harkonnen>
User-Agent: KMail/4.7.3 (Linux/3.1.1-2.fc16.x86_64; KDE/4.7.3; x86_64; ; )
In-Reply-To: <20111126200216.GC11421@kroah.com>
References: <cover.1322328073.git.rubini@gnudd.com> <09c2b3834c06fc45d8cca26d980482c8dad7af5a.1322328075.git.rubini@gnudd.com> <20111126200216.GC11421@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In data sabato 26 novembre 2011 12:02:16, Greg KH ha scritto:
> On Sat, Nov 26, 2011 at 06:30:31PM +0100, Alessandro Rubini wrote:
> > +/*
> > + * We use the same functions to deal with attributes, but the structures
> > + * we act on may be different (dev, cset, channel). Thus, all structures
> > + * begin with the type identifier, and zio_obj_head is used in
> > container_of + */
> 
> Because you are using container_of, you don't have to have the structure
> at the beginning of the structure it is included in, right?

Different structures have similar features and we use zio_obj_head->zobj_type to 
identify the correct container_of to apply.  Sometimes we use the head only, so 
we delay container_of later. 

> > +enum zio_object_type {
> > +   ZNONE = 0,      /* reserved for non zio object */
> > +   ZDEV, ZCSET, ZCHAN,
> > +   ZTRIG, ZTI,     /* trigger and trigger instance */
> > +   ZBUF, ZBI,      /* buffer and buffer instance */
> > +};
> > +
> > +/* zio_obj_head is for internal use only, as explained above */
> > +struct zio_obj_head {
> > +   struct kobject          kobj;
> > +   enum zio_object_type    zobj_type;
> > +   char                    name[ZIO_NAME_LEN];
> > +};
> > +#define to_zio_head(_kobj) container_of(_kobj, struct zio_obj_head, kobj)
> > +#define to_zio_dev(_kobj) container_of(_kobj, struct zio_device,
> > head.kobj) +#define to_zio_cset(_kobj) container_of(_kobj, struct
> > zio_cset, head.kobj) +#define to_zio_chan(_kobj) container_of(_kobj,
> > struct zio_channel, head.kobj)
> Why are you using a "raw" kobject and not 'struct device' instead? 

The device way was experimented and we can move in that direction. I also 
tried a mixed solution with device and kobject, because not all the zio objects 
can be device.

I decided to use the kobject way because it was an easier and flexible solution 
for a fast development.

> If you use a kobject, you loose all of the device tree information that a
> real struct device provides to userspace,

You mean the device sysfs tree? Acctually we don't need that information

> and can only cause confusion in the long run.

I think it can be confusing to declare a device what is not a device, for 
example: buffer, trigger, channel-set (maybe in some 
sense can be a device) and channel 

> This also will provide you the "type" and name that you are needing
> here, as well as lots of other good things (properly formatted logging
> messages, uevents, etc.)

If you refer to device_type, I think it is too complex for our purpose (also 
tried during the device "experiment"), we only need to recognize a zio object, 
we don't need al the stuff within device_type.

You are right, device is full of great things and the migration to device is 
always a point of discussion, but actually kobject meet well with our needs.

> Please consider moving to that instead.

We can re-evaluate and better explain the choice if kobj is still the 
preferrable one

> thanks,
> 
> greg k-h
-- 
Federico Vaga
