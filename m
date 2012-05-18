Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030969Ab2ERDG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:06:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40450 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933644Ab2ERCwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:32 -0400
Message-Id: <20120518023255.447450493@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:02 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>
Subject: [ 08/53] namespaces, pid_ns: fix leakage on fork() failure
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Galbraith <efault@gmx.de>

commit 5e2bf0142231194d36fdc9596b36a261ed2b9fe7 upstream.

Fork() failure post namespace creation for a child cloned with
CLONE_NEWPID leaks pid_namespace/mnt_cache due to proc being mounted
during creation, but not unmounted during cleanup.  Call
pid_ns_release_proc() during cleanup.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Louis Rilling <louis.rilling@kerlabs.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/fork.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index b9372a0..687a15d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -47,6 +47,7 @@
 #include <linux/audit.h>
 #include <linux/memcontrol.h>
 #include <linux/ftrace.h>
+#include <linux/proc_fs.h>
 #include <linux/profile.h>
 #include <linux/rmap.h>
 #include <linux/ksm.h>
@@ -1464,6 +1465,8 @@ bad_fork_cleanup_io:
 	if (p->io_context)
 		exit_io_context(p);
 bad_fork_cleanup_namespaces:
+	if (unlikely(clone_flags & CLONE_NEWPID))
+		pid_ns_release_proc(p->nsproxy->pid_ns);
 	exit_task_namespaces(p);
 bad_fork_cleanup_mm:
 	if (p->mm)
-- 
1.7.10



