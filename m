Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab1EaL7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 07:59:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:35335 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab1EaL7E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 07:59:04 -0400
Subject: Re: Fix for critical bogoMIPS intermittent calculation failure
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Worsley <amworsley@gmail.com>, linux-kernel@vger.kernel.org,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>
In-Reply-To: <20110407151745.d2e682c6.akpm@linux-foundation.org>
References: <AANLkTikTjBAZGBF2BirRpayiL6PX=ewmh+ZEnZkZBr=s@mail.gmail.com>
	 <20110407151745.d2e682c6.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 31 May 2011 13:58:45 +0200
Message-ID: <1306843125.2353.7.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-07 at 15:17 -0700, Andrew Morton wrote:
> On Thu, 10 Mar 2011 17:03:51 +1100
> Andrew Worsley <amworsley@gmail.com> wrote:
> 

> Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  init/calibrate.c |   70 +++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 65 insertions(+), 5 deletions(-)
> 
> diff -puN init/calibrate.c~init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure init/calibrate.c
> --- a/init/calibrate.c~init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure
> +++ a/init/calibrate.c
> @@ -38,6 +38,9 @@ static unsigned long __cpuinit calibrate
>  	unsigned long timer_rate_min, timer_rate_max;
>  	unsigned long good_timer_sum = 0;
>  	unsigned long good_timer_count = 0;
> +	unsigned long measured_times[MAX_DIRECT_CALIBRATION_RETRIES];
> +	int max = -1; /* index of measured_times with max/min values or not set */
> +	int min = -1;
>  	int i;
>  
>  	if (read_current_timer(&pre_start) < 0 )
> @@ -90,17 +93,74 @@ static unsigned long __cpuinit calibrate
>  		 * If the upper limit and lower limit of the timer_rate is
>  		 * >= 12.5% apart, redo calibration.
>  		 */
> -		if (pre_start != 0 && pre_end != 0 &&
> +		printk(KERN_DEBUG
> +"calibrate_delay_direct() timer_rate_max=%lu timer_rate_min=%lu pre_start=%lu pre_end=%lu\n",
> +			  timer_rate_max, timer_rate_min, pre_start, pre_end);


Can we please remove this printk(), I'm not really enjoying the 120
lines of dmesg spew this creates on my dev-box.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 init/calibrate.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/init/calibrate.c b/init/calibrate.c
index cfd7000..a24efd3 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -93,14 +93,12 @@ static unsigned long __cpuinit calibrate_delay_direct(void)
 		 * If the upper limit and lower limit of the timer_rate is
 		 * >= 12.5% apart, redo calibration.
 		 */
-		printk(KERN_DEBUG "calibrate_delay_direct() timer_rate_max=%lu "
-			    "timer_rate_min=%lu pre_start=%lu pre_end=%lu\n",
-			  timer_rate_max, timer_rate_min, pre_start, pre_end);
-		if (start >= post_end)
+		if (start >= post_end) {
 			printk(KERN_NOTICE "calibrate_delay_direct() ignoring "
 					"timer_rate as we had a TSC wrap around"
 					" start=%lu >=post_end=%lu\n",
 				start, post_end);
+		}
 		if (start < post_end && pre_start != 0 && pre_end != 0 &&
 		    (timer_rate_max - timer_rate_min) < (timer_rate_max >> 3)) {
 			good_timer_count++;

