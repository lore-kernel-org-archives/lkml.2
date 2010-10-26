Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab0JZBMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 21:12:23 -0400
Received: from statler.bytemark.co.uk ([212.110.162.18]:38496 "EHLO
	statler.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121Ab0JZBMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 21:12:20 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>, "Emilio G. Cota" <cota@braap.org>
Subject: [PATCH 26/30] staging/vme: move all contents of vme_bridge.h to vme.h
Date: Mon, 25 Oct 2010 21:11:12 -0400
Message-Id: <1288055476-19438-27-git-send-email-cota@braap.org>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1288055476-19438-1-git-send-email-cota@braap.org>
References: <1288055476-19438-1-git-send-email-cota@braap.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

Upcoming changes will need to have struct vme_bridge exposed
to VME drivers; do it now.

Signed-off-by: Emilio G. Cota <cota@braap.org>
---
 drivers/staging/vme/bridges/vme_ca91cx42.c |    1 -
 drivers/staging/vme/bridges/vme_tsi148.c   |    1 -
 drivers/staging/vme/vme.c                  |    1 -
 drivers/staging/vme/vme.h                  |  173 +++++++++++++++++++++++++++
 drivers/staging/vme/vme_bridge.h           |  176 ----------------------------
 5 files changed, 173 insertions(+), 179 deletions(-)
 delete mode 100644 drivers/staging/vme/vme_bridge.h

diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
index 6dd895f..b91c130 100644
--- a/drivers/staging/vme/bridges/vme_ca91cx42.c
+++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
@@ -31,7 +31,6 @@
 #include <linux/uaccess.h>
 
 #include "../vme.h"
-#include "../vme_bridge.h"
 #include "vme_ca91cx42.h"
 
 static int __init ca91cx42_init(void);
diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
index 3ef5f48..80a9829 100644
--- a/drivers/staging/vme/bridges/vme_tsi148.c
+++ b/drivers/staging/vme/bridges/vme_tsi148.c
@@ -31,7 +31,6 @@
 #include <linux/uaccess.h>
 
 #include "../vme.h"
-#include "../vme_bridge.h"
 #include "vme_tsi148.h"
 
 static int __init tsi148_init(void);
diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
index 10a6435..96eb98e 100644
--- a/drivers/staging/vme/vme.c
+++ b/drivers/staging/vme/vme.c
@@ -32,7 +32,6 @@
 #include <linux/slab.h>
 
 #include "vme.h"
-#include "vme_bridge.h"
 
 /*
  * List of registered buses (bridges) and available bus numbers, both protected
diff --git a/drivers/staging/vme/vme.h b/drivers/staging/vme/vme.h
index 5cdfa52..1c9ab64 100644
--- a/drivers/staging/vme/vme.h
+++ b/drivers/staging/vme/vme.h
@@ -107,6 +107,174 @@ struct vme_driver {
 	struct device_driver    driver;
 };
 
+#define VME_CRCSR_BUF_SIZE (508*1024)
+#define VME_SLOTS_MAX 32
+/*
+ * Resource structures
+ */
+struct vme_master_resource {
+	struct list_head list;
+	struct vme_bridge *parent;
+	/*
+	 * We are likely to need to access the VME bus in interrupt context, so
+	 * protect master routines with a spinlock rather than a mutex.
+	 */
+	spinlock_t lock;
+	int locked;
+	int number;
+	vme_address_t address_attr;
+	vme_cycle_t cycle_attr;
+	vme_width_t width_attr;
+	struct resource bus_resource;
+	void __iomem *kern_base;
+};
+
+struct vme_slave_resource {
+	struct list_head list;
+	struct vme_bridge *parent;
+	struct mutex mtx;
+	int locked;
+	int number;
+	vme_address_t address_attr;
+	vme_cycle_t cycle_attr;
+};
+
+struct vme_dma_pattern {
+	u32 pattern;
+	vme_pattern_t type;
+};
+
+struct vme_dma_pci {
+	dma_addr_t address;
+};
+
+struct vme_dma_vme {
+	unsigned long long address;
+	vme_address_t aspace;
+	vme_cycle_t cycle;
+	vme_width_t dwidth;
+};
+
+struct vme_dma_list {
+	struct list_head list;
+	struct vme_dma_resource *parent;
+	struct list_head entries;
+	struct mutex mtx;
+};
+
+struct vme_dma_resource {
+	struct list_head list;
+	struct vme_bridge *parent;
+	struct mutex mtx;
+	int locked;
+	int number;
+	struct list_head pending;
+	struct list_head running;
+	vme_dma_route_t route_attr;
+};
+
+struct vme_lm_resource {
+	struct list_head list;
+	struct vme_bridge *parent;
+	struct mutex mtx;
+	int locked;
+	int number;
+	int monitors;
+};
+
+struct vme_bus_error {
+	struct list_head list;
+	unsigned long long address;
+	u32 attributes;
+};
+
+struct vme_callback {
+	void (*func)(int, int, void*);
+	void *priv_data;
+};
+
+struct vme_irq {
+	int count;
+	struct vme_callback callback[255];
+};
+
+/* Allow 16 characters for name (including null character) */
+#define VMENAMSIZ 16
+
+/* This structure stores all the information about one bridge
+ * The structure should be dynamically allocated by the driver and one instance
+ * of the structure should be present for each VME chip present in the system.
+ *
+ * Currently we assume that all chips are PCI-based
+ */
+struct vme_bridge {
+	char name[VMENAMSIZ];
+	int num;
+	struct list_head master_resources;
+	struct list_head slave_resources;
+	struct list_head dma_resources;
+	struct list_head lm_resources;
+
+	struct list_head vme_errors;	/* List for errors generated on VME */
+
+	/* Bridge Info - XXX Move to private structure? */
+	struct device *parent;	/* Generic device struct (pdev->dev for PCI) */
+	struct list_head buses_list;
+	void *driver_priv;	/* Private pointer for the bridge driver */
+
+	struct device dev[VME_SLOTS_MAX];	/* Device registered with
+						 * device model on VME bus
+						 */
+
+	/* Interrupt callbacks */
+	struct vme_irq irq[7];
+	/* Locking for VME irq callback configuration */
+	struct mutex irq_mtx;
+
+	/* Slave Functions */
+	int (*slave_get) (struct vme_slave_resource *, int *,
+		unsigned long long *, unsigned long long *, dma_addr_t *,
+		vme_address_t *, vme_cycle_t *);
+	int (*slave_set) (struct vme_slave_resource *, int, unsigned long long,
+		unsigned long long, dma_addr_t, vme_address_t, vme_cycle_t);
+
+	/* Master Functions */
+	int (*master_get) (struct vme_master_resource *, int *,
+		unsigned long long *, unsigned long long *, vme_address_t *,
+		vme_cycle_t *, vme_width_t *);
+	int (*master_set) (struct vme_master_resource *, int,
+		unsigned long long, unsigned long long,  vme_address_t,
+		vme_cycle_t, vme_width_t);
+	ssize_t (*master_read) (struct vme_master_resource *, void *, size_t,
+		loff_t);
+	ssize_t (*master_write) (struct vme_master_resource *, void *, size_t,
+		loff_t);
+	unsigned int (*master_rmw) (struct vme_master_resource *, unsigned int,
+		unsigned int, unsigned int, loff_t);
+
+	/* DMA Functions */
+	int (*dma_list_add) (struct vme_dma_list *, struct vme_dma_attr *,
+		struct vme_dma_attr *, size_t);
+	int (*dma_list_exec) (struct vme_dma_list *);
+	int (*dma_list_empty) (struct vme_dma_list *);
+
+	/* Interrupt Functions */
+	void (*irq_set) (struct vme_bridge *, int, int, int);
+	int (*irq_generate) (struct vme_bridge *, int, int);
+
+	/* Location monitor functions */
+	int (*lm_set) (struct vme_lm_resource *, unsigned long long,
+		vme_address_t, vme_cycle_t);
+	int (*lm_get) (struct vme_lm_resource *, unsigned long long *,
+		vme_address_t *, vme_cycle_t *);
+	int (*lm_attach) (struct vme_lm_resource *, int, void (*callback)(int));
+	int (*lm_detach) (struct vme_lm_resource *, int);
+
+	/* CR/CSR space functions */
+	int (*slot_get) (struct vme_bridge *);
+};
+
+/* functions for VME drivers */
 void *vme_alloc_consistent(struct vme_resource *, size_t, dma_addr_t *);
 void vme_free_consistent(struct vme_resource *, size_t,  void *,
 	dma_addr_t);
@@ -166,6 +334,11 @@ int vme_slot_get(struct device *);
 int vme_register_driver(struct vme_driver *);
 void vme_unregister_driver(struct vme_driver *);
 
+/* functions for VME bridges */
+void vme_irq_handler(struct vme_bridge *, int, int);
+int vme_register_bridge(struct vme_bridge *);
+void vme_unregister_bridge(struct vme_bridge *);
+
 
 #endif /* _VME_H_ */
 
diff --git a/drivers/staging/vme/vme_bridge.h b/drivers/staging/vme/vme_bridge.h
deleted file mode 100644
index 3bb1d7b..0000000
--- a/drivers/staging/vme/vme_bridge.h
+++ /dev/null
@@ -1,176 +0,0 @@
-#ifndef _VME_BRIDGE_H_
-#define _VME_BRIDGE_H_
-
-#define VME_CRCSR_BUF_SIZE (508*1024)
-#define VME_SLOTS_MAX 32
-/*
- * Resource structures
- */
-struct vme_master_resource {
-	struct list_head list;
-	struct vme_bridge *parent;
-	/*
-	 * We are likely to need to access the VME bus in interrupt context, so
-	 * protect master routines with a spinlock rather than a mutex.
-	 */
-	spinlock_t lock;
-	int locked;
-	int number;
-	vme_address_t address_attr;
-	vme_cycle_t cycle_attr;
-	vme_width_t width_attr;
-	struct resource bus_resource;
-	void __iomem *kern_base;
-};
-
-struct vme_slave_resource {
-	struct list_head list;
-	struct vme_bridge *parent;
-	struct mutex mtx;
-	int locked;
-	int number;
-	vme_address_t address_attr;
-	vme_cycle_t cycle_attr;
-};
-
-struct vme_dma_pattern {
-	u32 pattern;
-	vme_pattern_t type;
-};
-
-struct vme_dma_pci {
-	dma_addr_t address;
-};
-
-struct vme_dma_vme {
-	unsigned long long address;
-	vme_address_t aspace;
-	vme_cycle_t cycle;
-	vme_width_t dwidth;
-};
-
-struct vme_dma_list {
-	struct list_head list;
-	struct vme_dma_resource *parent;
-	struct list_head entries;
-	struct mutex mtx;
-};
-
-struct vme_dma_resource {
-	struct list_head list;
-	struct vme_bridge *parent;
-	struct mutex mtx;
-	int locked;
-	int number;
-	struct list_head pending;
-	struct list_head running;
-	vme_dma_route_t route_attr;
-};
-
-struct vme_lm_resource {
-	struct list_head list;
-	struct vme_bridge *parent;
-	struct mutex mtx;
-	int locked;
-	int number;
-	int monitors;
-};
-
-struct vme_bus_error {
-	struct list_head list;
-	unsigned long long address;
-	u32 attributes;
-};
-
-struct vme_callback {
-	void (*func)(int, int, void*);
-	void *priv_data;
-};
-
-struct vme_irq {
-	int count;
-	struct vme_callback callback[255];
-};
-
-/* Allow 16 characters for name (including null character) */
-#define VMENAMSIZ 16
-
-/* This structure stores all the information about one bridge
- * The structure should be dynamically allocated by the driver and one instance
- * of the structure should be present for each VME chip present in the system.
- *
- * Currently we assume that all chips are PCI-based
- */
-struct vme_bridge {
-	char name[VMENAMSIZ];
-	int num;
-	struct list_head master_resources;
-	struct list_head slave_resources;
-	struct list_head dma_resources;
-	struct list_head lm_resources;
-
-	struct list_head vme_errors;	/* List for errors generated on VME */
-
-	/* Bridge Info - XXX Move to private structure? */
-	struct device *parent;	/* Generic device struct (pdev->dev for PCI) */
-	struct list_head buses_list;
-	void *driver_priv;	/* Private pointer for the bridge driver */
-
-	struct device dev[VME_SLOTS_MAX];	/* Device registered with
-						 * device model on VME bus
-						 */
-
-	/* Interrupt callbacks */
-	struct vme_irq irq[7];
-	/* Locking for VME irq callback configuration */
-	struct mutex irq_mtx;
-
-	/* Slave Functions */
-	int (*slave_get) (struct vme_slave_resource *, int *,
-		unsigned long long *, unsigned long long *, dma_addr_t *,
-		vme_address_t *, vme_cycle_t *);
-	int (*slave_set) (struct vme_slave_resource *, int, unsigned long long,
-		unsigned long long, dma_addr_t, vme_address_t, vme_cycle_t);
-
-	/* Master Functions */
-	int (*master_get) (struct vme_master_resource *, int *,
-		unsigned long long *, unsigned long long *, vme_address_t *,
-		vme_cycle_t *, vme_width_t *);
-	int (*master_set) (struct vme_master_resource *, int,
-		unsigned long long, unsigned long long,  vme_address_t,
-		vme_cycle_t, vme_width_t);
-	ssize_t (*master_read) (struct vme_master_resource *, void *, size_t,
-		loff_t);
-	ssize_t (*master_write) (struct vme_master_resource *, void *, size_t,
-		loff_t);
-	unsigned int (*master_rmw) (struct vme_master_resource *, unsigned int,
-		unsigned int, unsigned int, loff_t);
-
-	/* DMA Functions */
-	int (*dma_list_add) (struct vme_dma_list *, struct vme_dma_attr *,
-		struct vme_dma_attr *, size_t);
-	int (*dma_list_exec) (struct vme_dma_list *);
-	int (*dma_list_empty) (struct vme_dma_list *);
-
-	/* Interrupt Functions */
-	void (*irq_set) (struct vme_bridge *, int, int, int);
-	int (*irq_generate) (struct vme_bridge *, int, int);
-
-	/* Location monitor functions */
-	int (*lm_set) (struct vme_lm_resource *, unsigned long long,
-		vme_address_t, vme_cycle_t);
-	int (*lm_get) (struct vme_lm_resource *, unsigned long long *,
-		vme_address_t *, vme_cycle_t *);
-	int (*lm_attach) (struct vme_lm_resource *, int, void (*callback)(int));
-	int (*lm_detach) (struct vme_lm_resource *, int);
-
-	/* CR/CSR space functions */
-	int (*slot_get) (struct vme_bridge *);
-};
-
-void vme_irq_handler(struct vme_bridge *, int, int);
-
-int vme_register_bridge(struct vme_bridge *);
-void vme_unregister_bridge(struct vme_bridge *);
-
-#endif /* _VME_BRIDGE_H_ */
-- 
1.7.1

