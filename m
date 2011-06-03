Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab1FCVpy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 17:45:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753622Ab1FCVpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 17:45:52 -0400
Date: Fri, 3 Jun 2011 14:45:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Sameer Nanda <snanda@chromium.org>, ext-phil.2.carmody@nokia.com,
        Tim.Deegan@citrix.com, jbeulich@novell.com, snanda@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] init: skip calibration delay if previously done
Message-Id: <20110603144540.d182c231.akpm@linux-foundation.org>
In-Reply-To: <4DE94D31.3040104@caviumnetworks.com>
References: <1306279146-23487-1-git-send-email-snanda@chromium.org>
	<20110603140054.a0f1859d.akpm@linux-foundation.org>
	<4DE94D31.3040104@caviumnetworks.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Jun 2011 14:08:01 -0700
David Daney <ddaney@caviumnetworks.com> wrote:

> On 06/03/2011 02:00 PM, Andrew Morton wrote:
> > On Tue, 24 May 2011 16:19:06 -0700
> > Sameer Nanda<snanda@chromium.org>  wrote:
> >
> >> For each CPU, do the calibration delay only once. For subsequent calls,
> >> use the cached per-CPU value of loops_per_jiffy.
> >>
> >> This saves about 200ms of resume time on dual core Intel Atom N5xx based
> >> systems. This helps bring down the kernel resume time on such systems from
> >> about 500ms to about 300ms.
> >>
> >> Signed-off-by: Sameer Nanda<snanda@chromium.org>
> >> ---
> >>   init/calibrate.c |   10 +++++++++-
> >>   1 files changed, 9 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/init/calibrate.c b/init/calibrate.c
> >> index 76ac919..47d3408 100644
> >> --- a/init/calibrate.c
> >> +++ b/init/calibrate.c
> >> @@ -183,11 +183,18 @@ recalibrate:
> >>   	return lpj;
> >>   }
> >>
> >> +DEFINE_PER_CPU(unsigned long, cpu_loops_per_jiffy) = { 0 };
> >> +
> >>   void __cpuinit calibrate_delay(void)
> >>   {
> >>   	static bool printed;
> >> +	int this_cpu = smp_processor_id();
> >>
> >> -	if (preset_lpj) {
> >> +	if (per_cpu(cpu_loops_per_jiffy, this_cpu)) {
> >> +		loops_per_jiffy = per_cpu(cpu_loops_per_jiffy, this_cpu);
> >> +		pr_info("Calibrating delay loop (skipped) "
> >> +				"already calibrated this CPU previously.. ");
> 
> That wording seems a little redundant, and there are two '.' at the end.
> 
> How about:
> s/"already calibrated this CPU previously.. "/", this CPU previously 
> calibrated."/
> 

Pedant ;)

--- a/init/calibrate.c~init-skip-calibration-delay-if-previously-done-fix-fix
+++ a/init/calibrate.c
@@ -256,7 +256,7 @@ void __cpuinit calibrate_delay(void)
 	if (per_cpu(cpu_loops_per_jiffy, this_cpu)) {
 		loops_per_jiffy = per_cpu(cpu_loops_per_jiffy, this_cpu);
 		pr_info("Calibrating delay loop (skipped) "
-				"already calibrated this CPU previously.. ");
+				"already calibrated this CPU");
 	} else if (preset_lpj) {
 		loops_per_jiffy = preset_lpj;
 		if (!printed)
_

But the whole thing is a bit weird.  Does this look better?

From: Andrew Morton <akpm@linux-foundation.org>

Make these messages more gramatically pleasing, more consistent and remove
strange ellipses.

Cc: Andrew Worsley <amworsley@gmail.com>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: Sameer Nanda <snanda@chromium.org>
Cc: David Daney <ddaney@caviumnetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/calibrate.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN init/calibrate.c~init-calibratec-calibrate_delay-tidy-up-the-pr_info-messages init/calibrate.c
--- a/init/calibrate.c~init-calibratec-calibrate_delay-tidy-up-the-pr_info-messages
+++ a/init/calibrate.c
@@ -255,24 +255,24 @@ void __cpuinit calibrate_delay(void)
 
 	if (per_cpu(cpu_loops_per_jiffy, this_cpu)) {
 		loops_per_jiffy = per_cpu(cpu_loops_per_jiffy, this_cpu);
-		pr_info("Calibrating delay loop (skipped) "
-				"already calibrated this CPU");
+		pr_info("Calibrating delay loop.  Skipped: already calibrated "
+				"this CPU");
 	} else if (preset_lpj) {
 		loops_per_jiffy = preset_lpj;
 		if (!printed)
-			pr_info("Calibrating delay loop (skipped) "
-				"preset value.. ");
+			pr_info("Calibrating delay loop.  Skipped: "
+				"preset value");
 	} else if ((!printed) && lpj_fine) {
 		loops_per_jiffy = lpj_fine;
-		pr_info("Calibrating delay loop (skipped), "
-			"value calculated using timer frequency.. ");
+		pr_info("Calibrating delay loop.  Skipped: value calculated "
+				"using timer frequency");
 	} else if ((loops_per_jiffy = calibrate_delay_direct()) != 0) {
 		if (!printed)
-			pr_info("Calibrating delay using timer "
-				"specific routine.. ");
+			pr_info("Calibrating delay loop using timer-specific "
+					"routine");
 	} else {
 		if (!printed)
-			pr_info("Calibrating delay loop... ");
+			pr_info("Calibrating delay loop");
 		loops_per_jiffy = calibrate_delay_converge();
 	}
 	per_cpu(cpu_loops_per_jiffy, this_cpu) = loops_per_jiffy;
_

