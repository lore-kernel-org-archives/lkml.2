Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab0C2Qnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 12:43:47 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:36106 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab0C2Qnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 12:43:45 -0400
Subject: Re: [PATCH] hangcheck-timer is broken on x86
From: john stultz <johnstul@us.ibm.com>
To: Yury Polyanskiy <ypolyans@princeton.edu>
Cc: Joel Becker <Joel.Becker@oracle.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Jan Glauber <jan.glauber@de.ibm.com>
In-Reply-To: <20100329101106.3678a312@penta.localdomain>
References: <20100323233611.6dcbe4f4@penta.localdomain>
	 <20100326214648.GF9984@mail.oracle.com>	<1269824436.1880.2.camel@work-vm>
	 <20100329101106.3678a312@penta.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 09:43:27 -0700
Message-ID: <1269881007.1857.18.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-29 at 10:11 -0400, Yury Polyanskiy wrote:
> On Sun, 28 Mar 2010 18:00:36 -0700
> john stultz <johnstul@us.ibm.com> wrote:
> 
> > > 1) Does getrawmonotonic() satisfy hangcheck-timer?  What I mean is, will
> > > it always return the wallclock nanoseconds even in the face of CPU speed
> > > changes, suspend, udelay, or any other suspension of kernel operation?
> > > Yes, I know this is a tougher standard than rdtsc(), but this is what
> > > hangcheck-timer wants.  rdtsc() at least satisfied udelay and PCI hangs.
> > 
> > getrawmonotonic() can be stalled and will wrap on some hardware (acpi pm
> > timer wraps every 5 seconds).
> > 
> 
> I am not sure which archs do you mean. But in any case,
> getrawmonotonic() is not just a wrap around a call to rdtsc() (or acpi
> pm timer read). It is based on the clock->raw_time, which is updated
> every timer interrupt by the update_wall_time(). So even if underlying
> timer wraps, it doesn't lead to getrawmonotonic() returning 0 sec.

What I'm saying is that if you're using getrawmonotonic() to detect
hangs, you might miss them, as getrawmonotonic may wrap (and thus stop
continually increasing) if the timer interrupt is delayed. This does not
apply to systems using the TSC clocksource, but does apply to systems
using the acpi_pm. 

read_persistent_clock() is likely a better interface to use, because it
returns the seconds usually from the CMOS clock which runs continually
without any OS maintenance. 

The only complication there would likely be hwclock syncing (either by
hand or via NTP), but that could be handled by a
touch_hangcheck_watchdog() style notifier. 

thanks
-john


