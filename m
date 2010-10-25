Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab0JYL0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 07:26:08 -0400
Received: from exprod5og102.obsmtp.com ([64.18.0.143]:33100 "EHLO
	exprod5og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab0JYL0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 07:26:07 -0400
Message-ID: <4CC568F6.2070207@ge.com>
Date: Mon, 25 Oct 2010 12:24:38 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.14) Gecko/20101006 Thunderbird/3.0.9
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>
Subject: Re: [PATCH 27/30] staging/vme: rework the bus model
References: <1287729412-24356-1-git-send-email-cota@braap.org> <1287729412-24356-28-git-send-email-cota@braap.org> <20101022232707.GA1370@braap.org>
In-Reply-To: <20101022232707.GA1370@braap.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Oct 2010 11:25:52.0080 (UTC) FILETIME=[61AAD500:01CB7437]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/10/10 00:27, Emilio G. Cota wrote:
> On Fri, Oct 22, 2010 at 10:26:11 +0100, Martyn Welch wrote:
>> Hi Emilio,
>>
>> Thank you for the fixes. After a quick glance, there seem to be a number
>> of valid fixes here, but I'm very concerned by the patches that change
>> the driver model. We discussed this approach in August last year, I am
>> still yet to be convinced by the approach you wish to take.
> (snip)
>> As I've said above - I am still not convinced by the change in approach.
> 
> I'd like to know what exactly doesn't convince you.
> 
> Let's re-visit the commit message:
> 
> Emilio G. Cota wrote:
>> From: Emilio G. Cota <cota@braap.org>
>>
>> The way in which VME devices and drivers are currently bound together
>> involves unnecessary contortions. Controlling a device with a VME driver
>> requires the following steps, in this order:
>>
>> - installing the VME core, eg insmod vme.ko
>> - installing the VME boards' drivers, where the devices to be controlled
>>   are passed to the VME core through the so-called bind tables.  Note that
>>   these modules are hooking stuff onto the VME core while the bridge driver
>>   that provides the bus they'll to attach hasn't yet been loaded.
>> - insmod of the VME bridge driver. 32 devices (called slots) are _always_
>>   created, and then the bus's .match method is called for each of them.
>>   This works because the boards' drivers have already hooked stuff onto
>>   the VME core (see previous step.)
>>
>> There are a few things I dislike about the above:
>>
>> * installing drivers even before the bridges they need are present
>>   seems counter-intuitive and wrong.

There are plenty of instances where a driver can be loaded before the
bus is probed or a device is even present. When the bus become
available, the probe routine will be run.

>> * a VME bus may need more than 32 devices--the relation to the 32 slots on
>>   a VME crate is artificial and confusing:

It is certainly not artificial. The VME64 spec (as approved in 1995)
defines a CR/CSR space. This is a special 24-bit address space, which is
divided in to 512KB blocks - specific offsets are assigned for Vendor
and Device IDs.

In fact, the VME64 spec also states that a rack must not have more than
21 slots. I'm sure there is hardware out there that doesn't fully comply
with the VME64 bit specs (be that because they were designed before 1995
and/or are used in some niche where adherence to the specs isn't
important), however I feel that the limit of 32 is not artificial - as
it is at the moment a probe routine can be written for a VME64 compliant
card that probes through the CR/CSR space.

>> 	* Some VME cards may be best treated in the kernel as several
>> 	  independent devices, and therefore it is pointless to limit the
>> 	  number of devices on the bus.

Write a driver for the card and layer modules above it.

>> 	* In VME jargon, a slot is a physical place where hardware is sitting,
>> 	  and is clearly out of the kernel's control. Users may thus have a
>> 	  misleading impression of 'this is what's on slot X', and then go
>> 	  to the crate and see that slot X is empty.

The VME64 spec stipulates that slots will be numbered with slot 1 on the
left incrementing up. The VME64x specification (as approved in 1998),
defines geographical addressing which allows compliant cards to
determine the physical slot in which they sit.

For drivers of non-compliant devices, this can be provided as a module
parameter by the system integrator (I have done exactly this for an
example driver for an ancient card I have developed to test the framework).

>> * .probe and .remove pass a pointer to a struct device representing a VME
>>   bridge, instead of representing the device to be added/removed.
>> 	* a bridge's module may be removed anytime and things do fall over;
>> 	  there is no refcounting at all and thus all drivers attached to
>> 	  the removed bus will oops.

Yes - this is an issue that does need to be dealt with.

>> * the so-called "bind table" is tricky, unnecessary and boring code that just
>>   duplicates what modparam's arrays do.
> 
> Do we first agree on the shortcomings mentioned above?

In summation - no I don't agree with all the above shortcomings.

> Because if we don't, then there's no point in discussing alternatives.
> 

I'm happy to discuss alternative approaches, however I don't consider a
dump of 30 patches at the start of a merge window on the LKML mailing
list, without any discussion on the appropriate sub-system mailing list
(in-fact, not even posted there) a discussion.

In these 30 patches there are quite a few improvements that I'm happy to
ack. Please re-post this series to the correct mailing list (as listed
in the maintainers file), I will ack the patches that I'm happy with and
we can discuss them there.

Martyn

-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square,
Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
