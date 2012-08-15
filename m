Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab2HOGkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 02:40:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211Ab2HOGkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 02:40:23 -0400
Message-ID: <502B448D.7050602@redhat.com>
Date: Wed, 15 Aug 2012 08:41:17 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [REGRESION] Suspend hangs with 3.6-rc1 on Lenovo T60 notebook
References: <87a9xwivqb.fsf@tucsk.pomaz.szeredi.hu>
In-Reply-To: <87a9xwivqb.fsf@tucsk.pomaz.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/15/2012 07:13 AM, Miklos Szeredi wrote:
> Suspend oopses in generic_ide_suspend() because dev_get_drvdata()
> returns NULL (dev->p->driver_data == NULL) and this function is not
> prepared for this.
>
> I bisected it to 0998d063 (device-core: Ensure drvdata = NULL when no
> driver is bound).  Reverting it fixes suspend.
>

First of all, thanks for reporting and bisecting this. With that said,
I must say that this is very weird. The patch in question:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=0998d063

Only makes dev-drvdata NULL in 2 cases:
1) The probe method of the driver fails
2) The driver has been detached from the device by calling one of:
    device_release_driver() or driver_detach()

Note that in both code paths dev->driver also gets set to NULL, and
other generic ide driver callbacks very much depend on that not being
NULL, ie:

static int generic_ide_remove(struct device *dev)
{
         ide_drive_t *drive = to_ide_device(dev);
         struct ide_driver *drv = to_ide_driver(dev->driver);

         if (drv->remove)
                 drv->remove(drive);

         return 0;
}

Also how can a drivers suspend callback get called if dev->driver is NULL,
since that callback would normally be "reached" through dev->driver, so
something weird is going on here ...

I hope one of the ide guys can shed some light on this.

Regards,

Hans
