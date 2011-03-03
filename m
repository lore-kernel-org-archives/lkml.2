Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab1CCH2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 02:28:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:62382 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657Ab1CCH2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 02:28:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,257,1297065600"; 
   d="scan'208";a="608545685"
From: Lin Ming <ming.m.lin@intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Han Pingtian <phan@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-perf-users@vger.kernel.org
Subject: [PATCH] perf: Avoid resolving [kernel.kallsyms] to real path for buildid cache
Date: Thu,  3 Mar 2011 23:23:57 +0800
Message-Id: <1299165837-27817-1-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kallsyms has a virtual file name [kernel.kallsyms].
Currently, it can't be added to buildid cache successfully
because the code(build_id_cache__add_s) tries to resolve
[kernel.kallsyms]to a real absolute pathname and that fails.

Fixes it by not resolving it and just use the name [kernel.kallsyms].
So dir ~/.debug/[kernel.kallsyms] is created.

Original bug report at:
https://lkml.org/lkml/2011/3/1/524

Tested-by: Han Pingtian <phan@redhat.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 tools/perf/util/header.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 72c124d..1f8883b 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -271,11 +271,15 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 			  const char *name, bool is_kallsyms)
 {
 	const size_t size = PATH_MAX;
-	char *realname = realpath(name, NULL),
-	     *filename = malloc(size),
+	char *realname, *filename = malloc(size),
 	     *linkname = malloc(size), *targetname;
 	int len, err = -1;
 
+	if (is_kallsyms)
+		realname = (char *)name;
+	else
+		realname = realpath(name, NULL);
+
 	if (realname == NULL || filename == NULL || linkname == NULL)
 		goto out_free;
 
@@ -307,7 +311,8 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 	if (symlink(targetname, linkname) == 0)
 		err = 0;
 out_free:
-	free(realname);
+	if (!is_kallsyms)
+		free(realname);
 	free(filename);
 	free(linkname);
 	return err;
-- 
1.7.2.3

