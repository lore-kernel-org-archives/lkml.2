Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196Ab1D0KqE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 06:46:04 -0400
Received: from smtp.nokia.com ([147.243.128.26]:65346 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758118Ab1D0KqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:46:00 -0400
From: Alexander Shishkin <virtuoso@slind.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alexander Shishkin <virtuoso@slind.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <johnstul@us.ibm.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 1/4] clock_rtoffset: new syscall
Date: Wed, 27 Apr 2011 13:43:40 +0300
Message-Id: <1303901023-11568-1-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <alpine.LFD.2.00.1103102040190.2787@localhost6.localdomain6>
References: <alpine.LFD.2.00.1103102040190.2787@localhost6.localdomain6>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to keep track of system time changes, we introduce a new
syscall which returns the offset of CLOCK_MONOTONIC clock against
CLOCK_REALTIME. The caller is to store this value and use it in
system calls (like clock_nanosleep or timerfd_settime) that will
compare it against the effective offset in order to ensure that
the caller's notion of the system time corresponds to the effective
system time at the moment of the action being carried out. If it
has changed, these system calls will return an error and the caller
will have to obtain this offset again.

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: John Stultz <johnstul@us.ibm.com>
CC: Chris Friesen <chris.friesen@genband.com>
CC: Kay Sievers <kay.sievers@vrfy.org>
CC: Kirill A. Shutemov <kirill@shutemov.name>
CC: linux-kernel@vger.kernel.org
---
 include/asm-generic/unistd.h |    4 +++-
 kernel/posix-timers.c        |   14 ++++++++++++++
 kernel/sys_ni.c              |    3 +++
 3 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index 07c40d5..89edfc8 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -654,9 +654,11 @@ __SYSCALL(__NR_open_by_handle_at, sys_open_by_handle_at)
 __SYSCALL(__NR_clock_adjtime, sys_clock_adjtime)
 #define __NR_syncfs 267
 __SYSCALL(__NR_syncfs, sys_syncfs)
+#define __NR_clock_rtoffset 268
+__SYSCALL(__NR_clock_rtoffset, sys_clock_rtoffset)
 
 #undef __NR_syscalls
-#define __NR_syscalls 268
+#define __NR_syscalls 269
 
 /*
  * All syscalls below here should go away really,
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index e5498d7..2512708 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -1019,6 +1019,20 @@ SYSCALL_DEFINE2(clock_getres, const clockid_t, which_clock,
 }
 
 /*
+ * Retrieve CLOCK_REALTIME's offset against CLOCK_MONOTONIC
+ */
+SYSCALL_DEFINE1(clock_rtoffset, struct timespec __user, *offset)
+{
+	struct timespec time, mono, sleep;
+	int ret;
+
+	get_xtime_and_monotonic_and_sleep_offset(&time, &mono, &sleep);
+	ret = copy_to_user(offset, &mono, sizeof(mono));
+
+	return ret ? -EFAULT : 0;
+}
+
+/*
  * nanosleep for monotonic and realtime clocks
  */
 static int common_nsleep(const clockid_t which_clock, int flags,
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 25cc41c..47791cc 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -191,3 +191,6 @@ cond_syscall(sys_fanotify_mark);
 cond_syscall(sys_name_to_handle_at);
 cond_syscall(sys_open_by_handle_at);
 cond_syscall(compat_sys_open_by_handle_at);
+
+/* monotonic vs realtime clock offset */
+cond_syscall(sys_clock_rtoffset);
-- 
1.7.4.1

