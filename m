Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab0KRWQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 17:16:00 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46866 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab0KRWP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 17:15:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SLgXoDz0+HyH5TRKIzmoH6MgxRL0B3pbs37ZNUA2pSH/jhkhFE0EXB5m+K9UZv8oWY
         oNAZGL4bolyQPer03rf6Le0HRutj9SsmRZ+tNPiuOpK7zSUO8F+KYzXKJT93+H1PwuMp
         xIXCN5DoF9ctYWy9CFDqwFG1lHG81gUkxO7OE=
Date: Fri, 19 Nov 2010 01:15:54 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
Message-ID: <20101118221554.GA31253@lenovo>
References: <20101112161144.GP4823@redhat.com> <4CDD6CAD.30303@windriver.com> <20101112172755.GR4823@redhat.com> <20101116184325.GB4823@redhat.com> <4CE2E3C3.6060800@windriver.com> <20101118080516.GJ32621@elte.hu> <4CE52048.5080802@windriver.com> <1290086232.2109.1507.camel@laptop> <20101118193247.GF18100@redhat.com> <20101118215650.GL6028@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118215650.GL6028@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 12:56:50AM +0300, Cyrill Gorcunov wrote:
...
> ---
>  arch/x86/kernel/cpu/perf_event_p4.c |   21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
> +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> @@ -753,19 +753,22 @@ out:
>  
>  static inline int p4_pmu_clear_cccr_ovf(struct hw_perf_event *hwc)
>  {
> -	int overflow = 0;
> -	u32 low, high;
> +	u32 overflow = 0;
> +	u32 low, low_cccr, high;
>  
> -	rdmsr(hwc->config_base + hwc->idx, low, high);
> +	/* an official way for overflow indication */
> +	rdmsr(hwc->config_base + hwc->idx, low_cccr, high);
> +	overflow |= (low_cccr & P4_CCCR_OVF);
> +
> +	/* unflagged overflows */
> +	rdmsr(hwc->event_base + hwc->idx, low, high);
> +	overflow |= high & 0x80000000;
>  
> -	/* we need to check high bit for unflagged overflows */
> -	if ((low & P4_CCCR_OVF) || !(high & (1 << 31))) {
> -		overflow = 1;
> +	if (overflow)

this should be rather 'if (low_cccr & P4_CCCR_OVF)' otherwise
redundant checking_wrmsrl called, updated patch below

/me seems should not touch code at all today 
---

perf, x86: P4 PMU - Fix unflagged overflows handling

Jason pointed out that kgdb no longer works with new
nmi-watchdog. Don found the reason -- P4 PMU reads CCCR
register instead of counter itself, it forces NMIs to
be eaten by perf subsystem.

Fix it by reading a proper register.

v2: Call checking_wrmsrl only if needed

Reported-by: Jason Wessel <jason.wessel@windriver.com>
Reported-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

Jason I've removed your Tested-by because the patch differ a bit

 arch/x86/kernel/cpu/perf_event_p4.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -753,19 +753,23 @@ out:
 
 static inline int p4_pmu_clear_cccr_ovf(struct hw_perf_event *hwc)
 {
-	int overflow = 0;
-	u32 low, high;
+	u32 overflow = 0;
+	u32 low_cntr, low_cccr, high;
 
-	rdmsr(hwc->config_base + hwc->idx, low, high);
+	/* an official way for overflow indication */
+	rdmsr(hwc->config_base + hwc->idx, low_cccr, high);
+	overflow |= (low_cccr & P4_CCCR_OVF);
 
-	/* we need to check high bit for unflagged overflows */
-	if ((low & P4_CCCR_OVF) || !(high & (1 << 31))) {
-		overflow = 1;
+	if (overflow) {
 		(void)checking_wrmsrl(hwc->config_base + hwc->idx,
-			((u64)low) & ~P4_CCCR_OVF);
+				((u64)low_cccr) & ~P4_CCCR_OVF);
 	}
 
-	return overflow;
+	/* unflagged overflows */
+	rdmsr(hwc->event_base + hwc->idx, low_cntr, high);
+	overflow |= high & 0x80000000;
+
+	return overflow > 0;
 }
 
 static void p4_pmu_disable_pebs(void)
