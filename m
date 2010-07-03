Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749Ab0GCN6Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 09:58:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:52687 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab0GCN6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 09:58:15 -0400
Date: Sat, 3 Jul 2010 13:57:44 GMT
From: tip-bot for Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
       mingo@redhat.com, guijianfeng@cn.fujitsu.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       acme@redhat.com, guijianfeng@cn.fujitsu.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4C185F68.1020505@cn.fujitsu.com>
References: <4C185F68.1020505@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Fix find tids routine by excluding "." and ".."
Message-ID: <tip-c214909b36efec632432acdcbfacdd46a6e11370@git.kernel.org>
Git-Commit-ID: c214909b36efec632432acdcbfacdd46a6e11370
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 03 Jul 2010 13:57:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c214909b36efec632432acdcbfacdd46a6e11370
Gitweb:     http://git.kernel.org/tip/c214909b36efec632432acdcbfacdd46a6e11370
Author:     Gui Jianfeng <guijianfeng@cn.fujitsu.com>
AuthorDate: Wed, 16 Jun 2010 13:21:44 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 1 Jul 2010 14:02:38 -0300

perf tools: Fix find tids routine by excluding "." and ".."

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
