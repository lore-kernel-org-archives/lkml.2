Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab0JYOjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 10:39:41 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:16112 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755967Ab0JYOji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 10:39:38 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0LAUOPR-02-CXK-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 5/5] apic, amd: Make firmware bug messages more meaningful
Date: Mon, 25 Oct 2010 16:03:39 +0200
Message-ID: <1288015419-29543-6-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1288015419-29543-1-git-send-email-robert.richter@amd.com>
References: <1288015419-29543-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This improves error messages in case the BIOS was setting up wrong LVT
offsets.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/apic/apic.c      |   15 ++++++++-------
 arch/x86/oprofile/op_model_amd.c |    1 +
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 850657d..cb13048 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -433,17 +433,18 @@ int setup_APIC_eilvt(u8 offset, u8 vector, u8 msg_type, u8 mask)
 	reserved = reserve_eilvt_offset(offset, new);
 
 	if (reserved != new) {
-		pr_err(FW_BUG "cpu %d, try to setup vector 0x%x, but "
-		       "vector 0x%x was already reserved by another core, "
-		       "APIC%lX=0x%x\n",
-		       smp_processor_id(), new, reserved, reg, old);
+		pr_err(FW_BUG "cpu %d, try to use APIC%lX (LVT offset %d) for "
+		       "vector 0x%x, but the register is already in use for "
+		       "vector 0x%x on another cpu\n",
+		       smp_processor_id(), reg, offset, new, reserved);
 		return -EINVAL;
 	}
 
 	if (!eilvt_entry_is_changeable(old, new)) {
-		pr_err(FW_BUG "cpu %d, try to setup vector 0x%x but "
-		       "register already in use, APIC%lX=0x%x\n",
-		       smp_processor_id(), new, reg, old);
+		pr_err(FW_BUG "cpu %d, try to use APIC%lX (LVT offset %d) for "
+		       "vector 0x%x, but the register is already in use for "
+		       "vector 0x%x on this cpu\n",
+		       smp_processor_id(), reg, offset, new, old);
 		return -EBUSY;
 	}
 
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 42fb46f..08de254 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -566,6 +566,7 @@ static int force_ibs_eilvt_setup(void)
 		ret = setup_ibs_ctl(i);
 		if (ret)
 			return ret;
+		pr_err(FW_BUG "using offset %d for IBS interrupts\n", i);
 		return 0;
 	}
 
-- 
1.7.3.1


