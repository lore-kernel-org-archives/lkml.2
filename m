Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030623Ab2HHROE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 13:14:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:45860 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030592Ab2HHROA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 13:14:00 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/11] perf tools: Fix lib/traceevent build dir with OUTPUT variable set
Date: Wed,  8 Aug 2012 14:13:39 -0300
Message-Id: <1344446028-21381-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1344446028-21381-1-git-send-email-acme@infradead.org>
References: <1344446028-21381-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@amd.com>

With the OUTPUT variable set the libtraceevent.a file is wrongly built
in the source directory:

 + make -d OUTPUT=/.../.build/perf-user/ DESTDIR=/.../.install/perf-user/
 ...
     Considering target file `../lib/traceevent//libtraceevent.a'.
      File `../lib/traceevent//libtraceevent.a' does not exist.
      Finished prerequisites of target file `../lib/traceevent//libtraceevent.a'.
     Must remake target `../lib/traceevent//libtraceevent.a'.
 Invoking recipe from Makefile:837 to update target `../lib/traceevent//libtraceevent.a'.
 Putting child 0x703850 (../lib/traceevent//libtraceevent.a) PID 8365 on the chain.
 Live child 0x703850 (../lib/traceevent//libtraceevent.a) PID 8365
     SUBDIR ../lib/traceevent/

 $ git clean -nxd
 Would remove tools/lib/traceevent/.event-parse.d
 Would remove tools/lib/traceevent/.parse-filter.d
 Would remove tools/lib/traceevent/.parse-utils.d
 Would remove tools/lib/traceevent/.trace-seq.d
 Would remove tools/lib/traceevent/event-parse.o
 Would remove tools/lib/traceevent/libtraceevent.a
 Would remove tools/lib/traceevent/parse-filter.o
 Would remove tools/lib/traceevent/parse-utils.o
 Would remove tools/lib/traceevent/trace-seq.o

This patch fixes this.

Note: Though this should already work with O=$outputdir we better use
the OUTPUT variable directly.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1344361396-7237-3-git-send-email-robert.richter@amd.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 35655c3..2d4bf6e 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -186,10 +186,10 @@ SCRIPTS = $(patsubst %.sh,%,$(SCRIPT_SH))
 
 TRACE_EVENT_DIR = ../lib/traceevent/
 
-ifeq ("$(origin O)", "command line")
-	TE_PATH=$(OUTPUT)/
+ifneq ($(OUTPUT),)
+	TE_PATH=$(OUTPUT)
 else
-	TE_PATH=$(TRACE_EVENT_DIR)/
+	TE_PATH=$(TRACE_EVENT_DIR)
 endif
 
 LIBTRACEEVENT = $(TE_PATH)libtraceevent.a
@@ -842,7 +842,7 @@ $(LIB_FILE): $(LIB_OBJS)
 
 # libtraceevent.a
 $(LIBTRACEEVENT):
-	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(QUIET_SUBDIR1) $(COMMAND_O) libtraceevent.a
+	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) libtraceevent.a
 
 help:
 	@echo 'Perf make targets:'
-- 
1.7.9.2.358.g22243

