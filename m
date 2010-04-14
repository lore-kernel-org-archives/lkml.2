Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055Ab0DNWh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 18:37:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755074Ab0DNWhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 18:37:55 -0400
Date: Thu, 15 Apr 2010 00:37:35 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
cc: Thomas Gleixner <tglx@linutronix.de>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>, linux-rt-users@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: [RT:PATCH] tracing/x86: Add check to GCC messing with  mcount
 prologue
Message-ID: <alpine.LFD.2.00.1004150028170.14487@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch is originally from Steven Rostedt.
I cherry-picked it from his git repo, and ported it to v2.6.33.2-rt13
by fixing up the merge conflicts.

The immediate importance of this, is that it restores the function_graph 
tracer to 32-bit x86, for real-time.

I have done some light testing on 32-bit x86, but it could use some more
testing everywhere. After that I hope that Thomas will pick it up for the
next 2.6.33.2-rtN release.

I have done this for real-time purposes, but Steven's patch was intended
for the mainline kernel, so maybe some testing in -rt would convince
folks to pick it up for mainline as well, if it isn't already queued up.

John Kacur


>From 8f31a8a1cc4f1ee54ad673318954b118e55aca31 Mon Sep 17 00:00:00 2001
From: Steven Rostedt <srostedt@redhat.com>
Date: Thu, 19 Nov 2009 23:41:02 -0500
Subject: [PATCH] tracing/x86: Add check to detect GCC messing with mcount prologue

Latest versions of GCC create a funny prologue for some functions.
Instead of the typical:

		push   %ebp
		mov    %esp,%ebp
		and    $0xffffffe0,%esp
		[...]
		call   mcount

GCC may try to align the stack before setting up the frame pointer
register:

		push   %edi
		lea    0x8(%esp),%edi
		and    $0xffffffe0,%esp
		pushl  -0x4(%edi)
		push   %ebp
		mov    %esp,%ebp
		[...]
		call   mcount

This crazy code places a copy of the return address into the
frame pointer. The function graph tracer uses this pointer to
save and replace the return address of the calling function to jump
to the function graph tracer's return handler, which will put back
the return address. But instead instead of the typical return:

		mov    %ebp,%esp
		pop    %ebp
		ret

The return of the function performs:

		lea    -0x8(%edi),%esp
		pop    %edi
		ret

The function graph tracer return handler will not be called at the exit
of the function, but the parent function will call it. Because we missed
the return of the child function, the handler will replace the parent's
return address with that of the child. Obviously this will cause a crash
(Note, there is code to detect this case and safely panic the kernel).

The kicker is that this happens to just a handful of functions.
And only with certain gcc options.

Compiling with: 	-march=pentium-mmx
will cause the problem to appear. But if you were to change
pentium-mmx to i686 or add -mtune=generic, then the problem goes away.

I first saw this problem when compiling with optimize for size.
But it seems that various other options may cause this issue to arise.

Instead of completely disabling the function graph tracer for i386 builds
this patch adds a check to recordmcount.pl to make sure that all
functions that contain a call to mcount start with "push %ebp".
If not, it will fail the compile and print out the nasty warning:

  CC      kernel/time/timer_stats.o

********************************************************
  Your version of GCC breaks the function graph tracer
  Please disable CONFIG_FUNCTION_GRAPH_TRACER
  Failed function was "timer_stats_update_stats"
********************************************************

The script recordmcount.pl is given a new parameter "do_check". If
this is negative, the script will only perform this check without
creating the mcount caller section. This will be executed for x86_32
when CONFIG_FUNCTION_GRAPH_TRACER is enabled and CONFIG_DYNAMIC_FTRACE
is not.

If the arch is x86_32 and $do_check is greater than 1, it will perform
the check while processing the mcount callers. If $do_check is 0, then
no check will be performed. This is for non x86_32 archs and when
compiling without CONFIG_FUNCTION_GRAPH_TRACER enabled, even on x86_32.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Fixed merge conflicts when cherry-picking this for v2.6.33.2-rt13
Signed-off-by: John Kacur <jkacur@redhat.com>
---
 kernel/trace/Kconfig    |    1 -
 scripts/Makefile.build  |   25 +++++++++++++++-
 scripts/recordmcount.pl |   72 +++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 93 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 7d57890..159ba62 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -141,7 +141,6 @@ config FUNCTION_GRAPH_TRACER
 	bool "Kernel Function Graph Tracer"
 	depends on HAVE_FUNCTION_GRAPH_TRACER
 	depends on FUNCTION_TRACER
-	depends on !X86_32 || !CC_OPTIMIZE_FOR_SIZE
 	default y
 	help
 	  Enable the kernel to trace a function at both its return
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 0b94d2f..6dfdc91 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -206,11 +206,34 @@ cmd_modversions =							\
 endif
 
 ifdef CONFIG_FTRACE_MCOUNT_RECORD
+
+ ifdef CONFIG_FUNCTION_GRAPH_TRACER
+  ifdef CONFIG_X86_32
+   rm_do_check = 1
+  else
+   rm_do_check = 0
+  endif
+ else
+  rm_do_check = 0
+ endif
+
 cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
 	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
 	"$(if $(CONFIG_64BIT),64,32)" \
 	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" "$(MV)" \
-	"$(if $(part-of-module),1,0)" "$(@)";
+	"$(if $(part-of-module),1,0)" "$(rm_do_check)" "$(@)";
+
+else
+
+ ifdef CONFIG_X86_32
+ ifdef CONFIG_FUNCTION_GRAPH_TRACER
+   cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
+	"$(if $(CONFIG_64BIT),64,32)" \
+	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" "$(MV)" \
+	"$(if $(part-of-module),1,0)" "-1" "$(@)";
+ endif
+ endif
+
 endif
 
 define rule_cc_o_c
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index ea6f6e3..22c4644 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -113,14 +113,14 @@ $P =~ s@.*/@@g;
 
 my $V = '0.1';
 
-if ($#ARGV != 11) {
-	print "usage: $P arch endian bits objdump objcopy cc ld nm rm mv is_module inputfile\n";
+if ($#ARGV < 12) {
+	print "usage: $P arch endian bits objdump objcopy cc ld nm rm mv is_module do_check inputfile\n";
 	print "version: $V\n";
 	exit(1);
 }
 
 my ($arch, $endian, $bits, $objdump, $objcopy, $cc,
-    $ld, $nm, $rm, $mv, $is_module, $inputfile) = @ARGV;
+    $ld, $nm, $rm, $mv, $is_module, $do_check, $inputfile) = @ARGV;
 
 # This file refers to mcount and shouldn't be ftraced, so lets' ignore it
 if ($inputfile =~ m,kernel/trace/ftrace\.o$,) {
@@ -144,6 +144,60 @@ $nm = "nm" if ((length $nm) == 0);
 $rm = "rm" if ((length $rm) == 0);
 $mv = "mv" if ((length $mv) == 0);
 
+# gcc can do stupid things with the stack pointer on x86_32.
+# It may pass a copy of the return address to mcount, which will
+# break the function graph tracer. If this happens then we need
+# to flag it and break the build.
+#
+# For x86_32, the parameter do_check will be negative if we only
+# want to perform the check, and positive if we should od the check.
+# If function graph tracing is not enabled, do_check will be zero.
+#
+
+my $check_next_line = 0;
+my $line_failed = 0;
+my $last_function;
+
+sub test_x86_32_prologue
+{
+    if ($check_next_line) {
+	if (!/push\s*\%ebp/) {
+	    $line_failed = 1;
+	}
+    }
+
+    if ($line_failed && /mcount/) {
+	print STDERR "\n********************************************************\n";
+	print STDERR "  Your version of GCC breaks the function graph tracer\n";
+	print STDERR "  Please disable CONFIG_FUNCTION_GRAPH_TRACER\n";
+	print STDERR "  Failed function was \"$last_function\"\n";
+	print STDERR "********************************************************\n\n";
+	exit -1;
+    }
+    $check_next_line = 0;
+
+    # check the first line after a function starts for
+    #  push %ebp
+    if (/^[0-9a-fA-F]+\s+<([a-zA-Z_].*)>:$/) {
+	$last_function = $1;
+	$check_next_line = 1;
+	$line_failed = 0;
+    }
+}
+
+if ($do_check < 0) {
+    # Only perform the check and quit
+    open(IN, "$objdump -dr $inputfile|") || die "error running $objdump";
+
+    while (<IN>) {
+	test_x86_32_prologue;
+    }
+    close (IN);
+    exit 0;
+}
+
+my $check = 0;
+
 #print STDERR "running: $P '$arch' '$objdump' '$objcopy' '$cc' '$ld' " .
 #    "'$nm' '$rm' '$mv' '$inputfile'\n";
 
@@ -202,6 +256,12 @@ if ($arch =~ /(x86(_64)?)|(i386)/) {
     }
 }
 
+if ($arch eq "i386") {
+    if ($do_check) {
+	$check = 1;
+    }
+}
+
 #
 # We base the defaults off of i386, the other archs may
 # feel free to change them in the below if statements.
@@ -470,6 +530,12 @@ while (<IN>) {
 	    "\tstill causes an issue, then disable CONFIG_DYNAMIC_FTRACE.\n";
 	exit(-1);
     }
+    # x86_32 may need to test the start of every function to see
+    # if GCC did not mess up the mcount prologue. All functions must
+    # start with push %ebp, otherwise it is broken.
+    if ($check) {
+	test_x86_32_prologue;
+    }
 
     # is it a section?
     if (/$section_regex/) {
-- 
1.6.6.1

