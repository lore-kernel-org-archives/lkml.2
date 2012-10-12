Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759785Ab2JLQ3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 12:29:34 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:37833 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757988Ab2JLQ3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 12:29:32 -0400
Message-ID: <1350059367.2643.17.camel@lorien2>
Subject: [PATCH -stable] amd_iommu: attach device fails on the last pci
 device
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: joerg.roedel@amd.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Greg KH <gregkh@linuxfoundation.org>
Cc: iommu@lists.linux-foundation.org, stable@vger.kernel.org, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com
Date: Fri, 12 Oct 2012 10:29:27 -0600
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

amd_iommu_attach_device() checks if device id is within the limits
of amd_iommu_last_bdf and instead checking if devid > amd_iommu_last_bdf,
it checks devid >= amd_iommu_last_bdf. As a result the last device attach
fails because amd_iommu_attach_device() returns an -EINVAL.

This bug is in linux-2.6.32 and an equivalent fix in linux-2.6.33 and has been
carried forward to later kernels and is in the upstream kernel. This equivalent
fix includes restructuring and consolidating device checks into a routine
check_device(). Instead of back-porting all of that work, spot-fixed the bug in
amd_iommu_attach_device() for linux-2.6.32.

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
CC: <stable@vger.kernel.org> v2.6.32
---
 arch/x86/kernel/amd_iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 3a44b75..67de7d7 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -2288,7 +2288,7 @@ static int amd_iommu_attach_device(struct iommu_domain *dom,
 
 	devid = calc_devid(pdev->bus->number, pdev->devfn);
 
-	if (devid >= amd_iommu_last_bdf ||
+	if (devid > amd_iommu_last_bdf ||
 			devid != amd_iommu_alias_table[devid])
 		return -EINVAL;
 
-- 
1.7.9.5



