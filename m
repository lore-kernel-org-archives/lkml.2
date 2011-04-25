Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488Ab1DYUdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:33:18 -0400
Received: from 1wt.eu ([62.212.114.60]:34572 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932392Ab1DYUZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:23 -0400
Message-Id: <20110425200240.339262153@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:05:21 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 169/173] proc: do proper range check on readdir offset
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit d8bdc59f215e62098bc5b4256fd9928bf27053a1 upstream.

Rather than pass in some random truncated offset to the pid-related
functions, check that the offset is in range up-front.

This is just cleanup, the previous commit fixed the real problem.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/base.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2806,11 +2806,16 @@ static int proc_pid_fill_cache(struct fi
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
 


