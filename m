Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab2CTTEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 15:04:10 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:44905 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab2CTTEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 15:04:08 -0400
Date: Tue, 20 Mar 2012 14:58:41 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Josh Boyer <jwboyer@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org,
        midgoon@gmail.com
Subject: Re: 3.2.1 Unable to reset IRR messages on boot
Message-ID: <20120320185841.GF29554@phenom.dumpdata.com>
References: <1327529048.2327.17.camel@sbsiddha-mobl2>
 <20120125231534.GL13655@zod.bos.redhat.com>
 <20120131142621.GA2136@zod.bos.redhat.com>
 <1328083230.3638.2.camel@sbsiddha-mobl2>
 <20120312132448.GA20204@zod.bos.redhat.com>
 <1331577393.31585.94.camel@sbsiddha-desk.sc.intel.com>
 <20120319133046.GB13093@zod.bos.redhat.com>
 <20120319193842.GA8123@phenom.dumpdata.com>
 <20120320094048.GC20079@phenom.dumpdata.com>
 <1332267178.16101.66.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332267178.16101.66.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090204.4F68D461.010F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 11:12:58AM -0700, Suresh Siddha wrote:
> On Tue, 2012-03-20 at 05:40 -0400, Konrad Rzeszutek Wilk wrote:
> > I think there are three ways of fixing this:
> > 
> >  1). Revert Suresh's patch and look at just removing the "Unable to reset IRR" warning
> >     (perhaps by being conditional on running in kexec-env?).
> > 
> >  2). Make the Xen layer fake out an IOAPIC - so instead of 0xffffff, make sure to
> >      clear the three bits that Suresh' patch is testing for (Ewwwww, I don't actually
> >      like that - that stinks of a hack).
> > 
> >  3). Rework Suresh's patch - to only remove the IOAPIC entry if there is no
> >      INT_SRV_OVR that depend on it. I made a stab at it and here is draft patch, that
> >      looks to work on my boxes that have more than one IOAPIC and are booting under Xen:
> >      But I am not 100% confident about it so would appreciate somebody looking at it.
> > 
> 
> Thanks for looking at this Konrad. This issue is not just specific to
> INT_SRC_OVR per-say.
> 
> Issue is that Xen though it doesn't use IO-APIC, it does depend on
> proper IO-APIC parsing for various things like getting proper gsi_top,
> INT_SRV_OVR entries etc.
> 
> I think Xen should be setting up a valid dummy IO-APIC mapping instead
> of working around.

Then this fixes the issue - thought if there are more checks in the future
it will have to be redone..:

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 988828b..b8e2794 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1859,6 +1859,7 @@ pgd_t * __init xen_setup_kernel_pagetable(pgd_t *pgd,
 #endif	/* CONFIG_X86_64 */
 
 static unsigned char dummy_mapping[PAGE_SIZE] __page_aligned_bss;
+static unsigned char fake_ioapic_mapping[PAGE_SIZE] __page_aligned_bss;
 
 static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 {
@@ -1899,7 +1900,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 		 * We just don't map the IO APIC - all access is via
 		 * hypercalls.  Keep the address in the pte for reference.
 		 */
-		pte = pfn_pte(PFN_DOWN(__pa(dummy_mapping)), PAGE_KERNEL);
+		pte = pfn_pte(PFN_DOWN(__pa(fake_ioapic_mapping)), PAGE_KERNEL);
 		break;
 #endif
 
@@ -2064,6 +2065,7 @@ void __init xen_init_mmu_ops(void)
 	pv_mmu_ops = xen_mmu_ops;
 
 	memset(dummy_mapping, 0xff, PAGE_SIZE);
+	memset(fake_ioapic_mapping, 0xfd, PAGE_SIZE);
 }
 
 /* Protected by xen_reservation_lock. */
> 
> thanks,
> suresh
