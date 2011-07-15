Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652Ab1GOAgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 20:36:48 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:55836 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409Ab1GOAgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 20:36:47 -0400
Subject: Re: 2.6.32.21 - uptime related crashes?
From: john stultz <johnstul@us.ibm.com>
To: Willy Tarreau <w@1wt.eu>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Cc: "MINOURA Makoto / ?$BL'1: ?$B??" <minoura@valinux.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Faidon Liambotis <paravoid@debian.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org, Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        seto.hidetoshi@jp.fujitsu.com,
        =?ISO-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        Rand@jasper.es
In-Reply-To: <20110712041938.GO27254@1wt.eu>
References: <20110428082625.GA23293@pcnci.linuxbox.cz>
	 <20110428183434.GG30645@1wt.eu> <20110429100200.GB23293@pcnci.linuxbox.cz>
	 <20110430093605.GA10529@1wt.eu> <20110430173905.GA25641@tty.gr>
	 <BANLkTi=22QFrJ4vO7-3VuHU=9Cg39bxJ4Q@mail.gmail.com>
	 <20110705231515.95bc758f.akpm@linux-foundation.org>
	 <kk5d3hgi9eh.fsf@brer.local.valinux.co.jp>
	 <1310434819.30337.21.camel@work-vm>  <20110712041938.GO27254@1wt.eu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jul 2011 17:35:38 -0700
Message-ID: <1310690138.3367.61.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-12 at 06:19 +0200, Willy Tarreau wrote:
> On Tue, Jul 12, 2011 at 11:49:57AM +0900, MINOURA Makoto / ?$BL'1: ?$B?? wrote:
> > 
> > |> In <1310434819.30337.21.camel@work-vm>
> > |>  john stultz <johnstul@us.ibm.com> wrote:
> > 
> > > I'm working on a debug patch that will hopefully trip sched_clock
> > > overflows very early to see if we can't shake these issues out.
> > 
> > Thanks. I hope that'll help.
> 
> That certainly will. What currently makes this bug hard to fix is that
> it takes around 7 months to test a possible fix. We don't even know if
> more recent kernels are affected, it's possible that 2.6.32-stable is
> the only one that people don't reboot for an update in 7 months :-/
> 
> We need to make this bug more visible, so John's patch will be very
> welcome !

Ok. So this might be long.

So I scratched out a hack that trips the multiplication overflows to
happen after 5 minutes, but found that for my systems, it didn't cause
any strange behavior at all. The reason being that my system
sched_clock_stable is not set, so there are extra corrective layers
going on. 

This likely shows why this issue crops up on some boxes but not others.
Its likely only x86 systems with both X86_FEATURE_TSC_RELIABLE and
X86_FEATURE_CONSTANT_TSC are affected.

Even forcing sched_clock_stable on, I still didn't see any crashes or
oopses with mainline. So I then back ported to 2.6.31, and there I could
only trigger softlockup watchdog warnings (but not crashes).

None the less, adding further debug messages, I did see some odd
behavior from sched_clock around the time the multiplication overflows
happen.


Earlier in this thread, one reporter had the following in their logs
when they hit a softlockup warning:
Apr 18 20:56:07 hn-05 kernel: [17966378.581971] tap0: no IPv6 routers present 
Apr 19 10:15:42 hn-05 kernel: [18446743935.365550] BUG: soft lockup - CPU#4 stuck for 17163091968s! [kvm:25913] 
...
Apr 19 10:18:32 hn-05 kernel: [ 31.587025] bond0.13: received packet with own address as source address 

This was a 2ghz box, so working backward, we know the cyc2ns scale value
is 512, so the cyc2ns equation is (cyc*512)>>10

Well, 64bits divided by 512 is ~36028797018963967 cycles, which is
~18014398 seconds or ~208 days (which lines up closely to the 17966378
printk time above from 20:56:07 - the day before the overflow). 

So on this machines we should expect to see the sched_clock values get
close to 18014398 seconds, and then drop down to a small number and grow
again. Which happens as we see at 10:18:32 timestamp above.

The oddball bit is why the large [18446743935.365550] printk time
in-between when the softlockup occured? Since we're unsigned and
shifting down by 10, we shouldn't be seeing such large numbers!

Well, I reproduced this as well periodically, and it ends up sched_clock
is doing more then (cyc*512)>>10.

Because the freq might change, there's also a normalization done by
adding a cyc2ns_offset value. Well, at boot, this value is miscalculated
on the first cpu, and we end up with a negative value in cyc2ns_offset.

So what we're seeing is the overflow, which is expected, but then the
subtraction rolls the value under and back into a very large number.

So yea, the multiplication overflow is probably hard enough for
sched_clock users to handle, however the extra spike caused by the
subtraction makes it even more complicated.

You can find my current forced-overflow patch and my cyc2ns_offset
initialization fix here (Caution, I may re-base these branches!):
http://git.linaro.org/gitweb?p=people/jstultz/linux.git;a=shortlog;h=refs/heads/dev/uptime-crash


However, as I mentioned in the cyc2ns_offset fix, there's still the
chance for the same thing to occur in other cases where the cpufreq does
change. And this suggests we really need a deeper fix here.

One thought I've had is to rework the sched_clock implementation to be a
bit more like the timekeeping code. However, this requires keeping track
of a bit more data, which then requires fancy atomic updates to
structures using rcu (since we can't do locking with sched_clock), and
probably has some extra overhead.

That said, it avoids having to do the funky offset based normalization
and if we add a very rare periodic timer to do accumulation, we can
avoid the multiplication overflow all together.

I've put together a first pitch at this here (boots, but not robustly
tested):
http://git.linaro.org/gitweb?p=people/jstultz/linux.git;a=shortlog;h=refs/heads/dev/sched_clock-rework

Peter/Ingo: Can you take a look at the above and let me know if you find
it too disagreeable?

thanks
-john

