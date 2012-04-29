Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab2D2Gox (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 02:44:53 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:61319 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab2D2Gow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 02:44:52 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: viro@zeniv.linux.org.uk, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, paulus@samba.org,
        acme@ghostprotocols.net, james.l.morris@oracle.com,
        ebiederm@xmission.com, akpm@linux-foundation.org, tglx@linutronix.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-security-module@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH 01/14] sysctl: provide callback for write into ctl_table entry
Date: Sun, 29 Apr 2012 08:45:24 +0200
Message-Id: <1335681937-3715-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a callback that will be called when writing to a ctl_table
entry after the user input has been validated.

This will simplify user input checks since now it will be possible to
remove them out of the proc_handler.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 fs/proc/proc_sysctl.c  |    4 ++++
 include/linux/sysctl.h |    1 +
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 21d836f..190db28 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -507,6 +507,10 @@ static ssize_t proc_sys_call_handler(struct file *filp, void __user *buf,
 	error = table->proc_handler(table, write, buf, &res, ppos);
 	if (!error)
 		error = res;
+
+	if (!error && write && table->callback)
+		error = table->callback();
+
 out:
 	sysctl_head_finish(head);
 
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index c34b4c8..27c14cf 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -1022,6 +1022,7 @@ struct ctl_table
 	struct ctl_table_poll *poll;
 	void *extra1;
 	void *extra2;
+	int (*callback)(void);		/* Called when entry is written to */
 };
 
 struct ctl_node {
-- 
1.7.8.5

