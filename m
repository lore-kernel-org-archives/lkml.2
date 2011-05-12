Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab1ELGS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 02:18:29 -0400
Received: from cantor.suse.de ([195.135.220.2]:44895 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164Ab1ELGS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 02:18:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Viro <viro@zeniv.linux.org.uk>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH v2 3/3] coredump: escape / in hostname and comm
Date: Thu, 12 May 2011 08:18:13 +0200
Message-Id: <1305181093-20871-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305181093-20871-1-git-send-email-jslaby@suse.cz>
References: <1305181093-20871-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change every occurence of / in comm and hostname to !. If the process
changes its name to contain /, the core is not dumped (if the
directory tree doesn't exist like that). The same with hostname being
something like myhost/3. Fix this behaviour by using the escape loop
used in %E. (We extract it to a separate function.)

Now both with comm == myprocess/1 and hostname == myhost/1, the core
is dumped like (kernel.core_pattern='core.%p.%e.%h):
core.2349.myprocess!1.myhost!1

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>
---
 fs/exec.c |   22 +++++++++++++++-------
 1 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 8900f61..dafded4 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1547,10 +1547,17 @@ expand_fail:
 	return ret;
 }
 
+static void cn_escape(char *str)
+{
+	for (; *str; str++)
+		if (*str == '/')
+			*str = '!';
+}
+
 static int cn_print_exe_file(struct core_name *cn)
 {
 	struct file *exe_file;
-	char *pathbuf, *path, *p;
+	char *pathbuf, *path;
 	int ret;
 
 	exe_file = get_mm_exe_file(current->mm);
@@ -1572,9 +1579,7 @@ static int cn_print_exe_file(struct core_name *cn)
 		goto free_buf;
 	}
 
-	for (p = path; *p; p++)
-		if (*p == '/')
-			*p = '!';
+	cn_escape(path);
 
 	ret = cn_printf(cn, "%s", path);
 
@@ -1652,17 +1657,20 @@ static int format_corename(struct core_name *cn, long signr)
 				break;
 			}
 			/* hostname */
-			case 'h':
+			case 'h': {
+				char *namestart = cn->corename + cn->used;
 				down_read(&uts_sem);
 				err = cn_printf(cn, "%s",
 					      utsname()->nodename);
 				up_read(&uts_sem);
+				cn_escape(namestart);
 				break;
+			}
 			/* executable */
 			case 'e': {
 				char comm[TASK_COMM_LEN];
-				err = cn_printf(cn, "%s",
-						get_task_comm(comm, current));
+				cn_escape(get_task_comm(comm, current));
+				err = cn_printf(cn, "%s", comm);
 				break;
 			}
 			case 'E':
-- 
1.7.4.2

