Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab0FHVW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 17:22:28 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:51312 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab0FHVW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 17:22:27 -0400
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
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 08 Jun 2010 14:22:18 -0700
In-Reply-To: <20100608134123.6d9a6fb6@jacob-laptop> (jacob pan's message of "Tue\, 8 Jun 2010 13\:41\:23 -0700")
Message-ID: <m1sk4x9q45.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: jacob.jun.pan@linux.intel.com, len.brown@intel.com, feng.tang@intel.com, mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org, arjan@linux.intel.com, alan@linux.intel.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;jacob pan <jacob.jun.pan@linux.intel.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] x86/sfi: fix ioapic gsi range
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jacob pan <jacob.jun.pan@linux.intel.com> writes:

> On Tue, 08 Jun 2010 12:41:45 -0700
> ebiederm@xmission.com (Eric W. Biederman) wrote:
>
>
>> Even if sfi is never implemented on a platform where that kind of
>> hardware exists, the current sfi code is setup to coexist
>> simultaneously in the kernel with all of the infrastructure of other
>> platforms where those kinds of devices exist.  Which means there can
>> be drivers compiled into your kernel that make assumptions about
>> special properties of the irqs 0-15.
>> 
> SFI code can be compiled in with ACPI at the same time but at runtime
> there is only one used, ACPI take precedence. So there wouldn't be any
> additional conflict caused by SFI added APIC tables.
>
>> As for the question about using legacy_pic to detect the absence of
>> an irq controller that Peter raised.  We can't do that because it
>> should be possible for an acpi system with all of the legacy hardware
>> to exist without needing to implement an i8259, or ever run in the
>> historical interrupt delivery mode of pcs.
> In your case, I don't understand how would it change the calculation of
> irq mapping. Even if you don't use i8259 on a x86 PC platform, you
> still have NR_LEGACY_IRQS=legacy_pic->nr_legacy_irqs.
>
> On the other side, use NR_LEGACY_IRQS breaks the existing code for
> Moorestown in terms of irq-gsi lookup and nr_irqs_gsi.

Is this code merged where I should have fixed it in my patchset?

We went through this with acpi having an identity mapping of irq to
gsi mapping and the result is that we (a) developed  weird platform
specific hooks for things that should have been handled by generic
code, and on other systems we lost access to 16 irqs.

It took probably 10 years to sort the acpi irq handling out.  What
I have learned along the way is:
- Sharing irq in software is madness, so a one to one mapping with
  hardware irq is required.
- An identity mapping with gsis is nice but we can't count on the hardware
  designers or the spec designers always doing sane and reasonable things
  so not guaranteeing a particular mapping is important.

If I have actually broken any sfi drivers because you assumed a
particular we are back where we were with ISA, and still haven't
completely escaped.  The abstraction layer should provide all of
the mapping so drivers only see linux irq numbers.

Eric

