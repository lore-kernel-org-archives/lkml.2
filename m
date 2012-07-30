Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab2G3LAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 07:00:36 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34363 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab2G3LAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 07:00:33 -0400
MIME-Version: 1.0
In-Reply-To: <1343390750-3642-2-git-send-email-acourbot@nvidia.com>
References: <1343390750-3642-1-git-send-email-acourbot@nvidia.com>
	<1343390750-3642-2-git-send-email-acourbot@nvidia.com>
Date: Mon, 30 Jul 2012 12:00:32 +0100
X-Google-Sender-Auth: CLBU7QDUkQO-oMFIA4wCeUmW6BM
Message-ID: <CAPnjgZ0H2xrJcL-ytMaX11iYrrhCg7LEM00u_NgEaveM4gHMPw@mail.gmail.com>
Subject: Re: [RFC][PATCH v3 1/3] runtime interpreted power sequences
From: Simon Glass <sjg@chromium.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jul 27, 2012 at 1:05 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> Some device drivers (panel backlights especially) need to follow precise
> sequences for powering on and off, involving gpios, regulators, PWMs
> with a precise powering order and delays to respect between each steps.
> These sequences are board-specific, and do not belong to a particular
> driver - therefore they have been performed by board-specific hook
> functions to far.
>
> With the advent of the device tree and of ARM kernels that are not
> board-tied, we cannot rely on these board-specific hooks anymore but
> need a way to implement these sequences in a portable manner. This patch
> introduces a simple interpreter that can execute such power sequences
> encoded either as platform data or within the device tree.

This all looks very reasonable to me, just a few comments.

>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  Documentation/power/power_seq.txt | 120 +++++++++++++++
>  drivers/base/Kconfig              |   4 +
>  drivers/base/Makefile             |   1 +
>  drivers/base/power_seq.c          | 300 ++++++++++++++++++++++++++++++++++++++
>  include/linux/power_seq.h         | 139 ++++++++++++++++++
>  5 files changed, 564 insertions(+)
>  create mode 100644 Documentation/power/power_seq.txt
>  create mode 100644 drivers/base/power_seq.c
>  create mode 100644 include/linux/power_seq.h
>
> diff --git a/Documentation/power/power_seq.txt b/Documentation/power/power_seq.txt
> new file mode 100644
> index 0000000..aa2ceb5
> --- /dev/null
> +++ b/Documentation/power/power_seq.txt
> @@ -0,0 +1,120 @@
> +Runtime Interpreted Power Sequences
> +-----------------------------------
> +
> +Problem
> +-------
> +One very common board-dependent code is the out-of-driver code that is used to
> +turn a device on or off. For instance, SoC boards very commonly use a GPIO
> +(abstracted to a regulator or not) to control the power supply of a backlight,
> +disabling it when the backlight is not used in order to save power. The GPIO
> +that should be used, however, as well as the exact power sequence that may
> +involve different resources, is board-dependent and thus unknown of the driver.
> +
> +This has been addressed so far by using hooks in the device's platform data that
> +are called whenever the state of the device might reflect a power change. This
> +approach, however, introduces board-dependant code into the kernel and is not
> +compatible with the device tree.
> +
> +The Runtime Interpreted Power Sequences (or power sequences for short) aim at
> +turning this code into platform data or device tree nodes. Power sequences are
> +described using a simple format and run by a simple interpreter whenever needed.
> +This allows to remove the callback mechanism and makes the kernel less
> +board-dependant.
> +
> +Sequences Format
> +----------------
> +Power sequences are a series of sequential steps during which an action is
> +performed on a resource. The supported resources so far are:
> +- GPIOs
> +- Regulators
> +- PWMs
> +
> +Each step designates a resource and the following parameters:
> +- Whether the step should enable or disable the resource,
> +- Delay to wait before performing the action,
> +- Delay to wait after performing the action.
> +
> +Both new resources and parameters can be introduced, but the goal is of course
> +to keep things as simple and compact as possible.
> +
> +The platform data is a simple array of platform_power_seq_step instances, each
> +instance describing a step. The type as well as one of id or gpio members
> +(depending on the type) must be specified. The last step must be of type
> +POWER_SEQ_STOP. Regulator and PWM resources are identified by name. GPIO are
> +identified by number. For example, the following sequence will turn on the
> +"power" regulator of the device, wait 10ms, and set GPIO number 110 to 1:

For the delay, I think milliseconds is reasonable. I suppose there is
no reasonable need for microseconds?

> +
> +struct platform_power_seq_step power_on_seq[] = {
> +       {
> +               .type = POWER_SEQ_REGULATOR,
> +               .id = "power",
> +               .params = {
> +                       .enable = 1,
> +                       .post_delay = 10,
> +               },
> +       },
> +       {
> +               .type = POWER_SEQ_GPIO,
> +               .gpio = 110,
> +               .params = {
> +                       .enable = 1,
> +               },
> +       },
> +       {
> +               .type = POWER_SEQ_STOP,
> +       },
> +};
> +
> +Usage by Drivers and Resources Management
> +-----------------------------------------
> +Power sequences make use of resources that must be properly allocated and
> +managed. The power_seq_build() function takes care of resolving the resources as
> +they are met in the sequence and to allocate them if needed:
> +
> +power_seq *power_seq_build(struct device *dev, power_seq_resources *ress,
> +                          platform_power_seq *pseq);
> +
> +You will need an instance of power_seq_resources to keep track of the resources
> +that are already allocated. On success, the function returns a devm allocated
> +resolved sequence that is ready to be passed to power_seq_run(). In case of
> +failure, and error code is returned.
> +
> +A resolved power sequence returned by power_seq_build can be run by
> +power_run_run():
> +
> +int power_seq_run(struct device *dev, power_seq *seq);
> +
> +It returns 0 if the sequence has successfully been run, or an error code if a
> +problem occured.
> +
> +Finally, some resources that cannot be allocated through devm need to be freed
> +manually. Therefore, be sure to call power_seq_free_resources() in your device
> +remove function:
> +
> +void power_seq_free_resources(power_seq_resources *ress);
> +
> +Device tree
> +-----------
> +All the same, power sequences can be encoded as device tree nodes. The following
> +properties and nodes are equivalent to the platform data defined previously:
> +
> +               power-supply = <&mydevice_reg>;
> +               enable-gpio = <&gpio 6 0>;
> +
> +               power-on-sequence {
> +                       regulator@0 {
> +                               id = "power";

Is there a reason not to put the phandle here, like:

                                   id = <&mydevice_reg>;

(or maybe 'device' instead of id?)

> +                               enable;
> +                               post-delay = <10>;
> +                       };
> +                       gpio@1 {
> +                               id = "enable-gpio";
> +                               enable;
> +                       };
> +               };
> +
> +Note that first, the phandles of the regulator and gpio used in the sequences
> +are defined as properties. Then the sequence references them through the id
> +property of every step. The name of sub-properties defines the type of the step.
> +Valid names are "regulator", "gpio" and "pwm". Steps must be numbered
> +sequentially.

For the regulator and gpio types I think you only have an enable. For
the pwm, what is the intended binding? Is that documented elsewhere?

Also it might be worth mentioning how you get a struct power_seq from
an fdt node, and perhaps given an example of a device which has an
attached node, so we can see how it is referenced from the device
(of_parse_power_seq I think). Do put the sequence inside the device
node or reference it with a phandle?

Finally, should you use typedefs?

Regards,
Simon
