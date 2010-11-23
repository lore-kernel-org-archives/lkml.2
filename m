Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429Ab0KWTEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 14:04:24 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52952 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756390Ab0KWTEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 14:04:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qg5itASDaSV94Z8js4vU+7NB/RFU0+9Js5/RX7DrnsvfsMvDZGc8VlpZ6coEDz+X+A
         NYaVQzMhM/lCTtqwU4hmcSda/gMPa7THd1L0E9un9cF4rDBZJ2n6NiwOolQsCxnP62pE
         LQRzUQw3dX/uLVLtL4B059gxgpgg7Pz2NTYCY=
Date: Tue, 23 Nov 2010 22:04:18 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, Don Zickus <dzickus@redhat.com>
Cc: sedat.dilek@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86, perf, nmi: Disable perf if counters are not
	accessable
Message-ID: <20101123190417.GC5997@lenovo>
References: <AANLkTikzSY09i=C+A2Y=_gVa-44r_bN76P-U2-NZMnpz@mail.gmail.com> <20101123165657.GF18100@redhat.com> <AANLkTimsz2XWQq7bJ4uhWXhoPuQw-fSJbCJ6D6Xo69XM@mail.gmail.com> <1290536827.2072.417.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290536827.2072.417.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 07:27:07PM +0100, Peter Zijlstra wrote:
> On Tue, 2010-11-23 at 19:21 +0100, Sedat Dilek wrote:
> > Due to BIOS l(ocal)apic is not possible:
> > 
> > # dmesg | grep -i apic
> > [    0.000000] Using APIC driver default
> > [    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
> > [    0.000000] APIC: disable apic facility
> > [    0.000000] APIC: switched to apic NOOP
> > [    0.008891] no APIC, boot with the "lapic" boot parameter to force-enable it.
> > [    0.036141] Local APIC not detected. Using dummy APIC emulation. 
> 
> Have you tried booting with "lapic" as the second last msg suggests you
> do?

 Peter, Don, might not we need something like the patch below -- ie to check for
apic earlier and do not acquire cpu for PERF cpu bit, and its cpu model, etc
if there is no active apic? And perhaps for nmi-watchdog, we should not try
to creat perf event for same reason and simply report that nmi-watchdog is
disabled (though of course hpet based one should try to continue).

 No?

  Cyrill
---
 arch/x86/kernel/cpu/perf_event.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
@@ -1329,14 +1329,16 @@ x86_pmu_notifier(struct notifier_block *
 	return ret;
 }
 
-static void __init pmu_check_apic(void)
+static int __init pmu_check_apic(void)
 {
 	if (cpu_has_apic)
-		return;
+		return 0;
 
 	x86_pmu.apic = 0;
 	pr_info("no APIC, boot with the \"lapic\" boot parameter to force-enable it.\n");
 	pr_info("no hardware sampling interrupt available.\n");
+
+	return -1;
 }
 
 void __init init_hw_perf_events(void)
@@ -1346,6 +1348,10 @@ void __init init_hw_perf_events(void)
 
 	pr_info("Performance Events: ");
 
+	/* apic is required */
+	if (pmu_check_apic())
+		goto no_pmu;
+
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_INTEL:
 		err = intel_pmu_init();
@@ -1356,12 +1362,8 @@ void __init init_hw_perf_events(void)
 	default:
 		return;
 	}
-	if (err != 0) {
-		pr_cont("no PMU driver, software events only.\n");
-		return;
-	}
-
-	pmu_check_apic();
+	if (err != 0)
+		goto no_pmu;
 
 	pr_cont("%s PMU driver.\n", x86_pmu.name);
 
@@ -1411,6 +1413,12 @@ void __init init_hw_perf_events(void)
 
 	perf_pmu_register(&pmu);
 	perf_cpu_notifier(x86_pmu_notifier);
+
+	return;
+
+no_pmu:
+	pr_cont("no PMU driver, software events only.\n");
+	return;
 }
 
 static inline void x86_pmu_read(struct perf_event *event)
