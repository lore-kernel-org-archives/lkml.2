Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab0KEQJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 12:09:13 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42468 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab0KEQJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 12:09:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pqz5sRAtqRtHMr2kfHq+WOC21v3wH/YH/nJ32Y8qi96+vLUDdbSW6b638yaVBDPDia
         nBppXPaimLez8/Ja9WY7+ZvDS/NQSbnvCrprJvWzeJEgQtyv0xHpHoiQMupOoxEYDHo3
         MaF0/htUXVRCeEyOzJie+fzljoU81bUGX0rGM=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Young <hidave.darkstar@gmail.com>, Greg Thelen <gthelen@google.com>,
        Andrea Righi <arighi@develer.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH] memcg: use do_div to divide s64 in 32 bit machine.
Date: Sat,  6 Nov 2010 01:08:53 +0900
Message-Id: <1288973333-7891-1-git-send-email-minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use do_div to divide s64 value. Otherwise, build would be failed
like Dave Young reported.

mm/built-in.o: In function `mem_cgroup_dirty_info':
/home/dave/vdb/build/mm/linux-2.6.36/mm/memcontrol.c:1251: undefined
reference to `__divdi3'
/home/dave/vdb/build/mm/linux-2.6.36/mm/memcontrol.c:1259: undefined
reference to `__divdi3'
make: *** [.tmp_vmlinux1] Error 1

Tested-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/memcontrol.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 76386f4..a15d95e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1247,18 +1247,20 @@ bool mem_cgroup_dirty_info(unsigned long sys_available_mem,
 	if (dirty_param.dirty_bytes)
 		info->dirty_thresh =
 			DIV_ROUND_UP(dirty_param.dirty_bytes, PAGE_SIZE);
-	else
-		info->dirty_thresh =
-			(dirty_param.dirty_ratio * available_mem) / 100;
+	else {
+		info->dirty_thresh = dirty_param.dirty_ratio * available_mem;
+		do_div(info->dirty_thresh, 100);
+	}
 
 	if (dirty_param.dirty_background_bytes)
 		info->background_thresh =
 			DIV_ROUND_UP(dirty_param.dirty_background_bytes,
 				     PAGE_SIZE);
-	else
-		info->background_thresh =
-			(dirty_param.dirty_background_ratio *
-			       available_mem) / 100;
+	else {
+		info->background_thresh = dirty_param.dirty_background_ratio *
+			available_mem;
+		do_div(info->background_thresh, 100);
+	}
 
 	info->nr_reclaimable =
 		mem_cgroup_page_stat(MEMCG_NR_RECLAIM_PAGES);
-- 
1.7.0.5

