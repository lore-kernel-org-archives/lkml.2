Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759715Ab2D0DjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 23:39:00 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:57908
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759603Ab2D0Di6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 23:38:58 -0400
X-SpamScore: -21
X-BigFish: VS-21(zz179dN1102I154dM1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 27 Apr 2012 11:48:27 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhao Richard-B20223 <B20223@freescale.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
Subject: Re: [PATCH v3 2/4] pinctrl: pinctrl-imx: add imx pinctrl core
 driver
Message-ID: <20120427034825.GA826@shlinux2.ap.freescale.net>
References: <1335451227-27709-1-git-send-email-b29396@freescale.com>
 <1335451227-27709-2-git-send-email-b29396@freescale.com>
 <20120426144446.GN9142@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120426144446.GN9142@game.jcrosoft.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 10:44:46PM +0800, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 22:40 Thu 26 Apr     , Dong Aisheng wrote:
> > From: Dong Aisheng <dong.aisheng@linaro.org>
> > 
> > The driver has mux and config support while the gpio is still
> > not supported.
> > For select input setting, the driver will handle it internally
> > and do not need user to take care of it.
> > 
> > The pinctrl-imx core driver will parse the dts file and dynamically
> > create the pinmux functions and groups.
> > 
> > Each IMX SoC pinctrl driver should register pins with a pin register map
> > including mux register and config register and select input map to core
> > for proper operations.
> > 
> > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> > 
> > ---
> > ChangeLog: v2->v3:
> > * add missed SION bit set from device tree
> >   Thanks for Richard Zhao's reminder.
> > ChangeLog: v1->v2:
> > * Change the binding a bit.
> >   For fsl,pins property, change it from pin name strings to pin function id
> >   which represents a pin working on a specific function. Then we can remove
> >   fsl,mux property since the pin function id already contains the mux setting.
> >   Also remove other pin config property in the first patch.
> >   Because in the future, we will switch to use dtc macro, then using a lot of
> >   propertys to represent the each pin config like pull, speed and etc seems
> >   needless.
> >   Then each pin entry in dts file becomes a pair of PIN_FUNC_ID and CONFIG:
> >   fsl,pins = <PIN_FUNC_ID CONFIG ..>
> >   See binding doc for details.
> > * Sascha raised a question that pins in the same group may have different
> >   pad setting for example I2C_CLK needs pull up while I2C_DAT not.
> >   The v1 driver can aslo handle this issue but needs split the different
> >   pad setting pins into different groups which loses a bit flexibility.
> >   Also suggested by Richard Zhao and Jason Liu, we may still want the iomux
> >   v3 simililar using way that allows each pin has the abiblity to configure
> >   its pad which seems reasonable because from HW point of view, FSL IMX are
> >   indeed pin based SoC which should be able to set per pin.
> >   So the main changes in this v2 patch are change to support per pin config.
> >   Then the using of iomux is almost the same as the existing iomux v3 for
> >   non dt imx platforms. See binding doc for example.
> > 
> >   After introduce the new way, there're mainly two known issues:
> >   1) Since many pins in the same group may have the same pad config setting,
> >      thus there may be some data redundance, however, since it's one word
> >      and it's purely describe hw i would think it's not a big issue.
> >   2) Need a magic number to indicate no pad config need. In current iomux v3,
> >      It's 1<<16 which is not used by IMX5, i used 1<<31 for both MX5 and MX6.
> >      However, it's definitely possibile that in the future, the bit 31 may also
> >      be used, that means we may need change the binding doc or just handle it in
> >      driver for different SoCs.
> >   3) Due to core limitation, the current pinconf_group_set/get only support
> >      get/set the same config(a u32 value)for all the pins in the same group,
> >      so i removed the imx_group_set/get functions support, instead, using
> >      imx_pin_get/set.
> >      About this limitation, we may need some futher discussion on if we may
> >      need to enhance it to be more flexible to support configure different
> >      pins in the same group.
> > * Refactor probe handling based on Stephen's suggestion.
> > * Enhanced the binding doc and split it into two part, pinctrl-imx common part
> >   and pinctrl-soc driver part.
> > * Change functions name from imx_pmx_* to imx_pinctrl_*.
> > * Other fixes based on Sascha, Stephen, Linus, Shawn's comments.
> > ---
> >  .../bindings/pinctrl/fsl,imx-pinctrl.txt           |   93 +++
> >  drivers/pinctrl/Kconfig                            |    5 +
> >  drivers/pinctrl/Makefile                           |    1 +
> >  drivers/pinctrl/pinctrl-imx.c                      |  627 ++++++++++++++++++++
> >  drivers/pinctrl/pinctrl-imx.h                      |  106 ++++
> >  5 files changed, 832 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/pinctrl/fsl,imx-pinctrl.txt
> >  create mode 100644 drivers/pinctrl/pinctrl-imx.c
> >  create mode 100644 drivers/pinctrl/pinctrl-imx.h
> > 
> > diff --git a/Documentation/devicetree/bindings/pinctrl/fsl,imx-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/fsl,imx-pinctrl.txt
> > new file mode 100644
> > index 0000000..e00c7fc
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/pinctrl/fsl,imx-pinctrl.txt
> > @@ -0,0 +1,93 @@
> > +* Freescale IOMUX Controller (IOMUXC) for i.MX
> > +
> > +The IOMUX Controller (IOMUXC), together with the IOMUX, enables the IC
> > +to share one PAD to several functional blocks. The sharing is done by
> > +multiplexing the PAD input/output signals. For each PAD there are up to
> > +8 muxing options (called ALT modes). Since different modules require
> > +different PAD settings (like pull up, keeper, etc) the IOMUXC controls
> > +also the PAD settings parameters.
> > +
> > +Please refer to pinctrl-bindings.txt in this directory for details of the
> > +common pinctrl bindings used by client devices, including the meaning of the
> > +phrase "pin configuration node".
> > +
> > +Freescale IMX pin configuration node is a node of a group of pins which can be
> > +used for a specific device or function. This node represents both mux and config
> > +of the pins in that group. The 'mux' selects the function mode(also named mux
> > +mode) this pin can work on and the 'config' configures various pad settings
> > +such as pull-up, open drain, drive strength, etc.
> > +
> > +Required properties for iomux controller:
> > +- compatible: "fsl,<soc>-iomuxc"
> > +  Please refer to each fsl,<soc>-pinctrl.txt binding doc for supported SoCs.
> > +
> > +Required properties for pin configuration node:
> > +- fsl,pins: two integers array, represents a group of pins mux and config
> > +  setting. The format is fsl,pins = <PIN_FUNC_ID CONFIG>, PIN_FUNC_ID is a
> > +  pin working on a specific function, CONFIG is the pad setting value like
> > +  pull-up on this pin. Please refer to fsl,<soc>-pinctrl.txt for the valid
> > +  pins and functions of each SoC.
> > +
> > +Bits used for CONFIG:
> > +NO_PAD_CTL(1 << 31): indicate this pin does not need config.
> > +
> > +SION(1 << 30): Software Input On Field.
> > +Force the selected mux mode input path no matter of MUX_MODE functionality.
> > +By default the input path is determined by functionality of the selected
> > +mux mode (regular).
> > +
> > +Other bits are used for PAD setting.
> > +
> > +NOTE:
> > +Some requirements for using fsl,imx-pinctrl binding:
> > +1. We have pin function node defined under iomux controller node to represent
> > +   what pinmux functions this SoC supports.
> > +2. The pin configuration node intends to work on a specific function should
> > +   to be defined under that specific function node.
> > +   The function node's name should represent well about what function
> > +   this group of pins in this pin configuration node are working on.
> > +3. The driver can use the function node's name and pin configuration node's
> > +   name describe the pin function and group hierarchy.
> > +   For example, Linux IMX pinctrl driver takes the function node's name
> > +   as the function name and pin configuration node's name as group name to
> > +   create the map table.
> > +4. Each pin configuration node should have a phandle, devices can set pins
> > +   configurations by referring to the phandle of that pin configuration node.
> > +
> > +Examples:
> > +usdhc@0219c000 { /* uSDHC4 */
> > +	fsl,card-wired;
> > +	vmmc-supply = <&reg_3p3v>;
> > +	status = "okay";
> > +	pinctrl-names = "default";
> > +	pinctrl-0 = <&pinctrl_usdhc4_1>;
> > +};
> > +
> > +iomuxc@020e0000 {
> > +	compatible = "fsl,imx6q-iomuxc";
> > +	reg = <0x020e0000 0x4000>;
> > +
> > +	/* shared pinctrl settings */
> > +	usdhc4 {
> > +		pinctrl_usdhc4_1: usdhc4grp-1 {
> > +			fsl,pins = <1386 0x17059	/* MX6Q_PAD_SD4_CMD__USDHC4_CMD */
> > +				    1392 0x17059	/* MX6Q_PAD_SD4_CLK__USDHC4_CLK	*/
> > +				    1462 0x17059	/* MX6Q_PAD_SD4_DAT0__USDHC4_DAT0 */
> > +				    1470 0x17059	/* MX6Q_PAD_SD4_DAT1__USDHC4_DAT1 */
> > +				    1478 0x17059	/* MX6Q_PAD_SD4_DAT2__USDHC4_DAT2 */
> > +				    1486 0x17059	/* MX6Q_PAD_SD4_DAT3__USDHC4_DAT3 */
> > +				    1493 0x17059	/* MX6Q_PAD_SD4_DAT4__USDHC4_DAT4 */
> > +				    1501 0x17059	/* MX6Q_PAD_SD4_DAT5__USDHC4_DAT5 */
> > +				    1509 0x17059	/* MX6Q_PAD_SD4_DAT6__USDHC4_DAT6 */
> > +				    1517 0x17059>;	/* MX6Q_PAD_SD4_DAT7__USDHC4_DAT7 */
> honestly I don't like this it's obscure need to decode manually
> 
> I propose to use phandle
> 
> as example on uart you will want or not the rst/cts so you will have quite a
> lot of bindings
> 
> so you can describe the pin configuration (function) and refer it by phandle
> in the group
> 
Hmm, i can't say you're wrong.
What you suggested may be suitable for your SoCs, before i know more about your SoC
details, i may not comment too much.

The binding i used here basically follows the exist iomux v3 convention which we're
using for non dt platforms, i think most people working on fsl platform may would
want a similar using as before since iomux v3 is very easy to use for imx soc.
You can refer to: iomux-mx51.h.

After dt macro support is available(which is still in progress), we may
convert the raw data above to raw data then user do not need to decode
the setting anymore.

Regards
Dong Aisheng

