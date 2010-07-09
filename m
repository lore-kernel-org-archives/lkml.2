Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab0GIDR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 23:17:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab0GIDR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 23:17:26 -0400
Message-ID: <4C369431.80409@ds.jp.nec.com>
Date: Thu, 08 Jul 2010 23:14:57 -0400
From: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       Vivek Goyal <vgoyal@redhat.com>
CC: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>, Ryo Tsuruta <ryov@valinux.co.jp>,
       taka@valinux.co.jp, kamezawa.hiroyu@jp.fujitsu.com,
       Andrea Righi <righi.andrea@gmail.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
       balbir@linux.vnet.ibm.com
Subject: [RFC][PATCH 01/11] blkiocg async: Make page_cgroup independent from
 memory controller
References: <4C369009.80503@ds.jp.nec.com>
In-Reply-To: <4C369009.80503@ds.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes page_cgroup independent from memory controller
so that kernel functionalities other than memory controller can
use page_cgroup.

This patch is based on a patch posted from Ryo Tsuruta on Oct 2,
2009 titled "The new page_cgroup framework".

Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
Signed-off-by: Ryo Tsuruta <ryov@valinux.co.jp>
Signed-off-by: Munehiro "Muuhh" Ikeda <m-ikeda@ds.jp.nec.com>
---
 include/linux/mmzone.h      |    4 ++--
 include/linux/page_cgroup.h |    4 ++--
 init/Kconfig                |    4 ++++
 mm/Makefile                 |    3 ++-
 4 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index b4d109e..d3a9bf7 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -612,7 +612,7 @@ typedef struct pglist_data {
 	int nr_zones;
 #ifdef CONFIG_FLAT_NODE_MEM_MAP	/* means !SPARSEMEM */
 	struct page *node_mem_map;
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+#ifdef CONFIG_CGROUP_PAGE
 	struct page_cgroup *node_page_cgroup;
 #endif
 #endif
@@ -971,7 +971,7 @@ struct mem_section {
 
 	/* See declaration of similar field in struct zone */
 	unsigned long *pageblock_flags;
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+#ifdef CONFIG_CGROUP_PAGE
 	/*
 	 * If !SPARSEMEM, pgdat doesn't have page_cgroup pointer. We use
 	 * section. (see memcontrol.h/page_cgroup.h about this.)
diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
index 5bb13b3..6a21b0d 100644
--- a/include/linux/page_cgroup.h
+++ b/include/linux/page_cgroup.h
@@ -1,7 +1,7 @@
 #ifndef __LINUX_PAGE_CGROUP_H
 #define __LINUX_PAGE_CGROUP_H
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+#ifdef CONFIG_CGROUP_PAGE
 #include <linux/bit_spinlock.h>
 /*
  * Page Cgroup can be considered as an extended mem_map.
@@ -104,7 +104,7 @@ static inline void unlock_page_cgroup(struct page_cgroup *pc)
 	bit_spin_unlock(PCG_LOCK, &pc->flags);
 }
 
-#else /* CONFIG_CGROUP_MEM_RES_CTLR */
+#else /* CONFIG_CGROUP_PAGE */
 struct page_cgroup;
 
 static inline void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat)
diff --git a/init/Kconfig b/init/Kconfig
index 5cff9a9..2e40f2f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -648,6 +648,10 @@ config DEBUG_BLK_CGROUP
 
 endif # CGROUPS
 
+config CGROUP_PAGE
+	def_bool y
+	depends on CGROUP_MEM_RES_CTLR
+
 config MM_OWNER
 	bool
 
diff --git a/mm/Makefile b/mm/Makefile
index 8982504..57b112e 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -40,7 +40,8 @@ else
 obj-y += percpu_up.o
 endif
 obj-$(CONFIG_QUICKLIST) += quicklist.o
-obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o page_cgroup.o
+obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o
+obj-$(CONFIG_CGROUP_PAGE) += page_cgroup.o
 obj-$(CONFIG_MEMORY_FAILURE) += memory-failure.o
 obj-$(CONFIG_HWPOISON_INJECT) += hwpoison-inject.o
 obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o
-- 
1.6.2.5
