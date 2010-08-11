Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab0HKHlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 03:41:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:48424 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932509Ab0HKHlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 03:41:53 -0400
Date: Wed, 11 Aug 2010 07:41:36 GMT
From: tip-bot for Dave Martin <dave.martin@linaro.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, dave.martin@linaro.org,
        hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, dave.martin@linaro.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, tglx@linutronix.de
In-Reply-To: <1281352878-8735-2-git-send-email-dave.martin@linaro.org>
References: <1281352878-8735-2-git-send-email-dave.martin@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Ignore mapping symbols on ARM
Message-ID: <tip-696b97a5d2de9e2b22699300835e675dfffe8592@git.kernel.org>
Git-Commit-ID: 696b97a5d2de9e2b22699300835e675dfffe8592
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 11 Aug 2010 07:41:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  696b97a5d2de9e2b22699300835e675dfffe8592
Gitweb:     http://git.kernel.org/tip/696b97a5d2de9e2b22699300835e675dfffe8592
Author:     Dave Martin <dave.martin@linaro.org>
AuthorDate: Mon, 9 Aug 2010 12:21:18 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 10 Aug 2010 16:10:36 -0300

perf symbols: Ignore mapping symbols on ARM

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
