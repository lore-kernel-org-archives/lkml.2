Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab0JRRes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 13:34:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37244 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab0JRRer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 13:34:47 -0400
Date: Mon, 18 Oct 2010 13:34:25 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Eric Paris <eparis@redhat.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, James Morris <jmorris@namei.org>,
        Christoph Hellwig <hch@infradead.org>, kernel@lists.fedoraproject.org,
        Mimi Zohar <zohar@us.ibm.com>, warthog9@kernel.org,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Serge Hallyn <serue@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: ima: use of radix tree cache indexing == massive waste of memory?
Message-ID: <20101018173425.GF8332@bombadil.infradead.org>
References: <20101016065206.GO4681@dastard>
 <20101016192027.GA6883@infradead.org>
 <ebc4973c-6c11-4397-b8b0-c212a27abce4@email.android.com>
 <20101017004945.GE1614@infradead.org>
 <20101017054008.GA16383@elte.hu>
 <20101017184652.GB28060@infradead.org>
 <alpine.LRH.2.00.1010181127480.9476@tundra.namei.org>
 <20101018062530.GD8332@bombadil.infradead.org>
 <1287420534.2530.67.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287420534.2530.67.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 12:48:54PM -0400, Eric Paris wrote:
>

A Red Hatter pointed out that ima_enabled needs to be exported for
modular users of IMA (like NFS...) and also Eric's points lead me to
think maybe just rolling them into the hooks might be a better solution
in the interim for Fedora 14, and we'll pull in the rbtree and other
fixes post-release and can talk about switching the toggle.

Thanks to you all for being so responsive about these issues.

regards, Kyle

---

 security/integrity/ima/ima.h      |    1 +
 security/integrity/ima/ima_iint.c |    9 +++++++++
 security/integrity/ima/ima_main.c |   24 +++++++++++++++++++++---
 3 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 3fbcd1d..65c3977 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -37,6 +37,7 @@ enum tpm_pcrs { TPM_PCR0 = 0, TPM_PCR8 = 8 };
 /* set during initialization */
 extern int iint_initialized;
 extern int ima_initialized;
+extern int ima_enabled;
 extern int ima_used_chip;
 extern char *ima_hash;
 
diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
index afba4ae..3d191ef 100644
--- a/security/integrity/ima/ima_iint.c
+++ b/security/integrity/ima/ima_iint.c
@@ -54,6 +54,9 @@ int ima_inode_alloc(struct inode *inode)
 	struct ima_iint_cache *iint = NULL;
 	int rc = 0;
 
+	if (!ima_enabled)
+		return 0;
+
 	iint = kmem_cache_alloc(iint_cache, GFP_NOFS);
 	if (!iint)
 		return -ENOMEM;
@@ -116,6 +119,9 @@ void ima_inode_free(struct inode *inode)
 {
 	struct ima_iint_cache *iint;
 
+	if (!ima_enabled)
+		return;
+
 	spin_lock(&ima_iint_lock);
 	iint = radix_tree_delete(&ima_iint_store, (unsigned long)inode);
 	spin_unlock(&ima_iint_lock);
@@ -139,6 +145,9 @@ static void init_once(void *foo)
 
 static int __init ima_iintcache_init(void)
 {
+	if (!ima_enabled)
+		return 0;
+
 	iint_cache =
 	    kmem_cache_create("iint_cache", sizeof(struct ima_iint_cache), 0,
 			      SLAB_PANIC, init_once);
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index e662b89..6e91905 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -26,6 +26,7 @@
 #include "ima.h"
 
 int ima_initialized;
+int ima_enabled;
 
 char *ima_hash = "sha1";
 static int __init hash_setup(char *str)
@@ -36,6 +37,14 @@ static int __init hash_setup(char *str)
 }
 __setup("ima_hash=", hash_setup);
 
+static int __init ima_enable(char *str)
+{
+	if (strncmp(str, "on", 2) == 0)
+		ima_enabled = 1;
+	return 1;
+}
+__setup("ima=", ima_enable);
+
 struct ima_imbalance {
 	struct hlist_node node;
 	unsigned long fsmagic;
@@ -148,7 +157,7 @@ void ima_counts_get(struct file *file)
 	struct ima_iint_cache *iint;
 	int rc;
 
-	if (!iint_initialized || !S_ISREG(inode->i_mode))
+	if (!ima_enabled || !iint_initialized || !S_ISREG(inode->i_mode))
 		return;
 	iint = ima_iint_find_get(inode);
 	if (!iint)
@@ -215,7 +224,7 @@ void ima_file_free(struct file *file)
 	struct inode *inode = file->f_dentry->d_inode;
 	struct ima_iint_cache *iint;
 
-	if (!iint_initialized || !S_ISREG(inode->i_mode))
+	if (!ima_enabled || !iint_initialized || !S_ISREG(inode->i_mode))
 		return;
 	iint = ima_iint_find_get(inode);
 	if (!iint)
@@ -269,7 +278,7 @@ int ima_file_mmap(struct file *file, unsigned long prot)
 {
 	int rc;
 
-	if (!file)
+	if (!ima_enabled || !file)
 		return 0;
 	if (prot & PROT_EXEC)
 		rc = process_measurement(file, file->f_dentry->d_name.name,
@@ -294,6 +303,9 @@ int ima_bprm_check(struct linux_binprm *bprm)
 {
 	int rc;
 
+	if (!ima_enabled)
+		return 0;
+
 	rc = process_measurement(bprm->file, bprm->filename,
 				 MAY_EXEC, BPRM_CHECK);
 	return 0;
@@ -313,6 +325,9 @@ int ima_file_check(struct file *file, int mask)
 {
 	int rc;
 
+	if (!ima_enabled)
+		return 0;
+
 	rc = process_measurement(file, file->f_dentry->d_name.name,
 				 mask & (MAY_READ | MAY_WRITE | MAY_EXEC),
 				 FILE_CHECK);
@@ -324,6 +339,9 @@ static int __init init_ima(void)
 {
 	int error;
 
+	if (!ima_enabled)
+		return 0;
+
 	error = ima_init();
 	ima_initialized = 1;
 	return error;
-- 
1.7.3.1

