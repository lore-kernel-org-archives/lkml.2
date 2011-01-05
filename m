Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845Ab1AEKQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 05:16:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33840 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab1AEKQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 05:16:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jean Pihet <jean.pihet@newoldbits.com>
Subject: Re: [PATCH 1/3] perf: add calls to suspend trace point
Date: Wed, 5 Jan 2011 11:15:55 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, mingo@elte.hu, trenn@suse.de,
        Len Brown <len.brown@intel.com>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-perf-users@vger.kernel.org, Jean Pihet <j-pihet@ti.com>
References: <1294136263-24020-1-git-send-email-j-pihet@ti.com> <201101050001.23979.rjw@sisk.pl> <AANLkTimRvZs2QBZ4y+AEO7CWUudwBSM6-K0ZQxFTF+Fm@mail.gmail.com>
In-Reply-To: <AANLkTimRvZs2QBZ4y+AEO7CWUudwBSM6-K0ZQxFTF+Fm@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101051115.55528.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 05, 2011, Jean Pihet wrote:
> On Wed, Jan 5, 2011 at 12:01 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Tuesday, January 04, 2011, Jean Pihet wrote:
> >> Hi,
> >>
> >> On Tue, Jan 4, 2011 at 12:29 PM, Pavel Machek <pavel@ucw.cz> wrote:
> >> > Hi!
> >> >
> >> >> Uses the machine_suspend trace point, called from the
> >> >> generic kernel suspend_enter function.
> >> >>
> >> >> Signed-off-by: Jean Pihet <j-pihet@ti.com>
> >> >> CC: Thomas Renninger <trenn@suse.de>
> >> >> ---
> >> >>  kernel/power/suspend.c |    3 +++
> >> >>  1 files changed, 3 insertions(+), 0 deletions(-)
> >> >>
> >> >> diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> >> >> index ecf7705..0650596 100644
> >> >> --- a/kernel/power/suspend.c
> >> >> +++ b/kernel/power/suspend.c
> >> >> @@ -22,6 +22,7 @@
> >> >>  #include <linux/mm.h>
> >> >>  #include <linux/slab.h>
> >> >>  #include <linux/suspend.h>
> >> >> +#include <trace/events/power.h>
> >> >>
> >> >>  #include "power.h"
> >> >>
> >> >> @@ -164,7 +165,9 @@ static int suspend_enter(suspend_state_t state)
> >> >>       error = sysdev_suspend(PMSG_SUSPEND);
> >> >>       if (!error) {
> >> >>               if (!suspend_test(TEST_CORE) && pm_check_wakeup_events()) {
> >> >> +                     trace_machine_suspend(state);
> >> >>                       error = suspend_ops->enter(state);
> >> >> +                     trace_machine_suspend(PWR_EVENT_EXIT);
> >> >>                       events_check_enabled = false;
> >> >>               }
> >> >>               sysdev_resume();
> >> >
> >> > Ok... why this place?
> >> This trace has been placed here because it traces the machine low
> >> level mode enter.
> >>
> >> > I mean, perhaps suspend time should include
> >> > device suspend?
> >> That makes sense. We have a few options here:
> >> 1) keep the traces as proposed to trace the low level machine code only,
> >> 2) move the traces to the entry and exit of suspend_enter so that it
> >> includes the prepare and late_prepare (+ the associated wake-up)
> >> callbacks as well,
> >> 3) move the traces to suspend_devices_and_enter so that it includes 2)
> >> and the handling of the console and the devices,
> >> 4) move the traces to enter_state do that it includes 3), the call to
> >> sys_sync and the user space freeze.
> >>
> >> Note that the the SNAPSHOT_2RAM ioctl code also calls
> >> suspend_devices_and_enter, so if only 4) is used no trace will be
> >> generated in that case.
> >>
> >> I am in favor of 3) of 4).
> >> What do you think?
> >
> > Why don't we keep the tracepoints as proposed _and_ add two additional
> > tracepoints around device suspend-resume?
> I like the idea but that requires to extend the current API with
> additional suspend tracepoints or device state change tracepoints.
> That can be done once the current API is firmly in place.
> Today the only trace API for suspend is machine_suspend(unsigned int
> state), so I think the best option is 3) here above.
> 
> Unless there is an objection I am pushing 3) asap.

Fine by me.

Thanks,
Rafael
