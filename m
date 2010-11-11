Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab0KKTai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:30:38 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:42233 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135Ab0KKTad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:30:33 -0500
From: Alexander Shishkin <virtuoso@slind.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@suse.de>, Chris Friesen <chris.friesen@genband.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <virtuoso@slind.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        David Howells <dhowells@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Christoph Hellwig <hch@lst.de>, linux-s390@vger.kernel.org
Subject: [PATCHv6 5/7] wire up sys_time_change_notify() on s390
Date: Thu, 11 Nov 2010 21:30:00 +0200
Message-Id: <1289503802-22444-6-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.7.2.1.45.gb66c2
In-Reply-To: <1289503802-22444-1-git-send-email-virtuoso@slind.org>
References: <1289503802-22444-1-git-send-email-virtuoso@slind.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: linux390@de.ibm.com
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Jesper Nilsson <jesper.nilsson@axis.com>
CC: David Howells <dhowells@redhat.com>
CC: Christian Borntraeger <borntraeger@de.ibm.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Christoph Hellwig <hch@lst.de>
CC: linux-s390@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 arch/s390/include/asm/unistd.h    |    3 ++-
 arch/s390/kernel/compat_wrapper.S |    7 +++++++
 arch/s390/kernel/syscalls.S       |    1 +
 3 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/s390/include/asm/unistd.h b/arch/s390/include/asm/unistd.h
index 1049ef2..f815a2d 100644
--- a/arch/s390/include/asm/unistd.h
+++ b/arch/s390/include/asm/unistd.h
@@ -272,7 +272,8 @@
 #define __NR_fanotify_init	332
 #define __NR_fanotify_mark	333
 #define __NR_prlimit64		334
-#define NR_syscalls 335
+#define __NR_time_change_notify	335
+#define NR_syscalls 336
 
 /* 
  * There are some system calls that are not present on 64 bit, some
diff --git a/arch/s390/kernel/compat_wrapper.S b/arch/s390/kernel/compat_wrapper.S
index 8e60fb2..dd4b23e 100644
--- a/arch/s390/kernel/compat_wrapper.S
+++ b/arch/s390/kernel/compat_wrapper.S
@@ -1877,3 +1877,10 @@ sys_prlimit64_wrapper:
 	llgtr	%r4,%r4			# const struct rlimit64 __user *
 	llgtr	%r5,%r5			# struct rlimit64 __user *
 	jg	sys_prlimit64		# branch to system call
+
+	.globl sys_time_change_notify_wrapper
+sys_time_change_notify_wrapper:
+	lgfr	%r2,%r2			# clockid_t (int)
+	lgfr	%r3,%r3			# int
+	llgfr	%r4,%r4			# unsigned int
+	jg	sys_time_change_notify	# branch to system call
diff --git a/arch/s390/kernel/syscalls.S b/arch/s390/kernel/syscalls.S
index a8fee1b..50ca1a7 100644
--- a/arch/s390/kernel/syscalls.S
+++ b/arch/s390/kernel/syscalls.S
@@ -343,3 +343,4 @@ SYSCALL(sys_perf_event_open,sys_perf_event_open,sys_perf_event_open_wrapper)
 SYSCALL(sys_fanotify_init,sys_fanotify_init,sys_fanotify_init_wrapper)
 SYSCALL(sys_fanotify_mark,sys_fanotify_mark,sys_fanotify_mark_wrapper)
 SYSCALL(sys_prlimit64,sys_prlimit64,sys_prlimit64_wrapper)
+SYSCALL(sys_time_change_notify,sys_time_change_notify,sys_time_change_notify_wrapper) /* 335 */
-- 
1.7.2.1.45.gb66c2

