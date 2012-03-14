Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030552Ab2CNCae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 22:30:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11079 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030489Ab2CNC3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 22:29:48 -0400
X-Authority-Analysis: v=2.0 cv=M9vP2lMs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=OSyqwHdVuCwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=TWj7lURODk-eakmO48EA:9 a=Uj1Xsr_Pkzl59ZrZtf4A:7 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120314022945.223176076@goodmis.org>
User-Agent: quilt/0.50-1
Date: Tue, 13 Mar 2012 22:27:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, stable-rt@vger.kernel.org
Subject: [PATCH RT 4/7] fs: dcache: Use cpu_chill() in trylock loops
References: <20120314022658.783312660@goodmis.org>
Content-Disposition: inline; filename=0004-fs-dcache-Use-cpu_chill-in-trylock-loops.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Retry loops on RT might loop forever when the modifying side was
preempted. Use cpu_chill() instead of cpu_relax() to let the system
make progress.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/autofs4/autofs_i.h |    1 +
 fs/autofs4/expire.c   |    2 +-
 fs/dcache.c           |    7 ++++---
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index b620114..83424ab 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -34,6 +34,7 @@
 #include <linux/sched.h>
 #include <linux/mount.h>
 #include <linux/namei.h>
+#include <linux/delay.h>
 #include <asm/current.h>
 #include <asm/uaccess.h>
 
diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index d8b6184..f4abda3 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -170,7 +170,7 @@ again:
 			parent = p->d_parent;
 			if (!seq_spin_trylock(&parent->d_lock)) {
 				seq_spin_unlock(&p->d_lock);
-				cpu_relax();
+				cpu_chill();
 				goto relock;
 			}
 			seq_spin_unlock(&p->d_lock);
diff --git a/fs/dcache.c b/fs/dcache.c
index 10580be..eedf276 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -36,6 +36,7 @@
 #include <linux/bit_spinlock.h>
 #include <linux/rculist_bl.h>
 #include <linux/prefetch.h>
+#include <linux/delay.h>
 #include "internal.h"
 
 /*
@@ -360,7 +361,7 @@ static inline struct dentry *dentry_kill(struct dentry *dentry, int ref)
 	if (inode && !spin_trylock(&inode->i_lock)) {
 relock:
 		seq_spin_unlock(&dentry->d_lock);
-		cpu_relax();
+		cpu_chill();
 		return dentry; /* try again with same dentry */
 	}
 	if (IS_ROOT(dentry))
@@ -738,7 +739,7 @@ relock:
 
 		if (!seq_spin_trylock(&dentry->d_lock)) {
 			spin_unlock(&dcache_lru_lock);
-			cpu_relax();
+			cpu_chill();
 			goto relock;
 		}
 
@@ -2053,7 +2054,7 @@ again:
 	if (dentry->d_count == 1) {
 		if (inode && !spin_trylock(&inode->i_lock)) {
 			seq_spin_unlock(&dentry->d_lock);
-			cpu_relax();
+			cpu_chill();
 			goto again;
 		}
 		dentry->d_flags &= ~DCACHE_CANT_MOUNT;
-- 
1.7.8.3


