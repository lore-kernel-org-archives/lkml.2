Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab0LMATP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:19:15 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44926 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab0LLXqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:04 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: eric.dumazet@gmail.com, davem@davemloft.net, yinghai@kernel.org,
        cminyard@mvista.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [65/223] ipmi: proper spinlock initialization
Message-Id: <20101212234603.6B231B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:03 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Eric Dumazet <eric.dumazet@gmail.com>

commit de5e2ddf9bb3ce7b643223b9b0718062254f302f upstream.

Unloading ipmi module can trigger following error.  (if
CONFIG_DEBUG_SPINLOCK=y)

[ 9633.779590] BUG: spinlock bad magic on CPU#1, rmmod/7170
[ 9633.779606]  lock: f41f5414, .magic: 00000000, .owner:
<none>/-1, .owner_cpu: 0
[ 9633.779626] Pid: 7170, comm: rmmod Not tainted
2.6.36-rc7-11474-gb71eb1e-dirty #328
[ 9633.779644] Call Trace:
[ 9633.779657]  [<c13921cc>] ? printk+0x18/0x1c
[ 9633.779672]  [<c11a1f33>] spin_bug+0xa3/0xf0
[ 9633.779685]  [<c11a1ffd>] do_raw_spin_lock+0x7d/0x160
[ 9633.779702]  [<c1131537>] ? release_sysfs_dirent+0x47/0xb0
[ 9633.779718]  [<c1131b78>] ? sysfs_addrm_finish+0xa8/0xd0
[ 9633.779734]  [<c1394bac>] _raw_spin_lock_irqsave+0xc/0x20
[ 9633.779752]  [<f99d93da>] cleanup_one_si+0x6a/0x200 [ipmi_si]
[ 9633.779768]  [<c11305b2>] ? sysfs_hash_and_remove+0x72/0x80
[ 9633.779786]  [<f99dcf26>] ipmi_pnp_remove+0xd/0xf [ipmi_si]
[ 9633.779802]  [<c11f622b>] pnp_device_remove+0x1b/0x40

Fix this by initializing spinlocks in a smi_info_alloc() helper function,
right after memory allocation and clearing.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: David Miller <davem@davemloft.net>
Cc: Yinghai Lu <yinghai@kernel.org>
Acked-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/char/ipmi/ipmi_si_intf.c |   30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

Index: linux/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux/drivers/char/ipmi/ipmi_si_intf.c
@@ -1662,6 +1662,17 @@ static int check_hotmod_int_op(const cha
 	return 0;
 }
 
+static struct smi_info *smi_info_alloc(void)
+{
+	struct smi_info *info = kzalloc(sizeof(*info), GFP_KERNEL);
+
+	if (info) {
+		spin_lock_init(&info->si_lock);
+		spin_lock_init(&info->msg_lock);
+	}
+	return info;
+}
+
 static int hotmod_handler(const char *val, struct kernel_param *kp)
 {
 	char *str = kstrdup(val, GFP_KERNEL);
@@ -1776,7 +1787,7 @@ static int hotmod_handler(const char *va
 		}
 
 		if (op == HM_ADD) {
-			info = kzalloc(sizeof(*info), GFP_KERNEL);
+			info = smi_info_alloc();
 			if (!info) {
 				rv = -ENOMEM;
 				goto out;
@@ -1838,7 +1849,7 @@ static __devinit void hardcode_find_bmc(
 		if (!ports[i] && !addrs[i])
 			continue;
 
-		info = kzalloc(sizeof(*info), GFP_KERNEL);
+		info = smi_info_alloc();
 		if (!info)
 			return;
 
@@ -2025,7 +2036,7 @@ static __devinit int try_init_spmi(struc
 	else
 		addr_space = IPMI_IO_ADDR_SPACE;
 
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	info = smi_info_alloc();
 	if (!info) {
 		printk(KERN_ERR PFX "Could not allocate SI data (3)\n");
 		return -ENOMEM;
@@ -2129,7 +2140,7 @@ static int __devinit ipmi_pnp_probe(stru
 	if (!acpi_dev)
 		return -ENODEV;
 
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	info = smi_info_alloc();
 	if (!info)
 		return -ENOMEM;
 
@@ -2307,7 +2318,7 @@ static __devinit void try_init_dmi(struc
 {
 	struct smi_info *info;
 
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	info = smi_info_alloc();
 	if (!info) {
 		printk(KERN_ERR PFX "Could not allocate SI data\n");
 		return;
@@ -2408,7 +2419,7 @@ static int __devinit ipmi_pci_probe(stru
 	int class_type = pdev->class & PCI_ERMC_CLASSCODE_TYPE_MASK;
 	struct smi_info *info;
 
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	info = smi_info_alloc();
 	if (!info)
 		return -ENOMEM;
 
@@ -2546,7 +2557,7 @@ static int __devinit ipmi_of_probe(struc
 		return -EINVAL;
 	}
 
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	info = smi_info_alloc();
 
 	if (!info) {
 		dev_err(&dev->dev,
@@ -2988,7 +2999,7 @@ static __devinit void default_find_bmc(v
 		if (check_legacy_ioport(ipmi_defaults[i].port))
 			continue;
 #endif
-		info = kzalloc(sizeof(*info), GFP_KERNEL);
+		info = smi_info_alloc();
 		if (!info)
 			return;
 
@@ -3111,9 +3122,6 @@ static int try_smi_init(struct smi_info
 		goto out_err;
 	}
 
-	spin_lock_init(&(new_smi->si_lock));
-	spin_lock_init(&(new_smi->msg_lock));
-
 	/* Do low-level detection first. */
 	if (new_smi->handlers->detect(new_smi->si_sm)) {
 		if (new_smi->addr_source)
