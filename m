Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320Ab1GLXiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 19:38:12 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:58730 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753734Ab1GLXho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 19:37:44 -0400
From: Serge Hallyn <serge@hallyn.com>
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Cc: dhowells@redhat.com, ebiederm@xmission.com,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: [RFC PATCH 02/14] allow root in container to copy namespaces
Date: Tue, 12 Jul 2011 23:30:40 +0000
Message-Id: <1310513452-13397-3-git-send-email-serge@hallyn.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1310513452-13397-1-git-send-email-serge@hallyn.com>
References: <1310513452-13397-1-git-send-email-serge@hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serge E. Hallyn <serge.hallyn@canonical.com>

Othewise nested containers with user namespaces won't be possible.

It's true that user namespaces are not yet fully isolated, but for
that same reason there are far worse things that root in a child
user ns can do.  Spawning a child user ns is not in itself bad.

This patch also allows setns for root in a container:
@Eric Biederman: are there gotchas in allowing setns from child
userns?

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/fork.c    |    4 ++--
 kernel/nsproxy.c |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 0276c30..01d7564 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1475,8 +1475,8 @@ long do_fork(unsigned long clone_flags,
 		/* hopefully this check will go away when userns support is
 		 * complete
 		 */
-		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SETUID) ||
-				!capable(CAP_SETGID))
+		if (!nsown_capable(CAP_SYS_ADMIN) || !nsown_capable(CAP_SETUID) ||
+				!nsown_capable(CAP_SETGID))
 			return -EPERM;
 	}
 
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index d6a00f3..a687405 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -134,7 +134,7 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
 				CLONE_NEWPID | CLONE_NEWNET)))
 		return 0;
 
-	if (!capable(CAP_SYS_ADMIN)) {
+	if (!nsown_capable(CAP_SYS_ADMIN)) {
 		err = -EPERM;
 		goto out;
 	}
@@ -191,7 +191,7 @@ int unshare_nsproxy_namespaces(unsigned long unshare_flags,
 			       CLONE_NEWNET)))
 		return 0;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!nsown_capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
 	*new_nsp = create_new_namespaces(unshare_flags, current,
@@ -241,7 +241,7 @@ SYSCALL_DEFINE2(setns, int, fd, int, nstype)
 	struct file *file;
 	int err;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!nsown_capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
 	file = proc_ns_fget(fd);
-- 
1.7.4.1

