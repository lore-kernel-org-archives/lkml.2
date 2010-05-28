Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab0E1SyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 14:54:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:43163 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332Ab0E1SyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 14:54:13 -0400
Date: Fri, 28 May 2010 15:53:57 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>, "David S. Miller" <davem@davemloft.net>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] perf tools: Make target to generate self contained
 source tarball
Message-ID: <20100528185357.GA28009@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal, Sam,

	Are you OK with with this change?

- Arnaldo


commit 0871c6215cb617ecb87a7f84db4627c7ee93c877
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Thu May 27 12:12:00 2010 -0300

    perf tools: Make target to generate self contained source tarball
    
    Useful for when people want to try some version of the perf tools and don't
    wants to download the kernel tarball.
    
    Here is a session using this new target:
    
      [root@emilia linux-2.6-tip]# make help | grep -i perf
      Perf packaging:
        perf-dist       - Generate perf-2.6.34.tar.gz source tarball
      [root@emilia linux-2.6-tip]# make perf-dist
      [root@emilia linux-2.6-tip]# ls -la perf-2.6.34.tar.gz
      -rw-r--r-- 1 root root 366277 May 27 12:09 perf-2.6.34.tar.gz
      [root@emilia linux-2.6-tip]# tar xf perf-2.6.34.tar.gz
      [root@emilia linux-2.6-tip]# cd perf-2.6.34
      [root@emilia perf-2.6.34]# ls
      arch  HEAD  include  lib  tools
      [root@emilia perf-2.6.34]# cat HEAD
      5ad90e4ea4a096af9f0a362e34dfae5686a191ef
      [root@emilia perf-2.6.34]# cd tools/perf
      [root@emilia perf]# make -j9 2>&1 | tail
          CC arch/x86/util/dwarf-regs.o
          CC util/probe-finder.o
          CC util/newt.o
          CC util/scripting-engines/trace-event-perl.o
          CC scripts/perl/Perf-Trace-Util/Context.o
          CC perf.o
          CC builtin-help.o
          AR libperf.a
          LINK perf
      rm .perf.dev.null
      [root@emilia perf]# ./perf record -a sleep 1
      [ perf record: Woken up 1 times to write data ]
      [ perf record: Captured and wrote 0.066 MB perf.data (~2900 samples) ]
      [root@emilia perf]# ./perf report | head -12
      # Events: 17  cycles
      #
      # Overhead          Command      Shared Object  Symbol
      # ........  ...............  .................  ......
      #
          29.40%      ksoftirqd/4  [kernel.kallsyms]  [k] _spin_lock
          23.88%            sleep  [kernel.kallsyms]  [k] unmap_vmas
          22.10%             init  [kernel.kallsyms]  [k] resched_task
           4.97%             perf  [kernel.kallsyms]  [k] format_decode
           4.93%             perf  [kernel.kallsyms]  [k] mangle_path
           4.90%             perf  [kernel.kallsyms]  [k] _spin_lock
           4.90%             perf  [ext4]             [k] __ext4_get_inode_loc
      [root@emilia perf]#
    
    Cc: Frédéric Weisbecker <fweisbec@gmail.com>
    Cc: Mike Galbraith <efault@gmx.de>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Stephane Eranian <eranian@google.com>
    Cc: Tom Zanussi <tzanussi@gmail.com>
    LKML-Reference: <new-submission>
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/Makefile b/Makefile
index ebc8225..ab45bd5 100644
--- a/Makefile
+++ b/Makefile
@@ -356,8 +356,9 @@ KBUILD_AFLAGS   := -D__ASSEMBLY__
 # Read KERNELRELEASE from include/config/kernel.release (if it exists)
 KERNELRELEASE = $(shell cat include/config/kernel.release 2> /dev/null)
 KERNELVERSION = $(VERSION).$(PATCHLEVEL).$(SUBLEVEL)$(EXTRAVERSION)
+PERF_TARNAME=perf-$(KERNELVERSION)
 
-export VERSION PATCHLEVEL SUBLEVEL KERNELRELEASE KERNELVERSION
+export VERSION PATCHLEVEL SUBLEVEL KERNELRELEASE KERNELVERSION PERF_TARNAME
 export ARCH SRCARCH CONFIG_SHELL HOSTCC HOSTCFLAGS CROSS_COMPILE AS LD CC
 export CPP AR NM STRIP OBJCOPY OBJDUMP
 export MAKE AWK GENKSYMS INSTALLKERNEL PERL UTS_MACHINE
@@ -411,7 +412,7 @@ endif
 no-dot-config-targets := clean mrproper distclean \
 			 cscope TAGS tags help %docs check% \
 			 include/linux/version.h headers_% \
-			 kernelrelease kernelversion
+			 kernelrelease kernelversion perf-dist
 
 config-targets := 0
 mixed-targets  := 0
@@ -1269,6 +1270,9 @@ help:
 	@echo  'Kernel packaging:'
 	@$(MAKE) $(build)=$(package-dir) help
 	@echo  ''
+	@echo  'Perf packaging:'
+	@echo  '  perf-dist       - Generate $(PERF_TARNAME).tar.gz source tarball'
+	@echo  ''
 	@echo  'Documentation targets:'
 	@$(MAKE) -f $(srctree)/Documentation/DocBook/Makefile dochelp
 	@echo  ''
@@ -1403,6 +1407,15 @@ prepare: ;
 scripts: ;
 endif # KBUILD_EXTMOD
 
+perf-dist:
+	@git archive --prefix=$(PERF_TARNAME)/ HEAD^{tree} \
+		`cat tools/perf/MANIFEST` -o $(PERF_TARNAME).tar
+	@mkdir -p $(PERF_TARNAME)
+	@git rev-parse HEAD > $(PERF_TARNAME)/HEAD
+	@tar rf $(PERF_TARNAME).tar $(PERF_TARNAME)/HEAD
+	@rm -r $(PERF_TARNAME)
+	@gzip -f -9 $(PERF_TARNAME).tar
+
 # Generate tags for editors
 # ---------------------------------------------------------------------------
 quiet_cmd_tags = GEN     $@
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
new file mode 100644
index 0000000..8c7fc0c
--- /dev/null
+++ b/tools/perf/MANIFEST
@@ -0,0 +1,12 @@
+tools/perf
+include/linux/perf_event.h
+include/linux/rbtree.h
+include/linux/list.h
+include/linux/hash.h
+include/linux/stringify.h
+lib/rbtree.c
+include/linux/swab.h
+arch/*/include/asm/unistd*.h
+include/linux/poison.h
+include/linux/magic.h
+include/linux/hw_breakpoint.h
