Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760338Ab2KBMdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 08:33:01 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:55006 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750773Ab2KBMc7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 08:32:59 -0400
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=iso-8859-1
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20121102112104.4657fb7b@pyramind.ukuu.org.uk>
Date: Fri, 2 Nov 2012 14:32:51 +0200
Cc: Russ Dill <Russ.Dill@ti.com>, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        linux-omap@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Paul Walmsley <paul@pwsan.com>, devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <0EC43413-1DD7-4E2A-879B-0B5B926FFDFE@antoniou-consulting.com>
References: <50924DA3.1060901@ti.com> <F49CA12D-4DAC-4293-AD4D-FC7EDCEA6993@antoniou-consulting.com> <20121101110418.GF410@arwen.pp.htv.fi> <3AF5A6FC-61D9-40CA-85B3-81C2C788CB76@antoniou-consulting.com> <20121101124025.GA12489@arwen.pp.htv.fi> <A16B0ABF-AB9D-4F48-88BD-96F123FFEF2F@antoniou-consulting.com> <20121101131609.GC12489@arwen.pp.htv.fi> <E911D0B7-0397-4ED0-828E-71F9531E84E0@antoniou-consulting.com> <20121101135148.382aec00@pyramind.ukuu.org.uk> <9F25E89E-9194-4725-8A8C-053DCBADA1DB@antoniou-consulting.com> <20121101220518.GE14982@arwen.pp.htv.fi> <CA+Bv8XbAvEXe=zDaA8W2+ROD2duYMRcJu4-bms31OH=V_ScKow@mail.gmail.com> <20121102112104.4657fb7b@pyramind.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Nov 2, 2012, at 1:21 PM, Alan Cox wrote:

>>>> Fair enough. But there's no such thing a 'hotplug enumeration
>>>> construct' in Linux yet, and a bus is the closest thing to it. It does
>>>> take advantage of the nice way device code matches drivers and devices
>>>> though.
> 
> A bus is the wrong construct. You need something to add devices onto the
> busses. You can do that. The Intel SFI layer on phones for example
> enumerates devices through a firmware table set and creates them on the
> right actual physical bus not on their own fake one.
> 
> It's not hotplug in the sense that the phone happens be a fixed
> configuration but it does support hotplug behaviour because the order of
> the drivers and enumeration is undefined (and both orders work).

I see. The firmware table format is similar to our case where we use DT.
We don't have to come up with another firmware table format, like SFI here.
The problem is that we have to inject DT fragments to the kernel's runtime
device tree, at some arbitrary point in time, after the cape probing is complete.
Not only that, the DT fragment for each device is not self contained; it contains
references to other nodes which have to be resolved in runtime.

Let me demonstrate what the problem is - take for example the very simple
example of a (non-versioned) cape, with a single I2C device.

------8<-----------8<--------------
Kernel's boot DT:

i2c2: i2c@4819c000 {
        compatible = "ti,omap4-i2c";
        #address-cells = <1>;
        #size-cells = <0>;
        ti,hwmods = "i2c3";     /* TODO: Fix hwmod */
        reg = <0x4819c000 0x1000>;
        interrupt-parent = <&intc>;
        interrupts = <30>;

        status = "on-demand";	/* there's no on-demand status property defined yet */
				/* means that it will be set to "okay" when a i2c   */
				/* device node turn it to "okay"                    */
				/* we can't enable it at boot because of possible   */
				/* conflicts with other peripherals                 */ 
        pinctrl-names = "default";
        pinctrl-0 = <&i2c2_pins>;

        clock-frequency = <100000>;

};
------8<-----------8<--------------

A cape DT fragment (probable syntax) :

i2c2-devices {
	parent = <&i2c2>;

        /* Ambient light sensor */
         tsl2550@39 {
         	compatible = "tsl,tsl2550";
                reg = <0x39>;
        };      
};

------8<-----------8<--------------

The i2c2 alias cannot be resolved at compile time; there has to be

a) A DT object format where unresolved aliases (symbols) are tracked
b) A runtime DT linker that will resolve the alias, and will insert the
   i2c2-devices child nodes as children in the i2c2 node.
c) A method to trigger platform device creation for the child nodes just
   inserted.

DT core changes aren't bound to be easily accepted, so without having a clear
signal from the DT maintainers that they would consider such a method people
are just hesitant to go down this road.


> 
>>>> 
>>>> I'm afraid that having the I2C/SPI drivers doing the detection won't
>>>> work.  The capes can have arbitrary I2C/SPI devices (and even more
>>>> weird components).  There is no way to assure for example that the I2C
>>>> device responding to address 'foo' in cape A is the same I2C device
>>>> responding to the same address in cape B.
>>> 
>>> your ->detect() method should take care of that.
>> 
>> There isn't some magical serial number in I²C devices that a
>> ->detect() method can read and the implementation of I²C is somewhat
> 
> It doesn't matter.
> 
> What you are basically talking about is
> 
> 
> 	cape layer
> 		- wtf is this
> 		- how do I plumb it
> 
> 		- create device nodes with correct name for
> 		  binding, address etc on the right bus
> 
> 
> 	i2c layer
> 		- ooh a new i2c device
> 		- probe as indicated by device name
> 		- attach correct driver
> 
> 
> Architecturally its possible you want to make some caps MFDs if they have
> their own bus heirarchies etc but generally I doubt it.
> 
> 
> Take a look at arch/x86/platform/mrst/mrst.c. It's a specific example of
> a platform which parses tables and attaches devices to the right physical
> bus in a manner they can be reliably probed even when the device has no
> sane autodetect.
> 
> Alan

Regards

-- Pantelis

