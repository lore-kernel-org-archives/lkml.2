Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab1KQUlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 15:41:51 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38515 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693Ab1KQUlu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 15:41:50 -0500
MIME-Version: 1.0
In-Reply-To: <4EC54132.5070908@gmail.com>
References: <1321542430-17971-1-git-send-email-pdeschrijver@nvidia.com>
 <4EC52BCF.7020609@gmail.com> <20111117155428.GS19069@tbergstrom-lnx.Nvidia.com>
 <CACxGe6ub2QBO0ZLwNdSvMxP1U087pqL-qL+dfWAbn-08gBQyvg@mail.gmail.com> <4EC54132.5070908@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 17 Nov 2011 13:41:28 -0700
X-Google-Sender-Auth: tuL1ounZW6j2riM8jM94OkVmXxU
Message-ID: <CACxGe6vP3dFUeSN0xLPi0iywGbdtZLgieD1k=5z2EiS9cw6VsA@mail.gmail.com>
Subject: Re: [PATCH] arm/tegra: convert tegra20 to GIC devicetree binding
To: Rob Herring <robherring2@gmail.com>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Marc Dietrich <marvin24@gmx.de>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Colin Cross <ccross@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 10:15 AM, Rob Herring <robherring2@gmail.com> wrote:
> On 11/17/2011 10:53 AM, Grant Likely wrote:
>>
>> On Nov 17, 2011 8:54 AM, "Peter De Schrijver" <pdeschrijver@nvidia.com
>> <mailto:pdeschrijver@nvidia.com>> wrote:
>>>
>>> On Thu, Nov 17, 2011 at 04:44:15PM +0100, Rob Herring wrote:
>>> > On 11/17/2011 09:07 AM, Peter De Schrijver wrote:
>>> > > Convert tegra20 IRQ intialization to the GIC devicetree binding.
>> Modify the
>>> > > interrupt definitions in the dts files according to
>>> > > Documentation/devicetree/bindings/arm/gic.txt
>>> > >
>>> > > Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com
>> <mailto:pdeschrijver@nvidia.com>>
>>> >
>>> > One minor comment below, but otherwise:
>>> >
>>> > Acked-by: Rob Herring <rob.herring@calxeda.com
>> <mailto:rob.herring@calxeda.com>>
>>> >
>>> > > ---
>>> > >  arch/arm/boot/dts/tegra-paz00.dts |    2 +-
>>> > >  arch/arm/boot/dts/tegra20.dtsi    |   52
>> ++++++++++++++++++------------------
>>> > >  arch/arm/mach-tegra/irq.c         |   18 +++++++++++-
>>> > >  3 files changed, 43 insertions(+), 29 deletions(-)
>>> > >
>>> > > diff --git a/arch/arm/boot/dts/tegra-paz00.dts
>> b/arch/arm/boot/dts/tegra-paz00.dts
>>> > > index 15a949f..7ff8f6f 100644
>>> > > --- a/arch/arm/boot/dts/tegra-paz00.dts
>>> > > +++ b/arch/arm/boot/dts/tegra-paz00.dts
>>> > > @@ -32,7 +32,7 @@
>>> > >             #size-cells = <0>;
>>> > >             compatible = "nvidia,nvec";
>>> > >             reg = <0x7000C500 0x100>;
>>> > > -           interrupts = <124>;
>>> > > +           interrupts = <0 92 0x04>;
>>> > >             clock-frequency = <80000>;
>>> > >             request-gpios = <&gpio 170 0>;
>>> > >             slave-addr = <138>;
>>> > > diff --git a/arch/arm/boot/dts/tegra20.dtsi
>> b/arch/arm/boot/dts/tegra20.dtsi
>>> > > index 795b921..cd01b01 100644
>>> > > --- a/arch/arm/boot/dts/tegra20.dtsi
>>> > > +++ b/arch/arm/boot/dts/tegra20.dtsi
>>> > > @@ -5,9 +5,9 @@
>>> > >     interrupt-parent = <&intc>;
>>> > >
>>> > >     intc: interrupt-controller@50041000 {
>>> > > -           compatible = "nvidia,tegra20-gic";
>>> > > +           compatible = "arm,cortex-a9-gic";
>>> > >             interrupt-controller;
>>> >
>>> > You should add an "interrupt-parent;" here so the gic's parent is null
>>> > and not the gic.
>>>
>>> Ok. I will add that in the next version.
>>
>> No, there is no need to do that, nor is it convention. The gic node
>> doesn't have an interrupts property, so the interrupt-parent is irrelevant.
>>
> Can't resist the inbox? Go back to your sabbatical.. :) We discussed
> this before and I though agreed this was the correct approach.

It's a little hard to stop cold turkey.  :-(

Yup, we had discussed it (and your description below jogged my
memory), but I don't remember talking about adding an empty
interrupt-parent property.  I only remember making sure that
of_irq_find_parent() got fixed.

> It inherits the interrupt-parent from the parent node. Originally
> of_irq_find_parent would return that node, but this was fixed. So it
> doesn't really matter from a functional standpoint.
>
> So is no interrupt parent defined as no interrupts property or
> interrupt-parent being null phandle?

There is no precedence for setting a null interrupt-parent and no need
to, so I say just leave it out.

>> Rob, perhaps we should adjust of_init_irq() to only set the parent
>> pointer if interrupts is present.
>>
>
> It works correctly already either way.

Okay, I wasn't sure.  Let's leave it alone.

g.
