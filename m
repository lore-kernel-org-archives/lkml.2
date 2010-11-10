Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab0KJSMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:12:43 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:55324 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703Ab0KJSKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:10:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HrwVDivCb6DvW/cfRvk4MlMq7RRV6HjzVu+TqAbi2Dj1WJLJHZ7De3x6GfHchSnDbT
         NmxiLBWr7EHYC9HgsFbJwV/tDCeMfbUrTDcOzheFJrUU7mxGfUySVsT2JoNgiYSKe5L6
         +aHpzC4osDk9HErKw2knQr6OuAhsNXNWuCAHk=
From: tzanussi@gmail.com
To: linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, fweisbec@gmail.com
Subject: [PATCH 1/7] perf trace scripting: fix some small memory leaks and missing error checks
Date: Wed, 10 Nov 2010 12:10:18 -0600
Message-Id: <1289412624-4772-2-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289412624-4772-1-git-send-email-tzanussi@gmail.com>
References: <1289412624-4772-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tom.zanussi@linux.intel.com>

Free the other two fields of script_desc which somehow got overlooked,
free malloc'ed args in case exec fails, and add missing checks for
failed mallocs.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Acked-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 tools/perf/builtin-trace.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 2f8df45..368e624 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -337,6 +337,8 @@ static struct script_desc *script_desc__new(const char *name)
 static void script_desc__delete(struct script_desc *s)
 {
 	free(s->name);
+	free(s->half_liner);
+	free(s->args);
 	free(s);
 }
 
@@ -626,6 +628,9 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 			close(live_pipe[0]);
 
 			__argv = malloc(6 * sizeof(const char *));
+			if (!__argv)
+				die("malloc");
+
 			__argv[0] = "/bin/sh";
 			__argv[1] = record_script_path;
 			__argv[2] = "-q";
@@ -634,6 +639,7 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 			__argv[5] = NULL;
 
 			execvp("/bin/sh", (char **)__argv);
+			free(__argv);
 			exit(-1);
 		}
 
@@ -641,6 +647,8 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 		close(live_pipe[1]);
 
 		__argv = malloc((argc + 3) * sizeof(const char *));
+		if (!__argv)
+			die("malloc");
 		__argv[0] = "/bin/sh";
 		__argv[1] = report_script_path;
 		for (i = 2; i < argc; i++)
@@ -650,6 +658,7 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 		__argv[i++] = NULL;
 
 		execvp("/bin/sh", (char **)__argv);
+		free(__argv);
 		exit(-1);
 	}
 
@@ -661,6 +670,8 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 		}
 
 		__argv = malloc((argc + 1) * sizeof(const char *));
+		if (!__argv)
+			die("malloc");
 		__argv[0] = "/bin/sh";
 		__argv[1] = script_path;
 		for (i = 3; i < argc; i++)
@@ -668,7 +679,7 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 		__argv[argc - 1] = NULL;
 
 		execvp("/bin/sh", (char **)__argv);
+		free(__argv);
 		exit(-1);
 	}
 
-- 
Tom Zanussi, Intel Open Source Technology Center


