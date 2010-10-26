Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab0JZGqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 02:46:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:46082 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756778Ab0JZGqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 02:46:32 -0400
Date: Tue, 26 Oct 2010 06:46:10 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        robert.richter@amd.com, tglx@linutronix.de, mingo@elte.hu,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, tglx@linutronix.de, borislav.petkov@amd.com,
        mingo@elte.hu
In-Reply-To: <1288015419-29543-6-git-send-email-robert.richter@amd.com>
References: <1288015419-29543-6-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mce] apic, amd: Make firmware bug messages more meaningful
Message-ID: <tip-eb48c9cb2053e7bb5f7f8f0371cb578a0d439450@git.kernel.org>
Git-Commit-ID: eb48c9cb2053e7bb5f7f8f0371cb578a0d439450
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Oct 2010 06:46:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eb48c9cb2053e7bb5f7f8f0371cb578a0d439450
Gitweb:     http://git.kernel.org/tip/eb48c9cb2053e7bb5f7f8f0371cb578a0d439450
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Mon, 25 Oct 2010 16:03:39 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 25 Oct 2010 18:59:43 +0200

apic, amd: Make firmware bug messages more meaningful

This improves error messages in case the BIOS was setting up
wrong LVT offsets.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Acked-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <1288015419-29543-6-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
