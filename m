Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab1DSURp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:17:45 -0400
Received: from kroah.org ([198.145.64.141]:35700 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754954Ab1DSURi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:38 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:49 2011
Message-Id: <20110419201049.182541523@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:09:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [56/70] proc: do proper range check on readdir offset
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

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
@@ -3066,11 +3066,16 @@ static int proc_pid_fill_cache(struct fi
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
 


