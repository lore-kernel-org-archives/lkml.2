Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab3ABJhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 04:37:35 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17268 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab3ABJhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 04:37:32 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 02 Jan 2013 01:37:19 -0800
Message-ID: <50E40106.4020406@nvidia.com>
Date: Wed, 2 Jan 2013 11:42:30 +0200
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mark Zhang <nvmarkzhang@gmail.com>
CC: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dev@lynxeye.de" <dev@lynxeye.de>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 0/8] Support for Tegra 2D hardware
References: <1356089964-5265-1-git-send-email-tbergstrom@nvidia.com> <50DD6311.9000002@gmail.com>
In-Reply-To: <50DD6311.9000002@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.12.2012 11:14, Mark Zhang wrote:
> diff --git a/drivers/gpu/drm/tegra/gr2d.c b/drivers/gpu/drm/tegra/gr2d.c
> index a936902..c3ded60 100644
> --- a/drivers/gpu/drm/tegra/gr2d.c
> +++ b/drivers/gpu/drm/tegra/gr2d.c
> @@ -131,6 +131,14 @@ static int gr2d_submit(struct tegra_drm_context
> *context,
>                 if (err)
>                         goto fail;
> 
> +               /* We define CMA as an temporary solution in host1x driver.
> +                  That's also why we have a CMA kernel config in it.
> +                  But seems here, in tegradrm, we hardcode the CMA here.
> +                  So what do you do when host1x change to IOMMU?
> +                  Do we also need to define a CMA config in tegradrm
> driver,
> +                  then after host1x changes to IOMMU, we add another IOMMU
> +                  config in tegradrm? Or we should invent another more
> +                  generic wrapper layer here? */
>                 cmdbuf.mem = handle_cma_to_host1x(drm, file_priv,
> cmdbuf.mem);

Lucas is working on host1x allocator, so let's defer this comment until
we have Lucas' code.

> diff --git a/drivers/gpu/host1x/job.c b/drivers/gpu/host1x/job.c
> index cc8ca2f..0867b72 100644
> --- a/drivers/gpu/host1x/job.c
> +++ b/drivers/gpu/host1x/job.c
> @@ -82,6 +82,26 @@ struct host1x_job *host1x_job_alloc(struct
> host1x_channel *ch,
>         mem += num_unpins * sizeof(dma_addr_t);
>         job->pin_ids = num_unpins ? mem : NULL;
> 
> +       /* I think this is a somewhat ugly design.
> +          Actually "addr_phys" is consisted by "reloc_addr_phys" and
> +          "gather_addr_phys".
> +          Why don't we just declare "reloc_addr_phys" and
> "gather_addr_phys"?
> +          In current design, let's say if one nvhost newbie changes the
> order
> +          of these 2 blocks of code in function "pin_job_mem":
> +
> +          for (i = 0; i < job->num_relocs; i++) {
> +               struct host1x_reloc *reloc = &job->relocarray[i];
> +               job->pin_ids[count] = reloc->target;
> +               count++;
> +          }
> +
> +          for (i = 0; i < job->num_gathers; i++) {
> +               struct host1x_job_gather *g = &job->gathers[i];
> +               job->pin_ids[count] = g->mem_id;
> +               count++;
> +          }
> +
> +          Then likely something weird occurs... */

We do this because this way we can implement batch pinning of memory
handles. This way we can decrease memory handle management a lot as we
need to do locking only once per submit.

Decreasing memory management overhead is really important, because in
complex graphics cases, there are might be a hundreds of buffer
references per submit, and several submits per frame. Any extra overhead
relates directly to reduced performance.

>         job->reloc_addr_phys = job->addr_phys;
>         job->gather_addr_phys = &job->addr_phys[num_relocs];
> 
> @@ -252,6 +272,10 @@ static int do_relocs(struct host1x_job *job,
>                         }
>                 }
> 
> +               /* I have question here. Does this mean the address info
> +                  which need to be relocated(according to the libdrm codes,
> +                  seems this address is "0xDEADBEEF") always staying at the
> +                  beginning of a page? */
>                 __raw_writel(
>                         (job->reloc_addr_phys[i] +
>                                 reloc->target_offset) >> reloc->shift,

No - the slot can be anywhere. That's why we have cmdbuf_offset in the
reloc struct.

> @@ -565,6 +589,7 @@ int host1x_job_pin(struct host1x_job *job, struct
> platform_device *pdev)
>                 }
>         }
> 
> +       /* if (host1x_firewall && !err) { */
>         if (host1x_firewall) {
>                 err = copy_gathers(job, pdev);
>                 if (err) {

Will add.

> @@ -573,6 +598,9 @@ int host1x_job_pin(struct host1x_job *job, struct
> platform_device *pdev)
>                 }
>         }
> 
> +/* Rename this label to "out" or something else.
> +   Because if everything goes right, the codes under this label also
> +   get executed. */
>  fail:
>         wmb();

Will do.

> 
> diff --git a/drivers/gpu/host1x/memmgr.c b/drivers/gpu/host1x/memmgr.c
> index f3954f7..bb5763d 100644
> --- a/drivers/gpu/host1x/memmgr.c
> +++ b/drivers/gpu/host1x/memmgr.c
> @@ -156,6 +156,9 @@ int host1x_memmgr_pin_array_ids(struct
> platform_device *dev,
>                         count, &unpin_data[pin_count],
>                         phys_addr);
> 
> +               /* I don't think the current "host1x_cma_pin_array_ids"
> +                  is able to return a negative value. So this "if" doesn't
> +                  make sense...*/
>                 if (cma_count < 0) {
>                         /* clean up previous handles */
>                         while (pin_count) {

It should return negative in case of error.

Terje
