Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352Ab0HDRr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 13:47:26 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41698 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab0HDRrY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 13:47:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=oKmG3IV9Rh17ongLwQBSiQgFD2IMxnl1+kzKicoS6a0XuvthdN7wVzqyz5+DvQQSGx
         9o4cwkGlpelYKMU41+vEoRsQCicz3QYL7aXilrKz0c3VxKSn+7+PKirxz6Cwu9XKMF+5
         w5Z6XQsQuPIZO+YcMgkf2JBoKq6ZaMPRtIA4A=
MIME-Version: 1.0
In-Reply-To: <20100723224652.25725.36534.stgit@localhost.localdomain>
References: <20100723224652.25725.36534.stgit@localhost.localdomain>
Date: Wed, 4 Aug 2010 10:47:23 -0700
X-Google-Sender-Auth: i2c3MpNg9l6Z1LESIEy7C5vjb2w
Message-ID: <AANLkTim-otwN3mZZPLNz6s9hH1X+W4F-t93hdVCHNT+e@mail.gmail.com>
Subject: Re: [PATCH] ioat2: catch and recover from broken vtd configurations 
	v6
From: Dan Williams <dan.j.williams@intel.com>
To: David Woodhouse <David.Woodhouse@intel.com>
Cc: linux-kernel@vger.kernel.org, lkml@chrisli.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 3:47 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On some platforms (MacPro3,1) the BIOS assigns the ioatdma device to the
> incorrect iommu causing faults when the driver initializes.  Add a quirk
> to catch this misconfiguration and try falling back to untranslated
> operation (which works in the MacPro3,1 case).
>
> Assuming there are other platforms with misconfigured iommus teach the
> ioatdma driver to treat initialization failures as non-fatal (just fail
> the driver load and emit a warning instead of triggering a BUG_ON).
>
> This can be classified as a boot regression since 2.6.32 on affected
> platforms since the ioatdma module did not autoload prior to that
> kernel.
>
> Cc: <stable@kernel.org>
> Cc: David Woodhouse <David.Woodhouse@intel.com>
> Reported-by: Chris Li <lkml@chrisli.org>
> Tested-by: Chris Li <lkml@chrisli.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> David, looking for your sign-off to take this final version through my
> tree.

Ping.  I'm looking to include this in my 2.6.36 pull request.

>
> Thanks,
> Dan
>
>  drivers/dma/ioat/dma.h    |    1 +
>  drivers/dma/ioat/dma_v2.c |   24 ++++++++++++++++++++++--
>  drivers/dma/ioat/dma_v3.c |    5 ++++-
>  drivers/pci/intel-iommu.c |   28 ++++++++++++++++++++++++++++
>  4 files changed, 55 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
> index 6d3a73b..5216c8a 100644
> --- a/drivers/dma/ioat/dma.h
> +++ b/drivers/dma/ioat/dma.h
> @@ -97,6 +97,7 @@ struct ioat_chan_common {
>        #define IOAT_RESET_PENDING 2
>        #define IOAT_KOBJ_INIT_FAIL 3
>        #define IOAT_RESHAPE_PENDING 4
> +       #define IOAT_RUN 5
>        struct timer_list timer;
>        #define COMPLETION_TIMEOUT msecs_to_jiffies(100)
>        #define IDLE_TIMEOUT msecs_to_jiffies(2000)
> diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
> index 3c8b32a..216f9d3 100644
> --- a/drivers/dma/ioat/dma_v2.c
> +++ b/drivers/dma/ioat/dma_v2.c
> @@ -287,7 +287,10 @@ void ioat2_timer_event(unsigned long data)
>                        chanerr = readl(chan->reg_base + IOAT_CHANERR_OFFSET);
>                        dev_err(to_dev(chan), "%s: Channel halted (%x)\n",
>                                __func__, chanerr);
> -                       BUG_ON(is_ioat_bug(chanerr));
> +                       if (test_bit(IOAT_RUN, &chan->state))
> +                               BUG_ON(is_ioat_bug(chanerr));
> +                       else /* we never got off the ground */
> +                               return;
>                }
>
>                /* if we haven't made progress and we have already
> @@ -492,6 +495,8 @@ static struct ioat_ring_ent **ioat2_alloc_ring(struct dma_chan *c, int order, gf
>        return ring;
>  }
>
> +void ioat2_free_chan_resources(struct dma_chan *c);
> +
>  /* ioat2_alloc_chan_resources - allocate/initialize ioat2 descriptor ring
>  * @chan: channel to be initialized
>  */
> @@ -500,6 +505,7 @@ int ioat2_alloc_chan_resources(struct dma_chan *c)
>        struct ioat2_dma_chan *ioat = to_ioat2_chan(c);
>        struct ioat_chan_common *chan = &ioat->base;
>        struct ioat_ring_ent **ring;
> +       u64 status;
>        int order;
>
>        /* have we already been set up? */
> @@ -540,7 +546,20 @@ int ioat2_alloc_chan_resources(struct dma_chan *c)
>        tasklet_enable(&chan->cleanup_task);
>        ioat2_start_null_desc(ioat);
>
> -       return 1 << ioat->alloc_order;
> +       /* check that we got off the ground */
> +       udelay(5);
> +       status = ioat_chansts(chan);
> +       if (is_ioat_active(status) || is_ioat_idle(status)) {
> +               set_bit(IOAT_RUN, &chan->state);
> +               return 1 << ioat->alloc_order;
> +       } else {
> +               u32 chanerr = readl(chan->reg_base + IOAT_CHANERR_OFFSET);
> +
> +               dev_WARN(to_dev(chan),
> +                       "failed to start channel chanerr: %#x\n", chanerr);
> +               ioat2_free_chan_resources(c);
> +               return -EFAULT;
> +       }
>  }
>
>  bool reshape_ring(struct ioat2_dma_chan *ioat, int order)
> @@ -778,6 +797,7 @@ void ioat2_free_chan_resources(struct dma_chan *c)
>        del_timer_sync(&chan->timer);
>        device->cleanup_fn((unsigned long) c);
>        device->reset_hw(chan);
> +       clear_bit(IOAT_RUN, &chan->state);
>
>        spin_lock_bh(&chan->cleanup_lock);
>        spin_lock_bh(&ioat->prep_lock);
> diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
> index 1cdd22e..d0f4990 100644
> --- a/drivers/dma/ioat/dma_v3.c
> +++ b/drivers/dma/ioat/dma_v3.c
> @@ -361,7 +361,10 @@ static void ioat3_timer_event(unsigned long data)
>                        chanerr = readl(chan->reg_base + IOAT_CHANERR_OFFSET);
>                        dev_err(to_dev(chan), "%s: Channel halted (%x)\n",
>                                __func__, chanerr);
> -                       BUG_ON(is_ioat_bug(chanerr));
> +                       if (test_bit(IOAT_RUN, &chan->state))
> +                               BUG_ON(is_ioat_bug(chanerr));
> +                       else /* we never got off the ground */
> +                               return;
>                }
>
>                /* if we haven't made progress and we have already
> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> index 796828f..90938c7 100644
> --- a/drivers/pci/intel-iommu.c
> +++ b/drivers/pci/intel-iommu.c
> @@ -3029,6 +3029,34 @@ static void __init iommu_exit_mempool(void)
>
>  }
>
> +static void quirk_ioat_snb_local_iommu(struct pci_dev *pdev)
> +{
> +       struct dmar_drhd_unit *drhd;
> +       u32 vtbar;
> +       int rc;
> +
> +       /* We know that this device on this chipset has its own IOMMU.
> +        * If we find it under a different IOMMU, then the BIOS is lying
> +        * to us. Hope that the IOMMU for this device is actually
> +        * disabled, and it needs no translation...
> +        */
> +       rc = pci_bus_read_config_dword(pdev->bus, PCI_DEVFN(0, 0), 0xb0, &vtbar);
> +       if (rc) {
> +               /* "can't" happen */
> +               dev_info(&pdev->dev, "failed to run vt-d quirk\n");
> +               return;
> +       }
> +       vtbar &= 0xffff0000;
> +
> +       /* we know that the this iommu should be at offset 0xa000 from vtbar */
> +       drhd = dmar_find_matched_drhd_unit(pdev);
> +       if (WARN_TAINT_ONCE(!drhd || drhd->reg_base_addr - vtbar != 0xa000,
> +                           TAINT_FIRMWARE_WORKAROUND,
> +                           "BIOS assigned incorrect VT-d unit for Intel(R) QuickData Technology device\n"))
> +               pdev->dev.archdata.iommu = DUMMY_DEVICE_DOMAIN_INFO;
> +}
> +DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_SNB, quirk_ioat_snb_local_iommu);
> +
>  static void __init init_no_remapping_devices(void)
>  {
>        struct dmar_drhd_unit *drhd;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
