Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab2JKF5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 01:57:08 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:39002 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756724Ab2JKF5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 01:57:05 -0400
X-AuditID: b753bd60-9544eba000002f78-7d-50765f2abfd3
X-AuditID: b753bd60-9544eba000002f78-7d-50765f2abfd3
Content-Type: multipart/mixed; boundary="===============2746783844303274711=="
MIME-Version: 1.0
From: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Andy Lutomirski" <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Ingo Molnar" <mingo@redhat.com>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Prarit Bhargava" <prarit@redhat.com>,
        "Srikar Dronamraju" <srikar@linux.vnet.ibm.com>,
        "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, "Khalid Aziz" <khalid.aziz@hp.com>,
        yrl.pp-manager.tt@hitachi.com
user-agent: StGIT/0.14.3
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "Vivek Goyal" <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
date: Thu, 11 Oct 2012 14:53:56 +0900
message-id: <20121011055356.6719.46214.stgit@t3500.sdl.hitachi.co.jp>
subject: [RFC PATCH 0/3 V3] introduce: livedump
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============2746783844303274711==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

The following series introduces the new memory dumping mechanism Live Dump,
which lets users obtain a consistent memory dump without stopping a running
system.


Changes in V3:
 - The patchset is rebased onto v3.6.
 - crash-6.1.0 is required (which was 6.0.6 previously).
 - Notifier-call-chain in do_page_fault is replaced with the callback
   dedicated for livedump.
 - The patchset implements the feature of dumping to disk.
   This version only supports block device as target device.

V2 is here: https://lkml.org/lkml/2012/5/25/104

ToDo:
 - Large page support
       Currently livedump can dump only 4K pages, and so it splits all
       pages in kernel space in advance. This causes big TLB overhead.
 - Other target device support
       Currently livedump can dump only to block device. Practically,
       dumping to normal file is necessary.
 - Other space/area support
       Currently livedump write-protect only kernel's straight mapping
       area. Pages in user space or vmap area cannot be dumped
       consistently.
 - Other CPU architecture support
       Currently livedump supports only x86-64.


Background:
This mechanism is useful especially in the case where very important
systems are consolidated onto a single machine via virtualization.
Assuming a KVM host runs multiple important VMs on it and one of them
fails, the other VMs have to keep running. However, at the same time, an
administrator may want to obtain memory dump of not only the failed guest
but also the host because possibly the cause of failture is not in the
guest but in the host or the hardware under it.


Mechanism overview:
Live Dump is based on Copy-on-write technique. Basically processing is
performed in the following order.
(1) Suspends processing of all CPUs.
(2) Makes pages (which you want to dump) read-only.
(3) Resumes all CPUs
(4) On page fault, dumps a faulting page.
(5) Finally, dumps the rest of pages that are not updated.

The kthread named "livedump" is in charge of dumping to disk. It has queue
to receive dump request from livedump's page fault handler. If ever the
queue becomes full, livedump simply fails, since livedump's page fault
can never sleep to wait for space.


This series consists of 3 patches.

The 1st patch introduces "livedump" misc device.

The 2nd patch introduces feature of write protection management. This
enables users to turn on write protection on kernel space and to install a
hook function that is called every time page fault occurs on each protected
page.

The 3rd patch introduces memory dumping feature. This patch installs the
function to dump content of the protected page on page fault.


***How to test***
To test this patch, you have to apply the attached patch to the source code
of crash[1]. This patch can be applied to the version 6.1.0 of crash.  In
addition to this, you have to configure your kernel to turn on
CONFIG_DEBUG_INFO.

[1]crash, http://people.redhat.com/anderson/crash-6.1.0.tar.gz

At first, kick the script tools/livedump/livedump as follows.
 # livedump dump <block device path>

At this point, all memory image has been saved. Then you can analyze
the image by kicking the patched crash as follows.
 # crash <block device path> System.map vmlinux.o

By the following command, you can release all resources of livedump.
 # livedump release

---

YOSHIDA Masanori (3):
      livedump: Add memory dumping functionality
      livedump: Add write protection management
      livedump: Add the new misc device "livedump"


 arch/x86/Kconfig                 |   29 ++
 arch/x86/include/asm/wrprotect.h |   45 +++
 arch/x86/mm/Makefile             |    2 
 arch/x86/mm/fault.c              |    7 
 arch/x86/mm/wrprotect.c          |  548 ++++++++++++++++++++++++++++++++++++++
 kernel/Makefile                  |    1 
 kernel/livedump-memdump.c        |  445 +++++++++++++++++++++++++++++++
 kernel/livedump-memdump.h        |   32 ++
 kernel/livedump.c                |  133 +++++++++
 tools/livedump/livedump          |   38 +++
 10 files changed, 1280 insertions(+)
 create mode 100644 arch/x86/include/asm/wrprotect.h
 create mode 100644 arch/x86/mm/wrprotect.c
 create mode 100644 kernel/livedump-memdump.c
 create mode 100644 kernel/livedump-memdump.h
 create mode 100644 kernel/livedump.c
 create mode 100755 tools/livedump/livedump

-- 
YOSHIDA Masanori
Linux Technology Center
Yokohama Research Laboratory
Hitachi, Ltd.

--===============2746783844303274711==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="crash-6.1.0-livedump.patch"

diff --git a/filesys.c b/filesys.c
index cc78f7d..21ddb12 100755
--- a/filesys.c
+++ b/filesys.c
@@ -168,6 +168,7 @@ memory_source_init(void)
 			return;
 
 		if (!STREQ(pc->live_memsrc, "/dev/mem") &&
+		    !STRNEQ(pc->live_memsrc, "/dev/sd") &&
 		     STREQ(pc->live_memsrc, pc->memory_device)) {
 			if (memory_driver_init())
 				return;
@@ -188,6 +189,11 @@ memory_source_init(void)
 	                                        strerror(errno));
 	                } else
 	                        pc->flags |= MFD_RDWR;
+		} else if (STRNEQ(pc->live_memsrc, "/dev/sd")) {
+	                if ((pc->mfd = open(pc->live_memsrc, O_RDONLY)) < 0)
+				error(FATAL, "%s: %s\n",
+						pc->live_memsrc,
+						strerror(errno));
 		} else if (STREQ(pc->live_memsrc, "/proc/kcore")) {
 			if ((pc->mfd = open("/proc/kcore", O_RDONLY)) < 0)
 				error(FATAL, "/proc/kcore: %s\n", 
diff --git a/main.c b/main.c
index 7650b8c..20266a8 100755
--- a/main.c
+++ b/main.c
@@ -449,6 +449,19 @@ main(int argc, char **argv)
 				pc->writemem = write_dev_mem;
 				pc->live_memsrc = argv[optind];
 
+			} else if (STRNEQ(argv[optind], "/dev/sd")) {
+				if (pc->flags & MEMORY_SOURCES) {
+					error(INFO,
+					    "too many dumpfile arguments\n");
+					program_usage(SHORT_FORM);
+				}
+				pc->flags |= DEVMEM;
+				pc->dumpfile = NULL;
+				pc->readmem = read_dev_mem;
+				pc->writemem = write_dev_mem;
+				pc->live_memsrc = argv[optind];
+				pc->program_pid = 1;
+
 			} else if (is_proc_kcore(argv[optind], KCORE_LOCAL)) {
 				if (pc->flags & MEMORY_SOURCES) {
 					error(INFO, 

--===============2746783844303274711==--
