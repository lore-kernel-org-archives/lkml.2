Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645Ab1DZVZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:25:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:61258 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932335Ab1DZVOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="738831901"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: torvalds@linux-foundation.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [73/106] proc: do proper range check on readdir offset
Message-Id: <20110426211354.98F543E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Linus Torvalds <torvalds@linux-foundation.org>

commit d8bdc59f215e62098bc5b4256fd9928bf27053a1 upstream.

Rather than pass in some random truncated offset to the pid-related
functions, check that the offset is in range up-front.

This is just cleanup, the previous commit fixed the real problem.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/proc/base.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/fs/proc/base.c
===================================================================
--- linux-2.6.35.y.orig/fs/proc/base.c
+++ linux-2.6.35.y/fs/proc/base.c
@@ -2867,11 +2867,16 @@ static int proc_pid_fill_cache(struct fi
 /* for the /proc/ directory itself, after non-process stuff has been done */
 int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir)
 {
-	unsigned int nr = filp->f_pos - FIRST_PROCESS_ENTRY;
-	struct task_struct *reaper = get_proc_task(filp->f_path.dentry->d_inode);
+	unsigned int nr;
+	struct task_struct *reaper;
 	struct tgid_iter iter;
 	struct pid_namespace *ns;
 
+	if (filp->f_pos >= PID_MAX_LIMIT + TGID_OFFSET)
+		goto out_no_task;
+	nr = filp->f_pos - FIRST_PROCESS_ENTRY;
+
+	reaper = get_proc_task(filp->f_path.dentry->d_inode);
 	if (!reaper)
 		goto out_no_task;
 
