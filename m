Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab1HHSnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 14:43:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:56394 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab1HHSnA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 14:43:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,338,1309762800"; 
   d="scan'208";a="35729645"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Andrew Lutomirski <luto@mit.edu>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Date: Mon, 8 Aug 2011 11:42:06 -0700
Subject: RE: [PATCH v2 1/2] x86: Enable fast strings on Intel if BIOS hasn't
 already
Thread-Topic: [PATCH v2 1/2] x86: Enable fast strings on Intel if BIOS
 hasn't already
Thread-Index: AcxUkQmmSg/eeHU9T5a9K8QbwRFQGgAyZcFAACgEZ0A=
Message-ID: <493994B35A117E4F832F97C4719C4C040132C60003@orsmsx505.amr.corp.intel.com>
References: <cover.1312630712.git.luto@mit.edu>
 <9a8f28ccbe44cd323a01e9a23b531cb869185a21.1312630712.git.luto@mit.edu>
 <493994B35A117E4F832F97C4719C4C040132C5FB69@orsmsx505.amr.corp.intel.com>
 <CAObL_7F2+eXTPo7a631Lh7GD_UpDQXgW_GSDp9Km7pwhwmM6Cw@mail.gmail.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Yu, Fenghua
> Sent: Sunday, August 07, 2011 4:45 PM
> To: 'Andrew Lutomirski'
> Cc: x86@kernel.org; linux-kernel@vger.kernel.org; Matthew Garrett; Len
> Brown; linux-acpi@vger.kernel.org; Ingo Molnar
> Subject: RE: [PATCH v2 1/2] x86: Enable fast strings on Intel if BIOS
> hasn't already
> 
> > -----Original Message-----
> > From: amluto@gmail.com [mailto:amluto@gmail.com] On Behalf Of Andrew
> > Lutomirski
> > Sent: Saturday, August 06, 2011 4:32 PM
> > To: Yu, Fenghua
> > Cc: x86@kernel.org; linux-kernel@vger.kernel.org; Matthew Garrett;
> Len
> > Brown; linux-acpi@vger.kernel.org; Ingo Molnar
> > Subject: Re: [PATCH v2 1/2] x86: Enable fast strings on Intel if BIOS
> > hasn't already
> >
> > On Sat, Aug 6, 2011 at 3:33 PM, Yu, Fenghua <fenghua.yu@intel.com>
> > wrote:
> > >> -----Original Message-----
> > >> From: Andy Lutomirski [mailto:luto@MIT.EDU]
> > >> Sent: Saturday, August 06, 2011 4:43 AM
> > >> To: x86@kernel.org; linux-kernel@vger.kernel.org
> > >> Cc: Yu, Fenghua; Matthew Garrett; Len Brown; linux-
> > >> acpi@vger.kernel.org; Ingo Molnar; Andy Lutomirski
> > >> Subject: [PATCH v2 1/2] x86: Enable fast strings on Intel if BIOS
> > >> hasn't already
> > >>
> > >> Intel SDM volume 3A, 8.4.2 says:
> > >>
> > >>   Software can disable fast-string operation by clearing the
> > >>   fast-string-enable bit (bit 0) of IA32_MISC_ENABLE MSR.
> > >>   However, Intel recomments that system software always enable
> > >>   fast-string operation.
> > >>
> > >> The Intel DQ67SW board (with latest BIOS) disables fast string
> > >> operations if TXT is enabled.  A Lenovo X220 disables it
> regardless
> > >> of TXT setting.  I doubt I'm the only person with a dumb BIOS like
> > >> this.
> > >>
> > >> Signed-off-by: Andy Lutomirski <luto@mit.edu>
> > >> ---
> > >>  arch/x86/kernel/cpu/intel.c |   25 ++++++++++++++++++++++---
> > >>  1 files changed, 22 insertions(+), 3 deletions(-)
> > >>
> > >> diff --git a/arch/x86/kernel/cpu/intel.c
> > b/arch/x86/kernel/cpu/intel.c
> > >> index ed6086e..c80ab41 100644
> > >> --- a/arch/x86/kernel/cpu/intel.c
> > >> +++ b/arch/x86/kernel/cpu/intel.c
> > >> @@ -30,6 +30,7 @@
> > >>  static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
> > >>  {
> > >>       u64 misc_enable;
> > >> +     bool allow_fast_string = true;
> > >>
> > >>       /* Unmask CPUID levels if masked: */
> > >>       if (c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xd)) {
> > >> @@ -118,8 +119,9 @@ static void __cpuinit early_init_intel(struct
> > >> cpuinfo_x86 *c)
> > >>        * (model 2) with the same problem.
> > >>        */
> > >>       if (c->x86 == 15) {
> > >> -             rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
> > >> +             allow_fast_string = false;
> > >>
> > >> +             rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
> > >>               if (misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING)
> {
> > >>                       printk(KERN_INFO "kmemcheck: Disabling fast
> > string
> > >> operations\n");
> > >>
> > >> @@ -130,11 +132,28 @@ static void __cpuinit
> early_init_intel(struct
> > >> cpuinfo_x86 *c)
> > >>  #endif
> > >>
> > >>       /*
> > >> -      * If fast string is not enabled in IA32_MISC_ENABLE for any
> > >> reason,
> > >> -      * clear the fast string and enhanced fast string CPU
> > >> capabilities.
> > >> +      * If BIOS didn't enable fast string operation, try to
> enable
> > >> +      * it ourselves.  If that fails, then clear the fast string
> > >> +      * and enhanced fast string CPU capabilities.
> > >>        */
> > >>       if (c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xd)) {
> > >>               rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
> > >> +
> > >> +             if (allow_fast_string &&
> > >> +                 !(misc_enable &
> MSR_IA32_MISC_ENABLE_FAST_STRING))
> > {
> > >> +                     misc_enable |=
> > MSR_IA32_MISC_ENABLE_FAST_STRING;
> > >> +                     wrmsr_safe(MSR_IA32_MISC_ENABLE,
> > (u32)misc_enable,
> > >> +                                (u32)(misc_enable >> 32));
> > >> +
> > >> +                     /* Re-read to make sure it stuck. */
> > >> +                     rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
> > >> +
> > >> +                     if (misc_enable &
> > MSR_IA32_MISC_ENABLE_FAST_STRING)
> > >> +                             printk(KERN_WARNING FW_WARN "CPU
> #%d:
> > "
> > >> +
> >  "IA32_MISC_ENABLE.FAST_STRING_ENABLE "
> > >> +                                    "was not set", c->cpu_index);
> > > This printk is redundant because the same info is dumped in the
> below
> > printk. Plus it's not firmware's issue if we can not set fast string
> > bit 0 in MISC_ENABLE register. So I don't think FW_WARN is right.
> >
> > Huh?  This is the success path -- the patch prints the warning if
> > flipping the bit worked...
> 
> Ok. I see.
> 
> Still I would suggest to remove this printk. This info will be printed
> on every single CPU if BIOS doesn't enable fast string. This could
> flood the log buffer on big machines or many threads machines. And the

On the bottom line, you need to use printk_once to reduce repeated message on each CPU.

Thanks.
 
-Fenghua
