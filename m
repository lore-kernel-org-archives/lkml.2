Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab1IWU0y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 16:26:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35330 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab1IWU0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 16:26:51 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        <stable@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric B Munson <emunson@mgebm.net>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/12] perf symbols: Fix ppc64 SEGV in dso__load_sym with debuginfo files
Date: Fri, 23 Sep 2011 17:26:16 -0300
Message-Id: <1316809586-28529-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1316809586-28529-1-git-send-email-acme@infradead.org>
References: <1316809586-28529-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

64bit PowerPC debuginfo files have an empty function descriptor section.
I hit a SEGV when perf tried to use this section for symbol resolution.

To fix this we need to check the section is valid and we can do this by
checking for type SHT_PROGBITS.

Cc: <stable@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Eric B Munson <emunson@mgebm.net>
Link: http://lkml.kernel.org/r/20110824065242.895239970@samba.org
Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 469c026..bb5d32f 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1111,6 +1111,8 @@ static int dso__load_sym(struct dso *dso, struct map *map, const char *name,
 	}
 
 	opdsec = elf_section_by_name(elf, &ehdr, &opdshdr, ".opd", &opdidx);
+	if (opdshdr.sh_type != SHT_PROGBITS)
+		opdsec = NULL;
 	if (opdsec)
 		opddata = elf_rawdata(opdsec, NULL);
 
-- 
1.6.2.5

