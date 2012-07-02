Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab2GBULP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 16:11:15 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36805 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197Ab2GBULO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 16:11:14 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, Stephen Boyd <sboyd@codeaurora.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Michal Simek <monstr@monstr.eu>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Suman Anna <s-anna@ti.com>, Mark Grosen <mgrosen@ti.com>
Subject: [PATCH] remoteproc: remove the get_by_name/put API
Date: Mon,  2 Jul 2012 23:10:57 +0300
Message-Id: <1341259857-17382-1-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove rproc_get_by_name() and rproc_put(), and the associated
remoteproc infrastructure that supports it (i.e. klist and friends),
because:

1. No one uses them
2. Using them is highly discouraged, and any potential user
   will be deeply scrutinized and encouraged to move.

If a user, that absolutely can't live with the direct boot/shutdown
model, does show up one day, then bringing this functionality back
is going to be trivial.

At this point though, keeping this functionality around is way too
much of a maintenance burden.

Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Sjur Brændeland <sjur.brandeland@stericsson.com>
Cc: Loic Pallardy <loic.pallardy@stericsson.com>
Cc: Ludovic BARRE <ludovic.barre@stericsson.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Fernando Guzman Lugo <fernando.lugo@ti.com>
Cc: Suman Anna <s-anna@ti.com>
Cc: Mark Grosen <mgrosen@ti.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 Documentation/remoteproc.txt         |  20 ------
 drivers/remoteproc/remoteproc_core.c | 126 -----------------------------------
 2 files changed, 146 deletions(-)

diff --git a/Documentation/remoteproc.txt b/Documentation/remoteproc.txt
index ad6ded4..f606854 100644
--- a/Documentation/remoteproc.txt
+++ b/Documentation/remoteproc.txt
@@ -56,26 +56,6 @@ cost.
         To decrement the refcount of @rproc, use rproc_put() (but _only_ if
         you acquired @rproc using rproc_get_by_name()).
 
-  struct rproc *rproc_get_by_name(const char *name)
-    - Find an rproc handle using the remote processor's name, and then
-      boot it. If it's already powered on, then just immediately return
-      (successfully). Returns the rproc handle on success, and NULL on failure.
-      This function increments the remote processor's refcount, so always
-      use rproc_put() to decrement it back once rproc isn't needed anymore.
-      Note: currently rproc_get_by_name() and rproc_put() are not used anymore
-      by the rpmsg bus and its drivers. We need to scrutinize the use cases
-      that still need them, and see if we can migrate them to use the non
-      name-based boot/shutdown interface.
-
-  void rproc_put(struct rproc *rproc)
-    - Decrement @rproc's power refcount and shut it down if it reaches zero
-      (essentially by just calling rproc_shutdown), and then decrement @rproc's
-      validity refcount too.
-      After this function returns, @rproc may _not_ be used anymore, and its
-      handle should be considered invalid.
-      This function should be called _iff_ the @rproc handle was grabbed by
-      calling rproc_get_by_name().
-
 3. Typical usage
 
 #include <linux/remoteproc.h>
diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 7c560846..283dc1e 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -36,7 +36,6 @@
 #include <linux/remoteproc.h>
 #include <linux/iommu.h>
 #include <linux/idr.h>
-#include <linux/klist.h>
 #include <linux/elf.h>
 #include <linux/virtio_ids.h>
 #include <linux/virtio_ring.h>
@@ -44,25 +43,6 @@
 
 #include "remoteproc_internal.h"
 
-static void klist_rproc_get(struct klist_node *n);
-static void klist_rproc_put(struct klist_node *n);
-
-/*
- * klist of the available remote processors.
- *
- * We need this in order to support name-based lookups (needed by the
- * rproc_get_by_name()).
- *
- * That said, we don't use rproc_get_by_name() at this point.
- * The use cases that do require its existence should be
- * scrutinized, and hopefully migrated to rproc_boot() using device-based
- * binding.
- *
- * If/when this materializes, we could drop the klist (and the by_name
- * API).
- */
-static DEFINE_KLIST(rprocs, klist_rproc_get, klist_rproc_put);
-
 typedef int (*rproc_handle_resources_t)(struct rproc *rproc,
 				struct resource_table *table, int len);
 typedef int (*rproc_handle_resource_t)(struct rproc *rproc, void *, int avail);
@@ -1274,105 +1254,6 @@ out:
 }
 EXPORT_SYMBOL(rproc_shutdown);
 
-/* will be called when an rproc is added to the rprocs klist */
-static void klist_rproc_get(struct klist_node *n)
-{
-	struct rproc *rproc = container_of(n, struct rproc, node);
-
-	get_device(&rproc->dev);
-}
-
-/* will be called when an rproc is removed from the rprocs klist */
-static void klist_rproc_put(struct klist_node *n)
-{
-	struct rproc *rproc = container_of(n, struct rproc, node);
-
-	put_device(&rproc->dev);
-}
-
-static struct rproc *next_rproc(struct klist_iter *i)
-{
-	struct klist_node *n;
-
-	n = klist_next(i);
-	if (!n)
-		return NULL;
-
-	return container_of(n, struct rproc, node);
-}
-
-/**
- * rproc_get_by_name() - find a remote processor by name and boot it
- * @name: name of the remote processor
- *
- * Finds an rproc handle using the remote processor's name, and then
- * boot it. If it's already powered on, then just immediately return
- * (successfully).
- *
- * Returns the rproc handle on success, and NULL on failure.
- *
- * This function increments the remote processor's refcount, so always
- * use rproc_put() to decrement it back once rproc isn't needed anymore.
- *
- * Note: currently this function (and its counterpart rproc_put()) are not
- * being used. We need to scrutinize the use cases
- * that still need them, and see if we can migrate them to use the non
- * name-based boot/shutdown interface.
- */
-struct rproc *rproc_get_by_name(const char *name)
-{
-	struct rproc *rproc;
-	struct klist_iter i;
-	int ret;
-
-	/* find the remote processor, and upref its refcount */
-	klist_iter_init(&rprocs, &i);
-	while ((rproc = next_rproc(&i)) != NULL)
-		if (!strcmp(rproc->name, name)) {
-			get_device(&rproc->dev);
-			break;
-		}
-	klist_iter_exit(&i);
-
-	/* can't find this rproc ? */
-	if (!rproc) {
-		pr_err("can't find remote processor %s\n", name);
-		return NULL;
-	}
-
-	ret = rproc_boot(rproc);
-	if (ret < 0) {
-		put_device(&rproc->dev);
-		return NULL;
-	}
-
-	return rproc;
-}
-EXPORT_SYMBOL(rproc_get_by_name);
-
-/**
- * rproc_put() - decrement the refcount of a remote processor, and shut it down
- * @rproc: the remote processor
- *
- * This function tries to shutdown @rproc, and it then decrements its
- * refcount.
- *
- * After this function returns, @rproc may _not_ be used anymore, and its
- * handle should be considered invalid.
- *
- * This function should be called _iff_ the @rproc handle was grabbed by
- * calling rproc_get_by_name().
- */
-void rproc_put(struct rproc *rproc)
-{
-	/* try to power off the remote processor */
-	rproc_shutdown(rproc);
-
-	/* downref rproc's refcount */
-	put_device(&rproc->dev);
-}
-EXPORT_SYMBOL(rproc_put);
-
 /**
  * rproc_register() - register a remote processor
  * @rproc: the remote processor handle to register
@@ -1402,9 +1283,6 @@ int rproc_register(struct rproc *rproc)
 	if (ret < 0)
 		return ret;
 
-	/* expose to rproc_get_by_name users */
-	klist_add_tail(&rproc->node, &rprocs);
-
 	dev_info(dev, "%s is available\n", rproc->name);
 
 	dev_info(dev, "Note: remoteproc is still under development and considered experimental.\n");
@@ -1430,7 +1308,6 @@ int rproc_register(struct rproc *rproc)
 	if (ret < 0) {
 		dev_err(dev, "request_firmware_nowait failed: %d\n", ret);
 		complete_all(&rproc->firmware_loading_complete);
-		klist_remove(&rproc->node);
 	}
 
 	return ret;
@@ -1586,9 +1463,6 @@ int rproc_unregister(struct rproc *rproc)
 	list_for_each_entry_safe(rvdev, tmp, &rproc->rvdevs, node)
 		rproc_remove_virtio_dev(rvdev);
 
-	/* the rproc is downref'ed as soon as it's removed from the klist */
-	klist_del(&rproc->node);
-
 	device_del(&rproc->dev);
 
 	return 0;
-- 
1.7.10.rc3.743.gaa3bb87

