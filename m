Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab1IXIbO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 04:31:14 -0400
Received: from www17.your-server.de ([213.133.104.17]:41953 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab1IXIbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 04:31:12 -0400
Subject: [PATCH] sys_poll: Fix negative timeout values for x86 userland on
 x86_64 kernels
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, stable@kernel.org
Date: Sat, 24 Sep 2011 10:31:01 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1316853066.1696.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

size of 'long' differs on x86 and x86_64. the ia32 emulation calls
directly into the sys_poll() function. when the timeout is set to a negative
value the test for sign will fail in sys_poll as the 64bit register is tested.
the timeout timer will be set to very high value, because of the sign bit.
this is an error as the timer shouldn't get set at all for negative timeout values.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---
 arch/x86/ia32/ia32entry.S |    2 +-
 fs/compat.c               |    6 ++++++
 include/linux/compat.h    |    2 ++
 3 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 54edb207..30f4116 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -671,7 +671,7 @@ ia32_sys_call_table:
 	.quad sys_getresuid16	/* 165 */
 	.quad sys32_vm86_warning	/* vm86 */ 
 	.quad quiet_ni_syscall	/* query_module */
-	.quad sys_poll
+	.quad compat_sys_poll
 	.quad quiet_ni_syscall /* old nfsservctl */
 	.quad sys_setresgid16	/* 170 */
 	.quad sys_getresgid16
diff --git a/fs/compat.c b/fs/compat.c
index 58b1da4..232675e 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1550,6 +1550,12 @@ asmlinkage long compat_sys_old_select(struct compat_sel_arg_struct __user *arg)
 				 compat_ptr(a.exp), compat_ptr(a.tvp));
 }
 
+asmlinkage long compat_sys_poll(struct pollfd __user *ufds, unsigned int nfds,
+				int timeout)
+{
+	return sys_poll(ufds, nfds, timeout);
+}
+
 #ifdef HAVE_SET_RESTORE_SIGMASK
 static long do_compat_pselect(int n, compat_ulong_t __user *inp,
 	compat_ulong_t __user *outp, compat_ulong_t __user *exp,
diff --git a/include/linux/compat.h b/include/linux/compat.h
index c6e7523..3bfb30a 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -433,6 +433,8 @@ asmlinkage long compat_sys_pselect6(int n, compat_ulong_t __user *inp,
 				    compat_ulong_t __user *exp,
 				    struct compat_timespec __user *tsp,
 				    void __user *sig);
+asmlinkage long compat_sys_poll(struct pollfd __user *ufds, unsigned int nfds,
+				int timeout);
 asmlinkage long compat_sys_ppoll(struct pollfd __user *ufds,
 				 unsigned int nfds,
 				 struct compat_timespec __user *tsp,
-- 
1.7.6.2


