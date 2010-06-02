Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720Ab0FBUkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 16:40:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43235 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758697Ab0FBUkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 16:40:35 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Michal Marek <mmarek@suse.cz>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 3/4] perf tools: Make target to generate self contained source tarball
Date: Wed,  2 Jun 2010 17:40:14 -0300
Message-Id: <1275511215-25703-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1275511215-25703-1-git-send-email-acme@infradead.org>
References: <1275511215-25703-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Useful for when people want to try some version of the perf tools and don't
wants to download the kernel tarball.

Here is a session using this new target:

  [root@emilia linux-2.6-tip]# make help | grep -i perf
    perf-tar-src-pkg    - Build perf-2.6.35-rc1.tar source tarball
    perf-targz-src-pkg  - Build perf-2.6.35-rc1.tar.gz source tarball
    perf-tarbz2-src-pkg - Build perf-2.6.35-rc1.tar.bz2 source tarball
  [root@emilia linux-2.6-tip]# make perf-tarbz2-src-pkg
    TAR
  [root@emilia linux-2.6-tip]# ls -la perf-2.6.35-rc1.tar.bz2
  -rw-r--r-- 1 root root 295731 May 31 11:18 perf-2.6.35-rc1.tar.bz2
  [root@emilia linux-2.6-tip]# tar xf perf-2.6.35-rc1.tar.bz2
  [root@emilia linux-2.6-tip]# cd perf-2.6.35-rc1
  [root@emilia perf-2.6.35-rc1]# ls
  arch  HEAD  include  lib  tools
  [root@emilia perf-2.6.35-rc1]# cd tools/perf
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
  [ perf record: Captured and wrote 0.262 MB perf.data (~11457 samples) ]
  [root@emilia perf]# ./perf report | head -12
  # Events: 6K cycles
  #
  # Overhead          Command       Shared Object  Symbol
  # ........  ...............  ..................  ......
  #
       4.73%             perf  [kernel.kallsyms]   [k] format_decode
       4.49%             perf  libc-2.12.so        [.] _IO_file_underflow_internal
       4.38%             init  [kernel.kallsyms]   [k] mwait_idle
       3.29%             perf  [kernel.kallsyms]   [k] vsnprintf
       2.38%             init  [kernel.kallsyms]   [k] sched_clock_local
       2.35%             init  [kernel.kallsyms]   [k] apic_timer_interrupt
       1.86%     sirq-timer/5  [kernel.kallsyms]   [k] find_busiest_group
  [root@emilia perf]#

Acked-by: Michal Marek <mmarek@suse.cz>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <20100528185357.GA28009@ghostprotocols.net>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 Makefile                 |    2 +-
 scripts/package/Makefile |   37 +++++++++++++++++++++++++++++++------
 tools/perf/MANIFEST      |   12 ++++++++++++
 3 files changed, 44 insertions(+), 7 deletions(-)
 create mode 100644 tools/perf/MANIFEST

diff --git a/Makefile b/Makefile
index 6e39ec7..0ab0c6f 100644
--- a/Makefile
+++ b/Makefile
@@ -411,7 +411,7 @@ endif
 no-dot-config-targets := clean mrproper distclean \
 			 cscope TAGS tags help %docs check% \
 			 include/linux/version.h headers_% \
-			 kernelrelease kernelversion
+			 kernelrelease kernelversion %src-pkg
 
 config-targets := 0
 mixed-targets  := 0
diff --git a/scripts/package/Makefile b/scripts/package/Makefile
index 62fcc3a..18513b0 100644
--- a/scripts/package/Makefile
+++ b/scripts/package/Makefile
@@ -111,13 +111,38 @@ tar%pkg: FORCE
 clean-dirs += $(objtree)/tar-install/
 
 
+# perf-pkg - generate a source tarball with perf source
+# ---------------------------------------------------------------------------
+
+perf-tar=perf-$(KERNELVERSION)
+
+quiet_cmd_perf_tar = TAR
+      cmd_perf_tar = \
+git archive --prefix=$(perf-tar)/ HEAD^{tree}                       \
+	$$(cat $(srctree)/tools/perf/MANIFEST) -o $(perf-tar).tar;  \
+mkdir -p $(perf-tar);                                               \
+git rev-parse HEAD > $(perf-tar)/HEAD;                              \
+tar rf $(perf-tar).tar $(perf-tar)/HEAD;                            \
+rm -r $(perf-tar);                                                  \
+$(if $(findstring tar-src,$@),,                                     \
+$(if $(findstring bz2,$@),bzip2,                                    \
+$(if $(findstring gz,$@),gzip,                                      \
+$(error unknown target $@)))                                       \
+	-f -9 $(perf-tar).tar)
+
+perf-%pkg: FORCE
+	$(call cmd,perf_tar)
+
 # Help text displayed when executing 'make help'
 # ---------------------------------------------------------------------------
 help: FORCE
-	@echo '  rpm-pkg         - Build both source and binary RPM kernel packages'
-	@echo '  binrpm-pkg      - Build only the binary kernel package'
-	@echo '  deb-pkg         - Build the kernel as an deb package'
-	@echo '  tar-pkg         - Build the kernel as an uncompressed tarball'
-	@echo '  targz-pkg       - Build the kernel as a gzip compressed tarball'
-	@echo '  tarbz2-pkg      - Build the kernel as a bzip2 compressed tarball'
+	@echo '  rpm-pkg             - Build both source and binary RPM kernel packages'
+	@echo '  binrpm-pkg          - Build only the binary kernel package'
+	@echo '  deb-pkg             - Build the kernel as an deb package'
+	@echo '  tar-pkg             - Build the kernel as an uncompressed tarball'
+	@echo '  targz-pkg           - Build the kernel as a gzip compressed tarball'
+	@echo '  tarbz2-pkg          - Build the kernel as a bzip2 compressed tarball'
+	@echo '  perf-tar-src-pkg    - Build $(perf-tar).tar source tarball'
+	@echo '  perf-targz-src-pkg  - Build $(perf-tar).tar.gz source tarball'
+	@echo '  perf-tarbz2-src-pkg - Build $(perf-tar).tar.bz2 source tarball'
 
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
-- 
1.6.2.5

