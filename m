Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab0LVL2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 06:28:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:34583 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027Ab0LVL2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 06:28:46 -0500
Date: Wed, 22 Dec 2010 11:28:27 GMT
From: tip-bot for Franck Bui-Huu <fbuihuu@gmail.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, fbuihuu@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fbuihuu@gmail.com, tglx@linutronix.de
In-Reply-To: <m38vzxxrql.fsf@gmail.com>
References: <m38vzxxrql.fsf@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf buildid-cache: Fix symbolic link handling
Message-ID: <tip-68a7a771ad0e2959983729bf88cbc74a7014438f@git.kernel.org>
Git-Commit-ID: 68a7a771ad0e2959983729bf88cbc74a7014438f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 22 Dec 2010 11:28:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  68a7a771ad0e2959983729bf88cbc74a7014438f
Gitweb:     http://git.kernel.org/tip/68a7a771ad0e2959983729bf88cbc74a7014438f
Author:     Franck Bui-Huu <fbuihuu@gmail.com>
AuthorDate: Fri, 10 Dec 2010 22:06:26 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 16 Dec 2010 09:41:45 -0200

perf buildid-cache: Fix symbolic link handling

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
