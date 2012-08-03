Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab2HCKzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 06:55:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110Ab2HCKzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 06:55:15 -0400
From: "Daniel P. Berrange" <berrange@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: containers@lists.linux-foundation.org,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH] Forbid invocation of kexec_load() outside initial PID namespace
Date: Fri,  3 Aug 2012 11:53:04 +0100
Message-Id: <1343991184-3619-1-git-send-email-berrange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Daniel P. Berrange" <berrange@redhat.com>

The following commit

    commit cf3f89214ef6a33fad60856bc5ffd7bb2fc4709b
    Author: Daniel Lezcano <daniel.lezcano@free.fr>
    Date:   Wed Mar 28 14:42:51 2012 -0700

    pidns: add reboot_pid_ns() to handle the reboot syscall

introduced custom handling of the reboot() syscall when invoked
from a non-initial PID namespace. The intent was that a process
in a container can be allowed to keep CAP_SYS_BOOT and execute
reboot() to shutdown/reboot just their private container, rather
than the host.

Unfortunately the kexec_load() syscall also relies on the
CAP_SYS_BOOT capability. So by allowing a container to keep
this capability to safely invoke reboot(), they mistakenly
also gain the ability to use kexec_load(). The solution is
to make kexec_load() return -EPERM if invoked from a PID
namespace that is not the initial namespace

Signed-off-by: Daniel P. Berrange <berrange@redhat.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 kernel/kexec.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 0668d58..b152bde 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -947,6 +947,11 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
 	if (!capable(CAP_SYS_BOOT))
 		return -EPERM;
 
+	/* Processes in containers must not be allowed to load a new
+	 * kernel, even if they have CAP_SYS_BOOT */
+	if (task_active_pid_ns(current) != &init_pid_ns)
+		return -EPERM;
+
 	/*
 	 * Verify we have a legal set of flags
 	 * This leaves us room for future extensions.
-- 
1.7.11.2

