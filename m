Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab2KMLqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 06:46:54 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45770 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab2KMLqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 06:46:52 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: raven@themaw.net
Cc: autofs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, sukadev@linux.vnet.ibm.com,
        serge.hallyn@canonical.com, ebiederm@xmission.com
Subject: [PATCH 2/2] autofs4: translate pids to the right namespace for the daemon
References: <87sj8drafh.fsf@tucsk.pomaz.szeredi.hu>
Date: Tue, 13 Nov 2012 12:49:04 +0100
In-Reply-To: <87sj8drafh.fsf@tucsk.pomaz.szeredi.hu> (Miklos Szeredi's message
	of "Tue, 13 Nov 2012 12:48:02 +0100")
Message-ID: <87obj1radr.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

The PID and the TGID of the process tringgering the mount are sent to the
daemon.  Currently the global pid values are sent (ones valid in the initial pid
namespace) but this is wrong if the autofs daemon itself is not running in the
initial pid namespace.

So send the pid values that are valid in the namespace of the autofs daemon.

The namespace to use is taken from the oz_pgrp pid pointer, which was set at
mount time to the mounting process' pid namespace.

If the pid translation fails (the triggering process is in an unrelated pid
namespace) then the automount fails with ENOENT.

Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/autofs4/waitq.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)
03944aae0b9cb4a36d091f275d2f2217447b27ec
Index: linux-2.6/fs/autofs4/waitq.c
===================================================================
--- linux-2.6.orig/fs/autofs4/waitq.c	2012-11-12 19:07:06.000000000 +0100
+++ linux-2.6/fs/autofs4/waitq.c	2012-11-12 19:57:10.000000000 +0100
@@ -354,11 +354,23 @@ int autofs4_wait(struct autofs_sb_info *
 	struct qstr qstr;
 	char *name;
 	int status, ret, type;
+	pid_t pid;
+	pid_t tgid;
 
 	/* In catatonic mode, we don't wait for nobody */
 	if (sbi->catatonic)
 		return -ENOENT;
 
+	/*
+	 * Try translating pids to the namespace of the daemon.
+	 *
+	 * Zero means failure: we are in an unrelated pid namespace.
+	 */
+	pid = task_pid_nr_ns(current, ns_of_pid(sbi->oz_pgrp));
+	tgid = task_tgid_nr_ns(current, ns_of_pid(sbi->oz_pgrp));
+	if (pid == 0 || tgid == 0)
+		return -ENOENT;
+
 	if (!dentry->d_inode) {
 		/*
 		 * A wait for a negative dentry is invalid for certain
@@ -424,8 +436,8 @@ int autofs4_wait(struct autofs_sb_info *
 		wq->ino = autofs4_get_ino(sbi);
 		wq->uid = current_uid();
 		wq->gid = current_gid();
-		wq->pid = current->pid;
-		wq->tgid = current->tgid;
+		wq->pid = pid;
+		wq->tgid = tgid;
 		wq->status = -EINTR; /* Status return if interrupted */
 		wq->wait_ctr = 2;
 		mutex_unlock(&sbi->wq_mutex);
