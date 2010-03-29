Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab0C2So5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 14:44:57 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:55260 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351Ab0C2So4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 14:44:56 -0400
Subject: Re: [PATCH] hangcheck-timer is broken on x86
From: john stultz <johnstul@us.ibm.com>
To: Yury Polyanskiy <ypolyans@princeton.edu>
Cc: Joel Becker <Joel.Becker@oracle.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Jan Glauber <jan.glauber@de.ibm.com>
In-Reply-To: <20100329130418.2b5c068c@penta.localdomain>
References: <20100323233611.6dcbe4f4@penta.localdomain>
	 <20100326214648.GF9984@mail.oracle.com>	<1269824436.1880.2.camel@work-vm>
	 <20100329101106.3678a312@penta.localdomain>
	 <1269881007.1857.18.camel@work-vm>
	 <20100329130418.2b5c068c@penta.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 11:44:51 -0700
Message-ID: <1269888291.3968.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-29 at 13:04 -0400, Yury Polyanskiy wrote:
> On Mon, 29 Mar 2010 09:43:27 -0700
> john stultz <johnstul@us.ibm.com> wrote:
> 
> > > I am not sure which archs do you mean. But in any case,
> > > getrawmonotonic() is not just a wrap around a call to rdtsc() (or acpi
> > > pm timer read). It is based on the clock->raw_time, which is updated
> > > every timer interrupt by the update_wall_time(). So even if underlying
> > > timer wraps, it doesn't lead to getrawmonotonic() returning 0 sec.  
> > 
> > What I'm saying is that if you're using getrawmonotonic() to detect
> > hangs, you might miss them, as getrawmonotonic may wrap (and thus stop
> > continually increasing) if the timer interrupt is delayed. This does not
> > apply to systems using the TSC clocksource, but does apply to systems
> > using the acpi_pm. 
> 
> But if timer interrupt is delayed by more than acpi_pm wrap-around
> time, then the update_wall_time() is also screwed. Since it is not, we
> can rely on getrawmonotonic().

Right, if the box hangs for longer then the clocksource can count for,
the timekeeping subsystem will be off by some multiple of that length.

And That's exactly why I'm advising against using
gettimeofday/getrawmonotonic or any other software managed sense of time
for the hangcheck timer, as you won't be able to correctly detect hangs.

I'm also suggesting using something like read_persistent_clock() is
better, because there is no OS/software management involved (other then
the minor syncing issue I mentioned before) so if the system hangs for a
long period of time, then returns, you'll still be able to detect the
hang.

But maybe what folks are using the hangcheck timer for is shifting, so
its possible that I'm not quite understanding what you're trying to do
here.

thanks
-john

