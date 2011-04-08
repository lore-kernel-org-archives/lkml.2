Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab1DHAcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 20:32:50 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:56329 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757269Ab1DHAcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 20:32:47 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@suse.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH/RFC 0/6] ARM: runtime PM: consolidate runtime PM implementations
Organization: Texas Instruments, Inc.
References: <1302134569-22825-1-git-send-email-khilman@ti.com>
	<871v1eaz0u.fsf@ti.com> <87hbaa7zhs.fsf@ti.com>
	<201104080031.23452.rjw@suse.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
Date: Thu, 07 Apr 2011 17:32:42 -0700
Message-ID: <874o694m6t.fsf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@suse.com> writes:

> On Thursday, April 07, 2011, Kevin Hilman wrote:
>> Kevin Hilman <khilman@ti.com> writes:
>> 
>> [...]
>> 
>> > Replacing the PM ops for all devices was done on OMAP and SH-mobile
>> > because that was the only approach we had.  Now that we have device
>> > power domains (thanks Rafael!), we can be more selective about which
>> > devices to apply them to.
>> >
>> > Note that my RFC patch/series did not do the selective part of deciding
>> > which devices to override and which ones not to, that part will be
>> > platform specific.  
>> 
>> Actually, thinking about this a little more, my patch actually does
>> select only relevant devices, and not *all* platform devices.
>> 
>> In my patch, the device power domain pointers are only added for devices
>> where a clk_get() actually succeeds.  In the original version, the
>> runtime PM hooks are overridden for *all* platform devices, but ones
>> that have no clock (or where clk_get() failed) have the additional
>> overhead of still calling the custom PM ops, but the custom ops have
>> nothing to do.
>
> As I wrote in another message to Grant, the problem basically is that
> the platform bus type behavior is not the desirable one.  Namely, I don't
> generally want device driver callbacks to be invoked until we know that
> power will be removed from the devices.  

Ah, I didn't know that was a goal.  I totally agree there.

> However, the platform bus type executes driver callbacks automatically
> if they exist.  This currently is unavoidable, because power domain
> callbacks are executed in addition to and not instead the bus type
> callbacks.
>
> We've discussed that a bit at the LF Collab Summit with Grant and Paul and
> the conclusion is that to address this particular problem we'll need to change
> the core so that if there is a power domain for the given device, the
> power domain callbacks will be executed first and if they return a specific
> error code, the core will execute the bus type callbacks.  For devices that
> don't belong to any power domain, the bus type callbacks will be executed
> (which is the current behavior).
>
> I'm going to post a patch along these lines early next week.  Then, we
> can simply move the management of device clocks, the execution of device
> driver callbacks and the power removal into power domain callbacks.

Sounds good to me.

> At that point it may be possible to share some code between shmobile and
> OMAP, but I'm not sure yet how much of the code may be shared and it what
> way exactly.

I'll have a look again after you post your series, but I'm pretty sure
any runtime PM implementation based on basic clock gating could be
shared.  Basically, the idea is in the absence of real power domains, to
create a default "virtual" powerdomain that contains every device with a
clock.  This would capture all on-chip devices into a single power domain.
The device powerdomain callbacks for these would do the basic clock
gating (as is done in mach-shmobile/pm_runtime.c).

Kevin
