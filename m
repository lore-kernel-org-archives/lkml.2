Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650Ab1JXN3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 09:29:50 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:13624 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555Ab1JXN3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 09:29:48 -0400
X-SpamScore: -1
X-BigFish: VS-1(zz1432N98dKa1fflb922lzz1202hzzz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,
Date: Mon, 24 Oct 2011 21:40:26 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Grant Likely <grant.likely@secretlab.ca>, Rajendra Nayak <rnayak@ti.com>,
        <patches@linaro.org>, <tony@atomide.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <lrg@ti.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111024134025.GE1755@S2100-06.ap.freescale.net>
References: <20111018132032.GD30703@S2100-06.ap.freescale.net>
 <4E9EB61C.1040207@ti.com>
 <20111019144215.GA32007@S2100-06.ap.freescale.net>
 <4E9FAF42.5060200@ti.com>
 <20111020061408.GE32007@S2100-06.ap.freescale.net>
 <4EA00F7C.1080005@ti.com>
 <20111021082309.GA337@S2100-06.ap.freescale.net>
 <20111024092411.GE8708@ponder.secretlab.ca>
 <20111024130429.GD1755@S2100-06.ap.freescale.net>
 <20111024130636.GB26033@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111024130636.GB26033@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 03:06:37PM +0200, Mark Brown wrote:
> On Mon, Oct 24, 2011 at 09:04:31PM +0800, Shawn Guo wrote:
> 
> > If we can attach the device_node of 'regulators' node to dev->of_node
> > when calling regulator_register(regulator_desc, dev, ...) from
> > regulator driver, the regulator core will be able to find all nodes under
> > 'regulators' using for_each_child_of_node(dev->of_node, child).
> 
> Please provide concrete examples of the bindings you're talking about,
> the really important thing here is how sane the bindings look and I've
> really got no idea what any of what you're talking about will look like
> or if they make sense.
> 
The only thing different from what I attached last time is the
compatible string added to 'regulators' node.

        ecspi@70010000 { /* ECSPI1 */
                fsl,spi-num-chipselects = <2>;
                cs-gpios = <&gpio3 24 0>, /* GPIO4_24 */
                           <&gpio3 25 0>; /* GPIO4_25 */
                status = "okay";

                pmic: mc13892@0 {
                        #address-cells = <1>;
                        #size-cells = <0>;
                        compatible = "fsl,mc13892";
                        spi-max-frequency = <6000000>;
                        reg = <0>;
                        mc13xxx-irq-gpios = <&gpio0 8 0>; /* GPIO1_8 */

                        regulators {
                        	compatible = "fsl,mc13892-regulator";

                                sw1reg: mc13892_sw1 {
                                        regulator-min-uV = <600000>;
                                        regulator-max-uV = <1375000>;
                                        regulator-change-voltage;
                                        regulator-boot-on;
                                        regulator-always-on;
                                };

                                sw2reg: mc13892_sw2 {
                                        regulator-min-uV = <900000>;
                                        regulator-max-uV = <1850000>;
                                        regulator-change-voltage;
                                        regulator-boot-on;
                                        regulator-always-on;
                                };

                                ......
                        };

                        leds {
                                ......
                        };

                        buttons {
                                ......
                        };
                };

                flash: at45db321d@1 {
                        ......
                };
        };

> > hesitate to hack this into mfd_add_devices(), so I would like to add
> > compatible string "fsl,mc13892-regulators" to node 'regulators' and
> > find the node using of_find_compatible_node(dev->parent, NULL,
> > "fsl,mc13892-regulators").
> 
> It's not immediately obvious to me that having a binding for the
> regulators separately makes sense, it's not a usefully distinct device.
> 
Fair point.  Actually, I also hate to have the finding of node
'regulators' plugged into regulator driver.  What about following
change to address Grant's concern on global device tree search?
 
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 8fe132d..29dcf90 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2673,7 +2673,8 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
        BLOCKING_INIT_NOTIFIER_HEAD(&rdev->notifier);

        /* find device_node and attach it */
-       rdev->dev.of_node = of_find_node_by_name(NULL, regulator_desc->name);
+       rdev->dev.of_node = of_find_node_by_name(dev->parent->of_node,
+                                                regulator_desc->name);

        /* register with sysfs */
        rdev->dev.class = &regulator_class;

-- 
Regards,
Shawn

