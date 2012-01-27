Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab2A0FBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 00:01:45 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:51331 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab2A0Erz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 23:47:55 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Damien Millescamps <damien.millescamps@6wind.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 18/29] sysctl: Normalize the root_table data structure.
Date: Thu, 26 Jan 2012 20:49:59 -0800
Message-Id: <1327639810-12760-18-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m1pqe5ah3z.fsf@fess.ebiederm.org>
References: <m1pqe5ah3z.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/Xu0d3JN2KQlA7K6UhAH6Y1TAxQwMJ1Jc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every other directory has a .child member and we look at the .child
for our entries.  Do the same for the root_table.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/proc_sysctl.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 7e96a26..88d1b06 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -25,7 +25,14 @@ void proc_sys_poll_notify(struct ctl_table_poll *poll)
 	wake_up_interruptible(&poll->wait);
 }
 
-static struct ctl_table root_table[1];
+static struct ctl_table root_table[] = {
+	{
+		.procname = "",
+		.mode = S_IRUGO|S_IXUGO,
+		.child = &root_table[1],
+	},
+	{ }
+};
 static struct ctl_table_root sysctl_table_root;
 static struct ctl_table_header root_table_header = {
 	{{.count = 1,
@@ -319,7 +326,7 @@ static struct dentry *proc_sys_lookup(struct inode *dir, struct dentry *dentry,
 		goto out;
 	}
 
-	table = table ? table->child : head->ctl_table;
+	table = table ? table->child : &head->ctl_table[1];
 
 	p = find_in_table(table, name);
 	if (!p) {
@@ -510,7 +517,7 @@ static int proc_sys_readdir(struct file *filp, void *dirent, filldir_t filldir)
 		goto out;
 	}
 
-	table = table ? table->child : head->ctl_table;
+	table = table ? table->child : &head->ctl_table[1];
 
 	ret = 0;
 	/* Avoid a switch here: arm builds fail with missing __cmpdi2 */
@@ -966,7 +973,7 @@ struct ctl_table_header *__register_sysctl_table(
 	spin_lock(&sysctl_lock);
 	header->set = lookup_header_set(root, namespaces);
 	header->attached_by = header->ctl_table;
-	header->attached_to = root_table;
+	header->attached_to = &root_table[1];
 	header->parent = &root_table_header;
 	set = header->set;
 	root = header->root;
-- 
1.7.2.5

