Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab0I3GYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 02:24:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754426Ab0I3GYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 02:24:49 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kbuild@vger.kernel.org
Cc: Amerigo Wang <amwang@redhat.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] Some bug fixes for namespace.pl
Date: Thu, 30 Sep 2010 14:28:57 +0800
Message-Id: <1285828138-5873-3-git-send-email-amwang@redhat.com>
In-Reply-To: <1285828138-5873-1-git-send-email-amwang@redhat.com>
References: <1285828138-5873-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Teach namespace.pl to understand "V" and "v"
2. cond_syscalls are moved into kernel/sys_ni.c

Signed-off-by: Amerigo Wang <amwang@redhat.com>
---
 scripts/namespace.pl |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/scripts/namespace.pl b/scripts/namespace.pl
index c8d0922..bccf610 100755
--- a/scripts/namespace.pl
+++ b/scripts/namespace.pl
@@ -266,6 +266,7 @@ sub do_nm
 		# T global label/procedure
 		# U external reference
 		# W weak external reference to text that has been resolved
+		# V similar to W, but the value of the weak symbol becomes zero with no error.
 		# a assembler equate
 		# b static variable, uninitialised
 		# d static variable, initialised
@@ -274,8 +275,9 @@ sub do_nm
 		# s static variable, uninitialised, small bss
 		# t static label/procedures
 		# w weak external reference to text that has not been resolved
+		# v similar to w
 		# ? undefined type, used a lot by modules
-		if ($type !~ /^[ABCDGRSTUWabdgrstw?]$/) {
+		if ($type !~ /^[ABCDGRSTUWVabdgrstwv?]$/) {
 			printf STDERR "nm output for $fullname contains unknown type '$_'\n";
 		}
 		elsif ($name =~ /\./) {
@@ -286,7 +288,7 @@ sub do_nm
 			# binutils keeps changing the type for exported symbols, force it to R
 			$type = 'R' if ($name =~ /^__ksymtab/ || $name =~ /^__kstrtab/);
 			$name =~ s/_R[a-f0-9]{8}$//;	# module versions adds this
-			if ($type =~ /[ABCDGRSTW]/ &&
+			if ($type =~ /[ABCDGRSTWV]/ &&
 				$name ne 'init_module' &&
 				$name ne 'cleanup_module' &&
 				$name ne 'Using_Versions' &&
@@ -353,11 +355,12 @@ sub list_multiply_defined
 	foreach my $name (keys(%def)) {
 		if ($#{$def{$name}} > 0) {
 			# Special case for cond_syscall
-			if ($#{$def{$name}} == 1 && $name =~ /^sys_/ &&
-			    ($def{$name}[0] eq "kernel/sys.o" ||
-			     $def{$name}[1] eq "kernel/sys.o")) {
-				&drop_def("kernel/sys.o", $name);
-				next;
+			if ($#{$def{$name}} == 1 && $name =~ /^sys_/) {
+				if($def{$name}[0] eq "kernel/sys_ni.o" ||
+				   $def{$name}[1] eq "kernel/sys_ni.o") {
+					&drop_def("kernel/sys_ni.o", $name);
+					next;
+				}
 			}
 			# Special case for i386 entry code
 			if ($#{$def{$name}} == 1 && $name =~ /^__kernel_/ &&
-- 
1.6.5.2

