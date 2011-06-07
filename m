Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab1FGRSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 13:18:32 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:25404
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756559Ab1FGRSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 13:18:30 -0400
X-SpamScore: -8
X-BigFish: VPS-8(z21eNz98dKzz1202hzz8275bh8275dhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMFK2M-01-4F2-02
X-M-MSG: 
Date: Tue, 7 Jun 2011 19:18:22 +0200
From: Robert Richter <robert.richter@amd.com>
To: John Lumby <johnlumby@hotmail.com>
CC: Maynard Johnson <maynardj@us.ibm.com>,
        oprofile list <oprofile-list@lists.sourceforge.net>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] oprofile, x86: Fix nmi-unsafe callgraph support in, 2.6.27
 and later
Message-ID: <20110607171822.GI20052@erda.amd.com>
References: <COL116-W380DF5357514E3CC28BB66A38F0@phx.gbl>
 <4DD5046F.3000807@us.ibm.com>
 <4DD53BC8.2010208@hotmail.com>
 <20110607105259.GE20052@erda.amd.com>
 <4DEE2F09.6090803@hotmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4DEE2F09.6090803@hotmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.06.11 10:00:41, John Lumby wrote:
> But please do send your fix along and I'll give it a try.   I now have 
> capability for capturing un-syslog'd console messages such as these via 
> serial console so if it happens again I should be able to provide more 
> information.

See the fix below.

-Robert


>From c73bebe2e281ae089499d7cbc3b44a0869c8daf8 Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Fri, 3 Jun 2011 16:37:47 +0200
Subject: [PATCH] oprofile, x86: Fix nmi-unsafe callgraph support

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
Cc: <stable@kernel.org> # .37+
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/backtrace.c |   56 ++++++++++++++++++++++++++++++++++------
 1 files changed, 47 insertions(+), 9 deletions(-)

diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
index 2d49d4e..88e856e 100644
--- a/arch/x86/oprofile/backtrace.c
+++ b/arch/x86/oprofile/backtrace.c
@@ -11,10 +11,12 @@
 #include <linux/oprofile.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
+#include <linux/compat.h>
+#include <linux/highmem.h>
+
 #include <asm/ptrace.h>
 #include <asm/uaccess.h>
 #include <asm/stacktrace.h>
-#include <linux/compat.h>
 
 static void backtrace_warning_symbol(void *data, char *msg,
 				     unsigned long symbol)
@@ -49,17 +51,53 @@ static struct stacktrace_ops backtrace_ops = {
 	.walk_stack	= print_context_stack,
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
+		map = kmap_atomic(page);
+		memcpy(to, map+offset, size);
+		kunmap_atomic(map);
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
 #ifdef CONFIG_COMPAT
 static struct stack_frame_ia32 *
 dump_user_backtrace_32(struct stack_frame_ia32 *head)
 {
+	/* Also check accessibility of one struct frame_head beyond: */
 	struct stack_frame_ia32 bufhead[2];
 	struct stack_frame_ia32 *fp;
+	unsigned long bytes;
 
-	/* Also check accessibility of one struct frame_head beyond */
-	if (!access_ok(VERIFY_READ, head, sizeof(bufhead)))
-		return NULL;
-	if (__copy_from_user_inatomic(bufhead, head, sizeof(bufhead)))
+	bytes = copy_from_user_nmi(bufhead, head, sizeof(bufhead));
+	if (bytes != sizeof(bufhead))
 		return NULL;
 
 	fp = (struct stack_frame_ia32 *) compat_ptr(bufhead[0].next_frame);
@@ -100,12 +138,12 @@ x86_backtrace_32(struct pt_regs * const regs, unsigned int depth)
 
 static struct stack_frame *dump_user_backtrace(struct stack_frame *head)
 {
+	/* Also check accessibility of one struct frame_head beyond: */
 	struct stack_frame bufhead[2];
+	unsigned long bytes;
 
-	/* Also check accessibility of one struct stack_frame beyond */
-	if (!access_ok(VERIFY_READ, head, sizeof(bufhead)))
-		return NULL;
-	if (__copy_from_user_inatomic(bufhead, head, sizeof(bufhead)))
+	bytes = copy_from_user_nmi(bufhead, head, sizeof(bufhead));
+	if (bytes != sizeof(bufhead))
 		return NULL;
 
 	oprofile_add_trace(bufhead[0].return_address);
-- 
1.7.5.rc3



-- 
Advanced Micro Devices, Inc.
Operating System Research Center

