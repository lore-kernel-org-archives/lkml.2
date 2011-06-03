Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab1FCVBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 17:01:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753670Ab1FCVBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 17:01:44 -0400
Date: Fri, 3 Jun 2011 14:00:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sameer Nanda <snanda@chromium.org>
Cc: ext-phil.2.carmody@nokia.com, Tim.Deegan@citrix.com, jbeulich@novell.com,
        snanda@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] init: skip calibration delay if previously done
Message-Id: <20110603140054.a0f1859d.akpm@linux-foundation.org>
In-Reply-To: <1306279146-23487-1-git-send-email-snanda@chromium.org>
References: <1306279146-23487-1-git-send-email-snanda@chromium.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011 16:19:06 -0700
Sameer Nanda <snanda@chromium.org> wrote:

> For each CPU, do the calibration delay only once. For subsequent calls,
> use the cached per-CPU value of loops_per_jiffy.
> 
> This saves about 200ms of resume time on dual core Intel Atom N5xx based
> systems. This helps bring down the kernel resume time on such systems from
> about 500ms to about 300ms.
> 
> Signed-off-by: Sameer Nanda <snanda@chromium.org>
> ---
>  init/calibrate.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/init/calibrate.c b/init/calibrate.c
> index 76ac919..47d3408 100644
> --- a/init/calibrate.c
> +++ b/init/calibrate.c
> @@ -183,11 +183,18 @@ recalibrate:
>  	return lpj;
>  }
>  
> +DEFINE_PER_CPU(unsigned long, cpu_loops_per_jiffy) = { 0 };
> +
>  void __cpuinit calibrate_delay(void)
>  {
>  	static bool printed;
> +	int this_cpu = smp_processor_id();
>  
> -	if (preset_lpj) {
> +	if (per_cpu(cpu_loops_per_jiffy, this_cpu)) {
> +		loops_per_jiffy = per_cpu(cpu_loops_per_jiffy, this_cpu);
> +		pr_info("Calibrating delay loop (skipped) "
> +				"already calibrated this CPU previously.. ");
> +	} else if (preset_lpj) {
>  		loops_per_jiffy = preset_lpj;
>  		if (!printed)
>  			pr_info("Calibrating delay loop (skipped) "
> @@ -205,6 +212,7 @@ void __cpuinit calibrate_delay(void)
>  			pr_info("Calibrating delay loop... ");
>  		loops_per_jiffy = calibrate_delay_converge();
>  	}
> +	per_cpu(cpu_loops_per_jiffy, this_cpu) = loops_per_jiffy;
>  	if (!printed)
>  		pr_cont("%lu.%02lu BogoMIPS (lpj=%lu)\n",
>  			loops_per_jiffy/(500000/HZ),

Seems reasonable.

On resume, the kernel will print "already calibrated this CPU
previously.." in all situations, such as when preset_lpj was set.  I
don't see a problem with that.

Let's be nice to the namespace:

--- a/init/calibrate.c~init-skip-calibration-delay-if-previously-done-fix
+++ a/init/calibrate.c
@@ -246,7 +246,7 @@ recalibrate:
 	return lpj;
 }
 
-DEFINE_PER_CPU(unsigned long, cpu_loops_per_jiffy) = { 0 };
+static DEFINE_PER_CPU(unsigned long, cpu_loops_per_jiffy) = { 0 };
 
 void __cpuinit calibrate_delay(void)
 {
_

