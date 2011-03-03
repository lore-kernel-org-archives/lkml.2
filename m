Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594Ab1CCR06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 12:26:58 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:37840 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758523Ab1CCR05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 12:26:57 -0500
Date: Thu, 3 Mar 2011 10:26:53 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Jean Delvare <khali@linux-fr.org>, Dirk Eibach <eibach@gdsys.de>,
        devicetree-discuss@lists.ozlabs.org, rdunlap@xenotime.net,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] hwmon: (ads1015) Add devicetree documentation
Message-ID: <20110303172653.GB22940@angua.secretlab.ca>
References: <1299143805-13133-1-git-send-email-eibach@gdsys.de>
 <20110303115151.GF3649@pengutronix.de>
 <20110303132025.51e0d92e@endymion.delvare>
 <20110303132549.GG3649@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303132549.GG3649@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 02:25:49PM +0100, Wolfram Sang wrote:
> > > Hmm, device tree bindings should be OS-neutral, sysfs is not.
> > 
> > Why do we document this in the Linux kernel tree then?
> 
> To describe which bindings Linux supports.
> 
> > > with the active channels. Then again, what is the drawback of exporting
> > > all channels?
> > 
> > Performance and user-friendliness. libsensors-based applications will
> > read all available attributes by default, and each reading takes time.
> > Letting the platform declare how the inputs are used allows for a sane
> > output for "sensors" and other similar tools out of the box, without
> > the user having to tinker with ignore statements in configuration files
> > to discard the nonsensical values.
> 
> OK, that's fine I'd say.
> 
> > > Is there another hwmon-driver doing so (couldn't find one)?
> > 
> > If "doing so" means "letting the user define how the ADC inputs are
> > used", then yes, the pcf8591 driver does something similar, except that
> > it uses a module parameter for the setting, for historical reasons.
> > Platform-provided, per-device data is better in my opinion.
> 
> OK. The thing is you can't map platform_data 1:1 to bindings, because
> most are very specific to the Linux-driver. Do you think something like
> "active-channels" would be sufficent for those other hwmon devices, too?
> (I still do not like "exported-channels", because there is no need to
> export the channels for the OS. The devicetree is primarily a hardware
> description language) Or maybe we go specific and say "ads1015,channel1
> = 1"? Maybe somebody knows of a similar chips as a reference?

Yes, Wolfram's correct.  The focus should be on what the connections
actually are instead of what the OS should attempt to do with them.
ie. give the active channels actual names for what they do, or use a
phandle to reference them from another node.  The driver can then make
a decision based on whether or not a channel has a configuration
provided.

>From the little information I have, I'd recommend something like:

sensor@49 {
	compatible = "ti,ads1015"
	reg = <0x49>;

	// Each child node (one node per channel) has an address with
	// no range
	#address-cells = <1>;
	#size-cells = <0>;

	adc@2 {
		ti,measurement = "cpu voltage";
		reg = <2>;
	};

	adc@4 {
		ti,measurement = "base voltage";
		reg = <4>;
	};
};

However, after taking a little look at the data sheet, this binding
might end up being a little naive for what the part can do.  It might
make more sense to do something like:

sensor@49 {
	compatible = "ti,ads1015"
	reg = <0x49>;

	// Each child node (one node per channel) has an address with
	// no range
	#address-cells = <1>;
	#size-cells = <0>;

	measurement@0 {
		reg = <0>;	// This reg value no longer reflects
				// the chip, it's just a handle for
				// logical measurement channels
		ti,measurement = "cpu voltage";
		ti,multiplexer = <2>; // AIN0 vs. AIN3
		ti,gain = <5>; // +/-0.256V
		ti,inverse-polarity;
	};

	measurement@1 {
		reg = <1>;
		ti,measurement = "base voltage";
		ti,multiplexer = <4>; // AIN0 vs. GND
		ti,gain = <2>; // +/-2.048V
	};
};

...which splits it up by logical measurement configurations instead of
only the multiplexer setting.

It's more verbose than a single exported-channels property, but it is
flexible enough that it can be easily extended with extra
configuration data per channel.

g.
