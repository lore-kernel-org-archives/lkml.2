Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab1FCWAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 18:00:15 -0400
Received: from mail.perches.com ([173.55.12.10]:2507 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753770Ab1FCWAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 18:00:11 -0400
Subject: Re: [PATCH] init: skip calibration delay if previously done
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Daney <ddaney@caviumnetworks.com>,
        Sameer Nanda <snanda@chromium.org>, ext-phil.2.carmody@nokia.com,
        Tim.Deegan@citrix.com, jbeulich@novell.com, snanda@google.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110603144540.d182c231.akpm@linux-foundation.org>
References: <1306279146-23487-1-git-send-email-snanda@chromium.org>
	 <20110603140054.a0f1859d.akpm@linux-foundation.org>
	 <4DE94D31.3040104@caviumnetworks.com>
	 <20110603144540.d182c231.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Jun 2011 15:00:09 -0700
Message-ID: <1307138409.14598.52.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-03 at 14:45 -0700, Andrew Morton wrote:
> But the whole thing is a bit weird.  Does this look better?
> Make these messages more gramatically pleasing, more consistent and remove
> strange ellipses.

or maybe something like this:

 init/calibrate.c |   34 ++++++++++++++++++++--------------
 1 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/init/calibrate.c b/init/calibrate.c
index cfd7000..827a45c 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -246,32 +246,38 @@ recalibrate:
 	return lpj;
 }
 
+static DEFINE_PER_CPU(unsigned long, cpu_loops_per_jiffy) = { 0 };
+
 void __cpuinit calibrate_delay(void)
 {
+	int this_cpu = smp_processor_id();
 	static bool printed;
+	const char *msg;
 
-	if (preset_lpj) {
+	if (per_cpu(cpu_loops_per_jiffy, this_cpu)) {
+		loops_per_jiffy = per_cpu(cpu_loops_per_jiffy, this_cpu);
+		msg = " CPU previously calibrated";
+	} else if (preset_lpj) {
 		loops_per_jiffy = preset_lpj;
-		if (!printed)
-			pr_info("Calibrating delay loop (skipped) "
-				"preset value.. ");
+		msg = " preset value";
 	} else if ((!printed) && lpj_fine) {
 		loops_per_jiffy = lpj_fine;
-		pr_info("Calibrating delay loop (skipped), "
-			"value calculated using timer frequency.. ");
+		msg = " using timer frequency";
 	} else if ((loops_per_jiffy = calibrate_delay_direct()) != 0) {
-		if (!printed)
-			pr_info("Calibrating delay using timer "
-				"specific routine.. ");
+		msg = " using timer specific routine";
 	} else {
-		if (!printed)
-			pr_info("Calibrating delay loop... ");
+		pr_info("Calibrating delay loop...\n");
 		loops_per_jiffy = calibrate_delay_converge();
+		per_cpu(cpu_loops_per_jiffy, this_cpu) = loops_per_jiffy;
+		msg = "";
 	}
-	if (!printed)
-		pr_cont("%lu.%02lu BogoMIPS (lpj=%lu)\n",
+
+	if (!printed) {
+		pr_info("Delay loop calibration:%s %lu.%02lu BogoMIPS (lpj=%lu)\n",
+			msg,
 			loops_per_jiffy/(500000/HZ),
 			(loops_per_jiffy/(5000/HZ)) % 100, loops_per_jiffy);
 
-	printed = true;
+		printed = true;
+	}
 }


