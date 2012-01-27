Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab2A0EtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 23:49:18 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:51334 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab2A0Erz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 23:47:55 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Damien Millescamps <damien.millescamps@6wind.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 19/29] sysctl: Rewrite proc_sys_lookup introducing find_entry and lookup_entry.
Date: Thu, 26 Jan 2012 20:50:00 -0800
Message-Id: <1327639810-12760-19-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m1pqe5ah3z.fsf@fess.ebiederm.org>
References: <m1pqe5ah3z.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/XYn4yBGWsl5812jbHmlJY+q3smlvNpis=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the helpers that proc_sys_lookup uses with helpers that work
in terms of an entire sysctl directory.  This is worse for sysctl_lock
hold times but it is much better for code clarity and the code cleanups
to come.

find_in_table is no longer needed so it is removed.

find_entry a general helper to find entries in a directory is added.

lookup_entry is a simple wrapper around find_entry that takes the
sysctl_lock increases the use count if an entry is found and drops
the sysctl_lock.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/proc_sysctl.c |  102 ++++++++++++++++++++++++++++++++++++------------
 1 files changed, 76 insertions(+), 26 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 88d1b06..3b63f29 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -49,6 +49,55 @@ static struct ctl_table_root sysctl_table_root = {
 
 static DEFINE_SPINLOCK(sysctl_lock);
 
+static int namecmp(const char *name1, int len1, const char *name2, int len2)
+{
+	int minlen;
+	int cmp;
+
+	minlen = len1;
+	if (minlen > len2)
+		minlen = len2;
+
+	cmp = memcmp(name1, name2, minlen);
+	if (cmp == 0)
+		cmp = len1 - len2;
+	return cmp;
+}
+
+static struct ctl_table *find_entry(struct ctl_table_header **phead,
+	struct ctl_table_set *set,
+	struct ctl_table_header *dir_head, struct ctl_table *dir,
+	const char *name, int namelen)
+{
+	struct ctl_table_header *head;
+	struct ctl_table *entry;
+
+	if (dir_head->set == set) {
+		for (entry = dir; entry->procname; entry++) {
+			const char *procname = entry->procname;
+			if (namecmp(procname, strlen(procname), name, namelen) == 0) {
+				*phead = dir_head;
+				return entry;
+			}
+		}
+	}
+
+	list_for_each_entry(head, &set->list, ctl_entry) {
+		if (head->unregistering)
+			continue;
+		if (head->attached_to != dir)
+			continue;
+		for (entry = head->attached_by; entry->procname; entry++) {
+			const char *procname = entry->procname;
+			if (namecmp(procname, strlen(procname), name, namelen) == 0) {
+				*phead = head;
+				return entry;
+			}
+		}
+	}
+	return NULL;
+}
+
 static void init_header(struct ctl_table_header *head,
 	struct ctl_table_root *root, struct ctl_table_set *set,
 	struct ctl_table *table)
@@ -168,6 +217,32 @@ lookup_header_list(struct ctl_table_root *root, struct nsproxy *namespaces)
 	return &set->list;
 }
 
+static struct ctl_table *lookup_entry(struct ctl_table_header **phead,
+				      struct ctl_table_header *dir_head,
+				      struct ctl_table *dir,
+				      const char *name, int namelen)
+{
+	struct ctl_table_header *head;
+	struct ctl_table *entry;
+	struct ctl_table_root *root;
+	struct ctl_table_set *set;
+
+	spin_lock(&sysctl_lock);
+	root = &sysctl_table_root;
+	do {
+		set = lookup_header_set(root, current->nsproxy);
+		entry = find_entry(&head, set, dir_head, dir, name, namelen);
+		if (entry && use_table(head))
+			*phead = head;
+		else
+			entry = NULL;
+		root = list_entry(root->root_list.next,
+				  struct ctl_table_root, root_list);
+	} while (!entry && root != &sysctl_table_root);
+	spin_unlock(&sysctl_lock);
+	return entry;
+}
+
 static struct ctl_table_header *__sysctl_head_next(struct nsproxy *namespaces,
 						struct ctl_table_header *prev)
 {
@@ -284,21 +359,6 @@ out:
 	return inode;
 }
 
-static struct ctl_table *find_in_table(struct ctl_table *p, struct qstr *name)
-{
-	for ( ; p->procname; p++) {
-		if (strlen(p->procname) != name->len)
-			continue;
-
-		if (memcmp(p->procname, name->name, name->len) != 0)
-			continue;
-
-		/* I have a match */
-		return p;
-	}
-	return NULL;
-}
-
 static struct ctl_table_header *grab_header(struct inode *inode)
 {
 	struct ctl_table_header *head = PROC_I(inode)->sysctl;
@@ -328,17 +388,7 @@ static struct dentry *proc_sys_lookup(struct inode *dir, struct dentry *dentry,
 
 	table = table ? table->child : &head->ctl_table[1];
 
-	p = find_in_table(table, name);
-	if (!p) {
-		for (h = sysctl_head_next(NULL); h; h = sysctl_head_next(h)) {
-			if (h->attached_to != table)
-				continue;
-			p = find_in_table(h->attached_by, name);
-			if (p)
-				break;
-		}
-	}
-
+	p = lookup_entry(&h, head, table, name->name, name->len);
 	if (!p)
 		goto out;
 
-- 
1.7.2.5

