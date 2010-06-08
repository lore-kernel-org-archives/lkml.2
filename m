Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab0FHAbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 20:31:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40627 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127Ab0FHAbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 20:31:10 -0400
Message-ID: <4C0D8F43.4070900@zytor.com>
Date: Mon, 07 Jun 2010 17:30:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>, Alan Cox <alan@linux.intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH] x86/sfi: fix ioapic gsi range
References: <1275952044-27996-1-git-send-email-jacob.jun.pan@linux.intel.com> <m1631ue5ho.fsf@fess.ebiederm.org>
In-Reply-To: <m1631ue5ho.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2010 05:24 PM, Eric W. Biederman wrote:
> Jacob Pan <jacob.jun.pan@linux.intel.com> writes:
> 
>> SFI based platforms should have zero based gsi_base for IOAPICs found in SFI
>> tables. The current code sets gsi_base starting from 1 when registering ioapic.
>> The result is that Moorestown platform would have wrong mp_gsi_routing for each
>> ioapic.
> 
> Yes starting at 1 is a bug.
> 
>> Background:
>> In Moorestown/Medfield platforms, there is no legacy IRQs, all gsis and irqs
>> are one to one mapped, including those < 16. Specifically, IRQ0 and IRQ1 are
>> used for per-cpu timers. So without this patch, IOAPIC pin to IRQ mapping is
>> off by one.
> 
> The patch looks mostly reasonable the comment is wrong.
> 
> You may not use a 1-1 mapping if you don't have legacy irqs.  Linux
> irqs 0-15 are the ISA irqs you may not use those irq numbers for
> something different on any architecture, but especially not on x86.
> The gsi numbers are firmware specific and you may treat however you want.
> 
> Does the following patch work for you?
> 
> It appears I goofed when it was pointed out that gsi_end was inclusive and
> didn't change the initialize.
> 
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 33f3563..5de84e5 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -90,7 +90,7 @@ int nr_ioapics;
>  struct mp_ioapic_gsi  mp_gsi_routing[MAX_IO_APICS];
>  
>  /* The last gsi number used */
> -u32 gsi_end;
> +u32 gsi_end = -1; 
>  

This seems like asking for signedness problems, especially since this is
used in range compares all the time.  The real problem here is that
gsi_end is inclusive, which is almost always the wrong thing for the
endpoint of a range.  Instead we should have the last number used plus
one; perhaps it should be called gsi_next or gsi_free.

	-hpa

