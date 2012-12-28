Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab2L1Tph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:45:37 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55220 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754688Ab2L1TSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:18:10 -0500
Message-Id: <20121228190356.249264887@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:34 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ondrej Zary <linux@rainbow-software.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 124/173] x86, 8042: Enable A20 using KBC to fix S3 resume on some MSI laptops
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ondrej Zary <linux@rainbow-software.org>

commit ad68652412276f68ad4fe3e1ecf5ee6880876783 upstream.

Some MSI laptop BIOSes are broken - INT 15h code uses port 92h to enable A20
line but resume code assumes that KBC was used.
The laptop will not resume from S3 otherwise but powers off after a while
and then powers on again stuck with a blank screen.

Fix it by enabling A20 using KBC in i8042_platform_init for x86.

Fixes https://bugzilla.kernel.org/show_bug.cgi?id=12878

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Link: http://lkml.kernel.org/r/201212112218.06551.linux@rainbow-software.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/input/serio/i8042-x86ia64io.h |    9 +++++++++
 1 file changed, 9 insertions(+)

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


