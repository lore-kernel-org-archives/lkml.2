Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab0JSOiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 10:38:08 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61681 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab0JSOiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 10:38:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=c852t/99LGu+s1vnMSua4dz2Ji3i0tTzxMyuEHNuImRBKgpZvcC8H+d+g5wt0IBif0
         VmIE6LDenpLz8veamvlVAy0IxVLMbtt+lrPcWAzRcOjC3k7biMBvReoHKgTxuWElZDLg
         kHwDGoZZBygg+9l7WuJPwDSTx0jtBcIlC8V0w=
Subject: [PATCH] ipmi: proper spinlocks initializations
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Corey Minyard <minyard@acm.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Oct 2010 16:37:53 +0200
Message-ID: <1287499073.2676.117.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unloading ipmi module can trigger following error.
(if CONFIG_DEBUG_SPINLOCK=y)

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

Fix this by initializing spinlocks in a smi_info_alloc() helper
function, right after memory allocation and clearing.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: David Miller <davem@davemloft.net>
CC: Yinghai Lu <yinghai@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
---
CC David since I caught this error on net-next-2.6 tree ;)

 drivers/char/ipmi/ipmi_si_intf.c |   30 ++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 7bd7c45..501f115 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -1665,6 +1665,17 @@ static int check_hotmod_int_op(const char *curr, const char *option,
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
@@ -1779,7 +1790,7 @@ static int hotmod_handler(const char *val, struct kernel_param *kp)
 		}
 
 		if (op == HM_ADD) {
-			info = kzalloc(sizeof(*info), GFP_KERNEL);
+			info = smi_info_alloc();
 			if (!info) {
 				rv = -ENOMEM;
 				goto out;
@@ -1844,7 +1855,7 @@ static __devinit void hardcode_find_bmc(void)
 		if (!ports[i] && !addrs[i])
 			continue;
 
-		info = kzalloc(sizeof(*info), GFP_KERNEL);
+		info = smi_info_alloc();
 		if (!info)
 			return;
 
@@ -2028,7 +2039,7 @@ static __devinit int try_init_spmi(struct SPMITable *spmi)
 		return -ENODEV;
 	}
 
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	info = smi_info_alloc();
 	if (!info) {
 		printk(KERN_ERR PFX "Could not allocate SI data (3)\n");
 		return -ENOMEM;
@@ -2138,7 +2149,7 @@ static int __devinit ipmi_pnp_probe(struct pnp_dev *dev,
 	if (!acpi_dev)
 		return -ENODEV;
 
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	info = smi_info_alloc();
 	if (!info)
 		return -ENOMEM;
 
@@ -2319,7 +2330,7 @@ static __devinit void try_init_dmi(struct dmi_ipmi_data *ipmi_data)
 {
 	struct smi_info *info;
 
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	info = smi_info_alloc();
 	if (!info) {
 		printk(KERN_ERR PFX "Could not allocate SI data\n");
 		return;
@@ -2426,7 +2437,7 @@ static int __devinit ipmi_pci_probe(struct pci_dev *pdev,
 	int class_type = pdev->class & PCI_ERMC_CLASSCODE_TYPE_MASK;
 	struct smi_info *info;
 
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	info = smi_info_alloc();
 	if (!info)
 		return -ENOMEM;
 
@@ -2567,7 +2578,7 @@ static int __devinit ipmi_of_probe(struct platform_device *dev,
 		return -EINVAL;
 	}
 
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	info = smi_info_alloc();
 
 	if (!info) {
 		dev_err(&dev->dev,
@@ -3014,7 +3025,7 @@ static __devinit void default_find_bmc(void)
 		if (check_legacy_ioport(ipmi_defaults[i].port))
 			continue;
 #endif
-		info = kzalloc(sizeof(*info), GFP_KERNEL);
+		info = smi_info_alloc();
 		if (!info)
 			return;
 
@@ -3139,9 +3150,6 @@ static int try_smi_init(struct smi_info *new_smi)
 		goto out_err;
 	}
 
-	spin_lock_init(&(new_smi->si_lock));
-	spin_lock_init(&(new_smi->msg_lock));
-
 	/* Do low-level detection first. */
 	if (new_smi->handlers->detect(new_smi->si_sm)) {
 		if (new_smi->addr_source)


