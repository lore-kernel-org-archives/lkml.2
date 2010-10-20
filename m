Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab0JTIfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 04:35:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37844 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab0JTIfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 04:35:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LYc/t12bHAoMBtUDpvbM3pDA3GTgiIUEymMAlfF5NZvtz/1CS2IYugI6Z4AUA2K8v1
         N/wDe4rwVCvMwzxnpfbSS4bj7fYjk/QYaV/P0CK3/D1CVeHcaLX56Wj6V3TUtRuAHrl8
         31qTDbA1vwsEHsKpsT5xiGTrflYDD18qPXSMc=
MIME-Version: 1.0
In-Reply-To: <1287542932-14206-5-git-send-email-x0095840@ti.com>
References: <1287542932-14206-1-git-send-email-x0095840@ti.com>
	<1287542932-14206-2-git-send-email-x0095840@ti.com>
	<1287542932-14206-3-git-send-email-x0095840@ti.com>
	<1287542932-14206-4-git-send-email-x0095840@ti.com>
	<1287542932-14206-5-git-send-email-x0095840@ti.com>
Date: Wed, 20 Oct 2010 11:35:50 +0300
Message-ID: <AANLkTimSQabHv3AOFFR4m3POjmuGvN18u7TNsPyauH8D@mail.gmail.com>
Subject: Re: [PATCHv4 4/4] iommu: create new api to set valid da range
From: "felipe.contreras@gmail.com" <felipe.contreras@gmail.com>
To: Fernando Guzman Lugo <x0095840@ti.com>
Cc: Hiroshi.DOYU@nokia.com, felipe.contreras@nokia.com, david.cohen@nokia.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 5:48 AM, Fernando Guzman Lugo <x0095840@ti.com> wrote:
> Some IOMMUs cannot use the whole 0x0 - 0xFFFFFFFF range.
> With this new API the valid range can be set.
>
> Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>

I don't see the point in having an API. It could be done through
platform data, and the usage of 0xFFFFF000 instead of ULONG_MAX is
independent of this.

diff --git a/arch/arm/mach-omap2/omap-iommu.c b/arch/arm/mach-omap2/omap-iommu.c
index f5a1aad..db919254 100644
--- a/arch/arm/mach-omap2/omap-iommu.c
+++ b/arch/arm/mach-omap2/omap-iommu.c
@@ -43,6 +43,7 @@ static struct iommu_device omap3_devices[] = {
 			.name = "iva2",
 			.nr_tlb_entries = 32,
 			.clk_name = "iva2_ck",
+			.start_addr = 0x11000000,
 		},
 	},
 #endif
diff --git a/arch/arm/plat-omap/include/plat/iommu.h
b/arch/arm/plat-omap/include/plat/iommu.h
index 33c7d41..94f3a9a 100644
--- a/arch/arm/plat-omap/include/plat/iommu.h
+++ b/arch/arm/plat-omap/include/plat/iommu.h
@@ -50,6 +50,8 @@ struct iommu {
 	int (*isr)(struct iommu *obj);

 	void *ctx; /* iommu context: registres saved area */
+
+	u32		start_addr;
 };

 struct cr_regs {
@@ -103,6 +105,7 @@ struct iommu_platform_data {
 	const char *name;
 	const char *clk_name;
 	const int nr_tlb_entries;
+	u32 start_addr;
 };

 #if defined(CONFIG_ARCH_OMAP1)
diff --git a/arch/arm/plat-omap/iommu.c b/arch/arm/plat-omap/iommu.c
index 6336ae2..3023d0b 100644
--- a/arch/arm/plat-omap/iommu.c
+++ b/arch/arm/plat-omap/iommu.c
@@ -926,6 +926,10 @@ static int __devinit omap_iommu_probe(struct
platform_device *pdev)
 	obj->name = pdata->name;
 	obj->dev = &pdev->dev;
 	obj->ctx = (void *)obj + sizeof(*obj);
+	obj->start_addr = pdata->start_addr;
+
+	if (!obj->start_addr)
+		obj->start_addr = PAGE_SIZE;

 	mutex_init(&obj->iommu_lock);
 	mutex_init(&obj->mmap_lock);
diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
index f318476..fd0c93f 100644
--- a/arch/arm/plat-omap/iovmm.c
+++ b/arch/arm/plat-omap/iovmm.c
@@ -284,7 +284,7 @@ static struct iovm_struct *alloc_iovm_area(struct
iommu *obj, u32 da,
 		/*
 		 * Reserve the first page for NULL
 		 */
-		start = PAGE_SIZE;
+		start = obj->start_addr;
 		if (flags & IOVMF_LINEAR)
 			alignement = iopgsz_max(bytes);
 		start = roundup(start, alignement);

-- 
Felipe Contreras
