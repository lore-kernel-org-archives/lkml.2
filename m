Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab1LTHZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 02:25:37 -0500
Received: from mailx.hitachi.co.jp ([133.145.228.49]:54538 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab1LTHZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 02:25:15 -0500
X-AuditID: b753bd60-9a062ba00000359c-ed-4ef037d1b8d8
X-AuditID: b753bd60-9a062ba00000359c-ed-4ef037d1b8d8
Date: Tue, 20 Dec 2011 16:22:41 +0900
From: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@mit.edu>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kevin Hilman <khilman@ti.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Michal Marek <mmarek@suse.cz>, Rik van Riel <riel@redhat.com>,
        Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, frank.rowand@am.sony.com, jan.kiszka@web.de,
        yrl.pp-manager.tt@hitachi.com
Subject: [RFC PATCH 0/5] introduce: Live Dump
Message-ID: <20111220072241.GA9220@t3500.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
User-Agent: StGIT/0.14.3
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

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

This series consists of 5 patches.

Ths 1st patch adds notifier-call-chain in do_page_fault. This is the only
modification against the existing code path of the upstream kernel.

The 2nd patch introduces "livedump" misc device.

The 3rd patch adds the function to split large pages.

The 4th patch introduces feature of write protection management. This
enables users to turn on write protection on kernel space and to install a
hook function that is called every time page fault occurs on each protected
page.

The last patch introduces memory dumping feature. This patch installs the
function to dump content of the protected page on page fault. At the same
time, it lets users to access the dumped data via the misc device
interface.


***How to test***
To test this patch, you have to apply the attached patch to the source code
of crash[1]. This patch can be applied to the version 6.0.1 of crash.  In
addition to this, you have to configure your kernel to turn on
CONFIG_DEBUG_INFO.

[1]crash, http://people.redhat.com/anderson/crash-6.0.1.tar.gz

At first, kick the script tools/livedump/livedump in the order as follows.
 # livedump init
 # livedump split
 # livedump start
 # livedump sweep

At this point, all memory image has been saved (also on memory). Then you
can analyze the image by kicking the patched crash as follows.
 # crash /dev/livedump /boot/System.map-livedump /boot/vmlinux.o-livedump

By the following command, you can release all resources allocated by the
livedump. You can execute this command at any timing (after init, split,
start or sweep).
 # livedump uninit

After executing "uninit", you can start again from "init".

---

YOSHIDA Masanori (5):
      livedump: Add memory dumping functionality
      livedump: Add write protection management
      livedump: Add page splitting functionality
      livedump: Add the new misc device "livedump"
      livedump: Add notifier-call-chain into do_page_fault


 arch/x86/Kconfig                 |   29 ++
 arch/x86/include/asm/traps.h     |    2 
 arch/x86/include/asm/wrprotect.h |   49 +++
 arch/x86/mm/Makefile             |    2 
 arch/x86/mm/fault.c              |    7 
 arch/x86/mm/wrprotect.c          |  613 ++++++++++++++++++++++++++++++++++++++
 kernel/Makefile                  |    1 
 kernel/livedump-memdump.c        |  227 ++++++++++++++
 kernel/livedump-memdump.h        |   45 +++
 kernel/livedump.c                |  131 ++++++++
 tools/livedump/livedump          |   17 +
 11 files changed, 1123 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/wrprotect.h
 create mode 100644 arch/x86/mm/wrprotect.c
 create mode 100644 kernel/livedump-memdump.c
 create mode 100644 kernel/livedump-memdump.h
 create mode 100644 kernel/livedump.c
 create mode 100755 tools/livedump/livedump

-- 
YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>

--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="crash-6.0.1-livedump.patch"

commit 6b649c02506a81b7d9ce36c474d68158e52ae463
Author: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
Date:   Wed Dec 7 16:07:57 2011 +0900

    Fix to support livedump

diff --git a/filesys.c b/filesys.c
index 48259fb..8c79e53 100755
--- a/filesys.c
+++ b/filesys.c
@@ -155,6 +155,7 @@ memory_source_init(void)
 			return;
 
 		if (!STREQ(pc->live_memsrc, "/dev/mem") &&
+		    !STREQ(pc->live_memsrc, "/dev/livedump") &&
 		     STREQ(pc->live_memsrc, pc->memory_device)) {
 			if (memory_driver_init())
 				return;
@@ -175,6 +176,9 @@ memory_source_init(void)
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
index c794ca8..b42c679 100755
--- a/main.c
+++ b/main.c
@@ -435,6 +435,19 @@ main(int argc, char **argv)
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

--SLDf9lqlvOQaIe6s--
