Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab0IXItQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 04:49:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51876 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab0IXItO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 04:49:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=S3rXicABt0y5xs2YtQqL57+ynTq8WH9lr63CGPxK2gWzLue3JgThKFaaxSvbDeAy0k
         dhBuxglhJW9dCEfibXKYfnzfr89PesDyuvlt2XUOL4Yah5Ph0kr82MLL+V3SlOTTUhJf
         491r/3oQt4SJmmPpXfufemO3OGKO47jqLbzSc=
Date: Fri, 24 Sep 2010 10:49:12 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>,
        John Stultz <johnstul@us.ibm.com>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/8] ptp: Added a clock that uses the eTSEC found on
 the MPC85xx.
Message-ID: <20100924084912.GA15286@riccoc20.at.omicron.at>
References: <cover.1285261533.git.richard.cochran@omicron.at>
 <57b64051c816dc9cb856bbb9f38fc901c9d3d651.1285261535.git.richard.cochran@omicron.at>
 <alpine.DEB.2.00.1009231348150.2962@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1009231348150.2962@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 02:17:36PM -0500, Christoph Lameter wrote:
> On Thu, 23 Sep 2010, Richard Cochran wrote:
> > +  These properties set the operational parameters for the PTP
> > +  clock. You must choose these carefully for the clock to work right.
> > +  Here is how to figure good values:
> > +
> > +  TimerOsc     = system clock               MHz
> > +  tclk_period  = desired clock period       nanoseconds
> > +  NominalFreq  = 1000 / tclk_period         MHz
> > +  FreqDivRatio = TimerOsc / NominalFreq     (must be greater that 1.0)
> > +  tmr_add      = ceil(2^32 / FreqDivRatio)
> > +  OutputClock  = NominalFreq / tmr_prsc     MHz
> > +  PulseWidth   = 1 / OutputClock            microseconds
> > +  FiperFreq1   = desired frequency in Hz
> > +  FiperDiv1    = 1000000 * OutputClock / FiperFreq1
> > +  tmr_fiper1   = tmr_prsc * tclk_period * FiperDiv1 - tclk_period
> > +  max_adj      = 1000000000 * (FreqDivRatio - 1.0) - 1
> 
> Great stuff for clock synchronization...
> 
> > +  The calculation for tmr_fiper2 is the same as for tmr_fiper1. The
> > +  driver expects that tmr_fiper1 will be correctly set to produce a 1
> > +  Pulse Per Second (PPS) signal, since this will be offered to the PPS
> > +  subsystem to synchronize the Linux clock.
> 
> Argh. And conceptually completely screwed up. Why go through the PPS
> subsystem if you can directly tune the system clock based on a number of
> the cool periodic clock features that you have above? See how the other
> clocks do that easily? Look into drivers/clocksource. Add it there.
> 
> Please do not introduce useless additional layers for clock sync. Load
> these ptp clocks like the other regular clock modules and make them sync
> system time like any other clock.
> 
> Really guys: I want a PTP solution! Now! And not some idiotic additional
> kernel layers that just pass bits around because its so much fun and
> screws up clock accurary in due to the latency noise introduced while
> having so much fun with the bits.

(Sorry if this message comes twice. Mutt/Gmail flaked out again.)

I think you misunderstood this particular patch. The device tree
parameters are really just internal driver stuff. When you use the
eTSEC, you must make some design choices at the same time as you plan
your board. The proper values for some of the eTSEC registers are
based on these design choices. Since the Freescale documentation is a
bit thin on this, I added a few notes to help my fellow board
designers.

Because these values are closely related to the board itself, I think
that it is nicer to configure them via the device tree than using
either CONFIG_ variables or platform data.

Richard
