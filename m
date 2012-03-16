Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab2CPEXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 00:23:06 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57911 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab2CPEWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 00:22:36 -0400
Date: Fri, 16 Mar 2012 15:20:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] powerpc: remove the remaining CONFIG_PPC_ISERIES pieces
Message-Id: <20120316152013.f0963db1e85f4e8db670762e@canb.auug.org.au>
In-Reply-To: <20120316151459.dab3cdcc2d5984b05e2d2b5c@canb.auug.org.au>
References: <20120316151459.dab3cdcc2d5984b05e2d2b5c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__16_Mar_2012_15_20_13_+1100_OEUw0yll+zD=c0Ym"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__16_Mar_2012_15_20_13_+1100_OEUw0yll+zD=c0Ym
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/boot/Makefile          |    9 +--------
 arch/powerpc/include/asm/dma.h      |    4 ----
 arch/powerpc/include/asm/lppaca.h   |    8 --------
 arch/powerpc/include/asm/spinlock.h |    5 ++---
 arch/powerpc/kernel/asm-offsets.c   |   14 --------------
 5 files changed, 3 insertions(+), 37 deletions(-)

diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index 8844a17..6042e93 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -184,7 +184,6 @@ image-$(CONFIG_PPC_EFIKA)		+=3D zImage.chrp
 image-$(CONFIG_PPC_PMAC)		+=3D zImage.pmac
 image-$(CONFIG_PPC_HOLLY)		+=3D dtbImage.holly
 image-$(CONFIG_PPC_PRPMC2800)		+=3D dtbImage.prpmc2800
-image-$(CONFIG_PPC_ISERIES)		+=3D zImage.iseries
 image-$(CONFIG_DEFAULT_UIMAGE)		+=3D uImage
 image-$(CONFIG_EPAPR_BOOT)		+=3D zImage.epapr
=20
@@ -311,12 +310,6 @@ $(obj)/dtbImage.%: vmlinux $(wrapperbits) $(obj)/%.dtb
 $(obj)/vmlinux.strip: vmlinux
 	$(STRIP) -s -R .comment $< -o $@
=20
-# The iseries hypervisor won't take an ET_DYN executable, so this
-# changes the type (byte 17) in the file to ET_EXEC (2).
-$(obj)/zImage.iseries: vmlinux
-	$(STRIP) -s -R .comment $< -o $@
-	printf "\x02" | dd of=3D$@ conv=3Dnotrunc bs=3D1 seek=3D17
-
 $(obj)/uImage: vmlinux $(wrapperbits)
 	$(call if_changed,wrap,uboot)
=20
@@ -364,7 +357,7 @@ install: $(CONFIGURE) $(addprefix $(obj)/, $(image-y))
 # anything not in $(targets)
 clean-files +=3D $(image-) $(initrd-) cuImage.* dtbImage.* treeImage.* \
 	zImage zImage.initrd zImage.chrp zImage.coff zImage.holly \
-	zImage.iseries zImage.miboot zImage.pmac zImage.pseries \
+	zImage.miboot zImage.pmac zImage.pseries \
 	zImage.maple simpleImage.* otheros.bld *.dtb
=20
 # clean up files cached by wrapper
diff --git a/arch/powerpc/include/asm/dma.h b/arch/powerpc/include/asm/dma.h
index a7e06e2..adadb99 100644
--- a/arch/powerpc/include/asm/dma.h
+++ b/arch/powerpc/include/asm/dma.h
@@ -34,8 +34,6 @@
 /* Doesn't really apply... */
 #define MAX_DMA_ADDRESS		(~0UL)
=20
-#if !defined(CONFIG_PPC_ISERIES) || defined(CONFIG_PCI)
-
 #ifdef HAVE_REALLY_SLOW_DMA_CONTROLLER
 #define dma_outb	outb_p
 #else
@@ -354,7 +352,5 @@ extern int isa_dma_bridge_buggy;
 #define isa_dma_bridge_buggy	(0)
 #endif
=20
-#endif	/* !defined(CONFIG_PPC_ISERIES) || defined(CONFIG_PCI) */
-
 #endif /* __KERNEL__ */
 #endif	/* _ASM_POWERPC_DMA_H */
diff --git a/arch/powerpc/include/asm/lppaca.h b/arch/powerpc/include/asm/l=
ppaca.h
index e0298d2..a76254a 100644
--- a/arch/powerpc/include/asm/lppaca.h
+++ b/arch/powerpc/include/asm/lppaca.h
@@ -41,15 +41,7 @@
  * We only have to have statically allocated lppaca structs on
  * legacy iSeries, which supports at most 64 cpus.
  */
-#ifdef CONFIG_PPC_ISERIES
-#if NR_CPUS < 64
-#define NR_LPPACAS	NR_CPUS
-#else
-#define NR_LPPACAS	64
-#endif
-#else /* not iSeries */
 #define NR_LPPACAS	1
-#endif
=20
=20
 /* The Hypervisor barfs if the lppaca crosses a page boundary.  A 1k
diff --git a/arch/powerpc/include/asm/spinlock.h b/arch/powerpc/include/asm=
/spinlock.h
index f9611bd..7124fc0 100644
--- a/arch/powerpc/include/asm/spinlock.h
+++ b/arch/powerpc/include/asm/spinlock.h
@@ -23,7 +23,6 @@
 #ifdef CONFIG_PPC64
 #include <asm/paca.h>
 #include <asm/hvcall.h>
-#include <asm/iseries/hv_call.h>
 #endif
 #include <asm/asm-compat.h>
 #include <asm/synch.h>
@@ -95,12 +94,12 @@ static inline int arch_spin_trylock(arch_spinlock_t *lo=
ck)
  * value.
  */
=20
-#if defined(CONFIG_PPC_SPLPAR) || defined(CONFIG_PPC_ISERIES)
+#if defined(CONFIG_PPC_SPLPAR)
 /* We only yield to the hypervisor if we are in shared processor mode */
 #define SHARED_PROCESSOR (get_lppaca()->shared_proc)
 extern void __spin_yield(arch_spinlock_t *lock);
 extern void __rw_yield(arch_rwlock_t *lock);
-#else /* SPLPAR || ISERIES */
+#else /* SPLPAR */
 #define __spin_yield(x)	barrier()
 #define __rw_yield(x)	barrier()
 #define SHARED_PROCESSOR	0
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-of=
fsets.c
index cdd0d26..cc492e4 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -46,9 +46,6 @@
 #include <asm/hvcall.h>
 #include <asm/xics.h>
 #endif
-#ifdef CONFIG_PPC_ISERIES
-#include <asm/iseries/alpaca.h>
-#endif
 #ifdef CONFIG_PPC_POWERNV
 #include <asm/opal.h>
 #endif
@@ -384,17 +381,6 @@ int main(void)
 	DEFINE(BUG_ENTRY_SIZE, sizeof(struct bug_entry));
 #endif
=20
-#ifdef CONFIG_PPC_ISERIES
-	/* the assembler miscalculates the VSID values */
-	DEFINE(PAGE_OFFSET_ESID, GET_ESID(PAGE_OFFSET));
-	DEFINE(PAGE_OFFSET_VSID, KERNEL_VSID(PAGE_OFFSET));
-	DEFINE(VMALLOC_START_ESID, GET_ESID(VMALLOC_START));
-	DEFINE(VMALLOC_START_VSID, KERNEL_VSID(VMALLOC_START));
-
-	/* alpaca */
-	DEFINE(ALPACA_SIZE, sizeof(struct alpaca));
-#endif
-
 	DEFINE(PGD_TABLE_SIZE, PGD_TABLE_SIZE);
 	DEFINE(PTE_SIZE, sizeof(pte_t));
=20
--=20
1.7.9.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__16_Mar_2012_15_20_13_+1100_OEUw0yll+zD=c0Ym
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYr99AAoJEECxmPOUX5FEncsP/3OkgLqxeQOYHLXCVLmWtfdO
wBc75yF9VBRhiFyqW7JQMFWcW3E5XFssEEow4Vfc8gAYnq9wE3/QV9jstIaqbaYl
K29x4o7XixHUtwd3lgwSZ2Y8ZULAZUaQSIAP7Qo0F4ml1Kyt+HO0sSfEcN75ixGl
n65KAdxkbpsdFvs8Xi3+7CbSkZgOQ0AfSoDgVmB5OWSwSSDvmAuEoihYc9/73OCk
600ff1UVn36MEcJV6T8U21A5NA+so85tDKhpjJmXYrYPQKV2ucOQkmnuwLPAQLB/
BVdMvlwxKZMvtq4Gw9oigFJ6PQrOk5I6lEQ3k+YXjdUo3boNsFa1RFq4P9QpzY53
drnteFeQjST4U0aHjEgGdYnV3kYAkA4d7Q4VMfnCbLY9pRg6Dw3IHXWV2L43Jq3i
2wACuxN7ZxlBURrBshxMEVMWaZ1f97075E4k3XZG4hPXmkeDpGpmYmtrF1wjiViG
O1/GG1i46vCH8XYNHhZgC2HEVhw5hWvQ7cRso2V1i0AONq7obJjNdcSCRvXaCSBK
OnpKDdvfqATC7pGc3f9igBEuftNPyA5vTX2ZHyOFcT9tEPTAHv9rXm+e2WTu5Q9E
RKki4mu08/XM6tBVV2BCD1Nj4TqX8Qmh5KYG/dbdJMEoIsnbHECAaSBRQdgpirih
9dxUWJOH7Kj4rLiO6G96
=oID9
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Mar_2012_15_20_13_+1100_OEUw0yll+zD=c0Ym--
