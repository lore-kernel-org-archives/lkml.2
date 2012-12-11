Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab2LKVS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 16:18:57 -0500
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:51165 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753238Ab2LKVSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 16:18:55 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: hpa@zytor.com
Subject: [PATCH v4] 8042: Enable A20 using KBC to fix S3 resume on some MSI laptops
Date: Tue, 11 Dec 2012 22:18:05 +0100
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201212112218.06551.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some MSI laptop BIOSes are broken - INT 15h code uses port 92h to enable A20
line but resume code assumes that KBC was used.
The laptop will not resume from S3 otherwise but powers off after a while
and then powers on again stuck with a blank screen.

Fix it by enabling A20 using KBC in i8042_platform_init for x86.

Fixes https://bugzilla.kernel.org/show_bug.cgi?id=12878

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/input/serio/i8042-x86ia64io.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index d6cc77a..5f306f7 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -921,6 +921,7 @@ static int __init i8042_platform_init(void)
 	int retval;
 
 #ifdef CONFIG_X86
+	u8 a20_on = 0xdf;
 	/* Just return if pre-detection shows no i8042 controller exist */
 	if (!x86_platform.i8042_detect())
 		return -ENODEV;
@@ -960,6 +961,14 @@ static int __init i8042_platform_init(void)
 
 	if (dmi_check_system(i8042_dmi_dritek_table))
 		i8042_dritek = true;
+
+	/*
+	 * A20 was already enabled during early kernel init. But some buggy
+	 * BIOSes (in MSI Laptops) require A20 to be enabled using 8042 to
+	 * resume from S3. So we do it here and hope that nothing breaks.
+	 */
+	i8042_command(&a20_on, 0x10d1);
+	i8042_command(NULL, 0x00ff);	/* Null command for SMM firmware */
 #endif /* CONFIG_X86 */
 
 	return retval;
-- 
Ondrej Zary
