Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab1I0Isa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 04:48:30 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45441 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab1I0Is2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 04:48:28 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.46.211]
In-Reply-To: <CAHQjnOPdsf-QB3st94WRSH325j8WPOLLe4rqv0WN1qK1KYWtmA@mail.gmail.com>
References: <15669786.49881316849426265.JavaMail.weblogic@epml24>
 <CAK=WgbYnGjPKs6_nmFRGfMnbh_7wDR-0QcptAGaqDKVOo-x3cg@mail.gmail.com>
 <CAHQjnOOtVHUS3KmBz7LdO88fLQyLA6f-w3ye9nAH0Bx+zh38XA@mail.gmail.com>
 <CAK=Wgbazwz9PRJSpZjopwxJ-PO88FtajmbXL=pVKDHOr1t61fQ@mail.gmail.com>
 <CAHQjnON7dksupFeAYLuYXX2PhgjX-GXEGJiy0dRTmpoBjbURVg@mail.gmail.com>
 <CAK=WgbaOwe8Q19tpZMeHdvyCj8fcV194zA-oSD20tF7j7_MvpQ@mail.gmail.com>
 <CAHQjnOM_KTiqzYnePScMHQ3bg5X1wqa4zu6=1A1z7UWeDxVZvQ@mail.gmail.com>
 <CAK=WgbYzZKTRRf6hk=L5ZvXmFAUpq66Ud3F7xh2-8j6zSvAq9g@mail.gmail.com> <CAHQjnOPdsf-QB3st94WRSH325j8WPOLLe4rqv0WN1qK1KYWtmA@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 27 Sep 2011 11:48:07 +0300
Message-ID: <CAK=Wgbbf2XbDrp6q5G3_7og+0wsmFmqpCsx_nDYTyRTa0-YBmg@mail.gmail.com>
Subject: Re: [PATCH 3/4] iommu/exynos: Add iommu driver for Exynos4 Platforms
To: KyongHo Cho <pullip.cho@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        =?UTF-8?B?7J207IOB7ZiE?= <sanghyun75.lee@samsung.com>,
        =?UTF-8?B?6rmA6rWt7KeE?= <kgene.kim@samsung.com>,
        =?UTF-8?B?6rmA7JiB6529?= <younglak1004.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 3:56 AM, KyongHo Cho <pullip.cho@samsung.com> wrote:
> I wanted the IOMMU driver to provide default fault handler to its users
> that does not provide fault handler for debugging purpose.
> If a user want to handle MMU fault, IOMMU driver welcomes to overwrite
> the existing 'default' fault handler.

Ok, this one patch below should allow you to do that.
report_iommu_fault() will now reliably tell you if a fault handler
failed or not, or if one isn't even installed.

This way your IOMMU driver doesn't need to define a fault handler of
its own, and instead, can do everything directly in
exynos_sysmmu_irq() where all the required information is now
available.

Thanks,
Ohad.

>From 0f2287abe5761e40d25f0da0c8e7964d18ebb3ef Mon Sep 17 00:00:00 2001
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 27 Sep 2011 11:14:22 +0300
Subject: [PATCH] iommu/core: let drivers know if an iommu fault
handler isn't installed

Let report_iommu_fault() return -ENOSYS whenever an iommu fault
handler isn't installed, so IOMMU drivers can then do their own
platform-specific default behavior if they want.

Clarify that -ENOSYS is reserved for this purpose, and that fault
handlers are prohibited from using it.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/iommu/iommu.c |    7 +++++++
 include/linux/iommu.h |    3 ++-
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 3a07259..c41a6a1 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -43,6 +43,13 @@ EXPORT_SYMBOL_GPL(iommu_found);
  * iommu_set_fault_handler() - set a fault handler for an iommu domain
  * @domain: iommu domain
  * @handler: fault handler
+ *
+ * This function should be used by IOMMU users which want to be notified
+ * whenever an IOMMU fault happens.
+ *
+ * The fault handler itself should return 0 on success, and an appropriate
+ * error code otherwise. It should never return -ENOSYS though, as this is
+ * reserved for the IOMMU core to return when no handler is installed.
  */
 void iommu_set_fault_handler(struct iommu_domain *domain,
 					iommu_fault_handler_t handler)
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index d084e87..2987199 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -98,11 +98,12 @@ extern void iommu_set_fault_handler(struct
iommu_domain *domain,
  * Returns 0 on success and an appropriate error code otherwise (if dynamic
  * PTE/TLB loading will one day be supported, implementations will be able
  * to tell whether it succeeded or not according to this return value).
+ * If a fault handler isn't installed, -ENOSYS is returned.
  */
 static inline int report_iommu_fault(struct iommu_domain *domain,
 		struct device *dev, unsigned long iova, int flags)
 {
-	int ret = 0;
+	int ret = -ENOSYS;

 	/*
 	 * if upper layers showed interest and installed a fault handler,
-- 
1.7.4.1
