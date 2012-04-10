Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab2DJPmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 11:42:10 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:49604 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab2DJPmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 11:42:08 -0400
Message-ID: <1334070500.16827.5.camel@key-ThinkPad-W510>
Subject: [PATCH v2 02/17] powerpc: Add pseries update notifier for OFDT prop
 changes
From: Kent Yoder <key@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, rcj@linux.vnet.ibm.com,
        key@linux.vnet.ibm.com, benh@kernel.crashing.org,
        linuxppc-dev@lists.ozlabs.org
Date: Tue, 10 Apr 2012 10:08:20 -0500
In-Reply-To: <1334070249.16827.1.camel@key-ThinkPad-W510>
References: <1334070249.16827.1.camel@key-ThinkPad-W510>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041015-5518-0000-0000-00000390E0DA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds an update notifier mechanism for changes to properties in the
device tree.  One use of this would be a device driver that needs to act
on changes to it's properties in the device tree after a live migration
or a dynamic activation that is triggered by updates to ofdt properties.

Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/pSeries_reconfig.h |   12 ++++++++++++
 arch/powerpc/platforms/pseries/reconfig.c   |    7 +++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/pSeries_reconfig.h b/arch/powerpc/include/asm/pSeries_reconfig.h
index 23cd6cc..c07edfe 100644
--- a/arch/powerpc/include/asm/pSeries_reconfig.h
+++ b/arch/powerpc/include/asm/pSeries_reconfig.h
@@ -13,6 +13,18 @@
 #define PSERIES_RECONFIG_REMOVE		0x0002
 #define PSERIES_DRCONF_MEM_ADD		0x0003
 #define PSERIES_DRCONF_MEM_REMOVE	0x0004
+#define PSERIES_UPDATE_PROPERTY		0x0005
+
+/**
+ * pSeries_reconfig_notify - Notifier value structure for OFDT property updates
+ *
+ * @node: Device tree node which owns the property being updated
+ * @property: Updated property
+ */
+struct pSeries_reconfig_prop_update {
+	struct device_node *node;
+	struct property *property;
+};
 
 #ifdef CONFIG_PPC_PSERIES
 extern int pSeries_reconfig_notifier_register(struct notifier_block *);
diff --git a/arch/powerpc/platforms/pseries/reconfig.c b/arch/powerpc/platforms/pseries/reconfig.c
index 168651a..7b3bf76 100644
--- a/arch/powerpc/platforms/pseries/reconfig.c
+++ b/arch/powerpc/platforms/pseries/reconfig.c
@@ -103,11 +103,13 @@ int pSeries_reconfig_notifier_register(struct notifier_block *nb)
 {
 	return blocking_notifier_chain_register(&pSeries_reconfig_chain, nb);
 }
+EXPORT_SYMBOL_GPL(pSeries_reconfig_notifier_register);
 
 void pSeries_reconfig_notifier_unregister(struct notifier_block *nb)
 {
 	blocking_notifier_chain_unregister(&pSeries_reconfig_chain, nb);
 }
+EXPORT_SYMBOL_GPL(pSeries_reconfig_notifier_unregister);
 
 int pSeries_reconfig_notify(unsigned long action, void *p)
 {
@@ -426,6 +428,7 @@ static int do_remove_property(char *buf, size_t bufsize)
 static int do_update_property(char *buf, size_t bufsize)
 {
 	struct device_node *np;
+	struct pSeries_reconfig_prop_update upd_value;
 	unsigned char *value;
 	char *name, *end, *next_prop;
 	int rc, length;
@@ -454,6 +457,10 @@ static int do_update_property(char *buf, size_t bufsize)
 		return -ENODEV;
 	}
 
+	upd_value.node = np;
+	upd_value.property = newprop;
+	pSeries_reconfig_notify(PSERIES_UPDATE_PROPERTY, &upd_value);
+
 	rc = prom_update_property(np, newprop, oldprop);
 	if (rc)
 		return rc;
-- 
1.7.1


