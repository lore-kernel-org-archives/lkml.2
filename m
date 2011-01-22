Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab1AVPUw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 10:20:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:48615 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331Ab1AVPUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 10:20:51 -0500
Date: Sat, 22 Jan 2011 15:19:28 GMT
From: "tip-bot for Dr. David Alan Gilbert" <david.gilbert@linaro.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, dave.martin@linaro.org,
        hpa@zytor.com, mingo@redhat.com, david.gilbert@linaro.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, dave.martin@linaro.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        david.gilbert@linaro.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110121163922.GA31398@davesworkthinkpad>
References: <20110121163922.GA31398@davesworkthinkpad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf symbols: Fix annotation of thumb code
Message-ID: <tip-b2f8fb237e9cc407a02aca401369c15babae35dd@git.kernel.org>
Git-Commit-ID: b2f8fb237e9cc407a02aca401369c15babae35dd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 22 Jan 2011 15:19:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b2f8fb237e9cc407a02aca401369c15babae35dd
Gitweb:     http://git.kernel.org/tip/b2f8fb237e9cc407a02aca401369c15babae35dd
Author:     Dr. David Alan Gilbert <david.gilbert@linaro.org>
AuthorDate: Fri, 21 Jan 2011 16:40:19 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 21 Jan 2011 16:32:18 -0200

perf symbols: Fix annotation of thumb code

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
 
