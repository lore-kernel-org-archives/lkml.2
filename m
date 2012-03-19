Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030573Ab2CSLIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 07:08:19 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:39118 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246Ab2CSLIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 07:08:17 -0400
Date: Mon, 19 Mar 2012 12:08:08 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "beattiem@uk.ibm.com" <beattiem@uk.ibm.com>,
        "holzheu@de.ibm.com" <holzheu@de.ibm.com>,
        "munzert@de.ibm.com" <munzert@de.ibm.com>,
        "linux390@de.ibm.com" <linux390@de.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH]s390/char/vmur.c: memory leak Fix in the driver
Message-ID: <20120319120808.7e34d652@de.ibm.com>
In-Reply-To: <20120319113744.5992d48f@de.ibm.com>
References: <491D6B4EAD0A714894D8AD22F4BDE0430495F2@SCYBEXDAG04.amd.com>
	<491D6B4EAD0A714894D8AD22F4BDE04304FF5A@SCYBEXDAG04.amd.com>
	<20120319113744.5992d48f@de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12031911-8372-0000-0000-00000206C202
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2012 11:37:44 +0100
Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> On Mon, 19 Mar 2012 01:55:40 +0000
> "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com> wrote:
> 
> > CC'ing maintainer: Martin Schwidefsky &  Heiko Carstens...
> > 
> > -----Original Message-----
> > From: Chen, Dennis (SRDC SW) 
> > Sent: Sunday, March 18, 2012 3:41 AM
> > To: linux-kernel@vger.kernel.org
> > Cc: beattiem@uk.ibm.com; holzheu@de.ibm.com; munzert@de.ibm.com; linux390@de.ibm.com; linux-s390@vger.kernel.org; Chen, Dennis (SRDC SW)
> > Subject: [PATCH]s390/char/vmur.c: memory leak Fix in the driver
> > 
> > This patch is used to fix a memory leak issue in s390/char/vmur.c: a character device instance is 
> > allocated by cdev_alloc, the cdev_del will not free that space if cdev_init is applied before. 
> > 
> > Signed-off-by: dennis1.chen@amd.com
> > --- a/s390/char/vmur.c  2012-03-18 02:50:47.950963949 +0800
> > +++ b/s390/char/vmur.c  2012-03-18 03:12:04.790936740 +0800
> > @@ -903,7 +903,7 @@ static int ur_set_online(struct ccw_devi
> >                 goto fail_urdev_put;
> >         }
> > 
> > -       cdev_init(urd->char_device, &ur_fops);
> > +       urd->char_device->ops = &ur_fops;
> >         urd->char_device->dev = MKDEV(major, minor);
> >         urd->char_device->owner = ur_fops.owner;
> > 
> 
> How does that fix anything? My copy of cdev_init looks like this:
> 
> void cdev_init(struct cdev *cdev, const struct file_operations *fops)
> {
>         memset(cdev, 0, sizeof *cdev);
>         INIT_LIST_HEAD(&cdev->list);
>         kobject_init(&cdev->kobj, &ktype_cdev_default);
>         cdev->ops = fops;
> }
> 
> It does not allocate anything but it initializes some more fields.
> The new code would only initialize the ops field. In addition
> cdev_del does a kobject_put and the release function of the object
> will call cdev_dynamic_release as far as I can tell. That code
> should be fine as it is.

Hmm, forget that. cdev_init has a second kobject_init that replaces
ktype_cdev_dynamic with ktype_cdev_default. cdev_alloc already does
the initialization and your fix is just fine. 
Seems like cdev_init is only there for static cdev structures.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

