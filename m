Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab2I0EZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 00:25:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52884 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab2I0EZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 00:25:22 -0400
Date: Wed, 26 Sep 2012 21:25:10 -0700
From: tip-bot for Eric Sandeen <sandeen@redhat.com>
Message-ID: <tip-e6048fb8602648eabee96476b2703807d5e89409@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, namhyung@kernel.org,
        sandeen@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, namhyung@kernel.org,
        sandeen@redhat.com
In-Reply-To: <505BD190.40707@redhat.com>
References: <505BD190.40707@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix parallel build
Git-Commit-ID: e6048fb8602648eabee96476b2703807d5e89409
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 21:25:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e6048fb8602648eabee96476b2703807d5e89409
Gitweb:     http://git.kernel.org/tip/e6048fb8602648eabee96476b2703807d5e89409
Author:     Eric Sandeen <sandeen@redhat.com>
AuthorDate: Thu, 20 Sep 2012 21:31:44 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 21 Sep 2012 12:13:21 -0300

perf tools: Fix parallel build

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
