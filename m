Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab0FIXoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 19:44:22 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:40766 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498Ab0FIXoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 19:44:20 -0400
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
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 09 Jun 2010 16:44:11 -0700
In-Reply-To: <20100608151735.1693105f@jacob-laptop> (jacob pan's message of "Tue\, 8 Jun 2010 15\:17\:35 -0700")
Message-ID: <m1r5kfwz3o.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: jacob.jun.pan@linux.intel.com, len.brown@intel.com, feng.tang@intel.com, mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org, arjan@linux.intel.com, alan@linux.intel.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;jacob pan <jacob.jun.pan@linux.intel.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] x86/sfi: fix ioapic gsi range
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jacob pan <jacob.jun.pan@linux.intel.com> writes:

> [jacob pan] 
>
> In arch/x86/kernel/mrst.c we parse SFI MTMR table then
> add timer irqs to mp_irqs. what is broken by this patch is
> pin_2_irq() lookup for the legacy irq range since we want
> NR_IRQS_LEGACY to be 0 on Moorestown. We do have the assumption that
> mp_irqs from SFI is 1:1 mapped to IRQs.

NR_IRQS_LEGACY is a constant of 16.

> Doing this can fix the problem, but you mentioned you have to use
> NR_IRQS_LEGACY, which i still don't understand.

Looking at the code in io_apic.c there is a relatively clean way to
handle this.  The actual concept in io_apic.c today is mp_bus_not_pci.

So you just need to do:

diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
index e796448..9377fda 100644
--- a/arch/x86/kernel/mrst.c
+++ b/arch/x86/kernel/mrst.c
@@ -242,4 +242,5 @@ void __init x86_mrst_early_setup(void)
 	x86_init.mpparse.find_smp_config = x86_init_noop;
 	x86_init.mpparse.get_smp_config = x86_init_uint_noop;
 
+	set_bit(0, mp_bus_not_pci);
 }


Then you get treated as ISA for purposes of pin_2_irq, and everything
is a pass through.  Since that seems to be what you want anyway I don't
see a problem with that for now.

Using legacy pic to even talk about this behavior is wrong as that is
hardware abstraction and the presence or absence of an i8259 has
nothing to do with the presence of ISA irqs and their descendants.

Eric
