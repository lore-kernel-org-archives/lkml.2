Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab2L1JPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 04:15:21 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:38358 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab2L1JPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 04:15:11 -0500
X-Greylist: delayed 170729 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Dec 2012 04:15:10 EST
Message-ID: <50DD6311.9000002@gmail.com>
Date: Fri, 28 Dec 2012 17:14:57 +0800
From: Mark Zhang <nvmarkzhang@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Terje Bergstrom <tbergstrom@nvidia.com>
CC: thierry.reding@avionic-design.de, airlied@linux.ie, dev@lynxeye.de,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 0/8] Support for Tegra 2D hardware
References: <1356089964-5265-1-git-send-email-tbergstrom@nvidia.com>
In-Reply-To: <1356089964-5265-1-git-send-email-tbergstrom@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Terje,

Here is the second part comments. I admit I still haven't finished
reading the codes... really too many codes. :)
Anyway I'll keep doing this when I have free slots.

diff --git a/drivers/gpu/drm/tegra/gr2d.c b/drivers/gpu/drm/tegra/gr2d.c
index a936902..c3ded60 100644
--- a/drivers/gpu/drm/tegra/gr2d.c
+++ b/drivers/gpu/drm/tegra/gr2d.c
@@ -131,6 +131,14 @@ static int gr2d_submit(struct tegra_drm_context
*context,
                if (err)
                        goto fail;

+               /* We define CMA as an temporary solution in host1x driver.
+                  That's also why we have a CMA kernel config in it.
+                  But seems here, in tegradrm, we hardcode the CMA here.
+                  So what do you do when host1x change to IOMMU?
+                  Do we also need to define a CMA config in tegradrm
driver,
+                  then after host1x changes to IOMMU, we add another IOMMU
+                  config in tegradrm? Or we should invent another more
+                  generic wrapper layer here? */
                cmdbuf.mem = handle_cma_to_host1x(drm, file_priv,
cmdbuf.mem);
                if (!cmdbuf.mem)
                        goto fail;
diff --git a/drivers/gpu/host1x/job.c b/drivers/gpu/host1x/job.c
index cc8ca2f..0867b72 100644
--- a/drivers/gpu/host1x/job.c
+++ b/drivers/gpu/host1x/job.c
@@ -82,6 +82,26 @@ struct host1x_job *host1x_job_alloc(struct
host1x_channel *ch,
        mem += num_unpins * sizeof(dma_addr_t);
        job->pin_ids = num_unpins ? mem : NULL;

+       /* I think this is a somewhat ugly design.
+          Actually "addr_phys" is consisted by "reloc_addr_phys" and
+          "gather_addr_phys".
+          Why don't we just declare "reloc_addr_phys" and
"gather_addr_phys"?
+          In current design, let's say if one nvhost newbie changes the
order
+          of these 2 blocks of code in function "pin_job_mem":
+
+          for (i = 0; i < job->num_relocs; i++) {
+               struct host1x_reloc *reloc = &job->relocarray[i];
+               job->pin_ids[count] = reloc->target;
+               count++;
+          }
+
+          for (i = 0; i < job->num_gathers; i++) {
+               struct host1x_job_gather *g = &job->gathers[i];
+               job->pin_ids[count] = g->mem_id;
+               count++;
+          }
+
+          Then likely something weird occurs... */
        job->reloc_addr_phys = job->addr_phys;
        job->gather_addr_phys = &job->addr_phys[num_relocs];

@@ -252,6 +272,10 @@ static int do_relocs(struct host1x_job *job,
                        }
                }

+               /* I have question here. Does this mean the address info
+                  which need to be relocated(according to the libdrm codes,
+                  seems this address is "0xDEADBEEF") always staying at the
+                  beginning of a page? */
                __raw_writel(
                        (job->reloc_addr_phys[i] +
                                reloc->target_offset) >> reloc->shift,
@@ -565,6 +589,7 @@ int host1x_job_pin(struct host1x_job *job, struct
platform_device *pdev)
                }
        }

+       /* if (host1x_firewall && !err) { */
        if (host1x_firewall) {
                err = copy_gathers(job, pdev);
                if (err) {
@@ -573,6 +598,9 @@ int host1x_job_pin(struct host1x_job *job, struct
platform_device *pdev)
                }
        }

+/* Rename this label to "out" or something else.
+   Because if everything goes right, the codes under this label also
+   get executed. */
 fail:
        wmb();

diff --git a/drivers/gpu/host1x/memmgr.c b/drivers/gpu/host1x/memmgr.c
index f3954f7..bb5763d 100644
--- a/drivers/gpu/host1x/memmgr.c
+++ b/drivers/gpu/host1x/memmgr.c
@@ -156,6 +156,9 @@ int host1x_memmgr_pin_array_ids(struct
platform_device *dev,
                        count, &unpin_data[pin_count],
                        phys_addr);

+               /* I don't think the current "host1x_cma_pin_array_ids"
+                  is able to return a negative value. So this "if" doesn't
+                  make sense...*/
                if (cma_count < 0) {
                        /* clean up previous handles */
                        while (pin_count) {

Mark
On 12/21/2012 07:39 PM, Terje Bergstrom wrote:
> This set of patches adds support for Tegra20 and Tegra30 host1x and
> 2D. It is based on linux-next-20121220.
> 
> The fourth version has only few changes compared to previous version:
>  * Fixed some sparse warnings
>  * Fixed host1x Makefile to allow building as module
>  * Fixed host1x module unload
>  * Fixed tegradrm unload sequence
>  * host1x creates DRM dummy device and tegradrm uses it for storing
>    DRM related data.
> 
> Some of the issues left open:
>  * Register definitions still use static inline. There has been a
>    debate about code style versus ability to use compiler type
>    checking and code coverage analysis. There was no conclusion, so
>    I left it as was.
>  * Uses still CMA helpers. IOMMU support will replace CMA with host1x
>    specific allocator.
> 
> host1x is the driver that controls host1x hardware. It supports
> host1x command channels, synchronization, and memory management. It
> is sectioned into logical driver under drivers/gpu/host1x and
> physical driver under drivers/host1x/hw. The physical driver is
> compiled with the hardware headers of the particular host1x version.
> 
> The hardware units are described (briefly) in the Tegra2 TRM. Wiki
> page https://gitorious.org/linux-tegra-drm/pages/Host1xIntroduction
> also contains a short description of the functionality.
> 
> The patch set removes responsibility of host1x from tegradrm. At the
> same time, it moves all drm related infrastructure in
> drivers/gpu/drm/tegra/host1x.c to drm.c. To replace the host1x
> central device, host1x creates a dummy device for tegradrm to hang
> global data to. This is a break in responsibility split of tegradrm
> taking care of DRM and host1x driver taking care of host1x and
> clients, but this structure was insisted. I've kept creation of dummy
> device as a separate patch to illustrate the alternatives. It can be
> later squashed into other patches.
> 
> The patch set adds 2D driver to tegradrm, which uses host1x for
> communicating with host1x to access sync points and channels. We
> expect to use the same infrastructure for other host1x clients, so
> we have kept host1x and tegradrm separate.
> 
> The patch set also adds user space API to tegradrm for accessing
> host1x and 2D.
> 
> Arto Merilainen (1):
>   drm: tegra: Remove redundant host1x
> 
> Terje Bergstrom (7):
>   gpu: host1x: Add host1x driver
>   gpu: host1x: Add syncpoint wait and interrupts
>   gpu: host1x: Add channel support
>   gpu: host1x: Add debug support
>   ARM: tegra: Add board data and 2D clocks
>   drm: tegra: Add gr2d device
>   gpu: host1x: Register DRM dummy device
> 
>  arch/arm/mach-tegra/board-dt-tegra20.c      |    1 +
>  arch/arm/mach-tegra/board-dt-tegra30.c      |    1 +
>  arch/arm/mach-tegra/tegra20_clocks_data.c   |    2 +-
>  arch/arm/mach-tegra/tegra30_clocks_data.c   |    1 +
>  drivers/gpu/Makefile                        |    1 +
>  drivers/gpu/drm/tegra/Kconfig               |    2 +-
>  drivers/gpu/drm/tegra/Makefile              |    2 +-
>  drivers/gpu/drm/tegra/dc.c                  |   26 +-
>  drivers/gpu/drm/tegra/drm.c                 |  433 ++++++++++++++++++-
>  drivers/gpu/drm/tegra/drm.h                 |   72 ++--
>  drivers/gpu/drm/tegra/fb.c                  |   17 +-
>  drivers/gpu/drm/tegra/gr2d.c                |  309 ++++++++++++++
>  drivers/gpu/drm/tegra/hdmi.c                |   30 +-
>  drivers/gpu/drm/tegra/host1x.c              |  325 --------------
>  drivers/gpu/host1x/Kconfig                  |   28 ++
>  drivers/gpu/host1x/Makefile                 |   17 +
>  drivers/gpu/host1x/cdma.c                   |  475 ++++++++++++++++++++
>  drivers/gpu/host1x/cdma.h                   |  107 +++++
>  drivers/gpu/host1x/channel.c                |  137 ++++++
>  drivers/gpu/host1x/channel.h                |   64 +++
>  drivers/gpu/host1x/cma.c                    |  117 +++++
>  drivers/gpu/host1x/cma.h                    |   43 ++
>  drivers/gpu/host1x/debug.c                  |  207 +++++++++
>  drivers/gpu/host1x/debug.h                  |   49 +++
>  drivers/gpu/host1x/dev.c                    |  242 +++++++++++
>  drivers/gpu/host1x/dev.h                    |  167 ++++++++
>  drivers/gpu/host1x/drm.c                    |   51 +++
>  drivers/gpu/host1x/drm.h                    |   25 ++
>  drivers/gpu/host1x/hw/Makefile              |    6 +
>  drivers/gpu/host1x/hw/cdma_hw.c             |  480 +++++++++++++++++++++
>  drivers/gpu/host1x/hw/cdma_hw.h             |   37 ++
>  drivers/gpu/host1x/hw/channel_hw.c          |  147 +++++++
>  drivers/gpu/host1x/hw/debug_hw.c            |  399 +++++++++++++++++
>  drivers/gpu/host1x/hw/host1x01.c            |   46 ++
>  drivers/gpu/host1x/hw/host1x01.h            |   25 ++
>  drivers/gpu/host1x/hw/host1x01_hardware.h   |  150 +++++++
>  drivers/gpu/host1x/hw/hw_host1x01_channel.h |   98 +++++
>  drivers/gpu/host1x/hw/hw_host1x01_sync.h    |  179 ++++++++
>  drivers/gpu/host1x/hw/hw_host1x01_uclass.h  |  130 ++++++
>  drivers/gpu/host1x/hw/intr_hw.c             |  178 ++++++++
>  drivers/gpu/host1x/hw/syncpt_hw.c           |  157 +++++++
>  drivers/gpu/host1x/intr.c                   |  377 ++++++++++++++++
>  drivers/gpu/host1x/intr.h                   |  106 +++++
>  drivers/gpu/host1x/job.c                    |  618 +++++++++++++++++++++++++++
>  drivers/gpu/host1x/memmgr.c                 |  174 ++++++++
>  drivers/gpu/host1x/memmgr.h                 |   53 +++
>  drivers/gpu/host1x/syncpt.c                 |  398 +++++++++++++++++
>  drivers/gpu/host1x/syncpt.h                 |  134 ++++++
>  drivers/video/Kconfig                       |    2 +
>  include/drm/tegra_drm.h                     |  131 ++++++
>  include/linux/host1x.h                      |  217 ++++++++++
>  include/trace/events/host1x.h               |  296 +++++++++++++
>  52 files changed, 7095 insertions(+), 394 deletions(-)
>  create mode 100644 drivers/gpu/drm/tegra/gr2d.c
>  delete mode 100644 drivers/gpu/drm/tegra/host1x.c
>  create mode 100644 drivers/gpu/host1x/Kconfig
>  create mode 100644 drivers/gpu/host1x/Makefile
>  create mode 100644 drivers/gpu/host1x/cdma.c
>  create mode 100644 drivers/gpu/host1x/cdma.h
>  create mode 100644 drivers/gpu/host1x/channel.c
>  create mode 100644 drivers/gpu/host1x/channel.h
>  create mode 100644 drivers/gpu/host1x/cma.c
>  create mode 100644 drivers/gpu/host1x/cma.h
>  create mode 100644 drivers/gpu/host1x/debug.c
>  create mode 100644 drivers/gpu/host1x/debug.h
>  create mode 100644 drivers/gpu/host1x/dev.c
>  create mode 100644 drivers/gpu/host1x/dev.h
>  create mode 100644 drivers/gpu/host1x/drm.c
>  create mode 100644 drivers/gpu/host1x/drm.h
>  create mode 100644 drivers/gpu/host1x/hw/Makefile
>  create mode 100644 drivers/gpu/host1x/hw/cdma_hw.c
>  create mode 100644 drivers/gpu/host1x/hw/cdma_hw.h
>  create mode 100644 drivers/gpu/host1x/hw/channel_hw.c
>  create mode 100644 drivers/gpu/host1x/hw/debug_hw.c
>  create mode 100644 drivers/gpu/host1x/hw/host1x01.c
>  create mode 100644 drivers/gpu/host1x/hw/host1x01.h
>  create mode 100644 drivers/gpu/host1x/hw/host1x01_hardware.h
>  create mode 100644 drivers/gpu/host1x/hw/hw_host1x01_channel.h
>  create mode 100644 drivers/gpu/host1x/hw/hw_host1x01_sync.h
>  create mode 100644 drivers/gpu/host1x/hw/hw_host1x01_uclass.h
>  create mode 100644 drivers/gpu/host1x/hw/intr_hw.c
>  create mode 100644 drivers/gpu/host1x/hw/syncpt_hw.c
>  create mode 100644 drivers/gpu/host1x/intr.c
>  create mode 100644 drivers/gpu/host1x/intr.h
>  create mode 100644 drivers/gpu/host1x/job.c
>  create mode 100644 drivers/gpu/host1x/memmgr.c
>  create mode 100644 drivers/gpu/host1x/memmgr.h
>  create mode 100644 drivers/gpu/host1x/syncpt.c
>  create mode 100644 drivers/gpu/host1x/syncpt.h
>  create mode 100644 include/drm/tegra_drm.h
>  create mode 100644 include/linux/host1x.h
>  create mode 100644 include/trace/events/host1x.h
> 
