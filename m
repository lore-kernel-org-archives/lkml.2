Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930Ab2JFUjF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 16:39:05 -0400
Received: from smtp.intuilab.com ([93.93.42.171]:56564 "EHLO
	zimbra.intuilab.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab2JFUjB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 16:39:01 -0400
X-Greylist: delayed 528 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Oct 2012 16:39:01 EDT
Subject: Re: [PATCH v1] i2c-hid: introduce HID over i2c specification  implementation
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
From: =?iso-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
In-Reply-To: <20121006220421.47f5fd56@endymion.delvare>
Date: Sat, 6 Oct 2012 22:30:00 +0200
Cc: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        =?iso-8859-1?Q?Fabien_Andr=E9?= <fabien.andre@gmail.com>,
        =?utf-8?B?5YqJ5ZiJ6ae/?= <scott.liu@emc.com.tw>,
        Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org, USB list <linux-input@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <6F756B9E-DC87-4EF6-BB09-8A69A5F8C999@enac.fr>
References: <1347630103-4105-1-git-send-email-benjamin.tissoires@gmail.com> <20121006220421.47f5fd56@endymion.delvare>
To: Jean Delvare <khali@linux-fr.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean

(I cc Marcel Holtmann because BT is involved too)

Le 6 oct. 2012 à 22:04, Jean Delvare a écrit :

> Hi Benjamin,
> 
> On Fri, 14 Sep 2012 15:41:43 +0200, benjamin.tissoires wrote:
>> From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
>> 
>> Microsoft published the protocol specification of HID over i2c:
>> http://msdn.microsoft.com/en-us/library/windows/hardware/hh852380.aspx
>> 
>> This patch introduces an implementation of this protocol.
>> 
>> This implementation does not includes the ACPI part of the specification.
>> This will come when ACPI 5.0 devices will be available.
>> 
>> Once the ACPI part will be done, OEM will not have to declare HID over I2C
>> devices in their platform specific driver.
>> 
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
>> ---
>> 
>> Hi,
>> 
>> this is finally my first implementation of HID over I2C.
>> 
>> This has been tested on an Elan Microelectronics HID over I2C device, with
>> a Samsung Exynos 4412 board.
>> 
>> Any comments are welcome.
>> 
>> Cheers,
>> Benjamin
>> 
>> drivers/i2c/Kconfig         |    8 +
>> drivers/i2c/Makefile        |    1 +
>> drivers/i2c/i2c-hid.c       | 1027 +++++++++++++++++++++++++++++++++++++++++++
>> include/linux/i2c/i2c-hid.h |   35 ++
>> 4 files changed, 1071 insertions(+)
>> create mode 100644 drivers/i2c/i2c-hid.c
>> create mode 100644 include/linux/i2c/i2c-hid.h
> 
> Looks like the wrong place for this driver. HID-over-USB support lives
> under drivers/hid, so your driver should go there as well. Not only
> this will be more consistent, but it also makes more sense: your driver
> is a user, not an implementer, of the I2C layer, so it doesn't belong
> to drivers/i2c.

This is a question I asked a few months back, but apparently not all points of views had been expressed at the time. Currently, HID-over-USB lives in drivers/hid, but HID-over-BT lives in drivers/bluetooth. When I asked, Jiri explained that he maintained HID-over-USB and Marcel maintained HID-over-BT, which explained the choices made. Let's try to summarize what we know now:

The question is what drives the choice of where to put HID-over-XXX, among the following
 1- who the maintainer is. Here, Benjamin will probably maintain this so it does not help.
 2- dependencies. HID-over-XXX depends on HID as much as it depends on XXX, so it does not help.
 3- data flow. Indeed, HID is a client of HID-over-XXX which is a client of XXX. Are there other parts of the kernel where this drives the choice of where YYY-over-XXX lives?

Jiri, Marcel, Greg, others, any opinions?

> 
> Also, you need to sort out dependencies. Your causes a link failure here:
> 
> ERROR: "hiddev_report_event" [drivers/i2c/i2c-hid.ko] undefined!
> ERROR: "hiddev_disconnect" [drivers/i2c/i2c-hid.ko] undefined!
> ERROR: "hiddev_connect" [drivers/i2c/i2c-hid.ko] undefined!
> ERROR: "hid_pidff_init" [drivers/i2c/i2c-hid.ko] undefined!
> make[1]: *** [__modpost] Erreur 1
> make: *** [modules] Erreur 2
> 
> This is because these functions aren't exported and I tried to build
> i2c-hid as a module.BTW I see that these functions are part of the
> usbhid driver, which looks seriously wrong. If these functions are
> transport layer-independent, they should be moved to the hid-code or
> some sub-module. One should be able to enable HID-over-I2C without
> HID-over-USB.
> 
> -- 
> Jean Delvare

Cheers,

St.

PS: Benjamin is leaving ENAC. He'll probably keep maintaining HID-over-I2C, and we'll probably share the maintenance of hid-multitouch as well as other input-related projects we have not published yet.

