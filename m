Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761239Ab2EIWKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 18:10:37 -0400
Received: from thoth.sbs.de ([192.35.17.2]:17771 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758824Ab2EIWKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 18:10:36 -0400
Message-ID: <4FAAEB37.1080001@siemens.com>
Date: Wed, 09 May 2012 19:09:59 -0300
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Anthony Liguori <aliguori@us.ibm.com>, Kevin Wolf <kwolf@redhat.com>
Subject: [PATCH] compat: Fix RT signal mask corruption via sigprocmask
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
rt_sigprogmask to save/restore the signal mask and caused RT signal
unblocking this way.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 kernel/compat.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/compat.c b/kernel/compat.c
index 74ff849..03e491d 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -381,6 +381,8 @@ asmlinkage long compat_sys_sigprocmask(int how, compat_old_sigset_t __user *set,
 
 	if (set && get_user(s, set))
 		return -EFAULT;
+	s |= current->blocked.sig[0] &
+		~((old_sigset_t)(compat_old_sigset_t)-1);
 	old_fs = get_fs();
 	set_fs(KERNEL_DS);
 	ret = sys_sigprocmask(how,
-- 
1.7.3.4
