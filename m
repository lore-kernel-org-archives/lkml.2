Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347Ab0LCJgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 04:36:21 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59657 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126Ab0LCJgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 04:36:19 -0500
Date: Fri, 3 Dec 2010 10:36:18 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Robin Holt <holt@sgi.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Adrian Bunk <bunk@kernel.org>,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jack Steiner <steiner@sgi.com>
Subject: Re: Do we need to call calibrate_delay() for all
 cores/hyperthreads on a socket?
Message-ID: <20101203093617.GB8800@basil.fritz.box>
References: <20101203065212.GQ6858@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101203065212.GQ6858@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 12:52:12AM -0600, Robin Holt wrote:
> 
> I do not know all the different combinations of sockets, cores, and
> hyperthreads out there, but it seems like all cores and their hyperthreads
> on a socket should compute the same value for their calculate_delay()
> function.
> 
> When booting a 4096 cpu system without specifying lpj on the command line,
> we spend approximately 0.1 seconds per core/hyperthread calculating the
> lpj value for that cpu.
> 
> If we were to, on the other hand, only calculate the delay value for the
> first core on a socket, we would reduce the time spent booting a 4096 cpu
> (256 sockets, 8 cores per socket hyperthreaded) down from nearly seven
> minutes to approx 25 seconds.  This seems like a very safe optimization,
> but I repeat that I do not know all the different potential combinations
> of socket, core, hyperthread out that.  Please note these are just rough
> approximations taken from memory.  I am doing a couple of test boots
> now without and with lpj= specified on the command line to get a more
> accurate approximation.

Hi Robin,

At least for SMT threads that seems like a fine idea: in general I think
we should be doing a lot more things "per core" instead of "per thread".

As for sharing calibration on whole sockets: on some systems individual 
cores on a socket can run with different frequencies (e.g. AMD Fam10h).
In theory the CPU should always run at P0 when coming out of boot,
but we've had cases in the past where it was running lower, e.g.
if the BIOS decided to cap power consumption. I guess in theory
those states could be different per core on those systems.

So I think it would be safer to still calibrate per core at least.
In theory one could try to check for the case described above,
and only do it then, but that may be fragile.

But maybe it's possible to calibrate different cores in a socket in 
parallel anyways?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
