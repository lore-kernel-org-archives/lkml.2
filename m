Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab2HTQam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:30:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:56630 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab2HTQ0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:26:40 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/24] perf tools: Let O= makes handle relative paths
Date: Mon, 20 Aug 2012 13:26:10 -0300
Message-Id: <1345479985-18669-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1345479985-18669-1-git-send-email-acme@infradead.org>
References: <1345479985-18669-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

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
-- 
1.7.1

