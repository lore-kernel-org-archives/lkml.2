Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab2EYJaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 05:30:11 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:56041 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab2EYJaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 05:30:05 -0400
X-AuditID: b753bd60-a1c87ba000000655-37-4fbf4c7fd03c
X-AuditID: b753bd60-a1c87ba000000655-37-4fbf4c7fd03c
Content-Type: multipart/mixed; boundary="===============4274647327584015487=="
MIME-Version: 1.0
From: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
Cc: "Andy Lutomirski" <luto@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        "Ingo Molnar" <mingo@elte.hu>, "Ingo Molnar" <mingo@redhat.com>,
        "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
        "Kees Cook" <keescook@chromium.org>, "Kevin Hilman" <khilman@ti.com>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Prarit Bhargava" <prarit@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, "Tejun Heo" <tj@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, yrl.pp-manager.tt@hitachi.com
user-agent: StGIT/0.14.3
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "Vivek Goyal" <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
date: Fri, 25 May 2012 18:12:07 +0900
message-id: <20120525091207.10256.18614.stgit@t3500.sdl.hitachi.co.jp>
subject: [RFC PATCH 0/4 V2] introduce: livedump
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============4274647327584015487==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Changes in V2:
 - A little more comments are added.
 - Operation using tools/livedump/livedump is simpliefied.
 - Previous 5 patches are arranged to 4 patches.
   ([3/5] and [4/5] are merged)
 - The patchset is rebased onto v3.4.
 - crash-6.0.6 is required (which was 6.0.1 previously).


The following series introduces the new memory dumping mechanism Live Dump,
which let users obtain a consistent memory dump without stopping a running
system.

Such a mechanism is useful especially in the case where very important
systems are consolidated onto a single machine via virtualization.
Assuming a KVM host runs multiple important VMs on it and one of them
fails, the other VMs have to keep running. However, at the same time, an
administrator may want to obtain memory dump of not only the failed guest
but also the host because possibly the cause of failture is not in the
guest but in the host or the hardware under it.

Live Dump is based on Copy-on-write technique. Basically processing is
performed in the following order.
(1) Suspends processing of all CPUs.
(2) Makes pages (which you want to dump) read-only.
(3) Resumes all CPUs
(4) On page fault, dumps a page including a fault address.
(5) Finally, dumps the rest of pages that are not updated.

Currently, Live Dump is just a simple prototype and it has many
limitations. I list the important ones below.
(1) It write-protects only kernel's straight mapping areas. Therefore
    memory updates from vmap areas and user space don't cause page fault.
    Pages corresponding to these areas are not consistently dumped.
(2) It supports only x86-64 architecture.
(3) It can only handle 4K pages. As we know, most pages in kernel space are
    mapped via 2M or 1G large page mapping. Therefore, the current
    implementation of Live Dump splits all large pages into 4K pages before
    setting up write protection.
(4) It allocates about 50% of physical RAM to store dumped pages. Currently
    Live Dump saves all dumped data on memory once, and after that a user
    becomes able to use the dumped data. Live Dump itself has no feature to
    save dumped data onto a disk or any other storage device.

This series consists of 4 patches.

Ths 1st patch adds notifier-call-chain in do_page_fault. This is the only
modification against the existing code path of the upstream kernel.

The 2nd patch introduces "livedump" misc device.

The 3rd patch introduces feature of write protection management. This
enables users to turn on write protection on kernel space and to install a
hook function that is called every time page fault occurs on each protected
page.

The last patch introduces memory dumping feature. This patch installs the
function to dump content of the protected page on page fault. At the same
time, it lets users to access the dumped data via the misc device
interface.


***How to test***
To test this patch, you have to apply the attached patch to the source code
of crash[1]. This patch can be applied to the version 6.0.6 of crash.  In
addition to this, you have to configure your kernel to turn on
CONFIG_DEBUG_INFO.

[1]crash, http://people.redhat.com/anderson/crash-6.0.6.tar.gz

At first, kick the script tools/livedump/livedump as follows.
 # livedump dump

At this point, all memory image has been saved (also on memory). Then you
can analyze the image by kicking the patched crash as follows.
 # crash /dev/livedump /boot/System.map /boot/vmlinux.o

By the following command, you can release all resources of livedump.
 # livedump release

---

YOSHIDA Masanori (4):
      livedump: Add memory dumping functionality
      livedump: Add write protection management
      livedump: Add the new misc device "livedump"
      livedump: Add notifier-call-chain into do_page_fault


 arch/x86/Kconfig                 |   29 ++
 arch/x86/include/asm/traps.h     |    2 
 arch/x86/include/asm/wrprotect.h |   47 +++
 arch/x86/mm/Makefile             |    2 
 arch/x86/mm/fault.c              |    7 
 arch/x86/mm/wrprotect.c          |  618 ++++++++++++++++++++++++++++++++++++++
 kernel/Makefile                  |    1 
 kernel/livedump-memdump.c        |  237 +++++++++++++++
 kernel/livedump-memdump.h        |   45 +++
 kernel/livedump.c                |  129 ++++++++
 tools/livedump/livedump          |   28 ++
 11 files changed, 1145 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/wrprotect.h
 create mode 100644 arch/x86/mm/wrprotect.c
 create mode 100644 kernel/livedump-memdump.c
 create mode 100644 kernel/livedump-memdump.h
 create mode 100644 kernel/livedump.c
 create mode 100755 tools/livedump/livedump

-- 
Signature

--===============4274647327584015487==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="crash-6.0.6-livedump.patch"

diff --git a/filesys.c b/filesys.c
index 5c45a8f..80f5918 100755
--- a/filesys.c
+++ b/filesys.c
@@ -167,6 +167,7 @@ memory_source_init(void)
 			return;
 
 		if (!STREQ(pc->live_memsrc, "/dev/mem") &&
+		    !STREQ(pc->live_memsrc, "/dev/livedump") &&
 		     STREQ(pc->live_memsrc, pc->memory_device)) {
 			if (memory_driver_init())
 				return;
@@ -187,6 +188,9 @@ memory_source_init(void)
 	                                        strerror(errno));
 	                } else
 	                        pc->flags |= MFD_RDWR;
+		} else if (STREQ(pc->live_memsrc, "/dev/livedump")) {
+	                if ((pc->mfd = open("/dev/livedump", O_RDONLY)) < 0)
+				error(FATAL, "/dev/livedump: %s\n", strerror(errno));
 		} else if (STREQ(pc->live_memsrc, "/proc/kcore")) {
 			if ((pc->mfd = open("/proc/kcore", O_RDONLY)) < 0)
 				error(FATAL, "/proc/kcore: %s\n", 
diff --git a/main.c b/main.c
index 5a5e19c..8628cde 100755
--- a/main.c
+++ b/main.c
@@ -436,6 +436,19 @@ main(int argc, char **argv)
 				pc->writemem = write_dev_mem;
 				pc->live_memsrc = argv[optind];
 
+			} else if (STREQ(argv[optind], "/dev/livedump")) {
+                        	if (pc->flags & MEMORY_SOURCES) {
+                                	error(INFO, 
+                                            "too many dumpfile arguments\n");
+                                	program_usage(SHORT_FORM);
+                        	}
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

--===============4274647327584015487==--
