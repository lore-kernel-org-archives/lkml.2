Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab2HGRq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:46:29 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:7885
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755789Ab2HGRoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:44:34 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M8EBY4-01-CEM-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 2/6] perf, tools: Fix lib/traceevent build dir with OUTPUT variable set
Date: Tue, 7 Aug 2012 19:43:12 +0200
Message-ID: <1344361396-7237-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1344361396-7237-1-git-send-email-robert.richter@amd.com>
References: <1344361396-7237-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 tools/perf/Makefile |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

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
1.7.8.4


