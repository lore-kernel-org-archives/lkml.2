Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab0FHWSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 18:18:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:21937 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932397Ab0FHWRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 18:17:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,386,1272870000"; 
   d="scan'208";a="628678265"
Date: Tue, 8 Jun 2010 15:17:35 -0700
From: jacob pan <jacob.jun.pan@linux.intel.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Alan Cox <alan@linux.intel.com>, Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Feng Tang <feng.tang@intel.com>,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH] x86/sfi: fix ioapic gsi range
Message-ID: <20100608151735.1693105f@jacob-laptop>
In-Reply-To: <m1sk4x9q45.fsf@fess.ebiederm.org>
References: <1275952044-27996-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<m1631ue5ho.fsf@fess.ebiederm.org>
	<20100607225010.342e2fab@jacob-laptop>
	<m1631tfh1i.fsf@fess.ebiederm.org>
	<20100608134123.6d9a6fb6@jacob-laptop>
	<m1sk4x9q45.fsf@fess.ebiederm.org>
Organization: OTC
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Jun 2010 14:22:18 -0700
ebiederm@xmission.com (Eric W. Biederman) wrote:

> jacob pan <jacob.jun.pan@linux.intel.com> writes:
> 
> > On Tue, 08 Jun 2010 12:41:45 -0700
> > ebiederm@xmission.com (Eric W. Biederman) wrote:
> >
> >
> >> Even if sfi is never implemented on a platform where that kind of
> >> hardware exists, the current sfi code is setup to coexist
> >> simultaneously in the kernel with all of the infrastructure of
> >> other platforms where those kinds of devices exist.  Which means
> >> there can be drivers compiled into your kernel that make
> >> assumptions about special properties of the irqs 0-15.
> >> 
> > SFI code can be compiled in with ACPI at the same time but at
> > runtime there is only one used, ACPI take precedence. So there
> > wouldn't be any additional conflict caused by SFI added APIC tables.
> >
> >> As for the question about using legacy_pic to detect the absence of
> >> an irq controller that Peter raised.  We can't do that because it
> >> should be possible for an acpi system with all of the legacy
> >> hardware to exist without needing to implement an i8259, or ever
> >> run in the historical interrupt delivery mode of pcs.
> > In your case, I don't understand how would it change the
> > calculation of irq mapping. Even if you don't use i8259 on a x86 PC
> > platform, you still have NR_LEGACY_IRQS=legacy_pic->nr_legacy_irqs.
> >
> > On the other side, use NR_LEGACY_IRQS breaks the existing code for
> > Moorestown in terms of irq-gsi lookup and nr_irqs_gsi.
> 
> Is this code merged where I should have fixed it in my patchset?
> 
yes, merged.
> We went through this with acpi having an identity mapping of irq to
> gsi mapping and the result is that we (a) developed  weird platform
> specific hooks for things that should have been handled by generic
> code, and on other systems we lost access to 16 irqs.
> 
> It took probably 10 years to sort the acpi irq handling out.  What
> I have learned along the way is:
> - Sharing irq in software is madness, so a one to one mapping with
>   hardware irq is required.
> - An identity mapping with gsis is nice but we can't count on the
> hardware designers or the spec designers always doing sane and
> reasonable things so not guaranteeing a particular mapping is
> important.
> 
> If I have actually broken any sfi drivers because you assumed a
> particular we are back where we were with ISA, and still haven't
> completely escaped.  The abstraction layer should provide all of
> the mapping so drivers only see linux irq numbers.
> 
> Eric
> 

[jacob pan] 

In arch/x86/kernel/mrst.c we parse SFI MTMR table then
add timer irqs to mp_irqs. what is broken by this patch is
pin_2_irq() lookup for the legacy irq range since we want
NR_IRQS_LEGACY to be 0 on Moorestown. We do have the assumption that
mp_irqs from SFI is 1:1 mapped to IRQs.

Doing this can fix the problem, but you mentioned you have to use
NR_IRQS_LEGACY, which i still don't understand.

--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1032,7 +1032,7 @@ static int pin_2_irq(int idx, int apic, int pin)
 	} else {
 		u32 gsi = mp_gsi_routing[apic].gsi_base + pin;
 
-		if (gsi >= NR_IRQS_LEGACY)
+		if (gsi >= legacy_pic->nr_legacy_irqs)
 			irq = gsi;


The second problem is nr_irqs_gsi gets an extra 16 for Moorestown.
Similarly, we need this in probe_nr_irqs_gsi:

-	nr = gsi_top + NR_IRQS_LEGACY;
+	nr = gsi_top + legacy_pic->nr_legacy_irqs;
