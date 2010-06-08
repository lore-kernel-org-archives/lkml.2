Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab0FHTlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 15:41:55 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:59400 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab0FHTly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 15:41:54 -0400
To: jacob pan <jacob.jun.pan@linux.intel.com>
Cc: Alan Cox <alan@linux.intel.com>, Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Feng Tang <feng.tang@intel.com>,
       Len Brown <len.brown@intel.com>
References: <1275952044-27996-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<m1631ue5ho.fsf@fess.ebiederm.org>
	<20100607225010.342e2fab@jacob-laptop>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 08 Jun 2010 12:41:45 -0700
In-Reply-To: <20100607225010.342e2fab@jacob-laptop> (jacob pan's message of "Mon\, 7 Jun 2010 22\:50\:10 -0700")
Message-ID: <m1631tfh1i.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: jacob.jun.pan@linux.intel.com, len.brown@intel.com, feng.tang@intel.com, mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org, arjan@linux.intel.com, alan@linux.intel.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;jacob pan <jacob.jun.pan@linux.intel.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] x86/sfi: fix ioapic gsi range
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jacob pan <jacob.jun.pan@linux.intel.com> writes:

>> > Background:
>> > In Moorestown/Medfield platforms, there is no legacy IRQs, all gsis
>> > and irqs are one to one mapped, including those < 16. Specifically,
>> > IRQ0 and IRQ1 are used for per-cpu timers. So without this patch,
>> > IOAPIC pin to IRQ mapping is off by one.
>> 
>> The patch looks mostly reasonable the comment is wrong.
>> 
>> You may not use a 1-1 mapping if you don't have legacy irqs.  Linux
>> irqs 0-15 are the ISA irqs you may not use those irq numbers for
>> something different on any architecture, but especially not on x86.
>> The gsi numbers are firmware specific and you may treat however you
>> want.
>
> [jacob pan] If we don't have ISA irqs, why can't we have gsi# = irq#
> for the legacy IRQ range? On Moorestown, we are re-using legacy irqs.
> e.g. 
> sh-4.0# cat /proc/interrupts
>           CPU0       CPU1
>   0:       1512          0   IO-APIC-edge      apbt0
>   1:          0       1482   IO-APIC-edge      apbt1
>   9:          0          0   IO-APIC-fasteoi   dw_spi
>  10:          0          0   IO-APIC-fasteoi   mrst_i2c
>  11:          0          0   IO-APIC-fasteoi   mrst_i2c
>  12:          0          0   IO-APIC-fasteoi   mrst_i2c
>  23:          0          0   IO-APIC-fasteoi   intel_scu_ipc
>  27:         21          0   IO-APIC-fasteoi

At the ioapic and gsi level, and in your firmware interface reusing the
numbers is fine.

The issue is what acpi calls bus 0 irqs, and how drivers deal with
them.  We wind up having well know irqs:  irqs 3 and 4 for serial ports,
irq 7 for parallel ports. irqs 14, and 15 for ide.

A bunch of these hardware devices we can get if someone connects up a
lpc superio chip.

Even if sfi is never implemented on a platform where that kind of
hardware exists, the current sfi code is setup to coexist
simultaneously in the kernel with all of the infrastructure of other
platforms where those kinds of devices exist.  Which means there can
be drivers compiled into your kernel that make assumptions about special
properties of the irqs 0-15.

I have seen a lot of weird hard to track issues, because of a conflict in
assumptions over the ISA irqs.  It is easiest and safest just to let the
first 16 linux irq numbers be reserved for the legacy oddness, so code can
make assumptions and we don't have to worry about it.

As for the question about using legacy_pic to detect the absence of an irq
controller that Peter raised.  We can't do that because it should be possible
for an acpi system with all of the legacy hardware to exist without needing
to implement an i8259, or ever run in the historical interrupt delivery mode
of pcs.

With the current code you should get all of the remapping of the gsi's out
of the legacy irq space without needing to lift a finger, and if someone later
decides we need an irq override so we can have an isa irq present on a weird
embedded system on a chip the code will be able to handle that easily.

Eric
