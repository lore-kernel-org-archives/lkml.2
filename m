Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab1JQOqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 10:46:03 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47966 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756014Ab1JQOqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 10:46:00 -0400
Date: Mon, 17 Oct 2011 10:45:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: NeilBrown <neilb@suse.de>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of suspend/hibernate
 interfaces
In-Reply-To: <20111017093401.21cd4461@notabene.brown>
Message-ID: <Pine.LNX.4.44L0.1110171030440.2430-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Oct 2011, NeilBrown wrote:

> > The more I think about this, the better it seems.  In essence, it 
> > amounts to "virtualizing" the existing PM interface.
> 
> While "virtualizing" does sound attractive in some way, I think it would be
> the wrong thing to do.
> In practice there is only one process at a time that is likely to suspend
> the system.  I've just been exploring how that works.
> 
> gnome-power-manager talks to upowerd over dbus to ask for a suspend.
> upowerd then runs /usr/sbin/pm-suspend.
> pm-suspend then runs all the script in /usr/lib/pm-utils/sleep.d/
> and the calls "do_suspend" which is defined in /usr/lib/pm-utils/pm-functions
> 
> Ugghh.. That is a very deep stack that is doing things the "wrong" way.
> i.e. it is structured about request to suspend rather than requests to stay
> awake.
> 
> Nonetheless, we only really need to worry about the bottom of the stack.
> Rather than virtualize /sys/power/state, just modify pm-function, which
> you can probably do by putting appropriate content
> into /usr/lib/pm-utils/defaults.
> Get that to define a do_suspend which interacts with the new suspend-daemon
> to say "now would be a good time to suspend" - if nothing else is blocking
> suspend, it does.
> 
> Put it another way:  power-management has always been "virtualized" via lots
> of shell scripts in pm-utils (and various daemons stacked on top of that).
> We just need to plug in to that virtualisation.
> 
> This is all based on gnome.  kde might be different, but I suspect that it
> only at the top levels.  I would be surprised if kde and the other desktops
> don't all end up going through pm-utils.

Okay, good; that allows us to avoid the virtualization issue.  The only
reason for having it in the first place was to be certain of working
with userspace environments that don't use a standard, structured
method for initiating system sleeps.  If you don't care about those 
environments then there's no need for it.

Do we agree about the best way to make this work?  I'm suggesting that
when the PM daemon is started up with a "legacy" option, it should
assume the existence of a predefined client that always wants to keep
the system awake, except for brief periods whenever a sleep request is
received from a new pm-utils program.  Maybe this new program could
pass the PM daemon a time limit (such as 3000 ms), with the requirement
that if the daemon can't put the system to sleep within that time limit
then it should give up and fail the sleep request.

Alan Stern

