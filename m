Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854Ab0EJW5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:57:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:50163 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932604Ab0EJWxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:53:24 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tzanussi@gmail.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/10] perf/trace/scripting: don't show script start/stop messages by default
Date: Mon, 10 May 2010 19:53:05 -0300
Message-Id: <1273531987-28956-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273531987-28956-1-git-send-email-acme@infradead.org>
References: <1273531987-28956-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tzanussi@gmail.com>

Only print the script start/stop messages in verbose mode - users
normally don't care and it just clutters up the output.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <1273466820-9330-7-git-send-email-tzanussi@gmail.com>
Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c                         |    3 +++
 .../perf/util/scripting-engines/trace-event-perl.c |    3 ---
 .../util/scripting-engines/trace-event-python.c    |    4 ----
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 6e268ca..95fcb05 100644
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
1.6.2.5

