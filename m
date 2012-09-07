Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab2IGIUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 04:20:06 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14969 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066Ab2IGIT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 04:19:58 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 07 Sep 2012 01:12:41 -0700
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
        Leela Krishna Amudala <leelakrishna.a@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v5 1/4] Runtime Interpreted Power Sequences
Date: Fri, 7 Sep 2012 17:21:52 +0900
Message-ID: <1380082.Ud3NsnIqpg@percival>
Organization: NVIDIA
User-Agent: KMail/4.9.1 (Linux/3.5.3-1-ARCH; KDE/4.9.1; x86_64; ; )
In-Reply-To: <504789B1.50205@wwwdotorg.org>
References: <1346412846-17102-1-git-send-email-acourbot@nvidia.com> <1346412846-17102-2-git-send-email-acourbot@nvidia.com> <504789B1.50205@wwwdotorg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Skipping the typos and rephrasing issues (which will all be addressed, 
thanks!), these issues caught my attention more particularly:

On Thursday 06 September 2012 01:19:45 Stephen Warren wrote:
> > +"regulator" type required properties:
> > +  - id: name of the regulator to use. Regulator is obtained by
> > +        regulator_get(dev, id)
> > +  - enable / disable: one of these two empty properties must be present
> > to
> > +                      enable or disable the resource
> > +
> > +"pwm" type required properties:
> > +  - id: name of the PWM to use. PWM is obtained by pwm_get(dev, id)
> > +  - enable / disable: one of these two empty properties must be present
> > to
> > +                      enable or disable the resource
> 
> For those two, would "name" be a better property name than "id"?

IIRC "name" is a reserved property name in the DT (I remember seeing an error 
message when compiling nodes with a "name" property that did not match the 
node's name). "id" was the second best candidate in my mind.

> > +"gpio" type required properties:
> > +  - number: phandle of the GPIO to use.
> 
> Naming the property "gpio" would seem more consistent with our GPIO
> properties.

Ok, although "gpio.gpio" might look strange in the platform data.

> > +  - enable / disable: one of these two empty properties must be present
> > to
> > +                      enable or disable the resource
> 
> You can't really enable or disable a GPIO (well, perhaps you can, but
> I'd consider that to affect tri-state rather than value); it's more that
> you're setting the output value to 0 or 1. I think a "value" or
> "set-value" property with value <0> or <1> would be better.

Right - will fix that.

> Overall, the general structure of the bindings looks reasonable to me.

Great, maybe we are finally headed to something stable!

> I'm not sure what "pdata" is supposed to point at; platform data applies
> to the original "struct device", not one of the resources used by the
> power sequences.

Right - more on this later.

> Hmmm. It'd be nice not to need separate functions for the non-DT and DT
> cases. That would require that devm_power_seq_set_build() be able to
> find the power sequence definitions somewhere other than platform data
> in the non-DT case - that's exactly why the regulator and pinctrl
> subsystems represent the device<->data mapping table separately from the
> device's platform data.

Oh, that sounds better indeed - I was still mentally stuck in the previous 
scheme where power sequences were not accessible from a fixed node of the 
device. Thanks.

> > +++ b/drivers/power/power_seq/Kconfig
> > 
> > +config POWER_SEQ
> > +	bool
> 
> Some kind of help text might be useful?

As this option was not user-visible but automatically enabled by drivers, I 
did not judge it to be necessary - but after reading your other mail we might 
need to make it visible and documented after all.

> > +/**
> > + * struct platform_power_seq_step - platform data for power sequences
> > steps + * @type:	The type of this step. This decides which member of 
the
> > union is + *		valid for this step.
> > + * @delay:	Used if type == POWER_SEQ_DELAY
> > + * @regulator:	Used if type == POWER_SEQ_REGULATOR
> > + * @pwm:	Used if type == POWER_SEQ_PWN
> > + * @gpio:	Used if type == POWER_SEQ_GPIO
> 
> In those last 4 line, I think s/type/@type/ since you're referencing
> another parameter?

Absolutely.

> > +struct power_seq_resource {
> > +	/* relevant for resolving the resource and knowing its type */
> > +	struct platform_power_seq_step *pdata;
> 
> Aha. So this isn't really platform data for the resource, but actually a
> step definition that referenced it. I think it'd be better to rename
> this field "step", and amend the documentation above not to refer to
> "pdata" but explicitly talk about a step definition; the step may have
> been defined in pdata, but isn't in the DT case.

This is a little bit confusing, isn't it? The resource identifier is duplicated 
in the platform data by every step that uses it. To avoid copying that 
information again into the resource structure, I just use this pointer to the 
first step that uses this resource. So a step not only contains step 
information, but also part of it might be used by a resource instance. Ugh, 
that's horribly confusing, actually.

> Alternatively, why not just copy the step type enum here, rather than
> referencing the step definition?

On top of the type we will also need the identifier of the resource (string for 
pwm and regulator, number for GPIO) so we can compare the resource against 
platform data when building the sequence to avoid allocating it twice. That's 
a little bit of extra memory, but the gain in clarity is probably worth it.

Alex.

