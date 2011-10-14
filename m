Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab1JNS4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 14:56:23 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63961 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab1JNS4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 14:56:20 -0400
Message-ID: <4E9885CF.1000301@gmail.com>
Date: Fri, 14 Oct 2011 11:56:15 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Alan Stern <stern@rowland.harvard.edu>, Ming Lei <tom.leiming@gmail.com>,
        Andrei Warkentin <awarkentin@vmware.com>, Greg KH <greg@kroah.com>,
        Dilan Lee <dilee@nvidia.com>, "G, Manjunath Kondaiah" <manjugk@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>, Manjunath@jasper.es,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linux PM List <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 2/5] drivercore: Add driver probe deferral mechanism
References: <CACxGe6vF6em0-PnJ7UuH0CQ0_StJTfmFKBsktvb9O+ccCx6E8A@mail.gmail.com> <Pine.LNX.4.44L0.1110141229450.2036-100000@iolanthe.rowland.org> <CACxGe6t2Xu5B0AKZJe-6HEpxK6GfuNm0Y2Kb_bs8ZwaTz5XnRg@mail.gmail.com>
In-Reply-To: <CACxGe6t2Xu5B0AKZJe-6HEpxK6GfuNm0Y2Kb_bs8ZwaTz5XnRg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2011 10:20 AM, Grant Likely wrote:
> On Fri, Oct 14, 2011 at 10:33 AM, Alan Stern<stern@rowland.harvard.edu>  wrote:
>> On Fri, 14 Oct 2011, Grant Likely wrote:
>>
>>>> How can a device acquire children before it has a driver?
>>>
>>> There are a few potential situations in embedded systems (or at least
>>> nothing currently prevents it) where platform setup code constructs a
>>> device hierarchy without the aid of device drivers, and it is still
>>> possible for a parent device to be attached to a driver.  IIUC, SPARC
>>> creates an entire hierarchy of platform_devices from all the nodes in
>>> the OpenFirmware device tree, and any of those devices can be bound to
>>> a driver.  I don't like that approach, but at the very least it needs
>>> to be guarded against.
>>
>> Do these devices ever require deferred probes?
>
> Yes, they very well might.  However, I'm happy with the limitation
> that only leaf devices can take advantage of probe deferral.
>


I have:

I2C-Bus-A
   +--Mux-I2C (controlled by parent I2C-Bus-A)
       +---I2C-Bus-1
       |      +--GPIO-Expander-A
       |
       +---I2C-Bus-2
              +--GPIO-Expander-B

These all have a parent/child relationship so no deferral is needed, so 
far so good.


Then this:

MDIO-Bus-A
    +---Mux-MDIO (controlled by GPIO-Expander-A)
          +---MDIO-Bus-1
          |
          +---MDIO-Bus-2
                +---PHY-1
                |
                +---PHY-2

In this case the driver for Mux-MDIO needs to be deferred until *both* 
MDIO-Bus-A's driver *and* GPIO-Expander-B's driver are loaded.  A 
perfect use case for the patch.

Would you consider Mux-MDIO to be a 'leaf device'?  If not, then I have 
real problems with 'the limitation that only leaf devices can take 
advantage of probe deferral'

David Daney
