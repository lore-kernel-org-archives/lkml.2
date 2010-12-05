Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab0LEXj5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 18:39:57 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40394 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab0LEXj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 18:39:56 -0500
Date: Sun, 5 Dec 2010 23:39:42 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, Erik Gilling <konkers@android.com>,
        linux-kernel@vger.kernel.org, Colin Cross <ccross@google.com>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 20/21] ARM: tegra: Allow overriding arch_reset
Message-ID: <20101205233942.GB22824@n2100.arm.linux.org.uk>
References: <1291590548-7341-1-git-send-email-ccross@android.com> <1291590548-7341-21-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291590548-7341-21-git-send-email-ccross@android.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 05, 2010 at 03:09:07PM -0800, Colin Cross wrote:
> diff --git a/arch/arm/mach-tegra/include/mach/system.h b/arch/arm/mach-tegra/include/mach/system.h
> index 84d5d46..70c95ac 100644
> --- a/arch/arm/mach-tegra/include/mach/system.h
> +++ b/arch/arm/mach-tegra/include/mach/system.h
> @@ -24,16 +24,30 @@
>  #include <mach/hardware.h>
>  #include <mach/iomap.h>
>  
> +extern void (*tegra_reset)(char mode, const char *cmd);
> +
>  static inline void arch_idle(void)
>  {
>  }
>  
> -static inline void arch_reset(char mode, const char *cmd)
> +static inline void tegra_assert_system_reset(void)
>  {
>  	void __iomem *reset = IO_ADDRESS(TEGRA_CLK_RESET_BASE + 0x04);
> -	u32 reg = readl(reset);
> +	u32 reg;
> +
> +	reg = readl(reset);
>  	reg |= 0x04;
>  	writel(reg, reset);
>  }
>  
> +static inline void arch_reset(char mode, const char *cmd)
> +{
> +	if (tegra_reset)
> +		tegra_reset(mode, cmd);
> +	else
> +		tegra_assert_system_reset();
> +
> +	do { } while (1);
> +}
> +

How about:

extern void (*arch_reset)(char mode, const char *cmd);

and then in a tegra private .c file:

static void tegra_assert_system_reset(char mode, const char *cmd)
{
...
}

void (*arch_reset)(char mode, const char *cmd) = tegra_assert_system_reset;
