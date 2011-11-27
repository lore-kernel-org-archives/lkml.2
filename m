Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab1K0KYR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 05:24:17 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:38962 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752095Ab1K0KYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 05:24:15 -0500
X-Sasl-enc: KYSPkQ6etSat8B1HbbXozk5WXqdpd081VTt7t8k/R2bD 1322389452
Date: Sun, 27 Nov 2011 01:32:24 -0800
From: Greg KH <greg@kroah.com>
To: Federico Vaga <federico.vaga@gmail.com>
Cc: Alessandro Rubini <rubini@gnudd.com>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, dcobas@cern.ch, siglesia@cern.ch,
        manohar.vanga@cern.ch
Subject: Re: [RFC PATCH 2/7] include/linux: add headers for drivers/zio
Message-ID: <20111127093224.GB31086@kroah.com>
References: <cover.1322328073.git.rubini@gnudd.com>
 <09c2b3834c06fc45d8cca26d980482c8dad7af5a.1322328075.git.rubini@gnudd.com>
 <20111126200216.GC11421@kroah.com>
 <1491684.cGqJrVR8Lo@harkonnen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1491684.cGqJrVR8Lo@harkonnen>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 10:46:48PM +0100, Federico Vaga wrote:
> In data sabato 26 novembre 2011 12:02:16, Greg KH ha scritto:
> > On Sat, Nov 26, 2011 at 06:30:31PM +0100, Alessandro Rubini wrote:
> > > +/*
> > > + * We use the same functions to deal with attributes, but the structures
> > > + * we act on may be different (dev, cset, channel). Thus, all structures
> > > + * begin with the type identifier, and zio_obj_head is used in
> > > container_of + */
> > 
> > Because you are using container_of, you don't have to have the structure
> > at the beginning of the structure it is included in, right?
> 
> Different structures have similar features and we use zio_obj_head->zobj_type to 
> identify the correct container_of to apply.  Sometimes we use the head only, so 
> we delay container_of later. 

That's usually not a good idea, which is why we don't do it generally in
the rest of the kernel.

You should "almost" always already know the type of device you are
pointing to when pointing to it, so that you can properly dereference
it.  I think you are doing the right thing here, but the true test would
be to move that structure somewhere else other than "first" and see what
breaks.

> > > +enum zio_object_type {
> > > +   ZNONE = 0,      /* reserved for non zio object */
> > > +   ZDEV, ZCSET, ZCHAN,
> > > +   ZTRIG, ZTI,     /* trigger and trigger instance */
> > > +   ZBUF, ZBI,      /* buffer and buffer instance */
> > > +};
> > > +
> > > +/* zio_obj_head is for internal use only, as explained above */
> > > +struct zio_obj_head {
> > > +   struct kobject          kobj;
> > > +   enum zio_object_type    zobj_type;
> > > +   char                    name[ZIO_NAME_LEN];
> > > +};
> > > +#define to_zio_head(_kobj) container_of(_kobj, struct zio_obj_head, kobj)
> > > +#define to_zio_dev(_kobj) container_of(_kobj, struct zio_device,
> > > head.kobj) +#define to_zio_cset(_kobj) container_of(_kobj, struct
> > > zio_cset, head.kobj) +#define to_zio_chan(_kobj) container_of(_kobj,
> > > struct zio_channel, head.kobj)
> > Why are you using a "raw" kobject and not 'struct device' instead? 
> 
> The device way was experimented and we can move in that direction. I also 
> tried a mixed solution with device and kobject, because not all the zio objects 
> can be device.
> 
> I decided to use the kobject way because it was an easier and flexible solution 
> for a fast development.
> 
> > If you use a kobject, you loose all of the device tree information that a
> > real struct device provides to userspace,
> 
> You mean the device sysfs tree? Acctually we don't need that information

Yes you do, you are already using it, right?

By using kobjects you "skip" notifying userspace the whole tree and it
only knows about "parts" of it, which is why you should not do this.

> > and can only cause confusion in the long run.
> 
> I think it can be confusing to declare a device what is not a device, for 
> example: buffer, trigger, channel-set (maybe in some 
> sense can be a device) and channel 

Nope, they seem like "devices" to me in that you want them showing up in
sysfs, which is why you used kobjects, right?  Because of that, you are
in the device tree, so you need to use a 'struct device'.

> > This also will provide you the "type" and name that you are needing
> > here, as well as lots of other good things (properly formatted logging
> > messages, uevents, etc.)
> 
> If you refer to device_type, I think it is too complex for our purpose (also 
> tried during the device "experiment"), we only need to recognize a zio object, 
> we don't need al the stuff within device_type.
> 
> You are right, device is full of great things and the migration to device is 
> always a point of discussion, but actually kobject meet well with our needs.

I beg to differ.

> > Please consider moving to that instead.
> 
> We can re-evaluate and better explain the choice if kobj is still the 
> preferrable one

kobject is not the preferrable one, sorry.

greg k-h
