Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889Ab0GQLMK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 07:12:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:41393 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab0GQLMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 07:12:06 -0400
Date: Sat, 17 Jul 2010 11:11:41 GMT
From: tip-bot for Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: acme@redhat.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        guijianfeng@cn.fujitsu.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        paulus@samba.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        guijianfeng@cn.fujitsu.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4C230362.5080704@cn.fujitsu.com>
References: <4C230362.5080704@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf symbols: Fix directory descriptor leaking
Message-ID: <tip-74534341c1214ac5993904680616afe698dde3b6@git.kernel.org>
Git-Commit-ID: 74534341c1214ac5993904680616afe698dde3b6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 17 Jul 2010 11:11:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  74534341c1214ac5993904680616afe698dde3b6
Gitweb:     http://git.kernel.org/tip/74534341c1214ac5993904680616afe698dde3b6
Author:     Gui Jianfeng <guijianfeng@cn.fujitsu.com>
AuthorDate: Thu, 24 Jun 2010 15:04:02 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 16 Jul 2010 14:16:47 -0300

perf symbols: Fix directory descriptor leaking

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
