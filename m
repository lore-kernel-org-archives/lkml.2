Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758345Ab2CFJiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 04:38:16 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38680 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab2CFJiN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 04:38:13 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of andi.shyti@gmail.com designates 10.220.156.4 as permitted sender) smtp.mail=andi.shyti@gmail.com; dkim=pass header.i=andi.shyti@gmail.com
MIME-Version: 1.0
In-Reply-To: <1331023544-6439-3-git-send-email-mad_soft@inbox.ru>
References: <1331023544-6439-1-git-send-email-mad_soft@inbox.ru>
	<1331023544-6439-3-git-send-email-mad_soft@inbox.ru>
Date: Tue, 6 Mar 2012 10:38:12 +0100
Message-ID: <CANndwHav6JcqNOuOXcD1dSNUmVYAV=MJ+y+ud6202q6Dh42Vgw@mail.gmail.com>
Subject: Re: [PATCH/RFC 2/2] arm/tegra: add timeout to PCIe PLL lock detection loop
From: Andi <andi.shyti@gmail.com>
To: Dmitry Artamonow <mad_soft@inbox.ru>
Cc: linux-tegra@vger.kernel.org, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        Mike Rapoport <mike@compulab.co.il>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Mar 6, 2012 at 9:45 AM, Dmitry Artamonow <mad_soft@inbox.ru> wrote:
> Tegra PCIe driver waits for PLL to lock using busy loop.
> If PLL fails to lock for some reason, this leads to silent lockup
> while booting (as PCIe code is not modular).
>
> Fix by adding timeout, so if PLL doesn't lock in a couple
> of seconds, just PCIe driver fails and machine continues to boot.
>
> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
> ---
>  arch/arm/mach-tegra/pcie.c |   14 +++++++++++---
>  1 files changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm/mach-tegra/pcie.c b/arch/arm/mach-tegra/pcie.c
> index 14b29ab..ffdfdd4 100644
> --- a/arch/arm/mach-tegra/pcie.c
> +++ b/arch/arm/mach-tegra/pcie.c
> @@ -585,10 +585,10 @@ static void tegra_pcie_setup_translations(void)
>        afi_writel(0, AFI_MSI_BAR_SZ);
>  }
>
> -static void tegra_pcie_enable_controller(void)
> +static int tegra_pcie_enable_controller(void)
>  {
>        u32 val, reg;
> -       int i;
> +       int i, timeout;
>
>        /* Enable slot clock and pulse the reset signals */
>        for (i = 0, reg = AFI_PEX0_CTRL; i < 2; i++, reg += 0x8) {
> @@ -639,8 +639,14 @@ static void tegra_pcie_enable_controller(void)
>        pads_writel(0xfa5cfa5c, 0xc8);
>
>        /* Wait for the PLL to lock */
> +       timeout = 2000;
>        do {
>                val = pads_readl(PADS_PLL_CTL);
> +               mdelay(1);

why are you using an mdelay? If you need to sleep 1ms just use
usleep_range or similar

Andi

> +               if (--timeout == 0) {
> +                       pr_err("Tegra PCIe error: timeout waiting for PLL\n");
> +                       return -EBUSY;
> +               }
>        } while (!(val & PADS_PLL_CTL_LOCKDET));
>
>        /* turn off IDDQ override */
> @@ -921,7 +927,9 @@ int __init tegra_pcie_init(bool init_port0, bool init_port1)
>        if (err)
>                return err;
>
> -       tegra_pcie_enable_controller();
> +       err = tegra_pcie_enable_controller();
> +       if (err)
> +               return err;
>
>        /* setup the AFI address translations */
>        tegra_pcie_setup_translations();
> --
> 1.7.5.1.300.gc565c
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
