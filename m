Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483Ab1KVLpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 06:45:53 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40678 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051Ab1KVLpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 06:45:51 -0500
Date: Tue, 22 Nov 2011 12:45:49 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, len.brown@intel.com,
        tj@kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] PM / Hibernation: Fix *massive* memory leak at early
 exits in hibernation
Message-ID: <20111122114549.GC32023@elf.ucw.cz>
References: <20111121173939.9486.38357.stgit@srivatsabhat.in.ibm.com>
 <201111212325.39330.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111212325.39330.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2011-11-21 23:25:39, Rafael J. Wysocki wrote:
> On Monday, November 21, 2011, Srivatsa S. Bhat wrote:
> > At some of the early exit points during hibernation (exiting either due
> > to failure or after a successful hibernation test, the memory pre-allocated
> > for hibernation is not freed up. And this is *very* serious, because, during
> > pre-allocation, it could have allocated upto a few *gigabytes* of memory!
> > And hence, if a hibernation fails or even if we run some hibernation tests
> > using the 'pm_test' framework, the system is rendered unstable due to memory
> > becoming signifantly lower. Fix this bug.
> 
> While the observation is valid, I'd prefer to do something like the patch
> below.

The code slowly becomes goto maze :-(.

> @@ -357,12 +357,14 @@ int hibernation_snapshot(int platform_mo
>  		 * successful freezer test.
>  		 */
>  		freezer_test_done = true;
> -		goto Close;
> +		goto Cleanup;
>  	}
>  
>  	error = dpm_prepare(PMSG_FREEZE);
> -	if (error)
> -		goto Complete_devices;
> +	if (error) {
> +		dpm_complete(msg);
> +		goto Cleanup;
> +	}

Perhaps dpm_prepare should be changed to clean after itself in the
error case? That is the normal convention AFAICT....

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
