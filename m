Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab2EKIXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 04:23:39 -0400
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:52484 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751224Ab2EKIXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 04:23:30 -0400
Message-ID: <4FACCC79.5000805@ti.com>
Date: Fri, 11 May 2012 13:53:21 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Colin Cross <ccross@android.com>, Kevin Hilman <khilman@ti.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [RFC][PATCH 2/2] PM / Domains: Add preliminary cpuidle support
References: <201205092340.26561.rjw@sisk.pl> <201205092343.11050.rjw@sisk.pl> <4FAB9412.5030102@ti.com> <201205102041.42473.rjw@sisk.pl>
In-Reply-To: <201205102041.42473.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 May 2012 12:11 AM, Rafael J. Wysocki wrote:
> On Thursday, May 10, 2012, Santosh Shilimkar wrote:
>> Rafael,
>>
>> On Thursday 10 May 2012 03:13 AM, Rafael J. Wysocki wrote:
>>> From: Rafael J. Wysocki <rjw@sisk.pl>
>>>
>>> On some systems there are CPU cores located in the same power
>>> domains as I/O devices.  Then, power can only be removed from the
>>> domain if all I/O devices in it are not in use and the CPU core
>>> is idle.  Add preliminary support for that to the generic PM domains
>>> framework.
>>>
>> I am just curious to know, what kind of IO devices, you are
>> talking here?
> 
> Nothing specific, really.  It can be any kind of I/O devices that happen
> to be in the same power domain.  This includes USB, SDHI, MMCIF controllers
> on the SoC I have in mind in particular.
> 
OK.
These are more of generic devices and actually not related to CPU/CPU
clusters as such.

>> And also how those devices linked with CPU low power
>> states apart from being part of same power domain. And is it
>> the power domain or more of voltage domain, we are talking here.
> 
> Depending on the definitions I guess.  How do you define a power domain and
> a voltage domain?
>

A voltage domain can be a section of the device supplied by a dedicated
voltage rail. A voltage domain can have many power-domains like
CPU cluster domain, Interconnect domain, peripheral domains.
And each power domain then can have many sub-modules like UART, SPI,
USB etc

>>> This assumes that there is only one CPU core in the system and it is
>>> supposed to be set up in the following way.
>>>
>>> First, the platform is expected to provide a cpuidle driver with one
>>> extra state designated for the generic PM domains code to handle.
>>> This state should be initially disabled and its exit_latency value
>>> should be set to whatever time is needed to bring up the CPU core
>>> itself after restoring power to it, not including the domain's
>>> power on latency.  Its .enter() callback should point to a procedure
>>> that will save the CPU core's state as appropriate before power
>>> removal.  On success, it should return the same value as it has
>>> been passed as its third argument, but it shouldn't put the CPU
>>> core into a C-state.  If it is about to return the index of
>>> a different cpuidle state, however, it should make sure that the CPU
>>> be put into that state before it returns.
>>>
>>> The remaining characteristics of the extra cpuidle state, referred to
>>> as the "domain" cpuidle state below, (e.g. power usage, target
>>> residency) should be populated in accordance with the properties of
>>> the hardware.
>>>
>>> Next, the platform should execute genpd_attach_cpuidle() on the PM
>>> domain containing the CPU core.  That will cause the generic PM
>>> domains framework to treat that domain in a special way such that:
>>>
>>>  * When all devices in the domain have been suspended and it is about
>>>    to be turned off, the states of the devices will be saved, but
>>>    power will not be removed from the domain.  Instead, the "domain"
>>>    cpuidle state will be enabled so that power can be removed from
>>>    the domain when the CPU core is idle and the state has been chosen
>>>    as the target by the cpuidle governor.  In that case, before
>>>    removing power from the domain, the framework will execute the
>>>    .enter() callback initially defined for the "domain" state.
>>>
>>>  * When the first I/O device in the domain is resumed and
>>>    __pm_genpd_poweron(() is called for the first time after
>>>    power has been removed from the domain, the "domain" cpuidle
>>>    state will be disabled to avoid subsequent surprise power removals
>>>    via cpuidle.
>>>
>>
>> If these are CPU cluster/package specific IO's like interrupt
>> controller, cache controller, Coherency interconnect etc and
>> if the intention is to ensure that these devices context
>> is saved/restored in cpuidle entry/exit, it can be handled with
>> CPU PM notifiers.
> 
> Maybe it can, but I'm not so sure of that in general.
> 
>> We already do that for ARM SOCs.
> 
> Surely not all of them?  I know of a few at least where this isn't done.
>
You are right these are not for general purpose IO's

>> From the patch description it seems, they are general purpose
>> peripherals.
> 
> Yes, they are.
> 
>> We had one thermal sensor on OMAP which
>> wrongly clocked from the CPU clock source and needed
>> some idle notifier infrastructure to prepare/resume
>> this device for idle entry/exit.
> 
> The system I have in mind is designed in such a way that there is a power
> domain with three subdomains, one of which contains the CPU core and the
> remaining two contain I/O devices of various kinds.  General purpose as well
> as "core".
> 
I am not sure CPUIDLE is suppose to take care of these kind of general
purpose IO's. CPUIDLE should take care of CPU and CPU cluster power
management. Any other peripherals as you mentioned should be already
have some sort of device drivers and they should be using runtime PM for
it, no? And for the constraints, PM-Qos can be used. So far CPUIDLE
core code has maintained that distinction and all the C-state latencies
are of the CPU clusters rather than the SOC.

If you have a voltage rail dependency then that should be handled
in the voltage layer/regulator layer. If there is a power domain
dependency then the power domain framework should do the use
counting yo handle such scenarios.

Please correct me but, IIUC, your proposal wants to use CPUIDLE
for the SOC level power management.
Will you be able to expand your requirements and explain why can't
you manage PM for the general purpose devices like MMC, USB etc
in their own device drivers ?

Regards
Santosh




