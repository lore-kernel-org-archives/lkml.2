Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab2HOTx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:53:59 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:40823 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932287Ab2HOTxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:53:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [REGRESION] Suspend hangs with 3.6-rc1 on Lenovo T60 notebook
Date: Wed, 15 Aug 2012 21:59:51 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
References: <87a9xwivqb.fsf@tucsk.pomaz.szeredi.hu> <502B448D.7050602@redhat.com>
In-Reply-To: <502B448D.7050602@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208152159.51385.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 15, 2012, Hans de Goede wrote:
> Hi,
> 
> On 08/15/2012 07:13 AM, Miklos Szeredi wrote:
> > Suspend oopses in generic_ide_suspend() because dev_get_drvdata()
> > returns NULL (dev->p->driver_data == NULL) and this function is not
> > prepared for this.
> >
> > I bisected it to 0998d063 (device-core: Ensure drvdata = NULL when no
> > driver is bound).  Reverting it fixes suspend.
> >
> 
> First of all, thanks for reporting and bisecting this. With that said,
> I must say that this is very weird. The patch in question:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=0998d063
> 
> Only makes dev-drvdata NULL in 2 cases:
> 1) The probe method of the driver fails
> 2) The driver has been detached from the device by calling one of:
>     device_release_driver() or driver_detach()
> 
> Note that in both code paths dev->driver also gets set to NULL, and
> other generic ide driver callbacks very much depend on that not being
> NULL, ie:
> 
> static int generic_ide_remove(struct device *dev)
> {
>          ide_drive_t *drive = to_ide_device(dev);
>          struct ide_driver *drv = to_ide_driver(dev->driver);
> 
>          if (drv->remove)
>                  drv->remove(drive);
> 
>          return 0;
> }
> 
> Also how can a drivers suspend callback get called if dev->driver is NULL,
> since that callback would normally be "reached" through dev->driver, so
> something weird is going on here ...

No, it wouldn't, because it is a bus type callback and it is invoked for
all devices whose bus type is ide_bus_type, regardless of whether or not
their driver field is NULL.

It clearly should check if drive is not NULL before using that pointer.

Thanks,
Rafael
