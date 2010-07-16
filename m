Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757Ab0GPSII (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 14:08:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:49038 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758714Ab0GPSIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 14:08:05 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/1] perf symbols: Fix directory descriptor leaking
Date: Fri, 16 Jul 2010 15:07:47 -0300
Message-Id: <1279303667-27764-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1279303667-27764-1-git-send-email-acme@infradead.org>
References: <1279303667-27764-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>

When I ran "perf kvm ... top", I encountered the following error output.

  Error: perfcounter syscall returned with -1 (Too many open files)

  Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?

Looking into perf, I found perf opens too many directories at
initialization time, but forgets to close them. Here is the fix.

LKML-Reference: <4C230362.5080704@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index b63e571..5b27683 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1443,6 +1443,7 @@ static int map_groups__set_modules_path_dir(struct map_groups *self,
 {
 	struct dirent *dent;
 	DIR *dir = opendir(dir_name);
+	int ret = 0;
 
 	if (!dir) {
 		pr_debug("%s: cannot open %s dir\n", __func__, dir_name);
@@ -1465,8 +1466,9 @@ static int map_groups__set_modules_path_dir(struct map_groups *self,
 
 			snprintf(path, sizeof(path), "%s/%s",
 				 dir_name, dent->d_name);
-			if (map_groups__set_modules_path_dir(self, path) < 0)
-				goto failure;
+			ret = map_groups__set_modules_path_dir(self, path);
+			if (ret < 0)
+				goto out;
 		} else {
 			char *dot = strrchr(dent->d_name, '.'),
 			     dso_name[PATH_MAX];
@@ -1487,17 +1489,18 @@ static int map_groups__set_modules_path_dir(struct map_groups *self,
 				 dir_name, dent->d_name);
 
 			long_name = strdup(path);
-			if (long_name == NULL)
-				goto failure;
+			if (long_name == NULL) {
+				ret = -1;
+				goto out;
+			}
 			dso__set_long_name(map->dso, long_name);
 			dso__kernel_module_get_build_id(map->dso, "");
 		}
 	}
 
-	return 0;
-failure:
+out:
 	closedir(dir);
-	return -1;
+	return ret;
 }
 
 static char *get_kernel_version(const char *root_dir)
-- 
1.6.2.5

