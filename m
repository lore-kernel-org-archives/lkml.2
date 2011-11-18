Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab1KRVlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 16:41:18 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51655 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327Ab1KRVlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 16:41:16 -0500
Date: Fri, 18 Nov 2011 13:41:16 -0800
From: Olof Johansson <olof@lixom.net>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Stephen Warren <swarren@nvidia.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 06/10] arm/tegra: prepare pinmux code for multiple tegra
 variants
Message-ID: <20111118214116.GC31678@quad.lixom.net>
References: <1321546766-26770-1-git-send-email-pdeschrijver@nvidia.com>
 <1321546766-26770-7-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321546766-26770-7-git-send-email-pdeschrijver@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 06:19:20PM +0200, Peter De Schrijver wrote:
> This patch modifies the pinmux code to be useable for multiple tegra variants.
> Some tegra20 specific constants will be replaced by variables which will be
> initialized to the appropriate value at runtime.
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> ---
>  arch/arm/mach-tegra/board-harmony-pcie.c     |    1 +
>  arch/arm/mach-tegra/board-harmony-pinmux.c   |    1 +
>  arch/arm/mach-tegra/board-paz00-pinmux.c     |    1 +
>  arch/arm/mach-tegra/board-trimslice-pinmux.c |    1 +
>  arch/arm/mach-tegra/include/mach/pinmux.h    |   25 +++----
>  arch/arm/mach-tegra/pinmux-tegra20-tables.c  |   15 +++-
>  arch/arm/mach-tegra/pinmux.c                 |  105 ++++++++++++++-----------
>  7 files changed, 86 insertions(+), 63 deletions(-)
> 
> diff --git a/arch/arm/mach-tegra/board-harmony-pcie.c b/arch/arm/mach-tegra/board-harmony-pcie.c
> index 6db7d69..bd402d0 100644
> --- a/arch/arm/mach-tegra/board-harmony-pcie.c
> +++ b/arch/arm/mach-tegra/board-harmony-pcie.c
> @@ -23,6 +23,7 @@
>  #include <asm/mach-types.h>
>  
>  #include <mach/pinmux.h>
> +#include <mach/pinmux-tegra20.h>

Boards shouldn't have to include this. The idea is that you should only
have to do board code against the pinmux.h interface, which internally
abstracts it for tegra 20 vs tegra 30.

[...]

> --- a/arch/arm/mach-tegra/include/mach/pinmux.h
> +++ b/arch/arm/mach-tegra/include/mach/pinmux.h
> @@ -17,12 +17,6 @@
>  #ifndef __MACH_TEGRA_PINMUX_H
>  #define __MACH_TEGRA_PINMUX_H
>  
> -#if defined(CONFIG_ARCH_TEGRA_2x_SOC)
> -#include "pinmux-tegra20.h"
> -#else
> -#error "Undefined Tegra architecture"
> -#endif
> -
>  enum tegra_mux_func {
>  	TEGRA_MUX_RSVD = 0x8000,
>  	TEGRA_MUX_RSVD1 = 0x8000,
> @@ -118,7 +112,7 @@ enum tegra_vddio {
>  };
>  
>  struct tegra_pingroup_config {
> -	enum tegra_pingroup	pingroup;
> +	int pingroup;
>  	enum tegra_mux_func	func;
>  	enum tegra_pullupdown	pupd;
>  	enum tegra_tristate	tristate;
> @@ -187,7 +181,7 @@ enum tegra_schmitt {
>  };
>  
>  struct tegra_drive_pingroup_config {
> -	enum tegra_drive_pingroup pingroup;
> +	int pingroup;
>  	enum tegra_hsm hsm;
>  	enum tegra_schmitt schmitt;
>  	enum tegra_drive drive;
> @@ -219,13 +213,15 @@ struct tegra_pingroup_desc {
>  	s8 pupd_bit;	/* offset into the PULL_UPDOWN_REG_* register bit */
>  };
>  
> -extern const struct tegra_pingroup_desc tegra_soc_pingroups[];
> -extern const struct tegra_drive_pingroup_desc tegra_soc_drive_pingroups[];
> +typedef void (*pinmux_init) (const struct tegra_pingroup_desc **pg,
> +	int *pg_max, const struct tegra_drive_pingroup_desc **pgdrive,
> +	int *pgdrive_max);

Ick, not a fan of this interface. It's better to fill in a struct or have the
bottom-layer code call back into the generic layer to register the various
tables.

> -int tegra_pinmux_set_tristate(enum tegra_pingroup pg,
> -	enum tegra_tristate tristate);
> -int tegra_pinmux_set_pullupdown(enum tegra_pingroup pg,
> -	enum tegra_pullupdown pupd);
> +void tegra20_pinmux_init(const struct tegra_pingroup_desc **pg, int *pg_max,
> +	const struct tegra_drive_pingroup_desc **pgdrive, int *pgdrive_max);
> +
> +int tegra_pinmux_set_tristate(int pg, enum tegra_tristate tristate);
> +int tegra_pinmux_set_pullupdown(int pg, enum tegra_pullupdown pupd);
>  
>  void tegra_pinmux_config_table(const struct tegra_pingroup_config *config,
>  	int len);
> @@ -241,4 +237,3 @@ void tegra_pinmux_config_tristate_table(const struct tegra_pingroup_config *conf
>  void tegra_pinmux_config_pullupdown_table(const struct tegra_pingroup_config *config,
>  	int len, enum tegra_pullupdown pupd);
>  #endif
> -
> diff --git a/arch/arm/mach-tegra/pinmux-tegra20-tables.c b/arch/arm/mach-tegra/pinmux-tegra20-tables.c
> index 88642a5..efe6aee 100644
> --- a/arch/arm/mach-tegra/pinmux-tegra20-tables.c
> +++ b/arch/arm/mach-tegra/pinmux-tegra20-tables.c
> @@ -44,7 +44,7 @@
>  		.reg = ((r) - PINGROUP_REG_A)			\
>  	}
>  
> -const struct tegra_drive_pingroup_desc tegra_soc_drive_pingroups[TEGRA_MAX_DRIVE_PINGROUP] = {
> +static const struct tegra_drive_pingroup_desc tegra_soc_drive_pingroups[TEGRA_MAX_DRIVE_PINGROUP] = {
>  	DRIVE_PINGROUP(AO1,		0x868),
>  	DRIVE_PINGROUP(AO2,		0x86c),
>  	DRIVE_PINGROUP(AT1,		0x870),
> @@ -108,7 +108,7 @@ const struct tegra_drive_pingroup_desc tegra_soc_drive_pingroups[TEGRA_MAX_DRIVE
>  		.pupd_bit = pupd_b,				\
>  	}
>  
> -const struct tegra_pingroup_desc tegra_soc_pingroups[TEGRA_MAX_PINGROUP] = {
> +static const struct tegra_pingroup_desc tegra_soc_pingroups[TEGRA_MAX_PINGROUP] = {
>  	PINGROUP(ATA,   NAND,  IDE,       NAND,      GMI,       RSVD,          IDE,       0x14, 0,  0x80, 24, 0xA0, 0),
>  	PINGROUP(ATB,   NAND,  IDE,       NAND,      GMI,       SDIO4,         IDE,       0x14, 1,  0x80, 16, 0xA0, 2),
>  	PINGROUP(ATC,   NAND,  IDE,       NAND,      GMI,       SDIO4,         IDE,       0x14, 2,  0x80, 22, 0xA0, 4),
> @@ -227,3 +227,14 @@ const struct tegra_pingroup_desc tegra_soc_pingroups[TEGRA_MAX_PINGROUP] = {
>  	PINGROUP(XM2C,  DDR,   RSVD,      RSVD,      RSVD,      RSVD,          RSVD,      -1,   -1, -1,   -1, 0xA8, 30),
>  	PINGROUP(XM2D,  DDR,   RSVD,      RSVD,      RSVD,      RSVD,          RSVD,      -1,   -1, -1,   -1, 0xA8, 28),
>  };
> +
> +void __init tegra20_pinmux_init(const struct tegra_pingroup_desc **pg,
> +		int *pg_max, const struct tegra_drive_pingroup_desc **pgdrive,
> +		int *pgdrive_max)
> +{
> +	*pg = tegra_soc_pingroups;
> +	*pg_max = TEGRA_MAX_PINGROUP;
> +	*pgdrive = tegra_soc_drive_pingroups;
> +	*pgdrive_max = TEGRA_MAX_DRIVE_PINGROUP;
> +}
> +
> diff --git a/arch/arm/mach-tegra/pinmux.c b/arch/arm/mach-tegra/pinmux.c
> index 1d20165..45ebd8c 100644
> --- a/arch/arm/mach-tegra/pinmux.c
> +++ b/arch/arm/mach-tegra/pinmux.c
> @@ -21,6 +21,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/io.h>
>  #include <linux/platform_device.h>
> +#include <linux/of_device.h>
>  
>  #include <mach/iomap.h>
>  #include <mach/pinmux.h>
> @@ -33,8 +34,10 @@
>  #define SLWR(reg)	(((reg) >> 28) & 0x3)
>  #define SLWF(reg)	(((reg) >> 30) & 0x3)
>  
> -static const struct tegra_pingroup_desc *const pingroups = tegra_soc_pingroups;
> -static const struct tegra_drive_pingroup_desc *const drive_pingroups = tegra_soc_drive_pingroups;
> +static const struct tegra_pingroup_desc *pingroups;
> +static const struct tegra_drive_pingroup_desc *drive_pingroups;
> +static int pingroup_max;
> +static int drive_max;
>  
>  static char *tegra_mux_names[TEGRA_MAX_MUX] = {
>  	[TEGRA_MUX_AHB_CLK] = "AHB_CLK",
> @@ -116,9 +119,9 @@ static const char *tegra_slew_names[TEGRA_MAX_SLEW] = {
>  
>  static DEFINE_SPINLOCK(mux_lock);
>  
> -static const char *pingroup_name(enum tegra_pingroup pg)
> +static const char *pingroup_name(int pg)
>  {
> -	if (pg < 0 || pg >=  TEGRA_MAX_PINGROUP)
> +	if (pg < 0 || pg >=  pingroup_max)
>  		return "<UNKNOWN>";
>  
>  	return pingroups[pg].name;
> @@ -189,10 +192,10 @@ static int tegra_pinmux_set_func(const struct tegra_pingroup_config *config)
>  	int i;
>  	unsigned long reg;
>  	unsigned long flags;
> -	enum tegra_pingroup pg = config->pingroup;
> +	int pg = config->pingroup;
>  	enum tegra_mux_func func = config->func;
>  
> -	if (pg < 0 || pg >=  TEGRA_MAX_PINGROUP)
> +	if (pg < 0 || pg >=  pingroup_max)
>  		return -ERANGE;
>  
>  	if (pingroups[pg].mux_reg < 0)
> @@ -230,13 +233,12 @@ static int tegra_pinmux_set_func(const struct tegra_pingroup_config *config)
>  	return 0;
>  }
>  
> -int tegra_pinmux_set_tristate(enum tegra_pingroup pg,
> -	enum tegra_tristate tristate)
> +int tegra_pinmux_set_tristate(int pg, enum tegra_tristate tristate)
>  {
>  	unsigned long reg;
>  	unsigned long flags;
>  
> -	if (pg < 0 || pg >=  TEGRA_MAX_PINGROUP)
> +	if (pg < 0 || pg >=  pingroup_max)
>  		return -ERANGE;
>  
>  	if (pingroups[pg].tri_reg < 0)
> @@ -255,13 +257,12 @@ int tegra_pinmux_set_tristate(enum tegra_pingroup pg,
>  	return 0;
>  }
>  
> -int tegra_pinmux_set_pullupdown(enum tegra_pingroup pg,
> -	enum tegra_pullupdown pupd)
> +int tegra_pinmux_set_pullupdown(int pg, enum tegra_pullupdown pupd)
>  {
>  	unsigned long reg;
>  	unsigned long flags;
>  
> -	if (pg < 0 || pg >=  TEGRA_MAX_PINGROUP)
> +	if (pg < 0 || pg >=  pingroup_max)
>  		return -ERANGE;
>  
>  	if (pingroups[pg].pupd_reg < 0)
> @@ -287,7 +288,7 @@ int tegra_pinmux_set_pullupdown(enum tegra_pingroup pg,
>  
>  static void tegra_pinmux_config_pingroup(const struct tegra_pingroup_config *config)
>  {
> -	enum tegra_pingroup pingroup = config->pingroup;
> +	int pingroup = config->pingroup;
>  	enum tegra_mux_func func     = config->func;
>  	enum tegra_pullupdown pupd   = config->pupd;
>  	enum tegra_tristate tristate = config->tristate;
> @@ -323,9 +324,9 @@ void tegra_pinmux_config_table(const struct tegra_pingroup_config *config, int l
>  		tegra_pinmux_config_pingroup(&config[i]);
>  }
>  
> -static const char *drive_pinmux_name(enum tegra_drive_pingroup pg)
> +static const char *drive_pinmux_name(int pg)
>  {
> -	if (pg < 0 || pg >=  TEGRA_MAX_DRIVE_PINGROUP)
> +	if (pg < 0 || pg >=  drive_max)
>  		return "<UNKNOWN>";
>  
>  	return drive_pingroups[pg].name;
> @@ -352,12 +353,11 @@ static const char *slew_name(unsigned long val)
>  	return tegra_slew_names[val];
>  }
>  
> -static int tegra_drive_pinmux_set_hsm(enum tegra_drive_pingroup pg,
> -	enum tegra_hsm hsm)
> +static int tegra_drive_pinmux_set_hsm(int pg, enum tegra_hsm hsm)
>  {
>  	unsigned long flags;
>  	u32 reg;
> -	if (pg < 0 || pg >=  TEGRA_MAX_DRIVE_PINGROUP)
> +	if (pg < 0 || pg >=  drive_max)
>  		return -ERANGE;
>  
>  	if (hsm != TEGRA_HSM_ENABLE && hsm != TEGRA_HSM_DISABLE)
> @@ -377,12 +377,11 @@ static int tegra_drive_pinmux_set_hsm(enum tegra_drive_pingroup pg,
>  	return 0;
>  }
>  
> -static int tegra_drive_pinmux_set_schmitt(enum tegra_drive_pingroup pg,
> -	enum tegra_schmitt schmitt)
> +static int tegra_drive_pinmux_set_schmitt(int pg, enum tegra_schmitt schmitt)
>  {
>  	unsigned long flags;
>  	u32 reg;
> -	if (pg < 0 || pg >=  TEGRA_MAX_DRIVE_PINGROUP)
> +	if (pg < 0 || pg >=  drive_max)
>  		return -ERANGE;
>  
>  	if (schmitt != TEGRA_SCHMITT_ENABLE && schmitt != TEGRA_SCHMITT_DISABLE)
> @@ -402,12 +401,11 @@ static int tegra_drive_pinmux_set_schmitt(enum tegra_drive_pingroup pg,
>  	return 0;
>  }
>  
> -static int tegra_drive_pinmux_set_drive(enum tegra_drive_pingroup pg,
> -	enum tegra_drive drive)
> +static int tegra_drive_pinmux_set_drive(int pg, enum tegra_drive drive)
>  {
>  	unsigned long flags;
>  	u32 reg;
> -	if (pg < 0 || pg >=  TEGRA_MAX_DRIVE_PINGROUP)
> +	if (pg < 0 || pg >=  drive_max)
>  		return -ERANGE;
>  
>  	if (drive < 0 || drive >= TEGRA_MAX_DRIVE)
> @@ -425,12 +423,12 @@ static int tegra_drive_pinmux_set_drive(enum tegra_drive_pingroup pg,
>  	return 0;
>  }
>  
> -static int tegra_drive_pinmux_set_pull_down(enum tegra_drive_pingroup pg,
> +static int tegra_drive_pinmux_set_pull_down(int pg,
>  	enum tegra_pull_strength pull_down)
>  {
>  	unsigned long flags;
>  	u32 reg;
> -	if (pg < 0 || pg >=  TEGRA_MAX_DRIVE_PINGROUP)
> +	if (pg < 0 || pg >=  drive_max)
>  		return -ERANGE;
>  
>  	if (pull_down < 0 || pull_down >= TEGRA_MAX_PULL)
> @@ -448,12 +446,12 @@ static int tegra_drive_pinmux_set_pull_down(enum tegra_drive_pingroup pg,
>  	return 0;
>  }
>  
> -static int tegra_drive_pinmux_set_pull_up(enum tegra_drive_pingroup pg,
> +static int tegra_drive_pinmux_set_pull_up(int pg,
>  	enum tegra_pull_strength pull_up)
>  {
>  	unsigned long flags;
>  	u32 reg;
> -	if (pg < 0 || pg >=  TEGRA_MAX_DRIVE_PINGROUP)
> +	if (pg < 0 || pg >=  drive_max)
>  		return -ERANGE;
>  
>  	if (pull_up < 0 || pull_up >= TEGRA_MAX_PULL)
> @@ -471,12 +469,12 @@ static int tegra_drive_pinmux_set_pull_up(enum tegra_drive_pingroup pg,
>  	return 0;
>  }
>  
> -static int tegra_drive_pinmux_set_slew_rising(enum tegra_drive_pingroup pg,
> +static int tegra_drive_pinmux_set_slew_rising(int pg,
>  	enum tegra_slew slew_rising)
>  {
>  	unsigned long flags;
>  	u32 reg;
> -	if (pg < 0 || pg >=  TEGRA_MAX_DRIVE_PINGROUP)
> +	if (pg < 0 || pg >=  drive_max)
>  		return -ERANGE;
>  
>  	if (slew_rising < 0 || slew_rising >= TEGRA_MAX_SLEW)
> @@ -494,12 +492,12 @@ static int tegra_drive_pinmux_set_slew_rising(enum tegra_drive_pingroup pg,
>  	return 0;
>  }
>  
> -static int tegra_drive_pinmux_set_slew_falling(enum tegra_drive_pingroup pg,
> +static int tegra_drive_pinmux_set_slew_falling(int pg,
>  	enum tegra_slew slew_falling)
>  {
>  	unsigned long flags;
>  	u32 reg;
> -	if (pg < 0 || pg >=  TEGRA_MAX_DRIVE_PINGROUP)
> +	if (pg < 0 || pg >=  drive_max)
>  		return -ERANGE;
>  
>  	if (slew_falling < 0 || slew_falling >= TEGRA_MAX_SLEW)
> @@ -517,7 +515,7 @@ static int tegra_drive_pinmux_set_slew_falling(enum tegra_drive_pingroup pg,
>  	return 0;
>  }
>  
> -static void tegra_drive_pinmux_config_pingroup(enum tegra_drive_pingroup pingroup,
> +static void tegra_drive_pinmux_config_pingroup(int pingroup,
>  					  enum tegra_hsm hsm,
>  					  enum tegra_schmitt schmitt,
>  					  enum tegra_drive drive,
> @@ -596,7 +594,7 @@ void tegra_pinmux_set_safe_pinmux_table(const struct tegra_pingroup_config *conf
>  	for (i = 0; i < len; i++) {
>  		int err;
>  		c = config[i];
> -		if (c.pingroup < 0 || c.pingroup >= TEGRA_MAX_PINGROUP) {
> +		if (c.pingroup < 0 || c.pingroup >= pingroup_max) {
>  			WARN_ON(1);
>  			continue;
>  		}
> @@ -617,7 +615,7 @@ void tegra_pinmux_config_pinmux_table(const struct tegra_pingroup_config *config
>  	for (i = 0; i < len; i++) {
>  		int err;
>  		if (config[i].pingroup < 0 ||
> -		    config[i].pingroup >= TEGRA_MAX_PINGROUP) {
> +		    config[i].pingroup >= pingroup_max) {
>  			WARN_ON(1);
>  			continue;
>  		}
> @@ -635,7 +633,7 @@ void tegra_pinmux_config_tristate_table(const struct tegra_pingroup_config *conf
>  {
>  	int i;
>  	int err;
> -	enum tegra_pingroup pingroup;
> +	int pingroup;
>  
>  	for (i = 0; i < len; i++) {
>  		pingroup = config[i].pingroup;
> @@ -654,7 +652,7 @@ void tegra_pinmux_config_pullupdown_table(const struct tegra_pingroup_config *co
>  {
>  	int i;
>  	int err;
> -	enum tegra_pingroup pingroup;
> +	int pingroup;
>  
>  	for (i = 0; i < len; i++) {
>  		pingroup = config[i].pingroup;
> @@ -668,11 +666,31 @@ void tegra_pinmux_config_pullupdown_table(const struct tegra_pingroup_config *co
>  	}
>  }
>  
> +static struct of_device_id tegra_pinmux_of_match[] __devinitdata = {
> +	{ .compatible = "nvidia,tegra20-pinmux", tegra20_pinmux_init },
> +	{ },
> +};
> +
>  static int __devinit tegra_pinmux_probe(struct platform_device *pdev)
>  {
>  	struct resource *res;
>  	int i;
>  	int config_bad = 0;
> +	const struct of_device_id *match;
> +
> +	match = of_match_device(tegra_pinmux_of_match, &pdev->dev);
> +
> +	if (match)
> +		((pinmux_init)(match->data))(&pingroups, &pingroup_max,

(()())()  too many parenthesis.

> +			&drive_pingroups, &drive_max);
> +#ifdef CONFIG_ARCH_TEGRA_2x_SOC
> +	else
> +		/* no device tree available, so we must be on tegra20 */
> +		tegra20_pinmux_init(&pingroups, &pingroup_max,
> +					&drive_pingroups, &drive_max);
> +#else
> +	pr_warn("non Tegra20 platform requires pinmux devicetree node\n");
> +#endif

Since there's no return in the if() above, this will always print if
CONFIG_ARCH_TEGRA_2x_SOC is disabled. Seems unintentional.

>  
>  	for (i = 0; ; i++) {
>  		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
> @@ -681,7 +699,7 @@ static int __devinit tegra_pinmux_probe(struct platform_device *pdev)
>  	}
>  	nbanks = i;
>  
> -	for (i = 0; i < TEGRA_MAX_PINGROUP; i++) {
> +	for (i = 0; i < pingroup_max; i++) {
>  		if (pingroups[i].tri_bank >= nbanks) {
>  			dev_err(&pdev->dev, "pingroup %d: bad tri_bank\n", i);
>  			config_bad = 1;
> @@ -698,7 +716,7 @@ static int __devinit tegra_pinmux_probe(struct platform_device *pdev)
>  		}
>  	}
>  
> -	for (i = 0; i < TEGRA_MAX_DRIVE_PINGROUP; i++) {
> +	for (i = 0; i < drive_max; i++) {
>  		if (drive_pingroups[i].reg_bank >= nbanks) {
>  			dev_err(&pdev->dev,
>  				"drive pingroup %d: bad reg_bank\n", i);
> @@ -741,11 +759,6 @@ static int __devinit tegra_pinmux_probe(struct platform_device *pdev)
>  	return 0;
>  }
>  
> -static struct of_device_id tegra_pinmux_of_match[] __devinitdata = {
> -	{ .compatible = "nvidia,tegra20-pinmux", },
> -	{ },
> -};
> -
>  static struct platform_driver tegra_pinmux_driver = {
>  	.driver		= {
>  		.name	= "tegra-pinmux",
> @@ -779,7 +792,7 @@ static int dbg_pinmux_show(struct seq_file *s, void *unused)
>  	int i;
>  	int len;
>  
> -	for (i = 0; i < TEGRA_MAX_PINGROUP; i++) {
> +	for (i = 0; i < pingroup_max; i++) {
>  		unsigned long reg;
>  		unsigned long tri;
>  		unsigned long mux;
> @@ -850,7 +863,7 @@ static int dbg_drive_pinmux_show(struct seq_file *s, void *unused)
>  	int i;
>  	int len;
>  
> -	for (i = 0; i < TEGRA_MAX_DRIVE_PINGROUP; i++) {
> +	for (i = 0; i < drive_max; i++) {
>  		u32 reg;
>  
>  		seq_printf(s, "\t{TEGRA_DRIVE_PINGROUP_%s",
> -- 
> 1.7.7.rc0.72.g4b5ea.dirty
> 
