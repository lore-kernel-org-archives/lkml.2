Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244Ab0I0QZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 12:25:52 -0400
Received: from bsdimp.com ([199.45.160.85]:55891 "EHLO harmony.bsdimp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932754Ab0I0QZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 12:25:51 -0400
Date: Mon, 27 Sep 2010 10:14:23 -0600 (MDT)
Message-Id: <20100927.101423.702773873740300798.imp@bsdimp.com>
To: cl@linux.com
Cc: johnstul@us.ibm.com, giometti@linux.it, peterz@infradead.org,
        linux-api@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, tglx@linutronix.de,
        linuxppc-dev@lists.ozlabs.org, richardcochran@gmail.com,
        linux-arm-kernel@lists.infradead.org, khc@pm.waw.pl
Subject: Re: [PATCH v6 0/8] ptp: IEEE 1588 hardware clock support
From: "M. Warner Losh" <imp@bsdimp.com>
In-Reply-To: <alpine.DEB.2.00.1009271038150.9258@router.home>
References: <alpine.DEB.2.00.1009231533040.7522@router.home>
	<1285278136.2587.154.camel@localhost.localdomain>
	<alpine.DEB.2.00.1009271038150.9258@router.home>
X-Mailer: Mew version 6.3 on Emacs 22.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message: <alpine.DEB.2.00.1009271038150.9258@router.home>
            Christoph Lameter <cl@linux.com> writes:
: On Thu, 23 Sep 2010, john stultz wrote:
: > The design actually avoids most userland induced latency.
: >
: > 1) On the PTP hardware syncing point, the reference packet gets
: > timestamped with the PTP hardware time on arrival. This allows the
: > offset calculation to be done in userland without introducing latency.
: 
: The timestamps allows the calculation of the network transmission time I
: guess and therefore its more accurate to calculate that effect out. Ok but
: then the overhead of getting to code in user space (that does the proper
: clock adjustments) is resulting in the addition of a relatively long time
: that is subject to OS scheduling latencies and noises.

The timestamps at the hardware level allow you to factor out variation
caused by OS Scheduling, OS network stack delay and internal buffering
on the NIC.  Variation in measurements is what kills accuracy.

When steering a clock by making an error measurement of the phase and
frequency of it, the latency induced by OS scheduling tends to be
unimportant.  It is far more important to know when you steered the
clock (called adjtime or friends) than to steer it at any fixed
latency to when the data for the measurements was made.  Measuring the
time of steer can tolerate errors in the range of OS scheduling
latencies easily, since that tends to produce a very small effect.  It
introduces an error in your expected phase for the next measurement on
the order of the product of the time of steer error times the change
in fractional frequency (abs( 1 - (nu_new / nu_old))).  Even if the
estimate is really bad at 100ms, most steers are on the order about
one part per million.  This leads to a sub-nanosecond phase error
estimate in the next measurement cycle (a non-accumulating error).  A
1ms error leads to maybe tens of picoseconds of estimate error.

This is a common error that I've seen repeated in this thread.  The
only reason that it has historically been important is because when
you are doing timestamping in software based on an interrupt, that
stuff does matter.

Warner
