Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab0JNHFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 03:05:18 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18680 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab0JNHFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 03:05:16 -0400
Message-ID: <4CB6AB24.9020504@kernel.org>
Date: Thu, 14 Oct 2010 00:03:00 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100914 SUSE/3.0.8 Thunderbird/3.0.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, hpa@zytor.com, jeremy@goop.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/memblock] x86-64: Only set max_pfn_mapped to 512 MiB
 if we enter via head_64.S
References: <4CB641F7.9040103@goop.org> <tip-859ee4f57fb4e91de8439496f62eb996f4a28ca8@git.kernel.org> <20101014055714.GA3329@elte.hu> <4CB69E22.2010005@kernel.org> <20101014063706.GA23561@elte.hu>
In-Reply-To: <20101014063706.GA23561@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2010 11:37 PM, Ingo Molnar wrote:
> 
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> On 10/13/2010 10:57 PM, Ingo Molnar wrote:
>>>
>>> * tip-bot for Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>>
>>>> Commit-ID:  859ee4f57fb4e91de8439496f62eb996f4a28ca8
>>>> Gitweb:     http://git.kernel.org/tip/859ee4f57fb4e91de8439496f62eb996f4a28ca8
>>>> Author:     Jeremy Fitzhardinge <jeremy@goop.org>
>>>> AuthorDate: Wed, 13 Oct 2010 16:34:15 -0700
>>>> Committer:  H. Peter Anvin <hpa@linux.intel.com>
>>>> CommitDate: Wed, 13 Oct 2010 17:09:59 -0700
>>>>
>>>> x86-64: Only set max_pfn_mapped to 512 MiB if we enter via head_64.S
>>>>
>>>> head_64.S maps up to 512 MiB, but that is not necessarity true for
>>>> other entry paths, such as Xen.
>>>

please fold following patch into 859ee4f57fb4e91de8439496f62eb996f4a28ca8

Thanks

Yinghai

[PATCH] x86_64: Set max_pfn_mapped in x86_64_start_kernel

Ingo found:
[    0.000000] init_memory_mapping: 0000000000000000-000000003fff0000
[    0.000000]  0000000000 - 003fe00000 page 2M
[    0.000000]  003fe00000 - 003fff0000 page 4k
[    0.000000] Kernel panic - not syncing: Cannot find space for the kernel page tables
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.36-rc7-tip+ #49192
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8156c73f>] panic+0x8c/0x192
[    0.000000]  [<ffffffff8156c881>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8154ec40>] init_memory_mapping+0x372/0x506
[    0.000000]  [<ffffffff819053ed>] ? memblock_x86_reserve_range+0x7c/0x83
[    0.000000]  [<ffffffff818f2f3d>] setup_arch+0x5a3/0xa68
[    0.000000]  [<ffffffff8156c881>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff81061135>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff818ef9e1>] start_kernel+0x83/0x36e
[    0.000000]  [<ffffffff818ef2a8>] x86_64_start_reservations+0xb8/0xbc
[    0.000000]  [<ffffffff818ef393>] x86_64_start_kernel+0xe7/0xee

caused by:
|  859ee4f: x86-64: Only set max_pfn_mapped to 512 MiB if we enter via head_64.S

it turns out max_pfn_mapped is in .bss section.

So We need to set that after bss get cleared.

that is safe because xen don't call x86_64_start_kernel()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/head64.c  |    2 ++
 arch/x86/kernel/head_64.S |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/head64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head64.c
+++ linux-2.6/arch/x86/kernel/head64.c
@@ -80,6 +80,8 @@ void __init x86_64_start_kernel(char * r
 	/* Cleanup the over mapped high alias */
 	cleanup_highmap();
 
+	max_pfn_mapped = KERNEL_IMAGE_SIZE >> PAGE_SHIFT;
+
 	for (i = 0; i < NUM_EXCEPTION_VECTORS; i++) {
 #ifdef CONFIG_EARLY_PRINTK
 		set_intr_gate(i, &early_idt_handlers[i]);
Index: linux-2.6/arch/x86/kernel/head_64.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head_64.S
+++ linux-2.6/arch/x86/kernel/head_64.S
@@ -141,8 +141,6 @@ ident_complete:
 	addq	%rbp, trampoline_level4_pgt + (511*8)(%rip)
 #endif
 
-	movq    $KERNEL_IMAGE_SIZE / PAGE_SIZE, max_pfn_mapped(%rip)
-
 	/* Due to ENTRY(), sometimes the empty space gets filled with
 	 * zeros. Better take a jmp than relying on empty space being
 	 * filled with 0x90 (nop)
