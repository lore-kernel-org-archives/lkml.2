Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab0JMW6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 18:58:41 -0400
Received: from mail.vyatta.com ([76.74.103.46]:41442 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496Ab0JMW6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 18:58:40 -0400
Date: Wed, 13 Oct 2010 15:58:30 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Amerigo Wang <amwang@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] namespace: add source file location exceptions
Message-ID: <20101013155830.169ca022@nehalam>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Teach namespace checker about some special case files where the
source is in unusual location.  This fixes many of the source file
not found errors (more can be added), and also prevents false positives
for functions not being used.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
---
Applies after previous patches by Amerigo Wang

--- a/scripts/namespace.pl	2010-10-13 15:01:56.695801914 -0700
+++ b/scripts/namespace.pl	2010-10-13 15:29:15.454600976 -0700
@@ -141,6 +141,26 @@ my %nameexception = (
     'VDSO32_sigreturn'	=> 1,
 );
 
+# Files with exceptions to source file location
+my %sourceloc = (
+    'net/dccp/dccp_probe.o'	=> 'probe',
+    'net/dccp/dccp_ipv4.o'	=> 'ipv4',
+    'net/dccp/dccp_ipv6.o'	=> 'ipv6',
+    'net/dccp/dccp_diag.o'	=> 'diag',
+    'drivers/char/hw_random/rng-core.o'	=> 'core',
+    'fs/fat/msdos.o'		=> 'namei_msdos',
+    'fs/fat/vfat.o'		=> 'namei_vfat',
+    'fs/nfs_common/nfs_acl.o'	=> 'nfsacl',
+    'sound/soundcore.o'		=> 'sound_core',
+    'drivers/md/dm-mirror.o'	=> 'dm-raid1',
+    'drivers/message/i2o/i2o_bus.o' => 'bus-osm',
+    'arch/x86/kvm/kvm-amd.o'	=> 'svm',
+    'arch/x86/kvm/kvm-intel.o'	=> 'vmx',
+    'arch/x86/crypto/twofish-x86_64.o' => 'twofish-x86_64-asm_64',
+    'arch/x86/crypto/aes-x86_64.o' => 'aes-x86_64-asm_64',
+    'arch/x86/crypto/aesni-intel.o' => 'aesni-intel_asm',
+    'arch/x86/crypto/salsa20-x86_64.o' => 'salsa20-x86_64-asm_64',
+);
 
 &find(\&linux_objects, '.');	# find the objects and do_nm on them
 &list_multiply_defined();
@@ -228,11 +248,15 @@ sub do_nm
 		return;
 	}
 	($source = $basename) =~ s/\.o$//;
+
+	$source = $sourceloc{$fullname} if ($sourceloc{$fullname});
+
 	if (-e "$source.c" || -e "$source.S") {
 		$source = "$objtree$File::Find::dir/$source";
 	} else {
 		$source = "$srctree$File::Find::dir/$source";
 	}
+
 	if (! -e "$source.c" && ! -e "$source.S") {
 		# No obvious source, exclude the object if it is conglomerate
 	        open(my $objdumpdata, "$objdump $basename|")
