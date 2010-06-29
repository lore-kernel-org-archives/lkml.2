Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab0F2GGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 02:06:22 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36451 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab0F2GGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 02:06:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Steven Rostedt <rostedt@goodmis.org>, John Kacur <jkacur@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Add to ignore event not found error
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20100629144832.38C6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 29 Jun 2010 15:06:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usually trace-cmd die If 'trace-cmd start' find wrong -e argument.
It mean an admin can't pass the trace point of unloaded kernel module.
It can cause nightmare if he manage lots and various computers.

That said, admin want to use the same trace configuration. but, example,
some machine loaded ext4 module, others unloaded. It makes harder to
reuse.

So, I simply implement ignore option.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 trace-cmd.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/trace-cmd.c b/trace-cmd.c
index cdb0735..b4eb0fe 100644
--- a/trace-cmd.c
+++ b/trace-cmd.c
@@ -113,6 +113,8 @@ struct events {
 
 static struct tracecmd_recorder *recorder;
 
+static int ignore_event_not_found = 0;
+
 static char *get_temp_file(int cpu)
 {
 	char *file = NULL;
@@ -738,7 +740,7 @@ static void update_event(const char *name, const char *filter,
 
 		ret = update_glob(str, filter, filter_only, update);
 		free(str);
-		if (!ret)
+		if (!ret && !ignore_event_not_found)
 			die("No events enabled with %s", name);
 		return;
 	}
@@ -752,7 +754,7 @@ static void update_event(const char *name, const char *filter,
 	ret2 = update_glob(str, filter, filter_only, update);
 	free(str);
 
-	if (!ret && !ret2)
+	if (!ret && !ret2 && !ignore_event_not_found)
 		goto fail;
 
 	return;
@@ -1431,7 +1433,7 @@ int main (int argc, char **argv)
 		   (strcmp(argv[1], "start") == 0) ||
 		   ((extract = strcmp(argv[1], "extract") == 0))) {
 
-		while ((c = getopt(argc-1, argv+1, "+he:f:Fp:do:O:s:r:vg:l:n:P:N:tb:k")) >= 0) {
+		while ((c = getopt(argc-1, argv+1, "+he:f:Fp:do:O:s:r:vg:l:n:P:N:tb:ki")) >= 0) {
 			switch (c) {
 			case 'h':
 				usage(argv);
@@ -1543,6 +1545,9 @@ int main (int argc, char **argv)
 			case 'k':
 				keep = 1;
 				break;
+			case 'i':
+				ignore_event_not_found = 1;
+				break;
 			}
 		}
 
-- 
1.6.5.2



