Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab1LDNV1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 08:21:27 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35248 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab1LDNVZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 08:21:25 -0500
MIME-Version: 1.0
In-Reply-To: <1321615040-13257-2-git-send-email-rnayak@ti.com>
References: <1321615040-13257-1-git-send-email-rnayak@ti.com>
	<1321615040-13257-2-git-send-email-rnayak@ti.com>
Date: Sun, 4 Dec 2011 18:51:23 +0530
Message-ID: <CAJuYYwRO+AS=WmQfNAe8L6Gi5Dm4VsCuVqk3X5Nb8uUYAdLnJQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] regulator: helper routine to extract regulator_init_data
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Rajendra Nayak <rnayak@ti.com>
Cc: broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        robherring2@gmail.com, linaro-dev@lists.linaro.org, patches@linaro.org,
        tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, olof@lixom.net,
        linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 November 2011 16:47, Rajendra Nayak <rnayak@ti.com> wrote:
> The helper routine is meant to be used by the regulator drivers
> to extract the regulator_init_data structure from the data
> that is passed from device tree.
> 'consumer_supplies' which is part of regulator_init_data is not extracted
> as the regulator consumer mappings are passed through DT differently,
> implemented in subsequent patches.
> Similarly the regulator<-->parent/supply mapping is handled in
> subsequent patches.
>
> Also add documentation for regulator bindings to be used to pass
> regulator_init_data struct information from device tree.
>
> Some of the regulator properties which are linux and board specific,
> are left out since its not clear if they can
> be in someway embedded into the kernel or passed in from DT.
> They will be revisited later.
>
> Signed-off-by: Rajendra Nayak <rnayak@ti.com>
> ---
>  .../devicetree/bindings/regulator/regulator.txt    |   54 +++++++++++++
>  drivers/regulator/Makefile                         |    1 +
>  drivers/regulator/of_regulator.c                   |   81 ++++++++++++++++++++
>  include/linux/regulator/of_regulator.h             |   20 +++++
>  4 files changed, 156 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/regulator/regulator.txt
>  create mode 100644 drivers/regulator/of_regulator.c
>  create mode 100644 include/linux/regulator/of_regulator.h
>
> diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt
> new file mode 100644
> index 0000000..82bef20
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/regulator/regulator.txt
> @@ -0,0 +1,54 @@
> +Voltage/Current Regulators
> +
> +Optional properties:
> +- regulator-name: A string used as a descriptive name for regulator outputs
> +- regulator-min-microvolt: smallest voltage consumers may set
> +- regulator-max-microvolt: largest voltage consumers may set
> +- regulator-microvolt-offset: Offset applied to voltages to compensate for voltage drops
> +- regulator-min-microamp: smallest current consumers may set
> +- regulator-max-microamp: largest current consumers may set
> +- regulator-always-on: boolean, regulator should never be disabled
> +- regulator-boot-on: bootloader/firmware enabled regulator
> +- <name>-supply: phandle to the parent supply/regulator node

For regulators that are not turned on by bootloader, and which require
'apply_uV' constraint, is there any alternative for turning on the
regulator when using dt?

Or, how about adding a additional check as below.

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 5baa196..25a6781 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -816,8 +816,9 @@ static int machine_constraints_voltage(struct
regulator_dev *rdev,
 	int ret;

 	/* do we need to apply the constraint voltage */
-	if (rdev->constraints->apply_uV &&
-	    rdev->constraints->min_uV == rdev->constraints->max_uV) {
+	if ((rdev->constraints->apply_uV &&
+	    rdev->constraints->min_uV == rdev->constraints->max_uV) ||
+		(!rdev->constraints->boot_on && rdev->constraints->always_on)) {
 		ret = _regulator_do_set_voltage(rdev,
 						rdev->constraints->min_uV,
 						rdev->constraints->max_uV);

Thanks,
Thomas.
