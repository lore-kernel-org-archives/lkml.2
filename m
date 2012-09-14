Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab2INCHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 22:07:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33568 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab2INCHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 22:07:05 -0400
Date: Thu, 13 Sep 2012 19:04:27 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Rajanikanth HV <rajanikanth.hv@stericsson.com>,
        Rajanikanth HV <rajanikanth.hv@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: Implement devicetree support for AB8500 Btemp
Message-ID: <20120914020427.GA30729@lizard>
References: <CAB4BAktQz5MY_AHHWUAhRp7HtEzC3v8uFbP0enx1b7ibJLoZ4Q@mail.gmail.com>
 <201209121536.56346.arnd@arndb.de>
 <5051E02B.5040703@stericsson.com>
 <201209131437.38666.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201209131437.38666.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Thanks for Cc'ing me.)

On Thu, Sep 13, 2012 at 02:37:38PM +0000, Arnd Bergmann wrote:
[...]
> > > If this is true, I don't understand what makes the 'supplied-to'
> > > properties you list in the device tree binding board specific. Are
> > > they not always done the same way? If so, you could just leave them
> > > out.
> > Precisely 'supplied-to' is not board specific, it was maintained as
> > platform_data which i migrated to dt-node. It is meant to establish
> > dependency across bm drivers based on power_supply property and
> > runtime battery attributes.
> > Basically, 'supplied-to' provides a way of exporting change in
> > power_supply_property and runtime batter characteristics so that other
> > bm devs shall make use or refer the updated values.
> > Ref: external_power_changed(...) call back api.
> > Note: all the bm drivers handles subset of power_supply property and
> >       battery attributes,
> >       ref: include/linux/power_supply.h and get_property(...) call back
> >       api across bm drivers.
> 
> Ok, so you want to just remove the property from the device tree,
> or do you want to establish a different method to specify these
> connections?

Power supply subsystem's supplied_to describes not just how driver
should notify other devices, supplied_to is more generic stuff, in terms
that it describes power supply hierarchy. It's like a directed graph,
e.g.:

      <AC power> supplied_to <main battery> and <backup battery>
     <USB power> supplied_to <main battery> and <backup battery>
  <main battery> supplied_to <system>
<backup battery> supplied_to <system>
  <cmos battery> supplied_to <southbridge pci device>
  <mice battery> supplied_to <mice wireless hid>

How things interact in linux are just implementations details.
So, device tree is surely a perfect place to describe these things.

Although, in current bindings I see this:

+       ab8500-fg {
+               /* Other enery management module */
+               supplied_to = "ab8500_chargalg", "ab8500_usb";
+               num_supplicants = <2>;
+       };

Instead of addressing supplicants by name, it's better to address
via phandles. And, of course, num_supplicants is not needed, it can
be derived.

[...]
> > > possible batteries and require a property such as
> > > 
> > >  st-ericsson,battery-type: A string identifier for the type of battery,
> > > 			   which impacts how an operating system interpret
> > > 			   the sensor readings. Possible values include:
> > > 	* "none"	-- no battery connected
> > > 	* "li-ion-9100" -- Type 9100 Li-ION battery
> > > 	* <add any others that apply here>
> > Can do this, not precisely as "st-ericsson,battery-type", it will be as
> > battery-type = [unknown|NiMH|LION|...|]], reason being
> > allowable battery type is based on technology, as you can see the
> > possible types as:
> > POWER_SUPPLY_TECHNOLOGY_UNKNOWN = 0,
> >         POWER_SUPPLY_TECHNOLOGY_NiMH,
> >         POWER_SUPPLY_TECHNOLOGY_LION,
> >         POWER_SUPPLY_TECHNOLOGY_LIPO,
> >         POWER_SUPPLY_TECHNOLOGY_LiFe,
> >         POWER_SUPPLY_TECHNOLOGY_NiCd,
> >         POWER_SUPPLY_TECHNOLOGY_LiMn
> > Ref: include/linux/power_supply.h
> > Note: doing this will impact my of_probe(...), may slightly bloat the
> > code.
> 
> Ok.
> 
> If you want to make the battery type a generic property, it's probably
> best to start a separate binding document for this in
> Documentation/devicetree/bindings/power-supply/common.txt
> and document a string for each of these.

Fully agree. We need to document generic DT bindings for power supplies.

Thanks,
Anton.
