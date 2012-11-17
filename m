Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab2KQEEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 23:04:23 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:63756 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab2KQEEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 23:04:21 -0500
MIME-Version: 1.0
In-Reply-To: <20121116103511.GB16084@e106331-lin.cambridge.arm.com>
References: <1353047903-14363-1-git-send-email-acourbot@nvidia.com>
 <1353047903-14363-2-git-send-email-acourbot@nvidia.com> <20121116103511.GB16084@e106331-lin.cambridge.arm.com>
From: Alexandre Courbot <acourbot@nvidia.com>
Date: Sat, 17 Nov 2012 13:04:00 +0900
X-Google-Sender-Auth: 1a_41d3jyilRBrh8EOTF58YvZe4
Message-ID: <CAAVeFuL_r8PGM=0gDv=x2ff3GFCZQ4=DaZq4N9gfvXtnFC=aNg@mail.gmail.com>
Subject: Re: [PATCH v8 1/3] Runtime Interpreted Power Sequences
To: Mark Rutland <mark.rutland@arm.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Nov 16, 2012 at 7:35 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> Given there are several ARM platforms that may have an interest in this, please
> consider posting this to the ARM mailing list:
> linux-arm-kernel@lists.infradead.org.

That's right. New revision on the way.

>> +Similarly, each power sequence declares its steps as sub-nodes of itself. Steps
>> +must be named sequentially, with the first step named step0, the second step1,
>> +etc. Failure to follow this rule will result in a parsing error.
>
> Could we not encode the step number in the unit-address? i.e. step@N rather than
> stepN.

That was the way I did it initially, but it has been pointed out that
doing so would require to have #address-cells and #size-cells in every
power sequence, as well as a "reg" property in every step (see
https://lkml.org/lkml/2012/7/31/454 ). Although I'd prefer to use the
@ notation too (and neither dtc nor the kernel complained when I did
it), I tend to think the current solution is less burdensome than
having these redundant properties.

>> +"gpio" type required properties:
>> +  - gpio: phandle of the GPIO to use.
>> +  - value: value this GPIO should take. Must be 0 or 1.
>
> Is there any reason for id to be a name rather than a phandle? It seems
> inconsistent with the gpio case.

That's another long story. But to make it short, I'd like to make it
possible for power sequences to be referenced and shared between
devices of the same type (as everybody knows, copy/pasting is bad). If
we use phandles in steps, the power sequence becomes tied to the
referred resources and thus cannot be shared with another instance of
the same device. On the other hand, using an identifier that is
resolved at runtime (through e.g. regulator_get(device *, char *)
leverages the existing frameworks and makes things more flexible.

GPIO is currently the exception. It is the only framework for which
you cannot currently resolve a resource from a device and an
identifier. So at the moment we have to use a phandle - but we are
also working with Linus Walleij to provide an alternative GPIO API
that will be more like what we have for regulators/pinctrl/PWM/etc.

Another problem with phandles is that some of the functions that
resolve them are not publicly exported (i.e. AFAIK there is no public
function that returns a regulator from a phandle - the only to obtain
one is through regulator_get)

> I also see from the example below that the gpio property is not just a phandle,
> as it has the gpio-specifier appended. Is there a better way of describing this
> format in the documentation?

This is already clearly be defined in
Documentation/devicetree/bindings/gpio/, isn't it?

Thanks,
Alex.
