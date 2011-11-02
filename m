Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab1KCBfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:35:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50544 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932764Ab1KCBfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:35:03 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:55 2011
Message-Id: <20111102221455.343054313@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:14:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jakub Jelinek <jakub@redhat.com>
Subject: [057/107] x86: Fix compilation bug in kprobes twobyte_is_boostable
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Josh Stone <jistone@redhat.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/kprobes.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -83,8 +83,10 @@ DEFINE_PER_CPU(struct kprobe_ctlblk, kpr
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


