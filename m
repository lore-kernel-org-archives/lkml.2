Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934Ab1CCWDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 17:03:20 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:9711 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab1CCWDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 17:03:19 -0500
Date: Thu, 3 Mar 2011 23:02:53 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Wolfram Sang <w.sang@pengutronix.de>, Dirk Eibach <eibach@gdsys.de>,
        devicetree-discuss@lists.ozlabs.org, rdunlap@xenotime.net,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] hwmon: (ads1015) Add devicetree documentation
Message-ID: <20110303230253.0e8455c2@endymion.delvare>
In-Reply-To: <20110303172653.GB22940@angua.secretlab.ca>
References: <1299143805-13133-1-git-send-email-eibach@gdsys.de>
	<20110303115151.GF3649@pengutronix.de>
	<20110303132025.51e0d92e@endymion.delvare>
	<20110303132549.GG3649@pengutronix.de>
	<20110303172653.GB22940@angua.secretlab.ca>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Mar 2011 10:26:53 -0700, Grant Likely wrote:
> On Thu, Mar 03, 2011 at 02:25:49PM +0100, Wolfram Sang wrote:
> > OK. The thing is you can't map platform_data 1:1 to bindings, because
> > most are very specific to the Linux-driver. Do you think something like
> > "active-channels" would be sufficent for those other hwmon devices, too?
> > (I still do not like "exported-channels", because there is no need to
> > export the channels for the OS. The devicetree is primarily a hardware
> > description language) Or maybe we go specific and say "ads1015,channel1
> > = 1"? Maybe somebody knows of a similar chips as a reference?
> 
> Yes, Wolfram's correct.  The focus should be on what the connections
> actually are instead of what the OS should attempt to do with them.
> ie. give the active channels actual names for what they do, or use a
> phandle to reference them from another node.  The driver can then make
> a decision based on whether or not a channel has a configuration
> provided.
> 
> From the little information I have, I'd recommend something like:
> 
> sensor@49 {
> 	compatible = "ti,ads1015"
> 	reg = <0x49>;
> 
> 	// Each child node (one node per channel) has an address with
> 	// no range
> 	#address-cells = <1>;
> 	#size-cells = <0>;
> 
> 	adc@2 {
> 		ti,measurement = "cpu voltage";
> 		reg = <2>;
> 	};
> 
> 	adc@4 {
> 		ti,measurement = "base voltage";
> 		reg = <4>;
> 	};
> };
> 
> However, after taking a little look at the data sheet, this binding
> might end up being a little naive for what the part can do.  It might
> make more sense to do something like:
> 
> sensor@49 {
> 	compatible = "ti,ads1015"
> 	reg = <0x49>;
> 
> 	// Each child node (one node per channel) has an address with
> 	// no range
> 	#address-cells = <1>;
> 	#size-cells = <0>;
> 
> 	measurement@0 {
> 		reg = <0>;	// This reg value no longer reflects
> 				// the chip, it's just a handle for
> 				// logical measurement channels

If there any hard requirement for this? From the driver's perspective,
the multiplexer setting can be used as the channel ID, and it's easier
this way than using arbitrary identifiers.

> 		ti,measurement = "cpu voltage";
> 		ti,multiplexer = <2>; // AIN0 vs. AIN3
> 		ti,gain = <5>; // +/-0.256V
> 		ti,inverse-polarity;
> 	};
> 
> 	measurement@1 {
> 		reg = <1>;
> 		ti,measurement = "base voltage";
> 		ti,multiplexer = <4>; // AIN0 vs. GND
> 		ti,gain = <2>; // +/-2.048V
> 	};
> };
> 
> ...which splits it up by logical measurement configurations instead of
> only the multiplexer setting.

I wouldn't disagree, as I did suggest making the gain a per-channel
setting while reviewing Dirk's driver. I had not thought of labelling,
but the hwmon sysfs API supports this too, so it would fit nicely
(although it can also be handled in user-space if needed.)

> It's more verbose than a single exported-channels property, but it is
> flexible enough that it can be easily extended with extra
> configuration data per channel.

I will leave it up to Dirk to decide how much time he wants to spend on
this. He has already been very patient with the driver review process
and I do not want to abuse his patience.

-- 
Jean Delvare
