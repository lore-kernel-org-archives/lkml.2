Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655Ab0EXXcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:32:43 -0400
Received: from kroah.org ([198.145.64.141]:59306 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932297Ab0EXXXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:23:25 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:18:13 2010
Message-Id: <20100524231813.390897769@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 16:15:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oliver Neukum <oneukum@suse.de>, Eric Piel <eric.piel@tremplin-utc.net>,
       Pavel Machek <pavel@ucw.cz>, Pavel Herrmann <morpheus.ibis@gmail.com>
Subject: [02/39] hp_accel: fix race in device removal
In-Reply-To: <20100524231840.GA17857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Oliver Neukum <oneukum@suse.de>

commit 06efbeb4a47b6f865e1c9d175ab9d6e90b69ae9e upstream.

The work queue has to be flushed after the device has been made
inaccessible.  The patch closes a window during which a work queue might
remain active after the device is removed and would then lead to ACPI
calls with undefined behavior.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Acked-by: Eric Piel <eric.piel@tremplin-utc.net>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Pavel Herrmann <morpheus.ibis@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/hp_accel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/hp_accel.c
+++ b/drivers/hwmon/hp_accel.c
@@ -324,8 +324,8 @@ static int lis3lv02d_remove(struct acpi_
 	lis3lv02d_joystick_disable();
 	lis3lv02d_poweroff(&lis3_dev);
 
-	flush_work(&hpled_led.work);
 	led_classdev_unregister(&hpled_led.led_classdev);
+	flush_work(&hpled_led.work);
 
 	return lis3lv02d_remove_fs(&lis3_dev);
 }


