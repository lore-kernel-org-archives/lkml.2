Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965073Ab2LGCyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 21:54:10 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:50356 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964966Ab2LGCyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 21:54:08 -0500
Message-ID: <50C15A35.5020007@huawei.com>
Date: Fri, 7 Dec 2012 10:53:41 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: WuJianguo <wujianguo@huawei.com>, Xishi Qiu <qiuxishi@huawei.com>,
        Liujiang <jiang.liu@huawei.com>, <andi@firstfloor.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] MCE: fix an error of mce_bad_pages statistics
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86 platform, if we use "/sys/devices/system/memory/soft_offline_page" to offline a
free page twice, the value of mce_bad_pages will be added twice. So this is an error,
since the page was already marked HWPoison, we should skip the page and don't add the
value of mce_bad_pages.

$ cat /proc/meminfo | grep HardwareCorrupted

soft_offline_page()
	get_any_page()
		atomic_long_add(1, &mce_bad_pages)

The free page which marked HWPoison is still managed by page buddy allocator. So when
offlining it again, get_any_page() always returns 0 with
"pr_info("%s: %#lx free buddy page\n", __func__, pfn);".

When page is allocated, the PageBuddy is removed in bad_page(), then get_any_page()
returns -EIO with pr_info("%s: %#lx: unknown zero refcount page type %lx\n", so
mce_bad_pages will not be added.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
﻿Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 mm/memory-failure.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 8b20278..02a522e 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1375,6 +1375,11 @@ static int get_any_page(struct page *p, unsigned long pfn, int flags)
 	if (flags & MF_COUNT_INCREASED)
 		return 1;

+	if (PageHWPoison(p)) {
+		pr_info("%s: %#lx page already poisoned\n", __func__, pfn);
+		return -EBUSY;
+	}
+
 	/*
 	 * The lock_memory_hotplug prevents a race with memory hotplug.
 	 * This is a big hammer, a better would be nicer.
-- 
1.7.6.1


