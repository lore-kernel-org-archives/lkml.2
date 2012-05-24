Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933522Ab2EXQJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:09:49 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:42194 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757434Ab2EXQIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:08:39 -0400
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: mcgrathr@google.com, hpa@zytor.com, indan@nul.nu, netdev@parisplace.org,
        linux-security-module@vger.kernel.org,
        kernel-hardening@lists.openwall.com, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de,
        luto@mit.edu, serge.hallyn@canonical.com, pmoore@redhat.com,
        akpm@linux-foundation.org, corbet@lwn.net, markus@chromium.org,
        coreyb@linux.vnet.ibm.com, keescook@chromium.org,
        viro@zeniv.linux.org.uk, jmorris@namei.org,
        Will Drewry <wad@chromium.org>
Subject: [RFC PATCH 1/3] seccomp: Don't allow tracers to abuse RET_TRACE
Date: Thu, 24 May 2012 11:07:59 -0500
Message-Id: <1337875681-20717-2-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1337875681-20717-1-git-send-email-wad@chromium.org>
References: <20120522173942.GJ11775@ZenIV.linux.org.uk>
 <1337875681-20717-1-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that consumers of the PTRACE_EVENT_SECCOMP notification
cannot change the system call number for the traced task
without it resulting in the system call being skipped.

Traditionally, tracers will set the system call number to
-1 to skip the system call. This behavior will work as expected
but the tracer will be unable to remap the system call to a valid
system call after the seccomp policy has been evaluated.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 kernel/seccomp.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index ee376be..33f0ad6 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -425,6 +425,10 @@ int __secure_computing(int this_syscall)
 			 */
 			if (fatal_signal_pending(current))
 				break;
+			/* Skip the system call if the tracer changed it. */
+			if (this_syscall !=
+			    syscall_get_nr(current, task_pt_regs(current)))
+				goto skip;
 			return 0;
 		case SECCOMP_RET_ALLOW:
 			return 0;
-- 
1.7.9.5

