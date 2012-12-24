Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab2LXMNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 07:13:21 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:12358 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752623Ab2LXMKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 07:10:31 -0500
X-IronPort-AV: E=Sophos;i="4.84,347,1355068800"; 
   d="scan'208";a="6464036"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: akpm@linux-foundation.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, benh@kernel.crashing.org, paulus@samba.org,
        cl@linux.com, minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, wujianguo@huawei.com,
        wency@cn.fujitsu.com, tangchen@cn.fujitsu.com, hpa@zytor.com,
        linfeng@cn.fujitsu.com, laijs@cn.fujitsu.com, mgorman@suse.de,
        yinghai@kernel.org
Cc: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org
Subject: [PATCH v5 09/14] memory-hotplug: remove page table of x86_64 architecture
Date: Mon, 24 Dec 2012 20:09:19 +0800
Message-Id: <1356350964-13437-10-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1356350964-13437-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1356350964-13437-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/24 20:10:13,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/24 20:10:15,
	Serialize complete at 2012/12/24 20:10:15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch searches a page table about the removed memory, and clear
page table for x86_64 architecture.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/mm/init_64.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index b30df3c..4b160d8 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -979,6 +979,15 @@ remove_pagetable(unsigned long start, unsigned long end, bool direct)
 	flush_tlb_all();
 }
 
+void __meminit
+kernel_physical_mapping_remove(unsigned long start, unsigned long end)
+{
+	start = (unsigned long)__va(start);
+	end = (unsigned long)__va(end);
+
+	remove_pagetable(start, end, true);
+}
+
 #ifdef CONFIG_MEMORY_HOTREMOVE
 int __ref arch_remove_memory(u64 start, u64 size)
 {
@@ -988,6 +997,7 @@ int __ref arch_remove_memory(u64 start, u64 size)
 	int ret;
 
 	zone = page_zone(pfn_to_page(start_pfn));
+	kernel_physical_mapping_remove(start, start + size);
 	ret = __remove_pages(zone, start_pfn, nr_pages);
 	WARN_ON_ONCE(ret);
 
-- 
1.7.1

