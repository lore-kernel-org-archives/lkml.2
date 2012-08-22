Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab2HVOer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 10:34:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34640 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756491Ab2HVOep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 10:34:45 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Andre Przywara <andre.przywara@amd.com>
Subject: Re: [PATCH 7/8] cpufreq: Remove support for hardware P-state chips from powernow-k8
Date: Wed, 22 Aug 2012 16:34:42 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.20-desktop; KDE/4.6.0; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1343305724-2809-1-git-send-email-andre.przywara@amd.com> <201208220300.03512.trenn@suse.de> <5034E11C.1010006@amd.com>
In-Reply-To: <5034E11C.1010006@amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201208221634.42832.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 22, 2012 03:39:40 PM Andre Przywara wrote:
> On 08/22/2012 03:00 AM, Thomas Renninger wrote:
> > On Monday 20 August 2012 22:49:16 Rafael J. Wysocki wrote:
> >> On Monday, August 20, 2012, Andre Przywara wrote:
> >>> On 08/05/2012 11:33 PM, Rafael J. Wysocki wrote:
> >>>> On Thursday, July 26, 2012, Andre Przywara wrote:
> > ...
> >>>
> >>> If you insist, I can keep the code in powernow-k8, but it probably
> >>> wouldn't receive any support anymore and would increase confusion on the
> >>> user side.
> >>
> >> I'm not afraid of that.  And as I said, you can just add info messages to
> >> powernow-k8 saying that the feature is deprecated and will be removed in the
> >> future and _then_ you actually _can_ remove it in the future (say, 2-3 major
> >> kernel releasew from now).
> >
> > Full code duplication in powernow-k8 and acpi-cpufreq does not make sense
> > to me.
> > You would need extra logic that only the first is successfully loaded etc.
> > IMO this has more risk of introducing new bugs than any good.
> > A message like that might be useful though:
> > if (boot_cpu_has(X86_FEATURE_HW_PSTATE))
> > {
> >       printk("powernowk8 does not serve MSR based frequency switching anymore, use acpi-cpufreq instead\n");
> >       return -1;
> > }
> 
> Matthew had something even better, that is patch 3/8:
> +               if (static_cpu_has(X86_FEATURE_HW_PSTATE))
> +			request_module("acpi_cpufreq");
> 
> So if someone tries to load powernow-k8 on a recent CPU, it will 
> automatically load acpi-cpufreq instead.
> I just realized that this doesn't work as expected, because powernow-k8 
> bails out early due to only family 0xf being in the matching CPUID 
> family list. Will fix this.
No need. I would just cut it out.
 
> I will do some tests now to check our options:
> 1. A combination of Matthew's and Thomas' ideas: if powernow-k8 is 
> loaded on newer CPUs, request acpi-cpufreq to load _plus_ write a 
> warning that powernow-k8 is obsolete for this hardware. Don't load 
> powernow-k8 (which has support removed anyway). My favorite.
> 
> 2. Add code (probably to the generic cpufreq framework) to avoid loading 
> two drivers. Print a warning if tried anyways. Leave h/w P-state support 
> in powernow-k8. It seems like that acpi-cpufreq takes precedence over 
> powernow-k8 in distribution's module load list, so this should work as 
> expected even with keeping the support in powernow-k8 (as a fallback in 
> case of trouble).

I would just issue above message (see my other mail).
Loading of acpi-cpufreq, powernow-k8 and most other cpufreq drivers
(beside some old obscure ones, for example speedstep-*) just works since:

commit fa8031aefec0cf7ea6c2387c93610d99d9659aa2
Author: Andi Kleen <ak@linux.intel.com>

    cpufreq: Add support for x86 cpuinfo auto loading v4

If someone else (than udev via x86cpu autoloading modalias or
request_module() in processor driver) tries
to load powernow-k8 on a X86_FEATURE_HW_PSTATE capable machine,
powernow-k8 should just bail out with a "deprecated, do not try
to load" message, so that userspace init scripts can get fixed.

On which cpu families did you develop/test this (also an Intel one)?
I cannot promise, but I try to find time to give the one or other
different CPU a cpupower-bench test. With and without the patches.
If performance behavior is identical, one could be rather
sure that everything works the same way.


   Thomas
