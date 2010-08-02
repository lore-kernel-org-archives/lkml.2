Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab0HBHxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:53:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:60433 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692Ab0HBHxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:53:15 -0400
Date: Mon, 2 Aug 2010 07:52:57 GMT
From: tip-bot for Dave Martin <dave.martin@linaro.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, dave.martin@linaro.org,
        hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, dave.martin@linaro.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: remove extra build-id check factored into dso__load
Message-ID: <tip-8b1389ef93b36621c6acdeb623bd85aee3c405c9@git.kernel.org>
Git-Commit-ID: 8b1389ef93b36621c6acdeb623bd85aee3c405c9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 02 Aug 2010 07:52:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b1389ef93b36621c6acdeb623bd85aee3c405c9
Gitweb:     http://git.kernel.org/tip/8b1389ef93b36621c6acdeb623bd85aee3c405c9
Author:     Dave Martin <dave.martin@linaro.org>
AuthorDate: Fri, 30 Jul 2010 09:36:08 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 30 Jul 2010 09:54:41 -0300

perf tools: remove extra build-id check factored into dso__load

Signed-off-by: Dave Martin <dave.martin@linaro.org>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   28 ++--------------------------
 1 files changed, 2 insertions(+), 26 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index b812ace..e0d9480 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -986,12 +986,12 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 
 	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
 	if (elf == NULL) {
-		pr_err("%s: cannot read %s ELF file.\n", __func__, name);
+		pr_debug("%s: cannot read %s ELF file.\n", __func__, name);
 		goto out_close;
 	}
 
 	if (gelf_getehdr(elf, &ehdr) == NULL) {
-		pr_err("%s: cannot get elf header.\n", __func__);
+		pr_debug("%s: cannot get elf header.\n", __func__);
 		goto out_elf_end;
 	}
 
@@ -1710,30 +1710,6 @@ static int dso__load_vmlinux(struct dso *self, struct map *map,
 {
 	int err = -1, fd;
 
-	if (self->has_build_id) {
-		u8 build_id[BUILD_ID_SIZE];
-
-		if (filename__read_build_id(vmlinux, build_id,
-					    sizeof(build_id)) < 0) {
-			pr_debug("No build_id in %s, ignoring it\n", vmlinux);
-			return -1;
-		}
-		if (!dso__build_id_equal(self, build_id)) {
-			char expected_build_id[BUILD_ID_SIZE * 2 + 1],
-			     vmlinux_build_id[BUILD_ID_SIZE * 2 + 1];
-
-			build_id__sprintf(self->build_id,
-					  sizeof(self->build_id),
-					  expected_build_id);
-			build_id__sprintf(build_id, sizeof(build_id),
-					  vmlinux_build_id);
-			pr_debug("build_id in %s is %s while expected is %s, "
-				 "ignoring it\n", vmlinux, vmlinux_build_id,
-				 expected_build_id);
-			return -1;
-		}
-	}
-
 	fd = open(vmlinux, O_RDONLY);
 	if (fd < 0)
 		return -1;
