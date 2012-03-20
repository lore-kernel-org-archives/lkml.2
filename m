Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab2CTSaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 14:30:22 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57885 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab2CTSaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 14:30:21 -0400
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
To: Al Viro <viro@zeniv.linux.org.uk>, Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: [PATCH] sysctl: protect poll() in entries that may go away
Date: Tue, 20 Mar 2012 15:29:42 -0300
Message-Id: <1332268182-440-1-git-send-email-lucas.demarchi@profusion.mobi>
X-Mailer: git-send-email 1.7.9.4
In-Reply-To: <CAMOw1v4qa_AxJgc+qAsY6M=K--2JDvO-+CNj8OwKuE7piRViGw@mail.gmail.com>
References: <CAMOw1v4qa_AxJgc+qAsY6M=K--2JDvO-+CNj8OwKuE7piRViGw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protect code accessing ctl_table by grabbing the header with
grab_header() and after releasing with sysctl_head_finish(). This is
needed if poll() is called in entries created by modules: currently only
hostname and domainname support poll(), but this bug may be triggered
when/if modules use it and if user called poll() in a file that doesn't
support it.

Dave Jones reported the following when using a syscall fuzzer while
hibernating/resuming:

RIP: 0010:[<ffffffff81233e3e>]  [<ffffffff81233e3e>] proc_sys_poll+0x4e/0x90
RAX: 0000000000000145 RBX: ffff88020cab6940 RCX: 0000000000000000
RDX: ffffffff81233df0 RSI: 6b6b6b6b6b6b6b6b RDI: ffff88020cab6940
[ ... ]
Code: 00 48 89 fb 48 89 f1 48 8b 40 30 4c 8b 60 e8 b8 45 01 00 00 49 83
7c 24 28 00 74 2e 49 8b 74 24 30 48 85 f6 74 24 48 85 c9 75 32 <8b> 16
b8 45 01 00 00 48 63 d2 49 39 d5 74 10 8b 06 48 98 48 89

If an entry goes away while we are polling() it, ctl_table may not exist
anymore.

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
---
 fs/proc/proc_sysctl.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index a6b6217..53c3bce 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -188,20 +188,32 @@ static ssize_t proc_sys_write(struct file *filp, const char __user *buf,
 
 static int proc_sys_open(struct inode *inode, struct file *filp)
 {
+	struct ctl_table_header *head = grab_header(inode);
 	struct ctl_table *table = PROC_I(inode)->sysctl_entry;
 
+	/* sysctl was unregistered */
+	if (IS_ERR(head))
+		return PTR_ERR(head);
+
 	if (table->poll)
 		filp->private_data = proc_sys_poll_event(table->poll);
 
+	sysctl_head_finish(head);
+
 	return 0;
 }
 
 static unsigned int proc_sys_poll(struct file *filp, poll_table *wait)
 {
 	struct inode *inode = filp->f_path.dentry->d_inode;
+	struct ctl_table_header *head = grab_header(inode);
 	struct ctl_table *table = PROC_I(inode)->sysctl_entry;
-	unsigned long event = (unsigned long)filp->private_data;
 	unsigned int ret = DEFAULT_POLLMASK;
+	unsigned long event;
+
+	/* sysctl was unregistered */
+	if (IS_ERR(head))
+		return POLLERR | POLLHUP;
 
 	if (!table->proc_handler)
 		goto out;
@@ -209,6 +221,7 @@ static unsigned int proc_sys_poll(struct file *filp, poll_table *wait)
 	if (!table->poll)
 		goto out;
 
+	event = (unsigned long)filp->private_data;
 	poll_wait(filp, &table->poll->wait, wait);
 
 	if (event != atomic_read(&table->poll->event)) {
@@ -217,6 +230,8 @@ static unsigned int proc_sys_poll(struct file *filp, poll_table *wait)
 	}
 
 out:
+	sysctl_head_finish(head);
+
 	return ret;
 }
 
-- 
1.7.9.4

