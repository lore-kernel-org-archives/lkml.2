Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab2HILmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 07:42:54 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38518 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753417Ab2HILmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 07:42:53 -0400
Date: Thu, 9 Aug 2012 13:42:42 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2] usb: gadget: composite: parse dt values
Message-ID: <20120809114242.GA4689@breakpoint.cc>
References: <1343135720-26559-1-git-send-email-aletes.xgr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343135720-26559-1-git-send-email-aletes.xgr@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 10:15:20AM -0300, Alexandre Pereira da Silva wrote:
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/usb/gadget.txt
> @@ -0,0 +1,20 @@
> +Usb Gadget DeviceTree bindings
> +
> +These optional properties inside the usb device controller node are used to
> +change some of the gadget drivers configuration:
> +- vendor-id: Usb vendor id
> +- product-id: Usb product id
> +- release: Version of this device
> +- vendor: Textual description of the vendor
> +- device: Textual description of this device
> +- serial: Textual representation of the device's serial number
> +
> +Binding Example:
> +	usbd@31020000 {
> +		vendor-id = <0x0525>;
> +		product-id = <0xa4a6>;
> +		release = <1>;
> +		vendor = "Some Corp";
> +		device = "Test Device";
> +		serial = "12345";
> +	};

No, I don't think that this is correct. You put this bindings at device level
and map those values directly to the composite layer for each gadget. You _can_
have multiple gadgets compiled and you may want to have load them depending
on your mood and here you force a special serial or vendor-id for each one of
them. If I take a look on N800 which I have here, I see that the vendor-id
changes if I switch from mass storage to modem. How do you want to make this
possible with device tree? Ah I leave this empty. I see.

Further more, you model this binding according to what the composite framework
is doing today instead of what the hardware should look like. Putting the 
current composite limitations aside the complete UDC node for the driver could 
look something like this:

|	usbd@31020000 {
|		compatible = "nxp,lpc3220-udc";
|		reg = <0x31020000 0x300>;
|		interrupts = <0x3d 0>, <0x3e 0>, <0x3c 0>, <0x3a 0>;
|		status = "disabled";
now  this 1:1 copy, nothing new.

|
|		gadget@0 {
The first gadget we want.

|			vendor-id = <0x0525>;
|			product-id = <0xa4a6>;
|			release = <1>;
|			vendor = "Some Corp";
|			device = "Test Device";
|			serial = "12345";

with some presets here

|			config@0 {
|				max_current = <900>;
|
|				function@0 {
|					compatible = "storage,uas";
|				};
|				function@1 {
|					compatible = "network,ncm";
|				};

Two gadgets here. We may could add extra string descriptors here but I would
have check if this makes sense.

|			};
|			config@1 {
|				max_current = <300>;
|
|				function@0 {
|					compatible = "network,ncm";
|				};

Another config if we don't have enough current, just go for the network and
let the storage off.

|			};
|		}
|
|		gadget@1 {
|			vendor-id = <0x0325>;
|			product-id = <0xa3a1>;
|			release = <1>;
|			vendor = "Some Corp";
|			device = "Test Device";
|			serial = "1234511";
|			
|			config@0 {
|				max_current = <900>;
|
|				function@0 {
|					compatible = "serial,cdc-acm";
|				};

a complete different gadget.

|			};
|		}
|	};

So _this_ binding would add two gadgets to your UDC and take, lets say, the
first one as the default one. And *then* you could depending on your mood switch
between network + storage gadget and modem gadget. Now how does this sound?

I understand that this is not yet possible with current gadget framework. If I
allow you to merge this it will make the rework more hard and painfull than it
already will be.

Based on this, I have to say, sorry, no, NAK.

Sebastian
