Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778Ab1BWVvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 16:51:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:57083 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399Ab1BWVva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 16:51:30 -0500
Date: Wed, 23 Feb 2011 21:51:12 GMT
From: tip-bot for Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca, hpa@zytor.com,
        mingo@redhat.com, dirk.brandewie@gmail.com, bigeasy@linutronix.de,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, dirk.brandewie@gmail.com,
        tglx@linutronix.de, bigeasy@linutronix.de
In-Reply-To: <1298405266-1624-7-git-send-email-bigeasy@linutronix.de>
References: <1298405266-1624-7-git-send-email-bigeasy@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86: dtb: Add device tree support for HPET
Message-ID: <tip-ffb9fc68dff38f811eeb24c15aba0418b6a8ee53@git.kernel.org>
Git-Commit-ID: ffb9fc68dff38f811eeb24c15aba0418b6a8ee53
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Feb 2011 21:51:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ffb9fc68dff38f811eeb24c15aba0418b6a8ee53
Gitweb:     http://git.kernel.org/tip/ffb9fc68dff38f811eeb24c15aba0418b6a8ee53
Author:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
AuthorDate: Tue, 22 Feb 2011 21:07:41 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 23 Feb 2011 22:27:53 +0100

x86: dtb: Add device tree support for HPET

Set hpet_address based on information provied form DTB

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Cc: sodaville@linutronix.de
Cc: devicetree-discuss@lists.ozlabs.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
LKML-Reference: <1298405266-1624-7-git-send-email-bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/devicetree.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 2739d56..dbb3bda 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -11,6 +11,7 @@
 #include <linux/of_platform.h>
 #include <linux/slab.h>
 
+#include <asm/hpet.h>
 #include <asm/irq_controller.h>
 #include <asm/apic.h>
 
@@ -98,6 +99,23 @@ void __init add_dtb(u64 data)
 	initial_dtb = data + offsetof(struct setup_data, data);
 }
 
+static void __init dtb_setup_hpet(void)
+{
+	struct device_node *dn;
+	struct resource r;
+	int ret;
+
+	dn = of_find_compatible_node(NULL, NULL, "intel,ce4100-hpet");
+	if (!dn)
+		return;
+	ret = of_address_to_resource(dn, 0, &r);
+	if (ret) {
+		WARN_ON(1);
+		return;
+	}
+	hpet_address = r.start;
+}
+
 static void __init dtb_lapic_setup(void)
 {
 #ifdef CONFIG_X86_LOCAL_APIC
@@ -197,5 +215,6 @@ void __init x86_dtb_get_config(unsigned int unused)
 	of_scan_flat_dt(early_init_dt_scan_root, NULL);
 
 	unflatten_device_tree();
+	dtb_setup_hpet();
 	dtb_apic_setup();
 }
