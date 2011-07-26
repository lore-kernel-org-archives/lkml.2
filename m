Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab1GZS66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 14:58:58 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:41313 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753188Ab1GZS6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 14:58:17 -0400
From: Serge Hallyn <serge@hallyn.com>
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, ebiederm@xmission.com,
        containers@lists.linux-foundation.org, netdev@vger.kernel.org,
        akpm@osdl.org, "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: [PATCH 02/14] allow root in container to copy namespaces
Date: Tue, 26 Jul 2011 18:58:25 +0000
Message-Id: <1311706717-7398-3-git-send-email-serge@hallyn.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1311706717-7398-1-git-send-email-serge@hallyn.com>
References: <1311706717-7398-1-git-send-email-serge@hallyn.com>
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
index 17bf7c8..22d0cf0 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1473,8 +1473,8 @@ long do_fork(unsigned long clone_flags,
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
index 9aeab4b..f50542d 100644
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

