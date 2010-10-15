Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab0JOLvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 07:51:09 -0400
Received: from thoth.sbs.de ([192.35.17.2]:20472 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526Ab0JOLvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 07:51:07 -0400
Message-ID: <4CB8401B.2020801@siemens.com>
Date: Fri, 15 Oct 2010 13:50:51 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Steven Rostedt <srostedt@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-trace-users@vger.kernel.org
Subject: [PATCH] trace-cmd: Plug startup race between flush_threads and recorders
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the SIGUSR1 handler is so far registered after forking the recorder
child, there is a small race window where a flush sent by the main
process can actually kill the child. Plug this by registering the signal
handlers before the fork. This also allows to unify SIGINT registration.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 trace-cmd.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/trace-cmd.c b/trace-cmd.c
index 9cbe362..f8992a8 100644
--- a/trace-cmd.c
+++ b/trace-cmd.c
@@ -1089,6 +1089,8 @@ static int create_recorder(int cpu)
 	char *file;
 	int pid;
 
+	signal(SIGUSR1, flush);
+
 	pid = fork();
 	if (pid < 0)
 		die("fork");
@@ -1096,9 +1098,6 @@ static int create_recorder(int cpu)
 	if (pid)
 		return pid;
 
-	signal(SIGINT, finish);
-	signal(SIGUSR1, flush);
-
 	if (rt_prio)
 		set_prio(rt_prio);
 
@@ -1694,9 +1693,9 @@ int main (int argc, char **argv)
 	set_options();
 
 	if (record || extract) {
+		signal(SIGINT, finish);
 		if (!latency)
 			start_threads();
-		signal(SIGINT, finish);
 	}
 
 	if (extract) {
-- 
1.7.1
