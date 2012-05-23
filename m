Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab2EWHVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 03:21:54 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:50651 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab2EWHVw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 03:21:52 -0400
MIME-Version: 1.0
In-Reply-To: <1337754877-19759-4-git-send-email-yinghai@kernel.org>
References: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
	<1337754877-19759-4-git-send-email-yinghai@kernel.org>
Date: Wed, 23 May 2012 08:21:51 +0100
Message-ID: <CAPM=9tyZLm+F1Sq3-ycOS7GmedjiU7DR-GQ=4Hj0BzaAxHHYxQ@mail.gmail.com>
Subject: Re: [PATCH 03/11] intel-gtt: Read 64bit for gmar_bus_addr
From: Dave Airlie <airlied@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 7:34 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> That bar could be 64bit pref mem.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: David Airlie <airlied@linux.ie>

Adding Daniel Vetter.

Dave.
> ---
>  drivers/char/agp/intel-gtt.c |   14 ++++++++++----
>  1 files changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
> index 7f025fb..77e150e 100644
> --- a/drivers/char/agp/intel-gtt.c
> +++ b/drivers/char/agp/intel-gtt.c
> @@ -770,16 +770,22 @@ static void i830_write_entry(dma_addr_t addr, unsigned int entry,
>  static bool intel_enable_gtt(void)
>  {
>        u32 gma_addr;
> +       u32 addr_hi = 0;
>        u8 __iomem *reg;
> +       int pos;
>
>        if (INTEL_GTT_GEN <= 2)
> -               pci_read_config_dword(intel_private.pcidev, I810_GMADDR,
> -                                     &gma_addr);
> +               pos = I810_GMADDR;
>        else
> -               pci_read_config_dword(intel_private.pcidev, I915_GMADDR,
> -                                     &gma_addr);
> +               pos = I915_GMADDR;
> +
> +       pci_read_config_dword(intel_private.pcidev, pos, &gma_addr);
> +
> +       if (gma_addr & PCI_BASE_ADDRESS_MEM_TYPE_64)
> +               pci_read_config_dword(intel_private.pcidev, pos + 4, &addr_hi);
>
>        intel_private.gma_bus_addr = (gma_addr & PCI_BASE_ADDRESS_MEM_MASK);
> +       intel_private.gma_bus_addr |= (u64)addr_hi << 32;
>
>        if (INTEL_GTT_GEN >= 6)
>            return true;
> --
> 1.7.7
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
