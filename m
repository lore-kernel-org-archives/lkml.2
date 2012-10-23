Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab2JWLct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 07:32:49 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:21556
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752622Ab2JWLcr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 07:32:47 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VS-7(z551biz98dI9371I1521I542M1432Izz1202h1d1ah1d2ahzz17326ah8275bh8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504hbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Tabi Timur-B04825 <B04825@freescale.com>
CC: "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/3 v3] iommu/fsl: Freescale PAMU driver and IOMMU API
 implementation.
Thread-Topic: [PATCH 3/3 v3] iommu/fsl: Freescale PAMU driver and IOMMU API
 implementation.
Thread-Index: AQHNrI35875xCS4rTUW/XSYVyCBXOZfF3FmAgADjUxA=
Date: Tue, 23 Oct 2012 11:32:28 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D223936@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1350495170-4593-1-git-send-email-Varun.Sethi@freescale.com>
	<1350495170-4593-4-git-send-email-Varun.Sethi@freescale.com>
 <6AE080B68D46FC4BA2D2769E68D765B7081084A7@039-SN2MPN1-023.039d.mgd.msft.net>
In-Reply-To: <6AE080B68D46FC4BA2D2769E68D765B7081084A7@039-SN2MPN1-023.039d.mgd.msft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.132.78]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Tabi Timur-B04825
> Sent: Tuesday, October 23, 2012 2:48 AM
> To: Sethi Varun-B16395
> Cc: joerg.roedel@amd.com; iommu@lists.linux-foundation.org; linuxppc-
> dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 3/3 v3] iommu/fsl: Freescale PAMU driver and IOMMU
> API implementation.
> 
> On Wed, Oct 17, 2012 at 12:32 PM, Varun Sethi <Varun.Sethi@freescale.com>
> wrote:
> 
> > + * Copyright (C) 2012 Freescale Semiconductor, Inc.
> 
> Copyright 2012 Freescale Semiconductor, Inc.
> 
[Sethi Varun-B16395] Have followed similar convention elsewhere i.e. added (C).

> > + *
> > + */
> > +
> > +#include <linux/init.h>
> > +#include <linux/iommu.h>
> > +#include <linux/slab.h>
> > +#include <linux/module.h>
> > +#include <linux/types.h>
> > +#include <linux/mm.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/device.h>
> > +#include <linux/of_platform.h>
> > +#include <linux/bootmem.h>
> > +#include <linux/genalloc.h>
> > +#include <asm/io.h>
> > +#include <asm/bitops.h>
> > +
> > +#include "fsl_pamu.h"
> > +
> > +/* PAMU bypass enbale register contains control bits for
> > + * enabling bypass mode on each PAMU.
> > + */
> 
> /*
>  * Linux multi-line comments
>  * look like this.
>  */
> 
> > +#define PAMUBYPENR 0x604
> 
> Update struct ccsr_guts instead.
> 
> http://patchwork.ozlabs.org/patch/141649/
> 
[Sethi Varun-B16395] Ok.

> > +
> > +/* define indexes for each operation mapping scenario */
> > +#define OMI_QMAN        0x00
> > +#define OMI_FMAN        0x01
> > +#define OMI_QMAN_PRIV   0x02
> > +#define OMI_CAAM        0x03
> > +
> > +static paace_t *ppaact;
> > +static paace_t *spaact;
> > +static struct ome *omt;
> > +unsigned int max_subwindow_count;
> > +
> > +struct gen_pool *spaace_pool;
> > +
> > +static paace_t *pamu_get_ppaace(int liodn) {
> > +       if (!ppaact) {
> > +               pr_err("PPAACT doesn't exist\n");
> 
> pr_err("fsl-pamu: PPAACT has not been initialized\n");
> 
> Make sure ALL pr_xxx() messages in this file start with "fsl-pamu: "
> 
> > +               return NULL;
> > +       }
> > +
> > +       return &ppaact[liodn];
> 
> Bounds checking?
> 
[Sethi Varun-B16395] Ok.

> > +}
> > +
> > +/**  Sets validation bit of PACCE
> > + *
> > + * @parm[in] liodn PAACT index for desired PAACE
> > + *
> > + * @return Returns 0 upon success else error code < 0 returned  */
> > +int pamu_enable_liodn(int liodn) {
> > +       paace_t *ppaace;
> > +
> > +       ppaace = pamu_get_ppaace(liodn);
> > +       if (!ppaace)
> > +               return -ENOENT;
> 
> error message?
[Sethi Varun-B16395] Have error messages at places from where the function is invoked.

> 
> > +
> > +       if (!get_bf(ppaace->addr_bitfields, PPAACE_AF_WSE)) {
> > +               pr_err("liodn %d not configured\n", liodn);
> > +               return -EINVAL;
> > +       }
> > +
> > +       /* Ensure that all other stores to the ppaace complete first */
> > +       mb();
> > +
> > +       ppaace->addr_bitfields |= PAACE_V_VALID;
> > +       mb();
> > +
> > +       return 0;
> > +}
> > +
> > +/** Clears validation bit of PACCE
> > + *
> > + * @parm[in]  liodn PAACT index for desired PAACE
> > + *
> > + * @return Returns 0 upon success else error code < 0 returned
> 
> This is not proper kerneldoc format.
[Sethi Varun-B16395] What format must be used? Can you point me to a relevant file.

> 
> > + */
> > +int pamu_disable_liodn(int liodn)
> > +{
> > +       paace_t *ppaace;
> > +
> > +       ppaace = pamu_get_ppaace(liodn);
> > +       if (!ppaace)
> > +               return -ENOENT;
> 
> error message?
[Sethi Varun-B16395] Error message at the point of invocation.

> 
> > +
> > +       set_bf(ppaace->addr_bitfields, PAACE_AF_V, PAACE_V_INVALID);
> > +       mb();
> > +
> > +       return 0;
> > +}
> > +
> > +
> > +static unsigned int map_addrspace_size_to_wse(phys_addr_t
> > +addrspace_size) {
> > +       BUG_ON((addrspace_size & (addrspace_size - 1)));
> > +
> > +       /* window size is 2^(WSE+1) bytes */
> > +       return __ffs(addrspace_size >> PAMU_PAGE_SHIFT) +
> > +PAMU_PAGE_SHIFT - 1; }
> > +
> > +static unsigned int map_subwindow_cnt_to_wce(u32 subwindow_cnt) {
> > +       /* window count is 2^(WCE+1) bytes */
> > +       return __ffs(subwindow_cnt) - 1; }
> > +
> > +static void pamu_setup_default_xfer_to_host_ppaace(paace_t *ppaace) {
> > +       set_bf(ppaace->addr_bitfields, PAACE_AF_PT, PAACE_PT_PRIMARY);
> > +
> > +       set_bf(ppaace->domain_attr.to_host.coherency_required,
> PAACE_DA_HOST_CR,
> > +              PAACE_M_COHERENCE_REQ); }
> > +
> > +static void pamu_setup_default_xfer_to_host_spaace(paace_t *spaace) {
> > +       set_bf(spaace->addr_bitfields, PAACE_AF_PT,
> PAACE_PT_SECONDARY);
> > +       set_bf(spaace->domain_attr.to_host.coherency_required,
> PAACE_DA_HOST_CR,
> > +              PAACE_M_COHERENCE_REQ); }
> > +
> > +static paace_t *pamu_get_spaace(u32 fspi_index, u32 wnum) {
> > +       return &spaact[fspi_index + wnum];
> 
> bounds checking?
> 
[Sethi Varun-B16395] Ok.

> > +}
> > +
> > +static unsigned long pamu_get_fspi_and_allocate(u32 subwin_cnt) {
> 
> subwin_cnt should probably be an unsigned int.
[Sethi Varun-B16395] Why?

> 
> This function needs to be documented.  What value is being returned?
> 
> > +       unsigned long spaace_addr;
> > +
> > +       spaace_addr = gen_pool_alloc(spaace_pool, subwin_cnt *
> sizeof(paace_t));
> > +       if (!spaace_addr)
> > +               return ULONG_MAX;
> 
> What's wrong with returning 0 on error?
> 
> > +
> > +       return (spaace_addr - (unsigned long)spaact) /
> > + (sizeof(paace_t));
> 
> Is this supposed to be a virtual address?  If so, then return void*
> instead of an unsigned long.
> 
[Sethi Varun-B16395] No, the function returns an fspi index is the spaace table.

> > +}
> > +
> > +void pamu_free_subwins(int liodn)
> > +{
> > +       paace_t *ppaace;
> > +       u32 subwin_cnt, size;
> 
> subwin_cnt should probably be an unsigned int.
>
[Sethi Varun-B16395] Why?

 
> > +
> > +       ppaace = pamu_get_ppaace(liodn);
> > +       if (!ppaace)
> > +               return;
> 
> error message
[Sethi Varun-B16395] Ok.

> 
> > +
> > +       if (get_bf(ppaace->addr_bitfields, PPAACE_AF_MW)) {
> > +               subwin_cnt = 1UL << (get_bf(ppaace->impl_attr,
> PAACE_IA_WCE) + 1);
> > +               size = (subwin_cnt - 1) * sizeof(paace_t);
> > +               gen_pool_free(spaace_pool, (unsigned
> long)&spaact[ppaace->fspi], size);
> > +               set_bf(ppaace->addr_bitfields, PPAACE_AF_MW, 0);
> > +       }
> > +}
> > +
> > +/* Function used for updating stash destination for the coresspong
> LIODN.
> > + */
> > +int  pamu_update_paace_stash(int liodn, u32 subwin, u32 value) {
> > +       paace_t *paace;
> > +
> > +       paace = pamu_get_ppaace(liodn);
> > +       if (!paace) {
> > +               return -ENOENT;
> > +       }
> 
> Error message?
> 
[Sethi Varun-B16395] Ok.

> > +       if (subwin) {
> > +               paace = pamu_get_spaace(paace->fspi, subwin - 1);
> > +               if (!paace) {
> > +                       return -ENOENT;
> 
> Error message?
[Sethi Varun-B16395] Ok.

> 
> 
> > +               }
> > +       }
> > +       set_bf(paace->impl_attr, PAACE_IA_CID, value);
> > +
> > +       return 0;
> > +}
> > +
> > +/** Sets up PPAACE entry for specified liodn
> > + *
> > + * @param[in] liodn      Logical IO device number
> > + * @param[in] win_addr   starting address of DSA window
> > + * @param[in] win-size   size of DSA window
> > + * @param[in] omi        Operation mapping index -- if ~omi == 0 then
> omi not defined
> > + * @param[in] rpn        real (true physical) page number
> > + * @param[in] stashid    cache stash id for associated cpu -- if
> ~stashid == 0 then
> > + *                      stashid not defined
> > + * @param[in] snoopid    snoop id for hardware coherency -- if
> ~snoopid == 0 then
> > + *                      snoopid not defined
> > + * @param[in] subwin_cnt number of sub-windows
> > + * @param[in] prot      window permissions
> > + *
> > + * @return Returns 0 upon success else error code < 0 returned  */
> 
> Please provide proper kerneldoc comments for all of the functions in this
> file.
> 
> > +int pamu_config_ppaace(int liodn, phys_addr_t win_addr, phys_addr_t
> win_size,
> > +                      u32 omi, unsigned long rpn, u32 snoopid, u32
> stashid,
> > +                      u32 subwin_cnt, int prot) {
> > +       paace_t *ppaace;
> > +       unsigned long fspi;
> > +
> > +       if ((win_size & (win_size - 1)) || win_size < PAMU_PAGE_SIZE) {
> > +               pr_err("window size too small or not a power of two
> %llx\n", win_size);
> > +               return -EINVAL;
> > +       }
> > +
> > +       if (win_addr & (win_size - 1)) {
> > +               pr_err("window address is not aligned with window
> size\n");
> > +               return -EINVAL;
> > +       }
> > +
> > +       ppaace = pamu_get_ppaace(liodn);
> > +       if (!ppaace) {
> > +               return -ENOENT;
> > +       }
> > +
> > +       /* window size is 2^(WSE+1) bytes */
> > +       set_bf(ppaace->addr_bitfields, PPAACE_AF_WSE,
> > +           map_addrspace_size_to_wse(win_size));
> > +
> > +       pamu_setup_default_xfer_to_host_ppaace(ppaace);
> > +
> > +       ppaace->wbah = win_addr >> (PAMU_PAGE_SHIFT + 20);
> > +       set_bf(ppaace->addr_bitfields, PPAACE_AF_WBAL,
> > +              (win_addr >> PAMU_PAGE_SHIFT));
> > +
> > +       /* set up operation mapping if it's configured */
> > +       if (omi < OME_NUMBER_ENTRIES) {
> > +               set_bf(ppaace->impl_attr, PAACE_IA_OTM,
> PAACE_OTM_INDEXED);
> > +               ppaace->op_encode.index_ot.omi = omi;
> > +       } else if (~omi != 0) {
> > +               pr_err("bad operation mapping index: %d\n", omi);
> > +               return -EINVAL;
> > +       }
> > +
> > +       /* configure stash id */
> > +       if (~stashid != 0)
> > +               set_bf(ppaace->impl_attr, PAACE_IA_CID, stashid);
> > +
> > +       /* configure snoop id */
> > +       if (~snoopid != 0)
> > +               ppaace->domain_attr.to_host.snpid = snoopid;
> > +
> > +       if (subwin_cnt) {
> > +               /* The first entry is in the primary PAACE instead */
> > +               fspi = pamu_get_fspi_and_allocate(subwin_cnt - 1);
> > +               if (fspi == ULONG_MAX) {
> > +                       pr_err("spaace indexes exhausted\n");
> > +               return -EINVAL;
> > +               }
> 
> Indentation problem.
>
[Sethi Varun-B16395] Ok.
 
> > +
> > +               /* window count is 2^(WCE+1) bytes */
> > +               set_bf(ppaace->impl_attr, PAACE_IA_WCE,
> > +                      map_subwindow_cnt_to_wce(subwin_cnt));
> > +               set_bf(ppaace->addr_bitfields, PPAACE_AF_MW, 0x1);
> > +               ppaace->fspi = fspi;
> > +       } else {
> > +               set_bf(ppaace->impl_attr, PAACE_IA_ATM,
> PAACE_ATM_WINDOW_XLATE);
> > +               ppaace->twbah = rpn >> 20;
> > +               set_bf(ppaace->win_bitfields, PAACE_WIN_TWBAL, rpn);
> > +               set_bf(ppaace->addr_bitfields, PAACE_AF_AP, prot);
> > +               set_bf(ppaace->impl_attr, PAACE_IA_WCE, 0);
> > +               set_bf(ppaace->addr_bitfields, PPAACE_AF_MW, 0);
> > +       }
> > +       mb();
> > +
> > +       return 0;
> > +}
> > +
> > +/** Sets up SPAACE entry for specified subwindow
> > + *
> > + * @param[in] liodn       Logical IO device number
> > + * @param[in] subwin_cnt  number of sub-windows associated with
> > +dma-window
> > + * @param[in] subwin_addr starting address of subwindow
> > + * @param[in] subwin_size size of subwindow
> > + * @param[in] omi         Operation mapping index
> > + * @param[in] rpn         real (true physical) page number
> > + * @param[in] snoopid     snoop id for hardware coherency -- if
> ~snoopid == 0 then
> > + *                       snoopid not defined
> > + * @param[in] stashid     cache stash id for associated cpu
> > + * @param[in] enable      enable/disable subwindow after
> reconfiguration
> > + * @param[in] prot        sub window permissions
> > + *
> > + * @return Returns 0 upon success else error code < 0 returned  */
> > +int pamu_config_spaace(int liodn, u32 subwin_cnt, u32 subwin_addr,
> > +                      phys_addr_t subwin_size, u32 omi, unsigned long
> rpn,
> > +                      u32 snoopid, u32 stashid, int enable, int prot)
> > +{
> > +       paace_t *paace;
> > +       unsigned long fspi;
> > +
> > +       /* setup sub-windows */
> > +       if (!subwin_cnt) {
> > +               pr_err("Invalid subwindow count\n");
> > +               return -EINVAL;
> > +       }
> > +
> > +       paace = pamu_get_ppaace(liodn);
> > +       if (subwin_addr > 0 && paace) {
> > +               fspi = paace->fspi;
> > +               paace = pamu_get_spaace(fspi, subwin_addr - 1);
> > +
> > +               if (paace && !(paace->addr_bitfields & PAACE_V_VALID))
> {
> > +                       pamu_setup_default_xfer_to_host_spaace(paace);
> > +                       set_bf(paace->addr_bitfields, SPAACE_AF_LIODN,
> liodn);
> > +               }
> > +       }
> > +
> > +       if (!paace)
> > +               return -ENOENT;
> 
> Error message?
> 
[Sethi Varun-B16395] Error message in the invoking function.

> > +
> > +       if (!enable && prot == PAACE_AP_PERMS_DENIED) {
> > +               if (subwin_addr > 0)
> > +                       set_bf(paace->addr_bitfields, PAACE_AF_V,
> > +                                PAACE_V_INVALID);
> > +               else
> > +                       set_bf(paace->addr_bitfields, PAACE_AF_AP,
> > +                                prot);
> > +               mb();
> > +               return 0;
> > +       }
> > +
> > +       if (subwin_size & (subwin_size - 1) || subwin_size <
> PAMU_PAGE_SIZE) {
> > +               pr_err("subwindow size out of range, or not a power of
> 2\n");
> > +               return -EINVAL;
> > +       }
> > +
> > +       if (rpn == ULONG_MAX) {
> > +               pr_err("real page number out of range\n");
> > +               return -EINVAL;
> > +       }
> > +
> > +       /* window size is 2^(WSE+1) bytes */
> > +       set_bf(paace->win_bitfields, PAACE_WIN_SWSE,
> > +              map_addrspace_size_to_wse(subwin_size));
> > +
> > +       set_bf(paace->impl_attr, PAACE_IA_ATM, PAACE_ATM_WINDOW_XLATE);
> > +       paace->twbah = rpn >> 20;
> > +       set_bf(paace->win_bitfields, PAACE_WIN_TWBAL, rpn);
> > +       set_bf(paace->addr_bitfields, PAACE_AF_AP, prot);
> > +
> > +       /* configure snoop id */
> > +       if (~snoopid != 0)
> > +               paace->domain_attr.to_host.snpid = snoopid;
> > +
> > +       /* set up operation mapping if it's configured */
> > +       if (omi < OME_NUMBER_ENTRIES) {
> > +               set_bf(paace->impl_attr, PAACE_IA_OTM,
> PAACE_OTM_INDEXED);
> > +               paace->op_encode.index_ot.omi = omi;
> > +       } else if (~omi != 0) {
> > +               pr_err("bad operation mapping index: %d\n", omi);
> > +               return -EINVAL;
> > +       }
> > +
> > +       if (~stashid != 0)
> > +               set_bf(paace->impl_attr, PAACE_IA_CID, stashid);
> > +
> > +       smp_wmb();
> > +
> > +       if (enable)
> > +               paace->addr_bitfields |= PAACE_V_VALID;
> > +
> > +       mb();
> > +
> > +       return 0;
> > +}
> > +
> > +void get_ome_index(u32 *omi_index, struct device *dev) {
> > +       if (of_device_is_compatible(dev->of_node, "fsl,qman-portal"))
> > +               *omi_index = OMI_QMAN;
> > +       if (of_device_is_compatible(dev->of_node, "fsl,qman"))
> > +               *omi_index = OMI_QMAN_PRIV; }
> 
> Documentation?
> 
> > +
> > +u32 get_stash_id(u32 stash_dest_hint, u32 vcpu)
> 
> Can we make the stash_id a signed integer, and return -1 as an error?
> Making it a u32 is awkward because we keep doing stuff like this:
> 
>       if (~stashid != 0)
> 
> and
> 
>       return ~(u32)0;
[Sethi Varun-B16395] What's wrong with this?

> 
> > +{
> > +       const u32 *prop;
> > +       struct device_node *node;
> > +       u32 cache_level;
> > +       int len;
> > +
> > +       /* Fastpath, exit early if L3/CPC cache is target for stashing
> */
> > +       if (stash_dest_hint == IOMMU_ATTR_CACHE_L3) {
> > +               node = of_find_compatible_node(NULL, NULL,
> > +                               "fsl,p4080-l3-cache-controller");
> > +               if (node) {
> 
> if (!node) {
>    pr_err( "no cpc node" );
>    return ~(u32)0;
> }
> 
> > +                       prop = of_get_property(node, "cache-stash-id",
> 0);
> > +                       if (!prop) {
> > +                               pr_err("missing cache-stash-id at
> %s\n", node->full_name);
> > +                               of_node_put(node);
> > +                               return ~(u32)0;
> > +                       }
> > +                       of_node_put(node);
> > +                       return be32_to_cpup(prop);
> > +               }
> > +               return ~(u32)0;
> > +       }
> > +
> > +       for_each_node_by_type(node, "cpu") {
> > +               prop = of_get_property(node, "reg", &len);
> > +               if (be32_to_cpup(prop) == vcpu)
> > +                       break;
> > +       }
> > +
> > +       /* find the hwnode that represents the cache */
> > +       for (cache_level = IOMMU_ATTR_CACHE_L1; cache_level <=
> > + IOMMU_ATTR_CACHE_L3; cache_level++) {
> 
> Shouldn't this be < IOMMU_ATTR_CACHE_L3, since we already handled the CPC
> case above?
[Sethi Varun-B16395] Yes

> 
> > +               if (stash_dest_hint == cache_level) {
> > +                       prop = of_get_property(node, "cache-stash-id",
> 0);
> > +                       if (!prop) {
> > +                               pr_err("missing cache-stash-id at
> %s\n", node->full_name);
> > +                               of_node_put(node);
> > +                               return ~(u32)0;
> > +                       }
> > +                       of_node_put(node);
> > +                       return be32_to_cpup(prop);
> > +               }
> > +
> > +               prop = of_get_property(node, "next-level-cache", 0);
> > +               if (!prop) {
> > +                       pr_err("can't find next-level-cache at %s\n",
> > +                                 node->full_name);
> > +                       of_node_put(node);
> > +                       return ~(u32)0;  /* can't traverse any further
> */
> > +               }
> > +               of_node_put(node);
> > +
> > +               /* advance to next node in cache hierarchy */
> > +               node = of_find_node_by_phandle(*prop);
> > +               if (!node) {
> > +                       pr_err("bad cpu reference %d\n", vcpu);
> 
> print the full path of any node that has a broken property
> 
[Sethi Varun-B16395] Ok.

> > +                       return ~(u32)0;
> > +               }
> > +       }
> > +
> > +       pr_err("stash dest not found for %d on vcpu %d\n",
> > +                 stash_dest_hint, vcpu);
> > +       return ~(u32)0;
> > +}
> > +
> > +#define QMAN_PAACE 1
> > +#define QMAN_PORTAL_PAACE 2
> > +#define BMAN_PAACE 3
> 
> Documentation?
[Sethi Varun-B16395] Ok.

> 
> > +
> > +static void setup_qbman_paace(paace_t *ppaace, int paace_type) {
> > +       switch(paace_type) {
> > +               case QMAN_PAACE:
> > +                       set_bf(ppaace->impl_attr, PAACE_IA_OTM,
> PAACE_OTM_INDEXED);
> > +                       ppaace->op_encode.index_ot.omi = OMI_QMAN_PRIV;
> > +                       /* setup QMAN Private data stashing for the L3
> cache */
> > +                       set_bf(ppaace->impl_attr, PAACE_IA_CID,
> get_stash_id(IOMMU_ATTR_CACHE_L3, 0));
> > +                       set_bf(ppaace-
> >domain_attr.to_host.coherency_required, PAACE_DA_HOST_CR,
> > +                              0);
> > +                       break;
> > +               case QMAN_PORTAL_PAACE:
> > +                       set_bf(ppaace->impl_attr, PAACE_IA_OTM,
> PAACE_OTM_INDEXED);
> > +                       ppaace->op_encode.index_ot.omi = OMI_QMAN;
> > +                       /*Set DQRR and Frame stashing for the L3 cache
> */
> > +                       set_bf(ppaace->impl_attr, PAACE_IA_CID,
> get_stash_id(IOMMU_ATTR_CACHE_L3, 0));
> > +                       break;
> > +               case BMAN_PAACE:
> > +                       set_bf(ppaace-
> >domain_attr.to_host.coherency_required, PAACE_DA_HOST_CR,
> > +                              0);
> > +                       break;
> > +       }
> > +}
> 
> Seriously, you need to document these functions.
> 
> > +
> > +static void __init setup_omt(struct ome *omt) {
> > +       struct ome *ome;
> > +
> > +       /* Configure OMI_QMAN */
> > +       ome = &omt[OMI_QMAN];
> > +
> > +       ome->moe[IOE_READ_IDX] = EOE_VALID | EOE_READ;
> > +       ome->moe[IOE_EREAD0_IDX] = EOE_VALID | EOE_RSA;
> > +       ome->moe[IOE_WRITE_IDX] = EOE_VALID | EOE_WRITE;
> > +       ome->moe[IOE_EWRITE0_IDX] = EOE_VALID | EOE_WWSAO;
> > +
> > +       ome->moe[IOE_DIRECT0_IDX] = EOE_VALID | EOE_LDEC;
> > +       ome->moe[IOE_DIRECT1_IDX] = EOE_VALID | EOE_LDECPE;
> > +
> > +       /* Configure OMI_FMAN */
> > +       ome = &omt[OMI_FMAN];
> > +       ome->moe[IOE_READ_IDX]  = EOE_VALID | EOE_READI;
> > +       ome->moe[IOE_WRITE_IDX] = EOE_VALID | EOE_WRITE;
> > +
> > +       /* Configure OMI_QMAN private */
> > +       ome = &omt[OMI_QMAN_PRIV];
> > +       ome->moe[IOE_READ_IDX]  = EOE_VALID | EOE_READ;
> > +       ome->moe[IOE_WRITE_IDX] = EOE_VALID | EOE_WRITE;
> > +       ome->moe[IOE_EREAD0_IDX] = EOE_VALID | EOE_RSA;
> > +       ome->moe[IOE_EWRITE0_IDX] = EOE_VALID | EOE_WWSA;
> > +
> > +       /* Configure OMI_CAAM */
> > +       ome = &omt[OMI_CAAM];
> > +       ome->moe[IOE_READ_IDX]  = EOE_VALID | EOE_READI;
> > +       ome->moe[IOE_WRITE_IDX] = EOE_VALID | EOE_WRITE; }
> > +
> > +int setup_one_pamu(unsigned long pamu_reg_base, unsigned long
> pamu_reg_size,
> > +                  phys_addr_t ppaact_phys, phys_addr_t spaact_phys,
> > +                  phys_addr_t omt_phys) {
> > +       u32 *pc;
> > +       struct pamu_mmap_regs *pamu_regs;
> > +       u32 pc3_val;
> > +
> > +       pc3_val = in_be32((u32 *)(pamu_reg_base + PAMU_PC3));
> 
> pamu_reg_base should be a void*.  Or even better, create a struct.
> 
> > +
> > +#define PAMU_PAGE_SHIFT 12
> > +#define PAMU_PAGE_SIZE  4096ULL
> 
> 4096ULL?  Why not just 4096?
> 
> 
> > +
> > +/* This bitmap advertises the page sizes supported by PAMU hardware
> > + * to the IOMMU API.
> > + */
> > +#define FSL_PAMU_PGSIZES       (~0xFFFUL)
> 
> There should be a better way to define this.  ~(PAMU_PAGE_SIZE-1) maybe?
[Sethi Varun-B16395] For 32 bit systems with current iommu_map implementation we can't 
create a PAMU window > 2G.  

> 
> 
> > +
> > +static int map_liodn(int liodn, struct fsl_dma_domain *dma_domain) {
> > +       u32 subwin_cnt = dma_domain->subwin_cnt;
> > +       unsigned long rpn;
> > +       int ret = 0, i;
> > +
> > +       if (subwin_cnt) {
> > +               struct dma_subwindow *sub_win_ptr =
> > +                                       &dma_domain->sub_win_arr[0];
> > +               for (i = 0; i < subwin_cnt; i++) {
> > +                       if (sub_win_ptr[i].valid) {
> > +                               rpn = sub_win_ptr[i].paddr >>
> > +                                        PAMU_PAGE_SHIFT,
> > +                               spin_lock(&iommu_lock);
> > +                               ret = pamu_config_spaace(liodn,
> subwin_cnt, i,
> > +
> sub_win_ptr[i].size,
> > +                                                        -1,
> > +                                                        rpn,
> > +                                                        dma_domain-
> >snoop_id,
> > +                                                        dma_domain-
> >stash_id,
> > +                                                        (i > 0) ? 1 :
> 0,
> > +
> sub_win_ptr[i].prot);
> > +                               spin_unlock(&iommu_lock);
> > +                               if (ret) {
> > +                                       pr_err("PAMU SPAACE
> configuration failed for liodn %d\n",
> > +                                                liodn);
> > +                                       return ret;
> > +                               }
> > +                       }
> > +               }
> > +       } else {
> > +
> 
> Blank line
> 
> 
> > +
> > +
> > +static struct fsl_dma_domain *iommu_alloc_dma_domain(void) {
> > +       struct fsl_dma_domain *domain;
> > +
> > +       domain = kmem_cache_zalloc(fsl_pamu_domain_cache, GFP_KERNEL);
> > +       if (!domain)
> > +               return NULL;
> > +
> > +       domain->stash_id = -1;
> > +       domain->snoop_id = -1;
> 
> Here, stash_id is set to -1, but in other places, you use ~0.  Please be
> consistent.
[Sethi Varun-B16395] Will fix this.

> 
> > +
> > +       INIT_LIST_HEAD(&domain->devices);
> > +
> > +       spin_lock_init(&domain->domain_lock);
> > +
> > +       return domain;
> > +}
> > +
> > +static inline struct fsl_dma_domain *find_domain(struct device *dev)
> > +{
> > +       return dev->archdata.iommu_domain; }
> > +
> > +static void remove_domain_ref(struct device_domain_info *info, u32
> > +subwin_cnt) {
> > +               list_del(&info->link);
> > +               spin_lock(&iommu_lock);
> > +               if (subwin_cnt)
> > +                       pamu_free_subwins(info->liodn);
> > +               pamu_disable_liodn(info->liodn);
> > +               spin_unlock(&iommu_lock);
> > +               spin_lock(&device_domain_lock);
> > +               info->dev->archdata.iommu_domain = NULL;
> > +               free_devinfo_mem(info);
> > +               spin_unlock(&device_domain_lock); }
> > +
> > +static void destroy_domain(struct fsl_dma_domain *dma_domain) {
> > +       struct device_domain_info *info;
> > +
> 
> > +       while (!list_empty(&dma_domain->devices)) {
> > +               info = list_entry(dma_domain->devices.next,
> > +                       struct device_domain_info, link);
> > +               remove_domain_ref(info, dma_domain->subwin_cnt);
> > +       }
> 
> I wonder if you should use list_for_each_safe() instead.
> 
> 
[Sethi Varun-B16395] Why? we are destroying the domain here.

> > +
> > +static int get_subwin_cnt(dma_addr_t geom_size, u32 subwin, u32
> > +*subwin_cnt) {
> > +
> 
> blank line
> 
> > +       switch (subwin) {
> > +               case 0:
> > +                       /* We can't support geometry size > 1MB*/
> > +                       if (geom_size != 1024 * 1024)
> 
> Instead of doing 1024*1024, use math that reflects the hardware
> limitation of the PAMU: 256 * PAMU_PAGE_SIZE.  Create a macro for 256,
> like PAMU_MAX_SUBWINDOWS or something.
> 
[Sethi Varun-B16395] Ok.

> > +                               return 0;
> > +                       *subwin_cnt = 256;
> > +                       break;
> > +               case 1:
> > +                       /* No subwindows only a single PAMU window */
> > +                       *subwin_cnt = 0;
> > +                       break;
> > +               default:
> > +                       if (subwin > max_subwindow_count ||
> > +                          (subwin & (subwin - 1)))
> > +                               return 0;
> > +                       *subwin_cnt = subwin;
> > +       }
> > +       return 1;
> > +}
> > +
> > +static  int configure_domain_geometry(struct iommu_domain *domain,
> > +void *data) {
> > +       int ret = 0;
> 
> I don't think you need to initialize 'ret'
> 
> 
> > +}
> > +
> > +static int configure_domain_dma_state(struct fsl_dma_domain
> > +*dma_domain, int enable)
> 
> bool enable
> 
[Sethi Varun-B16395] Ok.

> Finally, please CC: me on all IOMMU and PAMU patches you post upstream.
>
[Sethi Varun-B16395] Sure.

-Varun

