Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab0KTDUO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 22:20:14 -0500
Received: from smtp.outflux.net ([198.145.64.163]:47393 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757765Ab0KTDUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 22:20:12 -0500
Date: Fri, 19 Nov 2010 19:18:20 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Marcus Meissner <meissner@suse.de>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        tj@kernel.org, akpm@osdl.org, hpa@zytor.com, w@1wt.eu,
        alan@lxorguk.ukuu.org.uk, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
Message-ID: <20101120031820.GC4617@outflux.net>
References: <20101116104600.GA24015@suse.de>
 <20101117050759.GE22651@bombadil.infradead.org>
 <20101118074804.GC32621@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118074804.GC32621@elte.hu>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 08:48:04AM +0100, Ingo Molnar wrote:
> Agreed. A few other kernel address things that should be hidden are:
> [snip]

For reference, here's what GRKERNSEC_HIDESYM looks like in grsecurity.
It's quite a sledgehammer, but it does help to point out at least the
minimum number of things that need fixing.

And, more directly related to this thread, kallsyms hiding is implemented
in s_show instead of via DAC:


@@ -464,6 +467,11 @@ static int s_show(struct seq_file *m, vo
 {
    struct kallsym_iter *iter = m->private;
 
+#ifdef CONFIG_GRKERNSEC_HIDESYM
+   if (current_uid())
+       return 0;
+#endif
+
    /* Some debugging symbols have no name.  Ignore them. */
    if (!iter->name[0])
        return 0;

Here's the rest, manually extracted, untested, etc...

---
 arch/powerpc/kernel/process.c    |   10 +++++-----
 arch/sparc/kernel/process_32.c   |    8 ++++----
 arch/sparc/kernel/process_64.c   |    8 ++++----
 arch/sparc/kernel/traps_32.c     |    2 +-
 arch/sparc/kernel/traps_64.c     |   22 +++++++++++-----------
 arch/sparc/kernel/unaligned_64.c |    2 +-
 arch/sparc/mm/fault_64.c         |    2 +-
 arch/x86/kernel/dumpstack.c      |    2 +-
 drivers/message/fusion/mptbase.c |    5 +++++
 fs/proc/array.c                  |    6 ++++++
 fs/proc/base.c                   |   12 ++++++------
 fs/proc/kcore.c                  |    3 +++
 include/linux/kallsyms.h         |   11 ++++++++++-
 kernel/configs.c                 |    6 ++++++
 kernel/kallsyms.c                |   10 +++++++++-
 kernel/module.c                  |    5 +++++
 kernel/panic.c                   |    5 +++--
 kernel/time/timer_list.c         |    8 ++++++++
 kernel/time/timer_stats.c        |    4 ++++
 lib/Kconfig.debug                |    1 +
 lib/vsprintf.c                   |   16 ++++++++++++++--
 mm/kmemleak.c                    |    2 +-
 mm/slub.c                        |    2 +-
 net/atm/proc.c                   |    5 +++++
 net/ipv4/inet_diag.c             |   21 +++++++++++++++++++++
 net/ipv4/tcp_ipv4.c              |   19 +++++++++++++++++--
 net/ipv4/udp.c                   |    7 ++++++-
 net/ipv6/raw.c                   |    8 +++++++-
 net/ipv6/tcp_ipv6.c              |   23 ++++++++++++++++++++---
 net/ipv6/udp.c                   |    7 ++++++-
 net/key/af_key.c                 |    4 ++++
 net/netlink/af_netlink.c         |    8 ++++++++
 net/packet/af_packet.c           |    4 ++++
 net/phonet/socket.c              |    7 ++++++-
 net/sctp/proc.c                  |   14 ++++++++++++--
 net/unix/af_unix.c               |    4 ++++
 36 files changed, 230 insertions(+), 53 deletions(-)


diff -urNp linux-2.6.36/drivers/message/fusion/mptbase.c linux-2.6.36/drivers/message/fusion/mptbase.c
--- linux-2.6.36/drivers/message/fusion/mptbase.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/drivers/message/fusion/mptbase.c	2010-11-06 19:06:37.000000000 -0400
@@ -6681,8 +6681,13 @@ static int mpt_iocinfo_proc_show(struct 
 	seq_printf(m, "  MaxChainDepth = 0x%02x frames\n", ioc->facts.MaxChainDepth);
 	seq_printf(m, "  MinBlockSize = 0x%02x bytes\n", 4*ioc->facts.BlockSize);
 
+#ifdef CONFIG_GRKERNSEC_HIDESYM
+	seq_printf(m, "  RequestFrames @ 0x%p (Dma @ 0x%p)\n", NULL, NULL);
+#else
 	seq_printf(m, "  RequestFrames @ 0x%p (Dma @ 0x%p)\n",
 					(void *)ioc->req_frames, (void *)(ulong)ioc->req_frames_dma);
+#endif
+
 	/*
 	 *  Rounding UP to nearest 4-kB boundary here...
 	 */
diff -urNp linux-2.6.36/fs/proc/array.c linux-2.6.36/fs/proc/array.c
--- linux-2.6.36/fs/proc/array.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/fs/proc/array.c	2010-11-06 18:58:50.000000000 -0400
@@ -452,6 +452,12 @@ static int do_task_stat(struct seq_file 
 		gtime = task->gtime;
 	}
 
+#ifdef CONFIG_GRKERNSEC_HIDESYM
+	wchan = 0;
+	eip =0;
+	esp =0;
+#endif
+
 	/* scale priority and nice values from timeslices to -20..20 */
 	/* to make it look like a "normal" Unix priority/nice value  */
 	priority = task_prio(task);
diff -urNp linux-2.6.36/fs/proc/base.c linux-2.6.36/fs/proc/base.c
--- linux-2.6.36/fs/proc/base.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/fs/proc/base.c	2010-11-06 18:58:50.000000000 -0400
@@ -296,7 +296,7 @@ static int proc_pid_auxv(struct task_str
 }
 
 
-#ifdef CONFIG_KALLSYMS
+#if defined(CONFIG_KALLSYMS) && !defined(CONFIG_GRKERNSEC_HIDESYM)
 /*
  * Provides a wchan file via kallsyms in a proper one-value-per-file format.
  * Returns the resolved symbol.  If that fails, simply return the address.
@@ -318,7 +318,7 @@ static int proc_pid_wchan(struct task_st
 }
 #endif /* CONFIG_KALLSYMS */
 
-#ifdef CONFIG_STACKTRACE
+#if defined(CONFIG_STACKTRACE) && !defined(CONFIG_GRKERNSEC_HIDESYM)
 
 #define MAX_STACK_TRACE_DEPTH	64
 
@@ -2705,10 +2705,10 @@ static const struct pid_entry tgid_base_
 #ifdef CONFIG_SECURITY
 	DIR("attr",       S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
 #endif
-#ifdef CONFIG_KALLSYMS
+#if defined(CONFIG_KALLSYMS) && !defined(CONFIG_GRKERNSEC_HIDESYM)
 	INF("wchan",      S_IRUGO, proc_pid_wchan),
 #endif
-#ifdef CONFIG_STACKTRACE
+#if defined(CONFIG_STACKTRACE) && !defined(CONFIG_GRKERNSEC_HIDESYM)
 	ONE("stack",      S_IRUSR, proc_pid_stack),
 #endif
 #ifdef CONFIG_SCHEDSTATS
@@ -3040,10 +3040,10 @@ static const struct pid_entry tid_base_s
 #ifdef CONFIG_SECURITY
 	DIR("attr",      S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
 #endif
-#ifdef CONFIG_KALLSYMS
+#if defined(CONFIG_KALLSYMS) && !defined(CONFIG_GRKERNSEC_HIDESYM)
 	INF("wchan",     S_IRUGO, proc_pid_wchan),
 #endif
-#ifdef CONFIG_STACKTRACE
+#if defined(CONFIG_STACKTRACE) && !defined(CONFIG_GRKERNSEC_HIDESYM)
 	ONE("stack",      S_IRUSR, proc_pid_stack),
 #endif
 #ifdef CONFIG_SCHEDSTATS
diff -urNp linux-2.6.36/fs/proc/kcore.c linux-2.6.36/fs/proc/kcore.c
--- linux-2.6.36/fs/proc/kcore.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/fs/proc/kcore.c	2010-11-06 18:58:50.000000000 -0400
@@ -542,6 +542,9 @@ read_kcore(struct file *file, char __use
 
 static int open_kcore(struct inode *inode, struct file *filp)
 {
+#if defined(CONFIG_GRKERNSEC_HIDESYM)
+	return -EPERM;
+#endif
 	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
 	if (kcore_need_update)
diff -urNp linux-2.6.36/include/linux/kallsyms.h linux-2.6.36/include/linux/kallsyms.h
--- linux-2.6.36/include/linux/kallsyms.h	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/include/linux/kallsyms.h	2010-11-15 17:10:35.000000000 -0500
@@ -15,7 +15,8 @@
 
 struct module;
 
-#ifdef CONFIG_KALLSYMS
+#if !defined(__INCLUDED_BY_HIDESYM) || !defined(CONFIG_KALLSYMS)
+#if defined(CONFIG_KALLSYMS) && !defined(CONFIG_GRKERNSEC_HIDESYM)
 /* Lookup the address for a symbol. Returns 0 if not found. */
 unsigned long kallsyms_lookup_name(const char *name);
 
@@ -92,6 +93,14 @@ static inline int lookup_symbol_attrs(un
 /* Stupid that this does nothing, but I didn't create this mess. */
 #define __print_symbol(fmt, addr)
 #endif /*CONFIG_KALLSYMS*/
+#else /* when included by kallsyms.c or vsnprintf.c, with HIDESYM enabled */
+extern void __print_symbol(const char *fmt, unsigned long address);
+extern int sprint_symbol(char *buffer, unsigned long address);
+const char *kallsyms_lookup(unsigned long addr,
+			    unsigned long *symbolsize,
+			    unsigned long *offset,
+			    char **modname, char *namebuf);
+#endif
 
 /* This macro allows us to keep printk typechecking */
 static void __check_printsym_format(const char *fmt, ...)
diff -urNp linux-2.6.36/kernel/configs.c linux-2.6.36/kernel/configs.c
--- linux-2.6.36/kernel/configs.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/kernel/configs.c	2010-11-06 18:58:50.000000000 -0400
@@ -73,8 +73,14 @@ static int __init ikconfig_init(void)
 	struct proc_dir_entry *entry;
 
 	/* create the current config file */
+#if defined(CONFIG_GRKERNSEC_HIDESYM)
+	entry = proc_create("config.gz", S_IFREG | S_IRUSR, NULL,
+			    &ikconfig_file_ops);
+#else
 	entry = proc_create("config.gz", S_IFREG | S_IRUGO, NULL,
 			    &ikconfig_file_ops);
+#endif
+
 	if (!entry)
 		return -ENOMEM;
 
diff -urNp linux-2.6.36/kernel/kallsyms.c linux-2.6.36/kernel/kallsyms.c
--- linux-2.6.36/kernel/kallsyms.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/kernel/kallsyms.c	2010-11-06 18:58:50.000000000 -0400
@@ -11,6 +11,9 @@
  *      Changed the compression method from stem compression to "table lookup"
  *      compression (see scripts/kallsyms.c for a more complete description)
  */
+#ifdef CONFIG_GRKERNSEC_HIDESYM
+#define __INCLUDED_BY_HIDESYM 1
+#endif
 #include <linux/kallsyms.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -464,6 +467,11 @@ static int s_show(struct seq_file *m, vo
 {
 	struct kallsym_iter *iter = m->private;
 
+#ifdef CONFIG_GRKERNSEC_HIDESYM
+	if (current_uid())
+		return 0;
+#endif
+
 	/* Some debugging symbols have no name.  Ignore them. */
 	if (!iter->name[0])
 		return 0;
@@ -504,7 +512,7 @@ static int kallsyms_open(struct inode *i
 	struct kallsym_iter *iter;
 	int ret;
 
-	iter = kmalloc(sizeof(*iter), GFP_KERNEL);
+	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
 	if (!iter)
 		return -ENOMEM;
 	reset_iter(iter, 0);
diff -urNp linux-2.6.36/kernel/module.c linux-2.6.36/kernel/module.c
--- linux-2.6.36/kernel/module.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/kernel/module.c	2010-11-06 18:58:50.000000000 -0400
@@ -3075,6 +3075,11 @@ static const struct file_operations proc
 
 static int __init proc_modules_init(void)
 {
+#ifndef CONFIG_GRKERNSEC_HIDESYM
+	proc_create("modules", S_IRUSR, NULL, &proc_modules_operations);
+#else
+	proc_create("modules", S_IRUSR, NULL, &proc_modules_operations);
+#endif
 	return 0;
 }
 module_init(proc_modules_init);
diff -urNp linux-2.6.36/kernel/time/timer_list.c linux-2.6.36/kernel/time/timer_list.c
--- linux-2.6.36/kernel/time/timer_list.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/kernel/time/timer_list.c	2010-11-06 18:58:50.000000000 -0400
@@ -38,12 +38,16 @@ DECLARE_PER_CPU(struct hrtimer_cpu_base,
 
 static void print_name_offset(struct seq_file *m, void *sym)
 {
+#ifdef CONFIG_GRKERNSEC_HIDESYM
+	SEQ_printf(m, "<%p>", NULL);
+#else
 	char symname[KSYM_NAME_LEN];
 
 	if (lookup_symbol_name((unsigned long)sym, symname) < 0)
 		SEQ_printf(m, "<%p>", sym);
 	else
 		SEQ_printf(m, "%s", symname);
+#endif
 }
 
 static void
@@ -112,7 +116,11 @@ next_one:
 static void
 print_base(struct seq_file *m, struct hrtimer_clock_base *base, u64 now)
 {
+#ifdef CONFIG_GRKERNSEC_HIDESYM
+	SEQ_printf(m, "  .base:       %p\n", NULL);
+#else
 	SEQ_printf(m, "  .base:       %p\n", base);
+#endif
 	SEQ_printf(m, "  .index:      %d\n",
 			base->index);
 	SEQ_printf(m, "  .resolution: %Lu nsecs\n",
diff -urNp linux-2.6.36/kernel/time/timer_stats.c linux-2.6.36/kernel/time/timer_stats.c
--- linux-2.6.36/kernel/time/timer_stats.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/kernel/time/timer_stats.c	2010-11-06 18:58:50.000000000 -0400
@@ -269,12 +269,16 @@ void timer_stats_update_stats(void *time
 
 static void print_name_offset(struct seq_file *m, unsigned long addr)
 {
+#ifdef CONFIG_GRKERNSEC_HIDESYM
+	seq_printf(m, "<%p>", NULL);
+#else
 	char symname[KSYM_NAME_LEN];
 
 	if (lookup_symbol_name(addr, symname) < 0)
 		seq_printf(m, "<%p>", (void *)addr);
 	else
 		seq_printf(m, "%s", symname);
+#endif
 }
 
 static int tstats_show(struct seq_file *m, void *v)
diff -urNp linux-2.6.36/lib/Kconfig.debug linux-2.6.36/lib/Kconfig.debug
--- linux-2.6.36/lib/Kconfig.debug	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/lib/Kconfig.debug	2010-11-06 19:03:24.000000000 -0400
@@ -998,6 +998,7 @@ config LATENCYTOP
 	depends on DEBUG_KERNEL
 	depends on STACKTRACE_SUPPORT
 	depends on PROC_FS
+	depends on !GRKERNSEC_HIDESYM
 	select FRAME_POINTER if !MIPS && !PPC && !S390 && !MICROBLAZE
 	select KALLSYMS
 	select KALLSYMS_ALL
diff -urNp linux-2.6.36/lib/vsprintf.c linux-2.6.36/lib/vsprintf.c
--- linux-2.6.36/lib/vsprintf.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/lib/vsprintf.c	2010-11-13 16:31:35.000000000 -0500
@@ -16,6 +16,9 @@
  * - scnprintf and vscnprintf
  */
 
+#ifdef CONFIG_GRKERNSEC_HIDESYM
+#define __INCLUDED_BY_HIDESYM 1
+#endif
 #include <stdarg.h>
 #include <linux/module.h>
 #include <linux/types.h>
@@ -574,7 +577,7 @@ char *symbol_string(char *buf, char *end
 	unsigned long value = (unsigned long) ptr;
 #ifdef CONFIG_KALLSYMS
 	char sym[KSYM_SYMBOL_LEN];
-	if (ext != 'f' && ext != 's')
+	if (ext != 'f' && ext != 's' && ext != 'a')
 		sprint_symbol(sym, value);
 	else
 		kallsyms_lookup(value, NULL, NULL, NULL, sym);
@@ -947,6 +950,8 @@ char *uuid_string(char *buf, char *end, 
  * - 'f' For simple symbolic function names without offset
  * - 'S' For symbolic direct pointers with offset
  * - 's' For symbolic direct pointers without offset
+ * - 'A' For symbolic direct pointers with offset approved for use with GRKERNSEC_HIDESYM
+ * - 'a' For symbolic direct pointers without offset approved for use with GRKERNSEC_HIDESYM
  * - 'R' For decoded struct resource, e.g., [mem 0x0-0x1f 64bit pref]
  * - 'r' For raw struct resource, e.g., [mem 0x0-0x1f flags 0x201]
  * - 'M' For a 6-byte MAC address, it prints the address in the
@@ -989,7 +994,7 @@ char *pointer(const char *fmt, char *buf
 	      struct printf_spec spec)
 {
 	if (!ptr)
-		return string(buf, end, "(null)", spec);
+		return string(buf, end, "(nil)", spec);
 
 	switch (*fmt) {
 	case 'F':
@@ -998,6 +1003,13 @@ char *pointer(const char *fmt, char *buf
 		/* Fallthrough */
 	case 'S':
 	case 's':
+#ifdef CONFIG_GRKERNSEC_HIDESYM
+		break;
+#else
+		return symbol_string(buf, end, ptr, spec, *fmt);
+#endif
+	case 'A':
+	case 'a':
 		return symbol_string(buf, end, ptr, spec, *fmt);
 	case 'R':
 	case 'r':
diff -urNp linux-2.6.36/net/atm/proc.c linux-2.6.36/net/atm/proc.c
--- linux-2.6.36/net/atm/proc.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/net/atm/proc.c	2010-11-06 18:58:50.000000000 -0400
@@ -190,7 +190,12 @@ static void vcc_info(struct seq_file *se
 {
 	struct sock *sk = sk_atm(vcc);
 
+#ifdef CONFIG_GRKERNSEC_HIDESYM
+	seq_printf(seq, "%p ", NULL);
+#else
 	seq_printf(seq, "%p ", vcc);
+#endif
+
 	if (!vcc->dev)
 		seq_printf(seq, "Unassigned    ");
 	else
diff -urNp linux-2.6.36/net/ipv4/inet_diag.c linux-2.6.36/net/ipv4/inet_diag.c
--- linux-2.6.36/net/ipv4/inet_diag.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/net/ipv4/inet_diag.c	2010-11-13 16:33:13.000000000 -0500
@@ -114,8 +114,14 @@ static int inet_csk_diag_fill(struct soc
 	r->idiag_retrans = 0;
 
 	r->id.idiag_if = sk->sk_bound_dev_if;
+
+#ifdef CONFIG_GRKERNSEC_HIDESYM
+	r->id.idiag_cookie[0] = 0;
+	r->id.idiag_cookie[1] = 0;
+#else
 	r->id.idiag_cookie[0] = (u32)(unsigned long)sk;
 	r->id.idiag_cookie[1] = (u32)(((unsigned long)sk >> 31) >> 1);
+#endif
 
 	r->id.idiag_sport = inet->inet_sport;
 	r->id.idiag_dport = inet->inet_dport;
@@ -201,8 +207,15 @@ static int inet_twsk_diag_fill(struct in
 	r->idiag_family	      = tw->tw_family;
 	r->idiag_retrans      = 0;
 	r->id.idiag_if	      = tw->tw_bound_dev_if;
+
+#ifdef CONFIG_GRKERNSEC_HIDESYM
+	r->id.idiag_cookie[0] = 0;
+	r->id.idiag_cookie[1] = 0;
+#else
 	r->id.idiag_cookie[0] = (u32)(unsigned long)tw;
 	r->id.idiag_cookie[1] = (u32)(((unsigned long)tw >> 31) >> 1);
+#endif
+
 	r->id.idiag_sport     = tw->tw_sport;
 	r->id.idiag_dport     = tw->tw_dport;
 	r->id.idiag_src[0]    = tw->tw_rcv_saddr;
@@ -285,12 +298,14 @@ static int inet_diag_get_exact(struct sk
 	if (sk == NULL)
 		goto unlock;
 
+#ifndef CONFIG_GRKERNSEC_HIDESYM
 	err = -ESTALE;
 	if ((req->id.idiag_cookie[0] != INET_DIAG_NOCOOKIE ||
 	     req->id.idiag_cookie[1] != INET_DIAG_NOCOOKIE) &&
 	    ((u32)(unsigned long)sk != req->id.idiag_cookie[0] ||
 	     (u32)((((unsigned long)sk) >> 31) >> 1) != req->id.idiag_cookie[1]))
 		goto out;
+#endif
 
 	err = -ENOMEM;
 	rep = alloc_skb(NLMSG_SPACE((sizeof(struct inet_diag_msg) +
@@ -578,8 +593,14 @@ static int inet_diag_fill_req(struct sk_
 	r->idiag_retrans = req->retrans;
 
 	r->id.idiag_if = sk->sk_bound_dev_if;
+
+#ifdef CONFIG_GRKERNSEC_HIDESYM
+	r->id.idiag_cookie[0] = 0;
+	r->id.idiag_cookie[1] = 0;
+#else
 	r->id.idiag_cookie[0] = (u32)(unsigned long)req;
 	r->id.idiag_cookie[1] = (u32)(((unsigned long)req >> 31) >> 1);
+#endif
 
 	tmo = req->expires - jiffies;
 	if (tmo < 0)
diff -urNp linux-2.6.36/net/ipv4/tcp_ipv4.c linux-2.6.36/net/ipv4/tcp_ipv4.c
--- linux-2.6.36/net/ipv4/tcp_ipv4.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/net/ipv4/tcp_ipv4.c	2010-11-06 19:08:40.000000000 -0400
@@ -2400,7 +2400,11 @@ static void get_openreq4(struct sock *sk
 		0,  /* non standard timer */
 		0, /* open_requests have no inode */
 		atomic_read(&sk->sk_refcnt),
+#ifdef CONFIG_GRKERNSEC_HIDESYM
+		NULL,
+#else
 		req,
+#endif
 		len);
 }
 
@@ -2450,7 +2454,12 @@ static void get_tcp4_sock(struct sock *s
 		sock_i_uid(sk),
 		icsk->icsk_probes_out,
 		sock_i_ino(sk),
-		atomic_read(&sk->sk_refcnt), sk,
+		atomic_read(&sk->sk_refcnt),
+#ifdef CONFIG_GRKERNSEC_HIDESYM
+		NULL,
+#else
+		sk,
+#endif
 		jiffies_to_clock_t(icsk->icsk_rto),
 		jiffies_to_clock_t(icsk->icsk_ack.ato),
 		(icsk->icsk_ack.quick << 1) | icsk->icsk_ack.pingpong,
@@ -2478,7 +2487,13 @@ static void get_timewait4_sock(struct in
 		" %02X %08X:%08X %02X:%08lX %08X %5d %8d %d %d %p%n",
 		i, src, srcp, dest, destp, tw->tw_substate, 0, 0,
 		3, jiffies_to_clock_t(ttd), 0, 0, 0, 0,
-		atomic_read(&tw->tw_refcnt), tw, len);
+		atomic_read(&tw->tw_refcnt),
+#ifdef CONFIG_GRKERNSEC_HIDESYM
+		NULL,
+#else
+		tw,
+#endif
+		len);
 }
 
 #define TMPSZ 150
diff -urNp linux-2.6.36/net/ipv4/udp.c linux-2.6.36/net/ipv4/udp.c
--- linux-2.6.36/net/ipv4/udp.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/net/ipv4/udp.c	2010-11-06 18:58:50.000000000 -0400
@@ -2051,7 +2051,12 @@ static void udp4_format_sock(struct sock
 		sk_wmem_alloc_get(sp),
 		sk_rmem_alloc_get(sp),
 		0, 0L, 0, sock_i_uid(sp), 0, sock_i_ino(sp),
-		atomic_read(&sp->sk_refcnt), sp,
+		atomic_read(&sp->sk_refcnt),
+#ifdef CONFIG_GRKERNSEC_HIDESYM
+		NULL,
+#else
+		sp,
+#endif
 		atomic_read(&sp->sk_drops), len);
 }
 
diff -urNp linux-2.6.36/net/ipv6/raw.c linux-2.6.36/net/ipv6/raw.c
--- linux-2.6.36/net/ipv6/raw.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/net/ipv6/raw.c	2010-11-06 18:58:50.000000000 -0400
@@ -1243,7 +1243,13 @@ static void raw6_sock_seq_show(struct se
 		   0, 0L, 0,
 		   sock_i_uid(sp), 0,
 		   sock_i_ino(sp),
-		   atomic_read(&sp->sk_refcnt), sp, atomic_read(&sp->sk_drops));
+		   atomic_read(&sp->sk_refcnt),
+#ifdef CONFIG_GRKERNSEC_HIDESYM
+		   NULL,
+#else
+		   sp,
+#endif
+		   atomic_read(&sp->sk_drops));
 }
 
 static int raw6_seq_show(struct seq_file *seq, void *v)
diff -urNp linux-2.6.36/net/ipv6/tcp_ipv6.c linux-2.6.36/net/ipv6/tcp_ipv6.c
--- linux-2.6.36/net/ipv6/tcp_ipv6.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/net/ipv6/tcp_ipv6.c	2010-11-06 18:58:50.000000000 -0400
@@ -1987,7 +1987,13 @@ static void get_openreq6(struct seq_file
 		   uid,
 		   0,  /* non standard timer */
 		   0, /* open_requests have no inode */
-		   0, req);
+		   0,
+#ifdef CONFIG_GRKERNSEC_HIDESYM
+		   NULL
+#else
+		   req
+#endif
+		   );
 }
 
 static void get_tcp6_sock(struct seq_file *seq, struct sock *sp, int i)
@@ -2037,7 +2043,12 @@ static void get_tcp6_sock(struct seq_fil
 		   sock_i_uid(sp),
 		   icsk->icsk_probes_out,
 		   sock_i_ino(sp),
-		   atomic_read(&sp->sk_refcnt), sp,
+		   atomic_read(&sp->sk_refcnt),
+#ifdef CONFIG_GRKERNSEC_HIDESYM
+		   NULL,
+#else
+		   sp,
+#endif
 		   jiffies_to_clock_t(icsk->icsk_rto),
 		   jiffies_to_clock_t(icsk->icsk_ack.ato),
 		   (icsk->icsk_ack.quick << 1 ) | icsk->icsk_ack.pingpong,
@@ -2072,7 +2083,13 @@ static void get_timewait6_sock(struct se
 		   dest->s6_addr32[2], dest->s6_addr32[3], destp,
 		   tw->tw_substate, 0, 0,
 		   3, jiffies_to_clock_t(ttd), 0, 0, 0, 0,
-		   atomic_read(&tw->tw_refcnt), tw);
+		   atomic_read(&tw->tw_refcnt),
+#ifdef CONFIG_GRKERNSEC_HIDESYM
+		   NULL
+#else
+		   tw
+#endif
+		   );
 }
 
 static int tcp6_seq_show(struct seq_file *seq, void *v)
diff -urNp linux-2.6.36/net/ipv6/udp.c linux-2.6.36/net/ipv6/udp.c
--- linux-2.6.36/net/ipv6/udp.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/net/ipv6/udp.c	2010-11-06 18:58:50.000000000 -0400
@@ -1399,7 +1399,12 @@ static void udp6_sock_seq_show(struct se
 		   0, 0L, 0,
 		   sock_i_uid(sp), 0,
 		   sock_i_ino(sp),
-		   atomic_read(&sp->sk_refcnt), sp,
+		   atomic_read(&sp->sk_refcnt),
+#ifdef CONFIG_GRKERNSEC_HIDESYM
+		   NULL,
+#else
+		   sp,
+#endif
 		   atomic_read(&sp->sk_drops));
 }
 
diff -urNp linux-2.6.36/net/key/af_key.c linux-2.6.36/net/key/af_key.c
--- linux-2.6.36/net/key/af_key.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/net/key/af_key.c	2010-11-06 18:58:50.000000000 -0400
@@ -3644,7 +3644,11 @@ static int pfkey_seq_show(struct seq_fil
 		seq_printf(f ,"sk       RefCnt Rmem   Wmem   User   Inode\n");
 	else
 		seq_printf(f ,"%p %-6d %-6u %-6u %-6u %-6lu\n",
+#ifdef CONFIG_GRKERNSEC_HIDESYM
+			       NULL,
+#else
 			       s,
+#endif
 			       atomic_read(&s->sk_refcnt),
 			       sk_rmem_alloc_get(s),
 			       sk_wmem_alloc_get(s),
diff -urNp linux-2.6.36/net/netlink/af_netlink.c linux-2.6.36/net/netlink/af_netlink.c
--- linux-2.6.36/net/netlink/af_netlink.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/net/netlink/af_netlink.c	2010-11-06 18:58:50.000000000 -0400
@@ -2007,13 +2007,21 @@ static int netlink_seq_show(struct seq_f
 		struct netlink_sock *nlk = nlk_sk(s);
 
 		seq_printf(seq, "%p %-3d %-6d %08x %-8d %-8d %p %-8d %-8d %-8lu\n",
+#ifdef CONFIG_GRKERNSEC_HIDESYM
+			   NULL,
+#else
 			   s,
+#endif
 			   s->sk_protocol,
 			   nlk->pid,
 			   nlk->groups ? (u32)nlk->groups[0] : 0,
 			   sk_rmem_alloc_get(s),
 			   sk_wmem_alloc_get(s),
+#ifdef CONFIG_GRKERNSEC_HIDESYM
+			   NULL,
+#else
 			   nlk->cb,
+#endif
 			   atomic_read(&s->sk_refcnt),
 			   atomic_read(&s->sk_drops),
 			   sock_i_ino(s)
diff -urNp linux-2.6.36/net/packet/af_packet.c linux-2.6.36/net/packet/af_packet.c
--- linux-2.6.36/net/packet/af_packet.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/net/packet/af_packet.c	2010-11-06 18:58:50.000000000 -0400
@@ -2637,7 +2637,11 @@ static int packet_seq_show(struct seq_fi
 
 		seq_printf(seq,
 			   "%p %-6d %-4d %04x   %-5d %1d %-6u %-6u %-6lu\n",
+#ifdef CONFIG_GRKERNSEC_HIDESYM
+			   NULL,
+#else
 			   s,
+#endif
 			   atomic_read(&s->sk_refcnt),
 			   s->sk_type,
 			   ntohs(po->num),
diff -urNp linux-2.6.36/net/phonet/socket.c linux-2.6.36/net/phonet/socket.c
--- linux-2.6.36/net/phonet/socket.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/net/phonet/socket.c	2010-11-13 16:29:01.000000000 -0500
@@ -535,7 +535,12 @@ static int pn_sock_seq_show(struct seq_f
 			sk->sk_state,
 			sk_wmem_alloc_get(sk), sk_rmem_alloc_get(sk),
 			sock_i_uid(sk), sock_i_ino(sk),
-			atomic_read(&sk->sk_refcnt), sk,
+			atomic_read(&sk->sk_refcnt),
+#ifdef CONFIG_GRKERNSEC_HIDESYM
+			NULL,
+#else
+			sk,
+#endif
 			atomic_read(&sk->sk_drops), &len);
 	}
 	seq_printf(seq, "%*s\n", 127 - len, "");
diff -urNp linux-2.6.36/net/sctp/proc.c linux-2.6.36/net/sctp/proc.c
--- linux-2.6.36/net/sctp/proc.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/net/sctp/proc.c	2010-11-13 16:29:01.000000000 -0500
@@ -212,7 +212,12 @@ static int sctp_eps_seq_show(struct seq_
 	sctp_for_each_hentry(epb, node, &head->chain) {
 		ep = sctp_ep(epb);
 		sk = epb->sk;
-		seq_printf(seq, "%8p %8p %-3d %-3d %-4d %-5d %5d %5lu ", ep, sk,
+		seq_printf(seq, "%8p %8p %-3d %-3d %-4d %-5d %5d %5lu ",
+#ifdef CONFIG_GRKERNSEC_HIDESYM
+			   NULL, NULL,
+#else
+			   ep, sk,
+#endif
 			   sctp_sk(sk)->type, sk->sk_state, hash,
 			   epb->bind_addr.port,
 			   sock_i_uid(sk), sock_i_ino(sk));
@@ -318,7 +323,12 @@ static int sctp_assocs_seq_show(struct s
 		seq_printf(seq,
 			   "%8p %8p %-3d %-3d %-2d %-4d "
 			   "%4d %8d %8d %7d %5lu %-5d %5d ",
-			   assoc, sk, sctp_sk(sk)->type, sk->sk_state,
+#ifdef CONFIG_GRKERNSEC_HIDESYM
+			   NULL, NULL,
+#else
+			   assoc, sk,
+#endif
+			   sctp_sk(sk)->type, sk->sk_state,
 			   assoc->state, hash,
 			   assoc->assoc_id,
 			   assoc->sndbuf_used,
diff -urNp linux-2.6.36/net/unix/af_unix.c linux-2.6.36/net/unix/af_unix.c
--- linux-2.6.36/net/unix/af_unix.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/net/unix/af_unix.c	2010-11-06 20:08:14.000000000 -0400
@@ -2195,7 +2195,11 @@ static int unix_seq_show(struct seq_file
 		unix_state_lock(s);
 
 		seq_printf(seq, "%p: %08X %08X %08X %04X %02X %5lu",
+#ifdef CONFIG_GRKERNSEC_HIDESYM
+			NULL,
+#else
 			s,
+#endif
 			atomic_read(&s->sk_refcnt),
 			0,
 			s->sk_state == TCP_LISTEN ? __SO_ACCEPTCON : 0,
diff -urNp linux-2.6.36/arch/powerpc/kernel/process.c linux-2.6.36/arch/powerpc/kernel/process.c
--- linux-2.6.36/arch/powerpc/kernel/process.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/arch/powerpc/kernel/process.c	2010-11-13 16:29:01.000000000 -0500
@@ -654,8 +654,8 @@ void show_regs(struct pt_regs * regs)
 	 * Lookup NIP late so we have the best change of getting the
 	 * above info out without failing
 	 */
-	printk("NIP ["REG"] %pS\n", regs->nip, (void *)regs->nip);
-	printk("LR ["REG"] %pS\n", regs->link, (void *)regs->link);
+	printk("NIP ["REG"] %pA\n", regs->nip, (void *)regs->nip);
+	printk("LR ["REG"] %pA\n", regs->link, (void *)regs->link);
 #endif
 	show_stack(current, (unsigned long *) regs->gpr[1]);
 	if (!user_mode(regs))
@@ -1145,10 +1145,10 @@ void show_stack(struct task_struct *tsk,
 		newsp = stack[0];
 		ip = stack[STACK_FRAME_LR_SAVE];
 		if (!firstframe || ip != lr) {
-			printk("["REG"] ["REG"] %pS", sp, ip, (void *)ip);
+			printk("["REG"] ["REG"] %pA", sp, ip, (void *)ip);
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 			if ((ip == rth || ip == mrth) && curr_frame >= 0) {
-				printk(" (%pS)",
+				printk(" (%pA)",
 				       (void *)current->ret_stack[curr_frame].ret);
 				curr_frame--;
 			}
@@ -1168,7 +1168,7 @@ void show_stack(struct task_struct *tsk,
 			struct pt_regs *regs = (struct pt_regs *)
 				(sp + STACK_FRAME_OVERHEAD);
 			lr = regs->link;
-			printk("--- Exception: %lx at %pS\n    LR = %pS\n",
+			printk("--- Exception: %lx at %pA\n    LR = %pA\n",
 			       regs->trap, (void *)regs->nip, (void *)lr);
 			firstframe = 1;
 		}
diff -urNp linux-2.6.36/arch/sparc/kernel/process_32.c linux-2.6.36/arch/sparc/kernel/process_32.c
--- linux-2.6.36/arch/sparc/kernel/process_32.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/arch/sparc/kernel/process_32.c	2010-11-13 16:29:01.000000000 -0500
@@ -196,7 +196,7 @@ void __show_backtrace(unsigned long fp)
 		       rw->ins[4], rw->ins[5],
 		       rw->ins[6],
 		       rw->ins[7]);
-		printk("%pS\n", (void *) rw->ins[7]);
+		printk("%pA\n", (void *) rw->ins[7]);
 		rw = (struct reg_window32 *) rw->ins[6];
 	}
 	spin_unlock_irqrestore(&sparc_backtrace_lock, flags);
@@ -263,14 +263,14 @@ void show_regs(struct pt_regs *r)
 
         printk("PSR: %08lx PC: %08lx NPC: %08lx Y: %08lx    %s\n",
 	       r->psr, r->pc, r->npc, r->y, print_tainted());
-	printk("PC: <%pS>\n", (void *) r->pc);
+	printk("PC: <%pA>\n", (void *) r->pc);
 	printk("%%G: %08lx %08lx  %08lx %08lx  %08lx %08lx  %08lx %08lx\n",
 	       r->u_regs[0], r->u_regs[1], r->u_regs[2], r->u_regs[3],
 	       r->u_regs[4], r->u_regs[5], r->u_regs[6], r->u_regs[7]);
 	printk("%%O: %08lx %08lx  %08lx %08lx  %08lx %08lx  %08lx %08lx\n",
 	       r->u_regs[8], r->u_regs[9], r->u_regs[10], r->u_regs[11],
 	       r->u_regs[12], r->u_regs[13], r->u_regs[14], r->u_regs[15]);
-	printk("RPC: <%pS>\n", (void *) r->u_regs[15]);
+	printk("RPC: <%pA>\n", (void *) r->u_regs[15]);
 
 	printk("%%L: %08lx %08lx  %08lx %08lx  %08lx %08lx  %08lx %08lx\n",
 	       rw->locals[0], rw->locals[1], rw->locals[2], rw->locals[3],
@@ -305,7 +305,7 @@ void show_stack(struct task_struct *tsk,
 		rw = (struct reg_window32 *) fp;
 		pc = rw->ins[7];
 		printk("[%08lx : ", pc);
-		printk("%pS ] ", (void *) pc);
+		printk("%pA ] ", (void *) pc);
 		fp = rw->ins[6];
 	} while (++count < 16);
 	printk("\n");
diff -urNp linux-2.6.36/arch/sparc/kernel/process_64.c linux-2.6.36/arch/sparc/kernel/process_64.c
--- linux-2.6.36/arch/sparc/kernel/process_64.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/arch/sparc/kernel/process_64.c	2010-11-13 16:34:22.000000000 -0500
@@ -180,14 +180,14 @@ static void show_regwindow(struct pt_reg
 	printk("i4: %016lx i5: %016lx i6: %016lx i7: %016lx\n",
 	       rwk->ins[4], rwk->ins[5], rwk->ins[6], rwk->ins[7]);
 	if (regs->tstate & TSTATE_PRIV)
-		printk("I7: <%pS>\n", (void *) rwk->ins[7]);
+		printk("I7: <%pA>\n", (void *) rwk->ins[7]);
 }
 
 void show_regs(struct pt_regs *regs)
 {
 	printk("TSTATE: %016lx TPC: %016lx TNPC: %016lx Y: %08x    %s\n", regs->tstate,
 	       regs->tpc, regs->tnpc, regs->y, print_tainted());
-	printk("TPC: <%pS>\n", (void *) regs->tpc);
+	printk("TPC: <%pA>\n", (void *) regs->tpc);
 	printk("g0: %016lx g1: %016lx g2: %016lx g3: %016lx\n",
 	       regs->u_regs[0], regs->u_regs[1], regs->u_regs[2],
 	       regs->u_regs[3]);
@@ -200,7 +200,7 @@ void show_regs(struct pt_regs *regs)
 	printk("o4: %016lx o5: %016lx sp: %016lx ret_pc: %016lx\n",
 	       regs->u_regs[12], regs->u_regs[13], regs->u_regs[14],
 	       regs->u_regs[15]);
-	printk("RPC: <%pS>\n", (void *) regs->u_regs[15]);
+	printk("RPC: <%pA>\n", (void *) regs->u_regs[15]);
 	show_regwindow(regs);
 	show_stack(current, (unsigned long *) regs->u_regs[UREG_FP]);
 }
@@ -285,7 +285,7 @@ void arch_trigger_all_cpu_backtrace(void
 		       ((tp && tp->task) ? tp->task->pid : -1));
 
 		if (gp->tstate & TSTATE_PRIV) {
-			printk("             TPC[%pS] O7[%pS] I7[%pS] RPC[%pS]\n",
+			printk("             TPC[%pA] O7[%pA] I7[%pA] RPC[%pA]\n",
 			       (void *) gp->tpc,
 			       (void *) gp->o7,
 			       (void *) gp->i7,
diff -urNp linux-2.6.36/arch/sparc/kernel/traps_32.c linux-2.6.36/arch/sparc/kernel/traps_32.c
--- linux-2.6.36/arch/sparc/kernel/traps_32.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/arch/sparc/kernel/traps_32.c	2010-11-13 16:29:01.000000000 -0500
@@ -76,7 +76,7 @@ void die_if_kernel(char *str, struct pt_
 		      count++ < 30				&&
                       (((unsigned long) rw) >= PAGE_OFFSET)	&&
 		      !(((unsigned long) rw) & 0x7)) {
-			printk("Caller[%08lx]: %pS\n", rw->ins[7],
+			printk("Caller[%08lx]: %pA\n", rw->ins[7],
 			       (void *) rw->ins[7]);
 			rw = (struct reg_window32 *)rw->ins[6];
 		}
diff -urNp linux-2.6.36/arch/sparc/kernel/traps_64.c linux-2.6.36/arch/sparc/kernel/traps_64.c
--- linux-2.6.36/arch/sparc/kernel/traps_64.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/arch/sparc/kernel/traps_64.c	2010-11-13 16:34:06.000000000 -0500
@@ -75,7 +75,7 @@ static void dump_tl1_traplog(struct tl1_
 		       i + 1,
 		       p->trapstack[i].tstate, p->trapstack[i].tpc,
 		       p->trapstack[i].tnpc, p->trapstack[i].tt);
-		printk("TRAPLOG: TPC<%pS>\n", (void *) p->trapstack[i].tpc);
+		printk("TRAPLOG: TPC<%pA>\n", (void *) p->trapstack[i].tpc);
 	}
 }
 
@@ -1141,7 +1141,7 @@ static void cheetah_log_errors(struct pt
 	       regs->tpc, regs->tnpc, regs->u_regs[UREG_I7], regs->tstate);
 	printk("%s" "ERROR(%d): ",
 	       (recoverable ? KERN_WARNING : KERN_CRIT), smp_processor_id());
-	printk("TPC<%pS>\n", (void *) regs->tpc);
+	printk("TPC<%pA>\n", (void *) regs->tpc);
 	printk("%s" "ERROR(%d): M_SYND(%lx),  E_SYND(%lx)%s%s\n",
 	       (recoverable ? KERN_WARNING : KERN_CRIT), smp_processor_id(),
 	       (afsr & CHAFSR_M_SYNDROME) >> CHAFSR_M_SYNDROME_SHIFT,
@@ -1748,7 +1748,7 @@ void cheetah_plus_parity_error(int type,
 		       smp_processor_id(),
 		       (type & 0x1) ? 'I' : 'D',
 		       regs->tpc);
-		printk(KERN_EMERG "TPC<%pS>\n", (void *) regs->tpc);
+		printk(KERN_EMERG "TPC<%pA>\n", (void *) regs->tpc);
 		panic("Irrecoverable Cheetah+ parity error.");
 	}
 
@@ -1756,7 +1756,7 @@ void cheetah_plus_parity_error(int type,
 	       smp_processor_id(),
 	       (type & 0x1) ? 'I' : 'D',
 	       regs->tpc);
-	printk(KERN_WARNING "TPC<%pS>\n", (void *) regs->tpc);
+	printk(KERN_WARNING "TPC<%pA>\n", (void *) regs->tpc);
 }
 
 struct sun4v_error_entry {
@@ -1963,9 +1963,9 @@ void sun4v_itlb_error_report(struct pt_r
 
 	printk(KERN_EMERG "SUN4V-ITLB: Error at TPC[%lx], tl %d\n",
 	       regs->tpc, tl);
-	printk(KERN_EMERG "SUN4V-ITLB: TPC<%pS>\n", (void *) regs->tpc);
+	printk(KERN_EMERG "SUN4V-ITLB: TPC<%pA>\n", (void *) regs->tpc);
 	printk(KERN_EMERG "SUN4V-ITLB: O7[%lx]\n", regs->u_regs[UREG_I7]);
-	printk(KERN_EMERG "SUN4V-ITLB: O7<%pS>\n",
+	printk(KERN_EMERG "SUN4V-ITLB: O7<%pA>\n",
 	       (void *) regs->u_regs[UREG_I7]);
 	printk(KERN_EMERG "SUN4V-ITLB: vaddr[%lx] ctx[%lx] "
 	       "pte[%lx] error[%lx]\n",
@@ -1987,9 +1987,9 @@ void sun4v_dtlb_error_report(struct pt_r
 
 	printk(KERN_EMERG "SUN4V-DTLB: Error at TPC[%lx], tl %d\n",
 	       regs->tpc, tl);
-	printk(KERN_EMERG "SUN4V-DTLB: TPC<%pS>\n", (void *) regs->tpc);
+	printk(KERN_EMERG "SUN4V-DTLB: TPC<%pA>\n", (void *) regs->tpc);
 	printk(KERN_EMERG "SUN4V-DTLB: O7[%lx]\n", regs->u_regs[UREG_I7]);
-	printk(KERN_EMERG "SUN4V-DTLB: O7<%pS>\n",
+	printk(KERN_EMERG "SUN4V-DTLB: O7<%pA>\n",
 	       (void *) regs->u_regs[UREG_I7]);
 	printk(KERN_EMERG "SUN4V-DTLB: vaddr[%lx] ctx[%lx] "
 	       "pte[%lx] error[%lx]\n",
@@ -2196,13 +2196,13 @@ void show_stack(struct task_struct *tsk,
 			fp = (unsigned long)sf->fp + STACK_BIAS;
 		}
 
-		printk(" [%016lx] %pS\n", pc, (void *) pc);
+		printk(" [%016lx] %pA\n", pc, (void *) pc);
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 		if ((pc + 8UL) == (unsigned long) &return_to_handler) {
 			int index = tsk->curr_ret_stack;
 			if (tsk->ret_stack && index >= graph) {
 				pc = tsk->ret_stack[index - graph].ret;
-				printk(" [%016lx] %pS\n", pc, (void *) pc);
+				printk(" [%016lx] %pA\n", pc, (void *) pc);
 				graph++;
 			}
 		}
@@ -2255,7 +2255,7 @@ void die_if_kernel(char *str, struct pt_
 		while (rw &&
 		       count++ < 30 &&
 		       kstack_valid(tp, (unsigned long) rw)) {
-			printk("Caller[%016lx]: %pS\n", rw->ins[7],
+			printk("Caller[%016lx]: %pA\n", rw->ins[7],
 			       (void *) rw->ins[7]);
 
 			rw = kernel_stack_up(rw);
diff -urNp linux-2.6.36/arch/sparc/kernel/unaligned_64.c linux-2.6.36/arch/sparc/kernel/unaligned_64.c
--- linux-2.6.36/arch/sparc/kernel/unaligned_64.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/arch/sparc/kernel/unaligned_64.c	2010-11-13 16:33:46.000000000 -0500
@@ -278,7 +278,7 @@ static void log_unaligned(struct pt_regs
 	static DEFINE_RATELIMIT_STATE(ratelimit, 5 * HZ, 5);
 
 	if (__ratelimit(&ratelimit)) {
-		printk("Kernel unaligned access at TPC[%lx] %pS\n",
+		printk("Kernel unaligned access at TPC[%lx] %pA\n",
 		       regs->tpc, (void *) regs->tpc);
 	}
 }
diff -urNp linux-2.6.36/arch/sparc/mm/fault_64.c linux-2.6.36/arch/sparc/mm/fault_64.c
--- linux-2.6.36/arch/sparc/mm/fault_64.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/arch/sparc/mm/fault_64.c	2010-11-13 16:29:01.000000000 -0500
@@ -74,7 +74,7 @@ static void __kprobes bad_kernel_pc(stru
 	printk(KERN_CRIT "OOPS: Bogus kernel PC [%016lx] in fault handler\n",
 	       regs->tpc);
 	printk(KERN_CRIT "OOPS: RPC [%016lx]\n", regs->u_regs[15]);
-	printk("OOPS: RPC <%pS>\n", (void *) regs->u_regs[15]);
+	printk("OOPS: RPC <%pA>\n", (void *) regs->u_regs[15]);
 	printk(KERN_CRIT "OOPS: Fault was to vaddr[%lx]\n", vaddr);
 	dump_stack();
 	unhandled_fault(regs->tpc, current, regs);
diff -urNp linux-2.6.36/arch/x86/kernel/dumpstack.c linux-2.6.36/arch/x86/kernel/dumpstack.c
--- linux-2.6.36/arch/x86/kernel/dumpstack.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/arch/x86/kernel/dumpstack.c	2010-11-13 16:29:01.000000000 -0500
@@ -27,7 +27,7 @@ static int die_counter;
 
 void printk_address(unsigned long address, int reliable)
 {
-	printk(" [<%p>] %s%pS\n", (void *) address,
+	printk(" [<%p>] %s%pA\n", (void *) address,
 			reliable ? "" : "? ", (void *) address);
 }
 
diff -urNp linux-2.6.36/kernel/panic.c linux-2.6.36/kernel/panic.c
--- linux-2.6.36/kernel/panic.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/kernel/panic.c	2010-11-13 16:29:01.000000000 -0500
@@ -368,7 +368,7 @@ static void warn_slowpath_common(const c
 	const char *board;
 
 	printk(KERN_WARNING "------------[ cut here ]------------\n");
-	printk(KERN_WARNING "WARNING: at %s:%d %pS()\n", file, line, caller);
+	printk(KERN_WARNING "WARNING: at %s:%d %pA()\n", file, line, caller);
 	board = dmi_get_system_info(DMI_PRODUCT_NAME);
 	if (board)
 		printk(KERN_WARNING "Hardware name: %s\n", board);
@@ -423,7 +423,8 @@ EXPORT_SYMBOL(warn_slowpath_null);
  */
 void __stack_chk_fail(void)
 {
-	panic("stack-protector: Kernel stack is corrupted in: %p\n",
+	dump_stack();
+	panic("stack-protector: Kernel stack is corrupted in: %pA\n",
 		__builtin_return_address(0));
 }
 EXPORT_SYMBOL(__stack_chk_fail);
diff -urNp linux-2.6.36/mm/kmemleak.c linux-2.6.36/mm/kmemleak.c
--- linux-2.6.36/mm/kmemleak.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/mm/kmemleak.c	2010-11-13 16:29:01.000000000 -0500
@@ -355,7 +355,7 @@ static void print_unreferenced(struct se
 
 	for (i = 0; i < object->trace_len; i++) {
 		void *ptr = (void *)object->trace[i];
-		seq_printf(seq, "    [<%p>] %pS\n", ptr, ptr);
+		seq_printf(seq, "    [<%p>] %pA\n", ptr, ptr);
 	}
 }
 
diff -urNp linux-2.6.36/mm/slub.c linux-2.6.36/mm/slub.c
--- linux-2.6.36/mm/slub.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/mm/slub.c	2010-11-13 16:29:01.000000000 -0500
@@ -392,7 +392,7 @@ static void print_track(const char *s, s
 	if (!t->addr)
 		return;
 
-	printk(KERN_ERR "INFO: %s in %pS age=%lu cpu=%u pid=%d\n",
+	printk(KERN_ERR "INFO: %s in %pA age=%lu cpu=%u pid=%d\n",
 		s, (void *)t->addr, jiffies - t->when, t->cpu, t->pid);
 }
 


-- 
Kees Cook
Ubuntu Security Team
