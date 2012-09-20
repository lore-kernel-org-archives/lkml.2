Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab2ITXxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 19:53:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754607Ab2ITXxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 19:53:04 -0400
Message-ID: <505BAC5D.9020909@redhat.com>
Date: Thu, 20 Sep 2012 18:53:01 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: kernel list <linux-kernel@vger.kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] perf: Fix parallel build
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parallel builds of perf were failing for me on a 32p box, with:

    * new build flags or prefix
util/pmu.l:7:23: error: pmu-bison.h: No such file or directory

...

make: *** [util/pmu-flex.o] Error 1
make: *** Waiting for unfinished jobs....

This can pretty quickly be seen by adding a sleep in front of
the bison call in tools/perf/Makefile and running make -j4 on a
smaller box:

	sleep 10; $(QUIET_BISON)$(BISON) -v util/pmu.y -d -o $(OUTPUT)util/pmu-bison.c

Adding the following dependency fixes it for me:

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index bad726a..6c389d9 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -219,7 +219,7 @@ $(OUTPUT)util/parse-events-flex.c: util/parse-events.l
 $(OUTPUT)util/parse-events-bison.c: util/parse-events.y
 	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d $(PARSER_DEBUG_BISON) -o $(OUTPUT)util/parse-events-bison.c
 
-$(OUTPUT)util/pmu-flex.c: util/pmu.l
+$(OUTPUT)util/pmu-flex.c: util/pmu.l util/pmu-bison.c
 	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/pmu-flex.h -t util/pmu.l > $(OUTPUT)util/pmu-flex.c
 
 $(OUTPUT)util/pmu-bison.c: util/pmu.y

