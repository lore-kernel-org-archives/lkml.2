Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab1ITOek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:34:40 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:44247 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab1ITOej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:34:39 -0400
Message-Id: <20110920143436.019045253@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Tue, 20 Sep 2011 16:34:01 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: akpm@linux-foundation.org
Cc: vgoyal@redhat.com, ebiederm@xmission.com, mahesh@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [patch 1/2] kdump: Initialize vmcoreinfo note at startup
References: <20110920143400.776127689@linux.vnet.ibm.com>
Content-Disposition: inline; filename=s390-kdump-common-vmcoreinfo-init.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

Currently the vmcoreinfo note is only initialized in case of kdump. On s390
it is possible to create kernel dumps with other dump mechanisms than kdump
(e.g. via hypervisor dump or stand-alone dump tools). For those dumps it
would also be desirable to include the vmcoreinfo data. To accomplish this,
with this patch the vmcoreinfo ELF note is always initialized, not only in
case of a (kdump) crash. On s390 we will add an ABI defined pointer at
a well known address to vmcoreinfo so that dump analysis tools are able to
find this information.

In particular on s390 we have a tool named zgetdump. With this tool it is
possible to convert dump formats on the fly using fuse. E.g. you can mount a
s390 stand-alone dump as ELF dump. When this is done, the tool finds the
vmcoreinfo in the stand-alone dump via the well known ABI defined address and
it creates the respective VMCOREINFO ELF note in the output ELF dump. This then
can be used e.g. by makedumpfile for dump filtering.  No more need for a
vmlinux file with debug information.

So this will look like the following:
$ zgetdump --mount standalone.dump -f elf /mnt
$ ls /mnt
  dump.elf
$ readelf -n /mnt/dump.elf
$ ...
  VMCOREINFO            0x00000474      Unknown note type: (0x00000000)
$ makedumpfile -c -d 31 /mnt/dump.elf dump.kdump

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
---
 kernel/kexec.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1392,24 +1392,23 @@ int __init parse_crashkernel(char 		 *cm
 }
 
 
-
-void crash_save_vmcoreinfo(void)
+static void update_vmcoreinfo_note(void)
 {
-	u32 *buf;
+	u32 *buf = (u32 *) vmcoreinfo_note;
 
 	if (!vmcoreinfo_size)
 		return;
-
-	vmcoreinfo_append_str("CRASHTIME=%ld", get_seconds());
-
-	buf = (u32 *)vmcoreinfo_note;
-
 	buf = append_elf_note(buf, VMCOREINFO_NOTE_NAME, 0, vmcoreinfo_data,
 			      vmcoreinfo_size);
-
 	final_note(buf);
 }
 
+void crash_save_vmcoreinfo(void)
+{
+	vmcoreinfo_append_str("CRASHTIME=%ld", get_seconds());
+	update_vmcoreinfo_note();
+}
+
 void vmcoreinfo_append_str(const char *fmt, ...)
 {
 	va_list args;
@@ -1495,6 +1494,7 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_NUMBER(PG_swapcache);
 
 	arch_crash_save_vmcoreinfo();
+	update_vmcoreinfo_note();
 
 	return 0;
 }

