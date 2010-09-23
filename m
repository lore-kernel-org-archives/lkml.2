Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab0IWTp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 15:45:56 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:25724 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755448Ab0IWTpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 15:45:54 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: _pr6rXkVM1n2GVKsJ9mbohHHpfGohvbSzLjSFLVBnZFXUfM
 elPmXj8hVKdPinKjmVPiNMsuIFhJFLCDIFjtaMXNFiBv5bcbOJBkOOmmGfNN
 tv0vinOCESmMmwPumTr8tBg622HhnW8.ma1TWvAt40Pdmae_vsaWTn__ExHk
 wWPjqElityQCgByjwkfSQ2o7p5cckAcDr7vnWljlmLMaqjjKHxWq5eZfZsps
 xhAk4zMTVfHh1PwU1wNcr1KUEPXd_m9ZdLopFSe8-
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 23 Sep 2010 14:17:36 -0500 (CDT)
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
Subject: Re: [PATCH 6/8] ptp: Added a clock that uses the eTSEC found on the
 MPC85xx.
In-Reply-To: <57b64051c816dc9cb856bbb9f38fc901c9d3d651.1285261535.git.richard.cochran@omicron.at>
Message-ID: <alpine.DEB.2.00.1009231348150.2962@router.home>
References: <cover.1285261533.git.richard.cochran@omicron.at> <57b64051c816dc9cb856bbb9f38fc901c9d3d651.1285261535.git.richard.cochran@omicron.at>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Sep 2010, Richard Cochran wrote:

> +* Gianfar PTP clock nodes
> +
> +General Properties:
> +
> +  - compatible   Should be "fsl,etsec-ptp"
> +  - reg          Offset and length of the register set for the device
> +  - interrupts   There should be at least two interrupts. Some devices
> +                 have as many as four PTP related interrupts.
> +
> +Clock Properties:
> +
> +  - tclk-period  Timer reference clock period in nanoseconds.
> +  - tmr-prsc     Prescaler, divides the output clock.
> +  - tmr-add      Frequency compensation value.
> +  - cksel        0= external clock, 1= eTSEC system clock, 3= RTC clock input.
> +                 Currently the driver only supports choice "1".
> +  - tmr-fiper1   Fixed interval period pulse generator.
> +  - tmr-fiper2   Fixed interval period pulse generator.
> +  - max-adj      Maximum frequency adjustment in parts per billion.
> +
> +  These properties set the operational parameters for the PTP
> +  clock. You must choose these carefully for the clock to work right.
> +  Here is how to figure good values:
> +
> +  TimerOsc     = system clock               MHz
> +  tclk_period  = desired clock period       nanoseconds
> +  NominalFreq  = 1000 / tclk_period         MHz
> +  FreqDivRatio = TimerOsc / NominalFreq     (must be greater that 1.0)
> +  tmr_add      = ceil(2^32 / FreqDivRatio)
> +  OutputClock  = NominalFreq / tmr_prsc     MHz
> +  PulseWidth   = 1 / OutputClock            microseconds
> +  FiperFreq1   = desired frequency in Hz
> +  FiperDiv1    = 1000000 * OutputClock / FiperFreq1
> +  tmr_fiper1   = tmr_prsc * tclk_period * FiperDiv1 - tclk_period
> +  max_adj      = 1000000000 * (FreqDivRatio - 1.0) - 1

Great stuff for clock synchronization...

> +  The calculation for tmr_fiper2 is the same as for tmr_fiper1. The
> +  driver expects that tmr_fiper1 will be correctly set to produce a 1
> +  Pulse Per Second (PPS) signal, since this will be offered to the PPS
> +  subsystem to synchronize the Linux clock.

Argh. And conceptually completely screwed up. Why go through the PPS
subsystem if you can directly tune the system clock based on a number of
the cool periodic clock features that you have above? See how the other
clocks do that easily? Look into drivers/clocksource. Add it there.

Please do not introduce useless additional layers for clock sync. Load
these ptp clocks like the other regular clock modules and make them sync
system time like any other clock.

Really guys: I want a PTP solution! Now! And not some idiotic additional
kernel layers that just pass bits around because its so much fun and
screws up clock accurary in due to the latency noise introduced while
having so much fun with the bits.
