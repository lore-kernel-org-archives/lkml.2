Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab2IUD2q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 23:28:46 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:41231 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab2IUD2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 23:28:45 -0400
Message-ID: <505BDF34.3080905@oracle.com>
Date: Fri, 21 Sep 2012 11:29:56 +0800
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        levinsasha928@gmail.com, Feng Jin <joe.jin@oracle.com>
Subject: mm: frontswap: fix a wrong if condition in frontswap_shrink
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pages_to_unuse is set to 0 to unuse all frontswap pages
But that doesn't happen since a wrong condition in frontswap_shrink
cancels it.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
---
 mm/frontswap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/frontswap.c b/mm/frontswap.c
index 6b3e71a..db2a86f 100644
--- a/mm/frontswap.c
+++ b/mm/frontswap.c
@@ -275,7 +275,7 @@ static int __frontswap_shrink(unsigned long target_pages,
 	if (total_pages <= target_pages) {
 		/* Nothing to do */
 		*pages_to_unuse = 0;
-		return 0;
+		return 1;
 	}
 	total_pages_to_unuse = total_pages - target_pages;
 	return __frontswap_unuse_pages(total_pages_to_unuse, pages_to_unuse, type);
@@ -302,7 +302,7 @@ void frontswap_shrink(unsigned long target_pages)
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

