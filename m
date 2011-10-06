Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759126Ab1JFT2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 15:28:50 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:51274 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab1JFT2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 15:28:48 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: gregkh@suse.de
Cc: cascardo@holoscopio.com, dan.magenheimer@oracle.com, rdunlap@xenotime.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dave@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com, ngupta@vflare.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: [PATCH] staging: zcache: fix crash on cpu remove
Date: Thu,  6 Oct 2011 14:28:26 -0500
Message-Id: <1317929306-18471-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case that a cpu is taken offline before zcache_do_preload() is
ever called on the cpu, the per-cpu zcache_preloads structure will
be uninitialized.  In the CPU_DEAD case for zcache_cpu_notifier(),
kp->obj is not checked before calling kmem_cache_free() on it.
If it is NULL, a crash results.

This patch ensures that both kp->obj and kp->page are not NULL before
calling the respective free functions. In practice, just checking
one or the other should be sufficient since they are assigned together
in zcache_do_preload(), but I check both for safety.

Based on v3.1-rc8

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 drivers/staging/zcache/zcache-main.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 462fbc2..41d1ba1 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -1357,8 +1357,14 @@ static int zcache_cpu_notifier(struct notifier_block *nb,
 			kp->objnodes[kp->nr - 1] = NULL;
 			kp->nr--;
 		}
-		kmem_cache_free(zcache_obj_cache, kp->obj);
-		free_page((unsigned long)kp->page);
+		if (kp->obj) {
+			kmem_cache_free(zcache_obj_cache, kp->obj);
+			kp->obj = NULL;
+		}
+		if (kp->page) {
+			free_page((unsigned long)kp->page);
+			kp->page = NULL;
+		}
 		break;
 	default:
 		break;
-- 
1.7.4.1

