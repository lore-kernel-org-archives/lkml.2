Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab0JPUeu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 16:34:50 -0400
Received: from www.tglx.de ([62.245.132.106]:47198 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528Ab0JPUet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 16:34:49 -0400
Date: Sat, 16 Oct 2010 22:34:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Ted Ts'o" <tytso@mit.edu>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: jbd2: Convert jbd2_slab_create_sem to mutex
Message-ID: <alpine.LFD.2.00.1010162231480.2496@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jbd2_slab_create_sem is used as a mutex, so make it one.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 fs/jbd2/journal.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-next/fs/jbd2/journal.c
===================================================================
--- linux-next.orig/fs/jbd2/journal.c
+++ linux-next/fs/jbd2/journal.c
@@ -1838,7 +1838,7 @@ size_t journal_tag_bytes(journal_t *jour
  */
 #define JBD2_MAX_SLABS 8
 static struct kmem_cache *jbd2_slab[JBD2_MAX_SLABS];
-static DECLARE_MUTEX(jbd2_slab_create_sem);
+static DEFINE_MUTEX(jbd2_slab_create_mutex);
 
 static const char *jbd2_slab_names[JBD2_MAX_SLABS] = {
 	"jbd2_1k", "jbd2_2k", "jbd2_4k", "jbd2_8k",
@@ -1870,16 +1870,16 @@ static int jbd2_journal_create_slab(size
 
 	if (unlikely(i < 0))
 		i = 0;
-	down(&jbd2_slab_create_sem);
+	mutex_lock(&jbd2_slab_create_mutex);
 	if (jbd2_slab[i]) {
-		up(&jbd2_slab_create_sem);
+		mutex_unlock(&jbd2_slab_create_mutex);
 		return 0;	/* Already created */
 	}
 
 	slab_size = 1 << (i+10);
 	jbd2_slab[i] = kmem_cache_create(jbd2_slab_names[i], slab_size,
 					 slab_size, 0, NULL);
-	up(&jbd2_slab_create_sem);
+	mutex_unlock(&jbd2_slab_create_mutex);
 	if (!jbd2_slab[i]) {
 		printk(KERN_EMERG "JBD2: no memory for jbd2_slab cache\n");
 		return -ENOMEM;
