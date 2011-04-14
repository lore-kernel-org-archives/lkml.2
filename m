Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab1DNNG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 09:06:57 -0400
Received: from mail.academy.zt.ua ([82.207.120.245]:25498 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758438Ab1DNNGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 09:06:55 -0400
X-MDAV-Processed: mail.academy.zt.ua, Thu, 14 Apr 2011 16:06:56 +0300
X-Spam-Processed: mail.academy.zt.ua, Thu, 14 Apr 2011 16:06:54 +0300
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: george@academy.zt.ua
X-Return-Path: george@znau.edu.ua
X-Envelope-From: george@znau.edu.ua
Subject: Re: Could I (ab)use bus (struct bus_type) for virtual Broadcom bus?
From: George Kashperko <george@znau.edu.ua>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arend van Spriel <arend@broadcom.com>,
        Jonas Gorski <jonas.gorski@gmail.com>,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        b43-dev@lists.infradead.org, Greg KH <greg@kroah.com>,
        Andy Botting <andy@andybotting.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <BANLkTinvpt5vs+rXd3WN-a2JpGtTV+=Gyg@mail.gmail.com>
References: <BANLkTim7Uj2tsgFngWhUqFK_hk3Leg+sQA@mail.gmail.com>
	 <1302781431.21145.6.camel@dev.znau.edu.ua>
	 <BANLkTinvpt5vs+rXd3WN-a2JpGtTV+=Gyg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Thu, 14 Apr 2011 16:03:37 +0300
Message-Id: <1302786217.21965.49.camel@dev.znau.edu.ua>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-19.el5) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> W dniu 14 kwietnia 2011 13:43 użytkownik George Kashperko
> <george@znau.edu.ua> napisał:
> >> We have slightly improved our knowledge of new Broadcom's bus. It
> >> appears Broadcom took standard AMBA bus and put on it two cores for
> >> every device:
> >> 1) First core from each pair is real AMBA device, it has CID and PID.
> >> Broadcom called it wrapper, it is used to control second core
> >> (enabling second, disabling second, resetting second, setting flags of
> >> second).
> >> 2) Second core from each pair is Broadcom specific device. It can
> >> *not* be treated as standard AMBA core - attempting to read it's CID
> >> on PID leads to machine hang. Instead it is identified by MANUF, ID,
> >> REV and CLASS. Example can be 80211 core.
> >>
> >> One of the idea is to integrate with current AMBA driver:
> >> 1) First driver read info about all cores in Broadcom specific way. It
> >> registers all *wrapper* (AMBA type) cores as amba_device(s).
> >> 2) Second driver registers for cores with PID 0x103BB369 (Broadcom
> >> specific I believe). It receives wrappers (from AMBA bus) and exposes
> >> wrapper-related Broadcom specific core in the system.
> >>
> >> Problem: how to expose Broadcom specific cores in the system? Remember
> >> we can not use amba_device, because Broadcom specific cores are
> >> programmed and identified differently.
> >>
> >> Could we register some virtual bcm_amba bus in the system and register
> >> Broadcom specific cores with it? Or is there something better for this
> >> case? In summary everything I need is to make driver (for example b43)
> >> able to register for Broadcom specific core with Broadcom specific
> >> identifiers. For example:
> >> static const struct axi_device_id b43_axi_tbl[] = {
> >>       AXI_CORE(AXI_MANUF_BCM, AXI_CORE_80211, 0x17, AXI_ANY_CLASS),
> >>       AXI_CORETABLE_END
> >> };
> >> MODULE_DEVICE_TABLE(axi, b43_axi_tbl);
> >>
> >> We have problems deciding architecture, the whole proposed layout is
> >> not approved as final yet. Right now I try to check possibilities.
> >>
> > If you beleive you do need to register broadcom ip core devices on amba
> > bus then I would suggest you to introduce class driver for broadcom
> > cores rather than breaking into bus_type layout. But to be honest I
> > think it is bad idea and your original approach where you managed agents
> > internally and registered _broadcom_ devices on dedicated _broadcom_ bus
> > have much more sense. Going your original way you still can also
> > register agents on amba thus registering two buses per host but honestly
> > registering them just for the sake of registering makes no sense at all.
> 
> I think you may be right, but we got so messed with so many ideas we
> need to clean this out. Our old ideas:
> 1) Extending ssb
> 2) Separated library (brcmaxi)
> 3) Broadcom specific bus (bcmai)
> 4) AMBA AXI bus (axi)
> 5) Integrating with drivers/amba
First of all, think its obvious we have to implement dedicated broadcom
bus for specific broadcom devices management. Yes, the fact is,
old-style broadcom devices used Sonics SiliconBackplane interconnects,
new-line ones are based on amba axi, but both of them are industrial
buses 99,9% of which specs are electrical and about 0,1% refer to some
programmers' model. You could plan for amba or some other industrial bus
interface use by implementing enable/disable/reset/state/control as ops,
but at this point I suggest to manage agents internally by your
broadcom-specific bus driver code.

As for layout I've reviwed my original intent on bus model several days
ago after finally rewieved my latest ssb-related .pdf's findings,
Broadcom GPL sources for android, number of 2.4- and 2.6-based
ASUS/Buffalo/Dlink/Linksys/Netgear/Siemens/USRobotics/HewlettPackard/Belkin embeddables' firmwares.

Finally I see it as host->bridge->interconnect->ip_core->device where:
* host and bridge are implemented and managed by host device driver (e.
g. pci device driver managing all device pci functions or e. g. mips/arm
embeddable host);
* interconnect layer is managed by dedicated type handlers abstracted by
functional tables (providing scanning and agent management services);
* cores and their devices are managed by the bus core code regardless of
the host device type and underlying interconnect implementation.

In this way we will separate cows from horses and won't need inventing
some other bus driver when decide to support same broadcom buses over e.
g. usb.

* host driver manages bus lifetime, host-specific workarounds, provide
interconnect ports' accesses via 1+ bridges;
* interconnect handler (it could become driver at some point if/when
amba will evolve to not only platform-like embeddable bus) provides bus
enumeration and agent management;
* bus driver itself manages cooperation of upstream host/bridges with
underlying interconnect handler feeding the system with actual
buscommon/buscore/configuration/port devices.

As for devices here, classifying them to specific types
(buscommon/buscore/configuration/port/platform) will finally
differentiate pci bridge cores from host ones, will let to have
sprom/otp/flash configuration containers managed by dedicated drivers,
cleans support for non-chipcommon buscommons, buscommon-less or
chipcommon-as-buscore interconnects and more.

I see rather beneficial managing both buscommon and buscore separately
from host driver. You already "detouched" chipcommon from the bus core
code, the same way buscore can (and should I beleive) be separate
driver. The only thing here you seems to miss in your code is that
chipcommon devices (and buscore as well if only you decide to have it as
separate driver as well) are "special" and you must manage their
lifetimes to
1. ensure it's driver is loaded and initialized prior any other device
on the bus;
2. should not be unloaded until any other bus device have driver bound
to the bus;

> 
> I simply decide to consider every idea seriously and decide which will
> fit our needs the best way.
> 
> Hauke: you were proposing integrating with drivers/amba. I really
> expect you to comment on this, please tell us how do you see this now,
> when we have better overview. I took your proposal seriously, you can
> see the results above.
> 
> I think I agree with George that in proposed architecture we are using
> drivers/amba just for the idea of using it. We don't get anything from
> it, we don't provide anything to it that could be used anywhere else.
> I think we should simply take the last version of my patch, rename it
> to bcmamba, fix last issues and commit. It looks we use almos nothing
> AMBA specific in your driver.
> 
> But as I said, I treat every proposal seriously. So please share your
> minds Hauke & others.
> 

Have nice day,
George


