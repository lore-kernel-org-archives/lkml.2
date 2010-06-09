Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab0FIUXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 16:23:17 -0400
Received: from www.tglx.de ([62.245.132.106]:47033 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755818Ab0FIUXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 16:23:16 -0400
Date: Wed, 9 Jun 2010 22:22:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Suresh Rajashekara <suresh.raj+linuxomap@gmail.com>
cc: linux-omap@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, John Stultz <johnstul@us.ibm.com>
Subject: Re: Timekeeping issue on aggressive suspend/resume
In-Reply-To: <AANLkTinIO5a1EeK6Ej2ljkuyL9zv06OMfbyiZBaxTQTd@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1006092206020.2933@localhost.localdomain>
References: <AANLkTinIO5a1EeK6Ej2ljkuyL9zv06OMfbyiZBaxTQTd@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jun 2010, Suresh Rajashekara wrote:

> I have an application (running on 2.6.29-omap1) which puts an OMAP1
> system to suspend aggressively. The system wakes up every 4 seconds
> and stays awake for about 35 milliseconds and sleeps again for another
> 4 seconds. This design is to save power on a battery operated device.
> 
> This aggressive suspend resume action seems like creating an issue to
> other applications in the system waiting for some timeout to happen
> (especially an application which is waiting using the mq_timedreceive
> and is supposed to timeout every 30 seconds. It seems to wake up every
> 90 seconds). Seems like the timekeeping is not happening properly in
> side the kernel.
> 
> If the suspend duration is changed from 4 second to 1 second, then
> things work somewhat better. On reducing it to 0.5 second (which was
> our earlier design on 2.6.16-rc3), the problem seems to disappear.
> 
> Is this expected?

Yes, that's caused by the fact that suspend (via sys/power/state )
freezes the kernel internal timers and the user space visible timers
which are based on CLOCK_MONOTONIC or jiffies (like mq_timedreceive on
your .29 kernel). Only CLOCK_REALTIME based timers are kept correct as
we have to align to the wall clock time.

The reason for this is, that otherwise almost all timers are expired
when we resume and we get a thundering herd of apps and kernel
facilities due to firing timeouts.

Another problem is that jiffies can wrap around on 32 bit systems
during a long suspend though I don't think that's a real world problem
as it takes between 49 to 497 days of suspend depending on the HZ
setting. SO for your usecase it would not matter.

I'm more concerned about code getting surprised by firing timers as
the kernel has this behaviour for a long time now.

Though we could change that conditionally - the default would still be
the freeze of jiffies and CLOCK_MONOTONIC for historical compability.

There will be probably some accounting issues. uptime, cpu time of the
suspend task and some others, but that needs to be found out.

Thanks,

	tglx



