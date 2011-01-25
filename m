Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab1AYR17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:27:59 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48506 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab1AYRWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:22:05 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Franck Bui-Huu <fbuihuu@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 25/29] perf record: auto detect when stdout is a pipe
Date: Tue, 25 Jan 2011 15:21:48 -0200
Message-Id: <1295976112-2796-26-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1295976112-2796-1-git-send-email-acme@infradead.org>
References: <1295976112-2796-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Franck Bui-Huu <fbuihuu@gmail.com>

This patch gives the ability to 'perf record' to detect when its stdout
has been redirected to a pipe. There's now no more need to add '-o -'
switch in this case.

However '-o <path>' option has always precedence, that is if specified
and stdout has been connected via a pipe then the output will go into
the specified output.

LKML-Reference: <m3ipxo966i.fsf@gmail.com>
Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |   32 ++++++++++++++++++++------------
 1 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 45a3689..1346d42 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -48,7 +48,7 @@ static unsigned int		user_freq 			= UINT_MAX;
 static int			freq				=   1000;
 static int			output;
 static int			pipe_output			=      0;
-static const char		*output_name			= "perf.data";
+static const char		*output_name			= NULL;
 static int			group				=      0;
 static int			realtime_prio			=      0;
 static bool			nodelay				=  false;
@@ -497,18 +497,26 @@ static int __cmd_record(int argc, const char **argv)
 		exit(-1);
 	}
 
-	if (!strcmp(output_name, "-"))
-		pipe_output = 1;
-	else if (!stat(output_name, &st) && st.st_size) {
-		if (write_mode == WRITE_FORCE) {
-			char oldname[PATH_MAX];
-			snprintf(oldname, sizeof(oldname), "%s.old",
-				 output_name);
-			unlink(oldname);
-			rename(output_name, oldname);
+	if (!output_name) {
+		if (!fstat(STDOUT_FILENO, &st) && S_ISFIFO(st.st_mode))
+			pipe_output = 1;
+		else
+			output_name = "perf.data";
+	}
+	if (output_name) {
+		if (!strcmp(output_name, "-"))
+			pipe_output = 1;
+		else if (!stat(output_name, &st) && st.st_size) {
+			if (write_mode == WRITE_FORCE) {
+				char oldname[PATH_MAX];
+				snprintf(oldname, sizeof(oldname), "%s.old",
+					 output_name);
+				unlink(oldname);
+				rename(output_name, oldname);
+			}
+		} else if (write_mode == WRITE_APPEND) {
+			write_mode = WRITE_FORCE;
 		}
-	} else if (write_mode == WRITE_APPEND) {
-		write_mode = WRITE_FORCE;
 	}
 
 	flags = O_CREAT|O_RDWR;
-- 
1.6.2.5

