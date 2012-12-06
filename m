Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424382Ab2LFQUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 11:20:24 -0500
Received: from mail.tpi.com ([70.99.223.143]:4518 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1424087Ab2LFQUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 11:20:23 -0500
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, David Airlie <airlied@linux.ie>,
        Dave Airlie <airlied@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Zhao Yakui <yakui.zhao@intel.com>, David Howells <dhowells@redhat.com>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 3.7-rc8] ttm: Fix possible _manager memory allocation oops
Date: Thu,  6 Dec 2012 09:20:06 -0700
Message-Id: <1354810806-81681-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory for _manager is allocated using kzalloc() but the result is not checked.

Free _manager on error lest memory become orphaned.

I was led to scrutinize ttm_page_alloc_init() from a smatch warning:

drivers/gpu/drm/ttm/ttm_page_alloc.c:799 ttm_page_alloc_init() error: potential null dereference '_manager'.  (kzalloc returns null)

Cc: David Airlie <airlied@linux.ie>
Cc: Dave Airlie <airlied@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>
Cc: David Howells <dhowells@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: stable@vger.kernel.org # 3.5+
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---

This patch applies to stable 3.5 and newer.

 drivers/gpu/drm/ttm/ttm_page_alloc.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
index bd2a3b4..2c73d0a 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -798,6 +798,10 @@ int ttm_page_alloc_init(struct ttm_mem_global *glob, unsigned max_pages)
 	pr_info("Initializing pool allocator\n");
 
 	_manager = kzalloc(sizeof(*_manager), GFP_KERNEL);
+	if (!_manager) {
+		pr_err("ttm: Could not allocate _manager.\n");
+		return -ENOMEM;
+	}
 
 	ttm_page_pool_init_locked(&_manager->wc_pool, GFP_HIGHUSER, "wc");
 
@@ -817,6 +821,7 @@ int ttm_page_alloc_init(struct ttm_mem_global *glob, unsigned max_pages)
 				   &glob->kobj, "pool");
 	if (unlikely(ret != 0)) {
 		kobject_put(&_manager->kobj);
+		kfree(_manager);
 		_manager = NULL;
 		return ret;
 	}
-- 
1.7.9.5

