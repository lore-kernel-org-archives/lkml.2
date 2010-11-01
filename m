Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594Ab0KAQge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 12:36:34 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:24936 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab0KAQgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 12:36:31 -0400
X-IronPort-AV: E=Sophos;i="4.58,274,1286164800"; 
   d="scan'208";a="120599021"
Subject: Re: [GIT PULL] Small Xen bugfixes
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Vasiliy G Tolstov <v.tolstov@selfip.ru>
In-Reply-To: <4CCD9935.50308@goop.org>
References: <4CCB1906.4000608@goop.org>
	 <AANLkTi=g5sdiWSaLUHAATQn-1=jPqtc=RL6SpYSMYn98@mail.gmail.com>
	 <4CCB1E71.3060600@goop.org>  <4CCB292E.9090602@goop.org>
	 <1288516429.16032.13.camel@localhost.localdomain> <4CCD9935.50308@goop.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Mon, 1 Nov 2010 16:36:28 +0000
Message-ID: <1288629388.13236.4583.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-31 at 16:28 +0000, Jeremy Fitzhardinge wrote:
> On 10/31/2010 02:13 AM, Ian Campbell wrote:
> >> The 3rd is certainly simplest, at the cost of wasting a trivial amount
> >> of memory.
> > Doesn't Linux avoid using the lowest 1M anyway? (obviously apart from
> > the start of day probing for firmware tables etc).
> 
> No, it tries to use most of it I think.  It will tend to avoid the low
> 64k (maybe more) to avoid BIOS bugs.

It'll be interesting to see what effect Vista's avoidance of the whole
region (so I hear) has on BIOS vendors... (I think we can all guess)

> >>   Unfortunately it crashes early.  Sigh, will try and sort it
> >> out this afternoon.
> > Strange!
> 
> I didn't get a chance to poke at it again, but in retrospect, I think
> there are various "must succeed" allocations in low memory.  We don't
> need those allocations (things like AP boot trampoline, etc), but we
> don't bother to stub them out or prevent them from happening.  Reducing
> the system to one with *no* allocatable memory below 1M is just too
> strange, and would be a continuous source of problems in the future.

Agreed, we should try and mimic native as far as possible in this regard
or I fear we will see a never ending stream of little quirks and
oddities related to this sort of thing.

> Of the other two options, I think your original approach is going to be
> simplest.  E820 gap filling wouldn't be too bad, but we'd end up having
> to add a bit of gap-tracking logic to the E820 loop which isn't
> currently there.

It would also make us susceptible to perhaps being a bit fragile in the
face of unexpectedly insane e820s coming from the BIOS.

> Ignoring sub-1M gaps is simpler (and it needn't be
> conditional on xen_initial_domain(), because we would never expect to
> see anything strange sub-1M in a domU, and if there is, we should still
> be careful of it in case something odd is going on).

Absolutely.

I wonder if we shouldn't also do the following (note: untested). Since
Xen avoids using the sub-1M region for anything I think it is reasonable
to give the whole lot over to domain 0 for the purposes of finding
firmware table stashed in odd locations etc.

Ian.

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index ebb74ec..ab086e5 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2321,7 +2321,7 @@ __init void xen_ident_map_ISA(void)
 
 	xen_raw_printk("Xen: setup ISA identity maps\n");
 
-	for (pa = ISA_START_ADDRESS; pa < ISA_END_ADDRESS; pa += PAGE_SIZE) {
+	for (pa = 0; pa < ISA_END_ADDRESS; pa += PAGE_SIZE) {
 		pte_t pte = mfn_pte(PFN_DOWN(pa), PAGE_KERNEL_IO);
 
 		if (HYPERVISOR_update_va_mapping(PAGE_OFFSET + pa, pte, 0))


