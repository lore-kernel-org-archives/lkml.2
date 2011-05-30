Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab1E3OmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 10:42:07 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:27604
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752537Ab1E3OmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 10:42:05 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz4015L1432N98dKzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LM0JHX-02-5YK-02
X-M-MSG: 
Date: Mon, 30 May 2011 16:41:57 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] oprofile fixes for v2.6.40
Message-ID: <20110530144157.GL20052@erda.amd.com>
References: <20110526133948.GX20052@erda.amd.com>
 <20110527122301.GA32754@elte.hu>
 <20110530100039.GB20052@erda.amd.com>
 <20110530100956.GA17821@elte.hu>
 <20110530101619.GC20052@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110530101619.GC20052@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.05.11 12:16:19, Robert Richter wrote:
> On 30.05.11 06:09:56, Ingo Molnar wrote:
> > The way IBS is set up is not very obvious and atypical of existing 
> > preempt_*() patters. Might be worth adding a comment to the 
> > preempt_disable(), to unconfuse unsuspecting readers who are 
> > wondering about its oddness?
> 
> Yes, will add some comments.

Ingo,

please see below and apply the patch to tip, if it makes sense to you.

Thanks,

-Robert



>From cbf74cea070fa1f705de4712e25d9e56ae6543c7 Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Mon, 30 May 2011 16:31:11 +0200
Subject: [PATCH] oprofile, x86: Add comments to IBS LVT offset initialization

Adding a comment in the code as IBS LVT setup is not obvious at all ...

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/apic/apic.c      |    3 ++-
 arch/x86/oprofile/op_model_amd.c |   13 +++++++++----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index fabf01e..a0bf78a 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -390,7 +390,8 @@ static unsigned int reserve_eilvt_offset(int offset, unsigned int new)
 
 /*
  * If mask=1, the LVT entry does not generate interrupts while mask=0
- * enables the vector. See also the BKDGs.
+ * enables the vector. See also the BKDGs. Must be called with
+ * preemption disabled.
  */
 
 int setup_APIC_eilvt(u8 offset, u8 vector, u8 msg_type, u8 mask)
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 9fd8a56..9cbb710 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -609,16 +609,21 @@ static int setup_ibs_ctl(int ibs_eilvt_off)
 	return 0;
 }
 
+/*
+ * This runs only on the current cpu. We try to find an LVT offset and
+ * setup the local APIC. For this we must disable preemption. On
+ * success we initialize all nodes with this offset. This updates then
+ * the offset in the IBS_CTL per-node msr. The per-core APIC setup of
+ * the IBS interrupt vector is called from op_amd_setup_ctrs()/op_-
+ * amd_cpu_shutdown() using the new offset.
+ */
 static int force_ibs_eilvt_setup(void)
 {
 	int offset;
 	int ret;
 
-	/*
-	 * find the next free available EILVT entry, skip offset 0,
-	 * pin search to this cpu
-	 */
 	preempt_disable();
+	/* find the next free available EILVT entry, skip offset 0 */
 	for (offset = 1; offset < APIC_EILVT_NR_MAX; offset++) {
 		if (get_eilvt(offset))
 			break;
-- 
1.7.5.rc3



-- 
Advanced Micro Devices, Inc.
Operating System Research Center

