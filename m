Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760902Ab2EJRi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:38:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34840 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760862Ab2EJRiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:38:13 -0400
Date: Thu, 10 May 2012 19:38:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hui Zhu <teawater@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Geoff Levand <geoff@infradead.org>, jason.wessel@windriver.com
Subject: Re: [PATCH]KGTP (Linux Kernel debugger and tracer) lite patch for review
Message-ID: <20120510173808.GA27374@one.firstfloor.org>
References: <4FAA1953.60102@gmail.com> <20120509140538.GZ27374@one.firstfloor.org> <4FABB168.3060000@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FABB168.3060000@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 08:15:36PM +0800, Hui Zhu wrote:
> On 05/09/12 22:05, Andi Kleen wrote:
> >Please provide better explanation of the use case for this module.
> >One paragraph why someone would want it in their kernel.
> 
> sudo insmod kernel/gtp.ko

Thanks. Please put that into the change log for the next iteration.

> >>+#ifndef _ASM_ARM_GTP_H_
> >>+#define _ASM_ARM_GTP_H_
> >>+
> >>+#define ULONGEST		uint64_t
> >
> >So u64 in kernel. Just use that.
> >
> >>+#define CORE_ADDR		unsigned long
> >
> >In linux kernel CORE_ADDR is always unsigned long. Use that.
> >
> 
> ULONGEST and CORE_ADDR is the type from GDB rsp packet.  I use it to parse 
> the package from GDB.  Then want to add add a new arch to KGTP, just need 
> set this two type same with GDB.  So do you mind I keep it?

I was just aiming to eliminate the asm files. Is that possible?
If you can't please reuse stuff from kgdb.

> OK.  I changed hex2ulongest to simple_strtoull in new patch.
> But I meet a issue is checkpatch told me that "simple_strtoull is 
> obsolete, use kstrtoull instead".  But kstrtoull cannot get the address 
> that where this convert stop at.  Do you have some comments on it?

Keep using simple_strtoull.  Ignore checkpatch when it's wrong.  

> +static inline void
> +gtp_regs2ascii(struct pt_regs *regs, char *buf)
> +{
> +#ifdef CONFIG_32BIT

BITS_PER_LONG == 32 ? Then it would work on other archs and you could
move it out from asm/

> +#define OUTFORMAT	"%08lx"
> +#define REGSIZE		8
> +#define SWAB(a)		ntohl(a)
> +#else
> +#define OUTFORMAT	"%016lx"
> +#define REGSIZE		16
> +#ifdef __LITTLE_ENDIAN
> +#define SWAB(a)		swab64(a)
> +#else
> +#define SWAB(a)		(a)
> +#endif

be64_to_cpu()

> @@ -0,0 +1,914 @@
> +/*
> + * Kernel GDB tracepoint module.

add one sentence here what this file does.

> +	memcpy(&freg->regs, regs, sizeof(struct pt_regs));
> +#ifdef CONFIG_X86_32
> +	freg->regs.sp = (unsigned long)&regs->sp;
> +#endif	/* CONFIG_X86_32 */
> +#ifdef CONFIG_X86
> +	freg->regs.ip -= 1;
> +#endif	/* CONFIG_X86 */

What is that for? - 1?

> +
> +static void
> +gtp_action_release(struct action *ae)

Standard style is type on the same line.

> +{
> +	struct action	*ae2;
> +
> +	while (ae) {
> +		ae2 = ae;
> +		ae = ae->next;
> +		/* Release ae2.  */
> +		kfree(ae2);
> +	}

Better use a list_head from list.h and list_for_each_entry_safe() etc.
This will simplify some of the list code.

> +static int
> +gtp_gdbrsp_qtstart(void)
> +{
> +	struct gtp_entry	*tpe;
> +
> +	if (gtp_start)
> +		return -EBUSY;

This is in a lot of places. Can you put it somewhere more central?
> +	if (!gtp_frame) {
> +		gtp_frame = vmalloc(GTP_FRAME_SIZE);
> +		if (!gtp_frame)
> +			return -ENOMEM;
> +
> +		gtp_frame_reset();
> +	}
> +
> +	for (tpe = gtp_list; tpe; tpe = tpe->next) {
> +		if (tpe->action_list) {
> +			int	ret = register_kprobe(&tpe->kp);
> +			if (ret < 0) {
> +				gtp_gdbrsp_qtstop();
> +				return ret;

memory leak with frame?

> +	pr_devel("gtp_gdbrsp_QT: %s\n", pkg);
> +
> +	if (strcmp("init", pkg) == 0)
> +		ret = gtp_gdbrsp_qtinit();

This if cascade should be probably a table walk 

> +	else if (strcmp("Stop", pkg) == 0)
> +		ret = gtp_gdbrsp_qtstop();
> +
> +	return ret;
> +}
> +
> +static unsigned char	gtp_m_buffer[0xffff];

Ok so what lock protects this buffer?

> +	struct gtp_frame_reg	*fr = NULL;
> +
> +	if (GTP_RW_MAX - 4 - gtp_rw_size < GTP_REG_ASCII_SIZE)
> +		return -E2BIG;

The magic 4 should be a define

> +	next = gtp_frame_current->next;
> +	while (next) {
> +		switch (next[0]) {
> +		case 'r':
> +			fr = (struct gtp_frame_reg *) (next + 1);
> +			goto check;
> +			break;

either check or break, but not both

> +		default:
> +			next = NULL;

Not needed 
> +			break;
> +		}
> +	}
> +check:
> +	if (fr)
> +		gtp_regs2ascii(&fr->regs, gtp_rw_bufp);
> +	else
> +		memset(gtp_rw_bufp, '0', GTP_REG_ASCII_SIZE);

No 0 termination?

> +
> +static int
> +gtp_open(struct inode *inode, struct file *file)
> +{
> +	if (atomic_inc_return(&gtp_count) > 1) {
> +		atomic_dec(&gtp_count);
> +		return -EBUSY;
> +	}

This looks racy. Better use a try mutex lock

> +static int __init gtp_init(void)
> +{
> +	atomic_set(&gtp_count, 0);
> +	gtp_read_ack = 0;
> +	gtp_rw_buf = NULL;
> +	gtp_rw_bufp = NULL;
> +	gtp_rw_size = 0;
> +	gtp_start = 0;
> +	gtp_disconnected_tracing = 0;
> +	gtp_circular = 0;
> +	gtp_frame_num = 0;
> +	gtp_frame = NULL;
> +	gtp_frame_r_start = NULL;
> +	gtp_frame_w_start = NULL;
> +	gtp_frame_w_end = NULL;
> +	gtp_frame_r_cache = NULL;
> +	gtp_frame_is_circular = 0;
> +	gtp_frame_current = NULL;

Globals don't need to be initialized with 0

>  
> +config GTP
> +	tristate "GDB tracepoint support"
> +	depends on X86 || ARM || MIPS
> +	select KPROBES
> +	select DEBUG_FS
> +	---help---
> +	  Supply GDB tracepoint interface in /sys/kernel/debug/gtp.

Need far more description here. Write 1-2 paragraphs why a user
wants this. checkpatch should have warned.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
