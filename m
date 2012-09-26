Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab2IZLUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 07:20:18 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48556 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754077Ab2IZLUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 07:20:16 -0400
Message-ID: <1348658416.2648.22.camel@joe-AO722>
Subject: Re: [PATCH] x86, tsc: downgrade message for fast calibration failure
From: Joe Perches <joe@perches.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 26 Sep 2012 04:20:16 -0700
In-Reply-To: <1348654189.1664.12.camel@x61.thuisdomein>
References: <1348654189.1664.12.camel@x61.thuisdomein>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-26 at 12:09 +0200, Paul Bolle wrote:
> When fast calibration of the TSC fails an error is printed:
>     tsc: Fast TSC calibration failed
[]
> 1) By the way, it's debatable whether this message should be printed at
> informational or at notice level. But the difference between KERN_NOTICE
> and KERN_INFO is too subtle for me. I even find the difference between
> KERN_ALERT and KERN_CRIT, and between KERN_ERR and KERN_WARNING a bit
> subtle. Are there guidelines for choosing between those levels?

The only guidelines I know are the comments in kern_levels.h
and Documentation/kernel-parameters.txt

#define KERN_EMERG	KERN_SOH "0"	/* system is unusable */
#define KERN_ALERT	KERN_SOH "1"	/* action must be taken immediately */
#define KERN_CRIT	KERN_SOH "2"	/* critical conditions */
#define KERN_ERR	KERN_SOH "3"	/* error conditions */
#define KERN_WARNING	KERN_SOH "4"	/* warning conditions */
#define KERN_NOTICE	KERN_SOH "5"	/* normal but significant condition */
#define KERN_INFO	KERN_SOH "6"	/* informational */
#define KERN_DEBUG	KERN_SOH "7"	/* debug-level messages */

> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
[]
> @@ -374,7 +374,7 @@ static unsigned long quick_pit_calibrate(void)
>  			goto success;
>  		}
>  	}
> -	pr_err("Fast TSC calibration failed\n");
> +	pr_info("Fast TSC calibration failed\n");
>  	return 0;

Perhaps wordsmithing failed to unsuccessful might make
the message seem less like an error and more like an
ordinary occurrence.

Perhaps:

 arch/x86/kernel/tsc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index cfa5d4f..4e22540 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -374,7 +374,7 @@ static unsigned long quick_pit_calibrate(void)
 			goto success;
 		}
 	}
-	pr_err("Fast TSC calibration failed\n");
+	pr_info("Fast TSC calibration unsuccessful\n");
 	return 0;
 
 success:
@@ -521,7 +521,7 @@ unsigned long native_calibrate_tsc(void)
 
 		/* The alternative source failed as well, disable TSC */
 		if (tsc_ref_min == ULONG_MAX) {
-			pr_warn("HPET/PMTIMER calibration failed\n");
+			pr_warn("HPET/PMTIMER calibration unsuccessful\n");
 			return 0;
 		}
 
@@ -540,7 +540,7 @@ unsigned long native_calibrate_tsc(void)
 
 	/* The alternative source failed, use the PIT calibration value */
 	if (tsc_ref_min == ULONG_MAX) {
-		pr_warn("HPET/PMTIMER calibration failed. Using PIT calibration.\n");
+		pr_warn("HPET/PMTIMER calibration unsuccessful. Using PIT calibration.\n");
 		return tsc_pit_min;
 	}
 


