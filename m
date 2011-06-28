Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757666Ab1F1Mhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 08:37:32 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:18326 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757225Ab1F1MfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 08:35:14 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zz148cM1432N98dKzz1202hzz15d4R8275bh8275dh74efjz32i668h839h34h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LNI2YC-01-842-02
X-M-MSG: 
Date: Tue, 28 Jun 2011 14:35:14 +0200
From: Conny Seidel <conny.seidel@amd.com>
To: Tejun Heo <tj@kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rosenfeld, Hans" <Hans.Rosenfeld@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH tip:x86/urgent] x86-32, NUMA: Fix boot regression caused
 by NUMA init unification on highmem machines
Message-ID: <20110628143514.2e74a0c8.conny.seidel_amd.com@marah.osrc.amd.com>
In-Reply-To: <20110628094107.GB3386@htj.dyndns.org>
References: <20110621174131.054f0422.conny.seidel_amd.com@marah.osrc.amd.com>
	<20110626102235.GC12200@mtj.dyndns.org>
	<20110626223807.47cef5c6.conny.seidel_amd.com@marah.osrc.amd.com>
	<20110628094107.GB3386@htj.dyndns.org>
Organization: Advanced Micro Devices GmbH; Einsteinring 24; 85609 Dornach
 bei Muenchen; Geschaeftsfuehrer: Alberto Bozzo; Sitz: Dornach, Gemeinde
 Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr. 43632
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
	boundary="Sig_/OHq0EN4GI.5EUQNAagK.Fz2";
	protocol="application/pgp-signature"
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/OHq0EN4GI.5EUQNAagK.Fz2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Jun 2011 05:41:07 -0400
Tejun Heo <tj@kernel.org> wrote:

>During 32/64 NUMA init unification, commit 797390d855 "x86-32, NUMA:
>use sparse_memory_present_with_active_regions()" made 32bit mm init
>call memory_present() automatically from active_regions instead of
>leaving it to each NUMA init path.
>
>This commit description is inaccurate - memory_present() calls aren't
>the same for flat and numaq.  After the commit, memory_present() is
>only called for the intersection of e820 and NUMA layout.  Before, on
>flatmem, memory_present() would be called from 0 to max_pfn.  After,
>it would be called only on the areas that e820 indicates to be
>populated.
>
>This is how x86_64 works and should be okay as memmap is allowed to
>contain holes; however, x86_32 DISCONTIGMEM is missing
>early_pfn_valid(), which makes memmap_init_zone() assume that memmap
>doesn't contain any hole.  This leads to the following oops if e820
>map contains holes as it often does on machine with near or more 4GiB
>of memory by calling pfn_to_page() on a pfn which isn't mapped to a
>NUMA node.
>
>  BUG: unable to handle kernel paging request at 000012b0
>  IP: [<c1aa13ce>] memmap_init_zone+0x6c/0xf2
>  *pdpt =3D3D 0000000000000000 *pde =3D3D f000eef3f000ee00
>  Oops: 0000 [#1] SMP
>  last sysfs file:
>  Modules linked in:
>
>  Pid: 0, comm: swapper Not tainted 2.6.39-rc5-00164-g797390d #1 To Be
> Filled By O.E.M. To Be Filled By O.E.M./E350M1 EIP: 0060:[<c1aa13ce>]
> EFLAGS: 00010012 CPU: 0 EIP is at memmap_init_zone+0x6c/0xf2
>  EAX: 00000000 EBX: 000a8000 ECX: 000a7fff EDX: f2c00b80
>  ESI: 000a8000 EDI: f2c00800 EBP: c19ffe54 ESP: c19ffe34
>   DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>  Process swapper (pid: 0, ti=3D3Dc19fe000 task=3D3Dc1a07f60
> task.ti=3D3Dc19fe000) Stack:
>   00000002 00000000 0023f000 00000000 10000000 00000a00 f2c00000
> f2c00b58 c19ffeb0 c1a80f24 000375fe 00000000 f2c00800 00000800
> 00000100 00000030 c1abb768 0000003c 00000000 00000000 00000004
> 00207a02 f2c00800 000375fe Call Trace:
>   [<c1a80f24>] free_area_init_node+0x358/0x385
>   [<c1a81384>] free_area_init_nodes+0x420/0x487
>   [<c1a79326>] paging_init+0x114/0x11b
>   [<c1a6cb13>] setup_arch+0xb37/0xc0a
>   [<c1a69554>] start_kernel+0x76/0x316
>   [<c1a690a8>] i386_start_kernel+0xa8/0xb0
>
>This patch fixes the bug by defining early_pfn_valid() to be the same
>as pfn_valid() when DISCONTIGMEM.
>
>Signed-off-by: Tejun Heo <tj@kernel.org>
>Reported-and-bisected-by: Conny Seidel <conny.seidel@amd.com>
>LKML-Reference:
><20110621174131.054f0422.conny.seidel_amd.com@marah.osrc.amd.com> ---
>Conny, can you please verify this fixes the boot problem you're
>seeing?

Verified, the patch fixes our problem.

>Thanks.

Thanks for fixing this quickly.

> arch/x86/include/asm/mmzone_32.h |    2 ++
> 1 file changed, 2 insertions(+)
>
>diff --git a/arch/x86/include/asm/mmzone_32.h
>b/arch/x86/include/asm/mmzone_32.h index 5e83a41..756d2a7 100644
>--- a/arch/x86/include/asm/mmzone_32.h
>+++ b/arch/x86/include/asm/mmzone_32.h
>@@ -68,6 +68,8 @@ static inline int pfn_valid(int pfn)
> 	return 0;
> }
>
>+#define early_pfn_valid(pfn)	pfn_valid((pfn))
>+
> #endif /* CONFIG_DISCONTIGMEM */
>
> #ifdef CONFIG_NEED_MULTIPLE_NODES
>


##
##################################################################
# Email : conny.seidel@amd.com            GnuPG-Key : 0xA6AB055D #
# Fingerprint: 17C4 5DB2 7C4C C1C7 1452 8148 F139 7C09 A6AB 055D #
##################################################################
# Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach      #
# General Managers: Alberto Bozzoi                               #
# Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen #
#               HRB Nr. 43632                                    #
##################################################################

--Sig_/OHq0EN4GI.5EUQNAagK.Fz2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4JyoMACgkQ8Tl8CaarBV1lEgCgm1aLMjATw3JuJpM3zb9pSUEf
uG4An0XZ4FDQJa/ClPjpS2bhckcUCd5A
=tFZg
-----END PGP SIGNATURE-----

--Sig_/OHq0EN4GI.5EUQNAagK.Fz2--
