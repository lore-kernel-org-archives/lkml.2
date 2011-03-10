Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405Ab1CJHx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 02:53:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38091 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab1CJHxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 02:53:54 -0500
Date: Thu, 10 Mar 2011 08:53:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20110310075344.GA15153@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf/urgent git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf/urgent

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (1):
      perf symbols: Fix vmlinux path when not using --symfs

Lin Ming (1):
      perf symbols: Avoid resolving [kernel.kallsyms] to real path for buildid cache


 tools/perf/util/header.c |   11 ++++++++---
 tools/perf/util/symbol.c |    2 +-
 2 files changed, 9 insertions(+), 4 deletions(-)

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
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 7821d0e..b1bf490 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1836,7 +1836,7 @@ int dso__load_vmlinux(struct dso *self, struct map *map,
 	int err = -1, fd;
 	char symfs_vmlinux[PATH_MAX];
 
-	snprintf(symfs_vmlinux, sizeof(symfs_vmlinux), "%s/%s",
+	snprintf(symfs_vmlinux, sizeof(symfs_vmlinux), "%s%s",
 		 symbol_conf.symfs, vmlinux);
 	fd = open(symfs_vmlinux, O_RDONLY);
 	if (fd < 0)
