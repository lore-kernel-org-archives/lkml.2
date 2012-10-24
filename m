Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161174Ab2JXUhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 16:37:55 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:32983 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934318Ab2JXUhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 16:37:53 -0400
Message-ID: <5088517B.1010102@zankel.net>
Date: Wed, 24 Oct 2012 13:37:15 -0700
From: Chris Zankel <chris@zankel.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH stable] xtensa: add missing system calls to the syscall table
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Could you please include this patch in the next stable tree? It adds 
system calls required for libc builds, so would be great to have it there.

Thanks,
-Chris


 From 72b843f6fa14a818a833625d78d8023828366bb1 Mon Sep 17 00:00:00 2001
From: Chris Zankel <chris@zankel.net>
Date: Wed, 24 Oct 2012 12:59:28 -0700
Subject: [PATCH 1/1] xtensa: add missing system calls to the syscall table

Add the following system calls to the syscall table:

fallocate
sendmmsg
umount2
syncfs
epoll_create1
inotify_init1
signalfd4
dup3
pipe2
timerfd_create
timerfd_settime
timerfd_gettime
eventfd2
preadv
pwritev
fanotify_init
fanotify_mark
process_vm_readv
process_vm_writev
name_to_handle_at
open_by_handle_at
sync_file_range
perf_event_open
rt_tgsigqueueinfo
clock_adjtime
prlimit64
kcmp

Note that we have to use the 'sys_sync_file_range2' version, so that
the 64-bit arguments are aligned correctly to the argument registers

Signed-off-by: Chris Zankel <chris@zankel.net>
---
  arch/xtensa/include/asm/unistd.h |   91 
++++++++++++++++++++++++++++++--------
  1 file changed, 72 insertions(+), 19 deletions(-)

diff --git a/arch/xtensa/include/asm/unistd.h 
b/arch/xtensa/include/asm/unistd.h
index bc7e005..6b3ff98 100644
--- a/arch/xtensa/include/asm/unistd.h
+++ b/arch/xtensa/include/asm/unistd.h
@@ -148,8 +148,8 @@ __SYSCALL( 59, sys_getdents, 3)
  __SYSCALL( 60, sys_getdents64, 3)
  #define __NR_fcntl64                  61
  __SYSCALL( 61, sys_fcntl64, 3)
-#define __NR_available62             62
-__SYSCALL( 62, sys_ni_syscall, 0)
+#define __NR_fallocate                 62
+__SYSCALL(62, sys_fallocate, 6)
  #define __NR_fadvise64_64              63
  __SYSCALL( 63, xtensa_fadvise64_64, 6)
  #define __NR_utime                 64    /* glibc 2.3.3 ?? */
@@ -264,8 +264,8 @@ __SYSCALL(112, sys_socketpair, 4)
  __SYSCALL(113, sys_sendfile, 4)
  #define __NR_sendfile64             114
  __SYSCALL(114, sys_sendfile64, 4)
-#define __NR_available115            115
-__SYSCALL(115, sys_ni_syscall, 0)
+#define __NR_sendmmsg                115
+__SYSCALL(115, sys_sendmmsg, 4)

  /* Process Operations */

@@ -380,11 +380,11 @@ __SYSCALL(168, sys_msgrcv, 4)
  __SYSCALL(169, sys_msgctl, 4)
  #define __NR_available170            170
  __SYSCALL(170, sys_ni_syscall, 0)
-#define __NR_available171            171
-__SYSCALL(171, sys_ni_syscall, 0)

  /* File System */

+#define __NR_umount2                171
+__SYSCALL(171, sys_umount, 2)
  #define __NR_mount                 172
  __SYSCALL(172, sys_mount, 5)
  #define __NR_swapon                 173
@@ -399,8 +399,8 @@ __SYSCALL(176, sys_umount, 2)
  __SYSCALL(177, sys_swapoff, 1)
  #define __NR_sync                 178
  __SYSCALL(178, sys_sync, 0)
-#define __NR_available179            179
-__SYSCALL(179, sys_ni_syscall, 0)
+#define __NR_syncfs                179
+__SYSCALL(179, sys_syncfs, 1)
  #define __NR_setfsuid                 180
  __SYSCALL(180, sys_setfsuid, 1)
  #define __NR_setfsgid                 181
@@ -455,7 +455,7 @@ __SYSCALL(203, sys_reboot, 3)
  #define __NR_quotactl                 204
  __SYSCALL(204, sys_quotactl, 4)
  #define __NR_nfsservctl             205
-__SYSCALL(205, sys_ni_syscall, 0)
+__SYSCALL(205, sys_ni_syscall, 0)            /* old nfsservctl */
  #define __NR__sysctl                 206
  __SYSCALL(206, sys_sysctl, 1)
  #define __NR_bdflush                 207
@@ -562,7 +562,7 @@ __SYSCALL(252, sys_timer_getoverrun, 1)

  /* System */

-#define __NR_reserved244             253
+#define __NR_reserved253            253
  __SYSCALL(253, sys_ni_syscall, 0)
  #define __NR_lookup_dcookie             254
  __SYSCALL(254, sys_lookup_dcookie, 4)
@@ -609,8 +609,8 @@ __SYSCALL(272, sys_pselect6, 0)
  __SYSCALL(273, sys_ppoll, 0)
  #define __NR_epoll_pwait            274
  __SYSCALL(274, sys_epoll_pwait, 0)
-#define __NR_available275            275
-__SYSCALL(275, sys_ni_syscall, 0)
+#define __NR_epoll_create1        275
+__SYSCALL(275, sys_epoll_create1, 1)

  #define __NR_inotify_init            276
  __SYSCALL(276, sys_inotify_init, 0)
@@ -618,8 +618,8 @@ __SYSCALL(276, sys_inotify_init, 0)
  __SYSCALL(277, sys_inotify_add_watch, 3)
  #define __NR_inotify_rm_watch            278
  __SYSCALL(278, sys_inotify_rm_watch, 2)
-#define __NR_available279            279
-__SYSCALL(279, sys_ni_syscall, 0)
+#define __NR_inotify_init1            279
+__SYSCALL(279, sys_inotify_init1, 1)

  #define __NR_getcpu                280
  __SYSCALL(280, sys_getcpu, 0)
@@ -635,10 +635,10 @@ __SYSCALL(283, sys_ioprio_get, 3)
  __SYSCALL(284, sys_set_robust_list, 3)
  #define __NR_get_robust_list            285
  __SYSCALL(285, sys_get_robust_list, 3)
-#define __NR_reserved286            286    /* sync_file_rangeX */
-__SYSCALL(286, sys_ni_syscall, 3)
+#define __NR_available286            286
+__SYSCALL(286, sys_ni_syscall, 0)
  #define __NR_available287            287
-__SYSCALL(287, sys_faccessat, 0)
+__SYSCALL(287, sys_ni_syscall, 0)

  /* Relative File Operations */

@@ -683,10 +683,63 @@ __SYSCALL(305, sys_ni_syscall, 0)
  __SYSCALL(306, sys_eventfd, 1)
  #define __NR_recvmmsg                307
  __SYSCALL(307, sys_recvmmsg, 5)
+
  #define __NR_setns                308
  __SYSCALL(308, sys_setns, 2)
-
-#define __NR_syscall_count            309
+#define __NR_signalfd4                309
+__SYSCALL(309, sys_signalfd4, 4)
+#define __NR_dup3                310
+__SYSCALL(310, sys_dup3, 3)
+#define __NR_pipe2                311
+__SYSCALL(311, sys_pipe2, 2)
+
+#define __NR_timerfd_create            312
+__SYSCALL(312, sys_timerfd_create, 2)
+#define __NR_timerfd_settime            313
+__SYSCALL(313, sys_timerfd_settime, 4)
+#define __NR_timerfd_gettime            314
+__SYSCALL(314, sys_timerfd_gettime, 2)
+#define __NR_available315            315
+__SYSCALL(315, sys_ni_syscall, 0)
+
+#define __NR_eventfd2                316
+__SYSCALL(316, sys_eventfd2, 2)
+#define __NR_preadv                317
+__SYSCALL(317, sys_preadv, 5)
+#define __NR_pwritev                318
+__SYSCALL(318, sys_pwritev, 5)
+#define __NR_available319            319
+__SYSCALL(319, sys_ni_syscall, 0)
+
+#define __NR_fanotify_init            320
+__SYSCALL(320, sys_fanotify_init, 2)
+#define __NR_fanotify_mark            321
+__SYSCALL(321, sys_fanotify_mark, 6)
+#define __NR_process_vm_readv            322
+__SYSCALL(322, sys_process_vm_readv, 6)
+#define __NR_process_vm_writev            323
+__SYSCALL(323, sys_process_vm_writev, 6)
+
+#define __NR_name_to_handle_at            324
+__SYSCALL(324, sys_name_to_handle_at, 5)
+#define __NR_open_by_handle_at            325
+__SYSCALL(325, sys_open_by_handle_at, 3)
+#define __NR_sync_file_range            326
+__SYSCALL(326, sys_sync_file_range2, 6)
+#define __NR_perf_event_open            327
+__SYSCALL(327, sys_perf_event_open, 5)
+
+#define __NR_rt_tgsigqueueinfo            328
+__SYSCALL(328, sys_rt_tgsigqueueinfo, 4)
+#define __NR_clock_adjtime            329
+__SYSCALL(329, sys_clock_adjtime, 2)
+#define __NR_prlimit64                330
+__SYSCALL(330, sys_prlimit64, 4)
+#define __NR_kcmp                331
+__SYSCALL(331, sys_kcmp, 5)
+
+
+#define __NR_syscall_count            332

  /*
   * sysxtensa syscall handler
-- 
1.7.9.5

