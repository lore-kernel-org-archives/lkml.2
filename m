Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab2E1DgR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:36:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52099 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753920Ab2E1D3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:46 -0400
Message-Id: <20120528031213.651501116@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:20 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jan Kiszka <jan.kiszka@siemens.com>
Subject: [ 078/117] compat: Fix RT signal mask corruption via sigprocmask
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kiszka <jan.kiszka@siemens.com>

commit b7dafa0ef3145c31d7753be0a08b3cbda51f0209 upstream.

compat_sys_sigprocmask reads a smaller signal mask from userspace than
sigprogmask accepts for setting.  So the high word of blocked.sig[0]
will be cleared, releasing any potentially blocked RT signal.

This was discovered via userspace code that relies on get/setcontext.
glibc's i386 versions of those functions use sigprogmask instead of
rt_sigprogmask to save/restore signal mask and caused RT signal
unblocking this way.

As suggested by Linus, this replaces the sys_sigprocmask based compat
version with one that open-codes the required logic, including the merge
of the existing blocked set with the new one provided on SIG_SETMASK.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/compat.c |   63 ++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 46 insertions(+), 17 deletions(-)

diff --git a/kernel/compat.c b/kernel/compat.c
index 74ff849..d2c67aa 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -372,25 +372,54 @@ asmlinkage long compat_sys_sigpending(compat_old_sigset_t __user *set)
 
 #ifdef __ARCH_WANT_SYS_SIGPROCMASK
 
-asmlinkage long compat_sys_sigprocmask(int how, compat_old_sigset_t __user *set,
-		compat_old_sigset_t __user *oset)
+/*
+ * sys_sigprocmask SIG_SETMASK sets the first (compat) word of the
+ * blocked set of signals to the supplied signal set
+ */
+static inline void compat_sig_setmask(sigset_t *blocked, compat_sigset_word set)
 {
-	old_sigset_t s;
-	long ret;
-	mm_segment_t old_fs;
+	memcpy(blocked->sig, &set, sizeof(set));
+}
 
-	if (set && get_user(s, set))
-		return -EFAULT;
-	old_fs = get_fs();
-	set_fs(KERNEL_DS);
-	ret = sys_sigprocmask(how,
-			      set ? (old_sigset_t __user *) &s : NULL,
-			      oset ? (old_sigset_t __user *) &s : NULL);
-	set_fs(old_fs);
-	if (ret == 0)
-		if (oset)
-			ret = put_user(s, oset);
-	return ret;
+asmlinkage long compat_sys_sigprocmask(int how,
+				       compat_old_sigset_t __user *nset,
+				       compat_old_sigset_t __user *oset)
+{
+	old_sigset_t old_set, new_set;
+	sigset_t new_blocked;
+
+	old_set = current->blocked.sig[0];
+
+	if (nset) {
+		if (get_user(new_set, nset))
+			return -EFAULT;
+		new_set &= ~(sigmask(SIGKILL) | sigmask(SIGSTOP));
+
+		new_blocked = current->blocked;
+
+		switch (how) {
+		case SIG_BLOCK:
+			sigaddsetmask(&new_blocked, new_set);
+			break;
+		case SIG_UNBLOCK:
+			sigdelsetmask(&new_blocked, new_set);
+			break;
+		case SIG_SETMASK:
+			compat_sig_setmask(&new_blocked, new_set);
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		set_current_blocked(&new_blocked);
+	}
+
+	if (oset) {
+		if (put_user(old_set, oset))
+			return -EFAULT;
+	}
+
+	return 0;
 }
 
 #endif


