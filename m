Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941Ab0HJUQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 16:16:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:35973 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757870Ab0HJUPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 16:15:52 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Dave Martin <dave.martin@linaro.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6/9] perf symbols: Ignore mapping symbols on ARM
Date: Tue, 10 Aug 2010 17:15:36 -0300
Message-Id: <1281471339-10878-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1281471339-10878-1-git-send-email-acme@infradead.org>
References: <1281471339-10878-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Martin <dave.martin@linaro.org>

ARM ELF files use symbols with special names $a, $t, $d to identify regions of
ARM code, Thumb code and data within code sections.  This can cause confusing
output from the perf tools, especially for partially stripped binaries, or
binaries containing user-added zero-sized symbols (which may occur in
hand-written assembler which hasn't been fully annotated with .size
directives).

This patch filters out these symbols at load time.

LKML-Reference: <1281352878-8735-2-git-send-email-dave.martin@linaro.org>
Signed-off-by: Dave Martin <dave.martin@linaro.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index b6f5970..1a36773 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1079,6 +1079,16 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 		if (!is_label && !elf_sym__is_a(&sym, map->type))
 			continue;
 
+		/* Reject ARM ELF "mapping symbols": these aren't unique and
+		 * don't identify functions, so will confuse the profile
+		 * output: */
+		if (ehdr.e_machine == EM_ARM) {
+			if (!strcmp(elf_name, "$a") ||
+			    !strcmp(elf_name, "$d") ||
+			    !strcmp(elf_name, "$t"))
+				continue;
+		}
+
 		if (opdsec && sym.st_shndx == opdidx) {
 			u32 offset = sym.st_value - opdshdr.sh_addr;
 			u64 *opd = opddata->d_buf + offset;
-- 
1.6.2.5

