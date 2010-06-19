Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab0FSD4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 23:56:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52751 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752427Ab0FSD4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 23:56:08 -0400
Message-ID: <4C1C3F7C.4030607@cn.fujitsu.com>
Date: Sat, 19 Jun 2010 11:54:36 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: acme@ghostprotocols.net, mingo@elte.hu
CC: Yanmin Zhang <yanmin_zhang@linux.intel.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf: close the opened directories.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I ran "perf kvm ... top", I encountered the following error output.

  Error: perfcounter syscall returned with -1 (Too many open files)

  Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?

Looking into perf, I found perf opens too many direcotries at initialization
time, but forgets to close them. Here is the fix.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 tools/perf/util/symbol.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 7fd6b15..a00dcad 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1443,6 +1443,7 @@ static int map_groups__set_modules_path_dir(struct map_groups *self,
 {
 	struct dirent *dent;
 	DIR *dir = opendir(dir_name);
+	int ret = 0;
 
 	if (!dir) {
 		pr_debug("%s: cannot open %s dir\n", __func__, dir_name);
@@ -1465,8 +1466,10 @@ static int map_groups__set_modules_path_dir(struct map_groups *self,
 
 			snprintf(path, sizeof(path), "%s/%s",
 				 dir_name, dent->d_name);
-			if (map_groups__set_modules_path_dir(self, path) < 0)
-				goto failure;
+			if (map_groups__set_modules_path_dir(self, path) < 0) {
+				ret = -1;
+				goto out;
+			}
 		} else {
 			char *dot = strrchr(dent->d_name, '.'),
 			     dso_name[PATH_MAX];
@@ -1487,17 +1490,18 @@ static int map_groups__set_modules_path_dir(struct map_groups *self,
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
1.6.5.2

