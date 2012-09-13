Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab2IMOhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 10:37:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54057 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989Ab2IMOhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 10:37:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rajanikanth HV <rajanikanth.hv@stericsson.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: Implement devicetree support for AB8500 Btemp
Date: Thu, 13 Sep 2012 14:37:38 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Rajanikanth HV <rajanikanth.hv@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "STEricsson_nomadik_linux" <STEricsson_nomadik_linux@list.st.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>
References: <CAB4BAktQz5MY_AHHWUAhRp7HtEzC3v8uFbP0enx1b7ibJLoZ4Q@mail.gmail.com> <201209121536.56346.arnd@arndb.de> <5051E02B.5040703@stericsson.com>
In-Reply-To: <5051E02B.5040703@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201209131437.38666.arnd@arndb.de>
X-Provags-ID: V02:K0:2JEESkreztcMU9pMeQUxesZpIHdo6y0Zz/NLVjcO2nQ
 1aQoNIVJczw6mopX+dBLj5aU0PbNDEVLnpWwkQRuo/1s745v12
 Q9cMxoY8XZi3UDWD9bTmn3JcU92zqDYk1xih2Ij4fJLmkYeA+l
 xYExHvaeaeOo1t7B5mNZIdXu8Rkm3GlIUrHRe8sxp3bqNwJOXS
 oYes7rJw8Xwt3YBiMtNRqlWYk64K9X+o6/UbkIppXY9hSSppVV
 +qVDmTx2gTOVGnlGVqULl7Bs6Nz30Flf+aiR8MKT7ifNADxzBc
 Ldbnui6Onzy4SkVRmuTSAf5YX6FJGAAteZ8xPpiXADCVc2m0QE
 F12LDlovzl0AacEvTR+Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 September 2012, Rajanikanth HV wrote:
> On Wednesday 12 September 2012 09:06 PM, Arnd Bergmann wrote:> > 
> > If this is true, I don't understand what makes the 'supplied-to'
> > properties you list in the device tree binding board specific. Are
> > they not always done the same way? If so, you could just leave them
> > out.
> Precisely 'supplied-to' is not board specific, it was maintained as
> platform_data which i migrated to dt-node. It is meant to establish
> dependency across bm drivers based on power_supply property and
> runtime battery attributes.
> Basically, 'supplied-to' provides a way of exporting change in
> power_supply_property and runtime batter characteristics so that other
> bm devs shall make use or refer the updated values.
> Ref: external_power_changed(...) call back api.
> Note: all the bm drivers handles subset of power_supply property and
>       battery attributes,
>       ref: include/linux/power_supply.h and get_property(...) call back
>       api across bm drivers.

Ok, so you want to just remove the property from the device tree,
or do you want to establish a different method to specify these
connections?

> > What does indeed seem to be needed is a place to identify the battery
> > type, but it's not clear if the btemp device is the best place for
> > that (maybe it is). 
> I am not clear whether you are trying to correlate battery-type with
> supplied-to. however, battery type is identified based on the
> resistance value measured at batctrl pin which is expected to be in the
> allowable limit of ab8500 device. This resistance limit varies across
> battery types. This happens in btemp driver.

I wasn't correlating them. I just mentioned that unlike the supplied-to
property, the battery type property does seem to belong into the device
tree.

> For this, I would suggest you give a list of
> > possible batteries and require a property such as
> > 
> >  st-ericsson,battery-type: A string identifier for the type of battery,
> > 			   which impacts how an operating system interpret
> > 			   the sensor readings. Possible values include:
> > 	* "none"	-- no battery connected
> > 	* "li-ion-9100" -- Type 9100 Li-ION battery
> > 	* <add any others that apply here>
> Can do this, not precisely as "st-ericsson,battery-type", it will be as
> battery-type = [unknown|NiMH|LION|...|]], reason being
> allowable battery type is based on technology, as you can see the
> possible types as:
> POWER_SUPPLY_TECHNOLOGY_UNKNOWN = 0,
>         POWER_SUPPLY_TECHNOLOGY_NiMH,
>         POWER_SUPPLY_TECHNOLOGY_LION,
>         POWER_SUPPLY_TECHNOLOGY_LIPO,
>         POWER_SUPPLY_TECHNOLOGY_LiFe,
>         POWER_SUPPLY_TECHNOLOGY_NiCd,
>         POWER_SUPPLY_TECHNOLOGY_LiMn
> Ref: include/linux/power_supply.h
> Note: doing this will impact my of_probe(...), may slightly bloat the
> code.

Ok.

If you want to make the battery type a generic property, it's probably
best to start a separate binding document for this in
Documentation/devicetree/bindings/power-supply/common.txt
and document a string for each of these.

If we expect the property to be needed only for ab8500, please use
a vendor prefix like 'stericsson,'.

	Arnd
