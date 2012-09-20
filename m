Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab2ITRBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 13:01:23 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:49771 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407Ab2ITRBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 13:01:21 -0400
From: ciminaghi@gnudd.com
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        rubini@gnudd.com, sameo@linux.intel.com
Cc: giancarlo.asnaghi@st.com, linux-kernel@vger.kernel.org,
        Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH 1/2] x86, pci sta2x11-fixup: add clk related field to struct sta2x11_instance
Date: Thu, 20 Sep 2012 18:44:08 +0200
Message-Id: <1348159449-21583-2-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1348159449-21583-1-git-send-email-ciminaghi@gnudd.com>
References: <1348159449-21583-1-git-send-email-ciminaghi@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>

Use struct sta2x11_instance for storing a pointer to an array
of struct clk pointers representing the set of clocks belonging
to a single connext chip.
Since sta2x11_instance is an opaque type, we also add functions to
access the new field.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
---
 arch/x86/include/asm/sta2x11.h |   16 ++++++++++++++++
 arch/x86/pci/sta2x11-fixup.c   |   14 ++++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/sta2x11.h b/arch/x86/include/asm/sta2x11.h
index e9d32df..2b5d8bc 100644
--- a/arch/x86/include/asm/sta2x11.h
+++ b/arch/x86/include/asm/sta2x11.h
@@ -5,8 +5,24 @@
 #define __ASM_STA2X11_H
 
 #include <linux/pci.h>
+#include <linux/clk.h>
 
 /* This needs to be called from the MFD to configure its sub-devices */
 struct sta2x11_instance *sta2x11_get_instance(struct pci_dev *pdev);
 
+/*
+ * Return instance id
+ */
+int sta2x11_get_instance_id(struct sta2x11_instance *instance);
+
+/*
+ * Add clks array to instance. This is called by clock common API
+ */
+void sta2x11_instance_add_clks(struct sta2x11_instance *, struct clk **);
+
+/*
+ * Returns clks array of instance. This is called by clock common API
+ */
+struct clk **sta2x11_instance_get_clks(struct sta2x11_instance *);
+
 #endif /* __ASM_STA2X11_H */
diff --git a/arch/x86/pci/sta2x11-fixup.c b/arch/x86/pci/sta2x11-fixup.c
index 9d8a509..478c228 100644
--- a/arch/x86/pci/sta2x11-fixup.c
+++ b/arch/x86/pci/sta2x11-fixup.c
@@ -27,6 +27,8 @@
 #include <linux/export.h>
 #include <linux/list.h>
 
+#include <asm/sta2x11.h>
+
 #define STA2X11_SWIOTLB_SIZE (4*1024*1024)
 extern int swiotlb_late_init_with_default_size(size_t default_size);
 
@@ -52,6 +54,7 @@ struct sta2x11_instance {
 	struct list_head list;
 	int bus0;
 	struct sta2x11_mapping map[STA2X11_NR_EP];
+	struct clk **clks;
 };
 
 static LIST_HEAD(sta2x11_instance_list);
@@ -78,6 +81,17 @@ static void sta2x11_new_instance(struct pci_dev *pdev)
 }
 DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_STMICRO, 0xcc17, sta2x11_new_instance);
 
+void sta2x11_instance_add_clks(struct sta2x11_instance *instance,
+			       struct clk **clks)
+{
+	instance->clks = clks;
+}
+
+struct clk **sta2x11_instance_get_clks(struct sta2x11_instance *instance)
+{
+	return instance->clks;
+}
+
 /*
  * Utility functions used in this file from below
  */
-- 
1.7.9.1

