Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab1EABnt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:43:49 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61911 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753Ab1EABiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:38:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=oFU2tpVBqf6C2ZLH5C+84m6uUUD+9CHONOYzoFz5X1oj1wXhChrfTNkbMaVFl5EVpM
         WFVXJH/spxf5qCD3Qnv583a1W+gR3BLh+l9X9PTrLaCt0U1N0Lm5hIcBvwJXjbpNHzge
         PyffUkas6O8cvmFYp3OAFGkQdJm3wHzN40Hqc=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 69/69] RFC: sysctl: convert read-write lock to RCU
Date: Sun,  1 May 2011 03:36:39 +0200
Message-Id: <1304213799-10257-70-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apologies to reviewers who will feel insulted reading this. This patch
is just for kicks - and by kicks I mean ass-kicks for such an awful
misuse of the RCU API. I haven't done anything with RCUs until now and
I'm very unsure about the sanity of this patch.

This patch replaces the reader-writer lock protected lists ctl_subdirs
and ctl_tables with RCU protected lists.

Unlike in the RCU sniplets I found, where the Reader part only read
data from the object - Updates were done on a separate Copy (RCU ...),
here readers do change some data in the list elements (data access
protected by a separate spin lock), but does not touch the list_head.

read-side:
  - uses the for...rcu list traversal for DEC Alpha memory whatever
  - rcu_read_(un)lock make sure the grace period is as long as needed

write-site:
  - writers are synchronized with a spin-lock
  - list adding/removing is done with list_add_tail_rcu/list_del_rcu
  - freeing of elements is done after the grace period has ended (call_rcu)

Also note that there may be unwanted interactions with the RCU
protected VFS routines: ctl_table_header elements are scheduled to be
freed when all references to them have disappeared. This means after
removing the element from the list of at a later time (also with
call_rcu). I don't think that delaying free-ing some more would be a
problem, but I may be very wrong.

Free-ing of ctl_table_header is done with free_head.  This is
scheduled to be called with call_rcu in two places:

- sysctl_proc_inode_put() called from the VFS by proc_evict_inode which uses
       rcu_assign_pointer(PROC_I(inode)->sysctl, NULL)
   to delete the VFS's last reference to the object

- unregister_sysctl_table (no connection to the VFS).

Each of them determines if all references to that object have
disappeared, and if so, schedule the object to be freed with call_rcu.

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 fs/proc/proc_sysctl.c |    8 ++++----
 kernel/sysctl.c       |   23 +++++++++++------------
 kernel/sysctl_check.c |    5 +++--
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index c0cc16b..692acbb 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -79,7 +79,7 @@ retry:
 	sysctl_read_lock_head(head);
 
 	/* first check whether a subdirectory has the searched-for name */
-	list_for_each_entry(h, &head->ctl_subdirs, ctl_entry) {
+	list_for_each_entry_rcu(h, &head->ctl_subdirs, ctl_entry) {
 		if (IS_ERR(sysctl_fs_get(h)))
 			continue;
 
@@ -91,7 +91,7 @@ retry:
 	}
 
 	/* no subdir with that name, look for the file in the ctl_tables */
-	list_for_each_entry(h, &head->ctl_tables, ctl_entry) {
+	list_for_each_entry_rcu(h, &head->ctl_tables, ctl_entry) {
 		if (IS_ERR(sysctl_fs_get(h)))
 			continue;
 
@@ -230,7 +230,7 @@ static int scan(struct ctl_table_header *head,
 
 	sysctl_read_lock_head(head);
 
-	list_for_each_entry(h, &head->ctl_subdirs, ctl_entry) {
+	list_for_each_entry_rcu(h, &head->ctl_subdirs, ctl_entry) {
 		if (*pos < file->f_pos) {
 			(*pos)++;
 			continue;
@@ -248,7 +248,7 @@ static int scan(struct ctl_table_header *head,
 		(*pos)++;
 	}
 
-	list_for_each_entry(h, &head->ctl_tables, ctl_entry) {
+	list_for_each_entry_rcu(h, &head->ctl_tables, ctl_entry) {
 		ctl_table *t;
 
 		if (IS_ERR(sysctl_fs_get(h)))
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 6747259..76dfcd7 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1491,28 +1491,26 @@ static struct ctl_table dev_table[] = {
 static DEFINE_SPINLOCK(sysctl_lock);
 
 
-/* if it's deemed necessary, we can create a per-header rwsem. For now
- * a global one will do. */
-static DECLARE_RWSEM(sysctl_rwsem);
+/* protection for the headers' ctl_subdirs/ctl_tables lists */
+static DEFINE_SPINLOCK(sysctl_list_lock);
 void sysctl_write_lock_head(struct ctl_table_header *head)
 {
-	down_write(&sysctl_rwsem);
+	spin_lock(&sysctl_list_lock);
 }
 void sysctl_write_unlock_head(struct ctl_table_header *head)
 {
-	up_write(&sysctl_rwsem);
+	spin_unlock(&sysctl_list_lock);
 }
 void sysctl_read_lock_head(struct ctl_table_header *head)
 {
-	down_read(&sysctl_rwsem);
+	rcu_read_lock();
 }
 void sysctl_read_unlock_head(struct ctl_table_header *head)
 {
-	up_read(&sysctl_rwsem);
+	rcu_read_unlock();
 }
 
 
-
 /* called under sysctl_lock, will reacquire if has to wait */
 static void start_unregistering(struct ctl_table_header *p)
 {
@@ -1768,6 +1766,7 @@ static struct ctl_table_header *alloc_sysctl_header(struct ctl_table_group *grou
 	h->ctl_table_arg = NULL;
 	h->unregistering = NULL;
 	h->ctl_group = group;
+	INIT_LIST_HEAD(&h->ctl_entry);
 
 	return h;
 }
@@ -1779,7 +1778,7 @@ static struct ctl_table_header *mkdir_existing_dir(struct ctl_table_header *pare
 						   const char *name)
 {
 	struct ctl_table_header *h;
-	list_for_each_entry(h, &parent->ctl_subdirs, ctl_entry) {
+	list_for_each_entry_rcu(h, &parent->ctl_subdirs, ctl_entry) {
 		if (IS_ERR(sysctl_fs_get(h)))
 			continue;
 		if (strcmp(name, h->dirname) == 0) {
@@ -1834,7 +1833,7 @@ static struct ctl_table_header *mkdir_new_dir(struct ctl_table_header *parent,
 {
 	dir->parent = parent;
 	header_refs_inc(dir);
-	list_add_tail(&dir->ctl_entry, &parent->ctl_subdirs);
+	list_add_tail_rcu(&dir->ctl_entry, &parent->ctl_subdirs);
 	return dir;
 }
 
@@ -2028,7 +2027,7 @@ struct ctl_table_header *__register_sysctl_paths(
 	failed_duplicate_check = sysctl_check_duplicates(header);
 #endif
 	if (!failed_duplicate_check)
-		list_add_tail(&header->ctl_entry, &header->parent->ctl_tables);
+		list_add_tail_rcu(&header->ctl_entry, &header->parent->ctl_tables);
 
 	sysctl_write_unlock_head(header->parent);
 
@@ -2081,7 +2080,7 @@ void unregister_sysctl_table(struct ctl_table_header *header)
 		spin_lock(&sysctl_lock);
 		if (!--header->header_refs) {
 			start_unregistering(header);
-			list_del_init(&header->ctl_entry);
+			list_del_rcu(&header->ctl_entry);
 			if (!header->proc_inode_refs)
 				call_rcu(&header->rcu, free_head);
 		}
diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
index ccd39a3..03db5c5 100644
--- a/kernel/sysctl_check.c
+++ b/kernel/sysctl_check.c
@@ -1,5 +1,6 @@
 #include <linux/sysctl.h>
 #include <linux/string.h>
+#include <linux/rculist.h>
 
 /*
  * @path: the path to the offender
@@ -118,7 +119,7 @@ int sysctl_check_duplicates(struct ctl_table_header *header)
 	struct ctl_table_header *dir = header->parent;
 	struct ctl_table_header *h;
 
-	list_for_each_entry(h, &dir->ctl_subdirs, ctl_entry) {
+	list_for_each_entry_rcu(h, &dir->ctl_subdirs, ctl_entry) {
 		if (IS_ERR(sysctl_fs_get(h)))
 			continue;
 
@@ -130,7 +131,7 @@ int sysctl_check_duplicates(struct ctl_table_header *header)
 		sysctl_fs_put(h);
 	}
 
-	list_for_each_entry(h, &dir->ctl_tables, ctl_entry) {
+	list_for_each_entry_rcu(h, &dir->ctl_tables, ctl_entry) {
 		ctl_table *t;
 
 		if (IS_ERR(sysctl_fs_get(h)))
-- 
1.7.5.134.g1c08b

