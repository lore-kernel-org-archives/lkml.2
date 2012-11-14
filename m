Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161260Ab2KNTMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 14:12:54 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:30544 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161019Ab2KNTMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 14:12:53 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: sjenning@linux.vnet.ibm.com, dan.magenheimer@oracle.com,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org, minchan@kernel.org,
        akpm@linux-foundation.org, mgorman@suse.de
Cc: fschmaus@gmail.com, andor.daam@googlemail.com, ilendir@googlemail.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 03/11] zcache: The last of the atomic reads has now an accessory function.
Date: Wed, 14 Nov 2012 14:12:11 -0500
Message-Id: <1352920339-10183-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1352920339-10183-1-git-send-email-konrad.wilk@oracle.com>
References: <1352920339-10183-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And now we can move the code to its own file.

Reviewed-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/staging/ramster/zcache-main.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ramster/zcache-main.c b/drivers/staging/ramster/zcache-main.c
index 99dc045..9e6b6d3 100644
--- a/drivers/staging/ramster/zcache-main.c
+++ b/drivers/staging/ramster/zcache-main.c
@@ -252,6 +252,14 @@ static inline void dec_zcache_pers_zpages(unsigned zpages)
 {
 	zcache_pers_zpages = atomic_sub_return(zpages, &zcache_pers_zpages_atomic);
 }
+
+static inline unsigned long curr_pageframes_count(void)
+{
+	return zcache_pageframes_alloced -
+		atomic_read(&zcache_pageframes_freed_atomic) -
+		atomic_read(&zcache_eph_pageframes_atomic) -
+		atomic_read(&zcache_pers_pageframes_atomic);
+};
 /* but for the rest of these, counting races are ok */
 static unsigned long zcache_flush_total;
 static unsigned long zcache_flush_found;
@@ -551,10 +559,7 @@ static void zcache_free_page(struct page *page)
 		BUG();
 	__free_page(page);
 	inc_zcache_pageframes_freed();
-	curr_pageframes = zcache_pageframes_alloced -
-			atomic_read(&zcache_pageframes_freed_atomic) -
-			atomic_read(&zcache_eph_pageframes_atomic) -
-			atomic_read(&zcache_pers_pageframes_atomic);
+	curr_pageframes = curr_pageframes_count();
 	if (curr_pageframes > max_pageframes)
 		max_pageframes = curr_pageframes;
 	if (curr_pageframes < min_pageframes)
-- 
1.7.7.6

