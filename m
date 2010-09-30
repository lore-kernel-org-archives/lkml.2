Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab0I3GYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 02:24:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754426Ab0I3GYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 02:24:54 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kbuild@vger.kernel.org
Cc: Amerigo Wang <amwang@redhat.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] Improve namespace.pl to get more correct result
Date: Thu, 30 Sep 2010 14:28:58 +0800
Message-Id: <1285828138-5873-4-git-send-email-amwang@redhat.com>
In-Reply-To: <1285828138-5873-1-git-send-email-amwang@redhat.com>
References: <1285828138-5873-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exclude more symbols from arch/x86/vdso/ and arch/x86/boot/;
add some more linker-defined symbols into exception list;
add other cond_syscalls besides "sys_*".

Signed-off-by: Amerigo Wang <amwang@redhat.com>
---
 scripts/namespace.pl |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/scripts/namespace.pl b/scripts/namespace.pl
index bccf610..a71be6b 100755
--- a/scripts/namespace.pl
+++ b/scripts/namespace.pl
@@ -133,6 +133,12 @@ my %nameexception = (
     '__nosave_begin'	=> 1,
     '__nosave_end'	=> 1,
     'pg0'		=> 1,
+    'vdso_enabled'	=> 1,
+    '__stack_chk_fail'  => 1,
+    'VDSO32_PRELINK'	=> 1,
+    'VDSO32_vsyscall'	=> 1,
+    'VDSO32_rt_sigreturn'=>1,
+    'VDSO32_sigreturn'	=> 1,
 );
 
 
@@ -157,7 +163,8 @@ sub linux_objects
 	if (/.*\.o$/ &&
 		! (
 		m:/built-in.o$:
-		|| m:arch/x86/kernel/vsyscall-syms.o$:
+		|| m:arch/x86/vdso/:
+		|| m:arch/x86/boot/:
 		|| m:arch/ia64/ia32/ia32.o$:
 		|| m:arch/ia64/kernel/gate-syms.o$:
 		|| m:arch/ia64/lib/__divdi3.o$:
@@ -200,6 +207,7 @@ sub linux_objects
 		|| m:^.*/\.tmp_:
 		|| m:^\.tmp_:
 		|| m:/vmlinux-obj.o$:
+		|| m:^tools/:
 		)
 	) {
 		do_nm($basename, $_);
@@ -355,20 +363,15 @@ sub list_multiply_defined
 	foreach my $name (keys(%def)) {
 		if ($#{$def{$name}} > 0) {
 			# Special case for cond_syscall
-			if ($#{$def{$name}} == 1 && $name =~ /^sys_/) {
+			if ($#{$def{$name}} == 1 &&
+			   ($name =~ /^sys_/ || $name =~ /^compat_sys_/ ||
+			    $name =~ /^sys32_/)) {
 				if($def{$name}[0] eq "kernel/sys_ni.o" ||
 				   $def{$name}[1] eq "kernel/sys_ni.o") {
 					&drop_def("kernel/sys_ni.o", $name);
 					next;
 				}
 			}
-			# Special case for i386 entry code
-			if ($#{$def{$name}} == 1 && $name =~ /^__kernel_/ &&
-			    $def{$name}[0] eq "arch/x86/kernel/vsyscall-int80_32.o" &&
-			    $def{$name}[1] eq "arch/x86/kernel/vsyscall-sysenter_32.o") {
-				&drop_def("arch/x86/kernel/vsyscall-sysenter_32.o", $name);
-				next;
-			}
 
 			printf "$name is multiply defined in :-\n";
 			foreach my $module (@{$def{$name}}) {
-- 
1.6.5.2

