Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab1AXN5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 08:57:52 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:27640 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab1AXN5u (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 24 Jan 2011 08:57:50 -0500
Date: Fri, 21 Jan 2011 18:20:12 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: matthieu castet <castet.matthieu@free.fr>
Cc: Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Kees Cook <kees.cook@canonical.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "keir.fraser@eu.citrix.com" <keir.fraser@eu.citrix.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "sliakh.lkml@gmail.com" <sliakh.lkml@gmail.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "ak@muc.de" <ak@muc.de>, "davej@redhat.com" <davej@redhat.com>,
        "jiang@cs.ncsu.edu" <jiang@cs.ncsu.edu>,
        "arjan@infradead.org" <arjan@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Stefan Bader <stefan.bader@canonical.com>
Subject: Re: [tip:x86/security] x86: Add NX protection for kernel data
Message-ID: <20110121232012.GA17652@dumpdata.com>
References: <20110119235957.6ea35dc8@mat-laptop>
 <20110119233824.GA2869@dumpdata.com>
 <1295522306.4d381a02b1e10@imp.free.fr>
 <20110120150618.GC5092@dumpdata.com>
 <1295537856.14780.54.camel@zakaz.uk.xensource.com>
 <20110120190531.GA9687@dumpdata.com>
 <4D3899AB.60207@free.fr>
 <20110120210436.GA1810@dumpdata.com>
 <20110120211939.GA32262@dumpdata.com>
 <20110120215556.GA29700@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110120215556.GA29700@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So this patch fixes the regression and allows to boot Linux on Xen.
It does not affect negatively baremetal (tried x86_32 and x86_64).

The debugfs pagetable looks exactly as before this patch (from
__init_end and to further it expands as time goes on):
0xc14e7000-0xccc00000      187492K     RW             GLB NX pte.

I am concerned with 64edc8ed5ffae999d8d413ba006850e9e34166cb
(x86: Fix improper large page preservation) as it would make it possible
for the .bss sections to have RO pages in it - which would inhibit
the kernel from collapsing the small pages into a large one. However on
the machines I boot this patched kernel up it had no trouble
collapsing small pages in a large one (it also did not have
any pages in .bss section set to RO). Are there any known
(besides Xen) sections of code that sets pages in .bss and .data to RO?

commit 0390f0a87470fd2686c4eed6ace28443f8cc9b2f
Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date:   Fri Jan 21 11:23:39 2011 -0500

    x86: Don't force in .bss everything to RW.
    
    If there are pages there which are RO leave them be. Otherwise
    set them to RW.
    
    This fixes a bug where under Xen we would get:
    (XEN) mm.c:2389:d0 Bad type (saw 3c000003 != exp 70000000) for mfn 1335a1 (pfn 15a1)
    (XEN) mm.c:889:d0 Error getting mfn 1335a1 (pfn 15a1) from L1 entry 80000001335a1063 for l1e_owner=0, pg_owner=0
    (XEN) mm.c:4939:d0 ptwr_emulate: could not get_page_from_l1e()
    [    8.296405] BUG: unable to handle kernel paging request at cb159d08
    [    8.296405] IP: [<c1005ff4>] xen_set_pte_atomic+0x21/0x2f
    [    8.296405] *pdpt = 000000000165e001 *pde = 000000000b1a7067 *pte = 800000000b159061
    
    B/c we tried to set RW on the swapper_pg_dir, which had been
    set to RO by the Xen init code (xen_write_cr3_init) and MUST be
    RO (so that the Xen hypervisor can be assured that the guest is not
    messing with the pagetables on its own).
    
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 8b830ca..53b99e3 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -283,11 +283,18 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 		   __pa((unsigned long)__end_rodata) >> PAGE_SHIFT))
 		pgprot_val(forbidden) |= _PAGE_RW;
 	/*
-	 * .data and .bss should always be writable.
+	 * .data and .bss ought to be writable. But if there is a RO
+	 * in there, don't force RW on it.
 	 */
 	if (within(address, (unsigned long)_sdata, (unsigned long)_edata) ||
-	    within(address, (unsigned long)__bss_start, (unsigned long)__bss_stop))
-		pgprot_val(required) |= _PAGE_RW;
+	    within(address, (unsigned long)__bss_start, (unsigned long)__bss_stop)) {
+		unsigned int level;
+		pte_t *pte = lookup_address(address, &level);
+		pgprot_t prot = ((pte) ? pte_pgprot(*pte) : __pgprot(0));
+
+		if ((pgprot_val(prot) & _PAGE_RW))
+			pgprot_val(required) |= _PAGE_RW;
+	}
 
 #if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)
 	/*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
