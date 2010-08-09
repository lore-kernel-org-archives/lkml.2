Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab0HILVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 07:21:54 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49507 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756152Ab0HILVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 07:21:53 -0400
From: Dave Martin <dave.martin@linaro.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, Dave Martin <dave.martin@linaro.org>
Subject: [PATCH 1/1] perf symbols: ignore mapping symbols on ARM
Date: Mon,  9 Aug 2010 12:21:18 +0100
Message-Id: <1281352878-8735-2-git-send-email-dave.martin@linaro.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1281352878-8735-1-git-send-email-dave.martin@linaro.org>
References: <1281352878-8735-1-git-send-email-dave.martin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applies to linux-2.6-tip/master or acme/perf-core

ARM ELF files use symbols with special names $a, $t, $d to
identify regions of ARM code, Thumb code and data within code
sections.  This can cause confusing output from the perf tools,
especially for partially stripped binaries, or binaries
containing user-added zero-sized symbols (which may occur in
hand-written assembler which hasn't been fully annotated with
.size directives).

This patch filters out these symbols at load time.

Signed-off-by: Dave Martin <dave.martin@linaro.org>
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
1.7.0.4

