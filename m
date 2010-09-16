Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab0IPWQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:16:43 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:59966 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682Ab0IPWQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:16:32 -0400
From: Alexander Shishkin <virtuoso@slind.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@suse.de>, Chris Friesen <chris.friesen@genband.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Alexander Shishkin <virtuoso@slind.org>
Subject: [PATCHv5 0/7] system time changes notification
Date: Fri, 17 Sep 2010 01:10:42 +0300
Message-Id: <1284675049-23479-1-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.7.2.1.45.gb66c2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the fifth version of system time change notification mechanism
for linux kernel. The need for it comes from applications which would
like to keep track of time changes without having to wake up every
$TIMEOUT and calling gettimeofday().

An excellent description for one of the usecases, written by Kay Sievers
(http://kerneltrap.org/mailarchive/linux-kernel/2010/8/5/4603531):
"""
This is the example Lennart and I thought about when we considered
adding cron-like stuff to systemd's timer configs, but didn't want to
do silly things like scheduled checks for the actual time, so we
delayed this feature until such a notification becomes available.

Consider we want stuff like "wakeup every day at 3pm", the next wakeup
might be earlier than the timer we calculated last time, on system
time changes. We need to re-calculate it. This is necessary for all
repeating events.

Say we want to wakeup at 3pm, now it's 4pm, so we schedule it in 23
hours. Now the system time changes to 2pm, and we would expect to
wakeup in one hour, but we take 25.
"""

Changes since v4:
 - updated arm and s390 syscall wiring
 - removed RFC
Changes since v3:
 - broken out separate patches adding time_change_notify syscall to
   arm, powerpc, x86, ia64, s390 and blackfin
Changes since v2:
 - replaced sysfs interface with a syscall
 - added sysctl/procfs handle to set a limit to the number of users
 - fixed issues pointed out by Greg.
Changes since v1:
 - updated against 2.6.36-rc1,
 - added notification/filtering options,
 - added Documentation/ABI/sysfs-kernel-time-notify interface description.

Alexander Shishkin (7):
      notify userspace about time changes
      wire up sys_time_change_notify() on ARM
      wire up sys_time_change_notify() on x86
      wire up sys_time_change_notify() on powerpc
      wire up sys_time_change_notify() on blackfin
      wire up sys_time_change_notify() on ia64
      wire up sys_time_change_notify() on s390

 Documentation/time-change-notify-example.c |   64 ++++++++++
 arch/arm/include/asm/unistd.h              |    1 +
 arch/arm/kernel/calls.S                    |    1 +
 arch/blackfin/include/asm/unistd.h         |    3 +-
 arch/blackfin/mach-common/entry.S          |    1 +
 arch/ia64/include/asm/unistd.h             |    3 +-
 arch/ia64/kernel/entry.S                   |    1 +
 arch/powerpc/include/asm/systbl.h          |    1 +
 arch/powerpc/include/asm/unistd.h          |    3 +-
 arch/s390/include/asm/unistd.h             |    3 +-
 arch/s390/kernel/compat_wrapper.S          |    6 +
 arch/s390/kernel/syscalls.S                |    1 +
 arch/x86/ia32/ia32entry.S                  |    1 +
 arch/x86/include/asm/unistd_32.h           |    3 +-
 arch/x86/include/asm/unistd_64.h           |    2 +
 arch/x86/kernel/syscall_table_32.S         |    1 +
 include/asm-generic/unistd.h               |    4 +-
 include/linux/syscalls.h                   |    1 +
 include/linux/time.h                       |   20 +++
 init/Kconfig                               |    7 +
 kernel/Makefile                            |    1 +
 kernel/sys_ni.c                            |    3 +
 kernel/sysctl.c                            |   11 ++
 kernel/time.c                              |   11 ++-
 kernel/time_notify.c                       |  183 ++++++++++++++++++++++++++++
 25 files changed, 328 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/time-change-notify-example.c
 create mode 100644 kernel/time_notify.c

Regards,
--
Alex
