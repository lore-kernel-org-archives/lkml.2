Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab0HBBJN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 21:09:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:50974 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab0HBBJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 21:09:08 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Dave Martin <dave.martin@linaro.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 14/19] perf tools: remove extra build-id check factored into dso__load
Date: Sun,  1 Aug 2010 22:08:49 -0300
Message-Id: <1280711334-30000-15-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1280711334-30000-1-git-send-email-acme@infradead.org>
References: <1280711334-30000-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Martin <dave.martin@linaro.org>

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
-- 
1.6.2.5

