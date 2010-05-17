Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab0EQPjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 11:39:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941Ab0EQPjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 11:39:33 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-input@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH V2 3/3] input: Default to only using PNP for i8042 probing on x86
Date: Mon, 17 May 2010 11:38:36 -0400
Message-Id: <1274110716-12488-3-git-send-email-mjg@redhat.com>
In-Reply-To: <1274110716-12488-1-git-send-email-mjg@redhat.com>
References: <1274110716-12488-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Experimenting with Windows has revealed that it will not probe the
keyboard controller unless a valid PNPACPI device is present. Change our
behaviour to match - users can override by using the existing
i8042.nopnp=1 parameter.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/input/serio/i8042-x86ia64io.h |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 6168469..a5b5926 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -1,6 +1,8 @@
 #ifndef _I8042_X86IA64IO_H
 #define _I8042_X86IA64IO_H
 
+#include <linux/acpi.h>
+
 /*
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License version 2 as published by
@@ -744,9 +746,10 @@ static int __init i8042_pnp_init(void)
 
 	if (!i8042_pnp_kbd_devices && !i8042_pnp_aux_devices) {
 		i8042_pnp_exit();
-#if defined(__ia64__)
-		return -ENODEV;
-#else
+
+		if (!acpi_disabled)
+			return -ENODEV;
+
 		printk(KERN_INFO "PNP: No PS/2 controller found. Probing ports directly.\n");
 		return 0;
 #endif
-- 
1.7.0.1

