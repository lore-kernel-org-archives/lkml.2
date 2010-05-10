Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab0EJEsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 00:48:16 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55381 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab0EJErM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 00:47:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=t+MCd1S3dooKwPKAquLYAizy5A1mveZikWoP6K+gdQa4uh4/M5aYSipgJ9hW/HKdcB
         WjrcRc8WFbF87jOXcVFFznEofDg2Cs9Z66mxm/D8SCJq8/yHHLqsOfgMBEJ8XHK8aYRq
         OjLnHaOL6PmZWiuKnHNgQIbPMiQwvUDZClITc=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, acme@ghostprotocols.net
Subject: [PATCH 6/9] perf/trace/scripting: don't show script start/stop messages by default
Date: Sun,  9 May 2010 23:46:57 -0500
Message-Id: <1273466820-9330-7-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1273466820-9330-1-git-send-email-tzanussi@gmail.com>
References: <1273466820-9330-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only print the script start/stop messages in verbose mode - users
normally don't care and it just clutters up the output.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/builtin-trace.c                         |    3 +++
 .../perf/util/scripting-engines/trace-event-perl.c |    3 ---
 .../util/scripting-engines/trace-event-python.c    |    4 ----
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 9c483e9..cd9cffc 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -53,6 +53,8 @@ static void setup_scripting(void)
 
 static int cleanup_scripting(void)
 {
+	pr_debug("\nperf trace script stopped\n");
+
 	return scripting_ops->stop_script();
 }
 
@@ -703,6 +705,7 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 		err = scripting_ops->start_script(script_name, argc, argv);
 		if (err)
 			goto out;
+		pr_debug("perf trace started with script %s\n\n", script_name);
 	}
 
 	err = __cmd_trace(session);
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index 5376378..b059dc5 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -371,7 +371,6 @@ static int perl_start_script(const char *script, int argc, const char **argv)
 	run_start_sub();
 
 	free(command_line);
-	fprintf(stderr, "perf trace started with Perl script %s\n\n", script);
 	return 0;
 error:
 	perl_free(my_perl);
@@ -394,8 +393,6 @@ static int perl_stop_script(void)
 	perl_destruct(my_perl);
 	perl_free(my_perl);
 
-	fprintf(stderr, "\nperf trace Perl script stopped\n");
-
 	return 0;
 }
 
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 6a72f14..81f39ca 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -374,8 +374,6 @@ static int python_start_script(const char *script, int argc, const char **argv)
 	}
 
 	free(command_line);
-	fprintf(stderr, "perf trace started with Python script %s\n\n",
-		script);
 
 	return err;
 error:
@@ -407,8 +405,6 @@ out:
 	Py_XDECREF(main_module);
 	Py_Finalize();
 
-	fprintf(stderr, "\nperf trace Python script stopped\n");
-
 	return err;
 }
 
-- 
1.6.4.GIT

