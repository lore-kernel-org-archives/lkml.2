Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab0GARyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 13:54:39 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54311 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab0GARyh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 13:54:37 -0400
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: "Kanigeri, Hari" <h-kanigeri2@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "ohad@wizery.com" <ohad@wizery.com>, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
       "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
       "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>
Date: Thu, 1 Jul 2010 12:54:30 -0500
Subject: RE: [PATCHv3 5/9] dspbridge: add mmufault support
Thread-Topic: [PATCHv3 5/9] dspbridge: add mmufault support
Thread-Index: AcsYr29geLDqkvcsTwW6nxBnghiRywAkS5RwAAFMioA=
Message-ID: <496565EC904933469F292DDA3F1663E602CBDD373C@dlee06.ent.ti.com>
References: <1277942401-3566-1-git-send-email-x0095840@ti.com>
 <1277942401-3566-2-git-send-email-x0095840@ti.com>
 <1277942401-3566-3-git-send-email-x0095840@ti.com>
 <1277942401-3566-4-git-send-email-x0095840@ti.com>
 <1277942401-3566-5-git-send-email-x0095840@ti.com>
 <1277942401-3566-6-git-send-email-x0095840@ti.com>
 <8F7AF80515AF0D4D93307E594F3CB40E4CA563BC@dlee03.ent.ti.com>
In-Reply-To: <8F7AF80515AF0D4D93307E594F3CB40E4CA563BC@dlee03.ent.ti.com>
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



Hi Hari,

> -----Original Message-----
> From: Kanigeri, Hari
> Sent: Thursday, July 01, 2010 12:17 PM
> To: Guzman Lugo, Fernando; linux-omap@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Cc: ohad@wizery.com; hiroshi.doyo@nokia.com; ameya.palande@nokia.com;
> felipe.contreras@nokia.com; Guzman Lugo, Fernando
> Subject: RE: [PATCHv3 5/9] dspbridge: add mmufault support
> 
> Hi Fernando,
> 
> > +int mmu_fault_isr(struct iommu *mmu)
> >
> > -/*
> > - *  ======== mmu_check_if_fault =======
> > - *      Check to see if MMU Fault is valid TLB miss from DSP
> > - *  Note: This function is called from an ISR
> > - */
> > -static bool mmu_check_if_fault(struct bridge_dev_context *dev_context)
> >  {
> > +	struct deh_mgr *dm;
> > +	u32 da;
> > +
> > +	dev_get_deh_mgr(dev_get_first(), &dm);
> > +
> > +	if (!dm)
> > +		return -EPERM;
> > +
> > +	da = iommu_read_reg(mmu, MMU_FAULT_AD);
> > +	iommu_write_reg(mmu, 0, MMU_IRQENABLE);
> 
> -- Isn't the MMU already enabled at this point when the function callback
> is called by iommu ?

This line is actually disabling the interrupts. I am writing "0x0" in the MMU_IRQENABLE.

> 
> > +	dm->err_info.dw_val1 = da;
> > +	tasklet_schedule(&dm->dpc_tasklet);
> 
> -- The iommu fault isr disables the IOMMU at the end of the fault handler,
> so by the time your tasklet is scheduled you might have the MMU in a
> disabled state. Looks to me either this requires change in iommu to remove
> the disable part or enable the MMU in the tasklet instead of doing it
> early in mmu_fault_isr.

I am returning 0 in the callback function, that means the callback function has managed the fault and the mmu_fault_isr does not do anything else


	if (obj->isr)
		err = obj->isr(obj);

	if (!err)
		return IRQ_HANDLED;

it is working for me without not modifications in the iommu_fault_handler function.

Thanks for the comments,
Fernando.

> 
> Thank you,
> Best regards,
> Hari
