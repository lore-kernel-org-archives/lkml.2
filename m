Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab2IXP7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:59:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:41387 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603Ab2IXP7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:59:53 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/30] perf tools: Fix parallel build
Date: Mon, 24 Sep 2012 12:59:18 -0300
Message-Id: <1348502384-14442-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1348502384-14442-1-git-send-email-acme@infradead.org>
References: <1348502384-14442-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

Parallel builds of perf were failing for me on a 32p box, with:

    * new build flags or prefix
util/pmu.l:7:23: error: pmu-bison.h: No such file or directory

...

make: *** [util/pmu-flex.o] Error 1
make: *** Waiting for unfinished jobs....

This can pretty quickly be seen by adding a sleep in front of the bison
calls in tools/perf/Makefile and running make -j4 on a smaller box i.e.:

	sleep 10; $(QUIET_BISON)$(BISON) -v util/pmu.y -d -o $(OUTPUT)util/pmu-bison.c

Adding the following dependencies fixes it for me.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/505BD190.40707@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 5077f8e..3ae6a59 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -233,13 +233,13 @@ export PERL_PATH
 FLEX = flex
 BISON= bison
 
-$(OUTPUT)util/parse-events-flex.c: util/parse-events.l
+$(OUTPUT)util/parse-events-flex.c: util/parse-events.l $(OUTPUT)util/parse-events-bison.c
 	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/parse-events-flex.h $(PARSER_DEBUG_FLEX) -t util/parse-events.l > $(OUTPUT)util/parse-events-flex.c
 
 $(OUTPUT)util/parse-events-bison.c: util/parse-events.y
 	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d $(PARSER_DEBUG_BISON) -o $(OUTPUT)util/parse-events-bison.c
 
-$(OUTPUT)util/pmu-flex.c: util/pmu.l
+$(OUTPUT)util/pmu-flex.c: util/pmu.l $(OUTPUT)util/pmu-bison.c
 	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/pmu-flex.h -t util/pmu.l > $(OUTPUT)util/pmu-flex.c
 
 $(OUTPUT)util/pmu-bison.c: util/pmu.y
-- 
1.7.1

