Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692Ab1HHLGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 07:06:44 -0400
Received: from exprod5og111.obsmtp.com ([64.18.0.22]:43489 "EHLO
	exprod5og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab1HHLGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 07:06:42 -0400
Message-ID: <4E3FC33D.2080202@ge.com>
Date: Mon, 08 Aug 2011 12:06:37 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] staging: vme: add functions for bridge module refcounting
References: <20110803152317.GA21903@flamenco.cs.columbia.edu> <4E3A4904.3040007@ge.com> <20110804163451.GA18422@flamenco.cs.columbia.edu> <4E3B9FA2.3060303@ge.com> <20110805090416.GA4806@becoht-mvanga> <4E3BB6E7.6020809@ge.com> <20110805174728.GA1741@flamenco.cs.columbia.edu> <4E3F97EA.2020600@ge.com> <20110808091432.GA19570@flamenco.cs.columbia.edu> <4E3FABDA.8080204@ge.com> <20110808101140.GA21300@flamenco.cs.columbia.edu>
In-Reply-To: <20110808101140.GA21300@flamenco.cs.columbia.edu>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Aug 2011 11:03:23.0596 (UTC) FILETIME=[CA76C0C0:01CC55BA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/11 11:11, Emilio G. Cota wrote:
> On Mon, Aug 08, 2011 at 10:26:50 +0100, Martyn Welch wrote:
>> On 08/08/11 10:14, Emilio G. Cota wrote:
>>> Martyn, no one in the kernel is doing what you propose, for
>>> good reason. Look at USB, PCI, RapidIO.  They all provide get
>>> and put functions to be called from probe and release.
>>
>> Really, which functions are these for PCI?
> 
> pci_get_dev/put in drivers/pci/pci-driver.c.
> 

Which isn't explicitly used by the vast majority of PCI drivers. In fact the
instances which I did find where this was used by a PCI device driver, it
appears to be using the old-style PCI probing.

This is taken care of automatically for drivers using the "newer" PCI driver
registration model as part of the probe.

>>> Doing otherwise is a bug. If a driver needs a resource *not
>>> necessarily at .probe time*, it increments the refcount
>>> then (in .probe) to make sure that the parent driver won't
>>> be removed. IOW if you increase the refcount in the bridge
>>> driver only when a resource is requested you're doomed,
>>> because when the non-probe request arrives, the bridge driver
>>> may have been removed already.. And the kernel gently reminds
>>> you of this fact in the form of an oops.
>>
>> The probe is going to need to request the resources to access the hardware it
>> is designed to control. Hence it will be incrementing the refcount exactly
>> when it needs to.
> 
> We cannot presume (impose) what all VME drivers will do; that's
> up to them. Imagine for instance I want to write a driver that
> allows me to operate on the location monitors, all orchestrated
> via sysfs.  Probe would be almost empty, resources would come
> and go at a later time.

You'd need to request the location monitor to use it. If you didn't request it
at probe time, then removed the bridge, when you went to request the resource
at run time it would fail. It would be up to your driver to deal with that
gracefully.

> If the bridge driver is removed when
> I haven't registered any location monitors, I'll get an oops
> when I try to register a block of them. Not pretty.

No, your driver will be told the resource isn't available by vme_lm_request(),
it would return null. It would then be up to you as the driver writer to
handle that gracefully. In fact, just as you'd have to do if the location
monitor was already being used by a different VME device driver which had
positioned them where it needed them.

> Remember that we're writing a bus driver here, we shouldn't
> get on the way of the drivers for the devices on the bus, no
> matter how crazy they are.

Actually we're providing resource management and a bridge independent VME API
for VME device drivers as part of a bus specific core, much as USB and PCI do.
The VME bridge drivers bind under it, the VME device drivers bind on top of it.

Crazy probably equates to not portable across different VME bridges, so no I
don't agree. I'm in favour of providing as much flexibility to VME device
driver authors as possible, without impacting the flexibility of the user to
use the drivers on top of different VME bridges.

> IMHO in order to make sure we're on
> the right track we must look at other bus drivers. And these
> other drivers just keep things simple and stupid, which is
> flexible, safe and "Obviously Correct(tm)".

Though I don't think the approach you are advocating is simple for the VME
device driver writer (new style PCI drivers don't as a rule directly manage
refcounting, in the same way your approach would add complexity for the
individual VME device drivers); it's not safe (I deem it unsafe to expect
every VME device driver writer to manage the refcounting in their drivers
explicitly, just as it appears is the case for PCI devices) and as a result
not "Obviously Correct(tm)".

Martyn

-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)127322748                          | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
