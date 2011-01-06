Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab1AFKVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 05:21:53 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44469 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab1AFKVv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 05:21:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Kob9GzrTIHKJhPqfbV0hOwK11PAuN2mJ6+vqwItHQugiq96hwr1+Lg45++7At/cs4r
         EwTOgkinjLCp3VWJLJALSZ+Nd/n1dRagG66BCW9IQQQgGNUzyX384dfXKLcE4+rSK9RA
         7b19gGbTeTCOf42dvavXGPtI2MT8vHnmyQCJU=
MIME-Version: 1.0
In-Reply-To: <20110106101106.GE30215@kai-debian>
References: <20110106025949.GJ9496@kai-debian>
	<AANLkTi=B1XeBTogjVPWqOSFgJMD72gTpNZgg4znAR0t3@mail.gmail.com>
	<20110106101106.GE30215@kai-debian>
Date: Thu, 6 Jan 2011 11:21:49 +0100
Message-ID: <AANLkTin-W0-hj_jguZvbLNML_4VpV64qBN=bwEaf5RW3@mail.gmail.com>
Subject: Re: [PATCH] platform-driver-x86: ACPI EC Extra driver for Oaktrail
From: Corentin Chary <corentin.chary@gmail.com>
To: Yin Kangkai <kangkai.yin@linux.intel.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Liu, Bing Wei" <bing.wei.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 11:11 AM, Yin Kangkai
<kangkai.yin@linux.intel.com> wrote:
> On 2011-01-06, 08:29 +0100, Corentin Chary wrote:
>> Hi,
>
> Thanks for the review and comments.
>
>> > @@ -0,0 +1,349 @@
>> > +/*-*-linux-c-*-*/
>>
>> I don't know what's our general policy about that, but I don't think
>> each text editor should be allowed to add its own header on each
>> files. Most of the time you can configure your editor to set the
>> right indent style based on the path of the file or something like that.
>
> Yes, I agree with you, will remove that.
>
>> > + * gps - GPS subsystem enabled: contains either 0 or 1. (rw)
>> > + * wifi - WiFi subsystem enabled: contains either 0 or 1. (rw)
>> > + * wwan - WWAN (3G) subsystem enabled: contains either 0 or 1. (rw)
>>
>> Is there a reason do add these files in /sys/devices/platform while the
>> functionality is already provided by rfkill ?
>
> Provide a alternative way to enable/disable these devices, and also
> for debugging. Does that make any sense?

Maybe using debugfs then ?

>
>> > + * camera - Camera subsystem enabled: contains either 0 or 1. (rw)
>> > + * bluetooth - Bluetooth subsystem enabled: contains either 0 or 1. (rw)
>> > + * touchscreen - Touchscreen subsystem enabled: contains either 0 or 1. (ro)
>>
>> This should be in Documentation/ABI/testing/
>
> Should I prepare the document now and submit also?

Yep, there is already one or two platform drivers documented here, you can use
them as a template.

>> > +
>> > +static struct platform_device *oaktrail_device;
>> > +static struct rfkill *bt_rfkill;
>> > +static struct rfkill *gps_rfkill;
>> > +static struct rfkill *wifi_rfkill;
>> > +static struct rfkill *wwan_rfkill;
>>
>> Here you could create two (four ?) helpers that contains the logic,
>> and craft dummy functions which only call the helpers with the right
>> parameters in your macros.
>>
>> These helpers could also be used by later functions.
>>
>
> I will try to define some micros..
>
>> > +static int setup_rfkill(void)
>>
>> oaktrail_rfkill_init() ?
>
> Sure.
>
>> > +       rfkill_destroy(wwan_rfkill);
>> > +err_allocate_wwan:
>> > +       rfkill_unregister(gps_rfkill);
>> > +err_register_gps:
>> > +       rfkill_destroy(gps_rfkill);
>> > +err_allocate_gps:
>> > +       rfkill_unregister(bt_rfkill);
>> > +err_register_bt:
>> > +       rfkill_destroy(bt_rfkill);
>> > +err_allocate_bt:
>> > +       rfkill_unregister(wifi_rfkill);
>> > +err_register_wifi:
>> > +       rfkill_destroy(wifi_rfkill);
>> > +
>> > +       return ret;
>> > +}
>>
>> Here  I'd write an helper function to call rfkill_alloc,
>> rfkill_register and handle
>> rfkill_register failure. And then, if any of the helper calls fail, just call
>> oaktrail_rfkill_exit (which which rfkill if the rfkill pointer is NULL or not).
>>
>> oaktrail_rfkill_exit could also be used in the module exit function.
>
> Yes, will try to do that.
>
>> > +static int __devinit oaktrail_probe(struct platform_device *pdev)
>> > +{
>> > +       int err;
>> > +
>> > +       err = sysfs_create_group(&pdev->dev.kobj, &oaktrail_attribute_group);
>> > +       return err;
>> > +}
>>
>> return sysfs_create_group(&pdev->dev.kobj, &oaktrail_attribute_group);
>>
>> we don't really need err right now, do we ?
>
> Will change this.
>
>> > +MODULE_AUTHOR("Yin Kangkai (kangkai.yin@intel.com)");
>> > +MODULE_DESCRIPTION("Intel Oaktrail Platform ACPI Extras");
>> > +MODULE_VERSION(DRIVER_VERSION);
>> > +MODULE_LICENSE("GPL");
>>
>> Maybe you could add some MODULE_ALIAS("dmi:xxxxx") lines
>> to enable module autoloading ?
>
> Will try to.
>
> Thanks for the review.
>
> Regards,
> Kangkai
>



-- 
Corentin Chary
http://xf.iksaif.net
