Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab2DWJSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 05:18:10 -0400
Received: from mail.univention.de ([82.198.197.8]:2548 "EHLO
	mail.univention.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab2DWJSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 05:18:06 -0400
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Apr 2012 05:18:05 EDT
From: Philipp Hahn <hahn@univention.de>
Organization: Univention.de
To: stable@vger.kernel.org
Subject: [2.6.32.y][PATCH] fix pgd_lock deadlock
Date: Mon, 23 Apr 2012 11:07:53 +0200
User-Agent: KMail/1.9.10 (enterprise35 20100903.1171286)
Cc: Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@novell.com>, Andi Kleen <ak@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <jweiner@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Larry Woodman <lwoodman@redhat.com>, Rik van Riel <riel@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, 669335@bugs.debian.org
References: <alpine.LFD.2.00.1102152020590.26192@localhost6.localdomain6> <20110216102801.GA23082@elte.hu> <20110216144947.GA5935@random.random>
In-Reply-To: <20110216144947.GA5935@random.random>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3305640.1Wn9ajbPI9";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201204231107.59484.hahn@univention.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3305640.1Wn9ajbPI9
Content-Type: multipart/mixed;
  boundary="Boundary-01=_pvRlPD89MtYHNRe"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_pvRlPD89MtYHNRe
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

On Wednesday 16 February 2011 15:49:47 Andrea Arcangeli wrote:
> Subject: fix pgd_lock deadlock
>
> From: Andrea Arcangeli <aarcange@redhat.com>
>
> It's forbidden to take the page_table_lock with the irq disabled or if
> there's contention the IPIs (for tlb flushes) sent with the page_table_lo=
ck
> held will never run leading to a deadlock.
>
> Apparently nobody takes the pgd_lock from irq so the _irqsave can be
> removed.
>
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>

This patch (original commit Id for 2.6.38=20
a79e53d85683c6dd9f99c90511028adc2043031f) needs to be back-ported to 2.6.32=
=2Ex=20
as well.
I observed a dead-lock problem when running a PAE enabled Debian 2.6.32.46+=
=20
kernel with 6 VCPUs as a KVM on (2.6.32, 3.2, 3.3) kernel, which showed the=
=20
following behaviour:

1 VCPU is stuck in
  pgd_alloc() =E2=86=92 pgd_prepopulate_pmb() =E2=86=92... =E2=86=92  flush=
_tlb_others_ipi()
while (!cpumask_empty(to_cpumask(f->flush_cpumask)))
    cpu_relax();
(gdb) print f->flush_cpumask
$5 =3D {1}

while all other VCPUs are stuck in
  pgd_alloc() =E2=86=92 spin_lock_irqsave(pgd_lock)

I tracked it down to the commit
 2.6.39-rc1: 4981d01eada5354d81c8929d5b2836829ba3df7b
 2.6.32.34: ba456fd7ec1bdc31a4ad4a6bd02802dcaa730a33
 x86: Flush TLB if PGD entry is changed in i386 PAE mode
which when reverted made the bug disappear.

Comparing 3.2 to 2.6.32.34 showed that the 'pgd-deadlock'-patch went into=20
2.6.38, that is before the 'PAE correctness'-patch, so the problem was=20
probably never observed in the main development branch.
But for 2.6.32 the 'pgd-deadlock' patch is still missing, so the 'PAE=20
corretness'-patch made the problem worse with 2.6.32.

The Patch was also back-ported to the OpenSUSE Kernel
<http://kernel.opensuse.org/cgit/kernel-source/commit/?id=3Dac27c01aa880c65=
d17043ab87249c613ac4c3635>,
Since the patch didn't apply cleanly on the current Debian kernel, I had to=
=20
backport it for us and Debian. The patch is also available from our (German=
)=20
Bugzilla <https://forge.univention.org/bugzilla/show_bug.cgi?id=3D26661> or=
=20
from the Debian BTS at=20
<http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D669335>.

I have no easy test case, but running multiple parallel builds inside the V=
M=20
normally triggers the bug within seconds to minutes. With the patch applied=
=20
the VM survived a night building packages without any problem.

Signed-off-by: Philipp Hahn <hahn@univention.de>

Sincerely
Philipp
=2D-=20
Philipp Hahn           Open Source Software Engineer      hahn@univention.de
Univention GmbH        be open.                       fon: +49 421 22 232- 0
Mary-Somerville-Str.1  D-28359 Bremen                 fax: +49 421 22 232-99
                                                   http://www.univention.de/

--Boundary-01=_pvRlPD89MtYHNRe
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="x86-mm-Fix-pgd_lock-deadlock.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="x86-mm-Fix-pgd_lock-deadlock.patch"

It's forbidden to take the page_table_lock with the irq disabled
or if there's contention the IPIs (for tlb flushes) sent with
the page_table_lock held will never run leading to a deadlock.

Nobody takes the pgd_lock from irq context so the _irqsave can be
removed.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@kernel.org>
LKML-Reference: <201102162345.p1GNjMjm021738@imap1.linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Git-commit: a79e53d85683c6dd9f99c90511028adc2043031f
=2D-- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -223,15 +223,14 @@ void vmalloc_sync_all(void)
 	     address >=3D TASK_SIZE && address < FIXADDR_TOP;
 	     address +=3D PMD_SIZE) {
=20
=2D		unsigned long flags;
 		struct page *page;
=20
=2D		spin_lock_irqsave(&pgd_lock, flags);
+		spin_lock(&pgd_lock);
 		list_for_each_entry(page, &pgd_list, lru) {
 			if (!vmalloc_sync_one(page_address(page), address))
 				break;
 		}
=2D		spin_unlock_irqrestore(&pgd_lock, flags);
+		spin_unlock(&pgd_lock);
 	}
 }
=20
@@ -331,13 +330,12 @@ void vmalloc_sync_all(void)
 	     address +=3D PGDIR_SIZE) {
=20
 		const pgd_t *pgd_ref =3D pgd_offset_k(address);
=2D		unsigned long flags;
 		struct page *page;
=20
 		if (pgd_none(*pgd_ref))
 			continue;
=20
=2D		spin_lock_irqsave(&pgd_lock, flags);
+		spin_lock(&pgd_lock);
 		list_for_each_entry(page, &pgd_list, lru) {
 			pgd_t *pgd;
 			pgd =3D (pgd_t *)page_address(page) + pgd_index(address);
@@ -346,7 +344,7 @@ void vmalloc_sync_all(void)
 			else
 				BUG_ON(pgd_page_vaddr(*pgd) !=3D pgd_page_vaddr(*pgd_ref));
 		}
=2D		spin_unlock_irqrestore(&pgd_lock, flags);
+		spin_unlock(&pgd_lock);
 	}
 }
=20
=2D-- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -56,12 +56,10 @@ static unsigned long direct_pages_count[
=20
 void update_page_count(int level, unsigned long pages)
 {
=2D	unsigned long flags;
=2D
 	/* Protect against CPA */
=2D	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 	direct_pages_count[level] +=3D pages;
=2D	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 }
=20
 static void split_page_count(int level)
@@ -354,7 +352,7 @@ static int
 try_preserve_large_page(pte_t *kpte, unsigned long address,
 			struct cpa_data *cpa)
 {
=2D	unsigned long nextpage_addr, numpages, pmask, psize, flags, addr, pfn;
+	unsigned long nextpage_addr, numpages, pmask, psize, addr, pfn;
 	pte_t new_pte, old_pte, *tmp;
 	pgprot_t old_prot, new_prot;
 	int i, do_split =3D 1;
@@ -363,7 +361,7 @@ try_preserve_large_page(pte_t *kpte, uns
 	if (cpa->force_split)
 		return 1;
=20
=2D	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 	/*
 	 * Check for races, another CPU might have split this page
 	 * up already:
@@ -458,14 +456,14 @@ try_preserve_large_page(pte_t *kpte, uns
 	}
=20
 out_unlock:
=2D	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
=20
 	return do_split;
 }
=20
 static int split_large_page(pte_t *kpte, unsigned long address)
 {
=2D	unsigned long flags, pfn, pfninc =3D 1;
+	unsigned long pfn, pfninc =3D 1;
 	unsigned int i, level;
 	pte_t *pbase, *tmp;
 	pgprot_t ref_prot;
@@ -479,7 +477,7 @@ static int split_large_page(pte_t *kpte,
 	if (!base)
 		return -ENOMEM;
=20
=2D	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 	/*
 	 * Check for races, another CPU might have split this page
 	 * up for us already:
@@ -551,7 +549,7 @@ out_unlock:
 	 */
 	if (base)
 		__free_page(base);
=2D	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
=20
 	return 0;
 }
=2D-- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -110,14 +110,12 @@ static void pgd_ctor(pgd_t *pgd)
=20
 static void pgd_dtor(pgd_t *pgd)
 {
=2D	unsigned long flags; /* can be called from interrupt context */
=2D
 	if (SHARED_KERNEL_PMD)
 		return;
=20
=2D	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 	pgd_list_del(pgd);
=2D	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 }
=20
 /*
@@ -248,7 +246,6 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 {
 	pgd_t *pgd;
 	pmd_t *pmds[PREALLOCATED_PMDS];
=2D	unsigned long flags;
=20
 	pgd =3D (pgd_t *)__get_free_page(PGALLOC_GFP);
=20
@@ -268,12 +265,12 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 	 * respect to anything walking the pgd_list, so that they
 	 * never see a partially populated pgd.
 	 */
=2D	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
=20
 	pgd_ctor(pgd);
 	pgd_prepopulate_pmd(mm, pgd, pmds);
=20
=2D	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
=20
 	return pgd;
=20
=2D-- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -988,10 +988,9 @@ static void xen_pgd_pin(struct mm_struct
  */
 void xen_mm_pin_all(void)
 {
=2D	unsigned long flags;
 	struct page *page;
=20
=2D	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
=20
 	list_for_each_entry(page, &pgd_list, lru) {
 		if (!PagePinned(page)) {
@@ -1000,7 +999,7 @@ void xen_mm_pin_all(void)
 		}
 	}
=20
=2D	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 }
=20
 /*
@@ -1101,10 +1100,9 @@ static void xen_pgd_unpin(struct mm_stru
  */
 void xen_mm_unpin_all(void)
 {
=2D	unsigned long flags;
 	struct page *page;
=20
=2D	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
=20
 	list_for_each_entry(page, &pgd_list, lru) {
 		if (PageSavePinned(page)) {
@@ -1114,7 +1112,7 @@ void xen_mm_unpin_all(void)
 		}
 	}
=20
=2D	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 }
=20
 void xen_activate_mm(struct mm_struct *prev, struct mm_struct *next)

--Boundary-01=_pvRlPD89MtYHNRe--

--nextPart3305640.1Wn9ajbPI9
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAk+VG+kACgkQYPlgoZpUDjnvpACfbZnpDnPP5dx2+TjuFhM9AtZ/
yjQAoJVLKtP1/5kYVYQ5F/WQlky36wzM
=MLkg
-----END PGP SIGNATURE-----

--nextPart3305640.1Wn9ajbPI9--
