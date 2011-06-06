Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab1FFIfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 04:35:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:40189 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756782Ab1FFIfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 04:35:51 -0400
Date: Mon, 6 Jun 2011 08:35:18 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-764611c8dfb5be43611296affd92272b7215daea@git.kernel.org>
Cc: mingo@redhat.com, brgerst@gmail.com, torvalds@linux-foundation.org,
        mikpe@it.uu.se, richard.weinberger@gmail.com, jj@chaosbits.net,
        JBeulich@novell.com, tglx@linutronix.de, Louis.Rilling@kerlabs.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, luto@mit.edu,
        andi@firstfloor.org, bp@alien8.de, arjan@infradead.org, mingo@elte.hu
Reply-To: mingo@redhat.com, torvalds@linux-foundation.org, brgerst@gmail.com,
        mikpe@it.uu.se, richard.weinberger@gmail.com, jj@chaosbits.net,
        JBeulich@novell.com, tglx@linutronix.de, Louis.Rilling@kerlabs.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, luto@mit.edu,
        andi@firstfloor.org, bp@alien8.de, arjan@infradead.org, mingo@elte.hu
In-Reply-To: <e64e1b3c64858820d12c48fa739efbd1485e79d5.1307292171.git.luto@mit.edu>
References: <e64e1b3c64858820d12c48fa739efbd1485e79d5.1307292171.git.luto@mit.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86-64, vdso, seccomp: Fix !CONFIG_SECCOMP build
Git-Commit-ID: 764611c8dfb5be43611296affd92272b7215daea
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Jun 2011 08:35:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  764611c8dfb5be43611296affd92272b7215daea
Gitweb:     http://git.kernel.org/tip/764611c8dfb5be43611296affd92272b7215daea
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 6 Jun 2011 10:00:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 6 Jun 2011 10:00:01 +0200

x86-64, vdso, seccomp: Fix !CONFIG_SECCOMP build

Factor out seccomp->mode access into an inline function and make
it work in the !CONFIG_SECCOMP case as well.

Cc: Andy Lutomirski <luto@mit.edu>
Cc: Jesper Juhl <jj@chaosbits.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Jan Beulich <JBeulich@novell.com>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: Valdis.Kletnieks@vt.edu
Cc: pageexec@freemail.hu
Link: http://lkml.kernel.org/r/e64e1b3c64858820d12c48fa739efbd1485e79d5.1307292171.git.luto@mit.edu
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/vsyscall_64.c |    2 +-
 include/linux/seccomp.h       |   10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 52ba392..285af7a 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -188,7 +188,7 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 	}
 
 	tsk = current;
-	if (tsk->seccomp.mode) {
+	if (seccomp_mode(&tsk->seccomp)) {
 		do_exit(SIGKILL);
 		goto out;
 	}
diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 167c333..cc7a4e9 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -19,6 +19,11 @@ static inline void secure_computing(int this_syscall)
 extern long prctl_get_seccomp(void);
 extern long prctl_set_seccomp(unsigned long);
 
+static inline int seccomp_mode(seccomp_t *s)
+{
+	return s->mode;
+}
+
 #else /* CONFIG_SECCOMP */
 
 #include <linux/errno.h>
@@ -37,6 +42,11 @@ static inline long prctl_set_seccomp(unsigned long arg2)
 	return -EINVAL;
 }
 
+static inline int seccomp_mode(seccomp_t *s)
+{
+	return 0;
+}
+
 #endif /* CONFIG_SECCOMP */
 
 #endif /* _LINUX_SECCOMP_H */
