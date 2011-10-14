Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab1JNTDw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 15:03:52 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64342 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab1JNTDs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 15:03:48 -0400
MIME-Version: 1.0
In-Reply-To: <4E9885CF.1000301@gmail.com>
References: <CACxGe6vF6em0-PnJ7UuH0CQ0_StJTfmFKBsktvb9O+ccCx6E8A@mail.gmail.com>
 <Pine.LNX.4.44L0.1110141229450.2036-100000@iolanthe.rowland.org>
 <CACxGe6t2Xu5B0AKZJe-6HEpxK6GfuNm0Y2Kb_bs8ZwaTz5XnRg@mail.gmail.com> <4E9885CF.1000301@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 14 Oct 2011 13:03:27 -0600
X-Google-Sender-Auth: ZpPipwMabILt2EwORLPG0zGaZ3g
Message-ID: <CACxGe6v=NuxX3b=7wG6hMZjO22_zEg3Q4LtjT3UPtv2bKFtjWQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] drivercore: Add driver probe deferral mechanism
To: David Daney <ddaney.cavm@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Ming Lei <tom.leiming@gmail.com>,
        Andrei Warkentin <awarkentin@vmware.com>, Greg KH <greg@kroah.com>,
        Dilan Lee <dilee@nvidia.com>, "G, Manjunath Kondaiah" <manjugk@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>, Manjunath@jasper.es,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linux PM List <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 12:56 PM, David Daney <ddaney.cavm@gmail.com> wrote:
> On 10/14/2011 10:20 AM, Grant Likely wrote:
>>
>> On Fri, Oct 14, 2011 at 10:33 AM, Alan Stern<stern@rowland.harvard.edu>
>>  wrote:
>>>
>>> On Fri, 14 Oct 2011, Grant Likely wrote:
>>>
>>>>> How can a device acquire children before it has a driver?
>>>>
>>>> There are a few potential situations in embedded systems (or at least
>>>> nothing currently prevents it) where platform setup code constructs a
>>>> device hierarchy without the aid of device drivers, and it is still
>>>> possible for a parent device to be attached to a driver.  IIUC, SPARC
>>>> creates an entire hierarchy of platform_devices from all the nodes in
>>>> the OpenFirmware device tree, and any of those devices can be bound to
>>>> a driver.  I don't like that approach, but at the very least it needs
>>>> to be guarded against.
>>>
>>> Do these devices ever require deferred probes?
>>
>> Yes, they very well might.  However, I'm happy with the limitation
>> that only leaf devices can take advantage of probe deferral.
>>
>
>
> I have:
>
> I2C-Bus-A
>  +--Mux-I2C (controlled by parent I2C-Bus-A)
>      +---I2C-Bus-1
>      |      +--GPIO-Expander-A
>      |
>      +---I2C-Bus-2
>             +--GPIO-Expander-B
>
> These all have a parent/child relationship so no deferral is needed, so far
> so good.
>
>
> Then this:
>
> MDIO-Bus-A
>   +---Mux-MDIO (controlled by GPIO-Expander-A)
>         +---MDIO-Bus-1
>         |
>         +---MDIO-Bus-2
>               +---PHY-1
>               |
>               +---PHY-2
>
> In this case the driver for Mux-MDIO needs to be deferred until *both*
> MDIO-Bus-A's driver *and* GPIO-Expander-B's driver are loaded.  A perfect
> use case for the patch.
>
> Would you consider Mux-MDIO to be a 'leaf device'?  If not, then I have real
> problems with 'the limitation that only leaf devices can take advantage of
> probe deferral'

leaf device **at the time of its driver probe**.  :-)  After the
device has all of its dependencies met, it can freely add child
devices.  In your case, the child devices will get added by the
Mux-MDIO device driver, so all is good.

g.
