Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746Ab2EJNFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 09:05:15 -0400
Received: from david.siemens.de ([192.35.17.14]:30348 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090Ab2EJNFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 09:05:13 -0400
Message-ID: <4FABBCE4.3050503@siemens.com>
Date: Thu, 10 May 2012 10:04:36 -0300
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Anthony Liguori <aliguori@us.ibm.com>, Kevin Wolf <kwolf@redhat.com>
Subject: [PATCH v2] compat: Fix RT signal mask corruption via sigprocmask
References: <4FAAEB37.1080001@siemens.com> <CA+55aFz-z6F=ynvTZp2xrSyq+Ar7huT92_S9e8Wuxepyppq5ZQ@mail.gmail.com>
In-Reply-To: <CA+55aFz-z6F=ynvTZp2xrSyq+Ar7huT92_S9e8Wuxepyppq5ZQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

compat_sys_sigprocmask reads a smaller signal mask from userspace than
sigprogmask accepts for setting. So the high word of blocked.sig[0] will
be cleared, releasing any potentially blocked RT signal.

This was discovered via userspace code that relies on get/setcontext.
glibc's i386 versions of those functions use sigprogmask instead of
rt_sigprogmask to save/restore signal mask and caused RT signal
unblocking this way.

As suggested by Linus, this replaces the sys_sigprocmask based compat
version with one that open-codes the required logic, including the merge
of the existing blocked set with the new one provided on SIG_SETMASK.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 kernel/compat.c |   56 ++++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 39 insertions(+), 17 deletions(-)

diff --git a/kernel/compat.c b/kernel/compat.c
index 74ff849..39c164e 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -372,25 +372,47 @@ asmlinkage long compat_sys_sigpending(compat_old_sigset_t __user *set)
 
 #ifdef __ARCH_WANT_SYS_SIGPROCMASK
 
-asmlinkage long compat_sys_sigprocmask(int how, compat_old_sigset_t __user *set,
-		compat_old_sigset_t __user *oset)
+asmlinkage long compat_sys_sigprocmask(int how,
+				       compat_old_sigset_t __user *nset,
+				       compat_old_sigset_t __user *oset)
 {
-	old_sigset_t s;
-	long ret;
-	mm_segment_t old_fs;
+	old_sigset_t old_set, new_set;
+	sigset_t new_blocked;
 
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
+			new_blocked.sig[0] &=
+				~((old_sigset_t)(compat_old_sigset_t)-1);
+			new_blocked.sig[0] |= new_set;
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
-- 
1.7.3.4
