Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab2BQOQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 09:16:45 -0500
Received: from relay3.sgi.com ([192.48.152.1]:50309 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751862Ab2BQOQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 09:16:44 -0500
Date: Fri, 17 Feb 2012 08:16:41 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, John Stultz <johnstul@us.ibm.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Jack Steiner <steiner@sgi.com>
Subject: Re: [PATCH] x86 uv: lower UV rtc clocksource rating
Message-ID: <20120217141641.GA28063@sgi.com>
References: <20120216201042.GA10260@sgi.com>
 <20120217120242.GC25601@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217120242.GC25601@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 01:02:42PM +0100, Ingo Molnar wrote:
> 
> * Dimitri Sivanich <sivanich@sgi.com> wrote:
> 
> > Lower the rating of the UV rtc clocksource to just below that of the tsc.
> 
> This changelog is deficient for obvious reasons, mind updating 
> it?
>
OK.  Is this sufficient?


Lower the rating of the UV rtc clocksource to just below that of the tsc.

Reading the tsc clocksource has lower latency than reading the rtc, so favor
it in situations where it is synchronized and stable.  When the tsc is
unsynchronized, the rtc needs to be the chosen clocksource.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
---
 arch/x86/platform/uv/uv_time.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

Index: linux/arch/x86/platform/uv/uv_time.c
===================================================================
--- linux.orig/arch/x86/platform/uv/uv_time.c
+++ linux/arch/x86/platform/uv/uv_time.c
@@ -37,7 +37,7 @@ static void uv_rtc_timer_setup(enum cloc
 
 static struct clocksource clocksource_uv = {
 	.name		= RTC_NAME,
-	.rating		= 400,
+	.rating		= 299,
 	.read		= uv_read_rtc,
 	.mask		= (cycle_t)UVH_RTC_REAL_TIME_CLOCK_MASK,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
@@ -379,10 +379,6 @@ static __init int uv_rtc_setup_clock(voi
 	if (!is_uv_system())
 		return -ENODEV;
 
-	/* If single blade, prefer tsc */
-	if (uv_num_possible_blades() == 1)
-		clocksource_uv.rating = 250;
-
 	rc = clocksource_register_hz(&clocksource_uv, sn_rtc_cycles_per_second);
 	if (rc)
 		printk(KERN_INFO "UV RTC clocksource failed rc %d\n", rc);
