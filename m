Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab2F0Fxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 01:53:36 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38814 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab2F0Fxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 01:53:34 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FEA9FCD.6020405@jp.fujitsu.com>
Date: Wed, 27 Jun 2012 14:53:17 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-acpi@vger.kernel.org>
CC: <len.brown@intel.com>, <benh@kernel.crashing.org>, <paulus@samba.org>,
        <cl@linux.com>, <minchan.kim@gmail.com>, <akpm@linux-foundation.org>,
        <kosaki.motohiro@jp.fujitsu.com>, <wency@cn.fujitsu.com>
Subject: [RFC PATCH 7/12] memory-hotplug : check page type in get_page_bootmem
References: <4FEA9C88.1070800@jp.fujitsu.com>
In-Reply-To: <4FEA9C88.1070800@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a possibility that get_page_bootmem() is called to the same page many
times. So when get_page_bootmem is called to the same page, the function only
increments page->_count.

CC: Len Brown <len.brown@intel.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
CC: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Index: linux-3.5-rc4/mm/memory_hotplug.c
===================================================================
--- linux-3.5-rc4.orig/mm/memory_hotplug.c	2012-06-26 13:56:34.371988312 +0900
+++ linux-3.5-rc4/mm/memory_hotplug.c	2012-06-26 14:03:37.564697621 +0900
@@ -95,10 +95,17 @@ static void release_memory_resource(stru
 static void get_page_bootmem(unsigned long info,  struct page *page,
 			     unsigned long type)
 {
-	page->lru.next = (struct list_head *) type;
-	SetPagePrivate(page);
-	set_page_private(page, info);
-	atomic_inc(&page->_count);
+	unsigned long page_type;
+
+	page_type = (unsigned long) page->lru.next;
+	if (type < MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE ||
+	    type > MEMORY_HOTPLUG_MAX_BOOTMEM_TYPE){
+		page->lru.next = (struct list_head *) type;
+		SetPagePrivate(page);
+		set_page_private(page, info);
+		atomic_inc(&page->_count);
+	} else
+		atomic_inc(&page->_count);
 }

 /* reference to __meminit __free_pages_bootmem is valid

