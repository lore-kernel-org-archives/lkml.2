Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab0FXC4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 22:56:08 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:40141 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab0FXC4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 22:56:06 -0400
Message-ID: <4C22C944.4040700@austin.ibm.com>
Date: Wed, 23 Jun 2010 21:56:04 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Store sysfs dirent structs in rbtree
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On very large systems, i.e. those with > 1 TB of memory, the boot times become
exponentially worse due to the string compares used to ensure duplicate sysfs
directories are not created.  I am working with systems that create roughly
63,000 memory sections in sysfs at boot time.  This translates into just over 9
minutes of creating sysfs entries for the memory on the system at boot.  Other
systems have observed 40 minutes for 1.5 TB and times measured in hours for 2
TB systems.

This patch updates the sysfs code to store the sysfs directory entries in a
reb-black tree sorted aphabetically.  This significantly reduces the number of
string compares required to determine if a new directory is a duplicate.  On
the 1 TB system the sysfs memory creation time went from 9.1 minutes to 2.2
minutes.

Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
---
 fs/sysfs/dir.c   |   60 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 fs/sysfs/sysfs.h |    3 ++
 2 files changed, 56 insertions(+), 7 deletions(-)

Index: linux-2.6/fs/sysfs/dir.c
===================================================================
--- linux-2.6.orig/fs/sysfs/dir.c	2010-06-23 15:07:22.000000000 -0500
+++ linux-2.6/fs/sysfs/dir.c	2010-06-23 20:12:46.000000000 -0500
@@ -30,6 +30,37 @@
 static DEFINE_SPINLOCK(sysfs_ino_lock);
 static DEFINE_IDA(sysfs_ino_ida);
 
+static struct sysfs_dirent *to_sysfs_dirent(struct rb_node *node)
+{
+	struct sysfs_elem_dir *sysdir;
+
+	sysdir = rb_entry(node, struct sysfs_elem_dir, rb_node);
+	return container_of(sysdir, struct sysfs_dirent, s_dir);
+}
+
+static void sysfs_dirent_insert(struct sysfs_dirent *sd)
+{
+	struct sysfs_dirent *parent_sd = sd->s_parent;
+	struct sysfs_dirent *d;
+	struct rb_node **p = &parent_sd->s_dir.rb_root.rb_node;
+	struct rb_node *parent = NULL;
+
+	while (*p) {
+		int cmp_val;
+		parent = *p;
+		d = to_sysfs_dirent(parent);
+
+		cmp_val = strcmp(d->s_name, sd->s_name);
+		if (cmp_val < 0)
+			p = &parent->rb_left;
+		if (cmp_val > 0)
+			p = &parent->rb_right;
+	}
+
+	rb_link_node(&sd->s_dir.rb_node, parent, p);
+	rb_insert_color(&sd->s_dir.rb_node, &parent_sd->s_dir.rb_root);
+}
+
 /**
  *	sysfs_link_sibling - link sysfs_dirent into sibling list
  *	@sd: sysfs_dirent of interest
@@ -57,6 +88,9 @@
 	}
 	sd->s_sibling = *pos;
 	*pos = sd;
+
+	/* Add entry to rb tree */
+	sysfs_dirent_insert(sd);
 }
 
 /**
@@ -81,6 +115,8 @@
 			break;
 		}
 	}
+
+	rb_erase(&sd->s_dir.rb_node, &sd->s_parent->s_dir.rb_root);
 }
 
 /**
@@ -536,14 +572,24 @@
 				       const void *ns,
 				       const unsigned char *name)
 {
-	struct sysfs_dirent *sd;
-
-	for (sd = parent_sd->s_dir.children; sd; sd = sd->s_sibling) {
-		if (ns && sd->s_ns && (sd->s_ns != ns))
-			continue;
-		if (!strcmp(sd->s_name, name))
-			return sd;
+	struct sysfs_dirent *d;
+	struct rb_node **p = &parent_sd->s_dir.rb_root.rb_node;
+	struct rb_node *parent = NULL;
+
+	while (*p) {
+		int cmp_val;
+		parent = *p;
+		d = to_sysfs_dirent(parent);
+
+		cmp_val = strcmp(d->s_name, name);
+		if (cmp_val == 0)
+			return d;
+		else if (cmp_val < 0)
+			p = &parent->rb_left;
+		else /* (cmp_val > 0) */
+			p = &parent->rb_right;
 	}
+
 	return NULL;
 }
 
Index: linux-2.6/fs/sysfs/sysfs.h
===================================================================
--- linux-2.6.orig/fs/sysfs/sysfs.h	2010-06-23 15:07:22.000000000 -0500
+++ linux-2.6/fs/sysfs/sysfs.h	2010-06-23 20:12:46.000000000 -0500
@@ -10,12 +10,15 @@
 
 #include <linux/lockdep.h>
 #include <linux/fs.h>
+#include <linux/rbtree.h>
 
 struct sysfs_open_dirent;
 
 /* type-specific structures for sysfs_dirent->s_* union members */
 struct sysfs_elem_dir {
 	struct kobject		*kobj;
+	struct rb_root		rb_root;
+	struct rb_node		rb_node;
 	/* children list starts here and goes through sd->s_sibling */
 	struct sysfs_dirent	*children;
 };
