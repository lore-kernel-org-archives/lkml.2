Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab0LCPJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 10:09:36 -0500
Received: from relay2.sgi.com ([192.48.179.30]:47113 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751202Ab0LCPJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 10:09:35 -0500
Date: Fri, 3 Dec 2010 09:09:29 -0600
From: Robin Holt <holt@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Robin Holt <holt@sgi.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Adrian Bunk <bunk@kernel.org>,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>
Subject: Re: Do we need to call calibrate_delay() for all
 cores/hyperthreads on a socket?
Message-ID: <20101203150928.GG3344@sgi.com>
References: <20101203065212.GQ6858@sgi.com>
 <20101203093617.GB8800@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101203093617.GB8800@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 10:36:18AM +0100, Andi Kleen wrote:
> On Fri, Dec 03, 2010 at 12:52:12AM -0600, Robin Holt wrote:
> > 
> > I do not know all the different combinations of sockets, cores, and
> > hyperthreads out there, but it seems like all cores and their hyperthreads
> > on a socket should compute the same value for their calculate_delay()
> > function.
> > 
> > When booting a 4096 cpu system without specifying lpj on the command line,
> > we spend approximately 0.1 seconds per core/hyperthread calculating the
> > lpj value for that cpu.
> > 
> > If we were to, on the other hand, only calculate the delay value for the
> > first core on a socket, we would reduce the time spent booting a 4096 cpu
> > (256 sockets, 8 cores per socket hyperthreaded) down from nearly seven
> > minutes to approx 25 seconds.  This seems like a very safe optimization,
> > but I repeat that I do not know all the different potential combinations
> > of socket, core, hyperthread out that.  Please note these are just rough
> > approximations taken from memory.  I am doing a couple of test boots
> > now without and with lpj= specified on the command line to get a more
> > accurate approximation.
> 
> Hi Robin,
> 
> At least for SMT threads that seems like a fine idea: in general I think
> we should be doing a lot more things "per core" instead of "per thread".
> 
> As for sharing calibration on whole sockets: on some systems individual 
> cores on a socket can run with different frequencies (e.g. AMD Fam10h).
> In theory the CPU should always run at P0 when coming out of boot,
> but we've had cases in the past where it was running lower, e.g.
> if the BIOS decided to cap power consumption. I guess in theory
> those states could be different per core on those systems.
> 
> So I think it would be safer to still calibrate per core at least.
> In theory one could try to check for the case described above,
> and only do it then, but that may be fragile.
> 
> But maybe it's possible to calibrate different cores in a socket in 
> parallel anyways?


Ok, more accurate timing information.

Booted without lpj=:
[   95.105108] Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
...
[  411.231708] Booting Node 255, Processors  #4088 #4089 #4090 #4091 #4092 #4093 #4094 #4095 Ok.

Booted with lpj=:
[   95.327867] Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
...
[  168.246617] Booting Node 255, Processors  #4088 #4089 #4090 #4091 #4092 #4093 #4094 #4095 Ok.

That is not a fair comparison due to the lpj case, we did no calibrations,
but it is illustrative.  In that time span, on the first boot we performed
4095 calibrate_delay() calls which are not performed in the second boot.
The difference is 243 seconds or 0.06 seconds per cpu.  As Jack likes
to jokingly remind me, we have once again proved that if you multiply
a small number by a large enough number, you will get a large number.

If I am calculating this correctly, just doing the calibrate_delay on
a per-socket basis should reduce boot time 228 seconds.

If, on the other hand, we do it per core, it ends up only reducing boot
time by 121 seconds.  An improvement for sure, but not good enough to
make me really happy ;).


Thanks,
Robin
