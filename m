Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab2JFUEk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 16:04:40 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:36680 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab2JFUEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 16:04:38 -0400
Date: Sat, 6 Oct 2012 22:04:21 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, fabien.andre@gmail.com,
        scott.liu@emc.com.tw, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] i2c-hid: introduce HID over i2c specification
 implementation
Message-ID: <20121006220421.47f5fd56@endymion.delvare>
In-Reply-To: <1347630103-4105-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1347630103-4105-1-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

On Fri, 14 Sep 2012 15:41:43 +0200, benjamin.tissoires wrote:
> From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> 
> Microsoft published the protocol specification of HID over i2c:
> http://msdn.microsoft.com/en-us/library/windows/hardware/hh852380.aspx
> 
> This patch introduces an implementation of this protocol.
> 
> This implementation does not includes the ACPI part of the specification.
> This will come when ACPI 5.0 devices will be available.
> 
> Once the ACPI part will be done, OEM will not have to declare HID over I2C
> devices in their platform specific driver.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> ---
> 
> Hi,
> 
> this is finally my first implementation of HID over I2C.
> 
> This has been tested on an Elan Microelectronics HID over I2C device, with
> a Samsung Exynos 4412 board.
> 
> Any comments are welcome.
> 
> Cheers,
> Benjamin
> 
>  drivers/i2c/Kconfig         |    8 +
>  drivers/i2c/Makefile        |    1 +
>  drivers/i2c/i2c-hid.c       | 1027 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/i2c/i2c-hid.h |   35 ++
>  4 files changed, 1071 insertions(+)
>  create mode 100644 drivers/i2c/i2c-hid.c
>  create mode 100644 include/linux/i2c/i2c-hid.h

Looks like the wrong place for this driver. HID-over-USB support lives
under drivers/hid, so your driver should go there as well. Not only
this will be more consistent, but it also makes more sense: your driver
is a user, not an implementer, of the I2C layer, so it doesn't belong
to drivers/i2c.

Also, you need to sort out dependencies. Your causes a link failure here:

ERROR: "hiddev_report_event" [drivers/i2c/i2c-hid.ko] undefined!
ERROR: "hiddev_disconnect" [drivers/i2c/i2c-hid.ko] undefined!
ERROR: "hiddev_connect" [drivers/i2c/i2c-hid.ko] undefined!
ERROR: "hid_pidff_init" [drivers/i2c/i2c-hid.ko] undefined!
make[1]: *** [__modpost] Erreur 1
make: *** [modules] Erreur 2

This is because these functions aren't exported and I tried to build
i2c-hid as a module.BTW I see that these functions are part of the
usbhid driver, which looks seriously wrong. If these functions are
transport layer-independent, they should be moved to the hid-code or
some sub-module. One should be able to enable HID-over-I2C without
HID-over-USB.

-- 
Jean Delvare
