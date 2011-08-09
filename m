Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab1HIJAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 05:00:17 -0400
Received: from exprod5og107.obsmtp.com ([64.18.0.184]:39373 "EHLO
	exprod5og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab1HIJAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 05:00:14 -0400
Message-ID: <4E40F719.1020100@ge.com>
Date: Tue, 09 Aug 2011 10:00:09 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] staging: vme: add functions for bridge module refcounting
References: <20110804163451.GA18422@flamenco.cs.columbia.edu> <4E3B9FA2.3060303@ge.com> <20110805090416.GA4806@becoht-mvanga> <4E3BB6E7.6020809@ge.com> <20110805174728.GA1741@flamenco.cs.columbia.edu> <4E3F97EA.2020600@ge.com> <20110808091432.GA19570@flamenco.cs.columbia.edu> <4E3FABDA.8080204@ge.com> <20110808101140.GA21300@flamenco.cs.columbia.edu> <4E3FC33D.2080202@ge.com> <20110808172216.GA2311@flamenco.cs.columbia.edu>
In-Reply-To: <20110808172216.GA2311@flamenco.cs.columbia.edu>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Aug 2011 08:56:52.0968 (UTC) FILETIME=[48829680:01CC5672]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/11 18:22, Emilio G. Cota wrote:
> On Mon, Aug 08, 2011 at 12:06:37 +0100, Martyn Welch wrote:
>> On 08/08/11 11:11, Emilio G. Cota wrote:
>>> On Mon, Aug 08, 2011 at 10:26:50 +0100, Martyn Welch wrote:
>>>> On 08/08/11 10:14, Emilio G. Cota wrote:
>>>>> Martyn, no one in the kernel is doing what you propose, for
>>>>> good reason. Look at USB, PCI, RapidIO.  They all provide get
>>>>> and put functions to be called from probe and release.
>>>>
>>>> Really, which functions are these for PCI?
>>>
>>> pci_get_dev/put in drivers/pci/pci-driver.c.
>>>
>>
>> Which isn't explicitly used by the vast majority of PCI drivers. In fact the
>> instances which I did find where this was used by a PCI device driver, it
>> appears to be using the old-style PCI probing.
> 
>> This is taken care of automatically for drivers using the "newer" PCI driver
>> registration model as part of the probe.
> 
> And I don't care. The new model is not doing that nor what you suggest
> anyway, AFAIK it's not incrementing any refcounts for devices--perhaps
> because it cannot be built as a module? I dunno.
> 
> Look at other subsystems that usually sit under PCI, like USB
> or RapidIO.
> 

Just did.

RapidIO, defines rio_dev_put() in rio-driver.c, used in the rio_device_probe
function, so handled much like it is in PCI. Can't see any explicit
refcounting in the rionet driver.

USB, interestingly here the functions are defined as usb_get_dev() and
usb_put_dev() (not usb_dev_get() and usb_dev_put()). Here the situation is a
little different, the refcounting is more explicit, I assume because of the
hotplug and/or hierarchical nature of the USB bus (maybe Greg would be kind
enough to explain the rationale?)

So, out of the 3 bus types you have used to demonstrate that refcounts should
always be handled explicitly, 2 of the 3 (at least to me) appear to implicitly
handling refcounting.

>> No, your driver will be told the resource isn't available by vme_lm_request(),
>> it would return null. It would then be up to you as the driver writer to
>> handle that gracefully. In fact, just as you'd have to do if the location
>> monitor was already being used by a different VME device driver which had
>> positioned them where it needed them.
> 
> Ok, we may not oops, but this is unnecessary pain for the driver--and
> probably not what the driver wanted.
> 

The location monitor is a single, (location) configurable resource. If it's
being used for one purpose in one location by a driver, it can't be
repositioned and used for another purpose by another driver without adversely
affecting the operation of the first.

>>> Remember that we're writing a bus driver here, we shouldn't
>>> get on the way of the drivers for the devices on the bus, no
>>> matter how crazy they are.
>>
>> Actually we're providing resource management and a bridge independent VME API
>> for VME device drivers as part of a bus specific core, much as USB and PCI do.
>> The VME bridge drivers bind under it, the VME device drivers bind on top of it.
>>
>> Crazy probably equates to not portable across different VME bridges
> 
> ?? Crazy means crazy. ftrace is crazy, linux-rt is crazy. And
> they're great.
> 

I'm sure they are great, not sure I'd describe them as crazy though.

>> , so no I don't agree. I'm in favour of providing as much flexibility to VME device
>> driver authors as possible, without impacting the flexibility of the user to
>> use the drivers on top of different VME bridges.
> 
> This is nonsense.
> 
>>> IMHO in order to make sure we're on
>>> the right track we must look at other bus drivers. And these
>>> other drivers just keep things simple and stupid, which is
>>> flexible, safe and "Obviously Correct(tm)".
>>
>> Though I don't think the approach you are advocating is simple for the VME
>> device driver writer (new style PCI drivers don't as a rule directly manage
>> refcounting, in the same way your approach would add complexity for the
>> individual VME device drivers); it's not safe (I deem it unsafe to expect
>> every VME device driver writer to manage the refcounting in their drivers
>> explicitly, just as it appears is the case for PCI devices) and as a result
>> not "Obviously Correct(tm)".
> 
> By your definition there are lots of drivers in the kernel
> that are unsafe..
> 

It appears to me that both PCI and RapidIO (both buses that you have tried to
use to defend your position) don't seem to me to by-and-large expect drivers
to explicitly manage refcounting. That leaves USB, which I'd argue is a very
different bus to VME.

> I'm tired of your non-arguments. I'm just trying to persuade you
> to do what everyone else is doing, with technical reasons. To me
> (and to everybody else in this list, I'd imagine) refcounting
> should be explicit. You're going against what I perceive are
> well-established pratices in the kernel. I can't understand it.

Which I have yet to see you convincingly backup. I see a large amount of bluff
about oppses and how buses apparently deal with refcounting. I also know I
have had a number of commits to the VME code by a number of others (which is a
matter of public record, you can look at the commits in git) that haven't
complained about how the bus code is structured.

You have proposed a completely different structure. Manohar has proposed some
changes and I am trying to work with him to find a solution that satisfies
both of us. I'm not going to make any claims about others views, simply
because as they haven't aired them, I don't currently actually know what they are.

Martyn

-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)127322748                          | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
