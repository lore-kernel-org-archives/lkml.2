Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755Ab1FPMPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 08:15:51 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:55430 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757729Ab1FPMPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 08:15:47 -0400
Date: Thu, 16 Jun 2011 14:07:22 +0200
From: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>
To: Greg Kroah-Hartman <gregkh@suse.de>, Jiri Slaby <jirislaby@gmail.com>,
        linux-kernel@vger.kernel.org,
        christian.dietrich@informatik.uni-erlangen.de
Subject: [PATCH 02/11] drivers/tty: use printk_ratelimited() instead of
 printk_ratelimit()
Message-ID: <122f402290c451ebb0e9c1adbbe72966c2b69b48.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
References: <cover.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the printk_ratelimit() shouldn't be used anymore (see comment in
include/linux/printk.h), replace it with printk_ratelimited().

Signed-off-by: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>
---
 drivers/tty/moxa.c   |    5 +++--
 drivers/tty/mxser.c  |    4 ++--
 drivers/tty/tty_io.c |    4 ++--
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/moxa.c b/drivers/tty/moxa.c
index ba679ce..d15a071 100644
--- a/drivers/tty/moxa.c
+++ b/drivers/tty/moxa.c
@@ -44,6 +44,7 @@
 #include <linux/init.h>
 #include <linux/bitops.h>
 #include <linux/slab.h>
+#include <linux/ratelimit.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
@@ -242,8 +243,8 @@ static void moxa_wait_finish(void __iomem *ofsAddr)
 	while (readw(ofsAddr + FuncCode) != 0)
 		if (time_after(jiffies, end))
 			return;
-	if (readw(ofsAddr + FuncCode) != 0 && printk_ratelimit())
-		printk(KERN_WARNING "moxa function expired\n");
+	if (readw(ofsAddr + FuncCode) != 0)
+		printk_ratelimited(KERN_WARNING "moxa function expired\n");
 }
 
 static void moxafunc(void __iomem *ofsAddr, u16 cmd, u16 arg)
diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index d188f37..7fc8c02 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -39,6 +39,7 @@
 #include <linux/pci.h>
 #include <linux/bitops.h>
 #include <linux/slab.h>
+#include <linux/ratelimit.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
@@ -1490,8 +1491,7 @@ static int mxser_ioctl_special(unsigned int cmd, void __user *argp)
 
 	switch (cmd) {
 	case MOXA_GET_MAJOR:
-		if (printk_ratelimit())
-			printk(KERN_WARNING "mxser: '%s' uses deprecated ioctl "
+		printk_ratelimited(KERN_WARNING "mxser: '%s' uses deprecated ioctl "
 					"%x (GET_MAJOR), fix your userspace\n",
 					current->comm, cmd);
 		return put_user(ttymajor, (int __user *)argp);
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 6556f74..150e4f7 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -94,6 +94,7 @@
 #include <linux/delay.h>
 #include <linux/seq_file.h>
 #include <linux/serial.h>
+#include <linux/ratelimit.h>
 
 #include <linux/uaccess.h>
 #include <asm/system.h>
@@ -1420,8 +1421,7 @@ err_module_put:
 
 	/* call the tty release_tty routine to clean out this slot */
 err_release_tty:
-	if (printk_ratelimit())
-		printk(KERN_INFO "tty_init_dev: ldisc open failed, "
+	printk_ratelimited(KERN_INFO "tty_init_dev: ldisc open failed, "
 				 "clearing slot %d\n", idx);
 	release_tty(tty, idx);
 	return ERR_PTR(retval);
-- 
1.7.4.1

