Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab0FDAjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 20:39:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:42902 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab0FDAjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 20:39:21 -0400
Date: Thu, 3 Jun 2010 21:39:00 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com, tzanussi@gmail.com
Subject: Re: how to use perf annotate on the kernel
Message-ID: <20100604003900.GD10469@ghostprotocols.net>
References: <AANLkTik2yNxwCHl7FZAyOG4Vt56RlLi59oZR5Jo6o9ox@mail.gmail.com>
 <20100603175445.GC8928@ghostprotocols.net>
 <20100603180613.GA10469@ghostprotocols.net>
 <20100603181103.GB10469@ghostprotocols.net>
 <AANLkTincvUH7p-aHsDZoThUQn_eZkdbq3A8bM5i5ytpo@mail.gmail.com>
 <20100604002039.GC10469@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100604002039.GC10469@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jun 03, 2010 at 09:20:39PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Thu, Jun 03, 2010 at 08:18:04PM +0200, Stephane Eranian escreveu:
> > perf annotate __lock_acquire -k /home/eranian/perfmon/official/tip/build/vmlinux
> > build id event received for [kernel.kallsyms]:
> > 5c110a704293a259fbe11158dc1b25107ad7a23e
> > build id event received for
> > /lib/modules/2.6.35-rc1-tip/kernel/arch/x86/kernel/cpu/cpufreq/mperf.ko:
> > cb5
> > build id event received for
> > /lib/modules/2.6.35-rc1-tip/kernel/drivers/cpufreq/cpufreq_ondemand.ko:
> > cdb5
> > Using /home/eranian/perfmon/official/tip/build/vmlinux for symbols
> > hist_entry__inc_addr_samples: ip=0xffffffff81073b36
> > 0xffffffff81073b30 __lock_acquire: period++ [ip: 0xffffffff81073b36, 0x6] => 1
> > hist_entry__inc_addr_samples: ip=0xffffffff81073c94
> > 
> > But in the end I get:
> > objdump: '[kernel.kallsyms]': No such file
> 
> Reproduced, working on it now. I've been testing only with vmlinux in
> the path it searches for, not by directly specifying it, will get that
> fixed, thanks,

Should be fixed by this patch:

[root@emilia ~]# perf annotate -k /lib/modules/2.6.35-rc1/build/vmlinux.OFF n_tty_write | head -50


------------------------------------------------
 Percent |	Source code & Disassembly of vmlinux.OFF
------------------------------------------------
         :
         :
         :
         :	Disassembly of section .text:
         :
         :	ffffffff81288820 <n_tty_write>:
         :	 *                lock themselves)
         :	 */
         :
         :	static ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
         :	                           const unsigned char *buf, size_t nr)
         :	{
    0.00 :	ffffffff81288820:       41 57                   push   %r15
         :
         :	DECLARE_PER_CPU(struct task_struct *, current_task);
         :
         :	static __always_inline struct task_struct *get_current(void)
         :	{
         :	        return percpu_read_stable(current_task);
    0.00 :	ffffffff81288822:       65 48 8b 04 25 40 cc    mov    %gs:0xcc40,%rax
    0.00 :	ffffffff81288829:       00 00 
    0.00 :	ffffffff8128882b:       41 56                   push   %r14
    0.00 :	ffffffff8128882d:       41 55                   push   %r13
    0.00 :	ffffffff8128882f:       49 89 cd                mov    %rcx,%r13
    0.00 :	ffffffff81288832:       41 54                   push   %r12
    0.00 :	ffffffff81288834:       49 89 d4                mov    %rdx,%r12
    0.00 :	ffffffff81288837:       55                      push   %rbp
    0.00 :	ffffffff81288838:       48 89 f5                mov    %rsi,%rbp
    0.00 :	ffffffff8128883b:       53                      push   %rbx
    0.00 :	ffffffff8128883c:       48 89 fb                mov    %rdi,%rbx
    0.00 :	ffffffff8128883f:       48 83 ec 58             sub    $0x58,%rsp
         :	        const unsigned char *b = buf;
         :	        DECLARE_WAITQUEUE(wait, current);
    0.00 :	ffffffff81288843:       48 c7 44 24 20 00 00    movq   $0x0,0x20(%rsp)
    0.00 :	ffffffff8128884a:       00 00 
    7.14 :	ffffffff8128884c:       48 c7 44 24 38 00 00    movq   $0x0,0x38(%rsp)
    0.00 :	ffffffff81288853:       00 00 
    0.00 :	ffffffff81288855:       48 c7 44 24 40 00 00    movq   $0x0,0x40(%rsp)
    0.00 :	ffffffff8128885c:       00 00 
    7.14 :	ffffffff8128885e:       48 89 44 24 28          mov    %rax,0x28(%rsp)
    0.00 :	ffffffff81288863:       48 c7 44 24 30 30 49    movq   $0xffffffff81044930,0x30(%rsp)
    0.00 :	ffffffff8128886a:       04 81 
         :	        int c;
         :	        ssize_t retval = 0;
         :
[root@emilia ~]#

>From 842b66de6807e72bddfd24a63742bacd0f853872 Mon Sep 17 00:00:00 2001
From: Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Thu, 3 Jun 2010 18:35:55 -0300
Subject: [PATCH 1/1] perf symbols: Set the DSO long name when using symbol_conf.vmlinux_name
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We need to set the long name to the name specified via, for instance,
'perf annotate --vmlinux /path/to/vmlinux', if not it will remain as
'[kernel.kallsyms]' and that will make annotate fail when passing this
as the vmlinux name in the call to objdump.

The way this is setup grew unwieldly and dso__load_vmlinux is the
function that should allocate space for the long name, with callers not
assuming that filenames should be allocated somehow by then (strdup,
dso__build_id_filename, etc).

For now this is the minimalistic patch, a proper fix for .36 will be
made.

Reported-by: Stephane Eranian <eranian@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 7fd6b15..b63e571 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1745,7 +1745,12 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 	if (symbol_conf.vmlinux_name != NULL) {
 		err = dso__load_vmlinux(self, map,
 					symbol_conf.vmlinux_name, filter);
-		goto out_try_fixup;
+		if (err > 0) {
+			dso__set_long_name(self,
+					   strdup(symbol_conf.vmlinux_name));
+			goto out_fixup;
+		}
+		return err;
 	}
 
 	if (vmlinux_path != NULL) {
@@ -1806,7 +1811,6 @@ do_kallsyms:
 		pr_debug("Using %s for symbols\n", kallsyms_filename);
 	free(kallsyms_allocated_filename);
 
-out_try_fixup:
 	if (err > 0) {
 out_fixup:
 		if (kallsyms_filename != NULL)
-- 
1.6.5.2

