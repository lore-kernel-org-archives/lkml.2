Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab1CJGhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 01:37:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:36607 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917Ab1CJGh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 01:37:28 -0500
Date: Thu, 10 Mar 2011 06:36:54 GMT
From: tip-bot for Lin Ming <ming.m.lin@intel.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, phan@redhat.com,
        ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, phan@redhat.com, a.p.zijlstra@chello.nl,
        ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1299165837-27817-1-git-send-email-ming.m.lin@intel.com>
References: <1299165837-27817-1-git-send-email-ming.m.lin@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf symbols: Avoid resolving [kernel.kallsyms] to real path for buildid cache
Message-ID: <tip-7ee235efe5f86f239ce73915fd2e15f4d14259c6@git.kernel.org>
Git-Commit-ID: 7ee235efe5f86f239ce73915fd2e15f4d14259c6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 10 Mar 2011 06:36:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7ee235efe5f86f239ce73915fd2e15f4d14259c6
Gitweb:     http://git.kernel.org/tip/7ee235efe5f86f239ce73915fd2e15f4d14259c6
Author:     Lin Ming <ming.m.lin@intel.com>
AuthorDate: Thu, 3 Mar 2011 23:23:57 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Mar 2011 13:44:10 -0300

perf symbols: Avoid resolving [kernel.kallsyms] to real path for buildid cache

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
index f6a929e7..0866bcd 100644
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
