Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069Ab0KSW72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:59:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932559Ab0KSW70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:59:26 -0500
Date: Fri, 19 Nov 2010 17:59:02 -0500
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
Message-ID: <20101119225902.GQ18100@redhat.com>
References: <4CE2E3C3.6060800@windriver.com>
 <20101118080516.GJ32621@elte.hu>
 <4CE52048.5080802@windriver.com>
 <1290086232.2109.1507.camel@laptop>
 <20101118193247.GF18100@redhat.com>
 <4CE583D0.8050407@windriver.com>
 <20101118200807.GC8131@redhat.com>
 <1290112234.2109.1534.camel@laptop>
 <20101119165952.GJ18100@redhat.com>
 <1290191158.2109.1614.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290191158.2109.1614.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 07:25:58PM +0100, Peter Zijlstra wrote:
> On Fri, 2010-11-19 at 11:59 -0500, Don Zickus wrote:
> > Reading the kvm code in arch/x86/kernel/kvm/x86.c, it seems like they do
> > _not_ fault on writes, only on some (which don't include a bunch of the
> > perfctrs).  The reason seems to be to prevent older distros from falling
> > apart that could not handle those faults properly.
> 
> Egads, that's just vile.. in that case we don't really need to do
> anything, its a qemu/KVM bug, they emulate non-working hardware.
> 
> Hmm,. there is something we can do though, write a non-zero counter
> value and then read it back, if its not what we wrote, its fudged and we
> disable the pmu.

I hacked up this patch which seems to work, not sure if it is the correct
spot but.. and maybe the function name could be better..

Jason, can you test this?

Cheers,
Don


diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index bbe3c4a..6f03ace 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -381,6 +381,19 @@ static void release_pmc_hardware(void) {}
 
 #endif
 
+static bool check_hw_exists(void)
+{
+	u64 val, val_new;
+
+	val = 0xabcdUL;
+	(void) checking_wrmsrl(x86_pmu.perfctr, val);
+	rdmsrl(x86_pmu.perfctr, val_new);
+	if (val != val_new)
+		return false;
+
+	return true;
+}
+
 static void reserve_ds_buffers(void);
 static void release_ds_buffers(void);
 
@@ -1371,6 +1385,12 @@ void __init init_hw_perf_events(void)
 
 	pmu_check_apic();
 
+	/* sanity check that the hardware exists or is emulated */
+	if (!check_hw_exists()) {
+		pr_cont("no PMU driver, software events only.\n");
+		return;
+	}
+
 	pr_cont("%s PMU driver.\n", x86_pmu.name);
 
 	if (x86_pmu.quirks)
