Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab0KSXJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 18:09:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:43784 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518Ab0KSXJ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 18:09:29 -0500
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20101119225902.GQ18100@redhat.com>
References: <4CE2E3C3.6060800@windriver.com>
	 <20101118080516.GJ32621@elte.hu> <4CE52048.5080802@windriver.com>
	 <1290086232.2109.1507.camel@laptop> <20101118193247.GF18100@redhat.com>
	 <4CE583D0.8050407@windriver.com> <20101118200807.GC8131@redhat.com>
	 <1290112234.2109.1534.camel@laptop> <20101119165952.GJ18100@redhat.com>
	 <1290191158.2109.1614.camel@laptop>  <20101119225902.GQ18100@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 20 Nov 2010 00:09:39 +0100
Message-ID: <1290208179.2114.13.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 17:59 -0500, Don Zickus wrote:
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -381,6 +381,19 @@ static void release_pmc_hardware(void) {}
>  
>  #endif
>  
> +static bool check_hw_exists(void)
> +{
> +       u64 val, val_new;
> +
> +       val = 0xabcdUL;
> +       (void) checking_wrmsrl(x86_pmu.perfctr, val);
> +       rdmsrl(x86_pmu.perfctr, val_new);


Yeah, this looks about right, although for extreme prudence I'd also use
a checking_rdmsrl().


> +       if (val != val_new)
> +               return false;
> +
> +       return true;
> +}
> +
>  static void reserve_ds_buffers(void);
>  static void release_ds_buffers(void);
>  
> @@ -1371,6 +1385,12 @@ void __init init_hw_perf_events(void)
>  
>         pmu_check_apic();
>  
> +       /* sanity check that the hardware exists or is emulated */
> +       if (!check_hw_exists()) {
> +               pr_cont("no PMU driver, software events only.\n");
> +               return;
> +       } 

Maybe report something like this: 
  "Broken PMU hardware detected, software events only."

Because this is really not something that's supposed to happen.
