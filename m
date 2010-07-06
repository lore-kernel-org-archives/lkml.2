Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab0GFSsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 14:48:35 -0400
Received: from king.tilera.com ([72.1.168.226]:50110 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699Ab0GFSsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 14:48:33 -0400
Message-Id: <201007061848.o66ImVPc020837@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 6 Jul 2010 14:03:16 -0400
Subject: [PATCH] hvc_console: use "*_console" nomenclature to avoid modpost warning.
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Anton Blanchard <anton@au.ibm.com>, Paul Mackerras <paulus@au.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Ryan S. Arnold" <rsa@us.ibm.com>,
       Hollis Blanchard <hollisb@us.ibm.com>
X-OriginalArrivalTime: 06 Jul 2010 18:48:32.0703 (UTC) FILETIME=[D52E04F0:01CB1D3B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of "hvc_con_driver" as the name for a file-static "struct
console" with a ".setup" field pointing to an __init function causes
a modpost warning, since a non-initdata structure points to init code.
Using "hvc_console" as the name triggers the hacky "*_console"
workaround in modpost to silence the warning, and is the same thing
that most of the other console drivers already do.

I made the same change in hvsi.c since I happened to notice it was
likely to suffer from the same problem.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 drivers/char/hvc_console.c |   12 ++++++------
 drivers/char/hvsi.c        |    4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/char/hvc_console.c b/drivers/char/hvc_console.c
index 35cca4c..fa27d16 100644
--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -194,7 +194,7 @@ static int __init hvc_console_setup(struct console *co, char *options)
 	return 0;
 }
 
-static struct console hvc_con_driver = {
+static struct console hvc_console = {
 	.name		= "hvc",
 	.write		= hvc_console_print,
 	.device		= hvc_console_device,
@@ -220,7 +220,7 @@ static struct console hvc_con_driver = {
  */
 static int __init hvc_console_init(void)
 {
-	register_console(&hvc_con_driver);
+	register_console(&hvc_console);
 	return 0;
 }
 console_initcall(hvc_console_init);
@@ -276,8 +276,8 @@ int hvc_instantiate(uint32_t vtermno, int index, const struct hv_ops *ops)
 	 * now (setup won't fail at this point).  It's ok to just
 	 * call register again if previously .setup failed.
 	 */
-	if (index == hvc_con_driver.index)
-		register_console(&hvc_con_driver);
+	if (index == hvc_console.index)
+		register_console(&hvc_console);
 
 	return 0;
 }
@@ -641,7 +641,7 @@ int hvc_poll(struct hvc_struct *hp)
 		}
 		for (i = 0; i < n; ++i) {
 #ifdef CONFIG_MAGIC_SYSRQ
-			if (hp->index == hvc_con_driver.index) {
+			if (hp->index == hvc_console.index) {
 				/* Handle the SysRq Hack */
 				/* XXX should support a sequence */
 				if (buf[i] == '\x0f') {	/* ^O */
@@ -909,7 +909,7 @@ static void __exit hvc_exit(void)
 		tty_unregister_driver(hvc_driver);
 		/* return tty_struct instances allocated in hvc_init(). */
 		put_tty_driver(hvc_driver);
-		unregister_console(&hvc_con_driver);
+		unregister_console(&hvc_console);
 	}
 }
 module_exit(hvc_exit);
diff --git a/drivers/char/hvsi.c b/drivers/char/hvsi.c
index d4b14ff..1f4b6de 100644
--- a/drivers/char/hvsi.c
+++ b/drivers/char/hvsi.c
@@ -1255,7 +1255,7 @@ static int __init hvsi_console_setup(struct console *console, char *options)
 	return 0;
 }
 
-static struct console hvsi_con_driver = {
+static struct console hvsi_console = {
 	.name		= "hvsi",
 	.write		= hvsi_console_print,
 	.device		= hvsi_console_device,
@@ -1308,7 +1308,7 @@ static int __init hvsi_console_init(void)
 	}
 
 	if (hvsi_count)
-		register_console(&hvsi_con_driver);
+		register_console(&hvsi_console);
 	return 0;
 }
 console_initcall(hvsi_console_init);
-- 
1.6.5.2

