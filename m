Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab2JECbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 22:31:45 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58934 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756401Ab2JECbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 22:31:41 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <506E466B.4050903@jp.fujitsu.com>
Date: Fri, 5 Oct 2012 11:31:07 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: <x86@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-acpi@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <linux-sh@vger.kernel.org>,
        <linux-ia64@vger.kernel.org>, <cmetcalf@tilera.com>,
        <sparclinux@vger.kernel.org>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>, <rientjes@google.com>,
        <liuj97@gmail.com>, <len.brown@intel.com>, <cl@linux.com>,
        <minchan.kim@gmail.com>, <akpm@linux-foundation.org>,
        <kosaki.motohiro@jp.fujitsu.com>, <wency@cn.fujitsu.com>
Subject: [PATCH 4/10] memory-hotplug : unregister memory section on SPARSEMEM_VMEMMAP
References: <506E43E0.70507@jp.fujitsu.com>
In-Reply-To: <506E43E0.70507@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently __remove_section for SPARSEMEM_VMEMMAP does nothing. But even if
we use SPARSEMEM_VMEMMAP, we can unregister the memory_section.

So the patch add unregister_memory_section() into __remove_section().

CC: David Rientjes <rientjes@google.com>
CC: Jiang Liu <liuj97@gmail.com>
CC: Len Brown <len.brown@intel.com>
CC: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> 
CC: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---
 mm/memory_hotplug.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

Index: linux-3.6/mm/memory_hotplug.c
===================================================================
--- linux-3.6.orig/mm/memory_hotplug.c	2012-10-04 18:29:50.577668254 +0900
+++ linux-3.6/mm/memory_hotplug.c	2012-10-04 18:29:58.284676075 +0900
@@ -279,11 +279,14 @@ static int __meminit __add_section(int n
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 static int __remove_section(struct zone *zone, struct mem_section *ms)
 {
-	/*
-	 * XXX: Freeing memmap with vmemmap is not implement yet.
-	 *      This should be removed later.
-	 */
-	return -EBUSY;
+	int ret = -EINVAL;
+
+	if (!valid_section(ms))
+		return ret;
+
+	ret = unregister_memory_section(ms);
+
+	return ret;
 }
 #else
 static int __remove_section(struct zone *zone, struct mem_section *ms)

