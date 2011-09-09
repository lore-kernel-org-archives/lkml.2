Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718Ab1IIK1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 06:27:37 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:47953 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758408Ab1IIK1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 06:27:36 -0400
Message-Id: <20110909102732.497569031@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Fri, 09 Sep 2011 12:27:00 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: vgoyal@redhat.com
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 1/2] kdump: Initialize vmcoreinfo note at startup
References: <20110909102659.320220628@linux.vnet.ibm.com>
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

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
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

