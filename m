Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab0I3GYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 02:24:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754426Ab0I3GYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 02:24:44 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kbuild@vger.kernel.org
Cc: Stephen Hemminger <shemminger@vyatta.com>,
        Amerigo Wang <amwang@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] namespace.pl: update file exclusion list
Date: Thu, 30 Sep 2010 14:28:56 +0800
Message-Id: <1285828138-5873-2-git-send-email-amwang@redhat.com>
In-Reply-To: <1285828138-5873-1-git-send-email-amwang@redhat.com>
References: <1285828138-5873-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: Amerigo Wang <amwang@redhat.com>

---
 scripts/namespace.pl |  103 +++++++++++++++++++++++++++-----------------------
 1 files changed, 56 insertions(+), 47 deletions(-)

diff --git a/scripts/namespace.pl b/scripts/namespace.pl
index fb4e245..c8d0922 100755
--- a/scripts/namespace.pl
+++ b/scripts/namespace.pl
@@ -84,6 +84,58 @@ my %ksymtab = ();	# names that appear in __ksymtab_
 my %ref = ();		# $ref{$name} exists if there is a true external reference to $name
 my %export = ();	# $export{$name} exists if there is an EXPORT_... of $name
 
+my %nmexception = (
+    'fs/ext3/bitmap'			=> 1,
+    'fs/ext4/bitmap'			=> 1,
+    'arch/x86/lib/thunk_32'		=> 1,
+    'arch/x86/lib/cmpxchg'		=> 1,
+    'arch/x86/vdso/vdso32/note'		=> 1,
+    'lib/irq_regs'			=> 1,
+    'usr/initramfs_data'		=> 1,
+    'drivers/scsi/aic94xx/aic94xx_dump'	=> 1,
+    'drivers/scsi/libsas/sas_dump'	=> 1,
+    'lib/dec_and_lock'			=> 1,
+    'drivers/ide/ide-probe-mini'	=> 1,
+    'usr/initramfs_data'		=> 1,
+    'drivers/acpi/acpia/exdump'		=> 1,
+    'drivers/acpi/acpia/rsdump'		=> 1,
+    'drivers/acpi/acpia/nsdumpdv'	=> 1,
+    'drivers/acpi/acpia/nsdump'		=> 1,
+    'arch/ia64/sn/kernel/sn2/io'	=> 1,
+    'arch/ia64/kernel/gate-data'	=> 1,
+    'security/capability'		=> 1,
+    'fs/ntfs/sysctl'			=> 1,
+    'fs/jfs/jfs_debug'			=> 1,
+);
+
+my %nameexception = (
+    'mod_use_count_'	 => 1,
+    '__initramfs_end'	=> 1,
+    '__initramfs_start'	=> 1,
+    '_einittext'	=> 1,
+    '_sinittext'	=> 1,
+    'kallsyms_names'	=> 1,
+    'kallsyms_num_syms'	=> 1,
+    'kallsyms_addresses'=> 1,
+    '__this_module'	=> 1,
+    '_etext'		=> 1,
+    '_edata'		=> 1,
+    '_end'		=> 1,
+    '__bss_start'	=> 1,
+    '_text'		=> 1,
+    '_stext'		=> 1,
+    '__gp'		=> 1,
+    'ia64_unw_start'	=> 1,
+    'ia64_unw_end'	=> 1,
+    '__init_begin'	=> 1,
+    '__init_end'	=> 1,
+    '__bss_stop'	=> 1,
+    '__nosave_begin'	=> 1,
+    '__nosave_end'	=> 1,
+    'pg0'		=> 1,
+);
+
+
 &find(\&linux_objects, '.');	# find the objects and do_nm on them
 &list_multiply_defined();
 &resolve_external_references();
@@ -270,27 +322,9 @@ sub do_nm
 	close($nmdata);
 
 	if ($#nmdata < 0) {
-		if (
-			$fullname ne "lib/brlock.o"
-			&& $fullname ne "lib/dec_and_lock.o"
-			&& $fullname ne "fs/xfs/xfs_macros.o"
-			&& $fullname ne "drivers/ide/ide-probe-mini.o"
-			&& $fullname ne "usr/initramfs_data.o"
-			&& $fullname ne "drivers/acpi/executer/exdump.o"
-			&& $fullname ne "drivers/acpi/resources/rsdump.o"
-			&& $fullname ne "drivers/acpi/namespace/nsdumpdv.o"
-			&& $fullname ne "drivers/acpi/namespace/nsdump.o"
-			&& $fullname ne "arch/ia64/sn/kernel/sn2/io.o"
-			&& $fullname ne "arch/ia64/kernel/gate-data.o"
-			&& $fullname ne "drivers/ieee1394/oui.o"
-			&& $fullname ne "security/capability.o"
-			&& $fullname ne "sound/core/wrappers.o"
-			&& $fullname ne "fs/ntfs/sysctl.o"
-			&& $fullname ne "fs/jfs/jfs_debug.o"
-		) {
-			printf "No nm data for $fullname\n";
-		}
-		return;
+	    printf "No nm data for $fullname\n"
+		unless $nmexception{$fullname};
+	    return;
 	}
 	$nmdata{$fullname} = \@nmdata;
 }
@@ -372,31 +406,7 @@ sub resolve_external_references
 						$ref{$name} = ""
 					}
 				}
-				elsif (    $name ne "mod_use_count_"
-					&& $name ne "__initramfs_end"
-					&& $name ne "__initramfs_start"
-					&& $name ne "_einittext"
-					&& $name ne "_sinittext"
-					&& $name ne "kallsyms_names"
-					&& $name ne "kallsyms_num_syms"
-					&& $name ne "kallsyms_addresses"
-					&& $name ne "__this_module"
-					&& $name ne "_etext"
-					&& $name ne "_edata"
-					&& $name ne "_end"
-					&& $name ne "__bss_start"
-					&& $name ne "_text"
-					&& $name ne "_stext"
-					&& $name ne "__gp"
-					&& $name ne "ia64_unw_start"
-					&& $name ne "ia64_unw_end"
-					&& $name ne "__init_begin"
-					&& $name ne "__init_end"
-					&& $name ne "__bss_stop"
-					&& $name ne "__nosave_begin"
-					&& $name ne "__nosave_end"
-					&& $name ne "pg0"
-					&& $name ne "__module_text_address"
+				elsif ( ! $nameexception{$name}
 					&& $name !~ /^__sched_text_/
 					&& $name !~ /^__start_/
 					&& $name !~ /^__end_/
@@ -407,7 +417,6 @@ sub resolve_external_references
 					&& $name !~ /^__.*per_cpu_end/
 					&& $name !~ /^__alt_instructions/
 					&& $name !~ /^__setup_/
-					&& $name !~ /^jiffies/
 					&& $name !~ /^__mod_timer/
 					&& $name !~ /^__mod_page_state/
 					&& $name !~ /^init_module/
-- 
1.6.5.2

