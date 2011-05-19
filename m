Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab1ESFnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 01:43:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105Ab1ESFnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 01:43:31 -0400
Subject: Re: [PATCH v2] x86, vt-d: enable x2apic opt out
From: Alex Williamson <alex.williamson@redhat.com>
To: "Woodhouse, David" <david.woodhouse@intel.com>
Cc: "Song, Youquan" <youquan.song@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "Kay, Allen M" <allen.m.kay@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Liu, Kent" <kent.liu@intel.com>,
        Youquan Song <youquan.song@linux.intel.com>
In-Reply-To: <1305759537.28691.39.camel@i7.infradead.org>
References: <1302764783-24491-1-git-send-email-youquan.song@intel.com>
	 <1305126431.30435.163.camel@i7.infradead.org>
	 <1305577977.3146.112.camel@x201>
	 <1305759537.28691.39.camel@i7.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 May 2011 23:43:03 -0600
Message-ID: <1305783783.29268.76.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 23:58 +0100, Woodhouse, David wrote:
> On Mon, 2011-05-16 at 21:32 +0100, Alex Williamson wrote:
> > 
> > > Is this just a workaround for a crappy BIOS? What is the *actual* reason
> > > for wanting to disable x2apic?
> > 
> > Just a guess, but the OEM probably hasn't updated their SMI handlers to
> > understand x2apic yet and won't before the product ships because some
> > other OS doesn't bother to use x2apic. 
> 
> But I think we'll still use x2apic if interrupt remapping isn't enabled
> (for example if VT-d is disabled in the BIOS and the whole DMAR table is
> absent), or if we're booted with 'iommu=off' or indeed if the
> distribution vendor has hacked the kernel so that iommu=off is the
> *default*, because they've seen so many broken BIOSes.
> 
> AFAICT although CONFIG_X86_X2APIC depends on CONFIG_INTR_REMAP, we can
> still enable x2apic at runtime if interrupt remapping is not operating?
> We end up hitting this code in enable_IR_x2apic():
> 
> 	if (!ret) {
> 		/* IR is required if there is APIC ID > 255 even when running
> 		 * under KVM
> 		 */
> 		if (max_physical_apicid > 255 ||
> 		    !hypervisor_x2apic_available())
> 			goto nox2apic;
> 		/*
> 		 * without IR all CPUs can be addressed by IOAPIC/MSI
> 		 * only in physical mode
> 		 */
> 		x2apic_force_phys();
> 	}
> 
> So if that *is* the reason, this doesn't seem like a viable solution.

I've always been under the impression that interrupt remapping is
required to enable x2apic because it enables IOxAPICs to work in that
mode.  Particularly this excerpt from the x2apic spec (sec 1.2):

        Similarly no modifications are required to the IOxAPIC. The
        routing of interrupts from these devices in x2APIC mode
        leverages the interrupt remapping architecture specified in the
        Intel Virtualization Technology for Directed I/O, Rev 1.1
        specification.

KVM wants to enable x2apic because it's easier to virtualize and
provides better performance than xapic.  We won't be taking the above
x2apic physical mode path on real hardware though, so I'm not sure that
code snippet is relevant here.

AIUI, platforms that require x2apic (>255 APIC IDs) probably aren't
going to have an option to disable VT-d in the BIOS.  If such a platform
hands off in xapic mode with iommu=off, you stay in xapic mode and don't
bring all the processors online.  If it hands off in x2apic mode with
iommu=off, hopefully we can switch back to xapic mode and lose
processors, but ISTR the x2apic->xapic transition isn't particularly
easy, so you may just be screwed.  Thanks,

Alex

