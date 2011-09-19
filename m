Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab1ISVQC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 17:16:02 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50484 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792Ab1ISVQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 17:16:00 -0400
MIME-Version: 1.0
In-Reply-To: <4E774847.3020104@gmail.com>
References: <1316017900-19918-1-git-send-email-robherring2@gmail.com>
 <1316017900-19918-6-git-send-email-robherring2@gmail.com> <CAJuYYwSFu2HC+u2NY41+yw9tEyy85RKa4Dpm3SL+jbwS_OOA0A@mail.gmail.com>
 <4E71CE5D.9030900@ti.com> <4E71F978.6020402@gmail.com> <4E72030F.1090300@ti.com>
 <4E722B2D.4050307@gmail.com> <4E76615C.3000005@gmail.com> <4E77310A.3000106@ti.com>
 <4E774847.3020104@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 19 Sep 2011 15:14:54 -0600
X-Google-Sender-Auth: 73Dq3cyjJpiogJyJUvstebNPQrE
Message-ID: <CACxGe6v9nd5f5x-eu9hUyAqdS1+p3h6ixyutECYLdNo3ewDH0w@mail.gmail.com>
Subject: Re: [PATCH 5/5] ARM: gic: add OF based initialization
To: Rob Herring <robherring2@gmail.com>
Cc: "Cousson, Benoit" <b-cousson@ti.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 7:48 AM, Rob Herring <robherring2@gmail.com> wrote:
> On 09/19/2011 07:09 AM, Cousson, Benoit wrote:
>> On 9/18/2011 11:23 PM, Rob Herring wrote:
>>> I was headed down the path of implementing the 2nd option above,
>>> but had a dilemma. What would be the numbering base for PPIs in
>>> this case? Should it be 0 in the DT as proposed for SPIs or does it
>>> stay at 16?
>>
>> Both SGI and PPI are internal to the CortexA9 MP core, and referring
>> to the CortexA9 MP core TRM [1], you can see that the PPI# -> ID#
>> mapping is already documented: - Private timer, PPI(2) Each Cortex-A9
>> processor has its own private timers that can generate interrupts,
>> using ID29. - Watchdog timers, PPI(3) Each Cortex-A9 processor has
>> its own watchdog timers that can generate interrupts, using ID30.
>>
>> So in that case, it can makes sense to use the ID. But it is
>> interesting to note that the PPI is identified with a 0 based index
>> number.
>>
> It's even worse than I thought: we could use 13 (ID16 == PPI0), 29 or 2
> for the timer interrupt. The first would match 0 based SPI convention.
> The last 2 would both match the documentation. We could never use 2 as
> this will for sure be different and the GIC code will have no way to
> know how to do the translation to ID. The only sane choice is using the
> ID as you say.
>
> But you can't have it both ways. It does not make sense to use the ID
> for some interrupts and a different scheme for others.

Hmmm, it seems to me that some orthogonal issues are getting
conflated.  Specifically, the binding vs. what the GIC driver using
internally.  For my own understanding, let me see if I can summarize
and clarify the problem.

Each GIC IRQ is represented in 5 different ways:
1) the hardware documentation (PPI[0-15] or SPI[988] input pin)
2) The DT binding to represent the connection.
3) The Interrupt ID as specified by the GIC architecture reference[1]
(SGI:[0-15], PPI:[16-31], SPI:[32-1019], special:[1020-1023])
4) The internal HWIRQ representation used by the GIC driver
5) The Linux VIRQ number that #4 maps to.

[1] http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.ihi0048b/BCGBFHCH.html

Some thoughts:
- Generally the DT binding (#2) should reflect the HW view of the
system (#1) since that is the number most likely to be represented in
hardware manuals.  The interrupt ID is an internal detail of the GIC,
and isn't really exposed in the block diagram of the hardware.
- Presumably it is preferable for the GIC to directly use the
Interrupt ID (#3) as the HWIRQ number (#4) because it is the most
efficient from an interrupt handling perspective, and indeed this is
currently what the GIC driver does.
- Translation between the DT binding (#2) and the Interrupt ID / HWIRQ
(#3/#4) is trivial, and easily managed by the GIC's irq_domain.
- Though not necessarily as trivial, the mapping between Linux VIRQ
and HWIRQ is not fixed, and when migrating to DT it should be assumed
to be assigned at runtime.  Perhaps not so important for a core IRQ
controller like the GIC (as opposed to an i2c irq expander), but
assuming an fixed offset still should be avoided.  We may still force
a SPI0->VIRQ32 on the root GIC as an optimization, but it is not
necessary and the driver still needs to support remapping for a
secondary GIC.

So, for the GIC DT binding, I'm inclined to agree with Benoit that the
binding should reflect the hardware connections, not the values used
by software for decoding IRQs.  Also, I see absolutely no need to use
separate nodes for each GIC interrupt space.  The DT interrupt
specifier number space can more than handle the features of the GIC in
a clear and concise manor.  So, here's my counter proposal for a GIC
bindings (using Rob's text as the starting point):

----

* ARM Generic Interrupt Controller

ARM SMP cores are often associated with a GIC, providing per processor
interrupts (PPI), shared processor interrupts (SPI) and software
generated interrupts (SGI).

Primary GIC is attached directly to the CPU and typically has PPIs and SGIs.
Secondary GICs are cascaded into the upward interrupt controller and do not
have PPIs or SGIs.

Main node required properties:

- compatible : should be one of:
       "arm,cortex-a9-gic"
       "arm,arm11mp-gic"
- interrupt-controller : Identifies the node as an interrupt controller
- #interrupt-cells : Specifies the number of cells needed to encode an
  interrupt source.  The type shall be a <u32> and the value shall be 3.

  The 1st cell is the interrupt type; 0 for SPI interrupts, 1 for PPI
interrupts.
  The 2nd cell contains the interrupt number for the interrupt type.
SPI interrupts are in the range [0-987].  PPI interrupts are in the
range [0-15].
  The 3rd cell is the flags, encoded as follows:
        bits[3:0] trigger type and level flags.
                    1 = low-to-high edge triggered
                    2 = high-to-low edge triggered
                    4 = active high level-sensitive
                    8 = active low level-sensitive
        bits[15:8] PPI interrupt cpu mask.  Each bit corresponds to
each of the 8 possible cpus attached to the GIC.  A bit set to '1'
indicated the interrupt is wired to that CPU.  Only valid for PPI
interrupts.

(Alternately, if there is no need for a CPU mask because PPI
interrupts will never be wired to more than one CPU, then it would be
better to encode the CPU number into the second cell with the SPI
number).

- reg : Specifies base physical address(s) and size of the GIC registers. The
  first 2 values are the GIC distributor register base and size. The 2nd 2
  values are the GIC cpu interface register base and size.

Optional
- interrupts   : Interrupt source of the parent interrupt controller. Only
  present on secondary GICs.

Example:
       intc: interrupt-controller@fff11000 {
               compatible = "arm,cortex-a9-gic";
               #interrupt-cells = <3>;
               #address-cells = <1>;
               interrupt-controller;
               reg = <0xfff11000 0x1000>,
                     <0xfff10100 0x100>;
       };
