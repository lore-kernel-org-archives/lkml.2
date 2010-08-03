Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab0HCLtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 07:49:01 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52248 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756006Ab0HCLtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 07:49:00 -0400
From: Dave Martin <dave.martin@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, kernel-team@lists.ubuntu.com,
        Will Deacon <Will.Deacon@arm.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Dave Martin <dave.martin@linaro.org>
Subject: [PATCH 2/2] perf symbols: work around incorrect ET_EXEC symbol adjustment
Date: Tue,  3 Aug 2010 12:48:36 +0100
Message-Id: <1280836116-6654-3-git-send-email-dave.martin@linaro.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1280836116-6654-1-git-send-email-dave.martin@linaro.org>
References: <1280836116-6654-1-git-send-email-dave.martin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Workaround to adjust .text symbols from ET_EXEC images correctly.

This is not a complete fix, but addresses the common case and does not
create additional assumptions beyond those which perf already makes.
ELF images with a weird link map may still be processed incorrectly
(as at present) -- that will require a separate fix.

The workaround allows correct symbol offsets to be generated for
ET_EXEC executables on systems with separated debug info (where
section sh_offset fields from the debug image may bear no relation to
the layout of the executable image).

The cover note accompanying this patch contains a more detailed
explanation.

Signed-off-by: Dave Martin <dave.martin@linaro.org>
---
 tools/perf/util/symbol.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 3b8c005..3930398 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1135,7 +1135,15 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 				  "sh_addr: %#Lx sh_offset: %#Lx\n", __func__,
 				  (u64)sym.st_value, (u64)shdr.sh_addr,
 				  (u64)shdr.sh_offset);
-			sym.st_value -= shdr.sh_addr - shdr.sh_offset;
+			/* Assumptions:
+			 *	a) shdr.sh_addr - shdr.sh_offset ==
+			 *		map->start - map->pgoff
+			 *	b) map->pgoff == 0
+			 * These are true iff we are looking at a function
+			 * symbol in the main executable segment _and_
+			 * the main executable segment starts at the start of
+			 * the ELF image (normally true). */
+			sym.st_value -= map->start;
 		}
 		/*
 		 * We need to figure out if the object was created from C++ sources
-- 
1.7.0.4

