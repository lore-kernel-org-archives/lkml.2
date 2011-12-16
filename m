Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964969Ab1LPUwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 15:52:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48984 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964939Ab1LPUvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 15:51:53 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 12:50:43 2011
Message-Id: <20111216205043.465306786@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 12:49:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg KH <greg@kroah.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        John Lumby <johnlumby@hotmail.com>,
        Maynard Johnson <maynardj@us.ibm.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [13/16] [PATCH 2/3] oprofile, x86: Fix nmi-unsafe callgraph support
In-Reply-To: <20111216205049.GA28030@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Richter <robert.richter@amd.com>

commit a0e3e70243f5b270bc3eca718f0a9fa5e6b8262e upstream.

Backport for stable kernel v2.6.32.y to v2.6.36.y.

Current oprofile's x86 callgraph support may trigger page faults
throwing the BUG_ON(in_nmi()) message below. This patch fixes this by
using the same nmi-safe copy-from-user code as in perf.

------------[ cut here ]------------
kernel BUG at .../arch/x86/kernel/traps.c:436!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:0a.0/0000:07:00.0/0000:08:04.0/net/eth0/broadcast
CPU 5
Modules linked in:

Pid: 8611, comm: opcontrol Not tainted 2.6.39-00007-gfe47ae7 #1 Advanced Micro Device Anaheim/Anaheim
RIP: 0010:[<ffffffff813e8e35>]  [<ffffffff813e8e35>] do_nmi+0x22/0x1ee
RSP: 0000:ffff88042fd47f28  EFLAGS: 00010002
RAX: ffff88042c0a7fd8 RBX: 0000000000000001 RCX: 00000000c0000101
RDX: 00000000ffff8804 RSI: ffffffffffffffff RDI: ffff88042fd47f58
RBP: ffff88042fd47f48 R08: 0000000000000004 R09: 0000000000001484
R10: 0000000000000001 R11: 0000000000000000 R12: ffff88042fd47f58
R13: 0000000000000000 R14: ffff88042fd47d98 R15: 0000000000000020
FS:  00007fca25e56700(0000) GS:ffff88042fd40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000074 CR3: 000000042d28b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process opcontrol (pid: 8611, threadinfo ffff88042c0a6000, task ffff88042c532310)
Stack:
 0000000000000000 0000000000000001 ffff88042c0a7fd8 0000000000000000
 ffff88042fd47de8 ffffffff813e897a 0000000000000020 ffff88042fd47d98
 0000000000000000 ffff88042c0a7fd8 ffff88042fd47de8 0000000000000074
Call Trace:
 <NMI>
 [<ffffffff813e897a>] nmi+0x1a/0x20
 [<ffffffff813f08ab>] ? bad_to_user+0x25/0x771
 <<EOE>>
Code: ff 59 5b 41 5c 41 5d c9 c3 55 65 48 8b 04 25 88 b5 00 00 48 89 e5 41 55 41 54 49 89 fc 53 48 83 ec 08 f6 80 47 e0 ff ff 04 74 04 <0f> 0b eb fe 81 80 44 e0 ff ff 00 00 01 04 65 ff 04 25 c4 0f 01
RIP  [<ffffffff813e8e35>] do_nmi+0x22/0x1ee
 RSP <ffff88042fd47f28>
---[ end trace ed6752185092104b ]---
Kernel panic - not syncing: Fatal exception in interrupt
Pid: 8611, comm: opcontrol Tainted: G      D     2.6.39-00007-gfe47ae7 #1
Call Trace:
 <NMI>  [<ffffffff813e5e0a>] panic+0x8c/0x188
 [<ffffffff813e915c>] oops_end+0x81/0x8e
 [<ffffffff8100403d>] die+0x55/0x5e
 [<ffffffff813e8c45>] do_trap+0x11c/0x12b
 [<ffffffff810023c8>] do_invalid_op+0x91/0x9a
 [<ffffffff813e8e35>] ? do_nmi+0x22/0x1ee
 [<ffffffff8131e6fa>] ? oprofile_add_sample+0x83/0x95
 [<ffffffff81321670>] ? op_amd_check_ctrs+0x4f/0x2cf
 [<ffffffff813ee4d5>] invalid_op+0x15/0x20
 [<ffffffff813e8e35>] ? do_nmi+0x22/0x1ee
 [<ffffffff813e8e7a>] ? do_nmi+0x67/0x1ee
 [<ffffffff813e897a>] nmi+0x1a/0x20
 [<ffffffff813f08ab>] ? bad_to_user+0x25/0x771
 <<EOE>>

Cc: John Lumby <johnlumby@hotmail.com>
Cc: Maynard Johnson <maynardj@us.ibm.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/oprofile/backtrace.c |   46 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 4 deletions(-)

--- a/arch/x86/oprofile/backtrace.c
+++ b/arch/x86/oprofile/backtrace.c
@@ -11,6 +11,8 @@
 #include <linux/oprofile.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
+#include <linux/highmem.h>
+
 #include <asm/ptrace.h>
 #include <asm/uaccess.h>
 #include <asm/stacktrace.h>
@@ -47,6 +49,42 @@ static struct stacktrace_ops backtrace_o
 	.address = backtrace_address,
 };
 
+/* from arch/x86/kernel/cpu/perf_event.c: */
+
+/*
+ * best effort, GUP based copy_from_user() that assumes IRQ or NMI context
+ */
+static unsigned long
+copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
+{
+	unsigned long offset, addr = (unsigned long)from;
+	unsigned long size, len = 0;
+	struct page *page;
+	void *map;
+	int ret;
+
+	do {
+		ret = __get_user_pages_fast(addr, 1, 0, &page);
+		if (!ret)
+			break;
+
+		offset = addr & (PAGE_SIZE - 1);
+		size = min(PAGE_SIZE - offset, n - len);
+
+		map = kmap_atomic(page, KM_USER0);
+		memcpy(to, map+offset, size);
+		kunmap_atomic(map, KM_USER0);
+		put_page(page);
+
+		len  += size;
+		to   += size;
+		addr += size;
+
+	} while (len < n);
+
+	return len;
+}
+
 struct frame_head {
 	struct frame_head *bp;
 	unsigned long ret;
@@ -54,12 +92,12 @@ struct frame_head {
 
 static struct frame_head *dump_user_backtrace(struct frame_head *head)
 {
+	/* Also check accessibility of one struct frame_head beyond: */
 	struct frame_head bufhead[2];
+	unsigned long bytes;
 
-	/* Also check accessibility of one struct frame_head beyond */
-	if (!access_ok(VERIFY_READ, head, sizeof(bufhead)))
-		return NULL;
-	if (__copy_from_user_inatomic(bufhead, head, sizeof(bufhead)))
+	bytes = copy_from_user_nmi(bufhead, head, sizeof(bufhead));
+	if (bytes != sizeof(bufhead))
 		return NULL;
 
 	oprofile_add_trace(bufhead[0].ret);


