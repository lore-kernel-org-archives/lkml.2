Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab2IUIjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 04:39:25 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31825 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321Ab2IUIjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 04:39:22 -0400
Message-ID: <505C27FE.5080205@oracle.com>
Date: Fri, 21 Sep 2012 16:40:30 +0800
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        levinsasha928@gmail.com, Feng Jin <joe.jin@oracle.com>,
        dan.carpenter@oracle.com, "zhenzhong.duan" <zhenzhong.duan@oracle.com>
Subject: [PATCH -v2] mm: frontswap: fix a wrong if condition in frontswap_shrink
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pages_to_unuse is set to 0 to unuse all frontswap pages
But that doesn't happen since a wrong condition in frontswap_shrink
cancel it.

-v2: Add comment to explain return value of __frontswap_shrink,
as suggested by Dan Carpenter, thanks

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>

diff --git a/mm/frontswap.c b/mm/frontswap.c
index 6b3e71a..e38fc39 100644
--- a/mm/frontswap.c
+++ b/mm/frontswap.c
@@ -263,6 +263,11 @@ static int __frontswap_unuse_pages(unsigned long total, unsigned long *unused,
 	return ret;
 }
 
+/*
+ * Used to check if it's necessory and feasible to unuse pages.
+ * Return 1 when nothing to do, 0 when need to shink pages,
+ * error code when there is an error.
+ */
 static int __frontswap_shrink(unsigned long target_pages,
 				unsigned long *pages_to_unuse,
 				int *type)
@@ -275,7 +280,7 @@ static int __frontswap_shrink(unsigned long target_pages,
 	if (total_pages <= target_pages) {
 		/* Nothing to do */
 		*pages_to_unuse = 0;
-		return 0;
+		return 1;
 	}
 	total_pages_to_unuse = total_pages - target_pages;
 	return __frontswap_unuse_pages(total_pages_to_unuse, pages_to_unuse, type);
@@ -302,7 +307,7 @@ void frontswap_shrink(unsigned long target_pages)
 	spin_lock(&swap_lock);
 	ret = __frontswap_shrink(target_pages, &pages_to_unuse, &type);
 	spin_unlock(&swap_lock);
-	if (ret == 0 && pages_to_unuse)
+	if (ret == 0)
 		try_to_unuse(type, true, pages_to_unuse);
 	return;
 }
-- 
1.7.3

