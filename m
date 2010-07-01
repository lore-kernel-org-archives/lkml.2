Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab0GARQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 13:16:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55878 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab0GARQm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 13:16:42 -0400
From: "Kanigeri, Hari" <h-kanigeri2@ti.com>
To: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "ohad@wizery.com" <ohad@wizery.com>,
       "hiroshi.doyo@nokia.com" <hiroshi.doyo@nokia.com>,
       "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
       "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>,
       "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
Date: Thu, 1 Jul 2010 12:16:38 -0500
Subject: RE: [PATCHv3 5/9] dspbridge: add mmufault support
Thread-Topic: [PATCHv3 5/9] dspbridge: add mmufault support
Thread-Index: AcsYr29geLDqkvcsTwW6nxBnghiRywAkS5Rw
Message-ID: <8F7AF80515AF0D4D93307E594F3CB40E4CA563BC@dlee03.ent.ti.com>
References: <1277942401-3566-1-git-send-email-x0095840@ti.com>
 <1277942401-3566-2-git-send-email-x0095840@ti.com>
 <1277942401-3566-3-git-send-email-x0095840@ti.com>
 <1277942401-3566-4-git-send-email-x0095840@ti.com>
 <1277942401-3566-5-git-send-email-x0095840@ti.com>
 <1277942401-3566-6-git-send-email-x0095840@ti.com>
In-Reply-To: <1277942401-3566-6-git-send-email-x0095840@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fernando,

> +int mmu_fault_isr(struct iommu *mmu)
> 
> -/*
> - *  ======== mmu_check_if_fault =======
> - *      Check to see if MMU Fault is valid TLB miss from DSP
> - *  Note: This function is called from an ISR
> - */
> -static bool mmu_check_if_fault(struct bridge_dev_context *dev_context)
>  {
> +	struct deh_mgr *dm;
> +	u32 da;
> +
> +	dev_get_deh_mgr(dev_get_first(), &dm);
> +
> +	if (!dm)
> +		return -EPERM;
> +
> +	da = iommu_read_reg(mmu, MMU_FAULT_AD);
> +	iommu_write_reg(mmu, 0, MMU_IRQENABLE);

-- Isn't the MMU already enabled at this point when the function callback is called by iommu ?

> +	dm->err_info.dw_val1 = da;
> +	tasklet_schedule(&dm->dpc_tasklet);

-- The iommu fault isr disables the IOMMU at the end of the fault handler, so by the time your tasklet is scheduled you might have the MMU in a disabled state. Looks to me either this requires change in iommu to remove the disable part or enable the MMU in the tasklet instead of doing it early in mmu_fault_isr.

Thank you,
Best regards,
Hari
