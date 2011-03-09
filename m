Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab1CIW5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 17:57:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:57078 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab1CIW5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 17:57:40 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>,
        Han Pingtian <phan@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/1] perf symbols: Avoid resolving [kernel.kallsyms] to real path for buildid cache
Date: Wed,  9 Mar 2011 19:57:30 -0300
Message-Id: <1299711450-17644-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1299711450-17644-1-git-send-email-acme@infradead.org>
References: <1299711450-17644-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lin Ming <ming.m.lin@intel.com>

kallsyms has a virtual file name [kernel.kallsyms].  Currently, it can't
be added to buildid cache successfully because the code
(build_id_cache__add_s) tries to resolve [kernel.kallsyms] to a real
absolute pathname and that fails.

Fixes it by not resolving it and just use the name [kernel.kallsyms].
So dir ~/.debug/[kernel.kallsyms] is created.

Original bug report at:
https://lkml.org/lkml/2011/3/1/524

Tested-by: Han Pingtian <phan@redhat.com>
Cc: Han Pingtian <phan@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1299165837-27817-1-git-send-email-ming.m.lin@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index f6a929e..0866bcd 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -270,11 +270,15 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
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
 
@@ -306,7 +310,8 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
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
1.6.2.5

