Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab1KINcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 08:32:51 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:29421 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab1KINcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 08:32:50 -0500
X-IronPort-AV: E=Sophos;i="4.69,484,1315180800"; 
   d="scan'208";a="8840177"
Subject: Re: [Xen-devel] [PATCH 2/3] Grant tables v2 implementation.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: "annie.li@oracle.com" <annie.li@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
        Paul Durrant <Paul.Durrant@citrix.com>
Date: Wed, 9 Nov 2011 13:32:48 +0000
In-Reply-To: <1320826541-29398-1-git-send-email-annie.li@oracle.com>
References: <4EBA35D3.3020506@oracle.com>
	 <1320826541-29398-1-git-send-email-annie.li@oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1320845568.955.134.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 08:15 +0000, annie.li@oracle.com wrote:
> From: Annie Li <annie.li@oracle.com>
> 
> Receiver-side copying of packets is based on this implementation, it gives
> better performance and better CPU accounting. It totally supports three types:
> full-page, sub-page and transitive grants.
> 
> However this patch does not cover sub-page and transitive grants, it mainly
> focus on Full-page part and implements grant table V2 interfaces corresponding
> to what already exists in grant table V1, such as: grant table V2
> initialization, mapping, releasing and exported interfaces.
> 
> Each guest can only supports one type of grant table type, every entry in grant
> table should be the same version. It is necessary to set V1 or V2 version before
> initializing the grant table.
> 
> Grant table exported interfaces of V2 are same with those of V1, Xen is
> responsible to judge what grant table version guests are using in every grant
> operation.
> 
> V2 fulfills the same role of V1, and it is totally backwards compitable with V1.
> If dom0 support grant table V2, the guests runing on it can run with either V1
> or V2.
> 
> Signed-off-by: Annie Li <annie.li@oracle.com>
> ---
>  arch/x86/xen/grant-table.c |   34 ++++++++-
>  drivers/xen/grant-table.c  |  194 +++++++++++++++++++++++++++++++++++++++++---
>  include/xen/grant_table.h  |    6 +-
>  3 files changed, 220 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/xen/grant-table.c b/arch/x86/xen/grant-table.c
> index 65ce508..3e9f936 100644
> --- a/arch/x86/xen/grant-table.c
> +++ b/arch/x86/xen/grant-table.c
> @@ -54,6 +54,17 @@ static int map_pte_fn(pte_t *pte, struct page *pmd_page,
>         return 0;
>  }
> 
> +/*32bits is not enough since Xen supports sparse physical memory*/

What does this mean?

> +static int map_pte_fn_status(pte_t *pte, struct page *pmd_page,
> +                            unsigned long addr, void *data)
> +{
> +       uint64_t **frames = (uint64_t **)data;
> +
> +       set_pte_at(&init_mm, addr, pte, mfn_pte((*frames)[0], PAGE_KERNEL));
> +       (*frames)++;
> +       return 0;
> +}

Isn't this function identical to map_pte_fn?

> +
>  static int unmap_pte_fn(pte_t *pte, struct page *pmd_page,
>                         unsigned long addr, void *data)
>  {

> @@ -630,6 +756,44 @@ static int gnttab_map_status_v1(unsigned int nr_gframes)
>         return 0;
>  }
> 
> +static int gnttab_map_status_v2(unsigned int nr_gframes)
> +{
> +       uint64_t *sframes;
> +       unsigned int nr_sframes;
> +       struct gnttab_get_status_frames getframes;
> +       int rc;
> +
> +       nr_sframes = nr_status_frames(nr_gframes);
> +
> +       /* No need for kzalloc as it is initialized in following hyercall

                                                                   hypercall

> +        * GNTTABOP_get_status_frames.
> +        */
> +       sframes = kmalloc(nr_sframes  * sizeof(uint64_t), GFP_ATOMIC);
> +       if (!sframes)
> +               return -ENOMEM;
> +
> +       getframes.dom        = DOMID_SELF;
> +       getframes.nr_frames  = nr_sframes;
> +       set_xen_guest_handle(getframes.frame_list, sframes);
> +
> +       rc = HYPERVISOR_grant_table_op(GNTTABOP_get_status_frames,
> +                                      &getframes, 1);
> +       if (rc == -ENOSYS) {
> +               kfree(sframes);
> +               return -ENOSYS;
> +       }
> +
> +       BUG_ON(rc || getframes.status);
> +
> +       rc = arch_gnttab_map_status(sframes, nr_sframes,
> +                                   nr_status_frames(gnttab_max_grant_frames()),
> +                                   &grstatus);
> +       BUG_ON(rc);
> +       kfree(sframes);
> +
> +       return 0;
> +}
> +
>  static int gnttab_map_status(unsigned int nr_gframes)
>  {
>         return gnttab_interface._gnttab_map_status(nr_gframes);
> @@ -666,6 +830,9 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
>                 return rc;
>         }
> 
> +       /* No need for kzalloc as it is initialized in following hyercall

"hypercall" again

Ian.


