Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab0KLCpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 21:45:38 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38322 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab0KLCpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 21:45:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EOrfsstMapYcWgChbw5xsN2Nm44ca2sNh1fPdaevOY8VYUb/tyYrCuMtXVa+VPpZta
         qyvVwJuN9j2NreVbbBWhnMqtvhXYUHpMRf5dTnM6h8PdxjLqoGGW1opHNlGwAjW73S5g
         dShAoRvmRKmm0aUaXZARCbllhg9Hq9lHQVfc0=
Subject: [PATCH 2/3] Input: xpad - fix a memory leak
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Marko Friedemann <mfr@bmx-chemnitz.de>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        linux-input@vger.kernel.org
In-Reply-To: <1289530116.20782.2.camel@mola>
References: <1289530116.20782.2.camel@mola>
Content-Type: text/plain
Date: Fri, 12 Nov 2010 10:49:40 +0800
Message-Id: <1289530180.20782.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In xpad_led_disconnect(), what we really want is to kfree(xpad_led).
In xpad_disconnect(), add a missing kfree(xpad->bdata) to fix the memory leak.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/joystick/xpad.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 39c0265..26b2f2b 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -732,7 +732,7 @@ static void xpad_led_disconnect(struct usb_xpad *xpad)
 
 	if (xpad_led) {
 		led_classdev_unregister(&xpad_led->led_cdev);
-		kfree(xpad_led->name);
+		kfree(xpad_led);
 	}
 }
 #else
@@ -989,6 +989,7 @@ static void xpad_disconnect(struct usb_interface *intf)
 
 	usb_set_intfdata(intf, NULL);
 	if (xpad) {
+		kfree(xpad->bdata);
 		xpad_led_disconnect(xpad);
 		input_unregister_device(xpad->dev);
 		xpad_deinit_output(xpad);
-- 
1.7.2



