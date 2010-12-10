Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab0LJVGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 16:06:33 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61981 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab0LJVGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 16:06:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:user-agent:mime-version
         :content-type;
        b=vbBbnPsn5dkQeA8MzMuQD5/dBMsDVIspAuIHXJ5t5LzEWR3AY6eZ/424ys7yjjD4sn
         oDFU9xXrKabMCVqFCcQWFIeCPYYtqDbEcbXNWvMoWkDfqca9Di4knNPHqbqBK0M4d7Q1
         ZnLf486SQNz30exDf2opxabacJe+l42oRRlg8=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-perf-users@vger.kernel.org
Subject: [PATCH] perf-tools: fix perf-buildid-cache when passing a symbolic link
Date: Fri, 10 Dec 2010 22:06:26 +0100
Message-ID: <m38vzxxrql.fsf@gmail.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Franck Bui-Huu <fbuihuu@gmail.com>

This was broken since link(2) doesn't dereference symbolic
links. Instead 'filename' becomes a symbolic link to the same file
that 'name' refers to.

This had the bad effect to create dangling symlinks in the case that
even can't be removed with perf-buildid-cache(1).

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
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
1.7.3.2
