Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761691Ab2FVIkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 04:40:08 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:41576 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab2FVIkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 04:40:01 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+1PUq+hQ1krhANuQVgoXv2
Date: Fri, 22 Jun 2012 01:39:56 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] pinctrl: Add one-register-per-pin type device tree
 based pinctrl driver
Message-ID: <20120622083955.GZ12766@atomide.com>
References: <20120611135826.GB12766@atomide.com>
 <4FDA6FCD.1020605@wwwdotorg.org>
 <20120615094938.GQ12766@atomide.com>
 <4FDB6000.5080703@wwwdotorg.org>
 <20120618055036.GU12766@atomide.com>
 <20120619135600.GX12766@atomide.com>
 <4FE39C86.5070901@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE39C86.5070901@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Stephen Warren <swarren@wwwdotorg.org> [120621 15:17]:
> On 06/19/2012 07:56 AM, Tony Lindgren wrote:
> > +
> > +- pinctrl-single,pinconf-mask : mask of allowed pinconf bits in the
> > +  pinmux register; this gets combined with pinconf mask but is a separate
> > +  mask to allow the option of setting pinconf separatately from the
> > +  function
> 
> Given that this binding doesn't allow describing pin configuration at
> present, I would simply remove all mention of that property in the
> binding documentation. It can be added back if/when that feature is
> added. Any future driver using this binding can refuse to allow pin
> configuration if that property is missing.

It might be better to just add support for pin_config_get/set to avoid
changing the binding later:

 static int pcs_pinconf_get(struct pinctrl_dev *pctldev,
                                unsigned pin, unsigned long *config)
 {
-	return -ENOTSUPP;
+	struct pcs_device *pcs;
+	void __iomem *reg;
+	int res;
+
+	pcs = pinctrl_dev_get_drvdata(pctldev);
+	res = pcs_pin_to_reg(pcs, pin, &reg);
+	if (res)
+		return res;
+
+	return pcs->read(reg) & pcs->cmask;
 }

A have not done that yet as currently the pcs_pin_to_reg() would need to be
sorted out in somewhat clean manner.
 
> > +- pinctrl-single,function-off : function off mode for disabled state if
> > +  available and same for all registers; if not, use a value larger than
> > +  function-mask to ignore disabling of registers
> 
> Rather than requiring an invalid value in this property, shouldn't the
> lack of a valid function-off value be represented by the property not
> being present in the DT?

Heh good point :) Will change.
 
> > +This driver assumes that there is only one register for each pin,
> > +and uses the common pinctrl bindings as specified in the pinctrl-bindings.txt
> > +document in this directory.
> 
> At this point in the file, I think you need to mention that you're
> switching from describing the top-level device node to describing pin
> configuration nodes.

Will add.
 
> > +The pinctrl register offsets and default values are specified as pairs
> 
> I thought we were going to remove "default" here?

Oops, looks like one was left, will remove.
 
> > +using pinctrl-single,pins. For example, setting a pin for a device
> > +could be done with:
> > +
> > +	pinctrl-single,pins = <0xdc 0x118>;
> > +
> > +Where 0xdc is the offset from the pinctrl register base address for the
> > +device pinctrl register, and 0x118 contains the desired value of the
> > +pinctrl register. See the device example and static board pins example
> > +below for more information.
> 
> There should be some explanation only the portion of this value covered
> by the pinctrl-single,function-mask value is updated in the register.

OK
 
> > +This driver tries to avoid understanding pin and function names because of
> > +the extra bloat they would cause especially in the case of a large number
> > +of pins. This driver just sets what is specified for the board in the .dts file.
> > +Further user space debugging tools can be developed to decipher the pin and
> > +function names using debugfs.
> 
> There shouldn't be any discussion of a driver here; the binding is a HW
> description.

Will move that to the driver comments.
 
> > +Example:
> 
> I only reviewed the binding document, not the code.

Thanks,

Tony
