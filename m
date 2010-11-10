Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab0KJH1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 02:27:44 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53729 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab0KJH1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 02:27:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=K32Fwmb2chiqRDUQVG1+4hWcn4oc4Tx0ksmgK1KjM6BNU3hRo/tsaPg3rNcLA1Jge7
         5RIeTZF4T1I+iP+/IlxxwKipd+eu5/3rkbYEqbyAx0Nti4PHLrD52I22fC01SoBQhecX
         B6cS2cWx4ZPLd/hrSzJXkn1L5M8dtwLgwnLGE=
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Wed, 10 Nov 2010 15:27:18 +0800
Message-ID: <AANLkTin3pacX9cfQ0bYH3F3fnvAYY6_DLTwh1gbOZJUj@mail.gmail.com>
Subject: [PATCH] Linux Kernel GDB tracepoint module 2010-11-10
To: linux-kernel@vger.kernel.org
Cc: Michael Snyder <msnyder@vmware.com>,
        Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        Steven <mqyoung@gmail.com>, colyli@gmail.com,
        Christoph Hellwig <hch@infradead.org>,
        "gdb@sourceware.org" <gdb@sourceware.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KGTP is Linux Kernel GDB tracepoint module.
It make Linux Kernel supply a GDB remote debug interface. Then GDB in
current machine or remote machine(see "Make GDB connect to gtp") can
debug Linux through GDB tracepoint without stop the Linux Kernel.
And even if the board doesn't have GDB on it and doesn't have
interface for remote debug. It can debug the Linux Kernel use offline
debug (See "Offline debug").
Now, it support X86-32, X86-64, MIPS and ARM.
http://www.tudou.com/programs/view/_p6VTgxmCRA/ This is a video(in
Chinese) to show how to use it.

Now, KGTP 2010-11-10 release.
You can get the package for it from
http://kgtp.googlecode.com/files/kgtp_20101110.tar.bz2
Or
svn co https://kgtp.googlecode.com/svn/tags/20101110

The change of this release is:
Fix bug that after gtp_release, value of frame is not right.
Fix c command hang the GDB.
Fix a debug build error.
Add /proc/gtpframe.
Change DECLARE_MUTEX to DEFINE_SEMAPHORE.

The new feature of this release is offline debug, it make kgtp can
debug a kernel even if a GDB didn't connect it.
For example:
In the PC that can run the GDB:
Change the "target remote XXXX" to
(gdb) target remote | perl ./getgtprsp.pl
After that, set tracepoint and start it as usual:
(gdb) trace vfs_readdir
Tracepoint 1 at 0xffffffff8114f3c0: file
/home/teawater/kernel/linux-2.6/fs/readdir.c, line 24.
(gdb) actions
Enter actions for tracepoint 1, one per line.
End with a line saying just "end".
>collect $reg
>end
(gdb) tstart
(gdb) stop
(gdb) quit
Then you can find files gtpstart and gtpstop. Copy it to the machine
that you want debug.
In the debuged machine after insmod the gtp.ko:
Start the tracepoint:
cat gtpstart > /proc/gtp
Stop the tracepoint:
cat gtpstop > /proc/gtp
Then file "/proc/gtpframe" have the trace frame. Copy it to the PC
that has GDB.
In the PC that can run the GDB:
(gdb) target tfile ./gtpframe
Tracepoint 1 at 0xffffffff8114f3dc: file
/home/teawater/kernel/linux-2.6/fs/readdir.c, line 24.
Created tracepoint 1 for target's tracepoint 1 at 0xffffffff8114f3c0.
(gdb) tfind
Found trace frame 0, tracepoint 1
#0  vfs_readdir (file=0xffff880036e8f300, filler=0xffffffff8114f240
<filldir>, buf=0xffff880001e5bf38)
    at /home/teawater/kernel/linux-2.6/fs/readdir.c:24
24      {

Please goto http://code.google.com/p/kgtp/wiki/HOWTO to get more info
about how to use KGTP.

And according to the comments of Christoph.  I make a patch for Linux
Kernel and make it looks OK with checkpatch.pl.

Signed-off-by: Hui Zhu <teawater@gmail.com>
---
 arch/arm/include/asm/gtp.h  |   13
 arch/mips/include/asm/gtp.h |   18
 arch/x86/include/asm/gtp.h  |   18
 lib/Kconfig.debug           |    8
 lib/Makefile                |    2
 lib/gtp.c                   | 4068 ++++++++++++++++++++++++++++++++++++++++++++
 scripts/getgtprsp.pl        |   76
 7 files changed, 4203 insertions(+)

--- /dev/null
+++ b/arch/arm/include/asm/gtp.h
@@ -0,0 +1,13 @@
+#ifndef _ASM_ARM_GTP_H_
+#define _ASM_ARM_GTP_H_
+
+#define ULONGEST		uint64_t
+#define LONGEST			int64_t
+#define CORE_ADDR		unsigned long
+
+#define GTP_REGS_PC(regs)	((regs)->uregs[15])
+
+#define GTP_REG_ASCII_SIZE	336
+#define GTP_REG_BIN_SIZE	168
+
+#endif
--- /dev/null
+++ b/arch/mips/include/asm/gtp.h
@@ -0,0 +1,18 @@
+#ifndef _ASM_MIPS_GTP_H_
+#define _ASM_MIPS_GTP_H_
+
+#define ULONGEST		uint64_t
+#define LONGEST			int64_t
+#define CORE_ADDR		unsigned long
+
+#define GTP_REGS_PC(regs)	((regs)->cp0_epc)
+
+#ifdef CONFIG_32BIT
+#define GTP_REG_ASCII_SIZE	304
+#define GTP_REG_BIN_SIZE	152
+#else
+#define GTP_REG_ASCII_SIZE	608
+#define GTP_REG_BIN_SIZE	304
+#endif
+
+#endif
--- /dev/null
+++ b/arch/x86/include/asm/gtp.h
@@ -0,0 +1,18 @@
+#ifndef _ASM_X86_GTP_H_
+#define _ASM_X86_GTP_H_
+
+#define ULONGEST		uint64_t
+#define LONGEST			int64_t
+#define CORE_ADDR		unsigned long
+
+#define GTP_REGS_PC(regs)	((regs)->ip)
+
+#ifdef CONFIG_X86_32
+#define GTP_REG_ASCII_SIZE	128
+#define GTP_REG_BIN_SIZE	64
+#else
+#define GTP_REG_ASCII_SIZE	296
+#define GTP_REG_BIN_SIZE	148
+#endif
+
+#endif
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1230,6 +1230,14 @@ config ASYNC_RAID6_TEST

 	  If unsure, say N.

+config GTP
+	tristate "GDB tracepoint support"
+	depends on X86 || ARM || MIPS
+	depends on KPROBES
+	depends on PROC_FS
+	---help---
+	  Supply GDB tracepoint interface in /proc/gtp.
+
 source "samples/Kconfig"

 source "lib/Kconfig.kgdb"
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -106,6 +106,8 @@ obj-$(CONFIG_GENERIC_ATOMIC64) += atomic

 obj-$(CONFIG_ATOMIC64_SELFTEST) += atomic64_test.o

+obj-$(CONFIG_GTP) += gtp.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h

--- /dev/null
+++ b/lib/gtp.c
@@ -0,0 +1,4068 @@
+/*
+ * Kernel GDB tracepoint module.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright(C) Hui Zhu (teawater@gmail.com), 2010
+ */
+
+#include <linux/version.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/proc_fs.h>
+#include <linux/uaccess.h>
+#include <linux/vmalloc.h>
+#include <linux/poll.h>
+#include <linux/kprobes.h>
+#include <asm/gtp.h>
+
+#ifdef GTPDEBUG
+#define GTP_DEBUG		KERN_WARNING
+#endif
+
+#define GTP_RW_MAX		16384
+
+#define GTP_FRAME_SIZE		5242880
+#define GTP_FRAME_HEAD_SIZE	(1 + sizeof(char *) + sizeof(ULONGEST))
+#define GTP_FRAME_REG_SIZE	(1 + sizeof(char *) + sizeof(struct pt_regs))
+#define GTP_FRAME_MEM_SIZE	(1 + sizeof(char *) \
+				 + sizeof(struct gtp_frame_mem))
+#define GTP_FRAME_VAR_SIZE	(1 + sizeof(char *) \
+				 + sizeof(struct gtp_frame_var))
+
+#define TOHEX(h)		((h) > 9 ? (h) + 'a' - 10 : (h) + '0')
+
+struct action_agent_exp {
+	unsigned int	size;
+	uint8_t		*buf;
+	int		need_var_lock;
+};
+
+struct action_m {
+	int		regnum;
+	CORE_ADDR	offset;
+	size_t		size;
+};
+
+struct action {
+	struct action	*next;
+	char		type;
+	char		*src;
+	union {
+		ULONGEST		reg_mask;
+		struct action_agent_exp	exp;
+		struct action_m		m;
+	} u;
+};
+
+struct gtpsrc {
+	struct gtpsrc	*next;
+	char		*src;
+};
+
+enum gtp_stop_type {
+	gtp_stop_normal = 0,
+	gtp_stop_frame_full,
+	gtp_stop_efault,
+	gtp_stop_access_wrong_reg,
+	gtp_stop_agent_expr_code_error,
+	gtp_stop_agent_expr_stack_overflow,
+};
+
+struct gtp_entry {
+	struct gtp_entry	*next;
+	int			disable;
+	ULONGEST		num;
+	ULONGEST		addr;
+	ULONGEST		step;
+	ULONGEST		pass;
+	int			nopass;
+	atomic_t		current_pass;
+	int			kpreg;
+	struct kprobe		kp;
+	struct work_struct	work;
+	enum gtp_stop_type	reason;
+	struct action		*cond;
+	struct action		*action_list;
+	struct gtpsrc		*src;
+};
+
+struct gtp_var {
+	struct gtp_var	*next;
+	unsigned int	num;
+	uint64_t	val;
+	char		*src;
+};
+
+struct gtp_frame_mem {
+	CORE_ADDR	addr;
+	size_t		size;
+};
+
+struct gtp_frame_var {
+	unsigned int	num;
+	uint64_t	val;
+};
+
+struct gtpro_entry {
+	struct gtpro_entry	*next;
+	CORE_ADDR		start;
+	CORE_ADDR		end;
+};
+
+static struct gtp_entry		*gtp_list;
+static struct gtp_entry		*current_gtp;
+static struct action		*current_gtp_action;
+static struct gtpsrc		*current_gtp_src;
+
+static struct workqueue_struct	*gtp_wq;
+
+static char			gtp_read_ack;
+static char			*gtp_rw_buf;
+static char			*gtp_rw_bufp;
+static size_t			gtp_rw_size;
+
+static int			gtp_start;
+
+static int			gtp_disconnected_tracing;
+static int			gtp_circular;
+
+static DEFINE_SPINLOCK(gtp_var_lock);
+static struct gtp_var		*gtp_var_list;
+static unsigned int		gtp_var_head;
+static unsigned int		gtp_var_tail;
+static struct gtp_var		**gtp_var_array;
+static struct gtp_var		*current_gtp_var;
+#define GTP_VAR_CURRENT_TASK_ID	1
+static struct gtp_var		gtp_var_current_task = {
+	.next	= NULL,
+	.num	= GTP_VAR_CURRENT_TASK_ID,
+	.src	= "0:1:63757272656e745f7461736b",
+};
+
+static DEFINE_SPINLOCK(gtp_frame_lock);
+static char			*gtp_frame;
+static char			*gtp_frame_r_start;
+static char			*gtp_frame_w_start;
+static char			*gtp_frame_end;
+static int			gtp_frame_is_circular;
+static char			*gtp_frame_current;
+static int			gtp_frame_current_num;
+static atomic_t			gtp_frame_create;
+static char			*gtp_frame_file;
+static size_t			gtp_frame_file_size;
+
+static struct gtpro_entry	*gtpro_list;
+
+#ifdef CONFIG_X86
+static ULONGEST
+gtp_action_reg_read(struct pt_regs *regs, struct gtp_entry *tpe, int num)
+{
+	ULONGEST	ret;
+
+	switch (num) {
+#ifdef CONFIG_X86_32
+	case 0:
+		ret = regs->ax;
+		break;
+	case 1:
+		ret = regs->cx;
+		break;
+	case 2:
+		ret = regs->dx;
+		break;
+	case 3:
+		ret = regs->bx;
+		break;
+	case 4:
+		ret = (ULONGEST)(CORE_ADDR)&regs->sp;
+		break;
+	case 5:
+		ret = regs->bp;
+		break;
+	case 6:
+		ret = regs->si;
+		break;
+	case 7:
+		ret = regs->di;
+		break;
+	case 8:
+		ret = regs->ip - 1;
+		break;
+	case 9:
+		ret = regs->flags;
+		break;
+	case 10:
+		ret = regs->cs;
+		break;
+	case 11:
+		ret = regs->ss;
+		break;
+	case 12:
+		ret = regs->ds;
+		break;
+	case 13:
+		ret = regs->es;
+		break;
+	case 14:
+		ret = regs->fs;
+		break;
+	case 15:
+		ret = regs->gs;
+		break;
+#else
+	case 0:
+		ret = regs->ax;
+		break;
+	case 1:
+		ret = regs->bx;
+		break;
+	case 2:
+		ret = regs->cx;
+		break;
+	case 3:
+		ret = regs->dx;
+		break;
+	case 4:
+		ret = regs->si;
+		break;
+	case 5:
+		ret = regs->di;
+		break;
+	case 6:
+		ret = regs->bp;
+		break;
+	case 7:
+		ret = regs->sp;
+		break;
+	case 8:
+		ret = regs->r8;
+		break;
+	case 9:
+		ret = regs->r9;
+		break;
+	case 10:
+		ret = regs->r10;
+		break;
+	case 11:
+		ret = regs->r11;
+		break;
+	case 12:
+		ret = regs->r12;
+		break;
+	case 13:
+		ret = regs->r13;
+		break;
+	case 14:
+		ret = regs->r14;
+		break;
+	case 15:
+		ret = regs->r15;
+		break;
+	case 16:
+		ret = regs->ip - 1;
+		break;
+	case 17:
+		ret = regs->flags;
+		break;
+	case 18:
+		ret = regs->cs;
+		break;
+	case 19:
+		ret = regs->ss;
+		break;
+#endif
+	default:
+		ret = 0;
+		tpe->reason = gtp_stop_access_wrong_reg;
+		break;
+	}
+
+	return ret;
+}
+
+static void
+gtp_regs2ascii(struct pt_regs *regs, char *buf)
+{
+#ifdef CONFIG_X86_32
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_regs2ascii: ax = 0x%x\n",
+		(unsigned int) regs->ax);
+	printk(GTP_DEBUG "gtp_regs2ascii: cx = 0x%x\n",
+		(unsigned int) regs->cx);
+	printk(GTP_DEBUG "gtp_regs2ascii: dx = 0x%x\n",
+		(unsigned int) regs->dx);
+	printk(GTP_DEBUG "gtp_regs2ascii: bx = 0x%x\n",
+		(unsigned int) regs->bx);
+	printk(GTP_DEBUG "gtp_regs2ascii: sp = 0x%x\n",
+		(unsigned int) regs->sp);
+	printk(GTP_DEBUG "gtp_regs2ascii: bp = 0x%x\n",
+		(unsigned int) regs->bp);
+	printk(GTP_DEBUG "gtp_regs2ascii: si = 0x%x\n",
+		(unsigned int) regs->si);
+	printk(GTP_DEBUG "gtp_regs2ascii: di = 0x%x\n",
+		(unsigned int) regs->di);
+	printk(GTP_DEBUG "gtp_regs2ascii: ip = 0x%x\n",
+		(unsigned int) regs->ip);
+	printk(GTP_DEBUG "gtp_regs2ascii: flags = 0x%x\n",
+		(unsigned int) regs->flags);
+	printk(GTP_DEBUG "gtp_regs2ascii: cs = 0x%x\n",
+		(unsigned int) regs->cs);
+	printk(GTP_DEBUG "gtp_regs2ascii: ss = 0x%x\n",
+		(unsigned int) regs->ss);
+	printk(GTP_DEBUG "gtp_regs2ascii: ds = 0x%x\n",
+		(unsigned int) regs->ds);
+	printk(GTP_DEBUG "gtp_regs2ascii: es = 0x%x\n",
+		(unsigned int) regs->es);
+	printk(GTP_DEBUG "gtp_regs2ascii: fs = 0x%x\n",
+		(unsigned int) regs->fs);
+	printk(GTP_DEBUG "gtp_regs2ascii: gs = 0x%x\n",
+		(unsigned int) regs->gs);
+#endif
+	sprintf(buf, "%08x", (unsigned int) swab32(regs->ax));
+	buf += 8;
+	sprintf(buf, "%08x", (unsigned int) swab32(regs->cx));
+	buf += 8;
+	sprintf(buf, "%08x", (unsigned int) swab32(regs->dx));
+	buf += 8;
+	sprintf(buf, "%08x", (unsigned int) swab32(regs->bx));
+	buf += 8;
+	sprintf(buf, "%08x", (unsigned int) swab32(regs->sp));
+	buf += 8;
+	sprintf(buf, "%08x", (unsigned int) swab32(regs->bp));
+	buf += 8;
+	sprintf(buf, "%08x", (unsigned int) swab32(regs->si));
+	buf += 8;
+	sprintf(buf, "%08x", (unsigned int) swab32(regs->di));
+	buf += 8;
+	sprintf(buf, "%08x", (unsigned int) swab32(regs->ip));
+	buf += 8;
+	sprintf(buf, "%08x", (unsigned int) swab32(regs->flags));
+	buf += 8;
+	sprintf(buf, "%08x", (unsigned int) swab32(regs->cs));
+	buf += 8;
+	sprintf(buf, "%08x", (unsigned int) swab32(regs->ss));
+	buf += 8;
+	sprintf(buf, "%08x", (unsigned int) swab32(regs->ds));
+	buf += 8;
+	sprintf(buf, "%08x", (unsigned int) swab32(regs->es));
+	buf += 8;
+	sprintf(buf, "%08x", (unsigned int) swab32(regs->fs));
+	buf += 8;
+	sprintf(buf, "%08x", (unsigned int) swab32(regs->gs));
+	buf += 8;
+#else
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_regs2ascii: ax = 0x%lx\n", regs->ax);
+	printk(GTP_DEBUG "gtp_regs2ascii: bx = 0x%lx\n", regs->bx);
+	printk(GTP_DEBUG "gtp_regs2ascii: cx = 0x%lx\n", regs->cx);
+	printk(GTP_DEBUG "gtp_regs2ascii: dx = 0x%lx\n", regs->dx);
+	printk(GTP_DEBUG "gtp_regs2ascii: si = 0x%lx\n", regs->si);
+	printk(GTP_DEBUG "gtp_regs2ascii: di = 0x%lx\n", regs->di);
+	printk(GTP_DEBUG "gtp_regs2ascii: bp = 0x%lx\n", regs->bp);
+	printk(GTP_DEBUG "gtp_regs2ascii: sp = 0x%lx\n", regs->sp);
+	printk(GTP_DEBUG "gtp_regs2ascii: r8 = 0x%lx\n", regs->r8);
+	printk(GTP_DEBUG "gtp_regs2ascii: r9 = 0x%lx\n", regs->r9);
+	printk(GTP_DEBUG "gtp_regs2ascii: r10 = 0x%lx\n", regs->r10);
+	printk(GTP_DEBUG "gtp_regs2ascii: r11 = 0x%lx\n", regs->r11);
+	printk(GTP_DEBUG "gtp_regs2ascii: r12 = 0x%lx\n", regs->r12);
+	printk(GTP_DEBUG "gtp_regs2ascii: r13 = 0x%lx\n", regs->r13);
+	printk(GTP_DEBUG "gtp_regs2ascii: r14 = 0x%lx\n", regs->r14);
+	printk(GTP_DEBUG "gtp_regs2ascii: r15 = 0x%lx\n", regs->r15);
+	printk(GTP_DEBUG "gtp_regs2ascii: ip = 0x%lx\n", regs->ip);
+	printk(GTP_DEBUG "gtp_regs2ascii: flags = 0x%lx\n", regs->flags);
+	printk(GTP_DEBUG "gtp_regs2ascii: cs = 0x%lx\n", regs->cs);
+	printk(GTP_DEBUG "gtp_regs2ascii: ss = 0x%lx\n", regs->ss);
+#endif
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->ax));
+	buf += 16;
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->bx));
+	buf += 16;
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->cx));
+	buf += 16;
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->dx));
+	buf += 16;
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->si));
+	buf += 16;
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->di));
+	buf += 16;
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->bp));
+	buf += 16;
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->sp));
+	buf += 16;
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->r8));
+	buf += 16;
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->r9));
+	buf += 16;
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->r10));
+	buf += 16;
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->r11));
+	buf += 16;
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->r12));
+	buf += 16;
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->r13));
+	buf += 16;
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->r14));
+	buf += 16;
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->r15));
+	buf += 16;
+	sprintf(buf, "%016lx", (unsigned long) swab64(regs->ip));
+	buf += 16;
+	sprintf(buf, "%08x",
+		(unsigned int) swab32((unsigned int)regs->flags));
+	buf += 8;
+	sprintf(buf, "%08x",
+		(unsigned int) swab32((unsigned int)regs->cs));
+	buf += 8;
+	sprintf(buf, "%08x",
+		(unsigned int) swab32((unsigned int)regs->ss));
+	buf += 8;
+#endif
+}
+
+static void
+gtp_regs2bin(struct pt_regs *regs, char *buf)
+{
+#ifdef CONFIG_X86_32
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_regs2ascii: ax = 0x%x\n",
+		(unsigned int) regs->ax);
+	printk(GTP_DEBUG "gtp_regs2ascii: cx = 0x%x\n",
+		(unsigned int) regs->cx);
+	printk(GTP_DEBUG "gtp_regs2ascii: dx = 0x%x\n",
+		(unsigned int) regs->dx);
+	printk(GTP_DEBUG "gtp_regs2ascii: bx = 0x%x\n",
+		(unsigned int) regs->bx);
+	printk(GTP_DEBUG "gtp_regs2ascii: sp = 0x%x\n",
+		(unsigned int) regs->sp);
+	printk(GTP_DEBUG "gtp_regs2ascii: bp = 0x%x\n",
+		(unsigned int) regs->bp);
+	printk(GTP_DEBUG "gtp_regs2ascii: si = 0x%x\n",
+		(unsigned int) regs->si);
+	printk(GTP_DEBUG "gtp_regs2ascii: di = 0x%x\n",
+		(unsigned int) regs->di);
+	printk(GTP_DEBUG "gtp_regs2ascii: ip = 0x%x\n",
+		(unsigned int) regs->ip);
+	printk(GTP_DEBUG "gtp_regs2ascii: flags = 0x%x\n",
+		(unsigned int) regs->flags);
+	printk(GTP_DEBUG "gtp_regs2ascii: cs = 0x%x\n",
+		(unsigned int) regs->cs);
+	printk(GTP_DEBUG "gtp_regs2ascii: ss = 0x%x\n",
+		(unsigned int) regs->ss);
+	printk(GTP_DEBUG "gtp_regs2ascii: ds = 0x%x\n",
+		(unsigned int) regs->ds);
+	printk(GTP_DEBUG "gtp_regs2ascii: es = 0x%x\n",
+		(unsigned int) regs->es);
+	printk(GTP_DEBUG "gtp_regs2ascii: fs = 0x%x\n",
+		(unsigned int) regs->fs);
+	printk(GTP_DEBUG "gtp_regs2ascii: gs = 0x%x\n",
+		(unsigned int) regs->gs);
+#endif
+	memcpy(buf, &regs->ax, 4);
+	buf += 4;
+	memcpy(buf, &regs->cx, 4);
+	buf += 4;
+	memcpy(buf, &regs->dx, 4);
+	buf += 4;
+	memcpy(buf, &regs->bx, 4);
+	buf += 4;
+	memcpy(buf, &regs->sp, 4);
+	buf += 4;
+	memcpy(buf, &regs->bp, 4);
+	buf += 4;
+	memcpy(buf, &regs->si, 4);
+	buf += 4;
+	memcpy(buf, &regs->di, 4);
+	buf += 4;
+	memcpy(buf, &regs->ip, 4);
+	buf += 4;
+	memcpy(buf, &regs->flags, 4);
+	buf += 4;
+	memcpy(buf, &regs->cs, 4);
+	buf += 4;
+	memcpy(buf, &regs->ss, 4);
+	buf += 4;
+	memcpy(buf, &regs->ds, 4);
+	buf += 4;
+	memcpy(buf, &regs->es, 4);
+	buf += 4;
+	memcpy(buf, &regs->fs, 4);
+	buf += 4;
+	memcpy(buf, &regs->gs, 4);
+	buf += 4;
+#else
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_regs2ascii: ax = 0x%lx\n", regs->ax);
+	printk(GTP_DEBUG "gtp_regs2ascii: bx = 0x%lx\n", regs->bx);
+	printk(GTP_DEBUG "gtp_regs2ascii: cx = 0x%lx\n", regs->cx);
+	printk(GTP_DEBUG "gtp_regs2ascii: dx = 0x%lx\n", regs->dx);
+	printk(GTP_DEBUG "gtp_regs2ascii: si = 0x%lx\n", regs->si);
+	printk(GTP_DEBUG "gtp_regs2ascii: di = 0x%lx\n", regs->di);
+	printk(GTP_DEBUG "gtp_regs2ascii: bp = 0x%lx\n", regs->bp);
+	printk(GTP_DEBUG "gtp_regs2ascii: sp = 0x%lx\n", regs->sp);
+	printk(GTP_DEBUG "gtp_regs2ascii: r8 = 0x%lx\n", regs->r8);
+	printk(GTP_DEBUG "gtp_regs2ascii: r9 = 0x%lx\n", regs->r9);
+	printk(GTP_DEBUG "gtp_regs2ascii: r10 = 0x%lx\n", regs->r10);
+	printk(GTP_DEBUG "gtp_regs2ascii: r11 = 0x%lx\n", regs->r11);
+	printk(GTP_DEBUG "gtp_regs2ascii: r12 = 0x%lx\n", regs->r12);
+	printk(GTP_DEBUG "gtp_regs2ascii: r13 = 0x%lx\n", regs->r13);
+	printk(GTP_DEBUG "gtp_regs2ascii: r14 = 0x%lx\n", regs->r14);
+	printk(GTP_DEBUG "gtp_regs2ascii: r15 = 0x%lx\n", regs->r15);
+	printk(GTP_DEBUG "gtp_regs2ascii: ip = 0x%lx\n", regs->ip);
+	printk(GTP_DEBUG "gtp_regs2ascii: flags = 0x%lx\n", regs->flags);
+	printk(GTP_DEBUG "gtp_regs2ascii: cs = 0x%lx\n", regs->cs);
+	printk(GTP_DEBUG "gtp_regs2ascii: ss = 0x%lx\n", regs->ss);
+#endif
+	memcpy(buf, &regs->ax, 8);
+	buf += 8;
+	memcpy(buf, &regs->bx, 8);
+	buf += 8;
+	memcpy(buf, &regs->cx, 8);
+	buf += 8;
+	memcpy(buf, &regs->dx, 8);
+	buf += 8;
+	memcpy(buf, &regs->si, 8);
+	buf += 8;
+	memcpy(buf, &regs->di, 8);
+	buf += 8;
+	memcpy(buf, &regs->bp, 8);
+	buf += 8;
+	memcpy(buf, &regs->sp, 8);
+	buf += 8;
+	memcpy(buf, &regs->r8, 8);
+	buf += 8;
+	memcpy(buf, &regs->r9, 8);
+	buf += 8;
+	memcpy(buf, &regs->r10, 8);
+	buf += 8;
+	memcpy(buf, &regs->r11, 8);
+	buf += 8;
+	memcpy(buf, &regs->r12, 8);
+	buf += 8;
+	memcpy(buf, &regs->r13, 8);
+	buf += 8;
+	memcpy(buf, &regs->r14, 8);
+	buf += 8;
+	memcpy(buf, &regs->r15, 8);
+	buf += 8;
+	memcpy(buf, &regs->ip, 8);
+	buf += 8;
+	memcpy(buf, &regs->flags, 4);
+	buf += 4;
+	memcpy(buf, &regs->cs, 4);
+	buf += 4;
+	memcpy(buf, &regs->ss, 4);
+	buf += 4;
+#endif
+}
+#endif
+
+#ifdef CONFIG_MIPS
+static ULONGEST
+gtp_action_reg_read(struct pt_regs *regs, struct gtp_entry *tpe, int num)
+{
+	ULONGEST	ret;
+
+	if (num > 90) {
+		/* GDB convert the reg number to a GDB
+		   [1 * gdbarch_num_regs .. 2 * gdbarch_num_regs) REGNUM
+		   in function mips_dwarf_dwarf2_ecoff_reg_to_regnum.  */
+		num -= 90;
+	}
+
+	if (num >= 0 && num < 31) {
+		ret = regs->regs[num];
+	} else {
+		switch (num) {
+		case 32:
+			ret = regs->cp0_status;
+			break;
+		case 33:
+			ret = regs->lo;
+			break;
+		case 34:
+			ret = regs->hi;
+			break;
+		case 35:
+			ret = regs->cp0_badvaddr;
+			break;
+		case 36:
+			ret = regs->cp0_cause;
+			break;
+		case 37:
+			ret = regs->cp0_epc;
+			break;
+		default:
+			ret = 0;
+			tpe->reason = gtp_stop_access_wrong_reg;
+			break;
+		}
+	}
+
+	return ret;
+};
+
+static void
+gtp_regs2ascii(struct pt_regs *regs, char *buf)
+{
+#ifdef GTP_DEBUG
+	{
+		int	i;
+
+		for (i = 0; i < 32; i++)
+			printk(GTP_DEBUG "gtp_gdbrsp_g: r%d = 0x%lx\n", i,
+			       regs->regs[i]);
+	}
+	printk(GTP_DEBUG "gtp_gdbrsp_g: status = 0x%lx\n",
+	       regs->cp0_status);
+	printk(GTP_DEBUG "gtp_gdbrsp_g: lo = 0x%lx\n", regs->lo);
+	printk(GTP_DEBUG "gtp_gdbrsp_g: hi = 0x%lx\n", regs->hi);
+	printk(GTP_DEBUG "gtp_gdbrsp_g: badvaddr = 0x%lx\n",
+	       regs->cp0_badvaddr);
+	printk(GTP_DEBUG "gtp_gdbrsp_g: cause = 0x%lx\n", regs->cp0_cause);
+	printk(GTP_DEBUG "gtp_gdbrsp_g: pc = 0x%lx\n", regs->cp0_epc);
+#endif
+
+#ifdef CONFIG_32BIT
+#define OUTFORMAT	"%08lx"
+#define REGSIZE		8
+#ifdef __LITTLE_ENDIAN
+#define SWAB(a)		swab32(a)
+#else
+#define SWAB(a)		(a)
+#endif
+#else
+#define OUTFORMAT	"%016lx"
+#define REGSIZE		16
+#ifdef __LITTLE_ENDIAN
+#define SWAB(a)		swab64(a)
+#else
+#define SWAB(a)		(a)
+#endif
+#endif
+	{
+		int	i;
+
+		for (i = 0; i < 32; i++) {
+			sprintf(buf, OUTFORMAT,
+				 (unsigned long) SWAB(regs->regs[i]));
+			buf += REGSIZE;
+		}
+	}
+
+	sprintf(buf, OUTFORMAT,
+		 (unsigned long) SWAB(regs->cp0_status));
+	buf += REGSIZE;
+	sprintf(buf, OUTFORMAT,
+		 (unsigned long) SWAB(regs->lo));
+	buf += REGSIZE;
+	sprintf(buf, OUTFORMAT,
+		 (unsigned long) SWAB(regs->hi));
+	buf += REGSIZE;
+	sprintf(buf, OUTFORMAT,
+		 (unsigned long) SWAB(regs->cp0_badvaddr));
+	buf += REGSIZE;
+	sprintf(buf, OUTFORMAT,
+		 (unsigned long) SWAB(regs->cp0_cause));
+	buf += REGSIZE;
+	sprintf(buf, OUTFORMAT,
+		 (unsigned long) SWAB(regs->cp0_epc));
+	buf += REGSIZE;
+#undef OUTFORMAT
+#undef REGSIZE
+#undef SWAB
+}
+
+static void
+gtp_regs2bin(struct pt_regs *regs, char *buf)
+{
+#ifdef GTP_DEBUG
+	{
+		int	i;
+
+		for (i = 0; i < 32; i++)
+			printk(GTP_DEBUG "gtp_gdbrsp_g: r%d = 0x%lx\n", i,
+			       regs->regs[i]);
+	}
+	printk(GTP_DEBUG "gtp_gdbrsp_g: status = 0x%lx\n",
+	       regs->cp0_status);
+	printk(GTP_DEBUG "gtp_gdbrsp_g: lo = 0x%lx\n", regs->lo);
+	printk(GTP_DEBUG "gtp_gdbrsp_g: hi = 0x%lx\n", regs->hi);
+	printk(GTP_DEBUG "gtp_gdbrsp_g: badvaddr = 0x%lx\n",
+	       regs->cp0_badvaddr);
+	printk(GTP_DEBUG "gtp_gdbrsp_g: cause = 0x%lx\n", regs->cp0_cause);
+	printk(GTP_DEBUG "gtp_gdbrsp_g: pc = 0x%lx\n", regs->cp0_epc);
+#endif
+
+#ifdef CONFIG_32BIT
+#define REGSIZE		4
+#else
+#define REGSIZE		8
+#endif
+	{
+		int	i;
+
+		for (i = 0; i < 32; i++) {
+			memcpy(buf, &regs->regs[i], REGSIZE);
+			buf += REGSIZE;
+		}
+	}
+	memcpy(buf, &regs->cp0_status, REGSIZE);
+	buf += REGSIZE;
+	memcpy(buf, &regs->lo, REGSIZE);
+	buf += REGSIZE;
+	memcpy(buf, &regs->hi, REGSIZE);
+	buf += REGSIZE;
+	memcpy(buf, &regs->cp0_badvaddr, REGSIZE);
+	buf += REGSIZE;
+	memcpy(buf, &regs->cp0_cause, REGSIZE);
+	buf += REGSIZE;
+	memcpy(buf, &regs->cp0_epc, REGSIZE);
+	buf += REGSIZE;
+#undef REGSIZE
+}
+#endif
+
+#ifdef CONFIG_ARM
+static ULONGEST
+gtp_action_reg_read(struct pt_regs *regs, struct gtp_entry *tpe, int num)
+{
+	if (num >= 0 && num < 16)
+		return regs->uregs[num];
+	else if (num == 25)
+		return regs->uregs[16];
+
+	tpe->reason = gtp_stop_access_wrong_reg;
+	return 0;
+}
+
+static void
+gtp_regs2ascii(struct pt_regs *regs, char *buf)
+{
+#ifdef __LITTLE_ENDIAN
+#define SWAB(a)		swab32(a)
+#else
+#define SWAB(a)		(a)
+#endif
+	int	i;
+
+	for (i = 0; i < 16; i++) {
+#ifdef GTP_DEBUG
+		printk(GTP_DEBUG "gtp_gdbrsp_g: r%d = 0x%lx\n",
+		       i, regs->uregs[i]);
+#endif
+		sprintf(buf, "%08lx", (unsigned long) SWAB(regs->uregs[i]));
+		buf += 8;
+	}
+
+	/* f0-f7 fps */
+	memset(buf, '0', 200);
+	buf += 200;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_gdbrsp_g: cpsr = 0x%lx\n", regs->uregs[16]);
+#endif
+	sprintf(buf, "%08lx",
+		 (unsigned long) SWAB(regs->uregs[16]));
+	buf += 8;
+#undef SWAB
+}
+
+static void
+gtp_regs2bin(struct pt_regs *regs, char *buf)
+{
+	int	i;
+
+	for (i = 0; i < 16; i++) {
+#ifdef GTP_DEBUG
+		printk(GTP_DEBUG "gtp_gdbrsp_g: r%d = 0x%lx\n",
+		       i, regs->uregs[i]);
+#endif
+		memcpy(buf, &regs->uregs[i], 4);
+		buf += 4;
+	}
+
+	/* f0-f7 fps */
+	memset(buf, '\0', 100);
+	buf += 100;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_gdbrsp_g: cpsr = 0x%lx\n", regs->uregs[16]);
+#endif
+	memcpy(buf, &regs->uregs[16], 4);
+	buf += 4;
+}
+#endif
+
+static char *
+gtp_frame_next(char *frame)
+{
+	switch (frame[0]) {
+	case 'h':
+		frame += GTP_FRAME_HEAD_SIZE;
+		break;
+	case 'r':
+		frame += GTP_FRAME_REG_SIZE;
+		break;
+	case 'm': {
+			struct gtp_frame_mem	*gfm;
+
+			gfm = (struct gtp_frame_mem *)
+			      (frame + 1 + sizeof(char *));
+			frame += GTP_FRAME_MEM_SIZE;
+			frame += gfm->size;
+		}
+		break;
+	case 'v':
+		frame += GTP_FRAME_VAR_SIZE;
+		break;
+	case 'z':
+		frame = gtp_frame;
+		break;
+	default:
+		return NULL;
+		break;
+	}
+
+	return frame;
+}
+
+static char *
+gtp_frame_alloc(size_t size)
+{
+	unsigned long	flags;
+	char		*ret = NULL;
+
+	if (size > GTP_FRAME_SIZE)
+		return NULL;
+
+	spin_lock_irqsave(&gtp_frame_lock, flags);
+
+	if (gtp_frame_w_start + size > gtp_frame_end) {
+		if (gtp_circular) {
+			gtp_frame_is_circular = 1;
+			if (gtp_frame_w_start != gtp_frame_end)
+				gtp_frame_w_start[0] = 'z';
+			gtp_frame_w_start = gtp_frame;
+			gtp_frame_r_start = gtp_frame;
+		} else
+			goto out;
+	}
+
+	if (gtp_frame_is_circular) {
+		while (gtp_frame_w_start <= gtp_frame_r_start
+		       && gtp_frame_w_start + size > gtp_frame_r_start) {
+			char *tmp = gtp_frame_next(gtp_frame_r_start);
+			if (tmp == NULL)
+				goto out;
+			gtp_frame_r_start = tmp;
+		}
+	}
+
+	ret = gtp_frame_w_start;
+	gtp_frame_w_start += size;
+
+out:
+	spin_unlock_irqrestore(&gtp_frame_lock, flags);
+	return ret;
+}
+
+static char * *
+gtp_action_head(struct gtp_entry *tpe)
+{
+	char		*tmp;
+	char		**nextp;
+	ULONGEST	*trace_nump;
+
+	/* Get the head.  */
+	tmp = gtp_frame_alloc(GTP_FRAME_HEAD_SIZE);
+	if (!tmp) {
+		tpe->reason = gtp_stop_frame_full;
+		return NULL;
+	}
+
+	tmp[0] = 'h';
+	tmp++;
+
+	nextp = (char **)tmp;
+	*nextp = NULL;
+	tmp += sizeof(char *);
+
+	trace_nump = (ULONGEST *)tmp;
+	*trace_nump = tpe->num;
+
+	atomic_inc(&gtp_frame_create);
+
+	return nextp;
+}
+
+struct gtp_trace_s {
+	struct gtp_entry	*tpe;
+	struct pt_regs		*regs;
+	char			**next;
+};
+
+static int
+gtp_action_memory_read(struct gtp_trace_s *gts, int reg, CORE_ADDR addr,
+		       size_t size)
+{
+	char			*tmp;
+	struct gtp_frame_mem	*fm;
+
+	if (reg >= 0)
+		addr += (CORE_ADDR) gtp_action_reg_read(gts->regs,
+							gts->tpe, reg);
+	if (gts->tpe->reason != gtp_stop_normal)
+		return -1;
+
+	if (gts->next == NULL) {
+		gts->next = gtp_action_head(gts->tpe);
+		if (!gts->next)
+			return -1;
+	}
+
+	tmp = gtp_frame_alloc(GTP_FRAME_MEM_SIZE + size);
+	if (!tmp) {
+		gts->tpe->reason = gtp_stop_frame_full;
+		return -1;
+	}
+	*gts->next = tmp;
+
+	tmp[0] = 'm';
+	tmp++;
+
+	gts->next = (char **)tmp;
+	*gts->next = NULL;
+	tmp += sizeof(char *);
+
+	fm = (struct gtp_frame_mem *)tmp;
+	fm->addr = addr;
+	fm->size = size;
+	tmp += sizeof(struct gtp_frame_mem);
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_action_memory_read: id:%d %p %u\n",
+	       (int)gts->tpe->num, (void *)addr, (unsigned int)size);
+#endif
+
+	if (probe_kernel_read(tmp, (void *)addr, size)) {
+		gts->tpe->reason = gtp_stop_efault;
+		memset(tmp, 0, size);
+#ifdef GTP_DEBUG
+		printk(GTP_DEBUG "gtp_action_memory_read: id:%d read %p %u "
+				    "get error.\n", (int)gts->tpe->num,
+		       (void *)addr, (unsigned int)size);
+#endif
+		return -1;
+	}
+
+	return 0;
+}
+
+static int
+gtp_action_r(struct gtp_trace_s *gts, struct action *ae)
+{
+	struct pt_regs		*regs;
+	char			*tmp;
+
+	if (gts->next == NULL) {
+		gts->next = gtp_action_head(gts->tpe);
+		if (!gts->next)
+			return -1;
+	}
+
+	tmp = gtp_frame_alloc(GTP_FRAME_REG_SIZE);
+	if (!tmp) {
+		gts->tpe->reason = gtp_stop_frame_full;
+		return -1;
+	}
+	*gts->next = tmp;
+
+	tmp[0] = 'r';
+	tmp++;
+
+	gts->next = (char **)tmp;
+	*gts->next = NULL;
+	tmp += sizeof(char *);
+
+	regs = (struct pt_regs *)tmp;
+
+	memcpy(regs, gts->regs, sizeof(struct pt_regs));
+#ifdef CONFIG_X86_32
+	regs->sp = (unsigned long)&regs->sp;
+#endif	/* CONFIG_X86_32 */
+#ifdef CONFIG_X86
+	regs->ip -= 1;
+#endif	/* CONFIG_X86 */
+
+	return 0;
+}
+
+static struct gtp_var *
+gtp_gtp_var_array_find(unsigned int num)
+{
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_gtp_var_array_find: num:%u %u %u\n",
+	       gtp_var_head, gtp_var_tail, num);
+#endif
+
+	if (num < gtp_var_head || num > gtp_var_tail)
+		return NULL;
+
+	return gtp_var_array[num - gtp_var_head];
+}
+
+static int
+gtp_collect_var(struct gtp_trace_s *gts, struct gtp_var *tve)
+{
+	struct gtp_frame_var	*fvar;
+	char			*tmp;
+
+	if (gts->next == NULL) {
+		gts->next = gtp_action_head(gts->tpe);
+		if (!gts->next)
+			return -1;
+	}
+
+	tmp = gtp_frame_alloc(GTP_FRAME_VAR_SIZE);
+	if (!tmp) {
+		gts->tpe->reason = gtp_stop_frame_full;
+		return -1;
+	}
+	*gts->next = tmp;
+
+	tmp[0] = 'v';
+	tmp++;
+
+	gts->next = (char **)tmp;
+	*gts->next = NULL;
+	tmp += sizeof(char *);
+
+	fvar = (struct gtp_frame_var *) tmp;
+	fvar->num = tve->num;
+	if (tve->num == GTP_VAR_CURRENT_TASK_ID)
+		fvar->val = (uint64_t)(CORE_ADDR)get_current();
+	else
+		fvar->val = tve->val;
+
+	return 0;
+}
+
+static int
+gtp_action_x(struct gtp_trace_s *gts, struct action *ae, int *run)
+{
+	int		ret = 0;
+	unsigned int	pc = 0, sp = 0;
+	ULONGEST	top = 0;
+	int		arg;
+#define STACK_MAX	30
+	ULONGEST	stack[STACK_MAX];
+	union {
+		union {
+			uint8_t	bytes[1];
+			uint8_t	val;
+		} u8;
+		union {
+			uint8_t	bytes[2];
+			uint16_t val;
+		} u16;
+		union {
+			uint8_t bytes[4];
+			uint32_t val;
+		} u32;
+		union {
+			uint8_t bytes[8];
+			ULONGEST val;
+		} u64;
+	} cnv;
+	unsigned long	flags = 0;
+
+	if (ae->u.exp.need_var_lock)
+		spin_lock_irqsave(&gtp_var_lock, flags);
+
+	while (pc < ae->u.exp.size) {
+#ifdef GTP_DEBUG
+		printk(GTP_DEBUG "gtp_parse_x: cmd %x\n", ae->u.exp.buf[pc]);
+#endif
+
+		switch (ae->u.exp.buf[pc++]) {
+		/* add */
+		case 0x02:
+			if (sp)
+				top += stack[--sp];
+			else
+				goto code_error_out;
+			break;
+		/* sub */
+		case 0x03:
+			if (sp)
+				top = stack[--sp] - top;
+			else
+				goto code_error_out;
+			break;
+		/* mul */
+		case 0x04:
+			if (sp)
+				top *= stack[--sp];
+			else
+				goto code_error_out;
+			break;
+#ifndef CONFIG_MIPS
+		/* div_signed */
+		case 0x05:
+			if (top && sp) {
+				LONGEST l = (LONGEST) stack[--sp];
+				do_div(l, (LONGEST) top);
+				top = l;
+			} else
+				goto code_error_out;
+			break;
+		/* div_unsigned */
+		case 0x06:
+			if (top && sp) {
+				ULONGEST ul = stack[--sp];
+				do_div(ul, top);
+				top = ul;
+			} else
+				goto code_error_out;
+			break;
+		/* rem_signed */
+		case 0x07:
+			if (top && sp) {
+				LONGEST l1 = (LONGEST) stack[--sp];
+				LONGEST l2 = (LONGEST) top;
+				top = do_div(l1, l2);
+			} else
+				goto code_error_out;
+			break;
+		/* rem_unsigned */
+		case 0x08:
+			if (top && sp) {
+				ULONGEST ul1 = stack[--sp];
+				ULONGEST ul2 = top;
+				top = do_div(ul1, ul2);
+			} else
+				goto code_error_out;
+			break;
+#endif
+		/* lsh */
+		case 0x09:
+			if (sp)
+				top = stack[--sp] << top;
+			else
+				goto code_error_out;
+			break;
+		/* rsh_signed */
+		case 0x0a:
+			if (sp)
+				top = ((LONGEST) stack[--sp]) >> top;
+			else
+				goto code_error_out;
+			break;
+		/* rsh_unsigned */
+		case 0x0b:
+			if (sp)
+				top = stack[--sp] >> top;
+			else
+				goto code_error_out;
+			break;
+		/* trace */
+		case 0x0c:
+			if (sp > 1) {
+				if (gtp_action_memory_read
+				      (gts, -1, (CORE_ADDR) stack[--sp],
+				       (size_t) top))
+					goto out;
+				if (--sp >= 0)
+					top = stack[sp];
+			} else
+				goto code_error_out;
+			break;
+		/* trace_quick */
+		case 0x0d:
+			if (gtp_action_memory_read
+			      (gts, -1, (CORE_ADDR) top,
+			       (size_t) ae->u.exp.buf[pc++]))
+				goto out;
+			break;
+		/* log_not */
+		case 0x0e:
+			top = !top;
+			break;
+		/* bit_and */
+		case 0x0f:
+			if (sp)
+				top &= stack[--sp];
+			else
+				goto code_error_out;
+			break;
+		/* bit_or */
+		case 0x10:
+			if (sp)
+				top |= stack[--sp];
+			else
+				goto code_error_out;
+			break;
+		/* bit_xor */
+		case 0x11:
+			if (sp)
+				top ^= stack[--sp];
+			else
+				goto code_error_out;
+			break;
+		/* bit_not */
+		case 0x12:
+			top = ~top;
+			break;
+		/* equal */
+		case 0x13:
+			if (sp)
+				top = (stack[--sp] == top);
+			else
+				goto code_error_out;
+			break;
+		/* less_signed */
+		case 0x14:
+			if (sp)
+				top = (((LONGEST) stack[--sp])
+					< ((LONGEST) top));
+			else
+				goto code_error_out;
+			break;
+		/* less_unsigned */
+		case 0x15:
+			if (sp)
+				top = (stack[--sp] < top);
+			else
+				goto code_error_out;
+			break;
+		/* ext */
+		case 0x16:
+			arg = ae->u.exp.buf[pc++];
+			if (arg < (sizeof(LONGEST)*8)) {
+				LONGEST mask = 1 << (arg - 1);
+				top &= ((LONGEST) 1 << arg) - 1;
+				top = (top ^ mask) - mask;
+			}
+			break;
+		/* ref8 */
+		case 0x17:
+			if (probe_kernel_read
+				(cnv.u8.bytes,
+				 (void *)(CORE_ADDR)top, 1))
+				goto code_error_out;
+			top = (ULONGEST) cnv.u8.val;
+			break;
+		/* ref16 */
+		case 0x18:
+			if (probe_kernel_read
+				(cnv.u16.bytes,
+				 (void *)(CORE_ADDR)top, 2))
+				goto code_error_out;
+			top = (ULONGEST) cnv.u16.val;
+			break;
+		/* ref32 */
+		case 0x19:
+			if (probe_kernel_read
+				(cnv.u32.bytes,
+				 (void *)(CORE_ADDR)top, 4))
+				goto code_error_out;
+			top = (ULONGEST) cnv.u32.val;
+			break;
+		/* ref64 */
+		case 0x1a:
+			if (probe_kernel_read
+				(cnv.u64.bytes,
+				 (void *)(CORE_ADDR)top, 8))
+				goto code_error_out;
+			top = (ULONGEST) cnv.u64.val;
+			break;
+		/* if_goto */
+		case 0x20:
+			if (top)
+				pc = (ae->u.exp.buf[pc] << 8)
+					+ (ae->u.exp.buf[pc + 1]);
+			else
+				pc += 2;
+			if (sp && --sp >= 0)
+				top = stack[sp];
+			break;
+		/* goto */
+		case 0x21:
+			pc = (ae->u.exp.buf[pc] << 8)
+				+ (ae->u.exp.buf[pc + 1]);
+			break;
+		/* const8 */
+		case 0x22:
+			stack[sp++] = top;
+			top = ae->u.exp.buf[pc++];
+			break;
+		/* const16 */
+		case 0x23:
+			stack[sp++] = top;
+			top = ae->u.exp.buf[pc++];
+			top = (top << 8) + ae->u.exp.buf[pc++];
+			break;
+		/* const32 */
+		case 0x24:
+			stack[sp++] = top;
+			top = ae->u.exp.buf[pc++];
+			top = (top << 8) + ae->u.exp.buf[pc++];
+			top = (top << 8) + ae->u.exp.buf[pc++];
+			top = (top << 8) + ae->u.exp.buf[pc++];
+			break;
+		/* const64 */
+		case 0x25:
+			stack[sp++] = top;
+			top = ae->u.exp.buf[pc++];
+			top = (top << 8) + ae->u.exp.buf[pc++];
+			top = (top << 8) + ae->u.exp.buf[pc++];
+			top = (top << 8) + ae->u.exp.buf[pc++];
+			top = (top << 8) + ae->u.exp.buf[pc++];
+			top = (top << 8) + ae->u.exp.buf[pc++];
+			top = (top << 8) + ae->u.exp.buf[pc++];
+			top = (top << 8) + ae->u.exp.buf[pc++];
+			break;
+		/* reg */
+		case 0x26:
+			stack[sp++] = top;
+			arg = ae->u.exp.buf[pc++];
+			arg = (arg << 8) + ae->u.exp.buf[pc++];
+			top = gtp_action_reg_read(gts->regs, gts->tpe, arg);
+			if (gts->tpe->reason != gtp_stop_normal)
+				goto error_out;
+			break;
+		/* end */
+		case 0x27:
+			if (run)
+				*run = (int)top;
+			goto out;
+			break;
+		/* dup */
+		case 0x28:
+			stack[sp++] = top;
+			break;
+		/* pop */
+		case 0x29:
+			if (sp && --sp >= 0)
+				top = stack[sp];
+			break;
+		/* zero_ext */
+		case 0x2a:
+			arg = ae->u.exp.buf[pc++];
+			if (arg < (sizeof(LONGEST)*8))
+				top &= ((LONGEST) 1 << arg) - 1;
+			break;
+		/* swap */
+		case 0x2b:
+			if (sp) {
+				stack[sp] = top;
+				top = stack[sp - 1];
+				stack[sp - 1] = stack[sp];
+			} else
+				goto code_error_out;
+			break;
+		/* getv */
+		case 0x2c: {
+				struct gtp_var	*tve;
+
+				arg = ae->u.exp.buf[pc++];
+				arg = (arg << 8) + ae->u.exp.buf[pc++];
+
+				tve = gtp_gtp_var_array_find(arg);
+				if (!tve)
+					goto code_error_out;
+
+				stack[sp++] = top;
+				if (tve->num == GTP_VAR_CURRENT_TASK_ID)
+					top = (uint64_t)(CORE_ADDR)
+					      get_current();
+				else
+					top = (uint64_t)tve->val;
+			}
+			break;
+		/* setv */
+		case 0x2d: {
+				struct gtp_var	*tve;
+
+				arg = ae->u.exp.buf[pc++];
+				arg = (arg << 8) + ae->u.exp.buf[pc++];
+
+				tve = gtp_gtp_var_array_find(arg);
+				if (!tve)
+					goto code_error_out;
+				if (tve->num == GTP_VAR_CURRENT_TASK_ID)
+					goto code_error_out;
+
+				tve->val = (uint64_t)top;
+			}
+			break;
+		/* tracev */
+		case 0x2e: {
+				struct gtp_var	*tve;
+
+				arg = ae->u.exp.buf[pc++];
+				arg = (arg << 8) + ae->u.exp.buf[pc++];
+
+				tve = gtp_gtp_var_array_find(arg);
+				if (!tve)
+					goto code_error_out;
+
+				if (gtp_collect_var(gts, tve))
+					goto out;
+			}
+			break;
+		}
+
+		if (sp > STACK_MAX - 5) {
+#ifdef GTP_DEBUG
+			printk(GTP_DEBUG "gtp_action_x: stack overflow.\n");
+#endif
+			gts->tpe->reason = gtp_stop_agent_expr_stack_overflow;
+			goto error_out;
+		}
+	}
+code_error_out:
+	gts->tpe->reason = gtp_stop_agent_expr_code_error;
+error_out:
+	ret = -1;
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_action_x: tracepoint %d "
+			    "action X get error in pc %u.\n",
+		(int)gts->tpe->num, pc);
+#endif
+out:
+	if (ae->u.exp.need_var_lock)
+		spin_unlock_irqrestore(&gtp_var_lock, flags);
+	return ret;
+}
+
+static int
+gtp_kp_pre_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct gtp_trace_s	gts;
+	struct action		*ae;
+
+	gts.tpe = container_of(p, struct gtp_entry, kp);
+	gts.regs = regs;
+	gts.next = NULL;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_kp_pre_handler: tracepoint %d\n",
+	       (int)gts.tpe->num);
+#endif
+
+	if (gts.tpe->kpreg == 0)
+		return 0;
+
+	/* Condition.  */
+	if (gts.tpe->cond) {
+		int	run;
+
+		if (gtp_action_x(&gts, gts.tpe->cond, &run))
+			goto tpe_stop;
+		if (!run)
+			return 0;
+	}
+
+	/* Pass.  */
+	if (!gts.tpe->nopass) {
+		if (atomic_dec_return(&gts.tpe->current_pass) < 0)
+			goto tpe_stop;
+	}
+
+	/* Handle actions.  */
+	for (ae = gts.tpe->action_list; ae; ae = ae->next) {
+		switch (ae->type) {
+		case 'R':
+			if (gtp_action_r(&gts, ae))
+				goto tpe_stop;
+			break;
+		case 'X':
+			if (gtp_action_x(&gts, ae, NULL))
+				goto tpe_stop;
+			break;
+		case 'M':
+			if (gtp_action_memory_read(&gts, ae->u.m.regnum,
+						   ae->u.m.offset,
+						   ae->u.m.size))
+				goto tpe_stop;
+			break;
+		}
+	}
+
+	return 0;
+
+tpe_stop:
+	gts.tpe->kpreg = 0;
+	queue_work(gtp_wq, &gts.tpe->work);
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_kp_pre_handler: tracepoint %d stop.\n",
+		(int)gts.tpe->num);
+#endif
+	return 0;
+}
+
+static struct action *
+gtp_action_alloc(char *pkg)
+{
+	struct action	*ret;
+
+	ret = kmalloc(sizeof(struct action), GFP_KERNEL);
+	if (!ret)
+		goto out;
+
+	memset(ret, '\0', sizeof(struct action));
+	ret->type = pkg[0];
+	ret->src = pkg;
+
+out:
+	return ret;
+}
+
+static void
+gtp_action_release(struct action *ae)
+{
+	struct action	*ae2;
+
+	while (ae) {
+		ae2 = ae;
+		ae = ae->next;
+		/* Release ae2.  */
+		switch (ae2->type) {
+		case 'X':
+			kfree(ae2->u.exp.buf);
+			break;
+		}
+		kfree(ae2->src);
+		kfree(ae2);
+	}
+}
+
+static void
+gtp_src_release(struct gtpsrc *src)
+{
+	struct gtpsrc	*src2;
+
+	while (src) {
+		src2 = src;
+		src = src->next;
+		kfree(src2->src);
+		kfree(src2);
+	}
+}
+
+static void
+gtp_stop(struct work_struct *work)
+{
+	struct gtp_entry	*tpe = container_of(work,
+						    struct gtp_entry, work);
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_stop: tracepoint %d\n", (int)tpe->num);
+#endif
+
+	unregister_kprobe(&tpe->kp);
+}
+
+static struct gtp_entry *
+gtp_list_add(ULONGEST num, ULONGEST addr)
+{
+	struct gtp_entry	*ret = kmalloc(sizeof(struct gtp_entry),
+					       GFP_KERNEL);
+
+	if (!ret)
+		goto out;
+	memset(ret, '\0', sizeof(struct gtp_entry));
+	ret->num = num;
+	ret->addr = addr;
+	ret->kp.addr = (kprobe_opcode_t *) (CORE_ADDR)addr;
+	ret->kp.pre_handler = gtp_kp_pre_handler;
+	INIT_WORK(&ret->work, gtp_stop);
+
+	/* Add to gtp_list.  */
+	ret->next = gtp_list;
+	gtp_list = ret;
+
+out:
+	return ret;
+}
+
+static struct gtp_entry *
+gtp_list_find(ULONGEST num, ULONGEST addr)
+{
+	struct gtp_entry	*tpe;
+
+	for (tpe = gtp_list; tpe; tpe = tpe->next) {
+		if (tpe->num == num && tpe->addr == addr)
+			return tpe;
+	}
+
+	return NULL;
+}
+
+static struct gtp_entry *
+gtp_list_find_onlynum(ULONGEST num)
+{
+	struct gtp_entry	*tpe;
+
+	for (tpe = gtp_list; tpe; tpe = tpe->next) {
+		if (tpe->num == num)
+			return tpe;
+	}
+
+	return NULL;
+}
+
+static void
+gtp_list_release(void)
+{
+	struct gtp_entry	*tpe;
+
+	while (gtp_list) {
+		tpe = gtp_list;
+		gtp_list = gtp_list->next;
+		gtp_action_release(tpe->cond);
+		gtp_action_release(tpe->action_list);
+		gtp_src_release(tpe->src);
+		kfree(tpe);
+	}
+
+	current_gtp = NULL;
+	current_gtp_action = NULL;
+	current_gtp_src = NULL;
+}
+
+static void
+gtp_frame_reset(void)
+{
+	gtp_frame_r_start = gtp_frame;
+	gtp_frame_w_start = gtp_frame;
+	gtp_frame_end = gtp_frame + GTP_FRAME_SIZE;
+	gtp_frame_is_circular = 0;
+	gtp_frame_current = NULL;
+	gtp_frame_current_num = 0;
+	atomic_set(&gtp_frame_create, 0);
+	if (gtp_frame_file) {
+		vfree(gtp_frame_file);
+		gtp_frame_file = NULL;
+		gtp_frame_file_size = 0;
+	}
+}
+
+static int
+hex2int(char hex, int *i)
+{
+	if ((hex >= '0') && (hex <= '9')) {
+		*i = hex - '0';
+		return 1;
+	}
+	if ((hex >= 'a') && (hex <= 'f')) {
+		*i = hex - 'a' + 10;
+		return 1;
+	}
+	if ((hex >= 'A') && (hex <= 'F')) {
+		*i = hex - 'A' + 10;
+		return 1;
+	}
+
+	return 0;
+}
+
+static char *
+hex2ulongest(char *pkg, ULONGEST *u64)
+{
+	int	i;
+
+	*u64 = 0;
+	while (hex2int(pkg[0], &i)) {
+		pkg++;
+		*u64 = (*u64) << 4;
+		*u64 |= i & 0xf;
+	}
+
+	return pkg;
+}
+
+static char *
+string2hex(char *pkg, char *out)
+{
+	char	*ret = out;
+
+	while (pkg[0]) {
+		sprintf(out, "%x", pkg[0]);
+		pkg++;
+		out += 2;
+	}
+
+	return ret;
+}
+
+static char *
+gtp_strdup(char *begin, char *end)
+{
+	int	len;
+	char	*ret;
+
+	if (end)
+		len = end - begin;
+	else
+		len = strlen(begin);
+
+	ret = kmalloc(len + 1, GFP_KERNEL);
+	if (ret == NULL)
+		return NULL;
+
+	strncpy(ret, begin, len);
+	ret[len] = '\0';
+
+	return ret;
+}
+
+static void
+gtpro_list_clear(void)
+{
+	struct gtpro_entry	*e;
+
+	while (gtpro_list) {
+		e = gtpro_list;
+		gtpro_list = gtpro_list->next;
+		kfree(e);
+	}
+}
+
+static struct gtpro_entry *
+gtpro_list_add(CORE_ADDR start, CORE_ADDR end)
+{
+	struct gtpro_entry	*e;
+
+	e = kmalloc(sizeof(struct gtpro_entry), GFP_KERNEL);
+	if (e == NULL)
+		goto out;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtpro_list_add: %p %p\n", (void *)start, (void *)end);
+#endif
+
+	e->start = start;
+	e->end = end;
+
+	e->next = gtpro_list;
+	gtpro_list = e;
+
+out:
+	return e;
+}
+
+static struct gtp_var *
+gtp_var_add(unsigned int num, uint64_t val, char *src)
+{
+	struct gtp_var *var = kmalloc(sizeof(struct gtp_var), GFP_KERNEL);
+	if (!var)
+		goto out;
+
+	var->num = num;
+	var->val = val;
+
+	var->src = gtp_strdup(src, NULL);
+	if (var->src == NULL) {
+		kfree(var);
+		var = NULL;
+		goto out;
+	}
+
+	var->next = gtp_var_list;
+	gtp_var_list = var;
+	gtp_var_head = min(var->num, gtp_var_head);
+	gtp_var_tail = max(var->num, gtp_var_tail);
+
+out:
+	return var;
+}
+
+static struct gtp_var *
+gtp_var_find(unsigned int num)
+{
+	struct gtp_var	*ret = NULL;
+
+	if (num >= gtp_var_head && num <= gtp_var_tail) {
+		for (ret = gtp_var_list; ret; ret = ret->next) {
+			if (ret->num == num)
+				break;
+		}
+	}
+
+	return ret;
+}
+
+static void
+gtp_var_release(void)
+{
+	struct gtp_var	*tve;
+
+	gtp_var_head = GTP_VAR_CURRENT_TASK_ID;
+	gtp_var_tail = GTP_VAR_CURRENT_TASK_ID;
+	current_gtp_var = NULL;
+
+	while (gtp_var_list != &gtp_var_current_task) {
+		tve = gtp_var_list;
+		gtp_var_list = gtp_var_list->next;
+		kfree(tve->src);
+		kfree(tve);
+	}
+}
+
+static int
+gtp_gdbrsp_qtstop(void)
+{
+	struct gtp_entry	*tpe;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_gdbrsp_qtstop\n");
+#endif
+
+	if (!gtp_start)
+		return -EBUSY;
+
+	flush_workqueue(gtp_wq);
+
+	for (tpe = gtp_list; tpe; tpe = tpe->next) {
+		if (tpe->kpreg) {
+			unregister_kprobe(&tpe->kp);
+			tpe->kpreg = 0;
+		}
+	}
+
+	kfree(gtp_var_array);
+	gtp_var_array = NULL;
+
+	gtp_start = 0;
+
+	return 0;
+}
+
+static int
+gtp_gdbrsp_qtinit(void)
+{
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_gdbrsp_qtinit\n");
+#endif
+
+	if (gtp_start)
+		gtp_gdbrsp_qtstop();
+
+	gtp_list_release();
+
+	if (gtp_frame)
+		gtp_frame_reset();
+
+	gtpro_list_clear();
+
+	gtp_var_release();
+
+	return 0;
+}
+
+static int
+gtp_gdbrsp_qtstart(void)
+{
+	struct gtp_entry	*tpe;
+	struct gtp_var		*tve;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_gdbrsp_qtstart\n");
+#endif
+
+	if (gtp_start)
+		return -EBUSY;
+
+	if (!gtp_frame) {
+		gtp_frame = vmalloc(GTP_FRAME_SIZE);
+		if (!gtp_frame)
+			return -ENOMEM;
+
+		gtp_frame_reset();
+	}
+
+	gtp_start = 1;
+
+	gtp_var_array = kmalloc(sizeof(struct gtp_var *)
+				*(gtp_var_tail - gtp_var_head + 1),
+				GFP_KERNEL);
+	if (!gtp_var_array) {
+		gtp_gdbrsp_qtstop();
+		return -ENOMEM;
+	}
+	memset(gtp_var_array, '\0', sizeof(struct gtp_var *)
+				    *(gtp_var_tail - gtp_var_head + 1));
+	for (tve = gtp_var_list; tve; tve = tve->next)
+		gtp_var_array[tve->num - gtp_var_head] = tve;
+
+	for (tpe = gtp_list; tpe; tpe = tpe->next) {
+		if (!tpe->disable && tpe->action_list) {
+			int	ret;
+
+			if (!tpe->nopass)
+				atomic_set(&tpe->current_pass, tpe->pass);
+			ret = register_kprobe(&tpe->kp);
+			if (ret < 0) {
+				gtp_gdbrsp_qtstop();
+				return ret;
+			}
+			tpe->kpreg = 1;
+		}
+		tpe->reason = gtp_stop_normal;
+	}
+
+	return 0;
+}
+
+struct gtp_x_goto {
+	struct gtp_x_goto	*next;
+	unsigned int		addr;
+	int			non_goto_done;
+};
+
+static struct gtp_x_goto *
+gtp_x_goto_find(struct gtp_x_goto *list, unsigned int pc)
+{
+	struct gtp_x_goto	*ret = NULL;
+
+	for (ret = list; ret; ret = ret->next) {
+		if (ret->addr == pc)
+			break;
+	}
+
+	return ret;
+}
+
+static struct gtp_x_goto *
+gtp_x_goto_add(struct gtp_x_goto **list, unsigned int pc, int non_goto_done)
+{
+	struct gtp_x_goto	*ret;
+
+	ret = kmalloc(sizeof(struct gtp_x_goto), GFP_KERNEL);
+	if (!ret)
+		goto out;
+
+	ret->addr = pc;
+	ret->non_goto_done = non_goto_done;
+
+	if (*list) {
+		ret->next = *list;
+		*list = ret;
+	} else {
+		ret->next = NULL;
+		*list = ret;
+	}
+
+out:
+	return ret;
+}
+
+struct gtp_x_var {
+	struct gtp_x_var	*next;
+	unsigned int		num;
+	unsigned int		flags;
+};
+
+static int
+gtp_x_var_add(struct gtp_x_var **list, unsigned int num, unsigned int flag)
+{
+	struct gtp_x_var	*curv;
+
+	for (curv = *list; curv; curv = curv->next) {
+		if (curv->num == num)
+			break;
+	}
+
+	if (!curv) {
+		curv = kmalloc(sizeof(struct gtp_x_var), GFP_KERNEL);
+		if (!curv)
+			return -ENOMEM;
+		curv->num = num;
+		curv->flags = 0;
+		if (*list) {
+			curv->next = *list;
+			*list = curv;
+		} else {
+			curv->next = NULL;
+			*list = curv;
+		}
+	}
+
+	curv->flags |= flag;
+
+	return 0;
+}
+
+static int
+gtp_check_x(struct action *ae)
+{
+	int			ret = -EINVAL;
+	unsigned int		pc = 0;
+	struct gtp_x_goto	*glist = NULL, *gtmp;
+	struct gtp_x_var	*vlist = NULL, *vtmp;
+
+reswitch:
+	while (pc < ae->u.exp.size) {
+#ifdef GTP_DEBUG
+		printk(GTP_DEBUG "gtp_check_x: cmd %x\n", ae->u.exp.buf[pc]);
+#endif
+		switch (ae->u.exp.buf[pc++]) {
+		/* add */
+		case 0x02:
+		/* sub */
+		case 0x03:
+		/* mul */
+		case 0x04:
+		/* lsh */
+		case 0x09:
+		/* rsh_signed */
+		case 0x0a:
+		/* rsh_unsigned */
+		case 0x0b:
+		/* trace */
+		case 0x0c:
+		/* log_not */
+		case 0x0e:
+		/* bit_and */
+		case 0x0f:
+		/* bit_or */
+		case 0x10:
+		/* bit_xor */
+		case 0x11:
+		/* bit_not */
+		case 0x12:
+		/* equal */
+		case 0x13:
+		/* less_signed */
+		case 0x14:
+		/* less_unsigned */
+		case 0x15:
+		/* ref8 */
+		case 0x17:
+		/* ref16 */
+		case 0x18:
+		/* ref32 */
+		case 0x19:
+		/* ref64 */
+		case 0x1a:
+		/* dup */
+		case 0x28:
+		/* pop */
+		case 0x29:
+		/* swap */
+		case 0x2b:
+			break;
+
+		/* trace_quick */
+		case 0x0d:
+		/* ext */
+		case 0x16:
+		/* const8 */
+		case 0x22:
+		/* zero_ext */
+		case 0x2a:
+			if (pc >= ae->u.exp.size)
+				goto release_out;
+			pc++;
+			break;
+
+		/* const16 */
+		case 0x23:
+		/* reg */
+		case 0x26:
+			if (pc + 1 >= ae->u.exp.size)
+				goto release_out;
+			pc += 2;
+			break;
+		/* const32 */
+		case 0x24:
+			if (pc + 3 >= ae->u.exp.size)
+				goto release_out;
+			pc += 4;
+			break;
+		/* const64 */
+		case 0x25:
+			if (pc + 7 >= ae->u.exp.size)
+				goto release_out;
+			pc += 8;
+			break;
+
+
+		/* if_goto */
+		case 0x20:
+			if (pc + 1 >= ae->u.exp.size)
+				goto release_out;
+			gtmp = gtp_x_goto_find(glist, pc);
+			if (gtmp) {
+				if (gtmp->non_goto_done)
+					goto out;
+				else {
+					gtmp->non_goto_done = 1;
+					pc += 2;
+				}
+			} else {
+				if (!gtp_x_goto_add(&glist, pc, 0)) {
+					ret = -ENOMEM;
+					goto release_out;
+				}
+				pc = (ae->u.exp.buf[pc] << 8)
+					+ (ae->u.exp.buf[pc + 1]);
+			}
+			break;
+		/* goto */
+		case 0x21:
+			if (pc + 1 >= ae->u.exp.size)
+				goto release_out;
+			gtmp = gtp_x_goto_find(glist, pc);
+			if (gtmp)
+				goto out;
+			else {
+				if (!gtp_x_goto_add(&glist, pc, 1)) {
+					ret = -ENOMEM;
+					goto release_out;
+				}
+				pc = (ae->u.exp.buf[pc] << 8)
+					+ (ae->u.exp.buf[pc + 1]);
+			}
+			break;
+
+		/* end */
+		case 0x27:
+			goto out;
+			break;
+
+		/* getv */
+		case 0x2c: {
+				int	arg;
+
+				if (pc + 1 >= ae->u.exp.size)
+					goto release_out;
+				arg = ae->u.exp.buf[pc++];
+				arg = (arg << 8) + ae->u.exp.buf[pc++];
+				if (gtp_x_var_add(&vlist, arg, 1)) {
+					ret = -ENOMEM;
+					goto release_out;
+				}
+			}
+			break;
+		/* setv */
+		case 0x2d: {
+				int	arg;
+
+				if (pc + 1 >= ae->u.exp.size)
+					goto release_out;
+				arg = ae->u.exp.buf[pc++];
+				arg = (arg << 8) + ae->u.exp.buf[pc++];
+				if (gtp_x_var_add(&vlist, arg, 2)) {
+					ret = -ENOMEM;
+					goto release_out;
+				}
+			}
+			break;
+
+		/* tracev */
+		case 0x2e: {
+				int	arg;
+
+				if (pc + 1 >= ae->u.exp.size)
+					goto release_out;
+				arg = ae->u.exp.buf[pc++];
+				arg = (arg << 8) + ae->u.exp.buf[pc++];
+				if (gtp_x_var_add(&vlist, arg, 4)) {
+					ret = -ENOMEM;
+					goto release_out;
+				}
+			}
+			break;
+
+		/* div_signed */
+		case 0x05:
+		/* div_unsigned */
+		case 0x06:
+		/* rem_signed */
+		case 0x07:
+		/* rem_unsigned */
+		case 0x08:
+#ifdef CONFIG_MIPS
+			/* XXX, mips don't have 64 bit div.  */
+			goto release_out;
+#endif
+			break;
+
+		/* float */
+		case 0x01:
+		/* ref_float */
+		case 0x1b:
+		/* ref_double */
+		case 0x1c:
+		/* ref_long_double */
+		case 0x1d:
+		/* l_to_d */
+		case 0x1e:
+		/* d_to_l */
+		case 0x1f:
+		/* trace16 */
+		case 0x30:
+		default:
+			goto release_out;
+			break;
+		}
+	}
+	goto release_out;
+
+out:
+	for (gtmp = glist; gtmp; gtmp = gtmp->next) {
+		if (!gtmp->non_goto_done)
+			break;
+	}
+	if (gtmp) {
+		pc = gtmp->addr + 2;
+		gtmp->non_goto_done = 1;
+		goto reswitch;
+	}
+	ret = 0;
+
+release_out:
+	while (glist) {
+		gtmp = glist;
+		glist = glist->next;
+		kfree(gtmp);
+	}
+	while (vlist) {
+		vtmp = vlist;
+		vlist = vlist->next;
+		if ((vtmp->flags & 2)
+		    && ((vtmp->flags & 1) || (vtmp->flags & 4)))
+			ae->u.exp.need_var_lock = 1;
+		kfree(vtmp);
+	}
+
+	return ret;
+}
+
+static int
+gtp_parse_x(struct action *ae, char **pkgp)
+{
+	ULONGEST	size;
+	int		ret = 0, i, h, l;
+	char		*pkg = *pkgp;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_parse_x: %s\n", pkg);
+#endif
+
+	if (pkg[0] == '\0') {
+		ret = -EINVAL;
+		goto out;
+	}
+	pkg = hex2ulongest(pkg, &size);
+	if (pkg[0] != ',') {
+		ret = -EINVAL;
+		goto out;
+	}
+	ae->u.exp.size = (unsigned int)size;
+	pkg++;
+
+	ae->u.exp.buf = kmalloc(ae->u.exp.size, GFP_KERNEL);
+	if (!ae->u.exp.buf)
+		return -ENOMEM;
+
+	for (i = 0; i < ae->u.exp.size
+		    && hex2int(pkg[0], &h) && hex2int(pkg[1], &l);
+	     i++) {
+#ifdef GTP_DEBUG
+		printk(GTP_DEBUG "gtp_parse_x: %s %d %d\n", pkg, h, l);
+#endif
+		ae->u.exp.buf[i] = (h << 4) | l;
+		pkg += 2;
+#ifdef GTP_DEBUG
+		printk(GTP_DEBUG "gtp_parse_x: %x\n", ae->u.exp.buf[i]);
+#endif
+	}
+	if (i != ae->u.exp.size) {
+		kfree(ae->u.exp.buf);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ae->u.exp.need_var_lock = 0;
+
+	ret = gtp_check_x(ae);
+	if (ret)
+		kfree(ae->u.exp.buf);
+
+out:
+	*pkgp = pkg;
+	return ret;
+}
+
+static int
+gtp_gdbrsp_qtdp(char *pkg)
+{
+	int			addnew = 1;
+	ULONGEST		num, addr;
+	struct gtp_entry	*tpe;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_gdbrsp_qtdp: %s\n", pkg);
+#endif
+
+	if (gtp_start)
+		return -EBUSY;
+
+	if (pkg[0] == '-') {
+		pkg++;
+		addnew = 0;
+	}
+
+	/* Get num and addr.  */
+	if (pkg[0] == '\0')
+		return -EINVAL;
+	pkg = hex2ulongest(pkg, &num);
+	if (pkg[0] == '\0')
+		return -EINVAL;
+	pkg++;
+	pkg = hex2ulongest(pkg, &addr);
+	if (pkg[0] == '\0')
+		return -EINVAL;
+	pkg++;
+
+	tpe = gtp_list_find(num, addr);
+	if (addnew) {
+		if (tpe)
+			return -EINVAL;
+
+		tpe = gtp_list_add(num, addr);
+		if (tpe == NULL)
+			return -ENOMEM;
+
+		if (pkg[0] == 'D')
+			tpe->disable = 1;
+		if (pkg[0] == '\0')
+			return -EINVAL;
+		pkg++;
+
+		/* Get step and pass.  */
+		if (pkg[0] == '\0')
+			return -EINVAL;
+		pkg++;
+		pkg = hex2ulongest(pkg, &tpe->step);
+		if (pkg[0] == '\0')
+			return -EINVAL;
+		pkg++;
+		pkg = hex2ulongest(pkg, &tpe->pass);
+		if (tpe->pass == 0)
+			tpe->nopass = 1;
+		if (pkg[0] == '\0')
+			return -EINVAL;
+		pkg++;
+	}
+
+	if (tpe) {
+		/* Add action to tpe.  */
+		int	step_action = 0;
+
+		if (pkg[0] == 'S') {
+			pkg++;
+			step_action = 1;
+			/* XXX: Still not support step.  */
+			return 1;
+		}
+		while (pkg[0]) {
+			struct action	*ae = NULL, *atail = NULL;
+
+			switch (pkg[0]) {
+			case 'M': {
+					int		is_neg = 0;
+					ULONGEST	ulongtmp;
+
+					ae = gtp_action_alloc(pkg);
+					if (!ae)
+						return -ENOMEM;
+					pkg++;
+					if (pkg[0] == '-') {
+						is_neg = 1;
+						pkg++;
+					}
+					pkg = hex2ulongest(pkg, &ulongtmp);
+					ae->u.m.regnum = (int)ulongtmp;
+					if (is_neg)
+						ae->u.m.regnum
+						  = -ae->u.m.regnum;
+					if (pkg[0] == '\0') {
+						kfree(ae);
+						return -EINVAL;
+					}
+					pkg++;
+					pkg = hex2ulongest(pkg, &ulongtmp);
+					ae->u.m.offset = (CORE_ADDR)ulongtmp;
+					if (pkg[0] == '\0') {
+						kfree(ae);
+						return -EINVAL;
+					}
+					pkg++;
+					pkg = hex2ulongest(pkg, &ulongtmp);
+					ae->u.m.size = (size_t)ulongtmp;
+				}
+				break;
+			case 'R':
+				/* XXX: reg_mask is ignore.  */
+				ae = gtp_action_alloc(pkg);
+				if (!ae)
+					return -ENOMEM;
+				pkg++;
+				pkg = hex2ulongest(pkg,
+						   &ae->u.reg_mask);
+				break;
+			case 'X': {
+					int	ret;
+
+					ae = gtp_action_alloc(pkg);
+					if (!ae)
+						return -ENOMEM;
+					pkg++;
+					ret = gtp_parse_x(ae, &pkg);
+					if (ret < 0) {
+						kfree(ae);
+						return ret;
+					}
+#ifdef GTP_DEBUG
+					if (ae->u.exp.need_var_lock)
+						printk(GTP_DEBUG
+						       "gtp_gdbrsp_qtdp: "
+						       "ae need var lock.\n");
+#endif
+				}
+				break;
+			case '-':
+				pkg++;
+				break;
+			default:
+				/* XXX: Not support.  */
+				return 1;
+			}
+
+			if (ae) {
+				/* Save the src.  */
+				ae->src = gtp_strdup(ae->src, pkg);
+				if (ae->src == NULL) {
+					kfree(ae);
+					return -ENOMEM;
+				}
+				/* Add ae to tpe.  */
+				if (ae->type == 'X' && addnew && !tpe->cond) {
+					tpe->cond = ae;
+					tpe->cond->next = NULL;
+				} else if (!tpe->action_list) {
+					tpe->action_list = ae;
+					atail = ae;
+				} else {
+					if (atail == NULL)
+						for (atail = tpe->action_list;
+						     atail->next;
+						     atail = atail->next)
+							;
+					atail->next = ae;
+					atail = ae;
+				}
+			}
+		}
+	} else
+		return -EINVAL;
+
+	return 0;
+}
+
+static int
+gtp_gdbrsp_qtdpsrc(char *pkg)
+{
+	ULONGEST		num, addr;
+	struct gtpsrc		*src, *srctail;
+	struct gtp_entry	*tpe;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_gdbrsp_qtdpsrc: %s\n", pkg);
+#endif
+
+	if (gtp_start)
+		return -EBUSY;
+
+	/* Get num and addr.  */
+	if (pkg[0] == '\0')
+		return -EINVAL;
+	pkg = hex2ulongest(pkg, &num);
+	if (pkg[0] == '\0')
+		return -EINVAL;
+	pkg++;
+	pkg = hex2ulongest(pkg, &addr);
+	if (pkg[0] == '\0')
+		return -EINVAL;
+	pkg++;
+	tpe = gtp_list_find(num, addr);
+	if (tpe == NULL)
+		return -EINVAL;
+
+	src = kmalloc(sizeof(struct gtpsrc), GFP_KERNEL);
+	if (src == NULL)
+		return -ENOMEM;
+	src->next = NULL;
+	src->src = gtp_strdup(pkg, NULL);
+	if (src->src == NULL) {
+		kfree(src);
+		return -ENOMEM;
+	}
+
+	if (tpe->src) {
+		for (srctail = tpe->src; srctail->next;
+		     srctail = srctail->next)
+			;
+		srctail->next = src;
+	} else
+		tpe->src = src;
+
+	return 0;
+}
+
+static int
+gtp_gdbrsp_qtdisconnected(char *pkg)
+{
+	ULONGEST setting;
+
+	if (pkg[0] == '\0')
+		return -EINVAL;
+
+	hex2ulongest(pkg, &setting);
+	gtp_disconnected_tracing = (int)setting;
+
+	return 0;
+}
+
+static int
+gtp_gdbrsp_qtbuffer(char *pkg)
+{
+	if (strncmp("circular:", pkg, 9) == 0) {
+		ULONGEST setting;
+
+		pkg += 9;
+		if (pkg[0] == '\0')
+			return -EINVAL;
+		hex2ulongest(pkg, &setting);
+		gtp_circular = (int)setting;
+
+		return 0;
+	}
+
+	return 1;
+}
+
+static int
+gtp_frame_head_find_addr(char *cur, int inside, unsigned long lo,
+			 unsigned long hi)
+{
+	char	*tmp;
+	int	tfnum = gtp_frame_current_num;
+
+	if (cur)
+		tmp = cur;
+	else
+		tmp = gtp_frame_r_start;
+
+	do {
+		if (tmp[0] == 'h') {
+			if (tfnum != gtp_frame_current_num) {
+				char		*next;
+				struct pt_regs	*regs = NULL;
+
+				for (next = *(char **)(tmp + 1); next;
+				     next = *(char **)(next + 1)) {
+					if (next[0] == 'r') {
+						regs = (struct pt_regs *)
+						       (next + 1
+							+ sizeof(char *));
+						break;
+					}
+				}
+				if (regs
+				    && ((inside
+					 && GTP_REGS_PC(regs) >= lo
+					 && GTP_REGS_PC(regs) <= hi)
+					|| (!inside
+					    && (GTP_REGS_PC(regs) < lo
+						|| GTP_REGS_PC(regs) > hi)))) {
+					gtp_frame_current_num = tfnum;
+					gtp_frame_current = tmp;
+					return 0;
+				}
+			}
+			tfnum++;
+		}
+
+		tmp = gtp_frame_next(tmp);
+		if (!tmp)
+			break;
+
+		if (tmp == gtp_frame_end)
+			tmp = gtp_frame;
+	} while (tmp != gtp_frame_w_start);
+
+	return -1;
+}
+
+static int
+gtp_frame_head_find_trace(char *cur, ULONGEST trace)
+{
+	char	*tmp;
+	int	tfnum = gtp_frame_current_num;
+
+	if (cur)
+		tmp = cur;
+	else
+		tmp = gtp_frame_r_start;
+
+	do {
+		if (tmp[0] == 'h') {
+			if (tfnum != gtp_frame_current_num) {
+				if (trace == *(ULONGEST *)
+					     (tmp + 1 + sizeof(char *))) {
+					gtp_frame_current_num = tfnum;
+					gtp_frame_current = tmp;
+					return 0;
+				}
+			}
+			tfnum++;
+		}
+
+		tmp = gtp_frame_next(tmp);
+		if (!tmp)
+			break;
+
+		if (tmp == gtp_frame_end)
+			tmp = gtp_frame;
+	} while (tmp != gtp_frame_w_start);
+
+	return -1;
+}
+
+static int
+gtp_frame_head_find_num(int num)
+{
+	char	*tmp = gtp_frame_r_start;
+	int	tfnum = 0;
+
+	do {
+		if (tmp[0] == 'h') {
+			if (tfnum == num) {
+				gtp_frame_current_num = num;
+				gtp_frame_current = tmp;
+				return 0;
+			}
+			tfnum++;
+		}
+
+		tmp = gtp_frame_next(tmp);
+		if (!tmp)
+			break;
+
+		if (tmp == gtp_frame_end)
+			tmp = gtp_frame;
+	} while (tmp != gtp_frame_w_start);
+
+	return -1;
+}
+
+static int
+gtp_gdbrsp_qtframe(char *pkg)
+{
+	int	ret = -1;
+
+	if (gtp_start)
+		return -EBUSY;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_gdbrsp_qtframe: %s\n", pkg);
+#endif
+
+	if (atomic_read(&gtp_frame_create) == 0)
+		goto out;
+
+	if (strncmp(pkg, "pc:", 3) == 0) {
+		ULONGEST	addr;
+
+		pkg += 3;
+
+		if (pkg[0] == '\0')
+			return -EINVAL;
+		hex2ulongest(pkg, &addr);
+
+		ret = gtp_frame_head_find_addr(gtp_frame_current, 1,
+					       (unsigned long)addr,
+					       (unsigned long)addr);
+	} else if (strncmp(pkg, "tdp:", 4) == 0) {
+		ULONGEST	trace;
+
+		pkg += 4;
+
+		if (pkg[0] == '\0')
+			return -EINVAL;
+		hex2ulongest(pkg, &trace);
+
+		ret = gtp_frame_head_find_trace(gtp_frame_current, trace);
+	} else if (strncmp(pkg, "range:", 6) == 0) {
+		ULONGEST	start, end;
+
+		pkg += 6;
+
+		if (pkg[0] == '\0')
+			return -EINVAL;
+		pkg = hex2ulongest(pkg, &start);
+		if (pkg[0] == '\0')
+			return -EINVAL;
+		pkg++;
+		hex2ulongest(pkg, &end);
+
+		ret = gtp_frame_head_find_addr(gtp_frame_current, 1,
+					       (unsigned long)start,
+					       (unsigned long)end);
+	} else if (strncmp(pkg, "outside:", 8) == 0) {
+		ULONGEST	start, end;
+
+		pkg += 8;
+
+		if (pkg[0] == '\0')
+			return -EINVAL;
+		pkg = hex2ulongest(pkg, &start);
+		if (pkg[0] == '\0')
+			return -EINVAL;
+		pkg++;
+		hex2ulongest(pkg, &end);
+
+		ret = gtp_frame_head_find_addr(gtp_frame_current, 0,
+					       (unsigned long)start,
+					       (unsigned long)end);
+	} else {
+		ULONGEST	num;
+
+		if (pkg[0] == '\0')
+			return -EINVAL;
+		hex2ulongest(pkg, &num);
+
+		if (((int) num) < 0) {
+			/* Return to current.  */
+			gtp_frame_current = NULL;
+			gtp_frame_current_num = 0;
+
+			return 0;
+		}
+		ret = gtp_frame_head_find_num((int) num);
+	}
+
+out:
+	if (ret) {
+		strcpy(gtp_rw_bufp, "F-1");
+		gtp_rw_bufp += 3;
+		gtp_rw_size += 3;
+	} else {
+		sprintf(gtp_rw_bufp, "F%xT%x",
+			gtp_frame_current_num,
+			(unsigned int)
+			*(ULONGEST *)(gtp_frame_current + 1 + sizeof(char *)));
+		gtp_rw_size += strlen(gtp_rw_bufp);
+		gtp_rw_bufp += strlen(gtp_rw_bufp);
+	}
+	return 1;
+}
+
+static int
+gtp_gdbrsp_qtro(char *pkg)
+{
+	ULONGEST	start, end;
+
+	gtpro_list_clear();
+
+	while (pkg[0]) {
+		pkg = hex2ulongest(pkg, &start);
+		if (pkg[0] != ',')
+			return -EINVAL;
+		pkg++;
+		pkg = hex2ulongest(pkg, &end);
+		if (pkg[0])
+			pkg++;
+
+		if (gtpro_list_add((CORE_ADDR)start, (CORE_ADDR)end) == NULL)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int
+gtp_gdbrsp_qtdv(char *pkg)
+{
+	ULONGEST	num, val;
+	struct gtp_var	*var;
+	char		*src;
+
+	pkg = hex2ulongest(pkg, &num);
+	if (num == GTP_VAR_CURRENT_TASK_ID)
+		return 0;
+	if (pkg[0] != ':')
+		return -EINVAL;
+	pkg++;
+	src = pkg;
+	pkg = hex2ulongest(pkg, &val);
+	if (pkg[0] != ':')
+		return -EINVAL;
+	pkg++;
+
+	var = gtp_var_find(num);
+	if (var)
+		return -EINVAL;
+
+	if (!gtp_var_add((unsigned int)num, (uint64_t)val, src))
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int
+gtp_gdbrsp_QT(char *pkg)
+{
+	int	ret = 1;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_gdbrsp_QT: %s\n", pkg);
+#endif
+
+	if (strcmp("init", pkg) == 0)
+		ret = gtp_gdbrsp_qtinit();
+	else if (strcmp("Stop", pkg) == 0)
+		ret = gtp_gdbrsp_qtstop();
+	else if (strcmp("Start", pkg) == 0)
+		ret = gtp_gdbrsp_qtstart();
+	else if (strncmp("DP:", pkg, 3) == 0)
+		ret = gtp_gdbrsp_qtdp(pkg + 3);
+	else if (strncmp("DPsrc:", pkg, 6) == 0)
+		ret = gtp_gdbrsp_qtdpsrc(pkg + 6);
+	else if (strncmp("Disconnected:", pkg, 13) == 0)
+		ret = gtp_gdbrsp_qtdisconnected(pkg + 13);
+	else if (strncmp("Buffer:", pkg, 7) == 0)
+		ret = gtp_gdbrsp_qtbuffer(pkg + 7);
+	else if (strncmp("Frame:", pkg, 6) == 0)
+		ret = gtp_gdbrsp_qtframe(pkg + 6);
+	else if (strncmp("ro:", pkg, 3) == 0)
+		ret = gtp_gdbrsp_qtro(pkg + 3);
+	else if (strncmp("DV:", pkg, 3) == 0)
+		ret = gtp_gdbrsp_qtdv(pkg + 3);
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_gdbrsp_QT: return %d\n", ret);
+#endif
+
+	return ret;
+}
+
+static int
+gtp_get_status(struct gtp_entry *tpe, char *buf)
+{
+	int			size = 0;
+	int			tfnum = 0;
+	unsigned long		flags;
+	CORE_ADDR		tmpaddr;
+
+	if (!gtp_frame) {
+		sprintf(buf, "tnotrun:0;");
+		buf += 10;
+		size += 10;
+	} else if (!tpe || (tpe && tpe->reason == gtp_stop_normal)) {
+		sprintf(buf, "tstop:0;");
+		buf += 8;
+		size += 8;
+	} else {
+		char	outtmp[100];
+
+		switch (tpe->reason) {
+		case gtp_stop_frame_full:
+			sprintf(buf, "tfull:%lx;",
+				(unsigned long)tpe->num);
+			break;
+		case gtp_stop_efault:
+			sprintf(buf, "terror:%s:%lx;",
+				string2hex("read memory false", outtmp),
+				(unsigned long)tpe->num);
+			break;
+		case gtp_stop_access_wrong_reg:
+			sprintf(buf, "terror:%s:%lx;",
+				string2hex("access wrong register", outtmp),
+				(unsigned long)tpe->num);
+			break;
+		case gtp_stop_agent_expr_code_error:
+			sprintf(buf, "terror:%s:%lx;",
+				string2hex("agent expression code error",
+					   outtmp),
+				(unsigned long)tpe->num);
+			break;
+		case gtp_stop_agent_expr_stack_overflow:
+			sprintf(buf, "terror:%s:%lx;",
+				string2hex("agent expression stack overflow",
+					   outtmp),
+				(unsigned long)tpe->num);
+			break;
+		default:
+			buf[0] = '\0';
+			break;
+		}
+
+		size += strlen(buf);
+		buf += strlen(buf);
+	}
+
+	if (atomic_read(&gtp_frame_create)) {
+		char	*tmp = gtp_frame_r_start;
+
+		do {
+			if (tmp[0] == 'h')
+				tfnum++;
+
+			tmp = gtp_frame_next(tmp);
+			if (!tmp)
+				break;
+
+			if (tmp == gtp_frame_end)
+				tmp = gtp_frame;
+		} while (tmp != gtp_frame_w_start);
+	}
+	sprintf(buf, "tframes:%x;", tfnum);
+	size += strlen(buf);
+	buf += strlen(buf);
+
+	sprintf(buf, "tcreated:%x;", atomic_read(&gtp_frame_create));
+	size += strlen(buf);
+	buf += strlen(buf);
+
+	sprintf(buf, "tsize:%x;", GTP_FRAME_SIZE);
+	size += strlen(buf);
+	buf += strlen(buf);
+
+	spin_lock_irqsave(&gtp_frame_lock, flags);
+	if (gtp_frame_is_circular)
+		tmpaddr = 0;
+	else
+		tmpaddr = GTP_FRAME_SIZE - (gtp_frame_w_start - gtp_frame);
+	spin_unlock_irqrestore(&gtp_frame_lock, flags);
+	sprintf(buf, "tfree:%lx;", (unsigned long)tmpaddr);
+	size += strlen(buf);
+	buf += strlen(buf);
+
+	sprintf(buf, "circular:%x;", gtp_circular);
+	size += strlen(buf);
+	buf += strlen(buf);
+
+	sprintf(buf, "disconn:%x", gtp_disconnected_tracing);
+	size += strlen(buf);
+	buf += strlen(buf);
+
+	return size;
+}
+
+static int
+gtp_gdbrsp_qtstatus(void)
+{
+	struct gtp_entry	*tpe;
+	int			tmp;
+
+	for (tpe = gtp_list; tpe; tpe = tpe->next) {
+		if (tpe->reason != gtp_stop_normal)
+			break;
+	}
+
+	if (gtp_start && tpe)	/* Tpe is stop, stop all tpes.  */
+		gtp_gdbrsp_qtstop();
+
+	sprintf(gtp_rw_bufp, "T%x;", gtp_start ? 1 : 0);
+	gtp_rw_bufp += 3;
+	gtp_rw_size += 3;
+
+	tmp = gtp_get_status(tpe, gtp_rw_bufp);
+	gtp_rw_bufp += tmp;
+	gtp_rw_size += tmp;
+
+	return 1;
+}
+
+static void
+gtp_report_tracepoint(struct gtp_entry *gtp, char *buf)
+{
+	sprintf(buf, "T%lx:%lx:%c:%lx:%lx",
+		(unsigned long)gtp->num,
+		(unsigned long)gtp->addr,
+		(gtp->disable ? 'D' : 'E'),
+		(unsigned long)gtp->step,
+		(unsigned long)gtp->pass);
+}
+
+static void
+gtp_report_action(struct gtp_entry *gtp, struct action *action, char *buf)
+{
+	sprintf(buf, "A%lx:%lx:%s",
+		(unsigned long)gtp->num,
+		(unsigned long)gtp->addr,
+		action->src);
+}
+
+static void
+gtp_report_src(struct gtp_entry *gtp, struct gtpsrc *src, char *buf)
+{
+	sprintf(buf, "Z%lx:%lx:%s",
+		(unsigned long)gtp->num,
+		(unsigned long)gtp->addr,
+		src->src);
+}
+
+static void
+gtp_current_set_check(void)
+{
+	if (current_gtp_src == NULL)
+		current_gtp = current_gtp->next;
+}
+
+static void
+gtp_current_action_check(void)
+{
+	if (current_gtp_action == NULL) {
+		current_gtp_src = current_gtp->src;
+		gtp_current_set_check();
+	}
+}
+
+static int
+gtp_gdbrsp_qtfp(void)
+{
+	if (gtp_list) {
+		current_gtp = gtp_list;
+		gtp_report_tracepoint(current_gtp, gtp_rw_bufp);
+		gtp_rw_size += strlen(gtp_rw_bufp);
+		gtp_rw_bufp += strlen(gtp_rw_bufp);
+		current_gtp_action = current_gtp->action_list;
+		gtp_current_action_check();
+	} else {
+		gtp_rw_bufp[0] = 'l';
+		gtp_rw_size += 1;
+		gtp_rw_bufp += 1;
+	}
+
+	return 1;
+}
+
+static int
+gtp_gdbrsp_qtsp(void)
+{
+	if (current_gtp_action) {
+		gtp_report_action(current_gtp, current_gtp_action,
+				  gtp_rw_bufp);
+		gtp_rw_size += strlen(gtp_rw_bufp);
+		gtp_rw_bufp += strlen(gtp_rw_bufp);
+		current_gtp_action = current_gtp_action->next;
+		gtp_current_action_check();
+		goto out;
+	}
+
+	if (current_gtp_src) {
+		gtp_report_src(current_gtp, current_gtp_src, gtp_rw_bufp);
+		gtp_rw_size += strlen(gtp_rw_bufp);
+		gtp_rw_bufp += strlen(gtp_rw_bufp);
+		current_gtp_src = current_gtp_src->next;
+		gtp_current_set_check();
+		goto out;
+	}
+
+	if (current_gtp) {
+		gtp_report_tracepoint(current_gtp, gtp_rw_bufp);
+		gtp_rw_size += strlen(gtp_rw_bufp);
+		gtp_rw_bufp += strlen(gtp_rw_bufp);
+		current_gtp_action = current_gtp->action_list;
+		gtp_current_action_check();
+	} else {
+		gtp_rw_bufp[0] = 'l';
+		gtp_rw_size += 1;
+		gtp_rw_bufp += 1;
+	}
+out:
+	return 1;
+}
+
+static void
+gtp_report_var(void)
+{
+	sprintf(gtp_rw_bufp, "%x:%s", current_gtp_var->num,
+		current_gtp_var->src);
+	gtp_rw_size += strlen(gtp_rw_bufp);
+	gtp_rw_bufp += strlen(gtp_rw_bufp);
+}
+
+static int
+gtp_gdbrsp_qtfsv(int f)
+{
+	if (f)
+		current_gtp_var = gtp_var_list;
+
+	if (current_gtp_var) {
+		gtp_report_var();
+		current_gtp_var = current_gtp_var->next;
+	} else {
+		gtp_rw_bufp[0] = 'l';
+		gtp_rw_size += 1;
+		gtp_rw_bufp += 1;
+	}
+
+	return 1;
+}
+
+static int
+gtp_gdbrsp_qtv(char *pkg)
+{
+	ULONGEST		num;
+	struct gtp_var		*var = NULL;
+	struct gtp_frame_var	*vr = NULL;
+	uint64_t		val;
+
+	pkg = hex2ulongest(pkg, &num);
+
+	if (gtp_start || !gtp_frame_current) {
+		if (num != GTP_VAR_CURRENT_TASK_ID) {
+			var = gtp_var_find(num);
+			if (var)
+				val = var->val;
+		}
+	} else {
+		char			*next;
+
+		for (next = *(char **)(gtp_frame_current + 1); next;
+		     next = *(char **)(next + 1)) {
+			if (next[0] == 'v') {
+				vr = (struct gtp_frame_var *)
+				     (next + 1 + sizeof(char *));
+				if (vr->num == (unsigned int)num)
+					goto while_stop;
+			}
+		}
+while_stop:
+		if (vr)
+			val = vr->val;
+	}
+
+	if (var || vr) {
+		sprintf(gtp_rw_bufp, "V%08x%08x",
+			(unsigned int) (val >> 32),
+			(unsigned int) (val & 0xffffffff));
+		gtp_rw_size += strlen(gtp_rw_bufp);
+		gtp_rw_bufp += strlen(gtp_rw_bufp);
+	} else {
+		gtp_rw_bufp[0] = 'U';
+		gtp_rw_size += 1;
+		gtp_rw_bufp += 1;
+	}
+
+	return 1;
+}
+
+static int
+gtp_gdbrsp_qT(char *pkg)
+{
+	int	ret = 1;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_gdbrsp_qT: %s\n", pkg);
+#endif
+
+	if (strcmp("Status", pkg) == 0)
+		ret = gtp_gdbrsp_qtstatus();
+	else if (strcmp("fP", pkg) == 0)
+		ret = gtp_gdbrsp_qtfp();
+	else if (strcmp("sP", pkg) == 0)
+		ret = gtp_gdbrsp_qtsp();
+	else if (strcmp("fV", pkg) == 0)
+		ret = gtp_gdbrsp_qtfsv(1);
+	else if (strcmp("sV", pkg) == 0)
+		ret = gtp_gdbrsp_qtfsv(0);
+	else if (strncmp("V:", pkg, 2) == 0)
+		ret = gtp_gdbrsp_qtv(pkg + 2);
+
+	return ret;
+}
+
+static uint8_t	gtp_m_buffer[0xffff];
+
+static int
+gtp_gdbrsp_m(char *pkg)
+{
+	int		i;
+	ULONGEST	addr, len;
+
+	/* Get add and len.  */
+	if (pkg[0] == '\0')
+		return -EINVAL;
+	pkg = hex2ulongest(pkg, &addr);
+	if (pkg[0] != ',')
+		return -EINVAL;
+	pkg++;
+	pkg = hex2ulongest(pkg, &len);
+	if (len == 0)
+		return -EINVAL;
+	len &= 0xffff;
+	len = (ULONGEST) min((int)((GTP_RW_MAX - 4 - gtp_rw_size) / 2),
+			     (int)len);
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_gdbrsp_m: addr = 0x%lx len = %d\n",
+		(unsigned long) addr, (int) len);
+#endif
+
+	if (gtp_start || !gtp_frame_current) {
+		if (probe_kernel_read(gtp_m_buffer, (void *)(CORE_ADDR)addr,
+					(size_t)len))
+			return -EFAULT;
+	} else {
+		char	*next;
+		int	ret;
+
+		/* The following part is for gtpro support.
+		   It is not available because it make disassemble cannot
+		   work when select a trace frame. */
+#if 0
+		struct gtpro_entry	*gtroe;
+
+		memset(gtp_m_buffer, 0, len);
+
+		/* Read the gtpro.  */
+		for (gtroe = gtpro_list; gtroe; gtroe = gtroe->next) {
+			CORE_ADDR	cur_start, cur_end;
+
+			cur_start = max(gtroe->start, (CORE_ADDR)addr);
+			cur_end = min(gtroe->end, ((CORE_ADDR)(addr + len)));
+			if (cur_start < cur_end) {
+#ifdef GTP_DEBUG
+				printk(GTP_DEBUG "gtp_gdbrsp_m: ro read "
+						 "start = 0x%lx end = 0x%lx\n",
+				       (unsigned long) cur_start,
+				       (unsigned long) cur_end);
+#endif
+				if (probe_kernel_read(gtp_m_buffer,
+						       (void *)cur_start,
+						       (size_t)(cur_end
+								- cur_start)))
+					return -EFAULT;
+			}
+		}
+#endif
+		ret = probe_kernel_read(gtp_m_buffer, (void *)(CORE_ADDR)addr,
+					(size_t)len);
+
+		for (next = *(char **)(gtp_frame_current + 1); next;
+		     next = *(char **)(next + 1)) {
+			if (next[0] == 'm') {
+				struct gtp_frame_mem	*mr;
+				ULONGEST		cur_start, cur_end;
+				uint8_t			*buf;
+
+				mr = (struct gtp_frame_mem *)
+				     (next + 1 + sizeof(char *));
+				buf = next + GTP_FRAME_MEM_SIZE;
+#ifdef GTP_DEBUG
+				printk(GTP_DEBUG "gtp_gdbrsp_m: section "
+						 "addr = 0x%lx size = %lu\n",
+				       (unsigned long) mr->addr,
+				       (unsigned long) mr->size);
+#endif
+				cur_start = max(((ULONGEST)mr->addr), addr);
+				cur_end = min(((ULONGEST)mr->addr
+						+ mr->size),
+					       (addr + len));
+#ifdef GTP_DEBUG
+				printk(GTP_DEBUG "gtp_gdbrsp_m: read "
+						 "start = 0x%lx end = 0x%lx\n",
+				       (unsigned long) cur_start,
+				       (unsigned long) cur_end);
+#endif
+				if (cur_start < cur_end) {
+					memcpy(gtp_m_buffer,
+						buf + cur_start - mr->addr,
+						cur_end - cur_start);
+					ret = 0;
+				}
+			}
+		}
+
+		if (ret)
+			return -EFAULT;
+	}
+
+	for (i = 0; i < (int)len; i++) {
+#ifdef GTP_DEBUG
+		printk(GTP_DEBUG "gtp_gdbrsp_m: %d %02x\n", i, gtp_m_buffer[i]);
+#endif
+		sprintf(gtp_rw_bufp, "%02x", gtp_m_buffer[i]);
+		gtp_rw_bufp += 2;
+		gtp_rw_size += 2;
+	}
+
+	return 1;
+}
+
+static int
+gtp_gdbrsp_g(void)
+{
+	char		*next;
+	struct pt_regs	*regs;
+
+	if (GTP_RW_MAX - 4 - gtp_rw_size < GTP_REG_ASCII_SIZE)
+		return -E2BIG;
+
+	if (gtp_start || !gtp_frame_current) {
+		memset(gtp_rw_bufp, '0', GTP_REG_ASCII_SIZE);
+		goto out;
+	}
+
+	/* Get the regs.  */
+	regs = NULL;
+	for (next = *(char **)(gtp_frame_current + 1); next;
+	     next = *(char **)(next + 1)) {
+		if (next[0] == 'r') {
+			regs = (struct pt_regs *)
+			       (next + 1 + sizeof(char *));
+			break;
+		}
+	}
+	if (regs)
+		gtp_regs2ascii(regs, gtp_rw_bufp);
+	else {
+		struct pt_regs		pregs;
+		struct gtp_entry	*tpe;
+
+		memset(&pregs, '\0', sizeof(struct pt_regs));
+		tpe = gtp_list_find_onlynum(*(ULONGEST *)(gtp_frame_current
+							  + 1
+							  + sizeof(char *)));
+		if (tpe)
+			GTP_REGS_PC(&pregs) = (unsigned long)tpe->addr;
+		gtp_regs2ascii(&pregs, gtp_rw_bufp);
+	}
+out:
+	gtp_rw_bufp += GTP_REG_ASCII_SIZE;
+	gtp_rw_size += GTP_REG_ASCII_SIZE;
+
+	return 1;
+}
+
+static DEFINE_SEMAPHORE(gtp_rw_lock);
+static DECLARE_WAIT_QUEUE_HEAD(gtp_rw_wq);
+static unsigned int	gtp_rw_count;
+
+static int
+gtp_open(struct inode *inode, struct file *file)
+{
+	int	ret = 0;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_open\n");
+#endif
+
+	down(&gtp_rw_lock);
+	if (gtp_rw_count == 0) {
+		gtp_read_ack = 0;
+		gtp_rw_buf = vmalloc(GTP_RW_MAX);
+		if (!gtp_rw_buf) {
+			ret = -ENOMEM;
+			goto out;
+		}
+	}
+	gtp_rw_count++;
+
+out:
+	up(&gtp_rw_lock);
+	return ret;
+}
+
+static int
+gtp_release(struct inode *inode, struct file *file)
+{
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_release\n");
+#endif
+
+	down(&gtp_rw_lock);
+	gtp_rw_count--;
+	if (gtp_rw_count == 0) {
+		vfree(gtp_rw_buf);
+
+		if (!gtp_disconnected_tracing) {
+			gtp_gdbrsp_qtstop();
+			gtp_gdbrsp_qtinit();
+			if (gtp_frame) {
+				vfree(gtp_frame);
+				gtp_frame = NULL;
+			}
+		}
+	}
+	up(&gtp_rw_lock);
+
+	return 0;
+}
+
+static long
+gtp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_ioctl: %x\n", cmd);
+#endif
+
+	return 0;
+}
+
+static ssize_t
+gtp_write(struct file *file, const char __user *buf, size_t size,
+	  loff_t *ppos)
+{
+	char		*rsppkg = NULL;
+	int		i, ret;
+	unsigned char	csum = 0;
+
+	if (down_interruptible(&gtp_rw_lock))
+		return -EINTR;
+
+	if (size == 0) {
+#ifdef GTP_DEBUG
+		printk(GTP_DEBUG "gtp_write: try write 0 size.\n");
+#endif
+		goto error_out;
+	}
+
+	size = min(size, (size_t) GTP_RW_MAX);
+	if (copy_from_user(gtp_rw_buf, buf, size)) {
+		size = -EFAULT;
+		goto error_out;
+	}
+
+	if (gtp_rw_buf[0] == '+' || gtp_rw_buf[0] == '-'
+	    || gtp_rw_buf[0] == '\3') {
+		if (gtp_rw_buf[0] == '+')
+			gtp_rw_size = 0;
+		size = 1;
+		goto out;
+	}
+
+	if (size < 4) {
+		gtp_read_ack = '-';
+		goto out;
+	}
+	/* Check format and crc and get the rsppkg.  */
+	for (i = 0; i < size - 2; i++) {
+		if (rsppkg == NULL) {
+			if (gtp_rw_buf[i] == '$')
+				rsppkg = gtp_rw_buf + i + 1;
+		} else {
+			if (gtp_rw_buf[i] == '#')
+				break;
+			else
+				csum += gtp_rw_buf[i];
+		}
+	}
+	if (rsppkg && gtp_rw_buf[i] == '#') {
+		/* Format is OK.  Check crc.  */
+		unsigned char	c1, c2;
+
+		gtp_rw_buf[i] = '\0';
+
+		c1 = gtp_rw_buf[i+1];
+		c2 = gtp_rw_buf[i+2];
+		if (csum == (c1 << 4) + c2) {
+#ifdef GTP_DEBUG
+			printk(GTP_DEBUG "gtp_write: crc error\n");
+#endif
+			gtp_read_ack = '-';
+			goto out;
+		}
+	} else {
+#ifdef GTP_DEBUG
+		printk(GTP_DEBUG "gtp_write: format error\n");
+#endif
+		gtp_read_ack = '-';
+		goto out;
+	}
+	gtp_read_ack = '+';
+	size = i + 3;
+
+	wake_up_interruptible_nr(&gtp_rw_wq, 1);
+
+	up(&gtp_rw_lock);
+	if (down_interruptible(&gtp_rw_lock))
+		return -EINTR;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_write: %s\n", rsppkg);
+#endif
+
+	/* Handle rsppkg and put return to gtp_rw_buf.  */
+	gtp_rw_buf[0] = '$';
+	gtp_rw_bufp = gtp_rw_buf + 1;
+	gtp_rw_size = 0;
+	ret = 1;
+	switch (rsppkg[0]) {
+	case '?':
+		strcpy(gtp_rw_bufp, "S05");
+		gtp_rw_bufp += 3;
+		gtp_rw_size += 3;
+		break;
+	case 'g':
+		ret = gtp_gdbrsp_g();
+		break;
+	case 'm':
+		ret = gtp_gdbrsp_m(rsppkg + 1);
+		break;
+	case 'Q':
+		if (rsppkg[1] == 'T')
+			ret = gtp_gdbrsp_QT(rsppkg + 2);
+		break;
+	case 'q':
+		if (rsppkg[1] == 'T')
+			ret = gtp_gdbrsp_qT(rsppkg + 2);
+		else if (strncmp("qSupported", rsppkg, 10) == 0) {
+			strcpy(gtp_rw_bufp,
+			       "ConditionalTracepoints+;"
+			       "TracepointSource+;DisconnectedTracing+");
+			gtp_rw_size += strlen(gtp_rw_bufp);
+			gtp_rw_bufp += strlen(gtp_rw_bufp);
+			ret = 1;
+		}
+		break;
+	case 's':
+	case 'S':
+	case 'c':
+	case 'C':
+		ret = -1;
+		break;
+	}
+	if (ret == 0) {
+		strcpy(gtp_rw_bufp, "OK");
+		gtp_rw_bufp += 2;
+		gtp_rw_size += 2;
+	} else if (ret < 0) {
+		sprintf(gtp_rw_bufp, "E%02x", -ret);
+		gtp_rw_bufp += 3;
+		gtp_rw_size += 3;
+	}
+
+	gtp_rw_bufp[0] = '#';
+	csum = 0;
+	for (i = 1; i < gtp_rw_size + 1; i++)
+		csum += gtp_rw_buf[i];
+	gtp_rw_bufp[1] = TOHEX(csum >> 4);
+	gtp_rw_bufp[2] = TOHEX(csum & 0x0f);
+	gtp_rw_bufp = gtp_rw_buf;
+	gtp_rw_size += 4;
+
+out:
+	wake_up_interruptible_nr(&gtp_rw_wq, 1);
+error_out:
+	up(&gtp_rw_lock);
+	return size;
+}
+
+static ssize_t
+gtp_read(struct file *file, char __user *buf, size_t size,
+	 loff_t *ppos)
+{
+	int	err;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_read\n");
+#endif
+
+	if (size == 0)
+		goto out;
+
+	if (down_interruptible(&gtp_rw_lock))
+		return -EINTR;
+
+	if (gtp_read_ack) {
+		err = put_user(gtp_read_ack, buf);
+		if (err) {
+			size = -err;
+			goto out;
+		}
+		gtp_read_ack = 0;
+		size = 1;
+		goto out;
+	}
+
+	size = min(gtp_rw_size, size);
+	if (size == 0)
+		goto out;
+	if (copy_to_user(buf, gtp_rw_bufp, size)) {
+		size = -EFAULT;
+		goto out;
+	}
+	gtp_rw_bufp += size;
+	gtp_rw_size -= size;
+
+out:
+	up(&gtp_rw_lock);
+	return size;
+}
+
+static unsigned int
+gtp_poll(struct file *file, poll_table *wait)
+{
+	unsigned int	mask = POLLOUT | POLLWRNORM;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_poll\n");
+#endif
+
+	down(&gtp_rw_lock);
+	poll_wait(file, &gtp_rw_wq, wait);
+	if (gtp_read_ack || gtp_rw_size)
+		mask |= POLLIN | POLLRDNORM;
+	up(&gtp_rw_lock);
+
+	return mask;
+}
+
+static char *
+gtp_frame_file_realloc(size_t *real_size, size_t size, int is_end)
+{
+	if (*real_size < gtp_frame_file_size + size) {
+		char	*tmp;
+
+		*real_size = gtp_frame_file_size + size;
+		if (!is_end)
+			*real_size += 100;
+
+		tmp = vmalloc(*real_size);
+		if (!tmp) {
+			vfree(gtp_frame_file);
+			return NULL;
+		}
+
+		memcpy(tmp, gtp_frame_file, gtp_frame_file_size);
+		vfree(gtp_frame_file);
+		gtp_frame_file = tmp;
+	}
+
+	return gtp_frame_file + gtp_frame_file_size;
+}
+
+static int
+gtp_frame2file_m(size_t *real_sizep, uint32_t *data_size, char *frame)
+{
+	struct gtp_frame_mem	*mr;
+	uint8_t			*buf;
+	ULONGEST		addr;
+	size_t			remaining;
+
+	mr = (struct gtp_frame_mem *) (frame + 1 + sizeof(char *));
+	buf = frame + GTP_FRAME_MEM_SIZE;
+	addr = mr->addr;
+	remaining = mr->size;
+
+	while (remaining > 0) {
+		uint16_t	blocklen;
+		char		*wbuf;
+		size_t		sp;
+
+		blocklen = remaining > 65535 ? 65535 : remaining;
+
+		sp = 1 + sizeof(addr) + sizeof(blocklen) + blocklen;
+		wbuf = gtp_frame_file_realloc(real_sizep, sp, 0);
+		if (!wbuf)
+			return -1;
+
+		wbuf[0] = 'M';
+		wbuf += 1;
+
+		memcpy(wbuf, &addr, sizeof(addr));
+		wbuf += sizeof(addr);
+
+		memcpy(wbuf, &blocklen, sizeof(blocklen));
+		wbuf += sizeof(blocklen);
+
+		memcpy(wbuf, buf, blocklen);
+
+		addr += blocklen;
+		remaining -= blocklen;
+		buf += blocklen;
+
+		gtp_frame_file_size += sp;
+		*data_size += sp;
+	}
+
+	return 0;
+}
+
+static int
+gtp_frame2file_v(size_t *real_sizep, uint32_t *data_size, char *frame)
+{
+	struct gtp_frame_var	*vr;
+	size_t			sp = 1 + sizeof(unsigned int)
+				     + sizeof(uint64_t);
+	char			*wbuf;
+
+	wbuf = gtp_frame_file_realloc(real_sizep, sp,
+				      0);
+	if (!wbuf)
+		return -1;
+
+	vr = (struct gtp_frame_var *) (frame + 1 + sizeof(char *));
+
+	wbuf[0] = 'V';
+	wbuf += 1;
+
+	memcpy(wbuf, &vr->num, sizeof(unsigned int));
+	wbuf += sizeof(unsigned int);
+
+	memcpy(wbuf, &vr->val, sizeof(uint64_t));
+	wbuf += sizeof(uint64_t);
+
+	gtp_frame_file_size += sp;
+	*data_size += sp;
+
+	return 0;
+}
+
+static int
+gtp_frame2file(size_t *real_sizep, char *frame)
+{
+	int16_t		*tmp16p;
+	char		*next;
+	char		*wbuf;
+	uint32_t	data_size;
+
+	/* Head.  */
+	tmp16p = (int16_t *)gtp_frame_file_realloc(real_sizep, 2, 0);
+	if (!tmp16p)
+		return -1;
+	*tmp16p = (int16_t)*(ULONGEST *)(frame + 1 + sizeof(char *));
+	gtp_frame_file_size += 2;
+	/* This part is for the data_size.  */
+	wbuf = gtp_frame_file_realloc(real_sizep, 4, 0);
+	if (!wbuf)
+		return -1;
+	gtp_frame_file_size += 4;
+
+	/* Body.  */
+	data_size = 0;
+	for (next = *(char **)(frame + 1); next;
+	     next = *(char **)(next + 1)) {
+		switch (next[0]) {
+		case 'r':
+			wbuf = gtp_frame_file_realloc(real_sizep,
+						      GTP_REG_BIN_SIZE + 1,
+						      0);
+			if (!wbuf)
+				return -1;
+			wbuf[0] = 'R';
+			gtp_regs2bin((struct pt_regs *)(next + 1
+							+ sizeof(char *)),
+				     wbuf + 1);
+			gtp_frame_file_size += GTP_REG_BIN_SIZE + 1;
+			data_size += GTP_REG_BIN_SIZE + 1;
+			break;
+
+		case 'm':
+			if (gtp_frame2file_m(real_sizep, &data_size, next))
+				return -1;
+			break;
+
+		case 'v':
+			if (gtp_frame2file_v(real_sizep, &data_size, next))
+				return -1;
+			break;
+		}
+	}
+
+	/* Set the data_size.  */
+	memcpy(gtp_frame_file + gtp_frame_file_size - data_size - 4,
+	       &data_size, 4);
+
+	return 0;
+}
+
+static ssize_t
+gtpframe_read(struct file *file, char __user *buf, size_t size,
+	      loff_t *ppos)
+{
+	ssize_t	ret = -ENOMEM;
+
+	down(&gtp_rw_lock);
+
+	if (gtp_start) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	/* Set gtp_frame_file if need.  */
+	if (!gtp_frame_file) {
+		size_t			real_size;
+		char			*wbuf;
+		struct gtp_entry	*tpe;
+		struct gtp_var		*tvar;
+		int			tmpsize;
+		char			tmpbuf[200];
+		char			*frame;
+
+		if (gtp_frame_is_circular)
+			real_size = GTP_FRAME_SIZE;
+		else
+			real_size = gtp_frame_w_start - gtp_frame;
+		real_size += 200;
+
+		gtp_frame_file = vmalloc(real_size);
+		if (!gtp_frame_file)
+			goto out;
+		gtp_frame_file_size = 0;
+
+		/* Head. */
+		wbuf = gtp_frame_file;
+		strcpy(wbuf, "\x7fTRACE0\n");
+		gtp_frame_file_size += 8;
+
+		/* BUG: will be a new value.  */
+		snprintf(tmpbuf, 200, "R %x\n", GTP_REG_BIN_SIZE);
+		wbuf = gtp_frame_file_realloc(&real_size, strlen(tmpbuf), 0);
+		if (!wbuf)
+			goto out;
+		strcpy(wbuf, tmpbuf);
+		gtp_frame_file_size += strlen(tmpbuf);
+
+		strcpy(tmpbuf, "status 0;");
+		wbuf = gtp_frame_file_realloc(&real_size, strlen(tmpbuf), 0);
+		if (!wbuf)
+			goto out;
+		strcpy(wbuf, tmpbuf);
+		gtp_frame_file_size += strlen(tmpbuf);
+
+		for (tpe = gtp_list; tpe; tpe = tpe->next) {
+			if (tpe->reason != gtp_stop_normal)
+				break;
+		}
+		tmpsize = gtp_get_status(tpe, tmpbuf);
+		wbuf = gtp_frame_file_realloc(&real_size, tmpsize, 0);
+		if (!wbuf)
+			goto out;
+		memcpy(wbuf, tmpbuf, tmpsize);
+		gtp_frame_file_size += tmpsize;
+
+		wbuf = gtp_frame_file_realloc(&real_size, 1, 0);
+		if (!wbuf)
+			goto out;
+		wbuf[0] = '\n';
+		gtp_frame_file_size += 1;
+
+		/* Tval. */
+		for (tvar = gtp_var_list; tvar; tvar = tvar->next) {
+			snprintf(tmpbuf, 200, "tsv %x:%s\n", tvar->num,
+				 tvar->src);
+			wbuf = gtp_frame_file_realloc(&real_size,
+						      strlen(tmpbuf), 0);
+			if (!wbuf)
+				goto out;
+			strcpy(wbuf, tmpbuf);
+			gtp_frame_file_size += strlen(tmpbuf);
+		}
+
+		/* Tracepoint.  */
+		for (tpe = gtp_list; tpe; tpe = tpe->next) {
+			struct action	*ae;
+			struct gtpsrc	*src;
+
+			/* Tpe.  */
+			gtp_report_tracepoint(tpe, tmpbuf);
+			wbuf = gtp_frame_file_realloc(&real_size,
+						      strlen(tmpbuf) + 5, 0);
+			if (!wbuf)
+				goto out;
+			sprintf(wbuf, "tp %s\n", tmpbuf);
+			gtp_frame_file_size += strlen(tmpbuf) + 4;
+			/* Action.  */
+			for (ae = tpe->action_list; ae; ae = ae->next) {
+				gtp_report_action(tpe, ae, tmpbuf);
+				wbuf = gtp_frame_file_realloc
+					   (&real_size, strlen(tmpbuf) + 5, 0);
+				if (!wbuf)
+					goto out;
+				sprintf(wbuf, "tp %s\n", tmpbuf);
+				gtp_frame_file_size += strlen(tmpbuf) + 4;
+			}
+			/* Src.  */
+			for (src = tpe->src; src; src = src->next) {
+				gtp_report_src(tpe, src, tmpbuf);
+				wbuf = gtp_frame_file_realloc
+					   (&real_size, strlen(tmpbuf) + 5, 0);
+				if (!wbuf)
+					goto out;
+				sprintf(wbuf, "tp %s\n", tmpbuf);
+				gtp_frame_file_size += strlen(tmpbuf) + 4;
+			}
+		}
+
+		wbuf = gtp_frame_file_realloc(&real_size, 1, 0);
+		if (!wbuf)
+			goto out;
+		wbuf[0] = '\n';
+		gtp_frame_file_size += 1;
+
+		/* Frame.  */
+		if (atomic_read(&gtp_frame_create) == 0)
+			goto end;
+		frame = gtp_frame_r_start;
+		do {
+			if (frame[0] == 'h') {
+				if (gtp_frame2file(&real_size, frame))
+					goto out;
+			}
+
+			frame = gtp_frame_next(frame);
+			if (!frame)
+				break;
+
+			if (frame == gtp_frame_end)
+				frame = gtp_frame;
+		} while (frame != gtp_frame_w_start);
+
+end:
+		/* End.  */
+		wbuf = gtp_frame_file_realloc(&real_size, tmpsize, 2);
+		if (!wbuf)
+			goto out;
+		wbuf[0] = '\0';
+		wbuf[1] = '\0';
+		gtp_frame_file_size += 2;
+	}
+
+	/* Set buf.  */
+	ret = size;
+	if (*ppos + ret > gtp_frame_file_size) {
+		ret = gtp_frame_file_size - *ppos;
+		if (ret <= 0) {
+			ret = 0;
+			goto out;
+		}
+	}
+	if (copy_to_user(buf, gtp_frame_file + *ppos, ret)) {
+		size = -EFAULT;
+		goto out;
+	}
+	*ppos += ret;
+
+out:
+	up(&gtp_rw_lock);
+	return ret;
+}
+
+static const struct file_operations proc_gtp_operations = {
+	.owner		= THIS_MODULE,
+	.open		= gtp_open,
+	.release	= gtp_release,
+	.unlocked_ioctl	= gtp_ioctl,
+	.compat_ioctl	= gtp_ioctl,
+	.read		= gtp_read,
+	.write		= gtp_write,
+	.poll		= gtp_poll,
+};
+
+static const struct file_operations proc_gtpframe_operations = {
+	.owner		= THIS_MODULE,
+	.read		= gtpframe_read,
+	.llseek		= default_llseek,
+};
+
+static int __init gtp_init(void)
+{
+	int	ret = -ENOMEM;
+
+	gtp_list = NULL;
+	gtp_read_ack = 0;
+	gtp_rw_bufp = NULL;
+	gtp_rw_size = 0;
+	gtp_start = 0;
+	gtp_disconnected_tracing = 0;
+	gtp_circular = 0;
+	gtp_var_list = &gtp_var_current_task;
+	gtp_var_head = GTP_VAR_CURRENT_TASK_ID;
+	gtp_var_tail = GTP_VAR_CURRENT_TASK_ID;
+	gtp_var_array = NULL;
+	current_gtp_var = NULL;
+	gtp_frame = NULL;
+	gtp_frame_r_start = NULL;
+	gtp_frame_w_start = NULL;
+	gtp_frame_end = NULL;
+	gtp_frame_is_circular = 0;
+	gtp_frame_current = NULL;
+	gtp_frame_current_num = 0;
+	atomic_set(&gtp_frame_create, 0);
+	gtp_rw_count = 0;
+	current_gtp = NULL;
+	current_gtp_action = NULL;
+	current_gtp_src = NULL;
+	gtpro_list = NULL;
+	gtp_frame_file = NULL;
+	gtp_frame_file_size = 0;
+
+	gtp_wq = create_singlethread_workqueue("gtpd");
+	if (gtp_wq == NULL)
+		goto out;
+
+	if (proc_create("gtp", S_IFIFO | S_IRUSR | S_IWUSR, NULL,
+			&proc_gtp_operations) == NULL)
+		goto out;
+
+	if (proc_create("gtpframe", S_IFIFO | S_IRUSR, NULL,
+			&proc_gtpframe_operations) == NULL)
+		goto out;
+
+	ret = 0;
+out:
+	if (ret < 0) {
+		if (gtp_wq)
+			destroy_workqueue(gtp_wq);
+		remove_proc_entry("gtp", NULL);
+		remove_proc_entry("gtpframe", NULL);
+	}
+
+	return 0;
+}
+
+static void __exit gtp_exit(void)
+{
+	remove_proc_entry("gtp", NULL);
+	remove_proc_entry("gtpframe", NULL);
+
+	gtp_gdbrsp_qtstop();
+	gtp_gdbrsp_qtinit();
+	if (gtp_frame) {
+		vfree(gtp_frame);
+		gtp_frame = NULL;
+	}
+
+	destroy_workqueue(gtp_wq);
+}
+
+module_init(gtp_init)
+module_exit(gtp_exit)
+
+MODULE_AUTHOR("Hui Zhu");
+MODULE_LICENSE("GPL");
--- /dev/null
+++ b/scripts/getgtprsp.pl
@@ -0,0 +1,76 @@
+#!/usr/bin/perl
+
+# This script to get the GDB tracepoint RSP package and save it
+# to ./gtpstart and ./gtpstop file.
+# GPL
+# Copyright(C) Hui Zhu (teawater@gmail.com), 2010
+
+binmode STDIN, ":raw";
+$| = 1;
+
+$status = 0;
+$circular = 0;
+
+while (1) {
+	sysread STDIN, $c, 1 or next;
+	if ($c eq '') {
+		next;
+	} elsif ($c eq '+' || $c eq '-') {
+		$c = '';
+	}
+
+	sysread STDIN, $line, 1024 or next;
+	print '+';
+	$line = $c.$line;
+
+	open(LOG, ">>./log");
+	print LOG $line."\n";
+	close (LOG);
+
+	if ($status == 0) {
+		if ($line eq '$?#3f') {
+			print '$S05#b8';
+		} elsif ($line eq '$g#67') {
+			print '$00000000#80';
+		} elsif ($line =~ /^\$m/) {
+			print '$00000000#80';
+		} elsif ($line eq '$QTBuffer:circular:1#f9') {
+			print '$OK#9a';
+			$circular = 1;
+		} elsif ($line eq '$QTBuffer:circular:0#f8') {
+			print '$OK#9a';
+			$circular = 0;
+		} elsif ($line eq '$QTStop#4b') {
+			print '$OK#9a';
+		} elsif ($line =~ /^\$qSupported/) {
+			print '$ConditionalTracepoints+;TracepointSource+#1b';
+		} elsif ($line eq '$QTinit#59') {
+			$status = 1;
+			open(STARTFILE, ">./gtpstart");
+			print STARTFILE '$QTDisconnected:1#e3'."\n";
+			if ($circular) {
+				print STARTFILE '$QTBuffer:circular:1#f9'."\n";
+			} else {
+				print STARTFILE '$QTBuffer:circular:0#f8'."\n";
+			}
+		} else {
+			print '$#00';
+		}
+	}
+
+	if ($status == 1) {
+		print '$OK#9a';
+
+		print STARTFILE $line."\n";
+
+		if ($line eq '$QTStart#b3') {
+			$status = 0;
+
+			close(STARTFILE);
+
+			open(STOPFILE, ">./gtpstop");
+			print STOPFILE '$QTStop#4b'."\n";
+			close(STOPFILE);
+		}
+	}
+}
