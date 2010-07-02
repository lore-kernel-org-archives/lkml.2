Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301Ab0GBQkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 12:40:47 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56077 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759261Ab0GBQkg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 12:40:36 -0400
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ohad@wizery.com" <ohad@wizery.com>,
       "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
       "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>
Date: Fri, 2 Jul 2010 11:40:32 -0500
Subject: RE: [PATCH 1/9] dspbridge: replace iommu custom for opensource
 implementation
Thread-Topic: [PATCH 1/9] dspbridge: replace iommu custom for opensource
 implementation
Thread-Index: AcsZsFx6YPnd7cu9QjOrSrKk6Qi9swAVIXOw
Message-ID: <496565EC904933469F292DDA3F1663E602CBDD3AF5@dlee06.ent.ti.com>
References: <1277943660-4112-1-git-send-email-x0095840@ti.com>
	<1277943660-4112-2-git-send-email-x0095840@ti.com>
 <20100702.093205.59662898.Hiroshi.DOYU@nokia.com>
In-Reply-To: <20100702.093205.59662898.Hiroshi.DOYU@nokia.com>
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



> -----Original Message-----
> From: Hiroshi DOYU [mailto:Hiroshi.DOYU@nokia.com]
> Sent: Friday, July 02, 2010 1:32 AM
> To: Guzman Lugo, Fernando
> Cc: linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org;
> ohad@wizery.com; ameya.palande@nokia.com; felipe.contreras@nokia.com
> Subject: Re: [PATCH 1/9] dspbridge: replace iommu custom for opensource
> implementation
> 
> Hi Fernando,
> 
> From: ext Fernando Guzman Lugo <x0095840@ti.com>
> Subject: [PATCH 1/9] dspbridge: replace iommu custom for opensource
> implementation
> Date: Thu, 1 Jul 2010 02:20:52 +0200
> 
> > This patch replace the call to custom dsp mmu implemenation
> > for the once on iommu module.
> >
> > Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
> > ---
> >  drivers/dsp/bridge/core/_tiomap.h    |   16 +
> >  drivers/dsp/bridge/core/io_sm.c      |  114 ++------
> >  drivers/dsp/bridge/core/tiomap3430.c |  501 +++++----------------------
> -------
> >  drivers/dsp/bridge/core/ue_deh.c     |   10 -
> >  4 files changed, 118 insertions(+), 523 deletions(-)
> >
> > diff --git a/drivers/dsp/bridge/core/_tiomap.h
> b/drivers/dsp/bridge/core/_tiomap.h
> > index bf0164e..d13677a 100644
> > --- a/drivers/dsp/bridge/core/_tiomap.h
> > +++ b/drivers/dsp/bridge/core/_tiomap.h
> > @@ -23,6 +23,8 @@
> >  #include <plat/clockdomain.h>
> >  #include <mach-omap2/prm-regbits-34xx.h>
> >  #include <mach-omap2/cm-regbits-34xx.h>
> > +#include <plat/iommu.h>
> > +#include <plat/iovmm.h>
> >  #include <dspbridge/devdefs.h>
> >  #include <hw_defs.h>
> >  #include <dspbridge/dspioctl.h>        /* for bridge_ioctl_extproc defn
> */
> > @@ -330,6 +332,7 @@ struct bridge_dev_context {
> >         u32 dw_internal_size;   /* Internal memory size */
> >
> >         struct omap_mbox *mbox;         /* Mail box handle */
> > +       struct iommu *dsp_mmu;          /* iommu for iva2 handler */
> >
> >         struct cfg_hostres *resources;  /* Host Resources */
> >
> > @@ -374,4 +377,17 @@ extern s32 dsp_debug;
> >   */
> >  int sm_interrupt_dsp(struct bridge_dev_context *dev_context, u16
> mb_val);
> >
> > +static inline void dsp_iotlb_init(struct iotlb_entry *e, u32 da, u32
> pa,
> > +                                                       u32 pgsz)
> > +{
> > +       e->da = da;
> > +       e->pa = pa;
> > +       e->valid = 1;
> > +       e->prsvd = 1;
> > +       e->pgsz = pgsz & MMU_CAM_PGSZ_MASK;
> > +       e->endian = MMU_RAM_ENDIAN_LITTLE;
> > +       e->elsz = MMU_RAM_ELSZ_32;
> > +       e->mixed = 0;
> > +}
> > +
> >  #endif /* _TIOMAP_ */
> > diff --git a/drivers/dsp/bridge/core/io_sm.c
> b/drivers/dsp/bridge/core/io_sm.c
> > index 7fb840d..1f47f8b 100644
> > --- a/drivers/dsp/bridge/core/io_sm.c
> > +++ b/drivers/dsp/bridge/core/io_sm.c
> > @@ -290,6 +290,8 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
> >         struct cod_manager *cod_man;
> >         struct chnl_mgr *hchnl_mgr;
> >         struct msg_mgr *hmsg_mgr;
> > +       struct iommu *mmu;
> > +       struct iotlb_entry e;
> >         u32 ul_shm_base;
> >         u32 ul_shm_base_offset;
> >         u32 ul_shm_limit;
> > @@ -312,7 +314,6 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
> >         struct bridge_ioctl_extproc ae_proc[BRDIOCTL_NUMOFMMUTLB];
> >         struct cfg_hostres *host_res;
> >         struct bridge_dev_context *pbridge_context;
> > -       u32 map_attrs;
> >         u32 shm0_end;
> >         u32 ul_dyn_ext_base;
> >         u32 ul_seg1_size = 0;
> > @@ -336,6 +337,21 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
> >                 status = -EFAULT;
> >                 goto func_end;
> >         }
> > +
> > +       mmu = pbridge_context->dsp_mmu;
> > +
> > +       if (mmu)
> > +               iommu_put(mmu);
> > +       mmu = iommu_get("iva2");
> 
> +       mmu = iommu_get("iva2", mmu_fault_isr);
> 
> I'm considering that it might be better to pass a mmu fault callback
> at this iommu_get.
> 
> What do you think?

That sounds good.

Thanks and regards,
Fernando.


