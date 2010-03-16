Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab0CPTkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 15:40:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755357Ab0CPTkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 15:40:01 -0400
Date: Tue, 16 Mar 2010 20:38:31 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org,
       David Howells <dhowells@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>
Subject: [PATCH 1/4] coredump: factor out the not-ispipe file checks
Message-ID: <20100316193831.GB31632@redhat.com>
References: <20100315122908.GB16175@hmsreliant.think-freely.org> <20100315194609.GA10896@redhat.com> <20100316193750.GA31632@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100316193750.GA31632@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_coredump() does a lot of file checks after it opens the file or
calls usermode helper. But all of these checks are only needed in
!ispipe case.

Move this code into the "else" branch and kill the ugly repetitive
ispipe checks.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 fs/exec.c |   61 ++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 30 insertions(+), 31 deletions(-)

--- 34-rc1/fs/exec.c~1_ISREG	2010-03-15 20:00:42.000000000 +0100
+++ 34-rc1/fs/exec.c	2010-03-16 18:06:12.000000000 +0100
@@ -1834,7 +1834,6 @@ void do_coredump(long signr, int exit_co
 	char corename[CORENAME_MAX_SIZE + 1];
 	struct mm_struct *mm = current->mm;
 	struct linux_binfmt * binfmt;
-	struct inode * inode;
 	const struct cred *old_cred;
 	struct cred *cred;
 	int retval = 0;
@@ -1911,9 +1910,6 @@ void do_coredump(long signr, int exit_co
 	ispipe = format_corename(corename, signr);
 	unlock_kernel();
 
-	if ((!ispipe) && (cprm.limit < binfmt->min_coredump))
-		goto fail_unlock;
-
  	if (ispipe) {
 		if (cprm.limit == 1) {
 			/*
@@ -1966,39 +1962,42 @@ void do_coredump(long signr, int exit_co
 			       corename);
 			goto fail_dropcount;
  		}
- 	} else
+	} else {
+		struct inode *inode;
+
+		if (cprm.limit < binfmt->min_coredump)
+			goto fail_unlock;
+
 		cprm.file = filp_open(corename,
 				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
 				 0600);
-	if (IS_ERR(cprm.file))
-		goto fail_dropcount;
-	inode = cprm.file->f_path.dentry->d_inode;
-	if (inode->i_nlink > 1)
-		goto close_fail;	/* multiple links - don't dump */
-	if (!ispipe && d_unhashed(cprm.file->f_path.dentry))
-		goto close_fail;
+		if (IS_ERR(cprm.file))
+			goto fail_unlock;
 
-	/* AK: actually i see no reason to not allow this for named pipes etc.,
-	   but keep the previous behaviour for now. */
-	if (!ispipe && !S_ISREG(inode->i_mode))
-		goto close_fail;
-	/*
-	 * Dont allow local users get cute and trick others to coredump
-	 * into their pre-created files:
-	 * Note, this is not relevant for pipes
-	 */
-	if (!ispipe && (inode->i_uid != current_fsuid()))
-		goto close_fail;
-	if (!cprm.file->f_op)
-		goto close_fail;
-	if (!cprm.file->f_op->write)
-		goto close_fail;
-	if (!ispipe &&
-	    do_truncate(cprm.file->f_path.dentry, 0, 0, cprm.file) != 0)
-		goto close_fail;
+		inode = cprm.file->f_path.dentry->d_inode;
+		if (inode->i_nlink > 1)
+			goto close_fail;
+		if (d_unhashed(cprm.file->f_path.dentry))
+			goto close_fail;
+		/*
+		 * AK: actually i see no reason to not allow this for named
+		 * pipes etc, but keep the previous behaviour for now.
+		 */
+		if (!S_ISREG(inode->i_mode))
+			goto close_fail;
+		/*
+		 * Dont allow local users get cute and trick others to coredump
+		 * into their pre-created files.
+		 */
+		if (inode->i_uid != current_fsuid())
+			goto close_fail;
+		if (!cprm.file->f_op || !cprm.file->f_op->write)
+			goto close_fail;
+		if (do_truncate(cprm.file->f_path.dentry, 0, 0, cprm.file))
+			goto close_fail;
+	}
 
 	retval = binfmt->core_dump(&cprm);
-
 	if (retval)
 		current->signal->group_exit_code |= 0x80;
 close_fail:

