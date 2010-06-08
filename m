Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab0FHAZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 20:25:56 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57518 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab0FHAZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 20:25:55 -0400
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Alan Cox <alan@linux.intel.com>, Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Feng Tang <feng.tang@intel.com>,
       Len Brown <len.brown@intel.com>
References: <1275952044-27996-1-git-send-email-jacob.jun.pan@linux.intel.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 07 Jun 2010 17:24:19 -0700
In-Reply-To: <1275952044-27996-1-git-send-email-jacob.jun.pan@linux.intel.com> (Jacob Pan's message of "Mon\,  7 Jun 2010 16\:07\:24 -0700")
Message-ID: <m1631ue5ho.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: jacob.jun.pan@linux.intel.com, len.brown@intel.com, feng.tang@intel.com, mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org, arjan@linux.intel.com, alan@linux.intel.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jacob Pan <jacob.jun.pan@linux.intel.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] x86/sfi: fix ioapic gsi range
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jacob Pan <jacob.jun.pan@linux.intel.com> writes:

> SFI based platforms should have zero based gsi_base for IOAPICs found in SFI
> tables. The current code sets gsi_base starting from 1 when registering ioapic.
> The result is that Moorestown platform would have wrong mp_gsi_routing for each
> ioapic.

Yes starting at 1 is a bug.

> Background:
> In Moorestown/Medfield platforms, there is no legacy IRQs, all gsis and irqs
> are one to one mapped, including those < 16. Specifically, IRQ0 and IRQ1 are
> used for per-cpu timers. So without this patch, IOAPIC pin to IRQ mapping is
> off by one.

The patch looks mostly reasonable the comment is wrong.

You may not use a 1-1 mapping if you don't have legacy irqs.  Linux
irqs 0-15 are the ISA irqs you may not use those irq numbers for
something different on any architecture, but especially not on x86.
The gsi numbers are firmware specific and you may treat however you want.

Does the following patch work for you?

It appears I goofed when it was pointed out that gsi_end was inclusive and
didn't change the initialize.

Eric
---

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 33f3563..5de84e5 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -90,7 +90,7 @@ int nr_ioapics;
 struct mp_ioapic_gsi  mp_gsi_routing[MAX_IO_APICS];
 
 /* The last gsi number used */
-u32 gsi_end;
+u32 gsi_end = -1; 
 

