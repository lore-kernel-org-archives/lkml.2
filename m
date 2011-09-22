Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab1IVKKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 06:10:53 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:49772 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752590Ab1IVKKu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 06:10:50 -0400
X-Authenticated: #3169751
X-Provags-ID: V01U2FsdGVkX1+jPedX8p6jtTr3kpZDhaXf0hRFU+Z7++uwgqHeYv
	Hl2CqRteDouy6A
Date: Thu, 22 Sep 2011 12:10:31 +0200
From: Matthias Dellweg <2500@gmx.de>
To: Greg Kroah-Hartman <gregkh@suse.de>, Vasiliy Kulikov <segooon@gmail.com>,
        Michal Sojka <sojkam1@fel.cvut.cz>, Arnd Bergmann <arnd@arndb.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] enable usb control message with class specific request
Message-ID: <20110922121031.639006d0@horus>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
Usb devio assumes that the wIndex in every control message apart from
those flagged as USB_TYPE_VENDOR holds the number of the Interface
being addressed. This is for example not true for the class specific
request GET_DEVICE_ID in the printer class:

"The high-byte of the wIndex field is used to specify the zero-based
interface index. The low-byte of the wIndex field is used to specify
the zero-based alternate setting." [1]

In this special case it misinterpretes the alternate setting 1 for the
interface and tries to claim a nonexisting one. Therefor you won't get
the printers name.

The patch below is a minimal approach to fix this. Maybe it should be
extended to USB_TYPE_RESERVED. Maybe there should be an extended test
that knows something about specific classes.

What do you think?
regards Matthias

[1] http://www.usb.org/developers/devclass_docs/usbprint11.pdf



>From 724e3b5e8782a584a95d05bb2f44e59743ed3a72 Mon Sep 17 00:00:00 2001
From: Matthias Dellweg <2500@gmx.de>
Date: Wed, 21 Sep 2011 21:28:18 +0200
Subject: [PATCH] drivers/usb/core/devio.c: Relax test in check_ctrlrecip

The generic test for the interface is not valid when the request type is
class specific.

Signed-off-by: Matthias Dellweg <2500@gmx.de>
---
 drivers/usb/core/devio.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 37518df..4e78768 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -615,7 +615,8 @@ static int check_ctrlrecip(struct dev_state *ps, unsigned int requesttype,
         && ps->dev->state != USB_STATE_ADDRESS
         && ps->dev->state != USB_STATE_CONFIGURED)
                return -EHOSTUNREACH;
-       if (USB_TYPE_VENDOR == (USB_TYPE_MASK & requesttype))
+       if ((USB_TYPE_VENDOR == (USB_TYPE_MASK & requesttype))
+        || (USB_TYPE_CLASS == (USB_TYPE_MASK & requesttype)))
                return 0;
 
        index &= 0xff;
-- 
1.7.6.3

