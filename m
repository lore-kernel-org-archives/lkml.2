Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab0LGVQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 16:16:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165Ab0LGVQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 16:16:36 -0500
Date: Tue, 7 Dec 2010 16:16:14 -0500
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haren Myneni <hbabu@us.ibm.com>
Subject: Re: perf hw  in kexeced kernel broken in tip
Message-ID: <20101207211614.GL21786@redhat.com>
References: <1291219906.32004.1671.camel@laptop>
 <20101201162335.GB2511@redhat.com>
 <1291232292.32004.1969.camel@laptop>
 <20101201194644.GD2511@redhat.com>
 <1291232989.32004.1987.camel@laptop>
 <20101201195835.GE2511@redhat.com>
 <1291234036.32004.2008.camel@laptop>
 <m162vdp3l4.fsf@fess.ebiederm.org>
 <20101202052321.GH18100@redhat.com>
 <1291275270.4023.20.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291275270.4023.20.camel@twins>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 08:34:30AM +0100, Peter Zijlstra wrote:
> >  void __init lockup_detector_init(void)
> >  {
> >  	void *cpu = (void *)(long)smp_processor_id();
> > @@ -563,6 +576,7 @@ void __init lockup_detector_init(void)
> >  
> >  	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
> >  	register_cpu_notifier(&cpu_nfb);
> > +	register_reboot_notifier(&reboot_nfb);
> >  
> >  	return;
> >  }
> 
> We'd really want a perf_event.c callback there to do as the hot-unplug
> code does and detach all running counters from the cpu.

Ok, here is a simpler patch for now.

--------------------------------8<--------
From: Don Zickus <dzickus@redhat.com>
Date: Tue, 7 Dec 2010 16:06:59 -0500
Subject: [PATCH] perf:  Use event select bits for hardware check

The counter registers can continue to increment if left enabled
across a kexec or a kdump.  The makes the perf hardware check
accidentally return false when the hardware really does exist.

Change the check to use the first bits of event selection.  Those
bits should be safe as they are used to program the type of events
to use.  And more importantly, they won't increment across kexec/kdump.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/cpu/perf_event.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 7b91396..7d869c0 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -377,10 +377,10 @@ static bool check_hw_exists(void)
 	u64 val, val_new = 0;
 	int ret = 0;
 
-	val = 0xabcdUL;
-	ret |= checking_wrmsrl(x86_pmu.perfctr, val);
-	ret |= rdmsrl_safe(x86_pmu.perfctr, &val_new);
-	if (ret || val != val_new)
+	val = 0xabUL;
+	ret |= checking_wrmsrl(x86_pmu.eventsel, val);
+	ret |= rdmsrl_safe(x86_pmu.eventsel, &val_new);
+	if (ret || val != (val_new & 0xFF))
 		return false;
 
 	return true;
-- 
1.7.3.2

