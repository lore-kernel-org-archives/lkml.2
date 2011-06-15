Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab1FOV72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 17:59:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:53307 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958Ab1FOV71 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 17:59:27 -0400
From: Alexander Graf <agraf@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: Oops in VMA code
Date: Wed, 15 Jun 2011 23:59:21 +0200
Message-Id: <47FAB15C-B113-40FD-9CE0-49566AACC0DF@suse.de>
Cc: linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi memory management experts,

I just had this crash while compiling code on my PPC G5. I was running my PPC KVM tree, which was pretty much 06e86849cf4019945a106913adb9ff0abcc01770 plus a few unrelated KVM patches. User space is 64-bit.

Is this a known issue or did I hit something completely unexpected?


Unable to handle kernel paging request for data at address 0xc00090026236bbc0
Faulting instruction address: 0xc000000000190598
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=4 NUMA PowerMac
Modules linked in:
NIP: c000000000190598 LR: c0000000001908a4 CTR: c000000000190850
REGS: c000000262987a50 TRAP: 0300   Tainted: G        W    (3.0.0-rc2+)
MSR: 9000000000009032 <EE,ME,IR,DR>  CR: 48000448  XER: 00000000
DAR: c00090026236bbc0, DSISR: 40010000
TASK = c000000262d6cfb0[13951] 'cc1' THREAD: c000000262984000 CPU: 2
GPR00: 0000040008f1f000 c000000262987cd0 c000000000e31578 c000000262828e00 
GPR04: 0000000000008000 0000000000008000 ffffffffffffffff 0000000000000000 
GPR08: fffff000fffff000 c00090026236bbe8 0000100000000000 c00000026236b420 
GPR12: 0000000028000442 c00000000fffef00 000000000000005f 0000000010026be4 
GPR16: 0000000000000000 00000000109fa6a4 00000000109eb110 00000000108b6338 
GPR20: 000000001099ca90 000000001099c590 0000000000000000 00000000109eb164 
GPR24: 00000000109fa7a8 0000000000000001 c00090026236bbb0 0000040008f45000 
GPR28: c0000002628fc580 c000000262828e00 c000000000d631e8 0000040008f45000 
NIP [c000000000190598] .do_munmap+0x138/0x3f0
LR [c0000000001908a4] .SyS_munmap+0x54/0x90
Call Trace:
[c000000262987cd0] [0000000000008000] 0x8000 (unreliable)
[c000000262987d90] [c0000000001908a4] .SyS_munmap+0x54/0x90
[c000000262987e30] [c000000000009864] syscall_exit+0x0/0x40
Instruction dump:
3b400000 2fa90000 409e0024 4800005c 60000000 60000000 e9290010 7d7a5b78 
2fa90000 7f4bd378 419e0034 3b49ffc8 <e81a0010> 7fbf0040 419cffe0 e97a0018 
---[ end trace 31fd0ba7d8756003 ]---


It seems to be related to vma mapping, but I have no idea in that area of code:

(gdb) l *0xc000000000190598
0xc000000000190598 is in find_vma_prev (mm/mmap.c:1641).
1636	
1637		while (rb_node) {
1638			struct vm_area_struct *vma_tmp;
1639			vma_tmp = rb_entry(rb_node, struct vm_area_struct, vm_rb);
1640	
1641			if (addr < vma_tmp->vm_end) {
1642				rb_node = rb_node->rb_left;
1643			} else {
1644				prev = vma_tmp;
1645				if (!prev->vm_next || (addr < prev->vm_next->vm_end))


Ben suggested to also dump the disassembly of that function, so here it is:


0xc00000000018e630 <find_vma_prev>:	cmpdi   r3,0
0xc00000000018e634 <find_vma_prev+4>:	beq     0xc00000000018e6d0 <find_vma_prev+160>
0xc00000000018e638 <find_vma_prev+8>:	ld      r11,8(r3)
0xc00000000018e63c <find_vma_prev+12>:	ld      r3,0(r3)
0xc00000000018e640 <find_vma_prev+16>:	cmpdi   cr7,r11,0
0xc00000000018e644 <find_vma_prev+20>:	beq     cr7,0xc00000000018e6dc <find_vma_prev+172>
0xc00000000018e648 <find_vma_prev+24>:	li      r8,0
0xc00000000018e64c <find_vma_prev+28>:	b       0xc00000000018e65c <find_vma_prev+44>
0xc00000000018e650 <find_vma_prev+32>:	ld      r11,16(r11)
0xc00000000018e654 <find_vma_prev+36>:	cmpdi   cr7,r11,0
0xc00000000018e658 <find_vma_prev+40>:	beq     cr7,0xc00000000018e694 <find_vma_prev+100>
0xc00000000018e65c <find_vma_prev+44>:	addi    r9,r11,-56
0xc00000000018e660 <find_vma_prev+48>:	ld      r0,16(r9)
0xc00000000018e664 <find_vma_prev+52>:	cmpld   cr7,r0,r4
0xc00000000018e668 <find_vma_prev+56>:	bgt     cr7,0xc00000000018e650 <find_vma_prev+32>
0xc00000000018e66c <find_vma_prev+60>:	ld      r10,24(r9)
0xc00000000018e670 <find_vma_prev+64>:	mr      r8,r9
0xc00000000018e674 <find_vma_prev+68>:	cmpdi   cr7,r10,0
0xc00000000018e678 <find_vma_prev+72>:	beq     cr7,0xc00000000018e6b0 <find_vma_prev+128>
0xc00000000018e67c <find_vma_prev+76>:	ld      r0,16(r10)
0xc00000000018e680 <find_vma_prev+80>:	cmpld   cr7,r4,r0
0xc00000000018e684 <find_vma_prev+84>:	blt     cr7,0xc00000000018e6b0 <find_vma_prev+128>
0xc00000000018e688 <find_vma_prev+88>:	ld      r11,8(r11)
0xc00000000018e68c <find_vma_prev+92>:	cmpdi   cr7,r11,0
0xc00000000018e690 <find_vma_prev+96>:	bne     cr7,0xc00000000018e65c <find_vma_prev+44>
0xc00000000018e694 <find_vma_prev+100>:	cmpdi   cr7,r8,0
0xc00000000018e698 <find_vma_prev+104>:	std     r8,0(r5)
0xc00000000018e69c <find_vma_prev+108>:	beqlr-  cr7
0xc00000000018e6a0 <find_vma_prev+112>:	ld      r3,24(r8)
0xc00000000018e6a4 <find_vma_prev+116>:	blr
0xc00000000018e6a8 <find_vma_prev+120>:	nop
0xc00000000018e6ac <find_vma_prev+124>:	nop
0xc00000000018e6b0 <find_vma_prev+128>:	mr      r8,r9
0xc00000000018e6b4 <find_vma_prev+132>:	cmpdi   cr7,r8,0
0xc00000000018e6b8 <find_vma_prev+136>:	std     r8,0(r5)
0xc00000000018e6bc <find_vma_prev+140>:	bne+    cr7,0xc00000000018e6a0 <find_vma_prev+112>
0xc00000000018e6c0 <find_vma_prev+144>:	blr
0xc00000000018e6c4 <find_vma_prev+148>:	nop
0xc00000000018e6c8 <find_vma_prev+152>:	nop
0xc00000000018e6cc <find_vma_prev+156>:	nop
0xc00000000018e6d0 <find_vma_prev+160>:	std     r3,0(r5)
0xc00000000018e6d4 <find_vma_prev+164>:	li      r3,0
0xc00000000018e6d8 <find_vma_prev+168>:	blr
0xc00000000018e6dc <find_vma_prev+172>:	std     r11,0(r5)
0xc00000000018e6e0 <find_vma_prev+176>:	blr


Alex

