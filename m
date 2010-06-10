Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298Ab0FJOk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 10:40:56 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:35929 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759259Ab0FJOky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 10:40:54 -0400
To: jacob pan <jacob.jun.pan@linux.intel.com>
Cc: Alan Cox <alan@linux.intel.com>, Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Feng Tang <feng.tang@intel.com>,
       Len Brown <len.brown@intel.com>
References: <1275952044-27996-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<m1631ue5ho.fsf@fess.ebiederm.org>
	<20100607225010.342e2fab@jacob-laptop>
	<m1631tfh1i.fsf@fess.ebiederm.org>
	<20100608134123.6d9a6fb6@jacob-laptop>
	<m1sk4x9q45.fsf@fess.ebiederm.org>
	<20100608151735.1693105f@jacob-laptop>
	<m1r5kfwz3o.fsf@fess.ebiederm.org> <20100610014018.00001c23@unknown>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 10 Jun 2010 07:39:50 -0700
In-Reply-To: <20100610014018.00001c23@unknown> (jacob pan's message of "Thu\, 10 Jun 2010 01\:40\:18 -0700")
Message-ID: <m1aar3uf2h.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: jacob.jun.pan@linux.intel.com, len.brown@intel.com, feng.tang@intel.com, mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org, arjan@linux.intel.com, alan@linux.intel.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH] x86/sfi: fix ioapic gsi range
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jacob pan <jacob.jun.pan@linux.intel.com> writes:

> Eric W. Biederman Wed, 09 Jun 2010 16:44:11 -0700
>>jacob pan <jacob.jun.pan@linux.intel.com> writes:
>>
>>> [jacob pan] 
>>>
>>> In arch/x86/kernel/mrst.c we parse SFI MTMR table then
>>> add timer irqs to mp_irqs. what is broken by this patch is
>>> pin_2_irq() lookup for the legacy irq range since we want
>>> NR_IRQS_LEGACY to be 0 on Moorestown. We do have the assumption that
>>> mp_irqs from SFI is 1:1 mapped to IRQs.
>>
>>NR_IRQS_LEGACY is a constant of 16.
> i know, what i meant is we want this to be a variable.

No.  Not on that code path.  As that code path has nothing
to do what what hardware is present.

There are a bunch of other very awkward usages of
legacy_pic->nr_legacy_irqs that should be removed with cleanups.

Things like EISA_ELCR are very wrong to have a variable in there.
We already have a probe for ISA being present so we don't need an
extra one.

>>> Doing this can fix the problem, but you mentioned you have to use
>>> NR_IRQS_LEGACY, which i still don't understand.
>>
>>Looking at the code in io_apic.c there is a relatively clean way to
>>handle this.  The actual concept in io_apic.c today is mp_bus_not_pci.
>>
>>So you just need to do:
>>
>>diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
>>index e796448..9377fda 100644
>>--- a/arch/x86/kernel/mrst.c
>>+++ b/arch/x86/kernel/mrst.c
>>@@ -242,4 +242,5 @@ void __init x86_mrst_early_setup(void)
>> 	x86_init.mpparse.find_smp_config = x86_init_noop;
>> 	x86_init.mpparse.get_smp_config = x86_init_uint_noop;
>> 
>>+	set_bit(0, mp_bus_not_pci);
>> }
>>
>>
>>Then you get treated as ISA for purposes of pin_2_irq, and everything
>>is a pass through.  Since that seems to be what you want anyway I don't
>>see a problem with that for now.
>>
> I think this may work better. Since we already assign srcbus = MP_ISA_BUS to 
> use the mp_irqs, this may be more inline with the current code.
> Thanks for the pointer.
>
> But the nr_irqs_gsi would still be wrong for Moorestown if don't use legacy_pic
> or some sort of runtime detection.

nr_irqs_gsi has a possibly confusing name.

nr_irqs_gsi is the number of linux irqs that we reserve for handling
the gsis.  All of the rest of the irqs are allowed to be dynamically
allocated for MSIs and the like.  As long as the number is >= the number
of gsis you are fine. 

Unless you have patches that do strange and use nr_irqs_gsi for something
else I don't see why you would have a problem with nr_irqs_gsi.

Eric
