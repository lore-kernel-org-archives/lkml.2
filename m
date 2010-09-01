Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab0IAClJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 22:41:09 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57436 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab0IAClG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 22:41:06 -0400
MIME-Version: 1.0
In-Reply-To: <4C7D5D60.1070203@am.sony.com>
References: <AANLkTimJkPD=shB9oi3ASocaLEpG=C7oDJMbq8BEy2Fe@mail.gmail.com> <4C7D5D60.1070203@am.sony.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 31 Aug 2010 20:40:44 -0600
X-Google-Sender-Auth: VVLjy1UQiO-_M_mTbTd79AW6i7Y
Message-ID: <AANLkTinWwWg9SXLL1rAF-VKCp+BH8wZuYsgibg-52__U@mail.gmail.com>
Subject: Re: [RFC] Kernel 'boot cache' to reduce boot time
To: Tim Bird <tim.bird@am.sony.com>
Cc: Andrew Murray <amurray@mpcdata.com>,
        "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 1:52 PM, Tim Bird <tim.bird@am.sony.com> wrote:
> On 08/31/2010 12:13 PM, Andrew Murray wrote:
>> I have a suggestion for a kernel framework which aims to reduce boot
>> time in embedded devices and would be interested in hearing your
>> feedback.
>>
>> A large portion of kernel boot time is spent in driver probe functions
>> often waiting for hardware for example calculating LPJ values or
>> trying to determine what type of camera is connected (PAL/NTSC) etc.
>> However for most embedded devices the hardware remains constant and
>> these probes always determine the same information. Therefore boot
>> time can be decreased by removing some of this probe code and
>> replacing it with known values.
>>
>> To some extent some of these optimisations have already been done
>> through a variety of methods - for example the LPJ calculation can be
>> bypassed with the lpj= parameter and some drivers have their own
>> methods. My solution aims to generalise these solutions...
>>
>> The solution is to provide a very simple framework which will allow
>> drivers to identify and record such values (LPJ, camera type, decoder
>> chip version) during boot. Once booted the user can obtain a
>> collection of these values and pass them back to the kernel on
>> subsequent boots. During subsequent boots - drivers upon realising
>> these values have already been provided can bypass some of their probe
>> code and thus reducing boot time. Taking advantage of this framework
>> would be very trivial for drivers.

I think we've pretty much already got this functionality, even if it
isn't fully taken advantage of by all device drivers.  Any device can
be registered with either a device-specific platform_data pointer or a
device_node pointer (when CONFIG_OF is enabled).  Any driver can be
adapted to use additional data from either of those sources as an
alternative to HW probing.  platform_data is simply a statically
defined C structure provided by the board support code.  A device_node
pointer points to the device's node in a flattened device tree data
structure that is passed to the kernel at boot time.

(It's also worth noting that a large number of device drivers in
embedded devices already don't do any form of probing, and only rely
on the static data provided at device registration time).

USB and PCI busses are the obvious cases where the kernel currently HW
probes by default, but those cases could also be modified to make use
of device tree or platform_data configuration sources.  From your
description, it sounds like camera connections are in the same boat.

>> I wanted to see your views on the overall solution prior to
>> considering how it could be implemented.
>
> For my part, I think this sounds like a great idea.  I have
> considered such a mechanism in the past, but never gotten around
> to actually designing a solution.
>
> Here are some random thoughts on this idea:
>
> My experience is that we've made good progress on boot time
> probing, for fixed hardware.  The big problems in the kernel
> boot time appear to be with busses that require discovery of
> devices, with long timeouts specified in the bus standard and
> arbitrary bus connection architecture (I'm thinking of USB,
> but other busses have similar problems).  For many embedded
> devices, scanning these types of pluggable busses aren't
> required for what I call "first product use", but they can be
> scanned and populated later.

There actually already are bindings and some support code for
describing fixed PCI devices in a flattened device tree.  USB is a bit
harder though, but fortunately USB probing can often be deferred until
later in the boot (as you rightly pointed out) after userspace has
started.

>
> Note that the asynchronous function call stuff by Arjan
> van de Ven addresses some of this boot time probing
> delay problem.
>
> Having said that, I don't think that probing of static
> hardware is a solved problem, by any means.
>
> For the boot cache data, you are going to need to figure
> out how to make the data persistent.  Doing something
> in a regular fashion (rather than ad-hoc via command line
> options) should help with this.

I'm not convinced that doing a "live" capture is the best approach.
I'd rather see that kind of data obtained by the developer and
explicitly specified either in a device tree or the platform support
code.

If live capture is required, then doing an IPL-style boot, suspend &
dump (like you described below) is probably a more robust approach.
Otherwise you have to figure out how to pick and choose items of data
out of a running kernel and inject them in again at the next boot
(blech!).

> To some degree this might end up looking very similar
> to the "resume" path in the driver, where a particular
> device state is entered into from cold start.
>
> Sony has been doing something related to this called
> "Snapshot boot" for some time now, which is kind of an
> optimized unhibernate operation, with some hardware bringup
> done by firmware, and some bringup done using the normal driver
> resume operation.  This work was presented at OLS
> several years ago, but we haven't pushed it much since
> then.  (But we're using it in product)
> See http://elinux.org/upload/3/37/Snapshot-boot-final.pdf

I remember hearing very positive things about that presentation (and
being sorry that I missed it) that year at OLS.  I'm pretty intrigued
by the approach and would like to see more research done in that area.

> Sorry for rambling.  Anyway - I'm all for the boot cache idea.
> But acceptability would, of course, be dependent on the
> details of the implementation.
>
> The best thing to get started, IMHO, would be to identify
> a few drivers which have long probe times, and see
> how they could reduce these with the proposed boot cache.
> If you find that each new device adds some new wrinkle
> in the cache requirements, that would be a bad sign.  But
> if different drivers, especially drivers in different functional
> areas, are found to be able to use a consistent API, then
> this could be a nice feature.
>
> BTW - I could see this tying into the flattened device
> tree work by Grant Likely.

http://www.devicetree.org/Device_Tree_Usage

g.
