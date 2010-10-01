Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab0JAQRF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 12:17:05 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:31279
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752345Ab0JAQRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 12:17:02 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Oct 2010 12:17:01 EDT
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h43h63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L9MCH5-02-D87-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Will Deacon <will.deacon@arm.com>,
        Matt Fleming <matt@console-pimps.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 1/5] oprofile, x86: Simplify init/exit functions
Date: Fri, 1 Oct 2010 17:56:23 +0200
Message-ID: <1285948587-24521-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285948587-24521-1-git-send-email-robert.richter@amd.com>
References: <1285948587-24521-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, that we only call the exit function if init succeeds with commit:

 979048e oprofile: don't call arch exit code from init code on failure

we can simplify the x86 init/exit functions too. Variable using_nmi
becomes obsolete.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index f1575c9..bd1489c 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -695,9 +695,6 @@ static int __init ppro_init(char **cpu_type)
 	return 1;
 }
 
-/* in order to get sysfs right */
-static int using_nmi;
-
 int __init op_nmi_init(struct oprofile_operations *ops)
 {
 	__u8 vendor = boot_cpu_data.x86_vendor;
@@ -705,8 +702,6 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 	char *cpu_type = NULL;
 	int ret = 0;
 
-	using_nmi = 0;
-
 	if (!cpu_has_apic)
 		return -ENODEV;
 
@@ -790,13 +785,11 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 	if (ret)
 		return ret;
 
-	using_nmi = 1;
 	printk(KERN_INFO "oprofile: using NMI interrupt.\n");
 	return 0;
 }
 
 void op_nmi_exit(void)
 {
-	if (using_nmi)
-		exit_sysfs();
+	exit_sysfs();
 }
-- 
1.7.2.2


