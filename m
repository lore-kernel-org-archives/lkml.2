Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934345Ab0EEJdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 05:33:03 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45236 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933505Ab0EEJc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 05:32:59 -0400
To: Yinghai <yinghai.lu@oracle.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, Feng Tang <feng.tang@intel.com>,
       Len Brown <len.brown@intel.com>, Jacob Pan <jacob.jun.pan@intel.com>
References: <1269936436-7039-14-git-send-email-ebiederm@xmission.com>
	<tip-988856ee1623bd37e384105f7bb2b7fe44c009f6@git.kernel.org>
	<4BE12323.2010104@oracle.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 05 May 2010 02:32:54 -0700
In-Reply-To: <4BE12323.2010104@oracle.com> (Yinghai's message of "Wed\, 05 May 2010 00\:49\:55 -0700")
Message-ID: <m1y6fy4rsp.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: yinghai.lu@oracle.com, jacob.jun.pan@intel.com, len.brown@intel.com, feng.tang@intel.com, tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Yinghai <yinghai.lu@oracle.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [tip:x86/irq] x86, acpi/irq: Handle isa irqs that are not identity mapped to gsi's.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai <yinghai.lu@oracle.com> writes:

>> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
>> index 9f3f6ca..594827c 100644
>> --- a/arch/x86/kernel/apic/io_apic.c
>> +++ b/arch/x86/kernel/apic/io_apic.c
>> @@ -1037,7 +1037,11 @@ static int pin_2_irq(int idx, int apic, int pin)
>>                   */
>>  		if (ioapic_renumber_irq)
>>  			gsi = ioapic_renumber_irq(apic, gsi);
>> -		irq = gsi;
>> +
>> +		if (gsi >= NR_IRQS_LEGACY)
>> +			irq = gsi;
>> +		else
>> +			irq = gsi_end + 1 + gsi;
>>  	}
>>  
>>  #ifdef CONFIG_X86_32
>> @@ -3852,7 +3856,7 @@ void __init probe_nr_irqs_gsi(void)
>>  {
>>  	int nr;
>>  
>> -	nr = gsi_end + 1;
>> +	nr = gsi_end + 1 + NR_IRQS_LEGACY;
>>  	if (nr > nr_irqs_gsi)
>>  		nr_irqs_gsi = nr;
>
> can you use legacy_irq->nr_legacy_irqs instead of NR_IRQS_LEGACY ?

No. legacy_irq->nr_legacy_irqs is just for dealing with hardware that
does not have i8259 pics.

Here I am reserving 16 irqs above the gsi range in case we get a
weird gsi to isa irq mapping.

Currently the sfi spec doesn't mention anything explicitly.  I
took a quick read through it and sfi and I presume Moorestown
is talking about non pci irqs.  So I would not be surprised
if we didn't have isa device drivers running on platforms
without i8259s.

Currently the code had a small bug dealing with multiple ioapics and
the spec really is incomplete about how you map irqs from pci devices
to interrupts.  So it looks like SFI and Moorestown are more a lab
experiment than real hardware at the moment.  So I expect when
it gets completely fleshed out we will have to jump through a
similar set of hoops as we do with acpi to ensure the first 16
irqs are not used for anything except isa irqs.

Eric
