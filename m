Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab1FGOaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 10:30:24 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:60030 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab1FGOaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 10:30:23 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH v2 2/2] coredump: escape / in hostname and comm
Date: Tue,  7 Jun 2011 16:30:10 +0200
Message-Id: <1307457010-7241-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1307457010-7241-1-git-send-email-jslaby@suse.cz>
References: <1307457010-7241-1-git-send-email-jslaby@suse.cz>
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
 fs/exec.c |   31 +++++++++++++++++++++++--------
 1 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 2093c47..1027025 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1623,15 +1623,26 @@ expand_fail:
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
-	if (!exe_file)
-		return cn_printf(cn, "%s (path unknown)", current->comm);
+	if (!exe_file) {
+		char *commstart = cn->corename + cn->used;
+		ret = cn_printf(cn, "%s (path unknown)", current->comm);
+		cn_escape(commstart);
+		return ret;
+	}
 
 	pathbuf = kmalloc(PATH_MAX, GFP_TEMPORARY);
 	if (!pathbuf) {
@@ -1645,9 +1656,7 @@ static int cn_print_exe_file(struct core_name *cn)
 		goto free_buf;
 	}
 
-	for (p = path; *p; p++)
-		if (*p == '/')
-			*p = '!';
+	cn_escape(path);
 
 	ret = cn_printf(cn, "%s", path);
 
@@ -1719,16 +1728,22 @@ static int format_corename(struct core_name *cn, long signr)
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
-			case 'e':
+			case 'e': {
+				char *commstart = cn->corename + cn->used;
 				err = cn_printf(cn, "%s", current->comm);
+				cn_escape(commstart);
 				break;
+			}
 			case 'E':
 				err = cn_print_exe_file(cn);
 				break;
-- 
1.7.5.3


