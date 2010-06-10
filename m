Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690Ab0FJIje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 04:39:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:11016 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670Ab0FJIjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 04:39:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,397,1272870000"; 
   d="scan'208";a="287231720"
Date: Thu, 10 Jun 2010 01:40:18 -0700
From: jacob pan <jacob.jun.pan@linux.intel.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Alan Cox <alan@linux.intel.com>, Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Feng Tang <feng.tang@intel.com>,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH] x86/sfi: fix ioapic gsi range
Message-ID: <20100610014018.00001c23@unknown>
In-Reply-To: <m1r5kfwz3o.fsf@fess.ebiederm.org>
References: <1275952044-27996-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<m1631ue5ho.fsf@fess.ebiederm.org>
	<20100607225010.342e2fab@jacob-laptop>
	<m1631tfh1i.fsf@fess.ebiederm.org>
	<20100608134123.6d9a6fb6@jacob-laptop>
	<m1sk4x9q45.fsf@fess.ebiederm.org>
	<20100608151735.1693105f@jacob-laptop>
	<m1r5kfwz3o.fsf@fess.ebiederm.org>
Organization: Intel OTC
X-Mailer: Claws Mail 3.7.4cvs1 (GTK+ 2.16.0; i586-pc-mingw32msvc)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman Wed, 09 Jun 2010 16:44:11 -0700
>jacob pan <jacob.jun.pan@linux.intel.com> writes:
>
>> [jacob pan] 
>>
>> In arch/x86/kernel/mrst.c we parse SFI MTMR table then
>> add timer irqs to mp_irqs. what is broken by this patch is
>> pin_2_irq() lookup for the legacy irq range since we want
>> NR_IRQS_LEGACY to be 0 on Moorestown. We do have the assumption that
>> mp_irqs from SFI is 1:1 mapped to IRQs.
>
>NR_IRQS_LEGACY is a constant of 16.
i know, what i meant is we want this to be a variable.
>
>> Doing this can fix the problem, but you mentioned you have to use
>> NR_IRQS_LEGACY, which i still don't understand.
>
>Looking at the code in io_apic.c there is a relatively clean way to
>handle this.  The actual concept in io_apic.c today is mp_bus_not_pci.
>
>So you just need to do:
>
>diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
>index e796448..9377fda 100644
>--- a/arch/x86/kernel/mrst.c
>+++ b/arch/x86/kernel/mrst.c
>@@ -242,4 +242,5 @@ void __init x86_mrst_early_setup(void)
> 	x86_init.mpparse.find_smp_config = x86_init_noop;
> 	x86_init.mpparse.get_smp_config = x86_init_uint_noop;
> 
>+	set_bit(0, mp_bus_not_pci);
> }
>
>
>Then you get treated as ISA for purposes of pin_2_irq, and everything
>is a pass through.  Since that seems to be what you want anyway I don't
>see a problem with that for now.
>
I think this may work better. Since we already assign srcbus = MP_ISA_BUS to 
use the mp_irqs, this may be more inline with the current code.
Thanks for the pointer.

But the nr_irqs_gsi would still be wrong for Moorestown if don't use legacy_pic
or some sort of runtime detection.

>Using legacy pic to even talk about this behavior is wrong as that is
>hardware abstraction and the presence or absence of an i8259 has
>nothing to do with the presence of ISA irqs and their descendants.
>
>Eric
