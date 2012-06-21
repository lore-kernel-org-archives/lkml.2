Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab2FUBUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 21:20:55 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:59306 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215Ab2FUBUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 21:20:53 -0400
From: Davide Ciminaghi <dciminaghi@mail.gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: giancarlo.asnaghi@st.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, rubini@gnudd.com,
        Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH] sta2x11-fixup : add clk related fields to struct sta2x11_instance
Date: Thu, 21 Jun 2012 03:04:27 +0200
Message-Id: <1340240667-3237-1-git-send-email-dciminaghi@mail.gnudd.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>

sta2x11_instance is still opaque, so we also add functions to
access some of its fields.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
---

Hi,

I'm implementing the common clock framework for the STA2X11.
Since more than one connext chip could be present on a single board, I could
also have multiple instances of the clocks tree. As a consequence, I need
to modify the structure representing a sta2x11 chip by adding a pointer to the
relevant clock tree. Being struct sta2x11_instance opaque, some functions are
also needed to access its fields from outside sta2x11-fixup.

Davide

 arch/x86/include/asm/sta2x11.h |   16 ++++++++++++++++
 arch/x86/pci/sta2x11-fixup.c   |   20 ++++++++++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

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
index 9d8a509..6450853 100644
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
@@ -124,6 +138,12 @@ struct sta2x11_instance *sta2x11_get_instance(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL(sta2x11_get_instance);
 
+int sta2x11_get_instance_id(struct sta2x11_instance *instance)
+{
+	return instance->bus0;
+}
+EXPORT_SYMBOL(sta2x11_get_instance_id);
+
 
 /**
  * p2a - Translate physical address to STA2x11 AMBA address,
-- 
1.7.9.1

