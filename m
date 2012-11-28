Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390Ab2K1XPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 18:15:49 -0500
Received: from smtp.outflux.net ([198.145.64.163]:52141 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756254Ab2K1XPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 18:15:39 -0500
Date: Wed, 28 Nov 2012 15:15:28 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jeff Layton <jlayton@redhat.com>, Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@google.com>,
        linux-audit@redhat.com
Subject: [PATCH v2] audit: create explicit AUDIT_SECCOMP event type
Message-ID: <20121128231528.GA12506@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The seccomp path was using AUDIT_ANOM_ABEND from when seccomp mode 1
could only kill a process. While we still want to make sure an audit
record is forced on a kill, this should use a separate record type since
seccomp mode 2 introduces other behaviors. In the case of "handled"
behaviors (process wasn't killed), only emit a record if the process is
under inspection. This change also fixes userspace examination of seccomp
audit events, since it was considered malformed due to missing fields of
the AUDIT_ANOM_ABEND event type.

Cc: Julien Tinnes <jln@google.com>
Cc: Will Drewry <wad@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Steve Grubb <sgrubb@redhat.com>
---
v2:
 - update commit message and add Cc to stable, suggested by Steve Grubb

---
 include/linux/audit.h      |    3 ++-
 include/uapi/linux/audit.h |    1 +
 kernel/auditsc.c           |   14 +++++++++++---
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index bce729a..9d5104d 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -157,7 +157,8 @@ void audit_core_dumps(long signr);
 
 static inline void audit_seccomp(unsigned long syscall, long signr, int code)
 {
-	if (unlikely(!audit_dummy_context()))
+	/* Force a record to be reported if a signal was delivered. */
+	if (signr || unlikely(!audit_dummy_context()))
 		__audit_seccomp(syscall, signr, code);
 }
 
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 76352ac..09a2d94 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -106,6 +106,7 @@
 #define AUDIT_MMAP		1323	/* Record showing descriptor and flags in mmap */
 #define AUDIT_NETFILTER_PKT	1324	/* Packets traversing netfilter chains */
 #define AUDIT_NETFILTER_CFG	1325	/* Netfilter chain modifications */
+#define AUDIT_SECCOMP		1326	/* Secure Computing event */
 
 #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
 #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 2f186ed..157e989 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2735,7 +2735,7 @@ void __audit_mmap_fd(int fd, int flags)
 	context->type = AUDIT_MMAP;
 }
 
-static void audit_log_abend(struct audit_buffer *ab, char *reason, long signr)
+static void audit_log_task(struct audit_buffer *ab)
 {
 	kuid_t auid, uid;
 	kgid_t gid;
@@ -2753,6 +2753,11 @@ static void audit_log_abend(struct audit_buffer *ab, char *reason, long signr)
 	audit_log_task_context(ab);
 	audit_log_format(ab, " pid=%d comm=", current->pid);
 	audit_log_untrustedstring(ab, current->comm);
+}
+
+static void audit_log_abend(struct audit_buffer *ab, char *reason, long signr)
+{
+	audit_log_task(ab);
 	audit_log_format(ab, " reason=");
 	audit_log_string(ab, reason);
 	audit_log_format(ab, " sig=%ld", signr);
@@ -2783,8 +2788,11 @@ void __audit_seccomp(unsigned long syscall, long signr, int code)
 {
 	struct audit_buffer *ab;
 
-	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_ANOM_ABEND);
-	audit_log_abend(ab, "seccomp", signr);
+	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_SECCOMP);
+	if (unlikely(!ab))
+		return;
+	audit_log_task(ab);
+	audit_log_format(ab, " sig=%ld", signr);
 	audit_log_format(ab, " syscall=%ld", syscall);
 	audit_log_format(ab, " compat=%d", is_compat_task());
 	audit_log_format(ab, " ip=0x%lx", KSTK_EIP(current));
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
