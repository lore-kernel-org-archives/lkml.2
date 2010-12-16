Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab0LPMBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 07:01:25 -0500
Received: from canuck.infradead.org ([134.117.69.58]:41068 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab0LPMAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 07:00:23 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Franck Bui-Huu <fbuihuu@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/4] perf buildid-cache: Fix symbolic link handling
Date: Thu, 16 Dec 2010 10:00:16 -0200
Message-Id: <1292500817-1348-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1292500817-1348-1-git-send-email-acme@infradead.org>
References: <1292500817-1348-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Franck Bui-Huu <fbuihuu@gmail.com>

This was broken since link(2) doesn't dereference symbolic
links. Instead 'filename' becomes a symbolic link to the same file
that 'name' refers to.

This had the bad effect to create dangling symlinks in the case that
even can't be removed with perf-buildid-cache(1).

LKML-Reference: <m38vzxxrql.fsf@gmail.com>
Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 64a85ba..7cba055 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -265,15 +265,16 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 			  const char *name, bool is_kallsyms)
 {
 	const size_t size = PATH_MAX;
-	char *filename = malloc(size),
+	char *realname = realpath(name, NULL),
+	     *filename = malloc(size),
 	     *linkname = malloc(size), *targetname;
 	int len, err = -1;
 
-	if (filename == NULL || linkname == NULL)
+	if (realname == NULL || filename == NULL || linkname == NULL)
 		goto out_free;
 
 	len = snprintf(filename, size, "%s%s%s",
-		       debugdir, is_kallsyms ? "/" : "", name);
+		       debugdir, is_kallsyms ? "/" : "", realname);
 	if (mkdir_p(filename, 0755))
 		goto out_free;
 
@@ -283,7 +284,7 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 		if (is_kallsyms) {
 			 if (copyfile("/proc/kallsyms", filename))
 				goto out_free;
-		} else if (link(name, filename) && copyfile(name, filename))
+		} else if (link(realname, filename) && copyfile(name, filename))
 			goto out_free;
 	}
 
@@ -300,6 +301,7 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 	if (symlink(targetname, linkname) == 0)
 		err = 0;
 out_free:
+	free(realname);
 	free(filename);
 	free(linkname);
 	return err;
-- 
1.6.2.5

