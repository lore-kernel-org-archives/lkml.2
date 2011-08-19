Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab1HSWdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 18:33:19 -0400
Received: from smtp-out.google.com ([74.125.121.67]:27093 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756359Ab1HSWdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 18:33:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:from:to:cc:subject:date:message-id:x-mailer:
	mime-version:content-type:content-transfer-encoding:in-reply-to:x-system-of-record;
	b=u99LlOn/OIi4PaK5+cwMC6NmkiZp5fK+2cvkP2IeCNtQvbFWGnuiM4FHloC5VLNtD
	q0+FaJLs800Z38Bx7WtWA==
From: Michal Nazarewicz <mnazarewicz@google.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Dave Young" <hidave.darkstar@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv3 0/4] Figuring out speed refactorisation
Date: Sat, 20 Aug 2011 00:32:58 +0200
Message-Id: <cover.1313791722.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <fb37566fc5a85ea4e8711221253e5db98d919251.1313594405.git.mina86@mina86.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

Michal Nazarewicz (4):
  usb: Provide usb_device_speed_name() function

    Just a little helper.

  usb: gadget: replace "is_dualspeed" with "max_speed"

    This replaces "is_dualspeed" with "max_speed" so that one
    can encode in the field whether given UDC is super speed
    as well.

    Without this change, we would have to add a "is_superspeed"
    field since after removal of USB_GADGET_SUPERSPEED Kconfig
    option current implementation of gadget_is_superspeed()
    won't work.

  usb: gadget: rename usb_gadget_driver::speed to max_speed

    I don't have strong feelings about this patch, but the current
    name of the usb_gadget_driver::speed field may lead to some
    confusion.

    Changing it to "max_speed" should be apparent that it describes
    the maximum speed the gadget driver supports.

    This comes in pair with usb_gadget::max_speed and
    usb_composite_driver::max_speed.

  usb: gadget: get rid of USB_GADGET_{DUAL,SUPER}SPEED

    Removes the USB_GADGET_DUALSPEED and USB_GADGET_SUPERSPEED Kconfig
    options.  In most cases, they were checked just for optimisation
    (ie. if UDC was not dual speed, gadget drivers could skip some of
    the logic) so in the end this change was just about deleting
    #ifdefs.



Making those changes has exposed problems with some UDC drivers,
namely:

$ g grep -A3 'max_speed.*[=!]=.*USB_SPEED_HIGH'
drivers/usb/gadget/amd5536udc.c:                        || driver->max_speed != USB_SPEED_HIGH)
drivers/usb/gadget/amd5536udc.c-                return -EINVAL;
drivers/usb/gadget/amd5536udc.c-        if (!dev)
drivers/usb/gadget/amd5536udc.c-                return -ENODEV;
--
drivers/usb/gadget/m66592-udc.c:                        || driver->max_speed != USB_SPEED_HIGH
drivers/usb/gadget/m66592-udc.c-                        || !bind
drivers/usb/gadget/m66592-udc.c-                        || !driver->setup)
drivers/usb/gadget/m66592-udc.c-                return -EINVAL;
--
drivers/usb/gadget/net2272.c:       driver->max_speed != USB_SPEED_HIGH)
drivers/usb/gadget/net2272.c-           return -EINVAL;
drivers/usb/gadget/net2272.c-   if (!dev)
drivers/usb/gadget/net2272.c-           return -ENODEV;
--
drivers/usb/gadget/net2280.c:                   || driver->max_speed != USB_SPEED_HIGH
drivers/usb/gadget/net2280.c-                   || !bind || !driver->setup)
drivers/usb/gadget/net2280.c-           return -EINVAL;
drivers/usb/gadget/net2280.c-   if (!dev)
--
drivers/usb/gadget/r8a66597-udc.c:                      || driver->max_speed != USB_SPEED_HIGH
drivers/usb/gadget/r8a66597-udc.c-                      || !bind
drivers/usb/gadget/r8a66597-udc.c-                      || !driver->setup)
drivers/usb/gadget/r8a66597-udc.c-              return -EINVAL;

All those drivers require usb_gadget_driver::max_speed to be set to
USB_SPEED_HIGH.  This basically means that gmidi (which sets it to
USB_SPEED_FULL), g_ether and g_zero (which set it to USB_SPEED_SUPER)
won't work with those UDCs:

$ g grep -e '\.max_speed.*=.*USB_SPEED_SUPER' -e '\.max_speed.*=.*USB_SPEED_FULL'
dummy_hcd.c:    dum->gadget.max_speed = USB_SPEED_SUPER;;
ether.c:        .max_speed      = USB_SPEED_SUPER,
gmidi.c:        .max_speed      = USB_SPEED_FULL,
goku_udc.c:     dev->gadget.max_speed = USB_SPEED_FULL;
omap_udc.c:     udc->gadget.max_speed = USB_SPEED_FULL;
zero.c: .max_speed      = USB_SPEED_SUPER,

So as far as I can tell, UDC drivers for those need to be fixed (but
that's probably scope for another patchset).  Or am I missing
something?


Like before, this has been compile-tested only.

 drivers/usb/Makefile                   |    3 ++
 drivers/usb/common.c                   |   24 +++++++++++++++++
 drivers/usb/gadget/Kconfig             |   30 ----------------------
 drivers/usb/gadget/amd5536udc.c        |    4 +-
 drivers/usb/gadget/atmel_usba_udc.c    |    2 +-
 drivers/usb/gadget/ci13xxx_udc.c       |    9 ++++--
 drivers/usb/gadget/composite.c         |    9 +------
 drivers/usb/gadget/dbgp.c              |    2 +-
 drivers/usb/gadget/dummy_hcd.c         |   15 +++++------
 drivers/usb/gadget/epautoconf.c        |    6 ++--
 drivers/usb/gadget/file_storage.c      |    6 +---
 drivers/usb/gadget/fsl_udc_core.c      |    2 +-
 drivers/usb/gadget/fusb300_udc.c       |    2 +-
 drivers/usb/gadget/gmidi.c             |    2 +-
 drivers/usb/gadget/goku_udc.c          |    3 +-
 drivers/usb/gadget/inode.c             |   14 +---------
 drivers/usb/gadget/langwell_udc.c      |    2 +-
 drivers/usb/gadget/m66592-udc.c        |    4 +-
 drivers/usb/gadget/mv_udc_core.c       |    2 +-
 drivers/usb/gadget/net2272.c           |    4 +-
 drivers/usb/gadget/net2280.c           |    4 +-
 drivers/usb/gadget/omap_udc.c          |    1 +
 drivers/usb/gadget/pch_udc.c           |    4 +-
 drivers/usb/gadget/printer.c           |   43 +++++--------------------------
 drivers/usb/gadget/r8a66597-udc.c      |    4 +-
 drivers/usb/gadget/s3c-hsotg.c         |    2 +-
 drivers/usb/gadget/s3c-hsudc.c         |    2 +-
 drivers/usb/gadget/u_ether.c           |    7 -----
 drivers/usb/gadget/udc-core.c          |   41 +++++++++++++++---------------
 drivers/usb/musb/musb_gadget.c         |    2 +-
 drivers/usb/renesas_usbhs/mod_gadget.c |    2 +-
 include/linux/usb/ch9.h                |    8 ++++++
 include/linux/usb/gadget.h             |   29 +++++----------------
 33 files changed, 115 insertions(+), 179 deletions(-)
 create mode 100644 drivers/usb/common.c

-- 
1.7.3.1

