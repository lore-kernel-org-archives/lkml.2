Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058Ab1JRBVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 21:21:47 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:36465 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757006Ab1JRBVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 21:21:45 -0400
X-AuditID: b753bd60-a3cafba0000019f4-e7-4e9cd4a65d1d
X-AuditID: b753bd60-a3cafba0000019f4-e7-4e9cd4a65d1d
Message-ID: <4E9CD49D.6020502@hitachi.com>
Date: Tue, 18 Oct 2011 10:21:33 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Josh Stone <jistone@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH] x86: Make kprobes' twobyte_is_boostable volatile
References: <1318899645-4068-1-git-send-email-jistone@redhat.com>
In-Reply-To: <1318899645-4068-1-git-send-email-jistone@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/10/18 10:00), Josh Stone wrote:
> When compiling an i386_defconfig kernel with gcc-4.6.1-9.fc15.i686, I
> noticed a warning about the asm operand for test_bit in kprobes'
> can_boost.  I discovered that this caused only the first long of
> twobyte_is_boostable[] to be output.
> 
> Jakub filed and fixed gcc PR50571 to correct the warning and this output
> issue.  But to solve it for less current gcc, we can make kprobes'
> twobyte_is_boostable[] volatile, and it won't be optimized out.

Uh, this should be an urgent fix.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks a lot!

> 
> Before:
> 
>     CC      arch/x86/kernel/kprobes.o
>   In file included from include/linux/bitops.h:22:0,
>                    from include/linux/kernel.h:17,
>                    from [...]/arch/x86/include/asm/percpu.h:44,
>                    from [...]/arch/x86/include/asm/current.h:5,
>                    from [...]/arch/x86/include/asm/processor.h:15,
>                    from [...]/arch/x86/include/asm/atomic.h:6,
>                    from include/linux/atomic.h:4,
>                    from include/linux/mutex.h:18,
>                    from include/linux/notifier.h:13,
>                    from include/linux/kprobes.h:34,
>                    from arch/x86/kernel/kprobes.c:43:
>   [...]/arch/x86/include/asm/bitops.h: In function ‘can_boost.part.1’:
>   [...]/arch/x86/include/asm/bitops.h:319:2: warning: use of memory input without lvalue in asm operand 1 is deprecated [enabled by default]
> 
>   $ objdump -rd arch/x86/kernel/kprobes.o | grep -A1 -w bt
>        551:	0f a3 05 00 00 00 00 	bt     %eax,0x0
>                           554: R_386_32	.rodata.cst4
> 
>   $ objdump -s -j .rodata.cst4 -j .data arch/x86/kernel/kprobes.o
> 
>   arch/x86/kernel/kprobes.o:     file format elf32-i386
> 
>   Contents of section .data:
>    0000 48000000 00000000 00000000 00000000  H...............
>   Contents of section .rodata.cst4:
>    0000 4c030000                             L...
> 
> Only a single long of twobyte_is_boostable[] is in the object file.
> 
> After, with volatile:
> 
>   $ objdump -rd arch/x86/kernel/kprobes.o | grep -A1 -w bt
>        551:	0f a3 05 20 00 00 00 	bt     %eax,0x20
>                           554: R_386_32	.data
> 
>   $ objdump -s -j .rodata.cst4 -j .data arch/x86/kernel/kprobes.o
> 
>   arch/x86/kernel/kprobes.o:     file format elf32-i386
> 
>   Contents of section .data:
>    0000 48000000 00000000 00000000 00000000  H...............
>    0010 00000000 00000000 00000000 00000000  ................
>    0020 4c030000 0f000200 ffff0000 ffcff0c0  L...............
>    0030 0000ffff 3bbbfff8 03ff2ebb 26bb2e77  ....;.......&..w
> 
> Now all 32 bytes are output into .data instead.
> 
> Signed-off-by: Josh Stone <jistone@redhat.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Jakub Jelinek <jakub@redhat.com>
> 
> ---
>  arch/x86/kernel/kprobes.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
> index f1a6244..c0ed3d9 100644
> --- a/arch/x86/kernel/kprobes.c
> +++ b/arch/x86/kernel/kprobes.c
> @@ -75,8 +75,10 @@ DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
>  	/*
>  	 * Undefined/reserved opcodes, conditional jump, Opcode Extension
>  	 * Groups, and some special opcodes can not boost.
> +	 * This is volatile to keep gcc from statically optimizing it out, as
> +	 * variable_test_bit makes gcc think only *(unsigned long*) is used.
>  	 */
> -static const u32 twobyte_is_boostable[256 / 32] = {
> +static volatile const u32 twobyte_is_boostable[256 / 32] = {
>  	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
>  	/*      ----------------------------------------------          */
>  	W(0x00, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0) | /* 00 */


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
