Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab0IWRx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 13:53:26 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:30471 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755775Ab0IWRxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 13:53:25 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: neWwWSsVM1lFrBIDUzAFPew4eH0gG9cVpL.4VHPg3pX94xW
 RG4F3wv4M0SemqEhhIMgIPJNTBUdfZ6fvG68WpU.rAb6Qoik5hK9ulhaGDOn
 aAEPhNOC_R2Ip3RtvBob1FfP849K737tWT0Uk_j_PP.EYFag_nVzHBVlaqt3
 RNh6zXEKVy21voUU7IGofGenKRiYrNa2bOaoV_YJV6L7Rn0QWNA63MI0S_I5
 ZdsCmTRua32ya76LK90tOGXpOWvPP
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 23 Sep 2010 12:53:20 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Richard Cochran <richardcochran@gmail.com>
cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>,
        John Stultz <johnstul@us.ibm.com>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v6 0/8] ptp: IEEE 1588 hardware clock support
In-Reply-To: <cover.1285261533.git.richard.cochran@omicron.at>
Message-ID: <alpine.DEB.2.00.1009231238170.2962@router.home>
References: <cover.1285261533.git.richard.cochran@omicron.at>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Sep 2010, Richard Cochran wrote:

>   Support for obtaining timestamps from a PHC already exists via the
>   SO_TIMESTAMPING socket option, integrated in kernel version 2.6.30.
>   This patch set completes the picture by allow user space programs to
>   adjust the PHC and to control its ancillary features.

Is there a way to use the PHC as a system clock? I think the main benefit
of PTP is to have syncronized time on multiple machines in a cluster. That
may mean getting rid of ntp and using an in kernel PHC based way to sync time.

>    So as far as the POSIX standard is concerned, offering a clock id
>    to represent the PHC would be acceptable.

Sure but what would you do with it? HPET timer support has no such need.

> 3.2.1 Using the POSIX Clock API
> --------------------------------
>
>     Looking at the mapping from PHC operation to the POSIX clock API,
>     we see that two of the basic clock operations, marked with *, have
>     no POSIX equivalent. The items marked NA are peculiar to PHCs and
>     will be discussed separately, below.
>
>       Clock Operation               POSIX function
>      -----------------------------+-----------------------------
>       Set time                      clock_gettime
>       Get time                      clock_settime
>       Shift the clock               *
>       Adjust clock frequency        *
>      -----------------------------+-----------------------------
>       Time stamp external events    NA
>       Enable PPS events             NA
>       Periodic output signals       NA
>       One shot or periodic alarms   timer_create, timer_settime
>
>     In contrast to the standard Linux system clock, a PHC is
>     adjustable in hardware, for example using frequency compensation
>     registers or a VCO. The ability to directly tune the PHC is
>     essential to reap the benefit of hardware timestamping.

There is a reason for not being able to shift posix clocks: The system has
one time base. The various clocks are contributing to maintaining that
sytem wide time.

I do not understand why you want to maintain different clocks running at
different speeds. Certainly interesting for some uses I guess that I
do not have the energy to imagine right now. But can we get the PTP killer
feature of synchronized accurate system time first?

> 3.3 Synchronizing the Linux System Time
> ========================================
>
>    One could offer a PHC as a combined clock source and clock event
>    device. The advantage of this approach would be that it obviates
>    the need for synchronization when the PHC is selected as the system
>    timer. However, some PHCs, namely the PHY based clocks, cannot be
>    used in this way.

Why not? Do PHY based clock not at least provide a counter that increments
in synchronized intervals throughout the network?

>    Instead, the patch set provides a way to offer a Pulse Per Second
>    (PPS) event from the PHC to the Linux PPS subsystem. A user space
>    application can read the PPS events and tune the system clock, just
>    like when using other external time sources like radio clocks or
>    GPS.

User space is subject to various latencies created by the OS etc. I would
that in order to have fine grained (read microsecond) accurary we would
have to run the portions that are relevant to obtaining the desired
accuracy in the kernel.

