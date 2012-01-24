Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab2AXMYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 07:24:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35732 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751471Ab2AXMYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 07:24:14 -0500
Date: Tue, 24 Jan 2012 12:24:11 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "lrg@ti.com" <lrg@ti.com>, "jedu@slimlogic.co.uk" <jedu@slimlogic.co.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1] regulator: tps65910: Sleep control through external
 inputs
Message-ID: <20120124122411.GB31839@opensource.wolfsonmicro.com>
References: <1327395919-32378-1-git-send-email-ldewangan@nvidia.com>
 <20120124115855.GC14888@opensource.wolfsonmicro.com>
 <4F1EA1E8.90104@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F1EA1E8.90104@nvidia.com>
X-Cookie: Q:	Are we not men?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 05:49:52PM +0530, Laxman Dewangan wrote:
> On Tuesday 24 January 2012 05:28 PM, Mark Brown wrote:
> >On Tue, Jan 24, 2012 at 02:35:19PM +0530, Laxman Dewangan wrote:

> >>+		err = tps65910_set_ext_sleep_config(pmic, i, 0);
> >>+		if (err<  0)
> >>+			dev_err(&pdev->dev, "Error in clearing external "
> >>+				"control\n");
> >>+	}

> >Why?

> The external controls for different rails are managed by power
> manament driver of soc in kernel to toggel them. The bootloader make
> sure that all external control signals are active just before
> jumping into kernel so that there is no issue during regulator init.
> When system reboots in kernel by kernel command, the configuration
> of the pmu still maintain as what it was in kernel before reboot and
> issue  system reboots. There is possibility that the default (POR)
> of these control signals are not active on soc reset or initial
> stage of the bootloader and hence it can turn off the rails which
> can avoid system booting.
> So kernel need to remove all external controls before reboot system.

The code needs to explain this stuff so readers will know.

> >>+ * Regulator mode when rail is in sleep state which controlled by external
> >>+ * input. The regultor will be OFF if it is in sleep state by default but
> >>+ * can be set in LOW power mode by ORing following macro with any of
> >>+ * above exterenl input option.
> >>+ */
> >>+#define TPS65910_SLEEP_CONTROL_REG_LOW_POWER		0x10
> >There's the suspend mode API for configuring suspend modes.

> Hmm.., I thought that  suspend mode apis manages the low/full-on
> power mode when the controls are not through external inputs. There
> is different register for configuring the power mode by i2c- write.
> This macro help in configuration of mode when enabled with external
> controls which configures in different sets of register.

No, usually it's used for configuring suspend mode when the PMIC knows
about system suspend.

> >>+	unsigned long regulator_ext_sleep_control[TPS65910_NUM_REGS];

> >I can't see anything in this code which will manage the enable signals?

> I used this  member in the probe as for configuring the rails..
> +        err = tps65910_set_ext_sleep_config(pmic, i,
> +                pmic_plat_data->regulator_ext_sleep_control[i]);

Right, but I can't see any code which manages the signals at runtime.
You tell the device to use the signals but the signals aren't (as far as
I can see) controlled by software.
