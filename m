Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab1ELGS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 02:18:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:44904 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565Ab1ELGS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 02:18:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Viro <viro@zeniv.linux.org.uk>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH v2 1/3] coredump: use get_task_comm for %e filename format
Date: Thu, 12 May 2011 08:18:11 +0200
Message-Id: <1305181093-20871-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently access current->comm directly. As we have
prctl(PR_SET_NAME), we need the access be protected by task_lock. This
is exactly what get_task_comm does, so use it.

I'm not 100% convinced prctl(PR_SET_NAME) may be called at the time of
core dump, but the locking won't hurt. Note that siglock is not held
in format_corename.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 fs/exec.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 5ee7562..155c6d4 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1656,9 +1656,12 @@ static int format_corename(struct core_name *cn, long signr)
 				up_read(&uts_sem);
 				break;
 			/* executable */
-			case 'e':
-				err = cn_printf(cn, "%s", current->comm);
+			case 'e': {
+				char comm[TASK_COMM_LEN];
+				err = cn_printf(cn, "%s",
+						get_task_comm(comm, current));
 				break;
+			}
 			case 'E':
 				err = cn_print_exe_file(cn);
 				break;
-- 
1.7.4.2

