Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab1FUACH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 20:02:07 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:33114 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756515Ab1FUACF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 20:02:05 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, Magnus Damm <magnus.damm@gmail.com>,
        Paul Walmsley <paul@pwsan.com>, Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH 0/8] PM / Domains: Support for generic I/O PM domains (v5)
Organization: Texas Instruments, Inc.
References: <201106112223.04972.rjw@sisk.pl>
Date: Mon, 20 Jun 2011 17:02:00 -0700
In-Reply-To: <201106112223.04972.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Sat, 11 Jun 2011 22:23:04 +0200")
Message-ID: <87boxs3vd3.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> Hi,
>
> This is the 4th update of the patchset adding support for generic I/O PM
> domains.  
>
> The patches have been reworked quite a bit to take feedback into
> account, but I left the Greg's ACK in [4/8] in the hope it still applies
> (Greg, please let me know in case it doesn't :-)).
>
> The model here is that a bunch of devices share a common power resource
> that can be turned on and off by software.  In addition to that, there
> are means to start and stop the activity of each device, for example
> by manipulating their clocks.  Moreover, there may be hierarchy of
> such things, for example power resource A may be necessary for devices
> a, b, c, which don't rely on any other power resources, and for devices
> x, y, z that also rely on power resource X.  In that case there one PM
> domain object representing devices a, b, c and power resource A, and 
> another PM domain object will represent devices x, y, z with power
> resource X, plus the first object will be the second one's parent.
>
> Note to Kevin: I know you'd like each PM domain to be able to go into several
> different states, but the situation will always be that in some of those
> states the devices' registers will remain intact, while in the rest of those
> states they will be reset.  Say, there are states 1, 2, 3, 4 and states
> 1-3 preserve device registers.  Then it is not necessary to save device
> registers for "domain" states 1-3 and it only is necessary to save them
> when going to state 4.  In that case, .power_off() may map to the "go to
> state 4" operation (and analogously .power_on()), while the rest may be
> done by .stop_device() and .start_device().  IOW, .power_is_off == true
> means "the devices' registers have to be restored", so it need not map to
> any particular physical state of a (hardware) power domain.

Sure, but it's not only about register context save/restore.  It's about
the the governor hook and how you decide which state to enter.  IOW, the
governor decision is not only about whether or not you will lose
register context but also about the latency involved in entering &
exiting those states.

So from my perspective, having only 2-states at this level makes the
governor rather pointless since any decision making will have to be done
where ever the knowledge of the mulitple power states lives.

> Note to Magnus and Paul: I didn't use a global lock as suggested, because
> I think it may lead to completely unnecessary congestion in situations in
> which there are no hierarchies of PM domains.  It is quite easy to show that
> the code doesn't deadlock, because (1) no more than 2 locks are held by the
> same thread at a time (parent lock and child lock) and (2) they are always
> acquired in the same order (parent before the child).
>
> Overall, I think I've taken all of the important dependencies into
> consideration, but if you spot something suspicious, please let me know. :-)
> Wakeup is not covered at this point, because it's not necessary for the
> SH7372's A4LC power domain that's the first user of the new code, but it
> is quite clear how add the support for it.  Also, for more complicated
> cases it is necessary to take QoS requirements (latencies) into account,
> which is in the works (kind of).
>
> [1/8] - Update documentation to reflect the fact that struct dev_power_domain
>         callbacks take precedence over subsystem PM callbacks.
>
> [2/8] - Rename struct dev_power_domain to struct dev_pm_domain to reflect the
>         fact that those objects need not correspond to hardware power domains
>         directly.
>
> [3/8] - Move subsys_data in struct dev_pm_info out of #ifdef CONFIG_PM_RUNTIME
>
> [4/8] - Introduce runtime PM support for generic I/O PM domains.
>
> [5/8] - Introduce generic "noirq" callbacks for system suspend/hibernation
>         (that's necessary for the next patches).
>
> [6/8] - Move some PM domains support code fro under #ifdef CONFIG_PM_RUNTIME
>
> [7/8] - Add system-wide PM support for generic I/O PM domains.
>
> [8/8] - Use the new code to represent the SH7372's A4MP power domain.
>
> The patchset has been tested on SH7372 Mackerel board and appears to work
> correctly.
>
> I'd like to push [1/8] for 3.0 (it may be regarded as a fix), but I _think_
> that it may be a good idea to push [2/8] for 3.0 too, to limit the time in
> which people may possibly use the naming that's going to change in their new
> code.  If you agree with that, please let me know, I'll need some serious
> ACKs below that patch if it's to be pushed for 3.0. ;-)

Just gave you my ack, but [2/8] will need a minor update to apply on
Linus' master branch since another fix to mach-omap1/pm_bus.c just got
merged[1] via the OMAP tree.

I don't have any other fixes touching those files queued for v3.0 so I
don't expect any other conflicts there.

Kevin

[1]
commit e9e35c5a2b2c803b5e2f25906d8ffe110670ceb6
Author: Kevin Hilman <khilman@ti.com>
Date:   Tue Jun 14 05:53:18 2011 -0700

    OMAP1: PM: register notifiers with generic clock ops even when !PM_RUNTIME
    
    When runtime PM is disabled, device clocks need to be enabled on
    device add and disabled on device remove.  This currently is not
    happening because in the !PM_RUNTIME case, no notifiers are registered
    for OMAP1 devices.
    
    Fix this by ensuring notifiers are registered, even in the !PM_RUNTIME case.
    
    Reported-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
    Tested-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
    Signed-off-by: Kevin Hilman <khilman@ti.com>
    Signed-off-by: Tony Lindgren <tony@atomide.com>

