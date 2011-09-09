Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298Ab1IIK1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 06:27:41 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:55873 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758687Ab1IIK1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 06:27:37 -0400
Message-Id: <20110909102732.657749229@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Fri, 09 Sep 2011 12:27:01 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: vgoyal@redhat.com
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 2/2] s390: Export vmcoreinfo note
References: <20110909102659.320220628@linux.vnet.ibm.com>
Content-Disposition: inline; filename=s390-kdump-arch-vmcoreinfo.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

This patch defines for s390 an ABI defined pointer to the vmcoreinfo note at
a well known address. With this patch tools are able to find this information
in dumps created by stand-alone or hypervisor dump tools.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 arch/s390/include/asm/lowcore.h |    3 ++-
 arch/s390/kernel/setup.c        |    8 ++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/arch/s390/include/asm/lowcore.h
+++ b/arch/s390/include/asm/lowcore.h
@@ -287,7 +287,8 @@ struct _lowcore {
 	 */
 	__u64	ipib;				/* 0x0e00 */
 	__u32	ipib_checksum;			/* 0x0e08 */
-	__u8	pad_0x0e0c[0x0f00-0x0e0c];	/* 0x0e0c */
+	__u64	vmcore_info;			/* 0x0e0c */
+	__u8	pad_0x0e14[0x0f00-0x0e14];	/* 0x0e14 */
 
 	/* Extended facility list */
 	__u64	stfle_fac_list[32];		/* 0x0f00 */
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -559,6 +559,13 @@ static void __init setup_restart_psw(voi
 	copy_to_absolute_zero(&S390_lowcore.restart_psw, &psw, sizeof(psw));
 }
 
+static void __init setup_vmcoreinfo(void)
+{
+	unsigned long ptr = paddr_vmcoreinfo_note();
+
+	copy_to_absolute_zero(&S390_lowcore.vmcore_info, &ptr, sizeof(ptr));
+}
+
 #ifdef CONFIG_CRASH_DUMP
 
 /*
@@ -1019,6 +1026,7 @@ setup_arch(char **cmdline_p)
 	reserve_crashkernel();
 	setup_memory();
 	setup_resources();
+	setup_vmcoreinfo();
 	setup_restart_psw();
 	setup_lowcore();
 

