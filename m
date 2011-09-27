Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab1I0VlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 17:41:24 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42576 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760Ab1I0VlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 17:41:22 -0400
From: jim.cromie@gmail.com
To: joe@perches.com
Cc: jbaron@redhat.com, greg@kroah.com, linux-kernel@vger.kernel.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 26/26] scx200_acb: use pr_(info|warn|err|debug) and dynamic-debug facilities
Date: Tue, 27 Sep 2011 15:41:00 -0600
Message-Id: <1317159660-2506-3-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1317159660-2506-1-git-send-email-jim.cromie@gmail.com>
References: <1316725066.29447.16.camel@Joe-Laptop>
 <1317159660-2506-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Switch this driver over to using more flexible dynamic-debug by
dropping NAME from pr_debug(NAME ": ...") calls, and adding it once
via pr_fmt().  With previous patch and CONFIG_I2C_DEBUG_BUS=y, we
get pr_debug()s enabled by default:

root@voyage:~# modprobe scx200_acb
root@voyage:~# grep scx200_acb /dbg/dynamic_debug/control
drivers/i2c/busses/scx200_acb.c:419 [scx200_acb]scx200_acb_probe =p "..."
drivers/i2c/busses/scx200_acb.c:408 [scx200_acb]scx200_acb_probe =p "..."
drivers/i2c/busses/scx200_acb.c:399 [scx200_acb]scx200_acb_probe =p "..."
drivers/i2c/busses/scx200_acb.c:584 [scx200_acb]scx200_acb_init =p "..."

The pr_fmt() adds the KBUILD_MODNAME to pr_err(), etc outputs, the
pr_fmt_debug() overrides that default, letting user do so selectively
via dynamic-debug.  This override affects a non DYNAMIC_DEBUG build
too; we could fix this by making it conditional, but doing so in
printk.h may be better.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 drivers/i2c/busses/scx200_acb.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/i2c/busses/scx200_acb.c b/drivers/i2c/busses/scx200_acb.c
index 986e5f6..34d89d6 100644
--- a/drivers/i2c/busses/scx200_acb.c
+++ b/drivers/i2c/busses/scx200_acb.c
@@ -23,6 +23,9 @@
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#define pr_fmt_debug(fmt) fmt
+
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
@@ -37,8 +40,6 @@
 
 #include <linux/scx200.h>
 
-#define NAME "scx200_acb"
-
 MODULE_AUTHOR("Christer Weinigel <wingel@nano-system.com>");
 MODULE_DESCRIPTION("NatSemi SCx200 ACCESS.bus Driver");
 MODULE_ALIAS("platform:cs5535-smb");
@@ -398,7 +399,7 @@ static __devinit int scx200_acb_probe(struct scx200_acb_iface *iface)
 	outb(0x70, ACBCTL2);
 
 	if (inb(ACBCTL2) != 0x70) {
-		pr_debug(NAME ": ACBCTL2 readback failed\n");
+		pr_debug("ACBCTL2 readback failed\n");
 		return -ENXIO;
 	}
 
@@ -406,7 +407,7 @@ static __devinit int scx200_acb_probe(struct scx200_acb_iface *iface)
 
 	val = inb(ACBCTL1);
 	if (val) {
-		pr_debug(NAME ": disabled, but ACBCTL1=0x%02x\n",
+		pr_debug("disabled, but ACBCTL1=0x%02x\n",
 			val);
 		return -ENXIO;
 	}
@@ -417,7 +418,7 @@ static __devinit int scx200_acb_probe(struct scx200_acb_iface *iface)
 
 	val = inb(ACBCTL1);
 	if ((val & ACBCTL1_NMINTE) != ACBCTL1_NMINTE) {
-		pr_debug(NAME ": enabled, but NMINTE won't be set, "
+		pr_debug("enabled, but NMINTE won't be set, "
 			 "ACBCTL1=0x%02x\n", val);
 		return -ENXIO;
 	}
@@ -433,7 +434,7 @@ static __devinit struct scx200_acb_iface *scx200_create_iface(const char *text,
 
 	iface = kzalloc(sizeof(*iface), GFP_KERNEL);
 	if (!iface) {
-		printk(KERN_ERR NAME ": can't allocate memory\n");
+		pr_err("can't allocate memory\n");
 		return NULL;
 	}
 
@@ -459,14 +460,14 @@ static int __devinit scx200_acb_create(struct scx200_acb_iface *iface)
 
 	rc = scx200_acb_probe(iface);
 	if (rc) {
-		printk(KERN_WARNING NAME ": probe failed\n");
+		pr_warn("probe failed\n");
 		return rc;
 	}
 
 	scx200_acb_reset(iface);
 
 	if (i2c_add_adapter(adapter) < 0) {
-		printk(KERN_ERR NAME ": failed to register\n");
+		pr_err("failed to register\n");
 		return -ENODEV;
 	}
 
@@ -493,7 +494,7 @@ static struct scx200_acb_iface * __devinit scx200_create_dev(const char *text,
 		return NULL;
 
 	if (!request_region(base, 8, iface->adapter.name)) {
-		printk(KERN_ERR NAME ": can't allocate io 0x%lx-0x%lx\n",
+		pr_err("can't allocate io 0x%lx-0x%lx\n",
 		       base, base + 8 - 1);
 		goto errout_free;
 	}
@@ -583,7 +584,7 @@ static __init void scx200_scan_isa(void)
 
 static int __init scx200_acb_init(void)
 {
-	pr_debug(NAME ": NatSemi SCx200 ACCESS.bus Driver\n");
+	pr_debug("NatSemi SCx200 ACCESS.bus Driver\n");
 
 	/* First scan for ISA-based devices */
 	scx200_scan_isa();	/* XXX: should we care about errors? */
-- 
1.7.4.4

