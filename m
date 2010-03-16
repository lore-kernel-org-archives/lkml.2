Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938091Ab0CPRrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:47:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938057Ab0CPRqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:46:49 -0400
Date: Tue, 16 Mar 2010 13:46:08 -0400
From: Jason Baron <jbaron@redhat.com>
To: fweisbec@gmail.com, mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       hpa@zytor.com, tglx@linutronix.de, mhiramat@redhat.com,
       heiko.carstens@de.ibm.com, benh@kernel.crashing.org,
       davem@davemloft.net, lethal@linux-sh.org, schwidefsky@de.ibm.com,
       brueckner@linux.vnet.ibm.com, tony.luck@intel.com
Message-Id: <cover.1268749695.git.jbaron@redhat.com>
Subject: [PATCH 00/14] tracing: add compat syscall support v3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Re-post to add infrastructure for compat syscall event tracing support. This
patch series also adds x86_64 arch specific support as an example consumer
of the new infrastructure.

Arches can request compat syscall tracing by setting: 
__HAVE_ARCH_FTRACE_COMPAT_SYSCALLS, if CONFIG_COMPAT and CONFIG_FTRACE_SYSCALLS
are set. Arches then need to implement the following interfaces:

1) int is_compat_task(void);
  - most arches seem to have this already
2) unsigned long arch_compat_syscall_addr(int nr);
  - returns a pointer to the compat syscall entry corresponding to syscall 'nr'
3) int NR_syscalls_compat;
  - number of entries in the compat syscall table.

thanks,

-Jason

Changes in v3:

 - create a separate "compat_syscalls" event subsystem
 - ARCH_COMPAT_SYSCALL_DEFINE#N() tacks "sys32" to start of syscall name
 - COMPAT_SYSCALL_DEFINE#N() tacks "compat_sys" to start of syscall name
 - both above macros create perf events as: [enter|exit]_compat_sys_blah
 - non-compat syscall naming changes to: [enter|exit]_sys_blah
 - removes any unreferenced compat syscalls from debugfs

Heiko Carstens (1):
  compat: have generic is_compat_task for !CONFIG_COMPAT

Jason Baron (13):
  x86: add NR_syscalls_compat, make ia32 syscall table visible
  x86: add arch_compat_syscall_addr()
  tracing: remove syscall bitmaps in preparation for compat support
  tracing: move __start_ftrace_events and __stop_ftrace_events to
    header file
  tracing: add tracing support for compat syscalls
  syscalls: add ARCH_COMPAT_SYSCALL_DEFINE()
  x86, compat: convert ia32 layer to use
  syscalls: add new COMPAT_SYSCALL_DEFINE#N() macro
  compat: convert to use COMPAT_SYSCALL_DEFINE#N()
  compat: convert fs compat to use COMPAT_SYSCALL_DEFINE#N() macros
  tags: recognize compat syscalls
  cleanup: remove arg from TRACE_SYS_ENTER_PROFILE_INIT() macro
  tracing: make a "compat_syscalls" tracing subsys

 arch/s390/include/asm/compat.h  |    7 --
 arch/s390/kernel/ptrace.c       |    2 +-
 arch/s390/kernel/setup.c        |    2 +-
 arch/s390/mm/mmap.c             |    2 +-
 arch/x86/ia32/ia32entry.S       |    3 +
 arch/x86/ia32/sys_ia32.c        |  106 ++++++++++++++--------------
 arch/x86/include/asm/compat.h   |    2 +
 arch/x86/include/asm/syscall.h  |    5 ++
 arch/x86/kernel/ftrace.c        |    8 ++
 drivers/s390/block/dasd_eckd.c  |    2 +-
 drivers/s390/block/dasd_ioctl.c |    1 +
 drivers/s390/char/fs3270.c      |    1 +
 drivers/s390/char/vmcp.c        |    1 +
 drivers/s390/cio/chsc_sch.c     |    1 +
 drivers/s390/scsi/zfcp_cfdc.c   |    1 +
 fs/compat.c                     |  147 +++++++++++++++++++--------------------
 include/linux/compat.h          |    9 +++
 include/linux/ftrace_event.h    |    3 +
 include/linux/syscalls.h        |   91 +++++++++++++++++-------
 include/trace/syscall.h         |    8 ++
 kernel/compat.c                 |  106 ++++++++++++++---------------
 kernel/trace/trace.h            |    2 +
 kernel/trace/trace_events.c     |    3 -
 kernel/trace/trace_syscalls.c   |  124 +++++++++++++++++++++++++--------
 scripts/tags.sh                 |    8 ++-
 25 files changed, 392 insertions(+), 253 deletions(-)

