Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab1AVBQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 20:16:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:47639 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab1AVBQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 20:16:15 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        "Dr. David Alan Gilbert" <david.gilbert@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, Dave Martin <dave.martin@linaro.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/2] perf symbols: Fix annotation of thumb code
Date: Fri, 21 Jan 2011 23:16:07 -0200
Message-Id: <1295658968-23217-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1295658968-23217-1-git-send-email-acme@infradead.org>
References: <1295658968-23217-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dr. David Alan Gilbert <david.gilbert@linaro.org>

In ARM's Thumb mode the bottom bit of the symbol address is set to mark
the function as Thumb; the instructions are in reality 2 or 4 byte on 2
byte alignments, and when the +1 address is used in annotate it causes
objdump to disassemble invalid instructions.

The patch removes that bottom bit during symbol loading.

Many thinks to Dave Martin for comments on an initial version of the
patch.

(For reference this corresponds to this bug
https://bugs.launchpad.net/linux-linaro/+bug/677547 )

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Dave Martin <dave.martin@linaro.org>
LKML-Reference: <20110121163922.GA31398@davesworkthinkpad>
Signed-off-by: Dr. David Alan Gilbert <david.gilbert@linaro.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 15ccfba..e32478e 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1161,6 +1161,13 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 
 		section_name = elf_sec__name(&shdr, secstrs);
 
+		/* On ARM, symbols for thumb functions have 1 added to
+		 * the symbol address as a flag - remove it */
+		if ((ehdr.e_machine == EM_ARM) &&
+		    (map->type == MAP__FUNCTION) &&
+		    (sym.st_value & 1))
+			--sym.st_value;
+
 		if (self->kernel != DSO_TYPE_USER || kmodule) {
 			char dso_name[PATH_MAX];
 
-- 
1.6.2.5

