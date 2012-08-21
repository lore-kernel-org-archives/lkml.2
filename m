Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957Ab2HUQU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:20:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60964 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab2HUQU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:20:27 -0400
Date: Tue, 21 Aug 2012 09:20:00 -0700
From: tip-bot for Steven Rostedt <rostedt@goodmis.org>
Message-ID: <tip-c883122acc0d97648d8b8f4726709017674e4420@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung.kim@lge.com,
        rostedt@goodmis.org, tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, rostedt@goodmis.org, peterz@infradead.org,
        namhyung.kim@lge.com, tglx@linutronix.de, borislav.petkov@amd.com
In-Reply-To: <20120815163923.GD15989@aftab.osrc.amd.com>
References: <20120815163923.GD15989@aftab.osrc.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Let O= makes handle relative paths
Git-Commit-ID: c883122acc0d97648d8b8f4726709017674e4420
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 09:20:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c883122acc0d97648d8b8f4726709017674e4420
Gitweb:     http://git.kernel.org/tip/c883122acc0d97648d8b8f4726709017674e4420
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Mon, 13 Aug 2012 10:23:02 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 16 Aug 2012 14:11:11 -0300

perf tools: Let O= makes handle relative paths

When I did a compile of perf using a relative path for the output
directory, the build failed when it tried to compile libtraceevent. This
is because it continues to use the same relative path when the new
working directory is in a different path.

    SUBDIR ../lib/traceevent/
/bin/sh: line 0: cd: ../../../nobackup/perf/: No such file or directory
Makefile:74: *** output directory "../../../nobackup/perf/" does not exist.  Stop.
make: *** [../../../nobackup/perf///libtraceevent.a] Error 2

Make the path used an absolute path when building perf with O=.

Boris:

Teach Makefile to check whether the supplied O= directory exists and
bail out if not. Reportedly, kernel dudes are idiots and need to be
guarded so as not to shoot themselves in the foot when playing in the
sandbox.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120815163923.GD15989@aftab.osrc.amd.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/scripts/Makefile.include |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index bde8521..96ce80a 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -1,6 +1,8 @@
 ifeq ("$(origin O)", "command line")
-	OUTPUT := $(O)/
-	COMMAND_O := O=$(O)
+	dummy := $(if $(shell test -d $(O) || echo $(O)),$(error O=$(O) does not exist),)
+	ABSOLUTE_O := $(shell cd $(O) ; pwd)
+	OUTPUT := $(ABSOLUTE_O)/
+	COMMAND_O := O=$(ABSOLUTE_O)
 endif
 
 ifneq ($(OUTPUT),)
