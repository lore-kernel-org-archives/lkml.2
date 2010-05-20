Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab0ETTxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 15:53:17 -0400
Received: from sprinkles.athenacr.com ([64.95.46.210]:26298 "EHLO
	sprinkles.inp.in.athenacr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757006Ab0ETTxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 15:53:13 -0400
X-Greylist: delayed 1992 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 May 2010 15:53:13 EDT
Message-ID: <4BF58B59.7080901@athenacr.com>
Date: Thu, 20 May 2010 15:19:53 -0400
From: Brian Bloniarz <bmb@athenacr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> The point is for the kernel to not be complicit in 
> practices that are technically not reliable.

One usecase that hasn't been discussed is when userspace needs this info to
calibrate the TSC.

Take NTP as an example. It does a pretty good job of observing the drift in
gettimeofday() against a reference clock and correcting for it. This seems
to work well even when GTOD uses the TSC. But, it assumes that the drift
changes slowly.

That goes out the window on reboot, because the kernel only spends 25ms on
TSC<->PIT calibration and the value of tsc_khz can vary a lot from boot to
boot. Then NTP starts up and reads a drift value from /var/lib/ntp/ntp.drift
that it *thinks* is accurate. In our experience, it'll then spend up to 48
hours doing god knows what to the clock until it converges on the real
drift at the new tsc_khz.  initscripts could correct for the kernel's
recalibration, but tsc_khz isn't exported.

So it's too bad that it can't be exported somehow. The TSC on our
machines has proven to be stable for all intents and purposes; I just
checked 25 of my machines, most have uptime of >200 days, all of them
still have current_clocksource=tsc. After NTP or PTPd has been running
for a while, things converge, but being unable to reboot is a headache.
Using the HPET for gettimeofday() would be impractical for performance
reasons.
