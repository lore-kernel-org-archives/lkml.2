Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099Ab0I0PwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 11:52:12 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:47301 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755550Ab0I0PwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 11:52:10 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: izkq7KAVM1ltRg.q81tPkRSd4btDUdmn0x4HjXqIumjSaYo
 y3IwgMzq3ILZfCrctJjr82ewQiGpYU57gYbyEVvi1.cWurTOEb31xG5hh75q
 N6D.YQUYnNSypIFaO7If2HIs_WzD80JTCKg2HAsX8SjPWZVFL5QolqSep_ca
 .4qSKqsQfWMAjNyp3Or.mMsj8oYKS17UUCnuxKnYvzW95wh.QeXzq9Q7nUHA
 GOMBjequ4cls7PKcX6_nPWHzHgUqs
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 27 Sep 2010 10:52:02 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: john stultz <johnstul@us.ibm.com>
cc: Richard Cochran <richardcochran@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-api@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        David Miller <davem@davemloft.net>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v6 0/8] ptp: IEEE 1588 hardware clock support
In-Reply-To: <1285278136.2587.154.camel@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1009271038150.9258@router.home>
References: <cover.1285261533.git.richard.cochran@omicron.at>  <alpine.DEB.2.00.1009231238170.2962@router.home>  <1285268380.2587.11.camel@localhost.localdomain>  <alpine.DEB.2.00.1009231402420.2962@router.home>  <1285273684.2587.92.camel@localhost.localdomain>
  <alpine.DEB.2.00.1009231533040.7522@router.home> <1285278136.2587.154.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Sep 2010, john stultz wrote:

> > > 3) Further, the PTP hardware counter can be simply set to a new offset
> > > to put it in line with the network time. This could cause trouble with
> > > timekeeping much like unsynced TSCs do.
> >
> > You can do the same for system time.
>
> Settimeofday does allow CLOCK_REALTIME to jump, but the CLOCK_MONOTONIC
> time cannot jump around. Having a clocksource that is non-monotonic
> would break this.

Currently time runs at the same speed. CLOCK_MONOTONIC runs at a offset
to CLOCK_REALTIME. We are creating APIs here that allow time to run at
different speeds.

> The design actually avoids most userland induced latency.
>
> 1) On the PTP hardware syncing point, the reference packet gets
> timestamped with the PTP hardware time on arrival. This allows the
> offset calculation to be done in userland without introducing latency.

The timestamps allows the calculation of the network transmission time I
guess and therefore its more accurate to calculate that effect out. Ok but
then the overhead of getting to code in user space (that does the proper
clock adjustments) is resulting in the addition of a relatively long time
that is subject to OS scheduling latencies and noises.

> 2) On the system syncing side, the proposal for the PPS interrupt allows
> the PTP hardware to trigger an interrupt on the second boundary that
> would take a timestamp of the system time. Then the pps interface allows
> for the timestamp to be read from userland allowing the offset to be
> calculated without introducing additional latency.

Sorry dont really get the whole picture here it seems. Sounds like one is
going through additional unnecessary layers. Why would the PTP hardware
triggger an interrupt? I thought the PTP messages came in via
timestamping and are then processed by software. Then the software is
issuing a hardware interrupt that then triggers the PPS subsystem. And
that is supposed to be better than directly interfacing with the PTP?


> Additionally, even just in userland, it would be easy to bracket two
> reads of the system time around one read of the PTP clock to bound any
> userland latency fairly well. It may not be as good as the PPS interface
> (although that depends on the interrupt latency), but if the accesses
> are all local, it probably could get fairly close.

That sounds hacky.

> > Ok maybe we need some sort of control interface to manage the clock like
> > the others have.
>
> That's what the clock_adjtime call provides.

Ummm... You are managing a hardware device with hardware (driver) specific
settings. That is currently being done via ioctls. Why generalize it?

> > The posix clocks today assumes one notion of real "time" in the kernel.
> > All clocks increase in lockstep (aside from offset updates).
>
> Not true. The cputime clockids do not increment at the same rate (as the
> apps don't always run). Further CLOCK_MONOTONIC_RAW provides a non-freq
> corrected view of CLOCK_MONOTONIC, so it increments at a slightly
> different rate.

cputime clockids are not tracking time but cpu resource use.

> Re-using the fairly nice (Alan of course disagrees :) posix interface
> seems at least a little better for application developers who actually
> have to use the hardware.

Well it may also be confusing for others. The application developers also
will have a hard time using a generic clock interface to control PTP
device specific things like frequencies, rates etc etc. So you always need
to ioctl/device specific control interface regardless.



