Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751254Ab1L2CdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 21:33:14 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:47567
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750714Ab1L2CdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 21:33:11 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 29 Dec 2011 10:46:48 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Dong Aisheng-B29396 <B29396@freescale.com>
CC: Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Message-ID: <20111229024647.GA11309@S2100-06.ap.freescale.net>
References: <1324402840-32451-1-git-send-email-b29396@freescale.com>
 <1324402840-32451-3-git-send-email-b29396@freescale.com>
 <74CDBE0F657A3D45AFBB94109FB122FF176BE92F00@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC6057885075542@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF176CC743EF@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC6057885077F82@039-SN2MPN1-013.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7FE21149F4667147B645348EC6057885077F82@039-SN2MPN1-013.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 02:41:25PM +0000, Dong Aisheng-B29396 wrote:
[...]
> > You could have nested sub-nodes, say something like:
> > 
> > iomuxc@020e0000 {
> >     compatible = "fsl,imx6q-iomuxc";
> >     reg = <0x020e0000 0x4000>;
> >     fsl,pins {
> >         ... // fsl-specific pin properties
> >     };
> >     fsl,groups {
> >         ... // fsl-specific group properties
> >     };
> >     fsl,functions {
> >         ... // fsl-specific mux function properties
> >     };
> >     pinmux-usage {
> >         // standardized pinmux "table" properties
> >         sd4 { // pin group name
> >             function = "sdio4"; // this function active on it
> >             ...
> >         };
> >         ...
> >     }
> >     ...
> > }
> > 
> Yes, I could do that.
> The extra effort is that we have to manually exclude one pinmux-usage
> node in pinmux driver since originally i take the child node count of
> iomuxc as the function count since all child nodes are functions,
> that why I firstly took the mapping node out of iomuxc, in addition
> the old way i used seems to be more brief and clear.
> 
Stephen suggested you put all the function nodes under node
'fsl,functions' (not sure prefix fsl is necessary).  In that case,
of_get_child_count() on 'fsl,functions' still get you the function
count you want, right?

But we do not bother with it, if we do not have pinmux-usage at all.
See below ...

> I tried adding pinmux-usage as a sub node of iomuxc and got two issues:
> Taking imx6q as an example:
> iomuxc@020e0000 {
>         uart4 {
>                 func-name = "uart4";
>                 grp-name = "uart4grp";
>                 grp-pins = <107 108>;
>                 num-pins = <2>;
>                 grp-mux = <4 4>;
>                 num-mux = <2>;
>         };
> 
>         sd4 {
>                 func-name = "sd4";
>                 grp-name = "sd4grp";
>                 grp-pins = <170 171 180 181 182 183 184 185 186 187>;
>                 num-pins = <10>;
>                 grp-mux = <0 0 1 1 1 1 1 1 1 1>;
>                 num-mux = <10>;
>         };
> 
>         pinmux-mapping {
>                 uart4 {
>                         function = "uart4";
>                         dev = <&uart4>;
>                 };
> 
>                 usdhc4 {
> /*			    ctrl-dev-name = "20e0000.iomuxc"; */
>                         function = "sd4";
>                         dev = <&usdhc4>;
>                 };
>         };
> };
> 
> If we remove ctrl-dev-name and get it from its parent node in drivers as
> you suggested,
> first, since this work will be done in the common API (pinmux_of_register_mappings
> Requires pass the pinmux mapping node to it for construct the mapping table)
> It will introduce a restriction that all platforms should define this node
> under their pinctrl device node.
> Second, it seems we cannot get its parent node device or device name in driver
> (can only get node Name which is not sufficient for construct the pin map table
> required by pinctrl core) and current device tree subsystem seems do not support
> get its associated device from a device node.
> We may not be able to construct ctrl-dev-name or ctrl-dev for struct pinmux_map.
> I'm not sure if I missed something, if missed please let me know.
> To support it, we may need to add support for converting device node
> to device. Not sure it's applicable since I still have not tried it.
> 
> The same issue applies to dev using a phandle.
> 
We do not bother with it, if we do not have pinmux-usage at all.
See below ...

[...]

> I was ever thought putting a phandle of pinmux function in each device,
> Then pinmux mapping table seems not need anymore. Like:
> 
> usdhc4: usdhc@0219c000 { /* uSDHC4 */
>         compatible = "fsl,imx6q-usdhc";
> 	....
>         pinmux = <&pinmux-sd4>;
> };
> 
> iomuxc@020e0000 {
>         pinmux-sd4 : sd4 {
>                 func-name = "sd4";
>                 grp-name = "sd4grp";
>                 grp-pins = <170 171 180 181 182 183 184 185 186 187>;
>                 num-pins = <10>;
>                 grp-mux = <0 0 1 1 1 1 1 1 1 1>;
>                 num-mux = <10>;
>         };
> 
> It is a pure hw point of view to define node.

That's the way we should go for.  This is exactly the same thing that
clk and regulator DT support is doing.  And right, in that way, we do
not need pinmux mapping for DT at all.

> And it may need to implement a of_pinmux_get.

To make the pinmux api generic for both dt and non-dt users, the pinmux
client driver should still see/call pinmux_get, something like
of_pinmux_get should be sorted out behind pinmux_get.

> But what about the pin maps without device associated?
> 
Do we have such cases?

-- 
Regards,
Shawn

