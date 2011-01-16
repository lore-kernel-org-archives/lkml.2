Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab1APQOz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 11:14:55 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38110 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab1APQOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 11:14:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:user-agent:mime-version
         :content-type;
        b=E1BCiJcRkMoHShc/cIphz6Qo3WiD3jO8O1aC2gd29EH63HV4/cQRW56DLGlQXDHm/P
         M5pL8h7Ogk/epjRVoj2N7KvE1C8IluvJetGfvE4F1wh8YfYTSigq3jZeQOYtfgWkPpLU
         vj65k0oV9Gu3yhqozQkFs3MDvQflmGdglgYqY=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf-record: auto detect when stdout is a pipe
Date: Sun, 16 Jan 2011 17:14:45 +0100
Message-ID: <m3ipxo966i.fsf@gmail.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Franck Bui-Huu <fbuihuu@gmail.com>

This patch gives the ability to perf-record to detect when its stdout
has been redirected to a pipe. There's now no more need to add '-o -'
switch in this case.

However '-o <path>' option has always precedence, that is if specified
and stdout has been connected via a pipe then the output will go into
the specified output.

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
---
 tools/perf/builtin-record.c |   32 ++++++++++++++++++++------------
 1 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 7069bd3..4f86354 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -46,7 +46,7 @@ static unsigned int		user_freq 			= UINT_MAX;
 static int			freq				=   1000;
 static int			output;
 static int			pipe_output			=      0;
-static const char		*output_name			= "perf.data";
+static const char		*output_name			= NULL;
 static int			group				=      0;
 static int			realtime_prio			=      0;
 static bool			raw_samples			=  false;
@@ -562,18 +562,26 @@ static int __cmd_record(int argc, const char **argv)
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
1.7.3.2
