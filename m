Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab0J3KQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 06:16:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:44027 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220Ab0J3KQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 06:16:52 -0400
Date: Sat, 30 Oct 2010 10:15:50 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        akpm@linux-foundation.org, tglx@linutronix.de, tytso@mit.edu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, tglx@linutronix.de, tytso@mit.edu
In-Reply-To: <alpine.LFD.2.00.1010162231480.2496@localhost6.localdomain6>
References: <alpine.LFD.2.00.1010162231480.2496@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] jbd2: Convert jbd2_slab_create_sem to mutex
Message-ID: <tip-51dfacdef38b1dd6fc58b03dd1725d517516b115@git.kernel.org>
Git-Commit-ID: 51dfacdef38b1dd6fc58b03dd1725d517516b115
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 30 Oct 2010 10:15:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  51dfacdef38b1dd6fc58b03dd1725d517516b115
Gitweb:     http://git.kernel.org/tip/51dfacdef38b1dd6fc58b03dd1725d517516b115
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 16 Oct 2010 22:34:39 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 30 Oct 2010 12:12:50 +0200

jbd2: Convert jbd2_slab_create_sem to mutex

jbd2_slab_create_sem is used as a mutex, so make it one.

[ akpm muttered: We may as well make it local to
jbd2_journal_create_slab() also. ]

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <alpine.LFD.2.00.1010162231480.2496@localhost6.localdomain6>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 fs/jbd2/journal.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 538417c..c590d15 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1838,7 +1838,6 @@ size_t journal_tag_bytes(journal_t *journal)
  */
 #define JBD2_MAX_SLABS 8
 static struct kmem_cache *jbd2_slab[JBD2_MAX_SLABS];
-static DECLARE_MUTEX(jbd2_slab_create_sem);
 
 static const char *jbd2_slab_names[JBD2_MAX_SLABS] = {
 	"jbd2_1k", "jbd2_2k", "jbd2_4k", "jbd2_8k",
@@ -1859,6 +1858,7 @@ static void jbd2_journal_destroy_slabs(void)
 
 static int jbd2_journal_create_slab(size_t size)
 {
+	static DEFINE_MUTEX(jbd2_slab_create_mutex);
 	int i = order_base_2(size) - 10;
 	size_t slab_size;
 
@@ -1870,16 +1870,16 @@ static int jbd2_journal_create_slab(size_t size)
 
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
