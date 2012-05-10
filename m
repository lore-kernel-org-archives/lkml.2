Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759422Ab2EJMQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 08:16:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48443 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492Ab2EJMP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 08:15:57 -0400
Message-ID: <4FABB168.3060000@gmail.com>
Date: Thu, 10 May 2012 20:15:36 +0800
From: Hui Zhu <teawater@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120426 Thunderbird/13.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Geoff Levand <geoff@infradead.org>, jason.wessel@windriver.com
Subject: Re: [PATCH]KGTP (Linux Kernel debugger and tracer) lite patch for
 review
References: <4FAA1953.60102@gmail.com> <20120509140538.GZ27374@one.firstfloor.org>
In-Reply-To: <20120509140538.GZ27374@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/12 22:05, Andi Kleen wrote:
> Please provide better explanation of the use case for this module.
> One paragraph why someone would want it in their kernel.

sudo insmod kernel/gtp.ko
sudo gdb ./vmlinux
#Connect KGTP interface
(gdb) target remote /sys/kernel/debug/gtp
Remote debugging using /sys/kernel/debug/gtp
0x0000000000000000 in irq_stack_union ()
#Access memory directly
(gdb) p jiffies_64
$1 = 4332444293
(gdb) p jiffies_64
$2 = 4332444591
(gdb) p *((struct module *)((char *)modules->next - ((size_t) &(((struct module *)0)->list))))
$3 = {state = MODULE_STATE_LIVE, list = {next = 0xffffffffa0964188, prev = 0xffffffff81c345f0},
   name = "gtp", '\000' <repeats 52 times>, mkobj = {kobj = {name = 0xffff88011f5c49c8 "gtp", entry = {
         next = 0xffff880221cd6420, prev = 0xffffffffa09641d8}, parent = 0xffff880221cd6438, kset = 0xffff880221cd6420,
...
(gdb) p *(struct device *)(__per_cpu_offset[0]+(uint64_t)(&mce_device))
$4 = {parent = 0xffff8802212f8000, p = 0x1fe, kobj = {name = 0x0, entry = {next = 0x0, prev = 0xffffffff8102ae70},
     parent = 0x0, kset = 0x0, ktype = 0x0, sd = 0x0, kref = {refcount = {counter = 0}}, state_initialized = 0,
...
#Set tracepoint to collect the register info of function vfs_read
(gdb) trace vfs_read
Tracepoint 1 at 0xffffffff8117a3d0: file /home/teawater/kernel2/linux/fs/read_write.c, line 365.
(gdb) actions
Enter actions for tracepoint 1, one per line.
End with a line saying just "end".
>collect $reg
>end
(gdb) tstart
(gdb) tstop
(gdb) tfind
Found trace frame 0, tracepoint 1
#0  vfs_read (file=0xffff880070bb6100,
     buf=0x31cb8f0 "$2aa6178136313733#331bb700088ffff481fe4450188ffff002", '0' <repeats 13 times>, "f0b81c03000000000061bb700088ffff781fe4450188ffff301fe4450188ffff606944030000000058f19a010288ffff01", '0' <repeats 14 times>, "4602", '0' <repeats 12 times>, "f0b81c0"..., count=8192, pos=0xffff880145e41f48) at /home/teawater/kernel2/linux/fs/read_write.c:365
365	{
(gdb) info reg
rax            0x0	0
rbx            0xffff880070bb6100	-131939504004864
rcx            0xffff880145e41f48	-131935927787704
rdx            0x2000	8192
rsi            0x31cb8f0	52214000
rdi            0xffff880070bb6100	-131939504004864
rbp            0xffff880145e41f78	0xffff880145e41f78
rsp            0xffff880145e41f30	0xffff880145e41f30
r8             0x3446960	54815072
r9             0xffff8802019af158	-131932778466984
r10            0x1	1
r11            0x246	582
r12            0x31cb8f0	52214000
r13            0x2000	8192
r14            0xa	10
r15            0xa	10
rip            0xffffffff8117a3d0	0xffffffff8117a3d0 <vfs_read>
eflags         0x286	[ PF SF IF ]
cs             0x10	16
ss             0x18	24
ds             *value not available*
es             *value not available*
fs             *value not available*
gs             *value not available*

Because this is a lite patch, so this patch doesn't support other functions of KGTP.

>
>> +++ b/arch/arm/include/asm/gtp.h
>> @@ -0,0 +1,34 @@
>> +#ifndef _ASM_ARM_GTP_H_
>> +#define _ASM_ARM_GTP_H_
>> +
>> +#define ULONGEST		uint64_t
>
> So u64 in kernel. Just use that.
>
>> +#define CORE_ADDR		unsigned long
>
> In linux kernel CORE_ADDR is always unsigned long. Use that.
>

ULONGEST and CORE_ADDR is the type from GDB rsp packet.  I use it to parse the package from GDB.  Then want to add add a new arch to KGTP, just need set this two type same with GDB.  So do you mind I keep it?

>> +
>> +#define GTP_REG_ASCII_SIZE	336
>> +
>> +static inline void
>> +gtp_regs2ascii(struct pt_regs *regs, char *buf)
>> +{
>> +#ifdef __LITTLE_ENDIAN
>> +#define SWAB(a)		swab32(a)
>> +#else
>> +#define SWAB(a)		(a)
>> +#endif
>
> That's just ntohl()? Just use that

It is fixed in new patch.

>
> Linux already has macros for this:
>> +	int	i;
>> +
>> +	for (i = 0; i < 16; i++) {
>> +		sprintf(buf, "%08lx", (unsigned long) SWAB(regs->uregs[i]));
>
> Is the gdb protocol really big endian in ASCII?
>
Yes, I tested this part of code in before.  GDB need it in this format.

> Also could you share code on this with the in kernel gdbstub?

Most of this part of code is deep inside the kgdb c code.  Share these code need change this part of code out of kgdb and something else.

>
>> +#include <linux/slab.h>
>> +#include <asm/gtp.h>
>> +
>> +#define GTP_DEBUG		KERN_WARNING
>
> You should use the pr_* macros now

OK.  I changed all of them to pr_devel.

>
>> +static int			gtp_disconnected_tracing;
>> +static int			gtp_circular;
>> +
>> +static DEFINE_SPINLOCK(gtp_frame_lock);
>
> Every spinlock needs a comment that describes what it protects.
> I believe checkpatch warns about that. Did you run it?

I use it with the patch but didn't get the warn.  It is fixed in the new patch.

>
>> +
>> +	tmp = gtp_frame_alloc(GTP_FRAME_REG_SIZE);
>> +	if (!tmp)
>> +		return NULL;
>> +
>> +	*next = tmp;
>> +	tmp[0] = 'r';
>> +	freg = (struct gtp_frame_reg *) (tmp + 1);
>> +	memcpy(&freg->regs, regs, sizeof(struct pt_regs));
>> +#if !defined CONFIG_X86_32 && !defined CONFIG_X86_64
>> +	freg->regs.sp = (unsigned long)&regs->sp;
>> +#endif	/* CONFIG_X86_32 CONFIG_X86_64 */
>
> That looks weird. What does that do?

Oops, this part of code is worng.(I copy this function from a very old version of KGTP.)
Fixed in new patch.

>
>> +gtp_action_alloc(char type)
>> +{
>> +	struct action	*ret;
>> +
>> +	ret = kmalloc(sizeof(struct action), GFP_KERNEL);
>
> kzalloc

All fixed.
>
> Same problem in others.
>
>> +static int
>> +hex2int(char hex, int *i)
>
> I'm sure we have code for this. strtoul et.al.?

OK.  I changed hex2ulongest to simple_strtoull in new patch.
But I meet a issue is checkpatch told me that "simple_strtoull is obsolete, use kstrtoull instead".  But kstrtoull cannot get the address that where this convert stop at.  Do you have some comments on it?

>
> Didn't read further so far.
>
>
> -Andi
>

Thanks for your help.
I post a new patch according to your comments.  Please help me review it.

Thanks,
Hui

Signed-off-by: Hui Zhu <teawater@gmail.com>
---
  arch/arm/include/asm/gtp.h  |   28 +
  arch/mips/include/asm/gtp.h |   64 +++
  arch/x86/include/asm/gtp.h  |   96 ++++
  kernel/Makefile             |    2
  kernel/gtp.c                |  914 ++++++++++++++++++++++++++++++++++++++++++++
  lib/Kconfig.debug           |    8
  6 files changed, 1112 insertions(+)

--- /dev/null
+++ b/arch/arm/include/asm/gtp.h
@@ -0,0 +1,28 @@
+#ifndef _ASM_ARM_GTP_H_
+#define _ASM_ARM_GTP_H_
+
+#define ULONGEST		uint64_t
+#define CORE_ADDR		unsigned long
+
+#define GTP_REG_ASCII_SIZE	336
+
+static inline void
+gtp_regs2ascii(struct pt_regs *regs, char *buf)
+{
+	int	i;
+
+	for (i = 0; i < 16; i++) {
+		sprintf(buf, "%08lx", (unsigned long) ntohl(regs->uregs[i]));
+		buf += 8;
+	}
+
+	/* f0-f7 fps */
+	memset(buf, '0', 200);
+	buf += 200;
+
+	sprintf(buf, "%08lx",
+		 (unsigned long) ntohl(regs->uregs[16]));
+	buf += 8;
+}
+
+#endif
--- /dev/null
+++ b/arch/mips/include/asm/gtp.h
@@ -0,0 +1,64 @@
+#ifndef _ASM_MIPS_GTP_H_
+#define _ASM_MIPS_GTP_H_
+
+#define ULONGEST		uint64_t
+#define CORE_ADDR		unsigned long
+
+#ifdef CONFIG_32BIT
+#define GTP_REG_ASCII_SIZE	304
+#else
+#define GTP_REG_ASCII_SIZE	608
+#endif
+
+#define GTP_SP_NUM		29
+
+static inline void
+gtp_regs2ascii(struct pt_regs *regs, char *buf)
+{
+#ifdef CONFIG_32BIT
+#define OUTFORMAT	"%08lx"
+#define REGSIZE		8
+#define SWAB(a)		ntohl(a)
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
+#endif
--- /dev/null
+++ b/arch/x86/include/asm/gtp.h
@@ -0,0 +1,96 @@
+#ifndef _ASM_X86_GTP_H_
+#define _ASM_X86_GTP_H_
+
+#define ULONGEST		uint64_t
+#define CORE_ADDR		unsigned long
+
+#ifdef CONFIG_X86_32
+#define GTP_REG_ASCII_SIZE	128
+#else
+#define GTP_REG_ASCII_SIZE	296
+#endif
+
+static inline void
+gtp_regs2ascii(struct pt_regs *regs, char *buf)
+{
+#ifdef CONFIG_X86_32
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
+#endif
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -107,6 +107,8 @@ obj-$(CONFIG_PADATA) += padata.o
  obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
  obj-$(CONFIG_JUMP_LABEL) += jump_label.o
  
+obj-$(CONFIG_GTP) += gtp.o
+
  $(obj)/configs.o: $(obj)/config_data.h
  
  # config_data.h contains the same information as ikconfig.h but gzipped.
--- /dev/null
+++ b/kernel/gtp.c
@@ -0,0 +1,914 @@
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
+ * Copyright(C) KGTP team (https://code.google.com/p/kgtp/), 2010, 2011, 2012
+ *
+ */
+
+#include <linux/version.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <linux/vmalloc.h>
+#include <linux/poll.h>
+#include <linux/kprobes.h>
+#include <linux/interrupt.h>
+#include <linux/debugfs.h>
+#include <linux/slab.h>
+#include <asm/gtp.h>
+
+#define GTP_RW_MAX		16384
+
+#define GTP_FRAME_SIZE		5242880
+#define GTP_FRAME_HEAD_SIZE	(1 + sizeof(struct gtp_frame_head))
+#define GTP_FRAME_REG_SIZE	(1 + sizeof(struct gtp_frame_reg))
+
+#define TOHEX(h)		((h) > 9 ? (h) + 'a' - 10 : (h) + '0')
+
+struct action {
+	struct action	*next;
+	char		type;
+	union {
+		ULONGEST	reg_mask;
+	} u;
+};
+
+struct gtp_entry {
+	struct gtp_entry	*next;
+	ULONGEST		num;
+	ULONGEST		addr;
+	ULONGEST		step;
+	ULONGEST		pass;
+	int			nopass;
+	int			kpreg;
+	struct kprobe		kp;
+	struct action		*action_list;
+	struct action		*action_list_tail;
+} *gtp_list = NULL, *gtp_list_tail = NULL;
+
+struct gtp_frame_head {
+	int		frame_num;
+	ULONGEST	trace_num;
+	char		*next;
+};
+
+struct gtp_frame_reg {
+	struct pt_regs	regs;
+	char		*next;
+};
+
+static atomic_t			gtp_count;
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
+/* This spin_lock protects the gtp_frame.  */
+static DEFINE_SPINLOCK(gtp_frame_lock);
+static int			gtp_frame_num;
+static char			*gtp_frame;
+static char			*gtp_frame_r_start;
+static char			*gtp_frame_w_start;
+static char			*gtp_frame_w_end;
+static char			*gtp_frame_r_cache;
+static int			gtp_frame_is_circular;
+static struct gtp_frame_head	*gtp_frame_current;
+
+static char *
+gtp_frame_alloc(size_t size)
+{
+	char	*ret = NULL;
+
+	if (size > GTP_FRAME_SIZE)
+		return NULL;
+
+	spin_lock(&gtp_frame_lock);
+
+	if (gtp_frame_w_start + size > gtp_frame_w_end) {
+		if (gtp_circular) {
+			gtp_frame_is_circular = 1;
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
+		while (gtp_frame_w_start + size > gtp_frame_r_start) {
+			switch (gtp_frame_r_start[0]) {
+			case 'h':
+				gtp_frame_r_start += GTP_FRAME_HEAD_SIZE;
+				break;
+			case 'r':
+				gtp_frame_r_start += GTP_FRAME_REG_SIZE;
+				break;
+			default:
+				goto out;
+			}
+		}
+	}
+
+	ret = gtp_frame_w_start;
+	gtp_frame_w_start += size;
+
+out:
+	spin_unlock(&gtp_frame_lock);
+	return ret;
+}
+
+static inline char **
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
+#ifdef CONFIG_X86
+	freg->regs.ip -= 1;
+#endif	/* CONFIG_X86 */
+	freg->next = NULL;
+
+	return &freg->next;
+}
+
+static int
+gtp_kp_pre_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct gtp_entry	*tpe = container_of(p, struct gtp_entry, kp);
+	struct gtp_frame_head	*head;
+	char			*tmp;
+	struct action		*ae;
+	char			**next;
+
+	pr_devel("gtp_kp_pre_handler: tracepoint %d\n", (int)tpe->num);
+
+	/* Get the head.  */
+	tmp = gtp_frame_alloc(GTP_FRAME_HEAD_SIZE);
+	if (!tmp)
+		goto no_memory;
+	tmp[0] = 'h';
+	head = (struct gtp_frame_head *) (tmp + 1);
+	/* Get a new frame num from gtp_frame_num.  */
+	spin_lock(&gtp_frame_lock);
+	if (gtp_frame_num < 0)
+		gtp_frame_num = head->frame_num = 0;
+	else
+		head->frame_num = gtp_frame_num++;
+	spin_unlock(&gtp_frame_lock);
+	head->trace_num = tpe->num;
+	head->next = NULL;
+	next = &head->next;
+
+	/* Handle actions.  */
+	for (ae = tpe->action_list; ae; ae = ae->next) {
+		switch (ae->type) {
+		case 'r':
+			next = gtp_action_r(regs, ae, next);
+			if (!next)
+				goto no_memory;
+			break;
+		}
+	}
+
+	return 0;
+
+no_memory:
+	pr_devel("gtp_kp_pre_handler: tracepoint %d no memory.\n",
+		 (int)tpe->num);
+	return 0;
+}
+
+static struct action *
+gtp_action_alloc(char type)
+{
+	struct action	*ret;
+
+	ret = kzalloc(sizeof(struct action), GFP_KERNEL);
+	if (!ret)
+		goto out;
+
+	ret->type = type;
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
+		kfree(ae2);
+	}
+}
+
+static struct gtp_entry *
+gtp_list_add(ULONGEST num, ULONGEST addr)
+{
+	struct gtp_entry	*ret = kzalloc(sizeof(struct gtp_entry),
+					       GFP_KERNEL);
+
+	if (!ret)
+		goto out;
+	ret->num = num;
+	ret->addr = addr;
+	ret->kp.addr = (kprobe_opcode_t *) (CORE_ADDR)addr;
+	ret->kp.pre_handler = gtp_kp_pre_handler;
+
+	/* Add to gtp_list.  */
+	if (!gtp_list) {
+		gtp_list = ret;
+		gtp_list_tail = ret;
+	} else {
+		gtp_list_tail->next = ret;
+		gtp_list_tail = ret;
+	}
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
+	struct gtp_entry	*tpe, *tpe2;
+
+	tpe = gtp_list;
+	while (tpe) {
+		tpe2 = tpe;
+		tpe = tpe->next;
+		/* Release tpe2.  */
+		gtp_action_release(tpe2->action_list);
+		kfree(tpe2);
+	}
+	gtp_list = NULL;
+	gtp_list_tail = NULL;
+}
+
+static void
+gtp_frame_reset(void)
+{
+	gtp_frame_num = 0;
+	gtp_frame_r_start = gtp_frame;
+	gtp_frame_w_start = gtp_frame;
+	gtp_frame_w_end = gtp_frame + GTP_FRAME_SIZE;
+	gtp_frame_is_circular = 0;
+	gtp_frame_r_cache = NULL;
+	gtp_frame_current = NULL;
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
+	return 0;
+}
+
+static int
+gtp_gdbrsp_qtdp(char *pkg)
+{
+	int			addnew = 1;
+	ULONGEST		num, addr;
+	struct gtp_entry	*tpe;
+
+	pr_devel("gtp_gdbrsp_qtdp: %s\n", pkg);
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
+	num = simple_strtoull(pkg, &pkg, 16);
+	if (pkg[0] == '\0')
+		return -EINVAL;
+	pkg++;
+	addr = simple_strtoull(pkg, &pkg, 16);
+	if (pkg[0] == '\0')
+		return -EINVAL;
+	pkg++;
+
+	tpe = gtp_list_find(num, addr);
+	if (addnew) {
+		if (tpe)
+			return -EINVAL;
+		if (pkg[0] == 'D')
+			return 0;
+		if (pkg[0] == '\0')
+			return -EINVAL;
+		pkg++;
+
+		tpe = gtp_list_add(num, addr);
+		if (tpe == NULL)
+			return -ENOMEM;
+
+		/* Get step and pass.  */
+		if (pkg[0] == '\0')
+			return -EINVAL;
+		pkg++;
+		tpe->step = simple_strtoull(pkg, &pkg, 16);
+		if (pkg[0] == '\0')
+			return -EINVAL;
+		pkg++;
+		tpe->pass = simple_strtoull(pkg, &pkg, 16);
+		if (tpe->pass == 0)
+			tpe->nopass = 1;
+	} else if (tpe) {
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
+			struct action	*ae;
+
+			switch (pkg[0]) {
+			case 'R':
+				/* XXX: reg_mask is ignore.  */
+				ae = gtp_action_alloc(pkg[0]);
+				if (!ae)
+					return -ENOMEM;
+				pkg++;
+				ae->type = 'r';
+				ae->u.reg_mask = simple_strtoull(pkg, &pkg, 16);
+				break;
+			default:
+				/* XXX: Not support.  */
+				return 1;
+			}
+
+			if (ae) {
+				/* Add ae to tpe.  */
+				if (!tpe->action_list) {
+					tpe->action_list = ae;
+					tpe->action_list_tail = ae;
+				} else {
+					tpe->action_list_tail->next = ae;
+					tpe->action_list_tail = ae;
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
+gtp_gdbrsp_qtdisconnected(char *pkg)
+{
+	ULONGEST setting;
+
+	if (gtp_start)
+		return -EBUSY;
+	if (pkg[0] == '\0')
+		return -EINVAL;
+
+	setting = simple_strtoull(pkg, NULL, 16);
+	gtp_disconnected_tracing = (int) setting;
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
+		setting = simple_strtoull(pkg, NULL, 16);
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
+
+	if (gtp_frame_r_cache) {
+		tmp = gtp_frame_r_cache;
+
+		while (tmp < gtp_frame_w_start) {
+			switch (tmp[0]) {
+			case 'h':
+				ret = (struct gtp_frame_head *)(tmp + 1);
+				goto cache_check;
+				break;
+			case 'r':
+				tmp += GTP_FRAME_REG_SIZE;
+				break;
+			default:
+				goto cache_check;
+				break;
+			}
+		}
+
+cache_check:
+		if (ret && ret->frame_num == num)
+			goto out;
+	}
+
+	tmp = gtp_frame_r_start;
+	while (tmp < gtp_frame_w_start) {
+		switch (tmp[0]) {
+		case 'h':
+			ret = (struct gtp_frame_head *) (tmp + 1);
+			if (ret->frame_num == num)
+				goto out;
+			ret = NULL;
+			tmp += GTP_FRAME_HEAD_SIZE;
+			break;
+		case 'r':
+			tmp += GTP_FRAME_REG_SIZE;
+			break;
+		default:
+			goto out;
+		}
+	}
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
+		num = simple_strtoull(pkg, NULL, 16);
+
+		pr_devel("gtp_gdbrsp_qtframe: %d\n", (int) num);
+
+		if (((int) num) < 0) {
+			/* Return to current.  */
+			gtp_frame_current = NULL;
+
+			return 0;
+		}
+		ret = gtp_frame_head_find((int) num);
+		if (ret) {
+			gtp_frame_current = ret;
+			gtp_frame_r_cache = (char *)ret;
+			gtp_frame_r_cache += sizeof(struct gtp_frame_head);
+			sprintf(gtp_rw_bufp, "F%xT%x",
+				gtp_frame_current->frame_num,
+				(unsigned int)gtp_frame_current->trace_num);
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
+gtp_gdbrsp_qtstop(void)
+{
+	struct gtp_entry	*tpe;
+
+	if (!gtp_start)
+		return -EBUSY;
+
+	for (tpe = gtp_list; tpe; tpe = tpe->next) {
+		if (tpe->kpreg) {
+			unregister_kprobe(&tpe->kp);
+			tpe->kpreg = 0;
+		}
+	}
+
+	gtp_start = 0;
+
+	return 0;
+}
+
+static int
+gtp_gdbrsp_qtstart(void)
+{
+	struct gtp_entry	*tpe;
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
+	for (tpe = gtp_list; tpe; tpe = tpe->next) {
+		if (tpe->action_list) {
+			int	ret = register_kprobe(&tpe->kp);
+			if (ret < 0) {
+				gtp_gdbrsp_qtstop();
+				return ret;
+			}
+			tpe->kpreg = 1;
+		}
+	}
+
+	gtp_start = 1;
+
+	return 0;
+}
+
+static int
+gtp_gdbrsp_QT(char *pkg)
+{
+	int	ret = 1;
+
+	pr_devel("gtp_gdbrsp_QT: %s\n", pkg);
+
+	if (strcmp("init", pkg) == 0)
+		ret = gtp_gdbrsp_qtinit();
+	else if (strncmp("DP:", pkg, 3) == 0)
+		ret = gtp_gdbrsp_qtdp(pkg + 3);
+	else if (strncmp("Disconnected:", pkg, 13) == 0)
+		ret = gtp_gdbrsp_qtdisconnected(pkg + 13);
+	else if (strncmp("Buffer:", pkg, 7) == 0)
+		ret = gtp_gdbrsp_qtbuffer(pkg + 7);
+	else if (strncmp("Frame:", pkg, 6) == 0)
+		ret = gtp_gdbrsp_qtframe(pkg + 6);
+	else if (strcmp("Start", pkg) == 0)
+		ret = gtp_gdbrsp_qtstart();
+	else if (strcmp("Stop", pkg) == 0)
+		ret = gtp_gdbrsp_qtstop();
+
+	return ret;
+}
+
+static unsigned char	gtp_m_buffer[0xffff];
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
+	addr = simple_strtoull(pkg, &pkg, 16);
+	if (pkg[0] != ',')
+		return -EINVAL;
+	pkg++;
+	len = simple_strtoull(pkg, &pkg, 16);
+	if (len == 0)
+		return -EINVAL;
+	len &= 0xffff;
+	len = (ULONGEST) min((int)((GTP_RW_MAX - 4 - gtp_rw_size) / 2),
+			     (int)len);
+
+	pr_devel("gtp_gdbrsp_m: addr = 0x%lx len = %d\n",
+		 (unsigned long) addr, (int) len);
+
+	if (probe_kernel_read(gtp_m_buffer, (void *)(CORE_ADDR)addr,
+			      (size_t)len))
+		return -EFAULT;
+
+	for (i = 0; i < (int)len; i++) {
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
+	struct gtp_frame_reg	*fr = NULL;
+
+	if (GTP_RW_MAX - 4 - gtp_rw_size < GTP_REG_ASCII_SIZE)
+		return -E2BIG;
+
+	if (gtp_start || !gtp_frame_current)
+		goto check;
+
+	/* Get the fr.  */
+	next = gtp_frame_current->next;
+	while (next) {
+		switch (next[0]) {
+		case 'r':
+			fr = (struct gtp_frame_reg *) (next + 1);
+			goto check;
+			break;
+		default:
+			next = NULL;
+			break;
+		}
+	}
+check:
+	if (fr)
+		gtp_regs2ascii(&fr->regs, gtp_rw_bufp);
+	else
+		memset(gtp_rw_bufp, '0', GTP_REG_ASCII_SIZE);
+	gtp_rw_bufp += GTP_REG_ASCII_SIZE;
+	gtp_rw_size += GTP_REG_ASCII_SIZE;
+	return 1;
+}
+
+static int
+gtp_open(struct inode *inode, struct file *file)
+{
+	if (atomic_inc_return(&gtp_count) > 1) {
+		atomic_dec(&gtp_count);
+		return -EBUSY;
+	}
+
+	gtp_read_ack = 0;
+	gtp_rw_buf = vmalloc(GTP_RW_MAX);
+	if (!gtp_rw_buf)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int
+gtp_release(struct inode *inode, struct file *file)
+{
+	vfree(gtp_rw_buf);
+
+	/* XXX:  not handle gtp_disconnected_tracing.  */
+	gtp_gdbrsp_qtstop();
+	gtp_gdbrsp_qtinit();
+	vfree(gtp_frame);
+	gtp_frame = NULL;
+
+	atomic_dec(&gtp_count);
+
+	return 0;
+}
+
+static long
+gtp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	/* This function will make GDB happy.  */
+	pr_devel("gtp_ioctl: %x\n", cmd);
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
+	size = min_t(size_t, size, GTP_RW_MAX);
+	if (copy_from_user(gtp_rw_buf, buf, size))
+		return -EFAULT;
+
+	if (gtp_rw_buf[0] == '+' || gtp_rw_buf[0] == '-'
+	    || gtp_rw_buf[0] == '\3')
+		goto out;
+
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
+			pr_devel("gtp_write: crc error\n");
+			gtp_read_ack = '-';
+			goto out;
+		}
+	} else {
+		pr_devel("gtp_write: format error\n");
+		gtp_read_ack = '-';
+		goto out;
+	}
+	gtp_read_ack = '+';
+
+	pr_devel("gtp_write: %s\n", rsppkg);
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
+	return size;
+}
+
+static ssize_t
+gtp_read(struct file *file, char __user *buf, size_t size,
+	 loff_t *ppos)
+{
+	if (gtp_read_ack) {
+		int err = put_user(gtp_read_ack, buf);
+		if (err)
+			return -err;
+		gtp_read_ack = 0;
+		return 1;
+	}
+
+	size = min(gtp_rw_size, size);
+
+	if (copy_to_user(buf, gtp_rw_bufp, size))
+		return -EFAULT;
+	gtp_rw_bufp += size;
+	gtp_rw_size -= size;
+
+	return size;
+}
+
+static const struct file_operations gtp_operations = {
+	.owner		= THIS_MODULE,
+	.open		= gtp_open,
+	.release	= gtp_release,
+	.unlocked_ioctl	= gtp_ioctl,
+	.compat_ioctl	= gtp_ioctl,
+	.read		= gtp_read,
+	.write		= gtp_write,
+};
+
+struct dentry	*gtp_dir;
+
+static int __init gtp_init(void)
+{
+	atomic_set(&gtp_count, 0);
+	gtp_read_ack = 0;
+	gtp_rw_buf = NULL;
+	gtp_rw_bufp = NULL;
+	gtp_rw_size = 0;
+	gtp_start = 0;
+	gtp_disconnected_tracing = 0;
+	gtp_circular = 0;
+	gtp_frame_num = 0;
+	gtp_frame = NULL;
+	gtp_frame_r_start = NULL;
+	gtp_frame_w_start = NULL;
+	gtp_frame_w_end = NULL;
+	gtp_frame_r_cache = NULL;
+	gtp_frame_is_circular = 0;
+	gtp_frame_current = NULL;
+
+	gtp_dir = debugfs_create_file("gtp", S_IFIFO | S_IRUSR | S_IWUSR, NULL,
+				      NULL, &gtp_operations);
+	if (gtp_dir == NULL || gtp_dir == ERR_PTR(-ENODEV))
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void __exit gtp_exit(void)
+{
+	if (gtp_dir)
+		debugfs_remove_recursive(gtp_dir);
+}
+
+module_init(gtp_init)
+module_exit(gtp_exit)
+
+MODULE_AUTHOR("Hui Zhu <teawater@gmail.com>");
+MODULE_LICENSE("GPL");
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1289,6 +1289,14 @@ config ASYNC_RAID6_TEST
  
  	  If unsure, say N.
  
+config GTP
+	tristate "GDB tracepoint support"
+	depends on X86 || ARM || MIPS
+	select KPROBES
+	select DEBUG_FS
+	---help---
+	  Supply GDB tracepoint interface in /sys/kernel/debug/gtp.
+
  source "samples/Kconfig"
  
  source "lib/Kconfig.kgdb"
