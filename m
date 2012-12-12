Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab2LLVxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 16:53:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53549 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab2LLVxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 16:53:36 -0500
Date: Wed, 12 Dec 2012 13:52:47 -0800
From: tip-bot for Ondrej Zary <linux@rainbow-software.org>
Message-ID: <tip-ad68652412276f68ad4fe3e1ecf5ee6880876783@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, linux@rainbow-software.org, hpa@zytor.com,
        mingo@kernel.org, stable@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        dmitry.torokhov@gmail.com, tglx@linutronix.de, hpa@linux.intel.com,
        rjw@sisk.pl
Reply-To: mingo@kernel.org, hpa@zytor.com, linux@rainbow-software.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, dmitry.torokhov@gmail.com,
        tglx@linutronix.de, rjw@sisk.pl, hpa@linux.intel.com
In-Reply-To: <201212112218.06551.linux@rainbow-software.org>
References: <201212112218.06551.linux@rainbow-software.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, 8042:
  Enable A20 using KBC to fix S3 resume on some MSI laptops
Git-Commit-ID: ad68652412276f68ad4fe3e1ecf5ee6880876783
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 12 Dec 2012 13:52:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ad68652412276f68ad4fe3e1ecf5ee6880876783
Gitweb:     http://git.kernel.org/tip/ad68652412276f68ad4fe3e1ecf5ee6880876783
Author:     Ondrej Zary <linux@rainbow-software.org>
AuthorDate: Tue, 11 Dec 2012 22:18:05 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 11 Dec 2012 14:55:16 -0800

x86, 8042: Enable A20 using KBC to fix S3 resume on some MSI laptops

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
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/201212112218.06551.linux@rainbow-software.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 drivers/input/serio/i8042-x86ia64io.h | 9 +++++++++
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
