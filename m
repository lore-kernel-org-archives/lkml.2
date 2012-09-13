Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731Ab2IMGBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 02:01:04 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1236 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545Ab2IMGBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 02:01:01 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 12 Sep 2012 23:00:09 -0700
From: Alex Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v6 1/4] Runtime Interpreted Power Sequences
Date: Thu, 13 Sep 2012 15:02:54 +0900
Message-ID: <3678448.5nUOr4ZZV4@percival>
Organization: NVIDIA
User-Agent: KMail/4.9.1 (Linux/3.5.3-1-ARCH; KDE/4.9.1; x86_64; ; )
In-Reply-To: <50510791.8080302@wwwdotorg.org>
References: <1347443867-18868-1-git-send-email-acourbot@nvidia.com> <1347443867-18868-2-git-send-email-acourbot@nvidia.com> <50510791.8080302@wwwdotorg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 September 2012 06:07:13 Stephen Warren wrote:
> On 09/12/2012 03:57 AM, Alexandre Courbot wrote:
> > Some device drivers (panel backlights especially) need to follow precise
> > sequences for powering on and off, involving gpios, regulators, PWMs
> > with a precise powering order and delays to respect between each steps.
> > These sequences are board-specific, and do not belong to a particular
> > driver - therefore they have been performed by board-specific hook
> > functions to far.
> > 
> > With the advent of the device tree and of ARM kernels that are not
> > board-tied, we cannot rely on these board-specific hooks anymore but
> > need a way to implement these sequences in a portable manner. This patch
> > introduces a simple interpreter that can execute such power sequences
> > encoded either as platform data or within the device tree.
> > 
> > Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> > 
> > diff --git a/Documentation/power/power_seq.txt
> > b/Documentation/power/power_seq.txt
> > 
> > +Sometimes, you may want to browse the list of resources allocated by a
> > sequence, +for instance to ensure that a resource of a given type is
> > present. The +power_seq_set_resources() function returns a list head that
> > can be used with +the power_seq_for_each_resource() macro to browse all
> > the resources of a set: +
> > +  struct list_head *power_seq_set_resources(struct power_seq_set *seqs);
> 
> I don't think you need to include that prototype here?

Why not? I thought it was customary to include the prototypes in the 
documentation, and this seems to be the right place for this function.

> > +  power_seq_for_each_resource(pos, seqs)
> > +
> > +Here "pos" will be a pointer to a struct power_seq_resource. This
> > structure +contains the type of the resource, the information used for
> > identifying it, and +the resolved resource itself.
> > 
> > diff --git a/drivers/power/power_seq/Makefile
> > b/drivers/power/power_seq/Makefile new file mode 100644
> > index 0000000..f77a359
> > --- /dev/null
> > +++ b/drivers/power/power_seq/Makefile
> > @@ -0,0 +1 @@
> > +obj-$(CONFIG_POWER_SEQ)		+= power_seq.o
> 
> Don't you need to compile all the power_seq_*.c too?
> 
> Oh, I see the following in power_seq.c:
> > +#include "power_seq_delay.c"
> > +#include "power_seq_regulator.c"
> > +#include "power_seq_pwm.c"
> > +#include "power_seq_gpio.c"
> 
> It's probably better just to compile them separately and link them.
> 
> > diff --git a/drivers/power/power_seq/power_seq.c
> > b/drivers/power/power_seq/power_seq.c
> > 
> > +struct power_seq_step {
> > +	/* Copy of the platform data */
> > +	struct platform_power_seq_step pdata;
> 
> I'd reword the comment to "Copy of the step", and name the field "step".

That would make a step within a step - doesn't pdata make it more explicit 
what this member is for (containing the platform data for this step)?

> > +static const struct power_seq_res_ops
> > power_seq_types[POWER_SEQ_NUM_TYPES] = { +	[POWER_SEQ_DELAY] =
> > POWER_SEQ_DELAY_TYPE,
> > +	[POWER_SEQ_REGULATOR] = POWER_SEQ_REGULATOR_TYPE,
> > +	[POWER_SEQ_PWM] = POWER_SEQ_PWM_TYPE,
> > +	[POWER_SEQ_GPIO] = POWER_SEQ_GPIO_TYPE,
> > +};
> 
> Ah, I see why you're using #include now.

We could also go with something more dynamic and compile these files 
separately, but that would require some registration mechanism which I don't 
think is needed for such a simple feature.

> 
> > +MODULE_LICENSE("GPL");
> 
> s/GPL/GPL v2/ given the license header.
> 
> > diff --git a/drivers/power/power_seq/power_seq_gpio.c
> > b/drivers/power/power_seq/power_seq_gpio.c
> > 
> > +static int power_seq_res_alloc_gpio(struct device *dev,
> > +				    struct platform_power_seq_step *pstep,
> > +				    struct power_seq_resource *res)
> > +{
> > +	int err;
> > +
> > +	err = devm_gpio_request_one(dev, pstep->gpio.gpio,
> > +				    GPIOF_OUT_INIT_LOW, dev_name(dev));
> 
> Hmm. The INIT_LOW part of that might be somewhat presumptive. I would
> suggest simply requesting the GPIO here, and using
> gpio_direction_output() in power_seq_step_run_gpio(), thus deferring the
> decision of what value to set the GPIO to until a real sequence is
> actually run.
> 
> > diff --git a/drivers/power/power_seq/power_seq_pwm.c
> > b/drivers/power/power_seq/power_seq_pwm.c
> > 
> > diff --git a/drivers/power/power_seq/power_seq_regulator.c
> > b/drivers/power/power_seq/power_seq_regulator.c
> > 
> > diff --git a/include/linux/power_seq.h b/include/linux/power_seq.h
> > 
> > +#include <net/irda/parameters.h>
> 
> That looks out of place.

Totally, thanks. I don't even understand how it landed there in the first 
place.

> 
> > +/**
> > + * struct power_seq_resource - resource used by a power sequence set
> > + * @pdata:	Pointer to the platform data used to resolve this resource
> > + * @regulator:	Resolved regulator if of type POWER_SEQ_REGULATOR
> > + * @pwm:	Resolved PWM if of type POWER_SEQ_PWM
> > + * @list:	Used to link resources together
> > + */
> 
> I think that kerneldoc is stale.
> 
> > +struct power_seq_resource {
> > +	enum power_seq_res_type type;
> > +	/* resolved resource and identifier */
> > +	union {
> > +		struct {
> > +			struct regulator *regulator;
> > +			const char *id;
> > +		} regulator;
> > +		struct {
> > +			struct pwm_device *pwm;
> > +			const char *id;
> > +		} pwm;
> > +		struct {
> > +			int gpio;
> > +		} gpio;
> > +	};
> > +	struct list_head list;
> > +};
> 
> Aside from those minor issues, this all looks reasonable to me, so,
> Reviewed-by: Stephen Warren <swarren@wwwdotorg.org>

Thanks!

Alex.

