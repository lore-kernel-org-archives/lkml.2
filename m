Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760631Ab0KRV44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:56:56 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45225 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab0KRV4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:56:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QJGSmhA2ehuy4zAIzGtvMiHnSz3mDkOplN9a/Pc6viF8WeG77OdV3bGDfeznpuWPB9
         JGC5lbcbi/Au27Ey9M8JP1BtBz4Bat50ecO0nB1EcP9GHexr9tZaOhjwoqzv4V3SKiq7
         I0gz/xs4/9WS+M4mfu3qID8EgPIiFiHA7j9WE=
Date: Fri, 19 Nov 2010 00:56:50 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
Message-ID: <20101118215650.GL6028@lenovo>
References: <4CDD6389.2080206@windriver.com> <20101112161144.GP4823@redhat.com> <4CDD6CAD.30303@windriver.com> <20101112172755.GR4823@redhat.com> <20101116184325.GB4823@redhat.com> <4CE2E3C3.6060800@windriver.com> <20101118080516.GJ32621@elte.hu> <4CE52048.5080802@windriver.com> <1290086232.2109.1507.camel@laptop> <20101118193247.GF18100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118193247.GF18100@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 02:32:47PM -0500, Don Zickus wrote:
... 
> On a side note I think I have a fix for the p4 problem but will probably
> need Cyril to look at it.  Basically in, p4_pmu_clear_cccr_ovf() it is
> using the high part of the cccr register to determine if the counter
> overflowed, when it probably wants to use the low bits of the cccr
> register and high bits of the event_base.
>

Thanks a hige Don for pointing to the problem. Here is the patch.
 
  Cyrill
---
perf, x86: P4 PMU - Fix unflagged overflows handling

Jason pointed out that kgdb no longer works with new
nmi-watchdog. Don found the reason -- P4 PMU reads CCCR
register instead of counter itself, it forces NMIs to
be eaten by perf subsystem.

Fix it by reading a proper register.

Reported-by: Jason Wessel <jason.wessel@windriver.com>
Reported-by: Don Zickus <dzickus@redhat.com>
Tested-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/cpu/perf_event_p4.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -753,19 +753,22 @@ out:
 
 static inline int p4_pmu_clear_cccr_ovf(struct hw_perf_event *hwc)
 {
-	int overflow = 0;
-	u32 low, high;
+	u32 overflow = 0;
+	u32 low, low_cccr, high;
 
-	rdmsr(hwc->config_base + hwc->idx, low, high);
+	/* an official way for overflow indication */
+	rdmsr(hwc->config_base + hwc->idx, low_cccr, high);
+	overflow |= (low_cccr & P4_CCCR_OVF);
+
+	/* unflagged overflows */
+	rdmsr(hwc->event_base + hwc->idx, low, high);
+	overflow |= high & 0x80000000;
 
-	/* we need to check high bit for unflagged overflows */
-	if ((low & P4_CCCR_OVF) || !(high & (1 << 31))) {
-		overflow = 1;
+	if (overflow)
 		(void)checking_wrmsrl(hwc->config_base + hwc->idx,
-			((u64)low) & ~P4_CCCR_OVF);
-	}
+			((u64)low_cccr) & ~P4_CCCR_OVF);
 
-	return overflow;
+	return overflow > 0;
 }
 
 static void p4_pmu_disable_pebs(void)
