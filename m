Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab1JSVgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 17:36:14 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:32890 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab1JSVgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 17:36:07 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: <linux-kernel@vger.kernel.org>
References: <m1lisj48q1.fsf@fess.ebiederm.org>
Date: Mon, 17 Oct 2011 14:20:15 -0700
In-Reply-To: <m1lisj48q1.fsf@fess.ebiederm.org> (Eric W. Biederman's message
	of "Mon, 17 Oct 2011 14:19:18 -0700")
Message-ID: <m1fwir48og.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1839nZtC/5MVWIllz9pPiIoeAXUlJi1n/s=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Thomas Gleixner <tglx@linutronix.de>,Ingo Molnar
	<mingo@redhat.com>,  "H. Peter Anvin" <hpa@zytor.com>,  x86@kernel.org
X-Spam-Relay-Country: **
Subject: [PATCH 2/2] x86 amd_gart_64: Verify we can perform the remapping requested
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Recently I had a driver try with a peculiar 2G dma memory limit.
The driver failed in weird and strange ways because the GART remapping
apperture had been allocated above 2G where the driver cound not reach,
and no error was reported when the mappings were setup.

Implement gart_dma_supported to test for this problem case and to return
and error if we can not support the remapping.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86/kernel/amd_gart_64.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_gart_64.c b/arch/x86/kernel/amd_gart_64.c
index 8a439d3..66279cb 100644
--- a/arch/x86/kernel/amd_gart_64.c
+++ b/arch/x86/kernel/amd_gart_64.c
@@ -519,6 +519,14 @@ static int gart_mapping_error(struct device *dev, dma_addr_t dma_addr)
 	return (dma_addr == bad_dma_addr);
 }
 
+static int gart_dma_supported(struct device *dev, u64 mask)
+{
+	unsigned long iommu_max_addr = iommu_bus_base + iommu_size - 1;
+
+	/* Fail if the gart window is too high to fit in the devices dma mask */
+	return iommu_max_addr <= mask;
+}
+
 static int no_agp;
 
 static __init unsigned long check_iommu_size(unsigned long aper, u64 aper_size)
@@ -703,6 +711,7 @@ static struct dma_map_ops gart_dma_ops = {
 	.alloc_coherent			= gart_alloc_coherent,
 	.free_coherent			= gart_free_coherent,
 	.mapping_error			= gart_mapping_error,
+	.dma_supported			= gart_dma_supported,
 };
 
 static void gart_iommu_shutdown(void)
-- 
1.7.2.5

