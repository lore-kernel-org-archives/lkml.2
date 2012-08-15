Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab2HOUXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:23:38 -0400
Received: from mail.windriver.com ([147.11.1.11]:36810 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756603Ab2HOTud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:33 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jakub Jelinek <jakub@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 069/165] x86: Fix compilation bug in kprobes' twobyte_is_boostable
Date: Wed, 15 Aug 2012 15:46:53 -0400
Message-ID: <1345060109-9187-70-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Stone <jistone@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 315eb8a2a1b7f335d40ceeeb11b9e067475eb881 upstream.

When compiling an i386_defconfig kernel with gcc-4.6.1-9.fc15.i686, I
noticed a warning about the asm operand for test_bit in kprobes'
can_boost.  I discovered that this caused only the first long of
twobyte_is_boostable[] to be output.

Jakub filed and fixed gcc PR50571 to correct the warning and this output
issue.  But to solve it for less current gcc, we can make kprobes'
twobyte_is_boostable[] non-const, and it won't be optimized out.

Before:

    CC      arch/x86/kernel/kprobes.o
  In file included from include/linux/bitops.h:22:0,
                   from include/linux/kernel.h:17,
                   from [...]/arch/x86/include/asm/percpu.h:44,
                   from [...]/arch/x86/include/asm/current.h:5,
                   from [...]/arch/x86/include/asm/processor.h:15,
                   from [...]/arch/x86/include/asm/atomic.h:6,
                   from include/linux/atomic.h:4,
                   from include/linux/mutex.h:18,
                   from include/linux/notifier.h:13,
                   from include/linux/kprobes.h:34,
                   from arch/x86/kernel/kprobes.c:43:
  [...]/arch/x86/include/asm/bitops.h: In function ‘can_boost.part.1’:
  [...]/arch/x86/include/asm/bitops.h:319:2: warning: use of memory input
        without lvalue in asm operand 1 is deprecated [enabled by default]

  $ objdump -rd arch/x86/kernel/kprobes.o | grep -A1 -w bt
       551:	0f a3 05 00 00 00 00 	bt     %eax,0x0
                          554: R_386_32	.rodata.cst4

  $ objdump -s -j .rodata.cst4 -j .data arch/x86/kernel/kprobes.o

  arch/x86/kernel/kprobes.o:     file format elf32-i386

  Contents of section .data:
   0000 48000000 00000000 00000000 00000000  H...............
  Contents of section .rodata.cst4:
   0000 4c030000                             L...

Only a single long of twobyte_is_boostable[] is in the object file.

After, without the const on twobyte_is_boostable:

  $ objdump -rd arch/x86/kernel/kprobes.o | grep -A1 -w bt
       551:	0f a3 05 20 00 00 00 	bt     %eax,0x20
                          554: R_386_32	.data

  $ objdump -s -j .rodata.cst4 -j .data arch/x86/kernel/kprobes.o

  arch/x86/kernel/kprobes.o:     file format elf32-i386

  Contents of section .data:
   0000 48000000 00000000 00000000 00000000  H...............
   0010 00000000 00000000 00000000 00000000  ................
   0020 4c030000 0f000200 ffff0000 ffcff0c0  L...............
   0030 0000ffff 3bbbfff8 03ff2ebb 26bb2e77  ....;.......&..w

Now all 32 bytes are output into .data instead.

Signed-off-by: Josh Stone <jistone@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/kprobes.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index ac4ed92..9619315 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -75,8 +75,10 @@ DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 	/*
 	 * Undefined/reserved opcodes, conditional jump, Opcode Extension
 	 * Groups, and some special opcodes can not boost.
+	 * This is non-const to keep gcc from statically optimizing it out, as
+	 * variable_test_bit makes gcc think only *(unsigned long*) is used.
 	 */
-static const u32 twobyte_is_boostable[256 / 32] = {
+static u32 twobyte_is_boostable[256 / 32] = {
 	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
 	/*      ----------------------------------------------          */
 	W(0x00, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0) | /* 00 */
-- 
1.7.12.rc2

