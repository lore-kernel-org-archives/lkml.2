Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545Ab0GBMtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 08:49:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:36987 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758352Ab0GBMs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 08:48:57 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/1] perf tools: Fix find tids routine by excluding "." and ".."
Date: Fri,  2 Jul 2010 09:48:44 -0300
Message-Id: <1278074924-21998-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1278074924-21998-1-git-send-email-acme@infradead.org>
References: <1278074924-21998-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>

Introduce a filter function to skip "." and ".." directories when calculating
tid number, otherwise tid 0 will be included in the all_tid result array.

Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <4C185F68.1020505@cn.fujitsu.com>
Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/thread.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 1f7ecd4..9a448b4 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -7,6 +7,15 @@
 #include "util.h"
 #include "debug.h"
 
+/* Skip "." and ".." directories */
+static int filter(const struct dirent *dir)
+{
+	if (dir->d_name[0] == '.')
+		return 0;
+	else
+		return 1;
+}
+
 int find_all_tid(int pid, pid_t ** all_tid)
 {
 	char name[256];
@@ -16,7 +25,7 @@ int find_all_tid(int pid, pid_t ** all_tid)
 	int i;
 
 	sprintf(name, "/proc/%d/task", pid);
-	items = scandir(name, &namelist, NULL, NULL);
+	items = scandir(name, &namelist, filter, NULL);
 	if (items <= 0)
                 return -ENOENT;
 	*all_tid = malloc(sizeof(pid_t) * items);
-- 
1.6.2.5

