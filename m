Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab2LGItK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 03:49:10 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:14530 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab2LGItJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 03:49:09 -0500
Message-ID: <50C1AD6D.7010709@huawei.com>
Date: Fri, 7 Dec 2012 16:48:45 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: WuJianguo <wujianguo@huawei.com>, Xishi Qiu <qiuxishi@huawei.com>,
        Liujiang <jiang.liu@huawei.com>, <Vyacheslav.Dubeyko@huawei.com>,
        Borislav Petkov <bp@alien8.de>, <andi@firstfloor.org>,
        <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V2] MCE: fix an error of mce_bad_pages statistics
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

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
﻿Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 mm/memory-failure.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 8b20278..de760ca 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1582,8 +1582,11 @@ int soft_offline_page(struct page *page, int flags)
 		return ret;

 done:
-	atomic_long_add(1, &mce_bad_pages);
-	SetPageHWPoison(page);
 	/* keep elevated page count for bad page */
+	if (!PageHWPoison(page)) {
+		atomic_long_add(1, &mce_bad_pages);
+		SetPageHWPoison(page);
+	}
+
 	return ret;
 }
-- 
1.7.6.1


