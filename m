Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab2KSPRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:17:07 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:35485 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab2KSPRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:17:04 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Mon, 19 Nov 2012 07:12:39 -0800
Message-Id: <1353337961-12962-14-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353337961-12962-1-git-send-email-ebiederm@xmission.com>
References: <87lidx8wbo.fsf@xmission.com>
 <1353337961-12962-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX195QGX/SfPK3TrKkYXvVmJCqg+KzKCkW54=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0459]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 14/16] proc: Generalize proc inode allocation
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Generalize the proc inode allocation so that it can be
used without having to having to create a proc_dir_entry.

This will allow namespace file descriptors to remain light
weight entitities but still have the same inode number
when the backing namespace is the same.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/generic.c       |   26 +++++++++++++-------------
 include/linux/proc_fs.h |   10 ++++++++++
 2 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 0d80cef..7b3ae3c 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -350,14 +350,14 @@ static DEFINE_SPINLOCK(proc_inum_lock); /* protects the above */
  * Return an inode number between PROC_DYNAMIC_FIRST and
  * 0xffffffff, or zero on failure.
  */
-static unsigned int get_inode_number(void)
+int proc_alloc_inum(unsigned int *inum)
 {
 	unsigned int i;
 	int error;
 
 retry:
-	if (ida_pre_get(&proc_inum_ida, GFP_KERNEL) == 0)
-		return 0;
+	if (!ida_pre_get(&proc_inum_ida, GFP_KERNEL))
+		return -ENOMEM;
 
 	spin_lock(&proc_inum_lock);
 	error = ida_get_new(&proc_inum_ida, &i);
@@ -365,18 +365,19 @@ retry:
 	if (error == -EAGAIN)
 		goto retry;
 	else if (error)
-		return 0;
+		return error;
 
 	if (i > UINT_MAX - PROC_DYNAMIC_FIRST) {
 		spin_lock(&proc_inum_lock);
 		ida_remove(&proc_inum_ida, i);
 		spin_unlock(&proc_inum_lock);
-		return 0;
+		return -ENOSPC;
 	}
-	return PROC_DYNAMIC_FIRST + i;
+	*inum = PROC_DYNAMIC_FIRST + i;
+	return 0;
 }
 
-static void release_inode_number(unsigned int inum)
+void proc_free_inum(unsigned int inum)
 {
 	spin_lock(&proc_inum_lock);
 	ida_remove(&proc_inum_ida, inum - PROC_DYNAMIC_FIRST);
@@ -554,13 +555,12 @@ static const struct inode_operations proc_dir_inode_operations = {
 
 static int proc_register(struct proc_dir_entry * dir, struct proc_dir_entry * dp)
 {
-	unsigned int i;
 	struct proc_dir_entry *tmp;
+	int ret;
 	
-	i = get_inode_number();
-	if (i == 0)
-		return -EAGAIN;
-	dp->low_ino = i;
+	ret = proc_alloc_inum(&dp->low_ino);
+	if (ret)
+		return ret;
 
 	if (S_ISDIR(dp->mode)) {
 		if (dp->proc_iops == NULL) {
@@ -764,7 +764,7 @@ EXPORT_SYMBOL(proc_create_data);
 
 static void free_proc_entry(struct proc_dir_entry *de)
 {
-	release_inode_number(de->low_ino);
+	proc_free_inum(de->low_ino);
 
 	if (S_ISLNK(de->mode))
 		kfree(de->data);
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 3144781..bf1d000 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -176,6 +176,8 @@ extern struct proc_dir_entry *proc_net_mkdir(struct net *net, const char *name,
 extern struct file *proc_ns_fget(int fd);
 extern bool proc_ns_inode(struct inode *inode);
 
+extern int proc_alloc_inum(unsigned int *pino);
+extern void proc_free_inum(unsigned int inum);
 #else
 
 #define proc_net_fops_create(net, name, mode, fops)  ({ (void)(mode), NULL; })
@@ -235,6 +237,14 @@ static inline bool proc_ns_inode(struct inode *inode)
 	return false;
 }
 
+static inline int proc_alloc_inum(unsigned int *inum)
+{
+	*inum = 1;
+	return 0;
+}
+static inline void proc_free_inum(unsigned int inum)
+{
+}
 #endif /* CONFIG_PROC_FS */
 
 #if !defined(CONFIG_PROC_KCORE)
-- 
1.7.5.4

