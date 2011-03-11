Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab1CKX1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 18:27:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751147Ab1CKX1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 18:27:51 -0500
Date: Fri, 11 Mar 2011 15:27:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, sboyd@codeaurora.org
Subject: Re: [PATCH 3/4] calibrate: retry with wider bounds when converge
 seems to fail
Message-Id: <20110311152744.ad5ef129.akpm@linux-foundation.org>
In-Reply-To: <1299768487-13200-4-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1299768487-13200-1-git-send-email-ext-phil.2.carmody@nokia.com>
	<1299768487-13200-2-git-send-email-ext-phil.2.carmody@nokia.com>
	<1299768487-13200-3-git-send-email-ext-phil.2.carmody@nokia.com>
	<1299768487-13200-4-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Mar 2011 16:48:06 +0200
Phil Carmody <ext-phil.2.carmody@nokia.com> wrote:

> Systems with unmaskable interrupts such as SMIs may massively underestimate
> loops_per_jiffy, and fail to converge anywhere near the real value. A case
> seen on x86_64 was an initial estimate of 256<<12, which converged to 511<<12
> where the real value should have been over 630<<12. This admitedly requires
> bypassing the TSC calibration (lpj_fine), and a failure to settle in the
> direct calibration too, but is physically possible. This failure does not
> depend on my previous calibration optimisation, but by luck is easy to fix
> with the optimisation in place with a trivial retry loop.
> 
> In the context of the optimised converging method, as we can no longer trust
> the starting estimate, enlarge the search bounds exponentially so that the
> number of retries is logarithmically bounded.
> 
> ...
>
> @@ -165,6 +169,16 @@ static unsigned long __cpuinit calibrate_delay_converge(void)
>  			lpj -= loopadd;
>  		loopadd >>= 1;
>  	}
> +	/*
> +	 * If we incremented every single time possible, presume we've
> +	 * massively underestimated initially, and retry with a higher
> +	 * start, and larger range. (Only seen on x86_64.)
> +	 */
> +	if (lpj + loopadd * 2 == lpj_base + loopadd_base * 2) {
> +		lpj_base = lpj;
> +		loopadd_base <<= 2;
> +		goto recalibrate;
> +	}

This is more informative, no?

--- a/init/calibrate.c~calibrate-retry-with-wider-bounds-when-converge-seems-to-fail-fix
+++ a/init/calibrate.c
@@ -172,7 +172,7 @@ recalibrate:
 	/*
 	 * If we incremented every single time possible, presume we've
 	 * massively underestimated initially, and retry with a higher
-	 * start, and larger range. (Only seen on x86_64.)
+	 * start, and larger range. (Only seen on x86_64, due to SMIs)
 	 */
 	if (lpj + loopadd * 2 == lpj_base + loopadd_base * 2) {
 		lpj_base = lpj;
_

