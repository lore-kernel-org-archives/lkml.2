Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab2KPKfR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 05:35:17 -0500
Received: from service87.mimecast.com ([91.220.42.44]:45672 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab2KPKfP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 05:35:15 -0500
Date: Fri, 16 Nov 2012 10:35:11 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v8 1/3] Runtime Interpreted Power Sequences
Message-ID: <20121116103511.GB16084@e106331-lin.cambridge.arm.com>
References: <1353047903-14363-1-git-send-email-acourbot@nvidia.com>
 <1353047903-14363-2-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <1353047903-14363-2-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 16 Nov 2012 10:35:12.0448 (UTC) FILETIME=[0EF58C00:01CDC3E6]
X-MC-Unique: 112111610351301601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 06:38:21AM +0000, Alexandre Courbot wrote:
> Some device drivers (e.g. panel or backlights) need to follow precise
> sequences for powering on and off, involving GPIOs, regulators, PWMs
> with a precise powering order and delays to respect between steps.
> These sequences are device-specific, and do not belong to a particular
> driver - therefore they have been performed by board-specific hook
> functions to far.
> 
> With the advent of the device tree and of ARM kernels that are not
> board-tied, we cannot rely on these board-specific hooks anymore but
> need a way to implement these sequences in a portable manner. This patch
> introduces a simple interpreter that can execute such power sequences
> encoded either as platform data or within the device tree.

Given there are several ARM platforms that may have an interest in this, please
consider posting this to the ARM mailing list:
linux-arm-kernel@lists.infradead.org.

> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> Reviewed-by: Stephen Warren <swarren@wwwdotorg.org>
> Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  .../devicetree/bindings/power/power_seq.txt        | 121 +++++++
>  Documentation/power/power_seq.txt                  | 253 ++++++++++++++
>  drivers/power/Kconfig                              |   1 +
>  drivers/power/Makefile                             |   1 +
>  drivers/power/power_seq/Kconfig                    |   2 +
>  drivers/power/power_seq/Makefile                   |   1 +
>  drivers/power/power_seq/power_seq.c                | 376 +++++++++++++++++++++
>  drivers/power/power_seq/power_seq_delay.c          |  65 ++++
>  drivers/power/power_seq/power_seq_gpio.c           |  94 ++++++
>  drivers/power/power_seq/power_seq_pwm.c            |  82 +++++
>  drivers/power/power_seq/power_seq_regulator.c      |  83 +++++
>  include/linux/power_seq.h                          | 203 +++++++++++
>  12 files changed, 1282 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/power/power_seq.txt
>  create mode 100644 Documentation/power/power_seq.txt
>  create mode 100644 drivers/power/power_seq/Kconfig
>  create mode 100644 drivers/power/power_seq/Makefile
>  create mode 100644 drivers/power/power_seq/power_seq.c
>  create mode 100644 drivers/power/power_seq/power_seq_delay.c
>  create mode 100644 drivers/power/power_seq/power_seq_gpio.c
>  create mode 100644 drivers/power/power_seq/power_seq_pwm.c
>  create mode 100644 drivers/power/power_seq/power_seq_regulator.c
>  create mode 100644 include/linux/power_seq.h
> 
> diff --git a/Documentation/devicetree/bindings/power/power_seq.txt b/Documentation/devicetree/bindings/power/power_seq.txt
> new file mode 100644
> index 0000000..7880a6c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/power/power_seq.txt
> @@ -0,0 +1,121 @@
> +Runtime Interpreted Power Sequences
> +===================================
> +
> +Power sequences are sequential descriptions of actions to be performed on
> +power-related resources. Having these descriptions in a well-defined data format
> +allows us to take much of the board- or device- specific power control code out
> +of the kernel and place it into the device tree instead, making kernels less
> +board-dependant.
> +
> +A device typically makes use of multiple power sequences, for different purposes
> +such as powering on and off. All the power sequences of a given device are
> +grouped into a set. In the device tree, this set is a sub-node of the device
> +node named "power-sequences".
> +
> +Power Sequences Structure
> +-------------------------
> +Every device that makes use of power sequences must have a "power-sequences"
> +node into which individual power sequences are declared as sub-nodes. The name
> +of the node becomes the name of the sequence within the power sequences
> +framework.
> +
> +Similarly, each power sequence declares its steps as sub-nodes of itself. Steps
> +must be named sequentially, with the first step named step0, the second step1,
> +etc. Failure to follow this rule will result in a parsing error.

Could we not encode the step number in the unit-address? i.e. step@N rather than
stepN.

If we ever add additional (non step) data to sequences it might make it easier
to filter, as we only reserve one name rather than a class of names.

> +
> +Power Sequences Steps
> +---------------------
> +Steps of a sequence describe an action to be performed on a resource. They
> +always include a "type" property which indicates what kind of resource this
> +step works on. Depending on the resource type, additional properties are defined
> +to control the action to be performed.
> +
> +"delay" type required properties:
> +  - delay: delay to wait (in microseconds)
> +
> +"regulator" type required properties:
> +  - id: name of the regulator to use.
> +  - enable / disable: one of these two empty properties must be present to
> +                      enable or disable the resource
> +
> +"pwm" type required properties:
> +  - id: name of the PWM to use.
> +  - enable / disable: one of these two empty properties must be present to
> +                      enable or disable the resource
> +
> +"gpio" type required properties:
> +  - gpio: phandle of the GPIO to use.
> +  - value: value this GPIO should take. Must be 0 or 1.

Is there any reason for id to be a name rather than a phandle? It seems
inconsistent with the gpio case.

I also see from the example below that the gpio property is not just a phandle,
as it has the gpio-specifier appended. Is there a better way of describing this
format in the documentation?

> +Example
> +-------
> +Here are example sequences declared within a backlight device that use all the
> +supported resources types:
> +
> +       backlight {
> +               compatible = "pwm-backlight";
> +               ...
> +
> +               /* resources used by the power sequences */
> +               pwms = <&pwm 2 5000000>;
> +               pwm-names = "backlight";
> +               power-supply = <&backlight_reg>;
> +
> +               power-sequences {
> +                       power-on {
> +                               step0 {
> +                                       type = "regulator";
> +                                       id = "power";
> +                                       enable;
> +                               };
> +                               step1 {
> +                                       type = "delay";
> +                                       delay = <10000>;
> +                               };
> +                               step2 {
> +                                       type = "pwm";
> +                                       id = "backlight";
> +                                       enable;
> +                               };
> +                               step3 {
> +                                       type = "gpio";
> +                                       gpio = <&gpio 28 0>;
> +                                       value = <1>;
> +                               };
> +                       };
> +
> +                       power-off {
> +                               step0 {
> +                                       type = "gpio";
> +                                       gpio = <&gpio 28 0>;
> +                                       value = <0>;
> +                               };
> +                               step1 {
> +                                       type = "pwm";
> +                                       id = "backlight";
> +                                       disable;
> +                               };
> +                               step2 {
> +                                       type = "delay";
> +                                       delay = <10000>;
> +                               };
> +                               step3 {
> +                                       type = "regulator";
> +                                       id = "power";
> +                                       disable;
> +                               };
> +                       };
> +               };
> +       };
 
Thanks,
Mark

