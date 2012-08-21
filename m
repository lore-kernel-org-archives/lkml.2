Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab2HUP0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:26:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59769 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab2HUP0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:26:33 -0400
Date: Tue, 21 Aug 2012 08:26:18 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-2ede8303db75ead3250f95c3390e6ba200cbe7d4@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, robert.richter@amd.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, robert.richter@amd.com, tglx@linutronix.de
In-Reply-To: <1344361396-7237-3-git-send-email-robert.richter@amd.com>
References: <1344361396-7237-3-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix lib/
 traceevent build dir with OUTPUT variable set
Git-Commit-ID: 2ede8303db75ead3250f95c3390e6ba200cbe7d4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:26:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2ede8303db75ead3250f95c3390e6ba200cbe7d4
Gitweb:     http://git.kernel.org/tip/2ede8303db75ead3250f95c3390e6ba200cbe7d4
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Tue, 7 Aug 2012 19:43:12 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 8 Aug 2012 12:37:41 -0300

perf tools: Fix lib/traceevent build dir with OUTPUT variable set

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
