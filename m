Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705Ab1CWVRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 17:17:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754434Ab1CWVQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 17:16:59 -0400
Date: Wed, 23 Mar 2011 17:16:56 -0400
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Ingo Molnar <mingo@redhat.com>, Lin Ming <ming.m.lin@intel.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] kgdb, x86: Pull up NMI notifier handler priority
Message-ID: <20110323211656.GA29184@redhat.com>
References: <4D8A58E1.5090509@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8A58E1.5090509@openvz.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 11:32:33PM +0300, Cyrill Gorcunov wrote:
> kgdb needs IPI to be sent and handled before perf
> or anything else NMI, otherwise kgdb hangs with bootup
> self-tests (found on P4 HT SMP machine). Raise its priority
> so that we're called first in a notifier chain.

This is only because P4 perf swallows all the nmis.  If that is the case
you are arguing to make the perf nmi at the bottom of the priority list,
which is probably not where it should be due to its volume.

I am stuck debugging P4 problems again for RHEL-6 and I noticed a small
change that is needed (didn't help my problem though) but it looked like
an oversight that might help your case.

Cheers,
Don


diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 3769ac8..d945314 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -777,6 +787,7 @@ static inline int p4_pmu_clear_cccr_ovf(struct hw_perf_event *hwc)
 	 * the counter has reached zero value and continued counting before
 	 * real NMI signal was received:
 	 */
+	rdmsrl(hwc->event_base, v);
 	if (!(v & ARCH_P4_UNFLAGGED_BIT))
 		return 1;
 
