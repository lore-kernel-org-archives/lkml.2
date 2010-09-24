Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933307Ab0IXQrL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:47:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48613 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932971Ab0IXQrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:47:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=eSQsCJAfUtzBu+qLp3uhxbnMhSD7+KmKw1nO+2vms7X0ptbUHgJGlx3k7bwfrmqDox
         tnnrAiOczqJBB7931x9ffQ5pQpkZFCBsjsD9C9/jVLiqZKGIzB5weEZBP2z5FbufTouU
         mDLP+KQBWoCCPh4yIm6AIbJ+7APYZRRvtMD6c=
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Sat, 25 Sep 2010 00:41:09 +0800
Message-ID: <AANLkTimEc_noHsE7MSA7kVnE3D7t34KPnGp7vTWvhAG_@mail.gmail.com>
Subject: [PATCH] Linux Kernel GDB tracepoint module 2010-9-24 release
To: linux-kernel@vger.kernel.org, "gdb@sourceware.org" <gdb@sourceware.org>
Cc: Michael Snyder <msnyder@vmware.com>,
        Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        Steven <mqyoung@gmail.com>, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KGTP is Linux Kernel GDB tracepoint module.
It make Linux Kernel supply a GDB remote debug interface. Then GDB in
current machine or remote machine(with netcat) can debug Linux through
GDB tracepoint without stop the Linux Kernel.
It support X86-32, X86-64, MIPS and ARM.

Now, the 2010-9-12 release.
http://kgtp.googlecode.com/files/kgtp_20100924.tar.bz2
or
svn co https://kgtp.googlecode.com/svn/tags/20100924

The change of this version is:
Add disconnected-tracing support.
The KGTP will stop and delete the trace frame when GDB disconnect with
it by default.
GDB command "set disconnected-tracing on" will open the KGTP
disconnect-trace. After that, when GDB disconnect with KGTP, KGTP will
not stop trace. And after GDB reconnect to KGTP, it can keep control
the KGTP like nothing happen.

Add trace state variables support.
http://sourceware.org/gdb/current/onlinedocs/gdb/Trace-State-Variables.html
KGTP have a special trace state variable $current_task that point the
curent_task struct.

Add condition support.  It works like GDB breakpoint condition.

Add passcounts support.  It can make tracepoint stop after it trace some times.

Following example that collect what process 2592 read which file and
just 4 times:
(gdb) target remote /proc/gtp
Remote debugging using /proc/gtp
0x0000000000000000 in ?? ()
Created trace state variable $current_task for target's variable 1.
(gdb) trace vfs_read if ((*(struct task_struct *)$current_task)->pid
== 2592 && file->f_path.dentry->d_iname[0])
Tracepoint 1 at 0xffffffff8113724b: file
/home/teawater/kernel/linux-2.6/fs/read_write.c, line 296.
(gdb) passcount 4
Setting tracepoint 1's passcount to 4
(gdb) tvariable $c
Trace state variable $c created, with initial value 0.
(gdb) actions
Enter actions for tracepoint 1, one per line.
End with a line saying just "end".
>teval $c=$c+1
>collect file->f_path.dentry->d_iname
>end
(gdb) tstart
(gdb) info tvariables
Name            Initial     Current
$current_task   0           <unknown>
$c              0           0
(gdb) info tvariables
Name            Initial     Current
$current_task   0           <unknown>
$c              0           4
(gdb) info tvariables
Name            Initial     Current
$current_task   0           <unknown>
$c              0           4
(gdb) tstatus
Trace is running on the target.
Collected 4 trace frames.
Trace buffer has 5241744 bytes of 5242880 bytes free (0% full).
Trace will stop if GDB disconnects.
Not looking at any trace frame.
(gdb) tstop
(gdb) tfind
Found trace frame 0, tracepoint 1
#0  0xffffffff8113724c in vfs_read (file=0xffff880062a91f00,
buf=0x7fff5d88f780 "", count=16, pos=0xffff88007b2b9f48)
    at /home/teawater/kernel/linux-2.6/fs/read_write.c:296
296	{
(gdb) p file->f_path.dentry->d_iname
$1 = "urandom\000dule.so\000\377\377\377\177\377\377\377\377\377\377\377\377\377\377\377\377"
(gdb) tfind
Found trace frame 1, tracepoint 1
0xffffffff8113724c	296	{
(gdb) p file->f_path.dentry->d_iname
$2 = "usercustomize.pyc\000a6\000\210\377\377p'\252\001\000\352\377\377"
(gdb) p file->f_path.dentry->d_iname
$3 = "usercustomize.pyc\000a6\000\210\377\377p'\252\001\000\352\377\377"

Please goto http://code.google.com/p/kgtp/wiki/HOWTO to get more info
about how to use KGTP.

And according to the comments of Christoph.  I make a patch for Linux
Kernel and make it looks OK with checkpatch.pl.

Signed-off-by: Hui Zhu <teawater@gmail.com>

---
 arch/arm/include/asm/gtp.h  |   10
 arch/mips/include/asm/gtp.h |   14
 arch/x86/include/asm/gtp.h  |   14
 lib/Kconfig.debug           |    8
 lib/Makefile                |    2
 lib/gtp.c                   | 3352 ++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 3400 insertions(+)

--- /dev/null
+++ b/arch/arm/include/asm/gtp.h
@@ -0,0 +1,10 @@
+#ifndef _ASM_ARM_GTP_H_
+#define _ASM_ARM_GTP_H_
+
+#define ULONGEST		uint64_t
+#define LONGEST			int64_t
+#define CORE_ADDR		unsigned long
+
+#define GTP_GDBRSP_REG_SIZE	336
+
+#endif
--- /dev/null
+++ b/arch/mips/include/asm/gtp.h
@@ -0,0 +1,14 @@
+#ifndef _ASM_MIPS_GTP_H_
+#define _ASM_MIPS_GTP_H_
+
+#define ULONGEST		uint64_t
+#define LONGEST			int64_t
+#define CORE_ADDR		unsigned long
+
+#ifdef CONFIG_32BIT
+#define GTP_GDBRSP_REG_SIZE	304
+#else
+#define GTP_GDBRSP_REG_SIZE	608
+#endif
+
+#endif
--- /dev/null
+++ b/arch/x86/include/asm/gtp.h
@@ -0,0 +1,14 @@
+#ifndef _ASM_X86_GTP_H_
+#define _ASM_X86_GTP_H_
+
+#define ULONGEST		uint64_t
+#define LONGEST			int64_t
+#define CORE_ADDR		unsigned long
+
+#ifdef CONFIG_X86_32
+#define GTP_GDBRSP_REG_SIZE	128
+#else
+#define GTP_GDBRSP_REG_SIZE	296
+#endif
+
+#endif
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1150,6 +1150,14 @@ config ATOMIC64_SELFTEST

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
@@ -0,0 +1,3352 @@
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
+#define GTP_FRAME_HEAD_SIZE	(1 + sizeof(struct gtp_frame_head))
+#define GTP_FRAME_REG_SIZE	(1 + sizeof(struct gtp_frame_reg))
+#define GTP_FRAME_MEM_SIZE	(1 + sizeof(struct gtp_frame_mem))
+#define GTP_FRAME_VAR_SIZE	(1 + sizeof(struct gtp_frame_var))
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
+struct gtp_frame_head {
+	ULONGEST	trace_num;
+	char		*next;
+};
+
+struct gtp_frame_reg {
+	struct pt_regs	regs;
+	char		*next;
+};
+
+struct gtp_frame_mem {
+	CORE_ADDR	addr;
+	size_t		size;
+	char		*next;
+};
+
+struct gtp_frame_var {
+	unsigned int	num;
+	uint64_t	val;
+	char		*next;
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
+static struct gtp_frame_head	*gtp_frame_current;
+static atomic_t			gtp_frame_create;
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
+		ret = regs->ip;
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
+		ret = regs->ip;
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
+#endif
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
+		/* Release some frame entry to get some place.
+		   XXX:  When support new frame type, need add new handler
+		   to switch.  */
+		while (gtp_frame_w_start <= gtp_frame_r_start
+		       && gtp_frame_w_start + size > gtp_frame_r_start) {
+			switch (gtp_frame_r_start[0]) {
+			case 'h':
+				gtp_frame_r_start += GTP_FRAME_HEAD_SIZE;
+				break;
+			case 'r':
+				gtp_frame_r_start += GTP_FRAME_REG_SIZE;
+				break;
+			case 'm': {
+					struct gtp_frame_mem	*gfm;
+
+					gfm = (struct gtp_frame_mem *)
+						(gtp_frame_r_start + 1);
+					gtp_frame_r_start
+						+= GTP_FRAME_MEM_SIZE;
+					gtp_frame_r_start += gfm->size;
+				}
+				break;
+			case 'v':
+				gtp_frame_r_start += GTP_FRAME_VAR_SIZE;
+				break;
+			case 'z':
+				gtp_frame_r_start = gtp_frame;
+				break;
+			default:
+				goto out;
+				break;
+			}
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
+	struct gtp_frame_head	*head;
+	char			*tmp;
+
+	/* Get the head.  */
+	tmp = gtp_frame_alloc(GTP_FRAME_HEAD_SIZE);
+	if (!tmp) {
+		tpe->reason = gtp_stop_frame_full;
+		return NULL;
+	}
+	tmp[0] = 'h';
+	head = (struct gtp_frame_head *) (tmp + 1);
+	head->trace_num = tpe->num;
+	head->next = NULL;
+
+	atomic_inc(&gtp_frame_create);
+
+	return &head->next;
+}
+
+static char * *
+gtp_action_memory_read(struct pt_regs *regs, struct gtp_entry *tpe,
+			int reg, CORE_ADDR addr, size_t size, char **next)
+{
+	char			*tmp;
+	struct gtp_frame_mem	*fm;
+
+	if (reg >= 0)
+		addr += (CORE_ADDR) gtp_action_reg_read(regs, tpe, reg);
+	if (tpe->reason != gtp_stop_normal)
+		return NULL;
+
+	if (next == NULL) {
+		next = gtp_action_head(tpe);
+		if (!next)
+			return NULL;
+	}
+
+	tmp = gtp_frame_alloc(GTP_FRAME_MEM_SIZE + size);
+	if (!tmp) {
+		tpe->reason = gtp_stop_frame_full;
+		return NULL;
+	}
+	*next = tmp;
+
+	tmp[0] = 'm';
+	tmp++;
+
+	fm = (struct gtp_frame_mem *)tmp;
+	tmp += sizeof(struct gtp_frame_mem);
+	fm->addr = addr;
+	fm->size = size;
+	fm->next = NULL;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_action_memory_read: id:%d %p %u\n",
+	       (int)tpe->num, (void *)addr, (unsigned int)size);
+#endif
+
+	if (probe_kernel_read(tmp, (void *)addr, size)) {
+		tpe->reason = gtp_stop_efault;
+		memset(tmp, 0, size);
+#ifdef GTP_DEBUG
+		printk(GTP_DEBUG "gtp_action_memory_read: id:%d read %p %u "
+				    "get error.\n", (int)tpe->num,
+		       (void *)addr, (unsigned int)size);
+#endif
+		return NULL;
+	}
+
+	return &fm->next;
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
+static char * *
+gtp_action_r(struct pt_regs *regs, struct action *ae, char **next)
+{
+	struct gtp_frame_reg	*freg;
+	char			*tmp;
+
+	tmp = gtp_frame_alloc(GTP_FRAME_REG_SIZE);
+	if (!tmp)
+		return NULL;
+
+	*next = tmp;
+	tmp[0] = 'r';
+	freg = (struct gtp_frame_reg *) (tmp + 1);
+	memcpy(&freg->regs, regs, sizeof(struct pt_regs));
+#ifdef CONFIG_X86_32
+	freg->regs.sp = (unsigned long)&regs->sp;
+#endif	/* CONFIG_X86_32 */
+	freg->next = NULL;
+
+	return &freg->next;
+}
+
+static char * *
+gtp_collect_var(struct gtp_var *tve, char **next)
+{
+	struct gtp_frame_var	*fvar;
+	char			*tmp;
+
+	tmp = gtp_frame_alloc(GTP_FRAME_VAR_SIZE);
+	if (!tmp)
+		return NULL;
+
+	*next = tmp;
+	tmp[0] = 'v';
+	fvar = (struct gtp_frame_var *) (tmp + 1);
+	fvar->num = tve->num;
+	if (tve->num == GTP_VAR_CURRENT_TASK_ID)
+		fvar->val = (uint64_t)get_current();
+	else
+		fvar->val = tve->val;
+	fvar->next = NULL;
+
+	return &fvar->next;
+}
+
+static char * *
+gtp_action_x(struct pt_regs *regs, struct gtp_entry *tpe, struct action *ae,
+	     char **next, int *run)
+{
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
+				next = gtp_action_memory_read
+					 (regs, tpe, -1,
+					  (CORE_ADDR) stack[--sp],
+					  (size_t) top, next);
+				if (!next)
+					goto out;
+				if (--sp >= 0)
+					top = stack[sp];
+			} else
+				goto code_error_out;
+			break;
+		/* trace_quick */
+		case 0x0d:
+			next = gtp_action_memory_read
+				   (regs, tpe, -1, (CORE_ADDR) top,
+				    (size_t) ae->u.exp.buf[pc++], next);
+			if (!next)
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
+			if (arg < (sizeof(LONGEST) * 8)) {
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
+			top = gtp_action_reg_read(regs, tpe, arg);
+			if (tpe->reason != gtp_stop_normal)
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
+			if (arg < (sizeof(LONGEST) * 8))
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
+					top = (uint64_t)get_current();
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
+				if (next == NULL) {
+					next = gtp_action_head(tpe);
+					if (!next)
+						goto out;
+				}
+
+				next = gtp_collect_var(tve, next);
+				if (!next)
+					goto out;
+			}
+			break;
+		}
+
+		if (sp > STACK_MAX - 5) {
+#ifdef GTP_DEBUG
+			printk(GTP_DEBUG "gtp_action_x: stack overflow.\n");
+#endif
+			tpe->reason = gtp_stop_agent_expr_stack_overflow;
+			goto error_out;
+		}
+	}
+code_error_out:
+	tpe->reason = gtp_stop_agent_expr_code_error;
+error_out:
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_action_x: tracepoint %d "
+			    "action X get error in pc %u.\n",
+		(int)tpe->num, pc);
+#endif
+	next = NULL;
+out:
+	if (ae->u.exp.need_var_lock)
+		spin_unlock_irqrestore(&gtp_var_lock, flags);
+	return next;
+}
+
+static int
+gtp_kp_pre_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct gtp_entry	*tpe = container_of(p, struct gtp_entry, kp);
+	struct action		*ae;
+	char			**next = NULL;
+
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_kp_pre_handler: tracepoint %d\n",
+		(int)tpe->num);
+#endif
+
+	if (tpe->kpreg == 0)
+		return 0;
+
+	/* Condition.  */
+	if (tpe->cond) {
+		int	run;
+
+		next = gtp_action_x(regs, tpe, tpe->cond, next, &run);
+		if (tpe->reason != gtp_stop_normal)
+			goto tpe_stop;
+		if (!run)
+			return 0;
+	}
+
+	/* Pass.  */
+	if (!tpe->nopass) {
+		if (atomic_dec_return(&tpe->current_pass) < 0)
+			goto tpe_stop;
+	}
+
+	/* Handle actions.  */
+	for (ae = tpe->action_list; ae; ae = ae->next) {
+		switch (ae->type) {
+		case 'R':
+			if (next == NULL) {
+				next = gtp_action_head(tpe);
+				if (!next)
+					goto tpe_stop;
+			}
+			next = gtp_action_r(regs, ae, next);
+			if (!next) {
+				tpe->reason = gtp_stop_frame_full;
+				goto tpe_stop;
+			}
+			break;
+		case 'X':
+			next = gtp_action_x(regs, tpe, ae, next, NULL);
+			if (tpe->reason != gtp_stop_normal)
+				goto tpe_stop;
+			break;
+		case 'M':
+			next = gtp_action_memory_read
+				(regs, tpe, ae->u.m.regnum,
+				 ae->u.m.offset, ae->u.m.size, next);
+			if (tpe->reason != gtp_stop_normal)
+				goto tpe_stop;
+			break;
+		}
+	}
+
+	return 0;
+
+tpe_stop:
+	tpe->kpreg = 0;
+	queue_work(gtp_wq, &tpe->work);
+#ifdef GTP_DEBUG
+	printk(GTP_DEBUG "gtp_kp_pre_handler: tracepoint %d stop.\n",
+		(int)tpe->num);
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
+	atomic_set(&gtp_frame_create, 0);
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
+	if (gtp_start)
+		return -EBUSY;
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
+				* (gtp_var_tail - gtp_var_head + 1),
+				GFP_KERNEL);
+	if (!gtp_var_array) {
+		gtp_gdbrsp_qtstop();
+		return -ENOMEM;
+	}
+	memset(gtp_var_array, '\0', sizeof(struct gtp_var *)
+				    * (gtp_var_tail - gtp_var_head + 1));
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
+static struct gtp_frame_head *
+gtp_frame_head_find(int num)
+{
+	struct gtp_frame_head	*ret = NULL;
+	char			*tmp;
+	int			tfnum = 0;
+
+	tmp = gtp_frame_r_start;
+
+	if (atomic_read(&gtp_frame_create) == 0)
+		return NULL;
+
+	do {
+		switch (tmp[0]) {
+		/* XXX:  When support new frame type, need add
+		   new handler to switch.  */
+		case 'h':
+			if (tfnum == num) {
+				ret = (struct gtp_frame_head *) (tmp + 1);
+				goto out;
+			}
+			tfnum++;
+			tmp += GTP_FRAME_HEAD_SIZE;
+			break;
+		case 'r':
+			tmp += GTP_FRAME_REG_SIZE;
+			break;
+		case 'm': {
+				struct gtp_frame_mem	*gfm;
+
+				gfm = (struct gtp_frame_mem *)
+					(tmp + 1);
+				tmp += GTP_FRAME_MEM_SIZE;
+				tmp += gfm->size;
+			}
+			break;
+		case 'v':
+			tmp += GTP_FRAME_VAR_SIZE;
+			break;
+		case 'z':
+			tmp = gtp_frame;
+			break;
+		default:
+			goto out;
+			break;
+		}
+
+		if (tmp == gtp_frame_end)
+			tmp = gtp_frame;
+	} while (tmp != gtp_frame_w_start);
+
+out:
+	return ret;
+}
+
+static int
+gtp_gdbrsp_qtframe(char *pkg)
+{
+	if (gtp_start)
+		return -EBUSY;
+
+	if (strncmp(pkg, "pc:", 3) == 0)	/* XXX */
+		return 1;
+	else if (strncmp(pkg, "tdp:", 4) == 0)	/* XXX */
+		return 1;
+	else if (strncmp(pkg, "range:", 6) == 0)	/* XXX */
+		return 1;
+	else if (strncmp(pkg, "outside:", 8) == 0)	/* XXX */
+		return 1;
+	else {
+		ULONGEST		num;
+		struct gtp_frame_head	*ret;
+
+		if (pkg[0] == '\0')
+			return -EINVAL;
+		hex2ulongest(pkg, &num);
+
+#ifdef GTP_DEBUG
+		printk(GTP_DEBUG "gtp_gdbrsp_qtframe: %d\n", (int) num);
+#endif
+		if (((int) num) < 0) {
+			/* Return to current.  */
+			gtp_frame_current = NULL;
+
+			return 0;
+		}
+		ret = gtp_frame_head_find((int) num);
+		if (ret) {
+			gtp_frame_current = ret;
+			sprintf(gtp_rw_bufp, "F%xT%x",
+				 (int) num,
+				 (unsigned int) gtp_frame_current->trace_num);
+			gtp_rw_size += strlen(gtp_rw_bufp);
+			gtp_rw_bufp += strlen(gtp_rw_bufp);
+		} else {
+			strcpy(gtp_rw_bufp, "F-1");
+			gtp_rw_bufp += 3;
+			gtp_rw_size += 3;
+		}
+	}
+
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
+gtp_gdbrsp_qtstatus(void)
+{
+	struct gtp_entry	*tpe;
+	char			*tmp;
+	int			tfnum = 0;
+	unsigned long		flags;
+	CORE_ADDR		tmpaddr;
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
+	if (!gtp_frame) {
+		sprintf(gtp_rw_bufp, "tnotrun:0;");
+		gtp_rw_bufp += 10;
+		gtp_rw_size += 10;
+	} else if (!tpe || (tpe && tpe->reason == gtp_stop_normal)) {
+		sprintf(gtp_rw_bufp, "tstop:0;");
+		gtp_rw_bufp += 8;
+		gtp_rw_size += 8;
+	} else {
+		char	outtmp[100];
+
+		switch (tpe->reason) {
+		case gtp_stop_frame_full:
+			sprintf(gtp_rw_bufp, "tfull:%lx;",
+				(unsigned long)tpe->num);
+			break;
+		case gtp_stop_efault:
+			sprintf(gtp_rw_bufp, "terror:%s:%lx;",
+				string2hex("read memory false", outtmp),
+				(unsigned long)tpe->num);
+			break;
+		case gtp_stop_access_wrong_reg:
+			sprintf(gtp_rw_bufp, "terror:%s:%lx;",
+				string2hex("access wrong register", outtmp),
+				(unsigned long)tpe->num);
+			break;
+		case gtp_stop_agent_expr_code_error:
+			sprintf(gtp_rw_bufp, "terror:%s:%lx;",
+				string2hex("agent expression code error",
+					   outtmp),
+				(unsigned long)tpe->num);
+			break;
+		case gtp_stop_agent_expr_stack_overflow:
+			sprintf(gtp_rw_bufp, "terror:%s:%lx;",
+				string2hex("agent expression stack overflow",
+					   outtmp),
+				(unsigned long)tpe->num);
+			break;
+		default:
+			gtp_rw_bufp[0] = '\0';
+			break;
+		}
+
+		gtp_rw_size += strlen(gtp_rw_bufp);
+		gtp_rw_bufp += strlen(gtp_rw_bufp);
+	}
+
+	if (atomic_read(&gtp_frame_create) == 0)
+		goto out;
+	tmp = gtp_frame_r_start;
+	do {
+		switch (tmp[0]) {
+		/* XXX:  When support new frame type, need add
+		   new handler to switch.  */
+		case 'h':
+			tfnum++;
+			tmp += GTP_FRAME_HEAD_SIZE;
+			break;
+		case 'r':
+			tmp += GTP_FRAME_REG_SIZE;
+			break;
+		case 'm': {
+				struct gtp_frame_mem	*gfm;
+
+				gfm = (struct gtp_frame_mem *)
+					(tmp + 1);
+				tmp += GTP_FRAME_MEM_SIZE;
+				tmp += gfm->size;
+			}
+			break;
+		case 'v':
+			tmp += GTP_FRAME_VAR_SIZE;
+			break;
+		case 'z':
+			tmp = gtp_frame;
+			break;
+		default:
+			goto out;
+		}
+		if (tmp == gtp_frame_end)
+			tmp = gtp_frame;
+	} while (tmp != gtp_frame_w_start);
+out:
+	sprintf(gtp_rw_bufp, "tframes:%x;", tfnum);
+	gtp_rw_size += strlen(gtp_rw_bufp);
+	gtp_rw_bufp += strlen(gtp_rw_bufp);
+
+	sprintf(gtp_rw_bufp, "tcreated:%x;", atomic_read(&gtp_frame_create));
+	gtp_rw_size += strlen(gtp_rw_bufp);
+	gtp_rw_bufp += strlen(gtp_rw_bufp);
+
+	sprintf(gtp_rw_bufp, "tsize:%x;", GTP_FRAME_SIZE);
+	gtp_rw_size += strlen(gtp_rw_bufp);
+	gtp_rw_bufp += strlen(gtp_rw_bufp);
+
+	spin_lock_irqsave(&gtp_frame_lock, flags);
+	tmpaddr = GTP_FRAME_SIZE
+		  - (max(gtp_frame_w_start, gtp_frame_r_start)
+		     - min(gtp_frame_w_start, gtp_frame_r_start));
+	spin_unlock_irqrestore(&gtp_frame_lock, flags);
+	if (tmpaddr == GTP_FRAME_SIZE && atomic_read(&gtp_frame_create) == 0)
+		tmpaddr = 0;
+	sprintf(gtp_rw_bufp, "tfree:%lx;", (unsigned long)tmpaddr);
+	gtp_rw_size += strlen(gtp_rw_bufp);
+	gtp_rw_bufp += strlen(gtp_rw_bufp);
+
+	sprintf(gtp_rw_bufp, "circular:%x;", gtp_circular);
+	gtp_rw_size += strlen(gtp_rw_bufp);
+	gtp_rw_bufp += strlen(gtp_rw_bufp);
+
+	sprintf(gtp_rw_bufp, "disconn:%x", gtp_disconnected_tracing);
+	gtp_rw_size += strlen(gtp_rw_bufp);
+	gtp_rw_bufp += strlen(gtp_rw_bufp);
+
+	return 1;
+}
+
+static void
+gtp_report_tracepoint(void)
+{
+	sprintf(gtp_rw_bufp, "T%lx:%lx:%c:%lx:%lx",
+		(unsigned long)current_gtp->num,
+		(unsigned long)current_gtp->addr,
+		(current_gtp->disable ? 'D' : 'E'),
+		(unsigned long)current_gtp->step,
+		(unsigned long)current_gtp->pass);
+	gtp_rw_size += strlen(gtp_rw_bufp);
+	gtp_rw_bufp += strlen(gtp_rw_bufp);
+}
+
+static void
+gtp_report_action(void)
+{
+	sprintf(gtp_rw_bufp, "A%lx:%lx:%s",
+		(unsigned long)current_gtp->num,
+		(unsigned long)current_gtp->addr,
+		current_gtp_action->src);
+	gtp_rw_size += strlen(gtp_rw_bufp);
+	gtp_rw_bufp += strlen(gtp_rw_bufp);
+}
+
+static void
+gtp_report_src(void)
+{
+	sprintf(gtp_rw_bufp, "Z%lx:%lx:%s",
+		(unsigned long)current_gtp->num,
+		(unsigned long)current_gtp->addr,
+		current_gtp_src->src);
+	gtp_rw_size += strlen(gtp_rw_bufp);
+	gtp_rw_bufp += strlen(gtp_rw_bufp);
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
+		gtp_report_tracepoint();
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
+		gtp_report_action();
+		current_gtp_action = current_gtp_action->next;
+		gtp_current_action_check();
+		goto out;
+	}
+
+	if (current_gtp_src) {
+		gtp_report_src();
+		current_gtp_src = current_gtp_src->next;
+		gtp_current_set_check();
+		goto out;
+	}
+
+	if (current_gtp) {
+		gtp_report_tracepoint();
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
+		struct gtp_frame_reg	*fr;
+		struct gtp_frame_mem	*mr;
+
+		next = gtp_frame_current->next;
+		while (next) {
+			switch (next[0]) {
+			case 'r':
+				fr = (struct gtp_frame_reg *) (next + 1);
+				next = fr->next;
+				break;
+			case 'm':
+				mr = (struct gtp_frame_mem *) (next + 1);
+				next = mr->next;
+				break;
+			case 'v':
+				vr = (struct gtp_frame_var *) (next + 1);
+				if (vr->num == (unsigned int)num)
+					goto while_stop;
+				next = vr->next;
+				vr = NULL;
+				break;
+			default:
+				next = NULL;
+				break;
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
+		char			*next;
+		struct gtpro_entry	*gtroe;
+
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
+
+		next = gtp_frame_current->next;
+		while (next) {
+			struct gtp_frame_reg	*fr;
+			struct gtp_frame_mem	*mr;
+			struct gtp_frame_var	*vr;
+			ULONGEST		cur_start, cur_end;
+			uint8_t			*buf;
+
+			switch (next[0]) {
+			case 'r':
+				fr = (struct gtp_frame_reg *) (next + 1);
+				next = fr->next;
+				break;
+			case 'm':
+				mr = (struct gtp_frame_mem *) (next + 1);
+				buf = next + GTP_FRAME_MEM_SIZE;
+				next = mr->next;
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
+				if (cur_start < cur_end)
+					memcpy(gtp_m_buffer,
+						buf + cur_start - mr->addr,
+						cur_end - cur_start);
+				break;
+			case 'v':
+				vr = (struct gtp_frame_var *) (next + 1);
+				next = vr->next;
+				break;
+			default:
+				next = NULL;
+				break;
+			}
+		}
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
+	char			*next;
+	struct gtp_frame_reg	*fr;
+	struct gtp_frame_mem	*mr;
+	struct gtp_frame_var	*vr;
+
+	if (GTP_RW_MAX - 4 - gtp_rw_size < GTP_GDBRSP_REG_SIZE)
+		return -E2BIG;
+
+	if (gtp_start || !gtp_frame_current)
+		goto empty_out;
+
+	/* Get the fr.  */
+	fr = NULL;
+	next = gtp_frame_current->next;
+	while (next) {
+		switch (next[0]) {
+		case 'r':
+			fr = (struct gtp_frame_reg *) (next + 1);
+			goto check;
+			break;
+		case 'm':
+			mr = (struct gtp_frame_mem *) (next + 1);
+			next = mr->next;
+			break;
+		case 'v':
+			vr = (struct gtp_frame_var *) (next + 1);
+			next = vr->next;
+			break;
+		default:
+			next = NULL;
+			break;
+		}
+	}
+check:
+	if (fr)
+		gtp_regs2ascii(&(fr->regs), gtp_rw_bufp);
+	else {
+empty_out:
+		memset(gtp_rw_bufp, '0', GTP_GDBRSP_REG_SIZE);
+	}
+	gtp_rw_bufp += GTP_GDBRSP_REG_SIZE;
+	gtp_rw_size += GTP_GDBRSP_REG_SIZE;
+
+	return 1;
+}
+
+static DECLARE_MUTEX(gtp_rw_lock);
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
+			if (gtp_frame) {
+				vfree(gtp_frame);
+				gtp_frame = NULL;
+			}
+			gtp_gdbrsp_qtinit();
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
+static int __init gtp_init(void)
+{
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
+	atomic_set(&gtp_frame_create, 0);
+	gtp_rw_count = 0;
+	current_gtp = NULL;
+	current_gtp_action = NULL;
+	current_gtp_src = NULL;
+	gtpro_list = NULL;
+
+	gtp_wq = create_singlethread_workqueue("gtpd");
+	if (gtp_wq == NULL)
+		return -ENOMEM;
+
+	if (proc_create("gtp", S_IFIFO | S_IRUSR | S_IWUSR, NULL,
+			&proc_gtp_operations) == NULL)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void __exit gtp_exit(void)
+{
+	remove_proc_entry("gtp", NULL);
+
+	gtp_gdbrsp_qtstop();
+	if (gtp_frame) {
+		vfree(gtp_frame);
+		gtp_frame = NULL;
+	}
+	gtp_gdbrsp_qtinit();
+
+	destroy_workqueue(gtp_wq);
+}
+
+module_init(gtp_init)
+module_exit(gtp_exit)
+
+MODULE_AUTHOR("Hui Zhu");
+MODULE_LICENSE("GPL");
