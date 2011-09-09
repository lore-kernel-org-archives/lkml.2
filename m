Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903Ab1IIBLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 21:11:49 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41661 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab1IIBL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 21:11:28 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6463"; a="116864730"
Message-Id: <20110909010916.902770712@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Thu, 08 Sep 2011 20:09:10 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [patch v3 23/36] Hexagon: Add user access functions
References: <20110909010847.294039464@codeaurora.org>
Content-Disposition: inline; filename=userspace.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>

---
 arch/hexagon/include/asm/uaccess.h   |  116 +++++++++++++++++++++
 arch/hexagon/mm/copy_from_user.S     |  114 +++++++++++++++++++++
 arch/hexagon/mm/copy_to_user.S       |   92 +++++++++++++++++
 arch/hexagon/mm/copy_user_template.S |  185 +++++++++++++++++++++++++++++++++++
 arch/hexagon/mm/strnlen_user.S       |  140 ++++++++++++++++++++++++++
 arch/hexagon/mm/uaccess.c            |   59 +++++++++++
 6 files changed, 706 insertions(+)

Index: linux-hexagon-kernel/arch/hexagon/include/asm/uaccess.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/uaccess.h	2011-09-03 20:14:59.724981391 -0500
@@ -0,0 +1,116 @@
+/*
+ * User memory access support for Hexagon
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_UACCESS_H
+#define _ASM_UACCESS_H
+/*
+ * User space memory access functions
+ */
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <asm/segment.h>
+#include <asm/sections.h>
+
+/*
+ * access_ok: - Checks if a user space pointer is valid
+ * @type: Type of access: %VERIFY_READ or %VERIFY_WRITE.  Note that
+ *        %VERIFY_WRITE is a superset of %VERIFY_READ - if it is safe
+ *        to write to a block, it is always safe to read from it.
+ * @addr: User space pointer to start of block to check
+ * @size: Size of block to check
+ *
+ * Context: User context only.  This function may sleep.
+ *
+ * Checks if a pointer to a block of memory in user space is valid.
+ *
+ * Returns true (nonzero) if the memory block *may* be valid, false (zero)
+ * if it is definitely invalid.
+ *
+ * User address space in Hexagon, like x86, goes to 0xbfffffff, so the
+ * simple MSB-based tests used by MIPS won't work.  Some further
+ * optimization is probably possible here, but for now, keep it
+ * reasonably simple and not *too* slow.  After all, we've got the
+ * MMU for backup.
+ */
+#define VERIFY_READ     0
+#define VERIFY_WRITE    1
+
+#define __access_ok(addr, size) \
+	((get_fs().seg == KERNEL_DS.seg) || \
+	(((unsigned long)addr < get_fs().seg) && \
+	  (unsigned long)size < (get_fs().seg - (unsigned long)addr)))
+
+/*
+ * When a kernel-mode page fault is taken, the faulting instruction
+ * address is checked against a table of exception_table_entries.
+ * Each entry is a tuple of the address of an instruction that may
+ * be authorized to fault, and the address at which execution should
+ * be resumed instead of the faulting instruction, so as to effect
+ * a workaround.
+ */
+
+/*  Assembly somewhat optimized copy routines  */
+unsigned long __copy_from_user_hexagon(void *to, const void __user *from,
+				     unsigned long n);
+unsigned long __copy_to_user_hexagon(void __user *to, const void *from,
+				   unsigned long n);
+
+#define __copy_from_user(to, from, n) __copy_from_user_hexagon(to, from, n)
+#define __copy_to_user(to, from, n) __copy_to_user_hexagon(to, from, n)
+
+/*
+ * XXX todo: some additonal performance gain is possible by
+ * implementing __copy_to/from_user_inatomic, which is much
+ * like __copy_to/from_user, but performs slightly less checking.
+ */
+
+__kernel_size_t __clear_user_hexagon(void __user *dest, unsigned long count);
+#define __clear_user(a, s) __clear_user_hexagon((a), (s))
+
+#define __strncpy_from_user(dst, src, n) hexagon_strncpy_from_user(dst, src, n)
+
+/*  get around the ifndef in asm-generic/uaccess.h  */
+#define __strnlen_user __strnlen_user
+
+extern long __strnlen_user(const char __user *src, long n);
+
+static inline long hexagon_strncpy_from_user(char *dst, const char __user *src,
+					     long n);
+
+#include <asm-generic/uaccess.h>
+
+/*  Todo:  an actual accelerated version of this.  */
+static inline long hexagon_strncpy_from_user(char *dst, const char __user *src,
+					     long n)
+{
+	long res = __strnlen_user(src, n);
+
+	/* return from strnlen can't be zero -- that would be rubbish. */
+
+	if (res > n) {
+		copy_from_user(dst, src, n);
+		return n;
+	} else {
+		copy_from_user(dst, src, res);
+		return res-1;
+	}
+}
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/mm/copy_from_user.S
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/mm/copy_from_user.S	2011-09-03 20:14:59.724981391 -0500
@@ -0,0 +1,114 @@
+/*
+ * User memory copy functions for kernel
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+/*
+ * The right way to do this involves valignb
+ * The easy way to do this is only speed up src/dest similar alignment.
+ */
+
+/*
+ * Copy to/from user are the same, except that for packets with a load and
+ * a store, I don't know how to tell which kind of exception we got.
+ * Therefore, we duplicate the function, and handle faulting addresses
+ * differently for each function
+ */
+
+/*
+ * copy from user: loads can fault
+ */
+#define src_sav r13
+#define dst_sav r12
+#define src_dst_sav r13:12
+#define d_dbuf r15:14
+#define w_dbuf r15
+
+#define dst r0
+#define src r1
+#define bytes r2
+#define loopcount r5
+
+#define FUNCNAME __copy_from_user_hexagon
+#include "copy_user_template.S"
+
+	/* LOAD FAULTS from COPY_FROM_USER */
+
+	/* Alignment loop.  r2 has been updated. Return it. */
+	.falign
+1009:
+2009:
+4009:
+	{
+		r0 = r2
+		jumpr r31
+	}
+	/* Normal copy loops. Do epilog. Use src-src_sav to compute distance */
+	/* X - (A - B) == X + B - A */
+	.falign
+8089:
+	{
+		memd(dst) = d_dbuf
+		r2 += sub(src_sav,src)
+	}
+	{
+		r0 = r2
+		jumpr r31
+	}
+	.falign
+4089:
+	{
+		memw(dst) = w_dbuf
+		r2 += sub(src_sav,src)
+	}
+	{
+		r0 = r2
+		jumpr r31
+	}
+	.falign
+2089:
+	{
+		memh(dst) = w_dbuf
+		r2 += sub(src_sav,src)
+	}
+	{
+		r0 = r2
+		jumpr r31
+	}
+	.falign
+1089:
+	{
+		memb(dst) = w_dbuf
+		r2 += sub(src_sav,src)
+	}
+	{
+		r0 = r2
+		jumpr r31
+	}
+
+	/* COPY FROM USER: only loads can fail */
+
+	.section __ex_table,"a"
+	.long 1000b,1009b
+	.long 2000b,2009b
+	.long 4000b,4009b
+	.long 8080b,8089b
+	.long 4080b,4089b
+	.long 2080b,2089b
+	.long 1080b,1089b
+	.previous
Index: linux-hexagon-kernel/arch/hexagon/mm/copy_to_user.S
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/mm/copy_to_user.S	2011-09-03 20:14:59.724981391 -0500
@@ -0,0 +1,92 @@
+/*
+ * User memory copying routines for the Hexagon Kernel
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+/* The right way to do this involves valignb
+ * The easy way to do this is only speed up src/dest similar alignment.
+ */
+
+/*
+ * Copy to/from user are the same, except that for packets with a load and
+ * a store, I don't know how to tell which kind of exception we got.
+ * Therefore, we duplicate the function, and handle faulting addresses
+ * differently for each function
+ */
+
+/*
+ * copy to user: stores can fault
+ */
+#define src_sav r13
+#define dst_sav r12
+#define src_dst_sav r13:12
+#define d_dbuf r15:14
+#define w_dbuf r15
+
+#define dst r0
+#define src r1
+#define bytes r2
+#define loopcount r5
+
+#define FUNCNAME __copy_to_user_hexagon
+#include "copy_user_template.S"
+
+	/* STORE FAULTS from COPY_TO_USER */
+	.falign
+1109:
+2109:
+4109:
+	/* Alignment loop.  r2 has been updated.  Return it. */
+	{
+		r0 = r2
+		jumpr r31
+	}
+	/* Normal copy loops.  Use dst-dst_sav to compute distance */
+	/* dst holds best write, no need to unwind any loops */
+	/* X - (A - B) == X + B - A */
+	.falign
+8189:
+8199:
+4189:
+4199:
+2189:
+2199:
+1189:
+1199:
+	{
+		r2 += sub(dst_sav,dst)
+	}
+	{
+		r0 = r2
+		jumpr r31
+	}
+
+	/* COPY TO USER: only stores can fail */
+	.section __ex_table,"a"
+	.long 1100b,1109b
+	.long 2100b,2109b
+	.long 4100b,4109b
+	.long 8180b,8189b
+	.long 8190b,8199b
+	.long 4180b,4189b
+	.long 4190b,4199b
+	.long 2180b,2189b
+	.long 2190b,2199b
+	.long 1180b,1189b
+	.long 1190b,1199b
+	.previous
Index: linux-hexagon-kernel/arch/hexagon/mm/copy_user_template.S
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/mm/copy_user_template.S	2011-09-03 20:14:59.724981391 -0500
@@ -0,0 +1,185 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+/* Numerology:
+ * WXYZ
+ * W: width in bytes
+ * X: Load=0, Store=1
+ * Y: Location 0=preamble,8=loop,9=epilog
+ * Z: Location=0,handler=9
+ */
+	.text
+	.global FUNCNAME
+	.type FUNCNAME, @function
+	.p2align 5
+FUNCNAME:
+	{
+		p0 = cmp.gtu(bytes,#0)
+		if (!p0.new) jump:nt .Ldone
+		r3 = or(dst,src)
+		r4 = xor(dst,src)
+	}
+	{
+		p1 = cmp.gtu(bytes,#15)
+		p0 = bitsclr(r3,#7)
+		if (!p0.new) jump:nt .Loop_not_aligned_8
+		src_dst_sav = combine(src,dst)
+	}
+
+	{
+		loopcount = lsr(bytes,#3)
+		if (!p1) jump .Lsmall
+	}
+	p3=sp1loop0(.Loop8,loopcount)
+.Loop8:
+8080:
+8180:
+	{
+		if (p3) memd(dst++#8) = d_dbuf
+		d_dbuf = memd(src++#8)
+	}:endloop0
+8190:
+	{
+		memd(dst++#8) = d_dbuf
+		bytes -= asl(loopcount,#3)
+		jump .Lsmall
+	}
+
+.Loop_not_aligned_8:
+	{
+		p0 = bitsclr(r4,#7)
+		if (p0.new) jump:nt .Lalign
+	}
+	{
+		p0 = bitsclr(r3,#3)
+		if (!p0.new) jump:nt .Loop_not_aligned_4
+		p1 = cmp.gtu(bytes,#7)
+	}
+
+	{
+		if (!p1) jump .Lsmall
+		loopcount = lsr(bytes,#2)
+	}
+	p3=sp1loop0(.Loop4,loopcount)
+.Loop4:
+4080:
+4180:
+	{
+		if (p3) memw(dst++#4) = w_dbuf
+		w_dbuf = memw(src++#4)
+	}:endloop0
+4190:
+	{
+		memw(dst++#4) = w_dbuf
+		bytes -= asl(loopcount,#2)
+		jump .Lsmall
+	}
+
+.Loop_not_aligned_4:
+	{
+		p0 = bitsclr(r3,#1)
+		if (!p0.new) jump:nt .Loop_not_aligned
+		p1 = cmp.gtu(bytes,#3)
+	}
+
+	{
+		if (!p1) jump .Lsmall
+		loopcount = lsr(bytes,#1)
+	}
+	p3=sp1loop0(.Loop2,loopcount)
+.Loop2:
+2080:
+2180:
+	{
+		if (p3) memh(dst++#2) = w_dbuf
+		w_dbuf = memuh(src++#2)
+	}:endloop0
+2190:
+	{
+		memh(dst++#2) = w_dbuf
+		bytes -= asl(loopcount,#1)
+		jump .Lsmall
+	}
+
+.Loop_not_aligned: /* Works for as small as one byte */
+	p3=sp1loop0(.Loop1,bytes)
+.Loop1:
+1080:
+1180:
+	{
+		if (p3) memb(dst++#1) = w_dbuf
+		w_dbuf = memub(src++#1)
+	}:endloop0
+	/* Done */
+1190:
+	{
+		memb(dst) = w_dbuf
+		jumpr r31
+		r0 = #0
+	}
+
+.Lsmall:
+	{
+		p0 = cmp.gtu(bytes,#0)
+		if (p0.new) jump:nt .Loop_not_aligned
+	}
+.Ldone:
+	{
+		r0 = #0
+		jumpr r31
+	}
+	.falign
+.Lalign:
+1000:
+	{
+		if (p0.new) w_dbuf = memub(src)
+		p0 = tstbit(src,#0)
+		if (!p1) jump .Lsmall
+	}
+1100:
+	{
+		if (p0) memb(dst++#1) = w_dbuf
+		if (p0) bytes = add(bytes,#-1)
+		if (p0) src = add(src,#1)
+	}
+2000:
+	{
+		if (p0.new) w_dbuf = memuh(src)
+		p0 = tstbit(src,#1)
+		if (!p1) jump .Lsmall
+	}
+2100:
+	{
+		if (p0) memh(dst++#2) = w_dbuf
+		if (p0) bytes = add(bytes,#-2)
+		if (p0) src = add(src,#2)
+	}
+4000:
+	{
+		if (p0.new) w_dbuf = memw(src)
+		p0 = tstbit(src,#2)
+		if (!p1) jump .Lsmall
+	}
+4100:
+	{
+		if (p0) memw(dst++#4) = w_dbuf
+		if (p0) bytes = add(bytes,#-4)
+		if (p0) src = add(src,#4)
+		jump FUNCNAME
+	}
+	.size FUNCNAME,.-FUNCNAME
Index: linux-hexagon-kernel/arch/hexagon/mm/uaccess.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/mm/uaccess.c	2011-09-03 20:14:59.724981391 -0500
@@ -0,0 +1,59 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+/*
+ * Support for user memory access from kernel.  This will
+ * probably be inlined for performance at some point, but
+ * for ease of debug, and to a lesser degree for code size,
+ * we implement here as subroutines.
+ */
+#include <linux/types.h>
+#include <asm/uaccess.h>
+#include <asm/pgtable.h>
+
+/*
+ * For clear_user(), exploit previously defined copy_to_user function
+ * and the fact that we've got a handy zero page defined in kernel/head.S
+ *
+ * dczero here would be even faster.
+ */
+__kernel_size_t __clear_user_hexagon(void __user *dest, unsigned long count)
+{
+	long uncleared;
+
+	while (count > PAGE_SIZE) {
+		uncleared = __copy_to_user_hexagon(dest, &empty_zero_page,
+						PAGE_SIZE);
+		if (uncleared)
+			return count - (PAGE_SIZE - uncleared);
+		count -= PAGE_SIZE;
+		dest += PAGE_SIZE;
+	}
+	if (count)
+		count = __copy_to_user_hexagon(dest, &empty_zero_page, count);
+
+	return count;
+}
+
+unsigned long clear_user_hexagon(void __user *dest, unsigned long count)
+{
+	if (!access_ok(VERIFY_WRITE, dest, count))
+		return count;
+	else
+		return __clear_user_hexagon(dest, count);
+}
Index: linux-hexagon-kernel/arch/hexagon/mm/strnlen_user.S
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/mm/strnlen_user.S	2011-09-03 20:14:59.724981391 -0500
@@ -0,0 +1,140 @@
+/*
+ * User string length functions for kernel
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#define isrc	r0
+#define max	r1	/*  Do not change!  */
+
+#define end	r2
+#define tmp1	r3
+
+#define obo	r6	/*  off-by-one  */
+#define start	r7
+#define mod8	r8
+#define dbuf    r15:14
+#define dcmp	r13:12
+
+/*
+ * The vector mask version of this turned out *really* badly.
+ * The hardware loop version also turned out *really* badly.
+ * Seems straight pointer arithmetic basically wins here.
+ */
+
+#define fname __strnlen_user
+
+	.text
+	.global fname
+	.type fname, @function
+	.p2align 5  /*  why?  */
+fname:
+	{
+		mod8 = and(isrc,#7);
+		end = add(isrc,max);
+		start = isrc;
+	}
+	{
+		P0 = cmp.eq(mod8,#0);
+		mod8 = and(end,#7);
+		dcmp = #0;
+		if (P0.new) jump:t dw_loop;	/*  fire up the oven  */
+	}
+
+alignment_loop:
+fail_1:	{
+		tmp1 = memb(start++#1);
+	}
+	{
+		P0 = cmp.eq(tmp1,#0);
+		if (P0.new) jump:nt exit_found;
+		P1 = cmp.gtu(end,start);
+		mod8 = and(start,#7);
+	}
+	{
+		if (!P1) jump exit_error;  /*  hit the end  */
+		P0 = cmp.eq(mod8,#0);
+	}
+	{
+		if (!P0) jump alignment_loop;
+	}
+
+
+
+dw_loop:
+fail_2:	{
+		dbuf = memd(start);
+		obo = add(start,#1);
+	}
+	{
+		P0 = vcmpb.eq(dbuf,dcmp);
+	}
+	{
+		tmp1 = P0;
+		P0 = cmp.gtu(end,start);
+	}
+	{
+		tmp1 = ct0(tmp1);
+		mod8 = and(end,#7);
+		if (!P0) jump end_check;
+	}
+	{
+		P0 = cmp.eq(tmp1,#32);
+		if (!P0.new) jump:nt exit_found;
+		if (!P0.new) start = add(obo,tmp1);
+	}
+	{
+		start = add(start,#8);
+		jump dw_loop;
+	}	/*  might be nice to combine these jumps...   */
+
+
+end_check:
+	{
+		P0 = cmp.gt(tmp1,mod8);
+		if (P0.new) jump:nt exit_error;	/*  neverfound!  */
+		start = add(obo,tmp1);
+	}
+
+exit_found:
+	{
+		R0 = sub(start,isrc);
+		jumpr R31;
+	}
+
+exit_error:
+	{
+		R0 = add(max,#1);
+		jumpr R31;
+	}
+
+	/*  Uh, what does the "fixup" return here?  */
+	.falign
+fix_1:
+	{
+		R0 = #0;
+		jumpr R31;
+	}
+
+	.size fname,.-fname
+
+
+.section __ex_table,"a"
+.long fail_1,fix_1
+.long fail_2,fix_1
+.previous
+

--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

