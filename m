Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab1LEJFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 04:05:22 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41720 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab1LEJFT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 04:05:19 -0500
MIME-Version: 1.0
In-Reply-To: <CACVXFVOgdmCzDbpygVXXj6pX_Pdbu+aAVk8p=7_P6SHyfMHNwQ@mail.gmail.com>
References: <1321231380-11631-1-git-send-email-peter.chen@freescale.com>
	<201111142327.37524.rjw@sisk.pl>
	<20111115005951.GB26360@kroah.com>
	<201111160016.09174.rjw@sisk.pl>
	<20111205085632.5976fe96@notabene.brown>
	<CACVXFVNkapRDJ8QkgmJCh+n1c2+7cHBiLf1ef22Nfdd8YrPpGg@mail.gmail.com>
	<35AB98346D25394A9354ED89C4D76587228EA3@039-SN1MPN1-002.039d.mgd.msft.net>
	<CACVXFVNd7ZnCjvRVX9wJbNNs_6apE-+14w-kxkgc5FAw4K-mAQ@mail.gmail.com>
	<CACVXFVOgdmCzDbpygVXXj6pX_Pdbu+aAVk8p=7_P6SHyfMHNwQ@mail.gmail.com>
Date: Mon, 5 Dec 2011 17:05:18 +0800
Message-ID: <CACVXFVOc45HL_qPHvNcGrkcQ7XWxBoLHikrYd1ZrRMYkiw5=ag@mail.gmail.com>
Subject: Re: [PATCH 1/1] driver core: disable device's runtime pm during shutdown
From: Ming Lei <tom.leiming@gmail.com>
To: Chen Peter-B29397 <B29397@freescale.com>
Cc: NeilBrown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Greg KH <greg@kroah.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "hzpeterchen@gmail.com" <hzpeterchen@gmail.com>,
        Igor Grinberg <grinberg@compulab.co.il>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 5, 2011 at 5:01 PM, Ming Lei <tom.leiming@gmail.com> wrote:

>>>
>>>
>>>> >  this patches causes a problem for me.
>>>> >
>>>> > Specifically it makes it impossible to power-down a device which uses
>>>> twl4030
>>>> > for power control on an omap3 processor.
>>>> >
>>>> > To perform the shutdown we need to send a command over the i2c bus.
>>>> > The relevant bus is called omap_i2c.1 and this is normally in suspend
>>>> mode.
>>>> > When a request is sent, omap_i2c_xfer uses pm_runtime_get_sync to wake
>>>> it up,
>>>> > performs the transfer, then calls pm_runtime_put to let it go back to
>>>> sleep.
>>>> >
>>>> > So it is asleep when the new pm_runtime_disable() call is made, so it
>>>> stays
>>>> > asleep, omap_i2c_xfer cannot wake it, the transfer doesn't happen and
>>>> the
>>>> > system doesn't get powered off.
>>>> >
>>>> > So here is a device that should *not* have pm disabled at shutdown.
>>>> >
>>>> > So I feel this fix is a little too heavy-handed.
>>>>
>>>> Maybe the device's runtime PM should not be disabled if
>>>> there is no ->shutdown defined in its driver, how about the blew?
>>>>
>>>> diff --git a/drivers/base/core.c b/drivers/base/core.c
>>>> index d8b3d89..ca30659 100644
>>>> --- a/drivers/base/core.c
>>>> +++ b/drivers/base/core.c
>>>> @@ -1743,14 +1743,16 @@ void device_shutdown(void)
>>>>                */
>>>>               list_del_init(&dev->kobj.entry);
>>>>               spin_unlock(&devices_kset->list_lock);
>>>> -             /* Disable all device's runtime power management */
>>>> -             pm_runtime_disable(dev);
>>>>
>>>> +             /* Disable the device's runtime power management if
>>>> +              * it is to be shutdown*/
>>>>               if (dev->bus && dev->bus->shutdown) {
>>>>                       dev_dbg(dev, "shutdown\n");
>>>> +                     pm_runtime_disable(dev);
>>>>                       dev->bus->shutdown(dev);
>>>>               } else if (dev->driver && dev->driver->shutdown) {
>>>>                       dev_dbg(dev, "shutdown\n");
>>>> +                     pm_runtime_disable(dev);
>>>>                       dev->driver->shutdown(dev);
>>>>               }
>>>>               put_device(dev);
>>>>
>>>>
>>> Yes, it is the solution for Neil's case, but I am not sure for all.
>>> Is it possible to resume driver's itself at driver's shutdown?
>>
>> Looks like this way is still not good. Maybe we should put all
>> device into active state first, then set its runtime pm as disabled.
>
> Below patch should a simple fix on the issue, but it may prolong
> shutdown/reboot time.
>
>
> diff --git a/drivers/base/core.c b/drivers/base/core.cindex
> d8b3d89..96b266c 100644--- a/drivers/base/core.c+++
> b/drivers/base/core.c@@ -1743,8 +1743,9 @@ void device_shutdown(void)
>                 */             list_del_init(&dev->kobj.entry);
>                spin_unlock(&devices_kset->list_lock);-         /* Disable all device's
> runtime power management */-            pm_runtime_disable(dev);++              /* put
> device into active state and forbid runtime pm
> */+             pm_runtime_forbid(dev);                 if (dev->bus && dev->bus->shutdown) {
>                        dev_dbg(dev, "shutdown\n");
,
Sorry, the above is line wrapped badly, see the below:

diff --git a/drivers/base/core.c b/drivers/base/core.c
index d8b3d89..96b266c 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1743,8 +1743,9 @@ void device_shutdown(void)
 		 */
 		list_del_init(&dev->kobj.entry);
 		spin_unlock(&devices_kset->list_lock);
-		/* Disable all device's runtime power management */
-		pm_runtime_disable(dev);
+
+		/* put device into active state and forbit runtime pm */
+		pm_runtime_forbid(dev);

 		if (dev->bus && dev->bus->shutdown) {
 			dev_dbg(dev, "shutdown\n");


thanks,
-- 
Ming Lei
