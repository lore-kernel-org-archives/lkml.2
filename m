Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932851Ab0EMWQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 18:16:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:10725 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758503Ab0EMWQe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 18:16:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,224,1272870000"; 
   d="scan'208";a="566987452"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
       Jacob Pan <jacob.jun.pan@linux.intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       "Du, Alek" <alek.du@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Tang, Feng" <feng.tang@intel.com>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 13 May 2010 15:16:29 -0700
Subject: RE: [PATCH 4/8] x86/mrst: change clock selection logic to support
 medfield
Thread-Topic: [PATCH 4/8] x86/mrst: change clock selection logic to support
 medfield
Thread-Index: AcrxF2VWcLli0NsER8GaYEOKwo847gBzqCHg
Message-ID: <43F901BD926A4E43B106BF17856F0755A77DF118@orsmsx508.amr.corp.intel.com>
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1273254108-3234-5-git-send-email-jacob.jun.pan@linux.intel.com>
 <alpine.LFD.2.00.1005111546260.3401@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1005111546260.3401@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sorry for the late reply, we are working on the fixes. just to give some answers to your comments.

> 
>  apbt sucks performance wise, so why do you consider it a better
>  choice than lapic + broadcast ?
> 
apbt is always-on, I guess depends on the load, it can be better than
having broadcast timers. e.g. if there are frequency transitions
between C0 to deep C states. if we are always in c0, I can easily see
native performance impact with per cpu apbt. I don't have power number
to backup either cases. ftrace shows programming lapic timer is quite
expensive, I don't understand.


 1)               |          clockevents_program_event() {
 1)               |            lapic_next_event() {
 1)   2.947 us    |              native_apic_mem_write();
 1)   8.682 us    |            }
 1) + 14.676 us   |          }

 0)               |                  clockevents_program_event() {
 0)   4.146 us    |                    apbt_next_event();
 0)   9.910 us    |                  }


> > + * lapic (always-on,ARAT) ------ 150
> > + */
> > +
> > +int mrst_timer_options __cpuinitdata;
> > +
> >  static u32 sfi_mtimer_usage[SFI_MTMR_MAX_NUM];
> >  static struct sfi_timer_table_entry
> sfi_mtimer_array[SFI_MTMR_MAX_NUM];
> > +static u32 mrst_cpu_chip;
> >  int sfi_mtimer_num;
> >
> >  struct sfi_rtc_table_entry sfi_mrtc_array[SFI_MRTC_MAX];
> > @@ -167,15 +191,16 @@ int __init sfi_parse_mrtc(struct
> sfi_table_header *table)
> >  	return 0;
> >  }
> >
> > -/*
> > - * the secondary clock in Moorestown can be APBT or LAPIC clock,
> default to
> > - * APBT but cmdline option can also override it.
> > - */
> >  static void __cpuinit mrst_setup_secondary_clock(void)
> >  {
> > -	/* restore default lapic clock if disabled by cmdline */
> > -	if (disable_apbt_percpu)
> > -		return setup_secondary_APIC_clock();
> > +	if ((mrst_timer_options == MRST_TIMER_APBT_ONLY))
> > +		return apbt_setup_secondary_clock();
> > +	if (cpu_has(&current_cpu_data, X86_FEATURE_ARAT)
> > +		||  (mrst_timer_options == MRST_TIMER_LAPIC_APBT)) {
> > +		pr_info("using lapic timers for secondary clock\n");
> > +		setup_secondary_APIC_clock();
> > +		return;
> 
>   The logic is confusing.
> 
it can be more straightforward if we don't allow user cmdline
overwrite.

>  I guess the 111 is Penwell/MRST specific, right ?
> 
>  According to SDM we have anyway different results for the various CPU
>  families, but we should utilize this in a generic way and have the
>  translation tables for the various CPUs in one place.
agreed. 111b is Penwell specific 83MHz spread spectrum


> 
>   Yikes. From which Intel cookbook is this ?
> 
>   Aside of that we have that info in boot_cpu_info already, don't we ?
>   So there is neither a requirement for the extra cpuid call nor for
>   the extra mrst_cpu_chip id magic.
> 
initially, I thought we need this before boot_cpu_data is initialized.
But we actually don't need it early. I will fix that.

