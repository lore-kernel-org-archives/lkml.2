Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab2HPLd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 07:33:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671Ab2HPLdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 07:33:54 -0400
Message-ID: <502CDADA.2070507@redhat.com>
Date: Thu, 16 Aug 2012 13:34:50 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Miklos Szeredi <miklos@szeredi.hu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [REGRESION] Suspend hangs with 3.6-rc1 on Lenovo T60 notebook
References: <87a9xwivqb.fsf@tucsk.pomaz.szeredi.hu> <502B448D.7050602@redhat.com> <201208152159.51385.rjw@sisk.pl>
In-Reply-To: <201208152159.51385.rjw@sisk.pl>
Content-Type: multipart/mixed;
 boundary="------------060800000801090903000904"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060800000801090903000904
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 08/15/2012 09:59 PM, Rafael J. Wysocki wrote:
> On Wednesday, August 15, 2012, Hans de Goede wrote:
>> Hi,
>>
>> On 08/15/2012 07:13 AM, Miklos Szeredi wrote:
>>> Suspend oopses in generic_ide_suspend() because dev_get_drvdata()
>>> returns NULL (dev->p->driver_data == NULL) and this function is not
>>> prepared for this.
>>>
>>> I bisected it to 0998d063 (device-core: Ensure drvdata = NULL when no
>>> driver is bound).  Reverting it fixes suspend.
>>>
>>
>> First of all, thanks for reporting and bisecting this. With that said,
>> I must say that this is very weird. The patch in question:
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=0998d063
>>
>> Only makes dev-drvdata NULL in 2 cases:
>> 1) The probe method of the driver fails
>> 2) The driver has been detached from the device by calling one of:
>>      device_release_driver() or driver_detach()
>>
>> Note that in both code paths dev->driver also gets set to NULL, and
>> other generic ide driver callbacks very much depend on that not being
>> NULL, ie:
>>
>> static int generic_ide_remove(struct device *dev)
>> {
>>           ide_drive_t *drive = to_ide_device(dev);
>>           struct ide_driver *drv = to_ide_driver(dev->driver);
>>
>>           if (drv->remove)
>>                   drv->remove(drive);
>>
>>           return 0;
>> }
>>
>> Also how can a drivers suspend callback get called if dev->driver is NULL,
>> since that callback would normally be "reached" through dev->driver, so
>> something weird is going on here ...
>
> No, it wouldn't, because it is a bus type callback and it is invoked for
> all devices whose bus type is ide_bus_type, regardless of whether or not
> their driver field is NULL.

Ah right, these are bus_driver operations. That explains some things, so I've
done some more research asking myself: "Why does generic_ide_suspend(), which
is a *bus* op, call dev_get_drvdata?", the answer to that seems to be that
the ide subsystem is abusing (IMHO) drvdata to store per device bus_driver
data. Which I believe is not how drvdata is intended to be used.

With that said, the above knowledge has allowed me to write an (ugly) fix for
the regression Miklos is seeing. Miklos can you give the attached patch a
try please?

> It clearly should check if drive is not NULL before using that pointer.

I assume you mean drive*r*, yes I agree that generic_ide_remove should
check for that. So who is going to write a patch for that?

Regards,

Hans

--------------060800000801090903000904
Content-Type: text/x-patch;
 name="0001-ide-Restore-drvdata-after-device_attach-failure.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-ide-Restore-drvdata-after-device_attach-failure.patch"

>From 00f700ef4dd5fa335f725361aa683388c9b8ec4f Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Thu, 16 Aug 2012 13:23:30 +0200
Subject: [PATCH] ide: Restore drvdata after device_attach failure

Since commit 0998d063: "device-core: Ensure drvdata = NULL when no
driver is bound", device_attach will clear a device's drvdata if the
driver failed to bind to it.

In the ide subsystem however drvdata is not used to store driver data,
but rather to store per device bus_driver data. So for now restore
drvdata after calling device_register(), so that drvdata will still point
to the per device bus_driver data after a driver probe failure.

In the long run the ide subsystem should probably be fixed to not abuse
drvdata in this way, as this clearly is not how drvdata is intended to be
used.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/ide/ide-probe.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 068cef0..be1981b 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1015,6 +1015,12 @@ static void hwif_register_devices(ide_hwif_t *hwif)
 		if (ret < 0)
 			printk(KERN_WARNING "IDE: %s: device_register error: "
 					    "%d\n", __func__, ret);
+		/*
+		 * device_register() will have cleared drvdata on
+		 * device_attach failure, but we use drvdata to store per
+		 * device bus info, rather then for driver info, so restore it.
+		 */
+		dev_set_drvdata(dev, drive);
 	}
 }
 
-- 
1.7.11.4


--------------060800000801090903000904--
