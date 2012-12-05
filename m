Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab2LEQUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:20:53 -0500
Received: from multi.imgtec.com ([194.200.65.239]:51591 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842Ab2LEQJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:09:27 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 12/44] metag: TBX source
Date: Wed, 5 Dec 2012 16:08:30 +0000
Message-ID: <1354723742-6195-13-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_12_05_16_09_18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add source files from the Thread Binary Interface (TBI) library which
provides useful low level operations and traps/context management.

Among other things it handles interrupt/exception/syscall entry
(in tbipcx.S), and some low level cache flushing (tbicache.c).

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/tbx/tbicache.c  |  462 ++++++++++++++++++++++++++++++++++++++++++++
 arch/metag/tbx/tbicore.S   |  136 +++++++++++++
 arch/metag/tbx/tbictx.S    |  366 +++++++++++++++++++++++++++++++++++
 arch/metag/tbx/tbictxfpu.S |  190 ++++++++++++++++++
 arch/metag/tbx/tbidefr.S   |  175 +++++++++++++++++
 arch/metag/tbx/tbidspram.S |  161 +++++++++++++++
 arch/metag/tbx/tbilogf.S   |   48 +++++
 arch/metag/tbx/tbipcx.S    |  451 ++++++++++++++++++++++++++++++++++++++++++
 arch/metag/tbx/tbiroot.S   |   87 +++++++++
 arch/metag/tbx/tbisoft.S   |  237 +++++++++++++++++++++++
 arch/metag/tbx/tbistring.c |  145 ++++++++++++++
 arch/metag/tbx/tbitimer.S  |  207 ++++++++++++++++++++
 12 files changed, 2665 insertions(+), 0 deletions(-)
 create mode 100644 arch/metag/tbx/tbicache.c
 create mode 100644 arch/metag/tbx/tbicore.S
 create mode 100644 arch/metag/tbx/tbictx.S
 create mode 100644 arch/metag/tbx/tbictxfpu.S
 create mode 100644 arch/metag/tbx/tbidefr.S
 create mode 100644 arch/metag/tbx/tbidspram.S
 create mode 100644 arch/metag/tbx/tbilogf.S
 create mode 100644 arch/metag/tbx/tbipcx.S
 create mode 100644 arch/metag/tbx/tbiroot.S
 create mode 100644 arch/metag/tbx/tbisoft.S
 create mode 100644 arch/metag/tbx/tbistring.c
 create mode 100644 arch/metag/tbx/tbitimer.S

diff --git a/arch/metag/tbx/tbicache.c b/arch/metag/tbx/tbicache.c
new file mode 100644
index 0000000..dfe365f
--- /dev/null
+++ b/arch/metag/tbx/tbicache.c
@@ -0,0 +1,462 @@
+/*
+ * tbicache.c
+ *
+ * Copyright (C) 2001, 2002, 2005, 2007, 2012 Imagination Technologies.
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ *
+ * Cache control code shared as part of TBI
+ */
+
+#include <linux/stddef.h>
+#include <asm/metag_isa.h>
+#include <asm/metag_mem.h>
+#include <asm/metag_regs.h>
+#include <asm/tbx.h>
+
+#define DEFAULT_CACHE_WAYS_LOG2	2
+
+/* Size of a set in the caches. Initialised for default 16K stride, adjusted
+ * according to values passed through TBI global heap segment via LDLK (on ATP)
+ * or config registers (on HTP/MTP)
+ */
+static int __TBICacheDSetShift = METAG_TBI_CACHE_SIZE_BASE_LOG2-DEFAULT_CACHE_WAYS_LOG2;
+static int __TBICacheISetShift = METAG_TBI_CACHE_SIZE_BASE_LOG2-DEFAULT_CACHE_WAYS_LOG2;
+/* The number of sets in the caches. Initialised for HTP/ATP, adjusted
+ * according to NOMMU setting in config registers
+ */
+static unsigned char __TBICacheDSetsLog2 = DEFAULT_CACHE_WAYS_LOG2;
+static unsigned char __TBICacheISetsLog2 = DEFAULT_CACHE_WAYS_LOG2;
+
+static int __TBICacheDoneInit = 0;
+
+static void __TBICacheInit( void )
+{
+
+	int version = *(volatile int*)METAC_ID;
+	
+	if ((version & METAC_ID_MAJOR_BITS) >= (0x02 << METAC_ID_MAJOR_S))
+	{
+		int coreid = *(volatile int*)METAC_CORE_ID;
+		int config = *(volatile int*)METAC_CORE_CONFIG2;
+		int cfgcache = coreid & METAC_COREID_CFGCACHE_BITS;
+
+		if (   cfgcache == METAC_COREID_CFGCACHE_TYPE0
+		    || cfgcache == METAC_COREID_CFGCACHE_PRIVNOMMU
+				)
+		{
+			__TBICacheISetsLog2 = 1;
+			__TBICacheDSetsLog2 = 1;
+		}
+
+		/* For normal size caches, the smallest size is 4Kb.
+		   For small caches, the smallest size is 64b */
+		__TBICacheISetShift = (config & METAC_CORECFG2_ICSMALL_BIT) ? 6 : 12;
+		__TBICacheISetShift += ((config & METAC_CORE_C2ICSZ_BITS) >> METAC_CORE_C2ICSZ_S);
+		__TBICacheISetShift -= __TBICacheISetsLog2;
+
+		__TBICacheDSetShift = (config & METAC_CORECFG2_DCSMALL_BIT) ? 6 : 12;
+		__TBICacheDSetShift += ((config & METAC_CORECFG2_DCSZ_BITS) >> METAC_CORECFG2_DCSZ_S);
+		__TBICacheDSetShift -= __TBICacheDSetsLog2;
+	}
+	else
+	{
+		/* Extract cache sizes from global heap segment */
+		unsigned long val, u;
+		int width, shift, addend;
+
+		PTBISEG pSeg = __TBIFindSeg( NULL, TBID_SEG( TBID_THREAD_GLOBAL,
+		                             TBID_SEGSCOPE_GLOBAL, TBID_SEGTYPE_HEAP) );
+		if ( pSeg != NULL )
+		{
+			val = pSeg->Data[1];
+
+			/* Work out width of I-cache size bit-field */
+			u = ((unsigned long) METAG_TBI_ICACHE_SIZE_BITS)
+			       >> METAG_TBI_ICACHE_SIZE_S;
+			width = 0;
+			while ( u & 1 )
+			{
+				width++;
+				u >>= 1;
+			}
+			/* Extract sign-extended size addend value */
+			shift = 32 - (METAG_TBI_ICACHE_SIZE_S + width);
+			addend = (long) ((val & METAG_TBI_ICACHE_SIZE_BITS) << shift)
+			           >> (shift + METAG_TBI_ICACHE_SIZE_S);
+			/* Now calculate I-cache set size */
+			__TBICacheISetShift = (METAG_TBI_CACHE_SIZE_BASE_LOG2-DEFAULT_CACHE_WAYS_LOG2)
+			                        + addend;
+
+			/* Similarly for D-cache */
+			u = ((unsigned long) METAG_TBI_DCACHE_SIZE_BITS)
+			       >> METAG_TBI_DCACHE_SIZE_S;
+			width = 0;
+			while ( u & 1 )
+			{
+				width++;
+				u >>= 1;
+			}
+			shift = 32 - (METAG_TBI_DCACHE_SIZE_S + width);
+			addend = (long) ((val & METAG_TBI_DCACHE_SIZE_BITS) << shift)
+			           >> (shift + METAG_TBI_DCACHE_SIZE_S);
+			__TBICacheDSetShift = (METAG_TBI_CACHE_SIZE_BASE_LOG2-DEFAULT_CACHE_WAYS_LOG2)
+			                        + addend;
+		}
+	}
+
+	__TBICacheDoneInit = 1;
+}
+
+void __TBIDataCacheFlush( const void *pStart, int Bytes )
+{
+	volatile int *pCtrl = (volatile int *) SYSC_CACHE_MMU_CONFIG;
+
+	if ( !__TBICacheDoneInit )
+		__TBICacheInit();
+
+	if ( (pCtrl[0] & SYSC_CMMUCFG_DC_ON_BIT) == 0 )
+	{
+		/* No need to flush the data cache it's not actually enabled */
+		return;
+	} 
+
+	{
+		/* Use a sequence of writes to flush the cache region requested */
+		volatile char *pFlush0;
+		int Loops, Step;
+		int Thread = (TBI_GETREG(TXENABLE) & TXENABLE_THREAD_BITS)>>
+		                                     TXENABLE_THREAD_S      ;
+	
+		if ( Bytes >= 4096 )
+		{
+			volatile char *pFlush1;
+			volatile char *pFlush2;
+			volatile char *pFlush3;
+
+			/* Cache is broken into sets which lie in contiguous RAMs */
+			int SetShift = __TBICacheDSetShift;
+			
+			/* Move to the base of the physical cache flush region */
+			pFlush0 = (volatile char *) LINSYSCFLUSH_DCACHE_LINE;
+			Step    = 64;
+
+#ifdef METAC_1_1
+			/* Set size */
+			Loops = 1<<SetShift;
+			
+			if ( ( (Mode & MMCU_xCACHE_CTRL_PARTITION_BIT) != 0 ) &&
+				 ( ((int) pStart) >= 0 )                             )
+			{
+				/* Only flush the 4K quarter that can contain local addrs */
+				Loops >>= 2;
+				pFlush0 += Loops * Thread;
+			}
+#else
+			{
+				/* Get partition data for this thread */
+				int Part = ((volatile int *) (SYSC_DCPART0 +
+				              (SYSC_xCPARTn_STRIDE*Thread)   ))[0];
+				int Offset;
+				
+				if ( ((int) pStart) < 0 )
+				{
+					/* Access Global vs Local partition */ 
+					Part >>= SYSC_xCPARTG_AND_S-SYSC_xCPARTL_AND_S;
+				}
+				
+				/* Extract Offset and move SetOff */
+				Offset = (Part & SYSC_xCPARTL_OR_BITS) >> SYSC_xCPARTL_OR_S;
+				pFlush0 += (Offset << (SetShift - 4));
+
+				/* Shrink size */
+				Part = (Part & SYSC_xCPARTL_AND_BITS) >> SYSC_xCPARTL_AND_S;
+				Loops = ((Part + 1) << (SetShift - 4));
+			}
+#endif
+			/* Reduce Loops by step of cache line size */
+			Loops /= Step;
+
+			pFlush1 = pFlush0 + (1 << SetShift);
+			pFlush2 = pFlush0 + (2 << SetShift);
+			pFlush3 = pFlush0 + (3 << SetShift);
+
+			if (__TBICacheDSetsLog2 == 1)
+			{
+				pFlush2 = pFlush1;
+				pFlush3 = pFlush1 + Step;
+				pFlush1 = pFlush0 + Step;
+				Step  <<= 1;
+				Loops >>= 1;
+			}
+			
+			/* Clear Loops ways in cache */
+			while ( Loops-- != 0 )
+			{
+				/* Clear the ways. */
+#if 0
+				/* GCC 2.95 doesnt generate very good code for this so we
+				 * provide inline assembly instead.
+				 */
+				*pFlush0 = 0;
+				*pFlush1 = 0;
+				*pFlush2 = 0;
+				*pFlush3 = 0;
+
+				pFlush0 += Step;
+				pFlush1 += Step;
+				pFlush2 += Step;
+				pFlush3 += Step;
+#else
+				asm volatile (
+					"SETB\t[%0+%4++],%5\n"
+					"SETB\t[%1+%4++],%5\n"
+					"SETB\t[%2+%4++],%5\n"
+					"SETB\t[%3+%4++],%5\n"
+					: "+e" (pFlush0), "+e" (pFlush1), "+e" (pFlush2), "+e" (pFlush3) 
+					: "e" (Step), "a" (0));
+#endif
+			}
+		}
+		else
+		{
+#ifdef METAC_1_1
+			/* Use linear cache flush mechanism */
+			pFlush0 = (volatile char *) (((unsigned int) pStart) >>
+			                            LINSYSLFLUSH_S            );
+			Loops  = (((int) pStart) & ((1<<LINSYSLFLUSH_S)-1)) + Bytes + 
+			                                ((1<<LINSYSLFLUSH_S)-1)   ;
+			Loops  >>= LINSYSLFLUSH_S;
+
+#define PRIM_FLUSH( _addr, _offset ) _addr[_offset] = 0
+
+#define LOOP_INC 4
+#else
+			/* Use linear cache flush mechanism on META IP */
+			pFlush0 = (volatile char *) ((int) pStart);
+			Loops  = (((int) pStart) & (DCACHE_LINE_BYTES-1)) + Bytes + 
+			                                (DCACHE_LINE_BYTES-1)   ;
+			Loops  >>= DCACHE_LINE_S;
+
+#define PRIM_FLUSH( Addr, Offset )                                          {\
+	int __Addr = ((int) (Addr)) + ((Offset) * 64);                           \
+	TBIDCACHE_FLUSH( __Addr );                                               }
+
+#define LOOP_INC (4*64)
+#endif
+
+			do
+			{
+				/* By default stop */
+				Step = 0;
+				
+				switch ( Loops )
+				{
+					/* Drop Thru Cases! */
+					default: PRIM_FLUSH( pFlush0, 3 );
+					         Loops -= 4;
+					         Step = 1;
+					case 3:  PRIM_FLUSH( pFlush0, 2 );
+					case 2:  PRIM_FLUSH( pFlush0, 1 );
+					case 1:  PRIM_FLUSH( pFlush0, 0 );
+					         pFlush0 += LOOP_INC;
+					case 0:	 break;
+				}
+			}
+			while ( Step ); 
+		}
+	}
+}
+
+void __TBICodeCacheFlush( const void *pStart, int Bytes )
+{
+	volatile int *pCtrl = (volatile int *) SYSC_CACHE_MMU_CONFIG;
+
+	if ( !__TBICacheDoneInit )
+		__TBICacheInit();
+
+	if ( (pCtrl[0] & SYSC_CMMUCFG_IC_ON_BIT) == 0 )
+	{
+		/* No need to flush the code cache it's not actually enabled */
+		return;
+	} 
+
+	{
+		/* Use a sequence of writes to flush the cache region requested */
+		int Loops, Step;
+#ifdef TBI_1_3
+		int TXEnable = TBI_GETREG(TXENABLE);
+		int Thread = (TXEnable & TXENABLE_THREAD_BITS)>> TXENABLE_THREAD_S;
+#else /* !TBI_1_3 */
+		int Thread = (TBI_GETREG(TXENABLE) & TXENABLE_THREAD_BITS)>>
+		                                     TXENABLE_THREAD_S      ;
+#endif /* !TBI_1_3 */
+		int SetShift = __TBICacheISetShift, SetSize;
+
+#ifdef TBI_1_3
+		/* If large size or not HTP/MTP */
+		if ( ( Bytes >= 4096 ) || ( (TXEnable & TXENABLE_REV_STEP_BITS) <
+		                            (3<<TXENABLE_REV_STEP_S)              ) )
+#endif /* TBI_1_3 */
+		{
+			volatile char *pFlush0;
+			volatile char *pFlush1;
+			volatile char *pFlush2;
+			volatile char *pFlush3;
+			volatile char *pEndSet;
+
+			/* Move to the base of the physical cache flush region */
+			pFlush0 = (volatile char *) LINSYSCFLUSH_ICACHE_LINE;
+			Step   = 64;
+
+#ifdef METAC_1_1
+			/* Set size */
+			Loops = 1<<SetShift;
+			
+			if ( ( (Mode & MMCU_xCACHE_CTRL_PARTITION_BIT) != 0 ) &&
+			     ( ((int) pStart) >= 0 )                             )
+			{
+				/* Only flush the 4K quarter that can contain local addrs */
+				Loops >>= 2;
+				pFlush0 += Loops * Thread;
+			}
+#else
+			{
+				/* Get partition code for this thread */
+				int Part = ((volatile int *) (SYSC_ICPART0 +
+				              (SYSC_xCPARTn_STRIDE*Thread)   ))[0];
+				int Offset;
+				
+				if ( ((int) pStart) < 0 )
+				{
+					/* Access Global vs Local partition */ 
+					Part >>= SYSC_xCPARTG_AND_S-SYSC_xCPARTL_AND_S;
+				}
+				
+				/* Extract Offset and move SetOff */
+				Offset = (Part & SYSC_xCPARTL_OR_BITS) >> SYSC_xCPARTL_OR_S;
+				pFlush0 += (Offset << (SetShift - 4));
+	
+				/* Shrink size */
+				Part = (Part & SYSC_xCPARTL_AND_BITS) >> SYSC_xCPARTL_AND_S;
+				Loops = ((Part + 1) << (SetShift - 4));
+			}
+#endif
+			/* Where does the Set end? */
+			pEndSet = pFlush0 + Loops;
+			SetSize = Loops;
+			
+			if ( ( Bytes < 4096 ) && ( Bytes < Loops ) )
+			{
+				/* Unreachable on HTP/MTP */
+				/* Only target the sets that could be relavent */
+				pFlush0 += (Loops - Step) & ((int) pStart);
+				Loops    = (((int) pStart) & (Step-1)) + Bytes + Step - 1;
+			}
+  
+			/* Reduce Loops by step of cache line size */
+			Loops /= Step;
+
+			pFlush1 = pFlush0 + (1<<SetShift);
+			pFlush2 = pFlush0 + (2<<SetShift);
+			pFlush3 = pFlush0 + (3<<SetShift);
+  
+			if (__TBICacheISetsLog2 == 1)
+			{
+				pFlush2 = pFlush1;
+				pFlush3 = pFlush1 + Step;
+				pFlush1 = pFlush0 + Step;
+#if 0
+				/* pFlush0 will stop one line early in this case
+				 * (pFlush1 will do the final line).
+				 * However we don't correct pEndSet here at the moment
+				 * because it will never wrap on HTP/MTP
+				 */
+				pEndSet -= Step;
+#endif
+				Step  <<= 1;
+				Loops >>= 1;
+			}
+				
+			/* Clear Loops ways in cache */
+			while ( Loops-- != 0 )
+			{
+#if 0
+				/* GCC 2.95 doesnt generate very good code for this so we
+				 * provide inline assembly instead.
+				 */
+				/* Clear the ways */
+				*pFlush0 = 0;
+				*pFlush1 = 0;
+				*pFlush2 = 0;
+				*pFlush3 = 0;
+
+				pFlush0 += Step;
+				pFlush1 += Step;
+				pFlush2 += Step;
+				pFlush3 += Step;
+#else
+				asm volatile (
+					"SETB\t[%0+%4++],%5\n"
+					"SETB\t[%1+%4++],%5\n"
+					"SETB\t[%2+%4++],%5\n"
+					"SETB\t[%3+%4++],%5\n"
+					: "+e" (pFlush0), "+e" (pFlush1), "+e" (pFlush2), "+e" (pFlush3) 
+					: "e" (Step), "a" (0));
+#endif
+  
+				if ( pFlush0 == pEndSet )
+				{
+					/* Wrap within Set 0 */
+					pFlush0 -= SetSize;
+					pFlush1 -= SetSize;
+					pFlush2 -= SetSize;
+					pFlush3 -= SetSize;
+				}
+			}
+		}
+#ifdef TBI_1_3
+		else
+		{
+			volatile char *pFlush;
+
+			/* Use linear cache flush mechanism on META IP */
+			pFlush = (volatile char *) (((int) pStart) & ~(ICACHE_LINE_BYTES-1));
+			Loops  = (((int) pStart) & (ICACHE_LINE_BYTES-1)) + Bytes + 
+			                                (ICACHE_LINE_BYTES-1)   ;
+			Loops  >>= ICACHE_LINE_S;
+
+
+#define PRIM_IFLUSH( Addr, Offset ) \
+  TBIXCACHE_WD(( (Addr) + ( (Offset) * 64) ), CACHEW_ICACHE_BIT)
+
+#define LOOP_INC (4*64)
+
+			do
+			{
+				/* By default stop */
+				Step = 0;
+				
+				switch ( Loops )
+				{
+					/* Drop Thru Cases! */
+					default: PRIM_IFLUSH( pFlush, 3 );
+					         Loops -= 4;
+					         Step = 1;
+					case 3:  PRIM_IFLUSH( pFlush, 2 );
+					case 2:  PRIM_IFLUSH( pFlush, 1 );
+					case 1:  PRIM_IFLUSH( pFlush, 0 );
+					         pFlush += LOOP_INC;
+					case 0:  break;
+				}
+			}
+			while ( Step ); 
+		}
+#endif /* TBI_1_3 */
+	}
+}
+
+
+/* End of tbicache.c */
diff --git a/arch/metag/tbx/tbicore.S b/arch/metag/tbx/tbicore.S
new file mode 100644
index 0000000..a0838eb
--- /dev/null
+++ b/arch/metag/tbx/tbicore.S
@@ -0,0 +1,136 @@
+/*
+ * tbicore.S
+ *
+ * Copyright (C) 2001, 2002, 2007, 2012 Imagination Technologies.
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ *
+ * Core functions needed to support use of the thread binary interface for META
+ * processors
+ */
+
+	.file	"tbicore.S"
+/* Get data structures and defines from the TBI C header */
+#include <asm/metag_mem.h>
+#include <asm/metag_regs.h>
+#include <asm/tbx.h>
+
+	.data
+	.balign	8
+	.global	___pTBISegs
+	.type	___pTBISegs,object
+___pTBISegs:
+	.quad	0		/* Segment list pointer with it's */
+	.size	___pTBISegs,.-___pTBISegs
+					/* own id or spin-lock location */
+/*
+ * Return ___pTBISegs value specific to privilege level - not very complicated
+ * at the moment
+ *
+ * Register Usage: D0Re0 is the result, D1Re0 is used as a scratch
+ */
+	.text
+	.balign	4
+	.global	___TBISegList
+	.type	___TBISegList,function
+___TBISegList:
+	MOVT	A1LbP,#HI(___pTBISegs)
+	ADD	A1LbP,A1LbP,#LO(___pTBISegs)
+	GETL	D0Re0,D1Re0,[A1LbP]
+	MOV	PC,D1RtP
+	.size	___TBISegList,.-___TBISegList
+
+/*
+ * Search the segment list for a match given Id, pStart can be NULL
+ *
+ * Register Usage: D1Ar1 is pSeg, D0Ar2 is Id, D0Re0 is the result
+ *                 D0Ar4, D1Ar3 are used as a scratch
+ *                 NB: The PSTAT bit if Id in D0Ar2 may be toggled
+ */
+	.text
+	.balign	4
+	.global	___TBIFindSeg
+	.type	___TBIFindSeg,function
+___TBIFindSeg:
+	MOVT	A1LbP,#HI(___pTBISegs)
+	ADD	A1LbP,A1LbP,#LO(___pTBISegs)
+	GETL	D1Ar3,D0Ar4,[A1LbP]	/* Read segment list head */
+	MOV	D0Re0,TXSTATUS		/* What priv level are we at? */
+	CMP	D1Ar1,#0		/* Is pStart provided? */
+/* Disable privilege adaption for now */
+	ANDT	D0Re0,D0Re0,#0	/*HI(TXSTATUS_PSTAT_BIT)  ; Is PSTAT set? Zero if not */
+	LSL	D0Re0,D0Re0,#(TBID_PSTAT_S-TXSTATUS_PSTAT_S)
+	XOR	D0Ar2,D0Ar2,D0Re0	/* Toggle Id PSTAT if privileged */
+	MOVNZ	D1Ar3,D1Ar1		/* Use pStart if provided */
+$LFindSegLoop:			
+	ADDS	D0Re0,D1Ar3,#0		/* End of list? Load result into D0Re0 */
+	MOVZ	PC,D1RtP		/* If result is NULL we leave */
+	GETL	D1Ar3,D0Ar4,[D1Ar3]	/* Read pLink and Id */
+	CMP	D0Ar4,D0Ar2		/* Does it match? */
+	BNZ	$LFindSegLoop		/* Loop if there is no match */
+	TST	D0Re0,D0Re0		/* Clear zero flag - we found it! */
+	MOV	PC,D1RtP		/* Return */
+	.size	___TBIFindSeg,.-___TBIFindSeg
+
+/* Useful offsets to encode the lower bits of the lock/unlock addresses */
+#define UON  (LINSYSEVENT_WR_ATOMIC_LOCK   & 0xFFF8)
+#define UOFF (LINSYSEVENT_WR_ATOMIC_UNLOCK & 0xFFF8)
+
+/*
+ * Perform a whole spin-lock sequence as used by the TBISignal routine
+ *
+ * Register Usage: D1Ar1 is pLock, D0Ar2 is Mask, D0Re0 is the result
+ *                 (All other usage due to ___TBIPoll - D0Ar6, D1Re0)
+ */
+	.text
+	.balign	4
+	.global	___TBISpin
+	.type	___TBISpin,function
+___TBISpin:
+	SETL	[A0StP++],D0FrT,D1RtP	/* Save our return address */
+	ORS	D0Re0,D0Re0,#1		/* Clear zero flag */
+	MOV	D1RtP,PC		/* Setup return address to form loop */
+$LSpinLoop:
+	BNZ	___TBIPoll		/* Keep repeating if fail to set */
+	GETL	D0FrT,D1RtP,[--A0StP]	/* Restore return address */
+	MOV	PC,D1RtP		/* Return */
+	.size	___TBISpin,.-___TBISpin
+
+/*
+ * Perform an attempt to gain access to a spin-lock and set some bits
+ * 
+ * Register Usage: D1Ar1 is pLock, D0Ar2 is Mask, D0Re0 is the result
+ *                 !!On return Zero flag is SET if we are sucessfull!!
+ *                 A0.3 is used to hold base address of system event region
+ *                 D1Re0 use to hold TXMASKI while interrupts are off
+ */
+	.text
+	.balign	4
+	.global	___TBIPoll
+	.type	___TBIPoll,function
+___TBIPoll:
+	MOV	D1Re0,#0		/* Prepare to disable ints */
+	MOVT	A0.3,#HI(LINSYSEVENT_WR_ATOMIC_LOCK)
+	SWAP	D1Re0,TXMASKI		/* Really stop ints */
+	LOCK2				/* Gain all locks */
+	SET	[A0.3+#UON],D1RtP	/* Stop shared memory access too */
+	DCACHE	[D1Ar1],A0.3		/* Flush Cache line */
+	GETD	D0Re0,[D1Ar1]		/* Get new state from memory or hit */
+	DCACHE	[D1Ar1],A0.3		/* Flush Cache line */
+	GETD	D0Re0,[D1Ar1]		/* Get current state */
+	TST	D0Re0,D0Ar2		/* Are we clear to send? */
+	ORZ	D0Re0,D0Re0,D0Ar2	/* Yes: So set bits and */
+	SETDZ	[D1Ar1],D0Re0		/*      transmit new state */
+	SET	[A0.3+#UOFF],D1RtP	/* Allow shared memory access */
+	LOCK0				/* Release all locks */
+	MOV	TXMASKI,D1Re0		/* Allow ints */
+$LPollEnd:
+	XORNZ	D0Re0,D0Re0,D0Re0	/* No: Generate zero result */
+	MOV	PC,D1RtP		/* Return (NZ indicates failure) */
+	.size	___TBIPoll,.-___TBIPoll
+
+/*
+ * End of tbicore.S
+ */
diff --git a/arch/metag/tbx/tbictx.S b/arch/metag/tbx/tbictx.S
new file mode 100644
index 0000000..19af983
--- /dev/null
+++ b/arch/metag/tbx/tbictx.S
@@ -0,0 +1,366 @@
+/*
+ * tbictx.S
+ *
+ * Copyright (C) 2001, 2002, 2007, 2012 Imagination Technologies.
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ *
+ * Explicit state save and restore routines forming part of the thread binary
+ * interface for META processors
+ */
+
+	.file	"tbictx.S"
+#include <asm/metag_regs.h>
+#include <asm/tbx.h>
+
+#ifdef METAC_1_0
+/* Ax.4 is NOT saved in XAX3 */
+#define A0_4
+#else
+/* Ax.4 is saved in XAX4 */
+#define A0_4 A0.4,
+#endif
+
+
+/* Size of the TBICTX structure */
+#define TBICTX_BYTES ((TBICTX_AX_REGS*8)+TBICTX_AX)
+
+/*
+ * TBIRES __TBINestInts( TBIRES State, void *pExt, int NoNestMask )
+ */
+	.text
+	.balign	4
+	.global	___TBINestInts
+	.type	___TBINestInts,function
+___TBINestInts:
+	XOR	D0Ar4,D0Ar4,#-1			/* D0Ar4 = ~TrigBit */
+	AND	D0Ar4,D0Ar4,#0xFFFF		/* D0Ar4 &= 0xFFFF */
+	MOV	D0Ar6,TXMASKI			/* BGNDHALT currently enabled? */
+	TSTT	D0Ar2,#TBICTX_XDX8_BIT+TBICTX_XAXX_BIT+TBICTX_XHL2_BIT+TBICTX_XTDP_BIT+TBICTX_XCBF_BIT
+	AND	D0Ar4,D0Ar2,D0Ar4		/* D0Ar4 = Ints to allow */
+	XOR	D0Ar2,D0Ar2,D0Ar4		/* Less Ints in TrigMask */
+	BNZ	___TBINestInts2			/* Jump if ctx save required! */
+	TSTT	D0Ar2,#TBICTX_CBUF_BIT+TBICTX_CBRP_BIT	/* Is catch state dirty? */
+	OR	D0Ar4,D0Ar4,D0Ar6		/* Or in TXMASKI BGNDHALT if set */
+	TSTNZ	D0Ar4,D0Ar4			/* Yes: AND triggers enabled */
+	MOV	D0Re0,D0Ar2			/* Update State argument */
+	MOV	D1Re0,D1Ar1			/*  with less Ints in TrigMask */
+	MOVZ	TXMASKI,D0Ar4			/* Early return: Enable Ints */
+	MOVZ	PC,D1RtP			/* Early return */
+	.size	___TBINestInts,.-___TBINestInts
+/*
+ * Drop thru into sub-function-
+ */
+	.global	___TBINestInts2
+	.type	___TBINestInts2,function
+___TBINestInts2:
+	MOV	D0FrT,A0FrP			/* Full entry sequence so we */
+	ADD	A0FrP,A0StP,#0			/*     can make sub-calls */
+	MSETL	[A0StP],D0FrT,D0.5,D0.6		/*     and preserve our result */
+	ORT	D0Ar2,D0Ar2,#TBICTX_XCBF_BIT	/* Add in XCBF save request */
+	MOV	D0.5,D0Ar2			/* Save State in DX.5 */
+	MOV	D1.5,D1Ar1
+	OR	D0.6,D0Ar4,D0Ar6		/* Save TrigMask in D0.6 */
+	MOVT	D1RtP,#HI(___TBICtxSave)	/* Save catch buffer */
+	CALL	D1RtP,#LO(___TBICtxSave)
+	MOV	TXMASKI,D0.6			/* Allow Ints */
+	MOV	D0Re0,D0.5			/* Return State */
+	MOV	D1Re0,D1.5
+	MGETL	D0FrT,D0.5,D0.6,[A0FrP]		/* Full exit sequence */
+	SUB	A0StP,A0FrP,#(8*3)
+	MOV	A0FrP,D0FrT
+	MOV	PC,D1RtP
+	.size	___TBINestInts2,.-___TBINestInts2
+
+/*
+ * void *__TBICtxSave( TBIRES State, void *pExt )
+ *
+ *       D0Ar2 contains TBICTX_*_BIT values that control what
+ *          extended data is to be saved beyond the end of D1Ar1.
+ *       These bits must be ored into the SaveMask of this structure.
+ *
+ *       Virtually all possible scratch registers are used.
+ *
+ *       The D1Ar1 parameter is only used as the basis for saving
+ *       CBUF state.
+ */
+/*
+ *       If TBICTX_XEXT_BIT is specified in State. then State.pCtx->Ext is
+ *       utilised to save the base address of the context save area and
+ *       the extended states saved. The XEXT flag then indicates that the
+ *       original state of the A0.2 and A1.2 registers from TBICTX.Ext.AX2
+ *       are stored as the first part of the extended state structure.
+ */
+	.balign	4
+	.global	___TBICtxSave
+	.type	___TBICtxSave,function
+___TBICtxSave:
+	GETD	D0Re0,[D1Ar1+#TBICTX_SaveMask-2]	/* Get SaveMask */
+	TSTT	D0Ar2,#TBICTX_XDX8_BIT+TBICTX_XAXX_BIT+TBICTX_XHL2_BIT+TBICTX_XTDP_BIT+TBICTX_XEXT_BIT
+						/* Just XCBF to save? */
+	MOV	A0.2,D1Ar3			/* Save pointer into A0.2 */
+	MOV	A1.2,D1RtP			/* Free off D0FrT:D1RtP pair */
+	BZ	$LCtxSaveCBUF			/* Yes: Only XCBF may be saved */
+	TSTT	D0Ar2,#TBICTX_XEXT_BIT		/* Extended base-state model? */
+	BZ	$LCtxSaveXDX8
+	GETL	D0Ar6,D1Ar5,[D1Ar1+#TBICTX_Ext_AX2]	/* Get A0.2, A1.2 state */
+	MOV	D0Ar4,D0Ar2			/* Extract Ctx.SaveFlags value */
+	ANDMT	D0Ar4,D0Ar4,#TBICTX_XDX8_BIT+TBICTX_XAXX_BIT+TBICTX_XHL2_BIT+TBICTX_XTDP_BIT+TBICTX_XEXT_BIT
+	SETD	[D1Ar1+#TBICTX_Ext_Ctx_pExt],A0.2
+	SETD	[D1Ar1+#TBICTX_Ext_Ctx_SaveMask-2],D0Ar4
+	SETL	[A0.2++],D0Ar6,D1Ar5		/* Save A0.2, A1.2 state */
+$LCtxSaveXDX8:
+	TSTT	D0Ar2,#TBICTX_XDX8_BIT		/* Save extended DX regs? */
+	BZ	$LCtxSaveXAXX
+/*
+ * Save 8 extra DX registers
+ */
+	MSETL	[A0.2],D0.8,D0.9,D0.10,D0.11,D0.12,D0.13,D0.14,D0.15
+$LCtxSaveXAXX:
+	TSTT	D0Ar2,#TBICTX_XAXX_BIT		/* Save extended AX regs? */
+	SWAP	D0Re0,A0.2			/* pDst into D0Re0 */
+	BZ	$LCtxSaveXHL2
+/*
+ * Save 4 extra AX registers
+ */
+	MSETL	[D0Re0], A0_4 A0.5,A0.6,A0.7	/* Save 8*3 bytes */
+$LCtxSaveXHL2:
+	TSTT	D0Ar2,#TBICTX_XHL2_BIT		/* Save hardware-loop regs? */
+	SWAP	D0Re0,A0.2			/* pDst back into A0.2 */
+	MOV	D0Ar6,TXL1START
+	MOV	D1Ar5,TXL2START
+	BZ	$LCtxSaveXTDP
+/*
+ * Save hardware loop registers
+ */
+	SETL	[A0.2++],D0Ar6,D1Ar5		/* Save 8*1 bytes */
+	MOV	D0Ar6,TXL1END
+	MOV	D1Ar5,TXL2END
+	MOV	D0FrT,TXL1COUNT
+	MOV	D1RtP,TXL2COUNT
+	MSETL	[A0.2],D0Ar6,D0FrT		/* Save 8*2 bytes */
+/*
+ * Clear loop counters to disable any current loops
+ */
+	XOR	TXL1COUNT,D0FrT,D0FrT
+	XOR	TXL2COUNT,D1RtP,D1RtP
+$LCtxSaveXTDP:
+	TSTT	D0Ar2,#TBICTX_XTDP_BIT		/* Save per-thread DSP regs? */
+	BZ	$LCtxSaveCBUF
+/*
+ * Save per-thread DSP registers; ACC.0, PR.0, PI.1-3 (PI.0 is zero)
+ */
+#ifndef CTX_NO_DSP
+D	SETL	[A0.2++],AC0.0,AC1.0		/* Save ACx.0 lower 32-bits */
+DH	SETL	[A0.2++],AC0.0,AC1.0		/* Save ACx.0 upper 32-bits */
+D	SETL	[A0.2++],D0AR.0,D1AR.0		/* Save DSP RAM registers */
+D	SETL	[A0.2++],D0AR.1,D1AR.1
+D	SETL	[A0.2++],D0AW.0,D1AW.0
+D	SETL	[A0.2++],D0AW.1,D1AW.1
+D	SETL	[A0.2++],D0BR.0,D1BR.0
+D	SETL	[A0.2++],D0BR.1,D1BR.1
+D	SETL	[A0.2++],D0BW.0,D1BW.0
+D	SETL	[A0.2++],D0BW.1,D1BW.1
+D	SETL	[A0.2++],D0ARI.0,D1ARI.0
+D	SETL	[A0.2++],D0ARI.1,D1ARI.1
+D	SETL	[A0.2++],D0AWI.0,D1AWI.0
+D	SETL	[A0.2++],D0AWI.1,D1AWI.1
+D	SETL	[A0.2++],D0BRI.0,D1BRI.0
+D	SETL	[A0.2++],D0BRI.1,D1BRI.1
+D	SETL	[A0.2++],D0BWI.0,D1BWI.0
+D	SETL	[A0.2++],D0BWI.1,D1BWI.1
+D	SETD	[A0.2++],T0
+D	SETD	[A0.2++],T1
+D	SETD	[A0.2++],T2
+D	SETD	[A0.2++],T3
+D	SETD	[A0.2++],T4
+D	SETD	[A0.2++],T5
+D	SETD	[A0.2++],T6
+D	SETD	[A0.2++],T7
+D	SETD	[A0.2++],T8
+D	SETD	[A0.2++],T9
+D	SETD	[A0.2++],TA
+D	SETD	[A0.2++],TB
+D	SETD	[A0.2++],TC
+D	SETD	[A0.2++],TD
+D	SETD	[A0.2++],TE
+D	SETD	[A0.2++],TF
+#else
+	ADD	A0.2,A0.2,#(8*18+4*16)
+#endif
+	MOV	D0Ar6,TXMRSIZE
+	MOV	D1Ar5,TXDRSIZE
+	SETL	[A0.2++],D0Ar6,D1Ar5		/* Save 8*1 bytes */
+	
+$LCtxSaveCBUF:
+#ifdef TBI_1_3
+	MOV	D0Ar4,D0Re0			/* Copy Ctx Flags */
+	ANDT	D0Ar4,D0Ar4,#TBICTX_XCBF_BIT	/*   mask XCBF if already set */
+	XOR	D0Ar4,D0Ar4,#-1
+	AND	D0Ar2,D0Ar2,D0Ar4		/*   remove XCBF if already set */
+#endif
+	TSTT	D0Ar2,#TBICTX_XCBF_BIT		/* Want to save CBUF? */
+	ANDT	D0Ar2,D0Ar2,#TBICTX_XDX8_BIT+TBICTX_XAXX_BIT+TBICTX_XHL2_BIT+TBICTX_XTDP_BIT+TBICTX_XEXT_BIT
+	OR	D0Ar2,D0Ar2,D0Re0		/* Generate new SaveMask */
+	SETD	[D1Ar1+#TBICTX_SaveMask-2],D0Ar2/* Add in bits saved to TBICTX */
+	MOV	D0Re0,A0.2			/* Return end of save area */
+	MOV	D0Ar4,TXDIVTIME			/* Get TXDIVTIME */
+	MOVZ	PC,A1.2				/* No: Early return */
+	TSTT	D0Ar2,#TBICTX_CBUF_BIT+TBICTX_CBRP_BIT	/* Need to save CBUF? */
+	MOVZ	PC,A1.2				/* No: Early return */
+	ORT	D0Ar2,D0Ar2,#TBICTX_XCBF_BIT
+	SETD	[D1Ar1+#TBICTX_SaveMask-2],D0Ar2/* Add in XCBF bit to TBICTX */
+	ADD	A0.2,D1Ar1,#TBICTX_BYTES	/* Dump CBUF state after TBICTX */
+/*
+ * Save CBUF
+ */
+	SETD	[A0.2+# 0],TXCATCH0		/* Restore TXCATCHn */
+	SETD	[A0.2+# 4],TXCATCH1
+	TSTT	D0Ar2,#TBICTX_CBRP_BIT		/* ... RDDIRTY was/is set */
+	SETD	[A0.2+# 8],TXCATCH2
+	SETD	[A0.2+#12],TXCATCH3
+	BZ	$LCtxSaveComplete
+	SETL	[A0.2+#(2*8)],RD		/* Save read pipeline */
+	SETL	[A0.2+#(3*8)],RD		/* Save read pipeline */
+	SETL	[A0.2+#(4*8)],RD		/* Save read pipeline */
+	SETL	[A0.2+#(5*8)],RD		/* Save read pipeline */
+	SETL	[A0.2+#(6*8)],RD		/* Save read pipeline */
+	SETL	[A0.2+#(7*8)],RD		/* Save read pipeline */
+	AND	TXDIVTIME,D0Ar4,#TXDIVTIME_DIV_BITS /* Clear RPDIRTY */
+$LCtxSaveComplete:
+	MOV	PC,A1.2				/* Return */
+	.size	___TBICtxSave,.-___TBICtxSave
+
+/*
+ * void *__TBICtxRestore( TBIRES State, void *pExt )
+ *
+ *                 D0Ar2 contains TBICTX_*_BIT values that control what
+ *                    extended data is to be recovered from D1Ar3 (pExt).
+ *
+ *                 Virtually all possible scratch registers are used.
+ */
+/*
+ *	If TBICTX_XEXT_BIT is specified in State. Then the saved state of
+ *       the orginal A0.2 and A1.2 is restored from pExt and the XEXT
+ *       related flags are removed from State.pCtx->SaveMask.
+ *
+ */
+	.balign	4
+	.global	___TBICtxRestore
+	.type	___TBICtxRestore,function
+___TBICtxRestore:
+	GETD	D0Ar6,[D1Ar1+#TBICTX_CurrMODE]	/* Get TXMODE Value */
+	ANDST	D0Ar2,D0Ar2,#TBICTX_XDX8_BIT+TBICTX_XAXX_BIT+TBICTX_XHL2_BIT+TBICTX_XTDP_BIT+TBICTX_XEXT_BIT
+	MOV	D1Re0,D0Ar2			/* Keep flags in D1Re0 */
+	MOV	D0Re0,D1Ar3			/* D1Ar3 is default result */
+	MOVZ	PC,D1RtP			/* Early return, nothing to do */
+	ANDT	D0Ar6,D0Ar6,#0xE000		/* Top bits of TXMODE required */
+	MOV	A0.3,D0Ar6			/* Save TXMODE for later */
+	TSTT	D1Re0,#TBICTX_XEXT_BIT		/* Check for XEXT bit */
+	BZ	$LCtxRestXDX8
+	GETD	D0Ar4,[D1Ar1+#TBICTX_SaveMask-2]/* Get current SaveMask */
+	GETL	D0Ar6,D1Ar5,[D0Re0++]		/* Restore A0.2, A1.2 state */
+	ANDMT	D0Ar4,D0Ar4,#(0xFFFF-(TBICTX_XDX8_BIT+TBICTX_XAXX_BIT+TBICTX_XHL2_BIT+TBICTX_XTDP_BIT+TBICTX_XEXT_BIT))
+	SETD	[D1Ar1+#TBICTX_SaveMask-2],D0Ar4/* New SaveMask */
+#ifdef METAC_1_0
+	SETD	[D1Ar1+#TBICTX_Ext_AX2_U0],D0Ar6
+	MOV	D0Ar6,D1Ar1
+	SETD	[D0Ar6+#TBICTX_Ext_AX2_U1],D1Ar5
+#else
+	SETL	[D1Ar1+#TBICTX_Ext_AX2],D0Ar6,D1Ar5
+#endif
+$LCtxRestXDX8:
+	TSTT	D1Re0,#TBICTX_XDX8_BIT		/* Get extended DX regs? */
+	MOV	A1.2,D1RtP			/* Free off D1RtP register */
+	BZ	$LCtxRestXAXX
+/*
+ * Restore 8 extra DX registers
+ */
+	MGETL	D0.8,D0.9,D0.10,D0.11,D0.12,D0.13,D0.14,D0.15,[D0Re0]
+$LCtxRestXAXX:
+	TSTT	D1Re0,#TBICTX_XAXX_BIT		/* Get extended AX regs? */
+	BZ	$LCtxRestXHL2
+/*
+ * Restore 3 extra AX registers
+ */
+	MGETL	A0_4 A0.5,A0.6,A0.7,[D0Re0]	/* Get 8*3 bytes */
+$LCtxRestXHL2:
+	TSTT	D1Re0,#TBICTX_XHL2_BIT		/* Get hardware-loop regs? */
+	BZ	$LCtxRestXTDP
+/*
+ * Get hardware loop registers
+ */
+	MGETL	D0Ar6,D0Ar4,D0Ar2,[D0Re0]	/* Get 8*3 bytes */
+	MOV	TXL1START,D0Ar6
+	MOV	TXL2START,D1Ar5
+	MOV	TXL1END,D0Ar4
+	MOV	TXL2END,D1Ar3
+	MOV	TXL1COUNT,D0Ar2
+	MOV	TXL2COUNT,D1Ar1
+$LCtxRestXTDP:
+	TSTT	D1Re0,#TBICTX_XTDP_BIT		/* Get per-thread DSP regs? */
+	MOVZ	PC,A1.2				/* No: Early return */
+/*
+ * Get per-thread DSP registers; ACC.0, PR.0, PI.1-3 (PI.0 is zero)
+ */
+	MOV	A0.2,D0Re0
+	GETL	D0Ar6,D1Ar5,[D0Re0++#((16*4)+(18*8))]
+#ifndef CTX_NO_DSP
+D	GETL	AC0.0,AC1.0,[A0.2++]		/* Restore ACx.0 lower 32-bits */
+DH	GETL	AC0.0,AC1.0,[A0.2++]		/* Restore ACx.0 upper 32-bits */
+#else
+	ADD	A0.2,A0.2,#(2*8)
+#endif
+	ADD	D0Re0,D0Re0,#(2*4)
+	MOV	TXMODE,A0.3			/* Some TXMODE bits needed */
+	MOV	TXMRSIZE,D0Ar6
+	MOV	TXDRSIZE,D1Ar5
+#ifndef CTX_NO_DSP
+D	GETL	D0AR.0,D1AR.0,[A0.2++]		/* Restore DSP RAM registers */
+D	GETL	D0AR.1,D1AR.1,[A0.2++]
+D	GETL	D0AW.0,D1AW.0,[A0.2++]
+D	GETL	D0AW.1,D1AW.1,[A0.2++]
+D	GETL	D0BR.0,D1BR.0,[A0.2++]
+D	GETL	D0BR.1,D1BR.1,[A0.2++]
+D	GETL	D0BW.0,D1BW.0,[A0.2++]
+D	GETL	D0BW.1,D1BW.1,[A0.2++]
+#else
+	ADD	A0.2,A0.2,#(8*8)
+#endif
+	MOV	TXMODE,#0			/* Restore TXMODE */
+#ifndef CTX_NO_DSP
+D	GETL	D0ARI.0,D1ARI.0,[A0.2++]
+D	GETL	D0ARI.1,D1ARI.1,[A0.2++]
+D	GETL	D0AWI.0,D1AWI.0,[A0.2++]
+D	GETL	D0AWI.1,D1AWI.1,[A0.2++]
+D	GETL	D0BRI.0,D1BRI.0,[A0.2++]
+D	GETL	D0BRI.1,D1BRI.1,[A0.2++]
+D	GETL	D0BWI.0,D1BWI.0,[A0.2++]
+D	GETL	D0BWI.1,D1BWI.1,[A0.2++]
+D	GETD	T0,[A0.2++]
+D	GETD	T1,[A0.2++]
+D	GETD	T2,[A0.2++]
+D	GETD	T3,[A0.2++]
+D	GETD	T4,[A0.2++]
+D	GETD	T5,[A0.2++]
+D	GETD	T6,[A0.2++]
+D	GETD	T7,[A0.2++]
+D	GETD	T8,[A0.2++]
+D	GETD	T9,[A0.2++]
+D	GETD	TA,[A0.2++]
+D	GETD	TB,[A0.2++]
+D	GETD	TC,[A0.2++]
+D	GETD	TD,[A0.2++]
+D	GETD	TE,[A0.2++]
+D	GETD	TF,[A0.2++]
+#else
+	ADD	A0.2,A0.2,#(8*8+4*16)
+#endif
+	MOV	PC,A1.2				/* Return */
+	.size	___TBICtxRestore,.-___TBICtxRestore
+
+/*
+ * End of tbictx.S
+ */
diff --git a/arch/metag/tbx/tbictxfpu.S b/arch/metag/tbx/tbictxfpu.S
new file mode 100644
index 0000000..e773bea
--- /dev/null
+++ b/arch/metag/tbx/tbictxfpu.S
@@ -0,0 +1,190 @@
+/*
+ * tbictxfpu.S
+ *
+ * Copyright (C) 2009, 2012 Imagination Technologies.
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ *
+ * Explicit state save and restore routines forming part of the thread binary
+ * interface for META processors
+ */
+
+	.file	"tbifpuctx.S"
+
+#include <asm/metag_regs.h>
+#include <asm/tbx.h>
+
+#ifdef TBI_1_4
+/*
+ * void *__TBICtxFPUSave( TBIRES State, void *pExt )
+ *
+ *                 D0Ar2 contains TBICTX_*_BIT values that control what
+ *                    extended data is to be saved.
+ *                 These bits must be ored into the SaveMask of this structure.
+ *
+ *                 Virtually all possible scratch registers are used.
+ */
+	.text
+	.balign	4
+	.global	___TBICtxFPUSave
+	.type	___TBICtxFPUSave,function
+___TBICtxFPUSave:
+
+	/* D1Ar1:D0Ar2 - State
+	 * D1Ar3       - pExt
+	 * D0Ar4       - Value of METAC_CORE_ID
+	 * D1Ar5       - Scratch
+	 * D0Ar6       - Scratch
+	 */
+	
+	/* If the FPAC bit isnt set then there is nothing to do */
+	TSTT	D0Ar2,#TBICTX_FPAC_BIT
+	MOVZ	PC, D1RtP
+
+	/* Obtain the Core config */
+	MOVT	D0Ar4,        #HI(METAC_CORE_ID)
+	ADD	D0Ar4, D0Ar4, #LO(METAC_CORE_ID)
+	GETD	D0Ar4, [D0Ar4]
+
+	/* Detect FX.8 - FX.15 and add to core config */
+	MOV	D0Ar6, TXENABLE
+	AND	D0Ar6, D0Ar6, #(TXENABLE_CLASSALT_FPUR8 << TXENABLE_CLASS_S)
+	AND	D0Ar4, D0Ar4, #LO(0x0000FFFF)
+	ORT	D0Ar4, D0Ar4, #HI(TBICTX_CFGFPU_FX16_BIT)
+	XOR	D0Ar4, D0Ar4, D0Ar6
+
+	/* Save the relevant bits to the buffer */
+	SETD	[D1Ar3++], D0Ar4
+
+	/* Save the relevant bits of TXDEFR (Assumes TXDEFR is coherent) ... */
+	MOV	D0Ar6, TXDEFR
+	LSR	D0Re0, D0Ar6, #8
+	AND	D0Re0, D0Re0, #LO(TXDEFR_FPE_FE_BITS>>8)
+	AND	D0Ar6, D0Ar6, #LO(TXDEFR_FPE_ICTRL_BITS)
+	OR	D0Re0, D0Re0, D0Ar6
+
+	/* ... along with relevant bits of TXMODE to buffer */
+	MOV	D0Ar6, TXMODE
+	ANDT	D0Ar6, D0Ar6, #HI(TXMODE_FPURMODE_BITS)
+	ORT	D0Ar6, D0Ar6, #HI(TXMODE_FPURMODEWRITE_BIT)
+	OR	D0Ar6, D0Ar6, D0Re0
+	SETD	[D1Ar3++], D0Ar6
+
+	GETD	D0Ar6,[D1Ar1+#TBICTX_SaveMask-2] /* Get the current SaveMask */
+	/* D0Ar6       - pCtx->SaveMask */
+
+	TSTT	D0Ar4, #HI(TBICTX_CFGFPU_FX16_BIT) /* Perform test here for extended FPU registers
+	    	                                    * to avoid stalls
+	    	                                    */
+	/* Save the standard FPU registers */
+F	MSETL	[D1Ar3++], FX.0, FX.2, FX.4, FX.6
+
+	/* Save the extended FPU registers if they are present */
+	BZ	$Lskip_save_fx8_fx16
+F	MSETL	[D1Ar3++], FX.8, FX.10, FX.12, FX.14
+$Lskip_save_fx8_fx16:
+
+	/* Save the FPU Accumulator if it is present */
+	TST	D0Ar4, #METAC_COREID_NOFPACC_BIT
+	BNZ	$Lskip_save_fpacc
+F	SETL	[D1Ar3++], ACF.0
+F	SETL	[D1Ar3++], ACF.1
+F	SETL	[D1Ar3++], ACF.2
+$Lskip_save_fpacc:
+
+	/* Update pCtx->SaveMask */
+	ANDT	D0Ar2, D0Ar2, #TBICTX_FPAC_BIT
+	OR	D0Ar6, D0Ar6, D0Ar2
+	SETD	[D1Ar1+#TBICTX_SaveMask-2],D0Ar6/* Add in XCBF bit to TBICTX */
+
+	MOV	D0Re0, D1Ar3 /* Return end of save area */
+	MOV	PC, D1RtP
+
+	.size	___TBICtxFPUSave,.-___TBICtxFPUSave
+
+/*
+ * void *__TBICtxFPURestore( TBIRES State, void *pExt )
+ *
+ *                 D0Ar2 contains TBICTX_*_BIT values that control what
+ *                    extended data is to be recovered from D1Ar3 (pExt).
+ *
+ *                 Virtually all possible scratch registers are used.
+ */
+/*
+ * If TBICTX_XEXT_BIT is specified in State. Then the saved state of
+ *       the orginal A0.2 and A1.2 is restored from pExt and the XEXT
+ *       related flags are removed from State.pCtx->SaveMask.
+ *
+ */
+	.balign	4
+	.global	___TBICtxFPURestore
+	.type	___TBICtxFPURestore,function
+___TBICtxFPURestore:
+
+	/* D1Ar1:D0Ar2 - State
+	 * D1Ar3       - pExt
+	 * D0Ar4       - Value of METAC_CORE_ID
+	 * D1Ar5       - Scratch
+	 * D0Ar6       - Scratch
+	 * D1Re0       - Scratch
+	 */
+
+	/* If the FPAC bit isnt set then there is nothing to do */
+	TSTT	D0Ar2,#TBICTX_FPAC_BIT
+	MOVZ	PC, D1RtP
+
+	/* Obtain the relevant bits of the Core config */
+	GETD	D0Ar4, [D1Ar3++]
+
+	/* Restore FPU related parts of TXDEFR. Assumes TXDEFR is coherent */
+	GETD	D1Ar5, [D1Ar3++]
+	MOV	D0Ar6, D1Ar5
+	LSL	D1Re0, D1Ar5, #8
+	ANDT	D1Re0, D1Re0, #HI(TXDEFR_FPE_FE_BITS|TXDEFR_FPE_ICTRL_BITS)
+	AND	D1Ar5, D1Ar5, #LO(TXDEFR_FPE_FE_BITS|TXDEFR_FPE_ICTRL_BITS)
+	OR	D1Re0, D1Re0, D1Ar5
+
+	MOV	D1Ar5, TXDEFR
+	ANDMT	D1Ar5, D1Ar5, #HI(~(TXDEFR_FPE_FE_BITS|TXDEFR_FPE_ICTRL_BITS))
+	ANDMB	D1Ar5, D1Ar5, #LO(~(TXDEFR_FPE_FE_BITS|TXDEFR_FPE_ICTRL_BITS))
+	OR	D1Re0, D1Re0, D1Ar5
+	MOV	TXDEFR, D1Re0
+
+	/* Restore relevant bits of TXMODE */
+	MOV	D1Ar5, TXMODE
+	ANDMT	D1Ar5, D1Ar5, #HI(~TXMODE_FPURMODE_BITS)
+	ANDT	D0Ar6, D0Ar6, #HI(TXMODE_FPURMODE_BITS|TXMODE_FPURMODEWRITE_BIT)
+	OR	D0Ar6, D0Ar6, D1Ar5
+	MOV	TXMODE, D0Ar6
+
+	TSTT	D0Ar4, #HI(TBICTX_CFGFPU_FX16_BIT) /* Perform test here for extended FPU registers
+	    	                                    * to avoid stalls
+	    	                                    */
+	/* Save the standard FPU registers */
+F	MGETL	FX.0, FX.2, FX.4, FX.6, [D1Ar3++]
+
+	/* Save the extended FPU registers if they are present */
+	BZ	$Lskip_restore_fx8_fx16
+F	MGETL	FX.8, FX.10, FX.12, FX.14, [D1Ar3++]
+$Lskip_restore_fx8_fx16:
+
+	/* Save the FPU Accumulator if it is present */
+	TST	D0Ar4, #METAC_COREID_NOFPACC_BIT
+	BNZ	$Lskip_restore_fpacc
+F	GETL	ACF.0, [D1Ar3++]
+F	GETL	ACF.1, [D1Ar3++]
+F	GETL	ACF.2, [D1Ar3++]
+$Lskip_restore_fpacc:
+
+	MOV	D0Re0, D1Ar3 /* Return end of save area */
+	MOV	PC, D1RtP
+
+	.size	___TBICtxFPURestore,.-___TBICtxFPURestore
+
+#endif /* TBI_1_4 */
+
+/*
+ * End of tbictx.S
+ */
diff --git a/arch/metag/tbx/tbidefr.S b/arch/metag/tbx/tbidefr.S
new file mode 100644
index 0000000..3eb165e
--- /dev/null
+++ b/arch/metag/tbx/tbidefr.S
@@ -0,0 +1,175 @@
+/*
+ * tbidefr.S
+ *
+ * Copyright (C) 2009, 2012 Imagination Technologies.
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ *
+ * Routing deferred exceptions
+ */
+
+#include <asm/metag_regs.h>
+#include <asm/tbx.h>
+
+	.text
+	.balign	4
+	.global	___TBIHandleDFR
+	.type	___TBIHandleDFR,function
+/* D1Ar1:D0Ar2 -- State
+ * D0Ar3       -- SigNum
+ * D0Ar4       -- Triggers
+ * D1Ar5       -- InstOrSWSId
+ * D0Ar6       -- pTBI (volatile)
+ */
+___TBIHandleDFR:
+#ifdef META_BUG_MBN100212
+	MSETL	[A0StP++], D0FrT, D0.5
+
+	/* D1Ar1,D0Ar2,D1Ar5,D0Ar6 -- Arguments to handler, must be preserved
+	 * D0Ar4       -- The deferred exceptions
+	 * D1Ar3       -- As per D0Ar4 but just the trigger bits
+	 * D0.5        -- The bgnd deferred exceptions
+	 * D1.5        -- TXDEFR with bgnd re-added
+	 */
+
+	/* - Collect the pending deferred exceptions using TXSTAT,
+	 *   (ack's the bgnd exceptions as a side-effect)
+	 * - Manually collect remaining (interrupt) deferred exceptions
+	 *   using TXDEFR
+	 * - Replace the triggers (from TXSTATI) with the int deferred
+	 *   exceptions DEFR ..., TXSTATI would have returned if it was valid
+	 *   from bgnd code
+	 * - Reconstruct TXDEFR by or'ing bgnd deferred exceptions (except
+	 *   the DEFER bit) and the int deferred exceptions. This will be
+	 *   restored later
+	 */
+	DEFR	D0.5,  TXSTAT
+	MOV	D1.5,  TXDEFR
+	ANDT	D0.5,  D0.5, #HI(0xFFFF0000)
+	MOV	D1Ar3, D1.5
+	ANDT	D1Ar3, D1Ar3, #HI(0xFFFF0000)
+	OR	D0Ar4, D1Ar3, #TXSTAT_DEFER_BIT
+	OR	D1.5, D1.5, D0.5
+
+	/* Mask off anything unrelated to the deferred exception triggers */
+	ANDT	D1Ar3, D1Ar3, #HI(TXSTAT_BUSERR_BIT | TXSTAT_FPE_BITS)
+
+	/* Can assume that at least one exception happened since this
+	 * handler wouldnt have been called otherwise.
+	 * 
+	 * Replace the signal number and at the same time, prepare
+	 * the mask to acknowledge the exception
+	 *
+	 * D1Re0 -- The bits to acknowledge
+	 * D1Ar3 -- The signal number
+	 * D1RtP -- Scratch to deal with non-conditional insns
+	 */
+	MOVT	D1Re0, #HI(TXSTAT_FPE_BITS & ~TXSTAT_FPE_DENORMAL_BIT)
+	MOV	D1RtP, #TXSTAT_FPE_INVALID_S
+	FFB	D1Ar3, D1Ar3
+	CMP	D1Ar3, #TXSTAT_FPE_INVALID_S
+	MOVLE	D1Ar3, D1RtP /* Collapse FPE triggers to a single signal */
+	MOV	D1RtP, #1
+	LSLGT	D1Re0, D1RtP, D1Ar3
+
+	/* Get the handler using the signal number
+	 *
+	 * D1Ar3 -- The signal number
+	 * D0Re0 -- Offset into TBI struct containing handler address
+	 * D1Re0 -- Mask of triggers to keep
+	 * D1RtP -- Address of handler
+	 */
+	SUB	D1Ar3, D1Ar3, #(TXSTAT_FPE_INVALID_S - TBID_SIGNUM_FPE)
+	LSL	D0Re0, D1Ar3, #2
+	XOR	D1Re0, D1Re0, #-1   /* Prepare mask for acknowledge (avoids stall) */
+	ADD	D0Re0,D0Re0,#TBI_fnSigs
+	GETD	D1RtP, [D0Ar6+D0Re0]
+
+	/* Acknowledge triggers */
+	AND	D1.5, D1.5, D1Re0
+
+	/* Restore remaining exceptions
+	 * Do this here in case the handler enables nested interrupts
+	 *
+	 * D1.5 -- TXDEFR with this exception ack'd
+	 */
+	MOV	TXDEFR, D1.5
+
+	/* Call the handler */
+	SWAP	D1RtP, PC
+
+	GETL	D0.5,  D1.5,  [--A0StP]
+	GETL	D0FrT, D1RtP, [--A0StP]
+	MOV	PC,D1RtP
+#else  /* META_BUG_MBN100212 */
+
+	/* D1Ar1,D0Ar2,D1Ar5,D0Ar6 -- Arguments to handler, must be preserved
+	 * D0Ar4       -- The deferred exceptions
+	 * D1Ar3       -- As per D0Ar4 but just the trigger bits
+	 */
+
+	/* - Collect the pending deferred exceptions using TXSTAT,
+	 *   (ack's the interrupt exceptions as a side-effect)
+	 */
+	DEFR	D0Ar4, TXSTATI
+
+	/* Mask off anything unrelated to the deferred exception triggers */
+	MOV	D1Ar3, D0Ar4
+	ANDT	D1Ar3, D1Ar3, #HI(TXSTAT_BUSERR_BIT | TXSTAT_FPE_BITS)
+
+	/* Can assume that at least one exception happened since this
+	 * handler wouldnt have been called otherwise.
+	 * 
+	 * Replace the signal number and at the same time, prepare
+	 * the mask to acknowledge the exception
+	 *
+	 * The unusual code for 1<<D1Ar3 may need explanation.
+	 * Normally this would be done using 'MOV rs,#1' and 'LSL rd,rs,D1Ar3'
+	 * but only D1Re0 is available in D1 and no crossunit insns are available
+	 * Even worse, there is no conditional 'MOV r,#uimm8'.
+	 * Since the CMP proves that D1Ar3 >= 20, we can reuse the bottom 12-bits
+	 * of D1Re0 (using 'ORGT r,#1') in the knowledge that the top 20-bits will
+	 * be discarded without affecting the result.
+	 *
+	 * D1Re0 -- The bits to acknowledge
+	 * D1Ar3 -- The signal number
+	 */
+	MOVT	D1Re0, #HI(TXSTAT_FPE_BITS & ~TXSTAT_FPE_DENORMAL_BIT)
+	MOV	D0Re0, #TXSTAT_FPE_INVALID_S
+	FFB	D1Ar3, D1Ar3
+	CMP	D1Ar3, #TXSTAT_FPE_INVALID_S
+	MOVLE	D1Ar3, D0Re0 /* Collapse FPE triggers to a single signal */
+	ORGT	D1Re0, D1Re0, #1
+	LSLGT	D1Re0, D1Re0, D1Ar3
+
+	SUB	D1Ar3, D1Ar3, #(TXSTAT_FPE_INVALID_S - TBID_SIGNUM_FPE)
+
+	/* Acknowledge triggers and restore remaining exceptions
+	 * Do this here in case the handler enables nested interrupts
+	 *
+	 * (x | y) ^ y == x & ~y. It avoids the restrictive XOR ...,#-1 insn
+	 * and is the same length
+	 */
+	MOV	D0Re0, TXDEFR
+	OR	D0Re0, D0Re0, D1Re0
+	XOR	TXDEFR, D0Re0, D1Re0
+
+	/* Get the handler using the signal number
+	 *
+	 * D1Ar3 -- The signal number
+	 * D0Re0 -- Address of handler
+	 */
+	LSL	D0Re0, D1Ar3, #2
+	ADD	D0Re0,D0Re0,#TBI_fnSigs
+	GETD	D0Re0, [D0Ar6+D0Re0]
+
+	/* Tailcall the handler */
+	MOV	PC,D0Re0
+
+#endif /* META_BUG_MBN100212 */
+	.size	___TBIHandleDFR,.-___TBIHandleDFR
+/*
+ * End of tbidefr.S
+ */
diff --git a/arch/metag/tbx/tbidspram.S b/arch/metag/tbx/tbidspram.S
new file mode 100644
index 0000000..2f27c03
--- /dev/null
+++ b/arch/metag/tbx/tbidspram.S
@@ -0,0 +1,161 @@
+/*
+ * tbidspram.S
+ *
+ * Copyright (C) 2009, 2012 Imagination Technologies.
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ *
+ * Explicit state save and restore routines forming part of the thread binary
+ * interface for META processors
+ */
+
+	.file	"tbidspram.S"
+
+/* These aren't generally useful to a user so for now, they arent publically available */
+#define _TBIECH_DSPRAM_DUA_S    8
+#define _TBIECH_DSPRAM_DUA_BITS 0x7f00
+#define _TBIECH_DSPRAM_DUB_S    0
+#define _TBIECH_DSPRAM_DUB_BITS 0x007f
+
+/*
+ * void *__TBIDspramSaveA( short DspramSizes, void *pExt )
+ */
+	.text
+	.balign	4
+	.global	___TBIDspramSaveA
+	.type	___TBIDspramSaveA,function
+___TBIDspramSaveA:
+
+	SETL	[A0StP++], D0.5, D1.5
+	MOV	A0.3, D0Ar2
+
+	/* D1Ar1 - Dspram Sizes
+	 * A0.4  - Pointer to buffer
+	 */
+
+	/* Save the specified amount of dspram DUA */
+DL	MOV	D0AR.0, #0
+	LSR	D1Ar1, D1Ar1, #_TBIECH_DSPRAM_DUA_S
+	AND	D1Ar1, D1Ar1, #(_TBIECH_DSPRAM_DUA_BITS >> _TBIECH_DSPRAM_DUA_S)
+	SUB	TXRPT, D1Ar1, #1
+$L1:
+DL	MOV	D0Re0, [D0AR.0++]
+DL	MOV	D0Ar6, [D0AR.0++]
+DL	MOV	D0Ar4, [D0AR.0++]
+DL	MOV	D0.5,  [D0AR.0++]
+	MSETL	[A0.3++], D0Re0, D0Ar6, D0Ar4, D0.5
+
+	BR	$L1
+
+	GETL	D0.5, D1.5, [--A0StP]
+	MOV	PC, D1RtP
+
+	.size	___TBIDspramSaveA,.-___TBIDspramSaveA
+
+/*
+ * void *__TBIDspramSaveB( short DspramSizes, void *pExt )
+ */
+	.balign	4
+	.global	___TBIDspramSaveB
+	.type	___TBIDspramSaveB,function
+___TBIDspramSaveB:
+
+	SETL	[A0StP++], D0.5, D1.5
+	MOV	A0.3, D0Ar2
+
+	/* D1Ar1 - Dspram Sizes
+	 * A0.3  - Pointer to buffer
+	 */
+
+	/* Save the specified amount of dspram DUA */
+DL	MOV	D0BR.0, #0
+	LSR	D1Ar1, D1Ar1, #_TBIECH_DSPRAM_DUB_S
+	AND	D1Ar1, D1Ar1, #(_TBIECH_DSPRAM_DUB_BITS >> _TBIECH_DSPRAM_DUB_S)
+	SUB	TXRPT, D1Ar1, #1
+$L2:
+DL	MOV	D0Re0, [D0BR.0++]
+DL	MOV	D0Ar6, [D0BR.0++]
+DL	MOV	D0Ar4, [D0BR.0++]
+DL	MOV	D0.5,  [D0BR.0++]
+	MSETL	[A0.3++], D0Re0, D0Ar6, D0Ar4, D0.5
+
+	BR	$L2
+
+	GETL	D0.5, D1.5, [--A0StP]
+	MOV	PC, D1RtP
+
+	.size	___TBIDspramSaveB,.-___TBIDspramSaveB
+
+/*
+ * void *__TBIDspramRestoreA( short DspramSizes, void *pExt )
+ */
+	.balign	4
+	.global	___TBIDspramRestoreA
+	.type	___TBIDspramRestoreA,function
+___TBIDspramRestoreA:
+
+	SETL	[A0StP++], D0.5, D1.5
+	MOV	A0.3, D0Ar2
+
+	/* D1Ar1 - Dspram Sizes
+	 * A0.3 - Pointer to buffer
+	 */
+
+	/* Restore the specified amount of dspram DUA */
+DL	MOV	D0AW.0, #0
+	LSR	D1Ar1, D1Ar1, #_TBIECH_DSPRAM_DUA_S
+	AND	D1Ar1, D1Ar1, #(_TBIECH_DSPRAM_DUA_BITS >> _TBIECH_DSPRAM_DUA_S)
+	SUB	TXRPT, D1Ar1, #1
+$L3:
+	MGETL	D0Re0, D0Ar6, D0Ar4, D0.5, [A0.3++]
+DL	MOV	[D0AW.0++], D0Re0
+DL	MOV	[D0AW.0++], D0Ar6
+DL	MOV	[D0AW.0++], D0Ar4
+DL	MOV	[D0AW.0++], D0.5
+
+	BR	$L3
+
+	GETL	D0.5, D1.5, [--A0StP]
+	MOV	PC, D1RtP
+
+	.size	___TBIDspramRestoreA,.-___TBIDspramRestoreA
+
+/*
+ * void *__TBIDspramRestoreB( short DspramSizes, void *pExt )
+ */
+	.balign	4
+	.global	___TBIDspramRestoreB
+	.type	___TBIDspramRestoreB,function
+___TBIDspramRestoreB:
+
+	SETL	[A0StP++], D0.5, D1.5
+	MOV	A0.3, D0Ar2
+
+	/* D1Ar1 - Dspram Sizes
+	 * A0.3 - Pointer to buffer
+	 */
+
+	/* Restore the specified amount of dspram DUA */
+DL	MOV	D0BW.0, #0
+	LSR	D1Ar1, D1Ar1, #_TBIECH_DSPRAM_DUB_S
+	AND	D1Ar1, D1Ar1, #(_TBIECH_DSPRAM_DUB_BITS >> _TBIECH_DSPRAM_DUB_S)
+	SUB	TXRPT, D1Ar1, #1
+$L4:
+	MGETL	D0Re0, D0Ar6, D0Ar4, D0.5, [A0.3++]
+DL	MOV	[D0BW.0++], D0Re0
+DL	MOV	[D0BW.0++], D0Ar6
+DL	MOV	[D0BW.0++], D0Ar4
+DL	MOV	[D0BW.0++], D0.5
+
+	BR	$L4
+
+	GETL	D0.5, D1.5, [--A0StP]
+	MOV	PC, D1RtP
+
+	.size	___TBIDspramRestoreB,.-___TBIDspramRestoreB
+
+/*
+ * End of tbidspram.S
+ */
diff --git a/arch/metag/tbx/tbilogf.S b/arch/metag/tbx/tbilogf.S
new file mode 100644
index 0000000..4a34d80
--- /dev/null
+++ b/arch/metag/tbx/tbilogf.S
@@ -0,0 +1,48 @@
+/*
+ * tbilogf.S
+ *
+ * Copyright (C) 2001, 2002, 2007, 2012 Imagination Technologies.
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ *
+ * Defines __TBILogF trap code for debugging messages and __TBICont for debug
+ * assert to be implemented on.
+ */
+
+	.file	"tbilogf.S"
+
+/*
+ * Perform console printf using external debugger or host support
+ */
+	.text
+	.balign	4
+	.global	___TBILogF
+	.type	___TBILogF,function
+___TBILogF:
+	MSETL 	[A0StP],D0Ar6,D0Ar4,D0Ar2
+	SWITCH 	#0xC10020
+	MOV	D0Re0,#0
+	SUB 	A0StP,A0StP,#24
+	MOV	PC,D1RtP
+	.size	___TBILogF,.-___TBILogF
+
+/*
+ * Perform wait for continue under control of the debugger
+ */
+	.text
+	.balign	4
+	.global	___TBICont
+	.type	___TBICont,function
+___TBICont:
+	MOV 	D0Ar6,#1
+	MSETL 	[A0StP],D0Ar6,D0Ar4,D0Ar2
+	SWITCH 	#0xC30006 	/* Returns if we are to continue */
+	SUB	A0StP,A0StP,#(8*3)
+	MOV	PC,D1RtP	/* Return */
+	.size	___TBICont,.-___TBICont
+
+/*
+ * End of tbilogf.S
+ */
diff --git a/arch/metag/tbx/tbipcx.S b/arch/metag/tbx/tbipcx.S
new file mode 100644
index 0000000..de0626f
--- /dev/null
+++ b/arch/metag/tbx/tbipcx.S
@@ -0,0 +1,451 @@
+/*
+ * tbipcx.S
+ *
+ * Copyright (C) 2001, 2002, 2007, 2009, 2012 Imagination Technologies.
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ *
+ * Asyncronous trigger handling including exceptions
+ */
+
+	.file	"tbipcx.S"
+#include <asm/metag_regs.h>
+#include <asm/tbx.h>
+
+/* BEGIN HACK */
+/* define these for now while doing inital conversion to GAS 
+   will fix properly later */
+
+/* Signal identifiers always have the TBID_SIGNAL_BIT set and contain the
+   following related bit-fields */
+#define TBID_SIGNUM_S       2
+
+/* END HACK */
+
+#ifdef METAC_1_0
+/* Ax.4 is saved in TBICTX */
+#define A0_4  ,A0.4
+#else
+/* Ax.4 is NOT saved in TBICTX */
+#define A0_4
+#endif
+
+/* Size of the TBICTX structure */
+#define TBICTX_BYTES ((TBICTX_AX_REGS*8)+TBICTX_AX)
+
+#ifdef METAC_1_1
+#ifndef BOOTROM
+#ifndef SPECIAL_BUILD
+/* Jump straight into the boot ROM version of this code */
+#define CODE_USES_BOOTROM
+#endif
+#endif
+#endif
+
+/* Define space needed for CATCH buffer state in traditional units */
+#define CATCH_ENTRIES      5
+#define CATCH_ENTRY_BYTES 16
+
+#ifndef CODE_USES_BOOTROM
+#define A0GblIStP	A0.15  /* PTBICTX for current thread in PRIV system */
+#define A1GblIGbP 	A1.15  /* Interrupt A1GbP value in PRIV system */
+#endif
+
+/*
+ * TBIRES __TBIASyncTrigger( TBIRES State )
+ */
+	.text
+	.balign	4
+	.global	___TBIASyncTrigger
+	.type	___TBIASyncTrigger,function
+___TBIASyncTrigger:
+#ifdef CODE_USES_BOOTROM
+	MOVT	D0Re0,#HI(LINCORE_BASE)
+	JUMP	D0Re0,#0xA0
+#else
+	MOV	D0FrT,A0FrP			/* Boing entry sequence */
+	ADD	A0FrP,A0StP,#0
+	SETL	[A0StP++],D0FrT,D1RtP
+	MOV	D0Re0,PCX			/* Check for repeat call */
+	MOVT	D0FrT,#HI(___TBIBoingRTI+4)
+	ADD	D0FrT,D0FrT,#LO(___TBIBoingRTI+4)
+	CMP	D0Re0,D0FrT
+	BEQ	___TBIBoingExit			/* Already set up - come out */
+	ADD	D1Ar1,D1Ar1,#7			/* PRIV system stack here */
+	MOV	A0.2,A0StP			/*  else push context here */
+	MOVS	D0Re0,D0Ar2			/* Return in user mode? */
+	ANDMB	D1Ar1,D1Ar1,#0xfff8		/*  align priv stack to 64-bit */
+	MOV	D1Re0,D1Ar1			/*   and set result to arg */
+	MOVMI	A0.2,D1Ar1			/*  use priv stack if PRIV set			 */
+/*
+ * Generate an initial TBICTX to return to our own current call context
+ */
+	MOVT	D1Ar5,#HI(___TBIBoingExit)	/* Go here to return */
+	ADD	D1Ar5,D1Ar5,#LO(___TBIBoingExit)
+	ADD	A0.3,A0.2,#TBICTX_DX		/* DX Save area */
+	ANDT	D0Ar2,D0Ar2,#TBICTX_PRIV_BIT	/* Extract PRIV bit */
+	MOVT	D0Ar6,#TBICTX_SOFT_BIT		/* Only soft thread state */
+	ADD	D0Ar6,D0Ar6,D0Ar2		/* Add in PRIV bit if requested */
+	SETL	[A0.2],D0Ar6,D1Ar5		/* Push header fields */
+	ADD	D0FrT,A0.2,#TBICTX_AX		/* Address AX save area */
+	MSETL	[A0.3],D0Re0,D0Ar6,D0Ar4,D0Ar2,D0FrT,D0.5,D0.6,D0.7
+	MOV	D0Ar6,#0
+	MOV	D1Ar5,#0
+	SETL	[A0.3++],D0Ar6,D1Ar5		/* Zero CT register states */
+	SETL	[A0.3++],D0Ar6,D1Ar5
+	MSETL	[D0FrT],A0StP,A0FrP,A0.2,A0.3 A0_4 /* Save AX regs */
+	MOV	A0FrP,A0.2			/* Restore me! */
+	B	___TBIResume
+	.size	___TBIASyncTrigger,.-___TBIASyncTrigger
+
+/*
+ * Optimised return to handler for META Core
+ */
+___TBIBoingRTH:
+	RTH					/* Go to background level */
+	MOVT	A0.2,     #HI($Lpcx_target)
+	ADD	A0.2,A0.2,#LO($Lpcx_target)
+	MOV	PCX,A0.2                        /* Setup PCX for interrupts */
+	MOV	PC,D1Re0			/* Jump to handler */
+/*
+ * This is where the code below needs to jump to wait for outermost interrupt
+ * event in a non-privilege mode system (single shared interrupt stack).
+ */
+___TBIBoingPCX:
+	MGETL	A0StP,A0FrP,A0.2,A0.3 A0_4,[D1Re0] /* Restore AX regs */
+	MOV	TXSTATUS,D0Re0			/* Restore flags */
+	GETL	D0Re0,D1Re0,[D1Re0+#TBICTX_DX-TBICTX_BYTES]
+___TBIBoingRTI:
+	RTI					/* Wait for interrupt */
+$Lpcx_target:
+/*
+ * Save initial interrupt state on current stack
+ */
+	SETL	[A0StP+#TBICTX_DX],D0Re0,D1Re0	/* Save key registers */
+	ADD	D1Re0,A0StP,#TBICTX_AX		/* Address AX save area */
+	MOV	D0Re0,TXSTATUS			/* Read TXSTATUS into D0Re0 */
+	MOV	TXSTATUS,#0			/* Clear TXSTATUS */
+	MSETL	[D1Re0],A0StP,A0FrP,A0.2,A0.3 A0_4 /* Save AX critical regs */
+/*
+ * Register state at this point is-
+ *
+ *	D0Re0 - Old TXSTATUS with PRIV and CBUF bits set if appropriate
+ *	A0StP - Is call stack frame and base of TBICTX being generated
+ *	A1GbP - Is valid static access link
+ */
+___TBIBoing:
+	LOCK0					/* Make sure we have no locks! */
+	ADD	A1.2,A0StP,#TBICTX_DX+(8*1)	/* Address DX.1 save area */
+	MOV	A0FrP,A0StP			/* Setup frame pointer */
+	MSETL	[A1.2],D0Ar6,D0Ar4,D0Ar2,D0FrT,D0.5,D0.6,D0.7
+	MOV	D0Ar4,TXRPT			/* Save critical CT regs */
+	MOV	D1Ar3,TXBPOBITS
+	MOV	D1Ar1,TXDIVTIME			/* Calc catch buffer pSrc */
+	MOV	D0Ar2,TXMODE
+	MOV	TXMODE,#0			/* Clear TXMODE */
+#ifdef TXDIVTIME_RPDIRTY_BIT
+	TSTT	D1Ar1,#HI(TXDIVTIME_RPDIRTY_BIT)/* NZ = RPDIRTY */
+	MOVT	D0Ar6,#TBICTX_CBRP_BIT
+	ORNZ	D0Re0,D0Re0,D0Ar6		/* Set CBRP if RPDIRTY set */
+#endif
+	MSETL	[A1.2],D0Ar4,D0Ar2		/* Save CT regs state */
+	MOV	D0Ar2,D0Re0			/* Copy TXSTATUS */
+	ANDMT	D0Ar2,D0Ar2,#TBICTX_CBUF_BIT+TBICTX_CBRP_BIT
+#ifdef TBI_1_4
+	MOVT	D1Ar1,#TBICTX_FPAC_BIT		/* Copy FPActive into FPAC */
+	TSTT	D0Re0,#HI(TXSTATUS_FPACTIVE_BIT)
+	ORNZ	D0Ar2,D0Ar2,D1Ar1
+#endif
+	MOV	D1Ar1,PCX			/* Read CurrPC */
+	ORT	D0Ar2,D0Ar2,#TBICTX_CRIT_BIT	/* SaveMask + CRIT bit */
+	SETL	[A0FrP+#TBICTX_Flags],D0Ar2,D1Ar1 /* Set pCtx header fields */
+/*
+ * Completed context save, now we need to make a call to an interrupt handler
+ *
+ *	D0Re0 - holds PRIV, WAIT, CBUF flags, HALT reason if appropriate
+ *	A0FrP - interrupt stack frame and base of TBICTX being generated
+ *	A0StP - same as A0FrP
+ */
+___TBIBoingWait:
+				/* Reserve space for TBICTX and CBUF */
+	ADD	A0StP,A0StP,#TBICTX_BYTES+(CATCH_ENTRY_BYTES*CATCH_ENTRIES)
+	MOV	D0Ar4,TXSTATI			/* Read the Triggers data */
+	MOV	D1Ar3,TXDIVTIME			/* Read IRQEnc bits */
+	MOV	D0Ar2,D0Re0			/* Copy PRIV and WAIT flags */
+	ANDT	D0Ar2,D0Ar2,#TBICTX_PRIV_BIT+TBICTX_WAIT_BIT+TBICTX_CBUF_BIT
+#ifdef TBI_1_4
+	MOVT	D1Ar5,#TBICTX_FPAC_BIT		/* Copy FPActive into FPAC */
+	TSTT	D0Re0,#HI(TXSTATUS_FPACTIVE_BIT)
+	ORNZ	D0Ar2,D0Ar2,D1Ar5
+#endif
+	ANDT	D1Ar3,D1Ar3,#HI(TXDIVTIME_IRQENC_BITS)
+	LSR	D1Ar3,D1Ar3,#TXDIVTIME_IRQENC_S
+	AND	TXSTATI,D0Ar4,#TXSTATI_BGNDHALT_BIT/* Ack any HALT seen */
+	ANDS	D0Ar4,D0Ar4,#0xFFFF-TXSTATI_BGNDHALT_BIT /* Only seen HALT? */
+	ORT	D0Ar2,D0Ar2,#TBICTX_CRIT_BIT	/* Set CRIT */
+#ifndef BOOTROM
+	MOVT	A1LbP,#HI(___pTBIs)
+	ADD	A1LbP,A1LbP,#LO(___pTBIs)
+	GETL	D1Ar5,D0Ar6,[A1LbP]		/* D0Ar6 = ___pTBIs[1] */
+#else
+/*
+ * For BOOTROM support ___pTBIs must be allocated at offset 0 vs A1GbP
+ */
+	GETL	D1Ar5,D0Ar6,[A1GbP]			/* D0Ar6 = ___pTBIs[1] */
+#endif
+	BZ	___TBIBoingHalt			/* Yes: Service HALT */
+/*
+ * Encode interrupt as signal vector, strip away same/lower TXMASKI bits
+ */
+	MOV	D1Ar1,#1			/* Generate mask for this bit */
+	MOV	D0Re0,TXMASKI			/* Get interrupt mask */
+	LSL	TXSTATI,D1Ar1,D1Ar3		/* Acknowledge trigger */
+	AND	TXMASKI,D0Re0,#TXSTATI_BGNDHALT_BIT	/* Only allow HALTs */
+	OR	D0Ar2,D0Ar2,D0Re0		/* Set TBIRES.Sig.TrigMask */
+	ADD	D1Ar3,D1Ar3,#TBID_SIGNUM_TRT	/* Offset into interrupt sigs */
+	LSL	D0Re0,D1Ar3,#TBID_SIGNUM_S	/* Generate offset from SigNum */
+/*
+ * This is a key moment we are about to call the handler, register state is
+ * as follows-
+ *
+ *	D0Re0 - Handler vector (SigNum<<TBID_SIGNUM_S)
+ *	D0Ar2 - TXMASKI:TBICTX_CRIT_BIT with optional CBUF and PRIV bits
+ *	D1Ar3 - SigNum
+ *	D0Ar4 - State read from TXSTATI
+ *	D1Ar5 - Inst for SWITCH trigger case only, otherwise undefined
+ *	D0Ar6 - pTBI
+ */
+___TBIBoingVec:
+	ADD	D0Re0,D0Re0,#TBI_fnSigs		/* Offset into signal table */
+	GETD	D1Re0,[D0Ar6+D0Re0]		/* Get address for Handler */
+/*
+ * Call handler at interrupt level, when it returns simply resume execution
+ * of state indicated by D1Re0.
+ */
+	MOV	D1Ar1,A0FrP			/* Pass in pCtx */
+	CALLR	D1RtP,___TBIBoingRTH		/* Use RTH to invoke handler */
+	
+/*
+ * Perform critical state restore and execute background thread.
+ *
+ *	A0FrP - is pointer to TBICTX structure to resume
+ *	D0Re0 - contains additional TXMASKI triggers
+ */
+	.text
+	.balign	4
+#ifdef BOOTROM
+	.global	___TBIResume
+#endif
+___TBIResume:
+/*
+ * New META IP method
+ */
+	RTH					/* Go to interrupt level */
+	MOV	D0Ar4,TXMASKI			/* Read TXMASKI */
+	OR	TXMASKI,D0Ar4,D0Re0		/* -Write-Modify TXMASKI */
+	GETL	D0Re0,D1Re0,[A0FrP+#TBICTX_Flags]/* Get Flags:SaveMask, CurrPC */
+	MOV	A0StP,A0FrP			/* Position stack pointer */
+	MOV	D0Ar2,TXPOLLI			/* Read pending triggers */
+	MOV	PCX,D1Re0			/* Set resumption PC */
+	TST	D0Ar2,#0xFFFF			/* Any pending triggers? */
+	BNZ	___TBIBoingWait			/* Yes: Go for triggers */
+	TSTT	D0Re0,#TBICTX_WAIT_BIT		/* Do we WAIT anyway? */
+	BNZ	___TBIBoingWait			/* Yes: Go for triggers */
+	LSLS	D1Ar5,D0Re0,#1			/* Test XCBF (MI) & PRIV (CS)? */
+	ADD	D1Re0,A0FrP,#TBICTX_CurrRPT	/* Address CT save area */
+	ADD	A0StP,A0FrP,#TBICTX_DX+(8*1)	/* Address DX.1 save area */
+	MGETL	A0.2,A0.3,[D1Re0]		/* Get CT reg states */
+	MOV	D1Ar3,A1.3			/* Copy old TXDIVTIME */
+	BPL	___TBIResCrit			/* No: Skip logic */
+	ADD	D0Ar4,A0FrP,#TBICTX_BYTES	/* Source is after TBICTX */
+	ANDST	D1Ar3,D1Ar3,#HI(TXDIVTIME_RPMASK_BITS)/* !Z if RPDIRTY */
+	MGETL	D0.5,D0.6,[D0Ar4]		/* Read Catch state */
+	MOV	TXCATCH0,D0.5			/* Restore TXCATCHn */
+	MOV	TXCATCH1,D1.5
+	MOV	TXCATCH2,D0.6
+	MOV	TXCATCH3,D1.6
+	BZ	___TBIResCrit
+	MOV	D0Ar2,#(1*8)
+	LSRS	D1Ar3,D1Ar3,#TXDIVTIME_RPMASK_S+1 /* 2nd RPMASK bit -> bit 0 */
+	ADD	RA,D0Ar4,#(0*8)			/* Re-read read pipeline */
+	ADDNZ	RA,D0Ar4,D0Ar2			/* If Bit 0 set issue RA */
+	LSRS	D1Ar3,D1Ar3,#2			/* Bit 1 -> C, Bit 2 -> Bit 0 */
+	ADD	D0Ar2,D0Ar2,#8
+	ADDCS	RA,D0Ar4,D0Ar2			/* If C issue RA */
+	ADD	D0Ar2,D0Ar2,#8
+	ADDNZ	RA,D0Ar4,D0Ar2			/* If Bit 0 set issue RA */
+	LSRS	D1Ar3,D1Ar3,#2			/* Bit 1 -> C, Bit 2 -> Bit 0 */
+	ADD	D0Ar2,D0Ar2,#8
+	ADDCS	RA,D0Ar4,D0Ar2			/* If C issue RA */
+	ADD	D0Ar2,D0Ar2,#8
+	ADDNZ	RA,D0Ar4,D0Ar2			/* If Bit 0 set issue RA */
+	MOV	TXDIVTIME,A1.3			/* Set RPDIRTY again */
+___TBIResCrit:
+	LSLS	D1Ar5,D0Re0,#1			/* Test XCBF (MI) & PRIV (CS)? */
+#ifdef TBI_1_4
+	ANDT	D1Ar5,D1Ar5,#(TBICTX_FPAC_BIT*2)
+	LSL	D0Ar6,D1Ar5,#3			/* Convert FPAC into FPACTIVE */
+#endif
+ 	ANDMT	D0Re0,D0Re0,#TBICTX_CBUF_BIT	/* Keep CBUF bit from SaveMask */
+#ifdef TBI_1_4
+	OR	D0Re0,D0Re0,D0Ar6		/* Combine FPACTIVE with others */
+#endif
+	MGETL	D0Ar6,D0Ar4,D0Ar2,D0FrT,D0.5,D0.6,D0.7,[A0StP] /* Restore DX */
+	MOV	TXRPT,A0.2			/* Restore CT regs */
+	MOV	TXBPOBITS,A1.2
+	MOV	TXMODE,A0.3
+	BCC	___TBIBoingPCX			/* Do non-PRIV wait! */
+	MOV	A1GblIGbP,A1GbP			/* Save A1GbP too */
+	MGETL	A0StP,A0FrP,A0.2,A0.3 A0_4,[D1Re0] /* Restore AX regs */
+/*
+ * Wait for the first interrupt/exception trigger in a privilege mode system
+ * (interrupt stack area for current TASK to be pointed to by A0GblIStP
+ * or per_cpu__stack_save[hwthread_id]).
+ */
+	MOV	TXSTATUS,D0Re0			/* Restore flags */
+	MOV	D0Re0,TXPRIVEXT			/* Set TXPRIVEXT_TXTOGGLEI_BIT */
+	SUB	D1Re0,D1Re0,#TBICTX_BYTES	/* TBICTX is top of int stack */
+#ifdef TBX_PERCPU_SP_SAVE
+	SWAP	D1Ar3,A1GbP
+	MOV	D1Ar3,TXENABLE			/* Which thread are we? */
+	AND	D1Ar3,D1Ar3,#TXENABLE_THREAD_BITS
+	LSR	D1Ar3,D1Ar3,#TXENABLE_THREAD_S-2
+	ADDT	D1Ar3,D1Ar3,#HI(_per_cpu__stack_save)
+	ADD	D1Ar3,D1Ar3,#LO(_per_cpu__stack_save)
+	SETD	[D1Ar3],D1Re0
+	SWAP	D1Ar3,A1GbP
+#else
+	MOV	A0GblIStP, D1Re0
+#endif
+	OR	D0Re0,D0Re0,#TXPRIVEXT_TXTOGGLEI_BIT
+	MOV	TXPRIVEXT,D0Re0			/* Cannot set TXPRIVEXT if !priv */
+	GETL	D0Re0,D1Re0,[D1Re0+#TBICTX_DX]
+	RTI					/* Wait for interrupt */
+/*
+ * Save initial interrupt state on A0GblIStP, switch to A0GblIStP if
+ * BOOTROM code, save and switch to [A1GbP] otherwise.
+ */
+___TBIBoingPCXP:
+#ifdef TBX_PERCPU_SP_SAVE
+	SWAP	D1Ar3,A1GbP			/* Get PRIV stack base */
+	MOV	D1Ar3,TXENABLE			/* Which thread are we? */
+	AND	D1Ar3,D1Ar3,#TXENABLE_THREAD_BITS
+	LSR	D1Ar3,D1Ar3,#TXENABLE_THREAD_S-2
+	ADDT	D1Ar3,D1Ar3,#HI(_per_cpu__stack_save)
+	ADD	D1Ar3,D1Ar3,#LO(_per_cpu__stack_save)
+	GETD	D1Ar3,[D1Ar3]
+#else
+	SWAP	D1Ar3,A0GblIStP			/* Get PRIV stack base */
+#endif
+	SETL	[D1Ar3+#TBICTX_DX],D0Re0,D1Re0 /* Save key registers */
+	MOV	D0Re0,TXPRIVEXT			/* Clear TXPRIVEXT_TXTOGGLEI_BIT */
+	ADD	D1Re0,D1Ar3,#TBICTX_AX	/* Address AX save area */
+	ANDMB	D0Re0,D0Re0,#0xFFFF-TXPRIVEXT_TXTOGGLEI_BIT
+	MOV	TXPRIVEXT,D0Re0			/* Cannot set TXPRIVEXT if !priv */
+	MOV	D0Re0,TXSTATUS			/* Read TXSTATUS into D0Re0 */
+	MOV	TXSTATUS,#0			/* Clear TXSTATUS */
+	MSETL	[D1Re0],A0StP,A0FrP,A0.2,A0.3 A0_4 /* Save AX critical regs */
+	MOV	A0StP,D1Ar3			/* Switch stacks */
+#ifdef TBX_PERCPU_SP_SAVE
+	MOV	D1Ar3,A1GbP			/* Get D1Ar2 back */
+#else
+	MOV	D1Ar3,A0GblIStP			/* Get D1Ar2 back */
+#endif
+	ORT	D0Re0,D0Re0,#TBICTX_PRIV_BIT	/* Add PRIV to TXSTATUS */
+	MOV	A1GbP,A1GblIGbP			/* Restore A1GbP */
+	B	___TBIBoing			/* Enter common handler code */
+/*
+ * At this point we know it's a background HALT case we are handling.
+ * The restored TXSTATUS always needs to have zero in the reason bits.
+ */
+___TBIBoingHalt:
+	MOV	D0Ar4,TXMASKI			/* Get interrupt mask */
+	ANDST	D0Re0,D0Re0,#HI(TXSTATUS_MAJOR_HALT_BITS+TXSTATUS_MEM_FAULT_BITS)
+	AND	TXMASKI,D0Ar4,#TXSTATI_BGNDHALT_BIT /* Only allow HALTs */
+	AND	D0Ar4,D0Ar4,#0xFFFF-TXSTATI_BGNDHALT_BIT /* What ints are off? */
+	OR	D0Ar2,D0Ar2,D0Ar4		/* Set TBIRES.Sig.TrigMask */
+	MOV	D0Ar4,#TXSTATI_BGNDHALT_BIT	/* This was the trigger state */
+	LSR	D1Ar3,D0Re0,#TXSTATUS_MAJOR_HALT_S
+	MOV	D0Re0,#TBID_SIGNUM_XXF<<TBID_SIGNUM_S
+	BNZ	___TBIBoingVec			/* Jump to XXF exception handler */
+/*
+ * Only the SWITCH cases are left, PCX must be valid
+ */
+#ifdef TBI_1_4
+	MOV	D1Ar5,TXPRIVEXT
+	TST	D1Ar5,#TXPRIVEXT_MINIMON_BIT
+	LSR	D1Ar3,D1Ar1,#1                  /* Shift needed for MINIM paths (fill stall) */
+	BZ	$Lmeta                          /* If META only, skip */
+	TSTT	D1Ar1,#HI(0x00800000)
+	ANDMT	D1Ar3,D1Ar3,#HI(0x007FFFFF >> 1)/* Shifted mask for large MINIM */
+	ANDT	D1Ar1,D1Ar1,#HI(0xFFE00000)     /* Static mask for small MINIM */
+	BZ	$Llarge_minim                   /* If large MINIM */
+$Lsmall_minim:
+	TSTT	D1Ar3,#HI(0x00100000 >> 1)
+	ANDMT	D1Ar3,D1Ar3,#HI(0x001FFFFF >> 1)/* Correct shifted mask for large MINIM */
+	ADDZ	D1Ar1,D1Ar1,D1Ar3               /* If META rgn, add twice to undo LSR #1 */
+	B	$Lrecombine
+$Llarge_minim:
+	ANDST	D1Ar1,D1Ar1,#HI(0xFF800000)     /* Correct static mask for small MINIM */
+	                                        /* Z=0 (Cannot place code at NULL) */
+$Lrecombine:
+	ADD	D1Ar1,D1Ar1,D1Ar3               /* Combine static and shifted parts */
+$Lmeta:
+	GETW	D1Ar5,[D1Ar1++]			/* META: lo-16, MINIM: lo-16 (all-16 if short) */
+	GETW	D1Ar3,[D1Ar1]			/* META: hi-16, MINIM: hi-16 (only if long) */
+	MOV	D1Re0,D1Ar5
+	XOR	D1Re0,D1Re0,#0x4000
+	LSLSNZ	D1Re0,D1Re0,#(32-14)		/* MINIM: If long C=0, if short C=1 */
+	LSLCC	D1Ar3,D1Ar3,#16			/* META/MINIM long: Move hi-16 up */
+	LSLCS	D1Ar3,D1Ar5,#16			/* MINIM short: Dup all-16 */
+	ADD	D1Ar5,D1Ar5,D1Ar3		/* ALL: Combine both 16-bit parts */
+#else
+	GETD	D1Ar5,[D1Ar1]			/* Read instruction for switch */
+#endif
+	LSR	D1Ar3,D1Ar5,#22			/* Convert into signal number */
+	AND	D1Ar3,D1Ar3,#TBID_SIGNUM_SW3-TBID_SIGNUM_SW0
+	LSL	D0Re0,D1Ar3,#TBID_SIGNUM_S	/* Generate offset from SigNum */
+	B	___TBIBoingVec			/* Jump to switch handler */
+/*
+ * Exit from TBIASyncTrigger call
+ */
+___TBIBoingExit:
+	GETL	D0FrT,D1RtP,[A0FrP++] 		/* Restore state from frame */
+	SUB	A0StP,A0FrP,#8			/* Unwind stack */
+	MOV	A0FrP,D0FrT			/* Last memory read completes */
+	MOV	PC,D1RtP			/* Return to caller */
+#endif /* ifdef CODE_USES_BOOTROM */
+	.size	___TBIResume,.-___TBIResume
+
+#ifndef BOOTROM
+/*
+ * void __TBIASyncResume( TBIRES State )
+ */
+	.text
+	.balign	4
+	.global	___TBIASyncResume
+	.type	___TBIASyncResume,function
+___TBIASyncResume:
+/*
+ * Perform CRIT|SOFT state restore and execute background thread.
+ */
+	MOV	D1Ar3,D1Ar1			/* Restore this context */
+	MOV	D0Re0,D0Ar2			/* Carry in additional triggers */
+						/* Reserve space for TBICTX */
+	ADD	D1Ar3,D1Ar3,#TBICTX_BYTES+(CATCH_ENTRY_BYTES*CATCH_ENTRIES)
+	MOV	A0StP,D1Ar3			/* Enter with protection of */
+	MOV	A0FrP,D1Ar1			/*   TBICTX on our stack */
+#ifdef CODE_USES_BOOTROM
+	MOVT	D1Ar1,#HI(LINCORE_BASE)
+	JUMP	D1Ar1,#0xA4
+#else
+	B	___TBIResume
+#endif
+	.size	___TBIASyncResume,.-___TBIASyncResume
+#endif /* ifndef BOOTROM */
+
+/*
+ * End of tbipcx.S
+ */
diff --git a/arch/metag/tbx/tbiroot.S b/arch/metag/tbx/tbiroot.S
new file mode 100644
index 0000000..7d84daf
--- /dev/null
+++ b/arch/metag/tbx/tbiroot.S
@@ -0,0 +1,87 @@
+/*
+ * tbiroot.S
+ *
+ * Copyright (C) 2001, 2002, 2012 Imagination Technologies.
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ *
+ * Module that creates and via ___TBI function returns a TBI Root Block for
+ * interrupt and background processing on the current thread.
+ */
+
+	.file	"tbiroot.S"
+#include <asm/metag_regs.h>
+
+/*
+ * Get data structures and defines from the TBI C header
+ */
+#include <asm/tbx.h>
+
+
+/* If signals need to be exchanged we must create a TBI Root Block */
+
+	.data
+	.balign	8
+	.global	___pTBIs
+	.type	___pTBIs,object
+___pTBIs:
+	.long	0 /* Bgnd+Int root block ptrs */
+	.long	0
+	.size	___pTBIs,.-___pTBIs
+
+
+/*
+ * Return ___pTBIs value specific to execution level with promotion/demotion
+ *
+ * Register Usage: D1Ar1 is Id, D0Re0 is the primary result
+ *                 D1Re0 is secondary result (___pTBIs for other exec level)
+ */
+	.text
+	.balign	4
+	.global	___TBI
+	.type	___TBI,function
+___TBI:
+	TSTT	D1Ar1,#HI(TBID_ISTAT_BIT)	/* Bgnd or Int level? */
+	MOVT	A1LbP,#HI(___pTBIs)
+	ADD	A1LbP,A1LbP,#LO(___pTBIs)
+	GETL	D0Re0,D1Re0,[A1LbP] /* Base of root block table */
+	SWAPNZ	D0Re0,D1Re0			/* Swap if asked */
+	MOV	PC,D1RtP
+	.size	___TBI,.-___TBI
+
+
+/*
+ * Return identifier of the current thread in TBI segment or signal format with
+ * secondary mask to indicate privilege and interrupt level of thread
+ */
+	.text
+	.balign	4
+	.global	___TBIThrdPrivId
+	.type	___TBIThrdPrivId,function
+___TBIThrdPrivId:
+	.global	___TBIThreadId
+	.type	___TBIThreadId,function
+___TBIThreadId:
+#ifndef METAC_0_1
+	MOV	D1Re0,TXSTATUS			/* Are we privileged or int? */
+	MOV	D0Re0,TXENABLE			/* Which thread are we? */
+/* Disable privilege adaption for now */
+	ANDT	D1Re0,D1Re0,#HI(TXSTATUS_ISTAT_BIT) /* +TXSTATUS_PSTAT_BIT) */
+	LSL	D1Re0,D1Re0,#TBID_ISTAT_S-TXSTATUS_ISTAT_S
+	AND	D0Re0,D0Re0,#TXENABLE_THREAD_BITS
+	LSL	D0Re0,D0Re0,#TBID_THREAD_S-TXENABLE_THREAD_S
+#else
+/* Thread 0 only */
+	XOR	D0Re0,D0Re0,D0Re0
+	XOR	D1Re0,D1Re0,D1Re0
+#endif
+	MOV 	PC,D1RtP			/* Return */
+	.size	___TBIThrdPrivId,.-___TBIThrdPrivId
+	.size	___TBIThreadId,.-___TBIThreadId 
+
+
+/*
+ * End of tbiroot.S
+ */
diff --git a/arch/metag/tbx/tbisoft.S b/arch/metag/tbx/tbisoft.S
new file mode 100644
index 0000000..0346fe8
--- /dev/null
+++ b/arch/metag/tbx/tbisoft.S
@@ -0,0 +1,237 @@
+/*
+ * tbisoft.S
+ *
+ * Copyright (C) 2001, 2002, 2007, 2012 Imagination Technologies.
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ *
+ * Support for soft threads and soft context switches
+ */
+
+	.file	"tbisoft.S"
+
+#include <asm/tbx.h>
+
+#ifdef METAC_1_0
+/* Ax.4 is saved in TBICTX */
+#define A0_4  ,A0.4
+#define D0_5  ,D0.5
+#else
+/* Ax.4 is NOT saved in TBICTX */
+#define A0_4
+#define D0_5
+#endif
+
+/* Size of the TBICTX structure */
+#define TBICTX_BYTES ((TBICTX_AX_REGS*8)+TBICTX_AX)
+
+	.text
+	.balign	4
+	.global	___TBISwitchTail
+	.type	___TBISwitchTail,function
+___TBISwitchTail:
+	B	$LSwitchTail
+	.size	___TBISwitchTail,.-___TBISwitchTail
+
+/* 
+ * TBIRES __TBIJumpX( TBIX64 ArgsA, PTBICTX *rpSaveCtx, int TrigsMask,
+ *                                    void (*fnMain)(), void *pStack );
+ *
+ * This is a combination of __TBISwitch and __TBIJump with the context of
+ * the calling thread being saved in the rpSaveCtx location with a drop-thru
+ *  effect into the __TBIJump logic. ArgsB passes via __TBIJump to the
+ *  routine eventually invoked will reflect the rpSaveCtx value specified.
+ */
+	.text
+	.balign	4
+	.global	___TBIJumpX
+	.type	___TBIJumpX,function
+___TBIJumpX:
+	CMP	D1RtP,#-1
+	B	$LSwitchStart
+	.size	___TBIJumpX,.-___TBIJumpX
+
+/*
+ * TBIRES __TBISwitch( TBIRES Switch, PTBICTX *rpSaveCtx )
+ *
+ * Software syncronous context switch between soft threads, save only the
+ * registers which are actually valid on call entry.
+ *
+ *	A0FrP, D0RtP, D0.5, D0.6, D0.7      - Saved on stack
+ *	A1GbP is global to all soft threads so not virtualised
+ *	A0StP is then saved as the base of the TBICTX of the thread
+ *	
+ */
+	.text
+	.balign	4
+	.global	___TBISwitch
+	.type	___TBISwitch,function
+___TBISwitch:
+	XORS	D0Re0,D0Re0,D0Re0		/* Set ZERO flag */
+$LSwitchStart:
+	MOV	D0FrT,A0FrP			/* Boing entry sequence */
+	ADD	A0FrP,A0StP,#0			
+	SETL	[A0StP+#8++],D0FrT,D1RtP
+/*
+ * Save current frame state - we save all regs because we don't want
+ * uninitialised crap in the TBICTX structure that the asyncronous resumption
+ * of a thread will restore.
+ */
+	MOVT	D1Re0,#HI($LSwitchExit)		/* ASync resume point here */
+	ADD	D1Re0,D1Re0,#LO($LSwitchExit)
+	SETD	[D1Ar3],A0StP			/* Record pCtx of this thread */
+	MOVT	D0Re0,#TBICTX_SOFT_BIT		/* Only soft thread state */
+	SETL	[A0StP++],D0Re0,D1Re0		/* Push header fields */
+	ADD	D0FrT,A0StP,#TBICTX_AX-TBICTX_DX /* Address AX save area */
+	MOV	D0Re0,#0			/* Setup 0:0 result for ASync */
+	MOV	D1Re0,#0			/* resume of the thread */
+	MSETL	[A0StP],D0Re0,D0Ar6,D0Ar4,D0Ar2,D0FrT,D0.5,D0.6,D0.7
+	SETL	[A0StP++],D0Re0,D1Re0		/* Zero CurrRPT, CurrBPOBITS, */
+	SETL	[A0StP++],D0Re0,D1Re0		/* Zero CurrMODE, CurrDIVTIME */
+	ADD	A0StP,A0StP,#(TBICTX_AX_REGS*8)	/* Reserve AX save space */
+	MSETL	[D0FrT],A0StP,A0FrP,A0.2,A0.3 A0_4 /* Save AX regs */
+	BNZ	___TBIJump
+/*
+ * NextThread MUST be in TBICTX_SOFT_BIT state!
+ */
+$LSwitchTail:
+	MOV	D0Re0,D0Ar2			/* Result from args */
+	MOV	D1Re0,D1Ar1
+	ADD	D1RtP,D1Ar1,#TBICTX_AX
+	MGETL	A0StP,A0FrP,[D1RtP]		/* Get frame values */
+$LSwitchCmn:
+	ADD	A0.2,D1Ar1,#TBICTX_DX+(8*5)
+	MGETL	D0.5,D0.6,D0.7,[A0.2]		/* Get caller-saved DX regs */
+$LSwitchExit:
+	GETL	D0FrT,D1RtP,[A0FrP++] 		/* Restore state from frame */
+	SUB	A0StP,A0FrP,#8			/* Unwind stack */
+	MOV	A0FrP,D0FrT			/* Last memory read completes */
+	MOV	PC,D1RtP			/* Return to caller */
+	.size	___TBISwitch,.-___TBISwitch
+
+/*
+ * void __TBISyncResume( TBIRES State, int TrigMask );
+ *
+ * This routine causes the TBICTX structure specified in State.Sig.pCtx to
+ * be restored. This implies that execution will not return to the caller.
+ * The State.Sig.TrigMask field will be ored into TXMASKI during the
+ * context switch such that any immediately occuring interrupts occur in
+ * the context of the newly specified task. The State.Sig.SaveMask parameter
+ * is ignored.
+ */
+	.text
+	.balign	4
+	.global	___TBISyncResume
+	.type	___TBISyncResume,function
+___TBISyncResume:
+	MOV	D0Re0,D0Ar2			/* Result from args */
+	MOV	D1Re0,D1Ar1
+	XOR	D1Ar5,D1Ar5,D1Ar5		/* D1Ar5 = 0 */
+	ADD	D1RtP,D1Ar1,#TBICTX_AX
+	SWAP	D1Ar5,TXMASKI			/* D1Ar5 <-> TXMASKI */
+	MGETL	A0StP,A0FrP,[D1RtP]		/* Get frame values */
+	OR	TXMASKI,D1Ar5,D1Ar3		/* New TXMASKI */
+	B 	$LSwitchCmn
+	.size	___TBISyncResume,.-___TBISyncResume
+
+/*
+ * void __TBIJump( TBIX64 ArgsA, TBIX32 ArgsB, int TrigsMask,
+ *                               void (*fnMain)(), void *pStack );
+ *
+ * Jump directly to a new routine on an arbitrary stack with arbitrary args
+ * oring bits back into TXMASKI on route.
+ */
+	.text
+	.balign	4
+	.global	___TBIJump
+	.type	___TBIJump,function
+___TBIJump:
+	XOR	D0Re0,D0Re0,D0Re0		/* D0Re0 = 0 */
+	MOV	A0StP,D0Ar6			/* Stack = Frame */
+	SWAP	D0Re0,TXMASKI			/* D0Re0 <-> TXMASKI */
+	MOV	A0FrP,D0Ar6			
+	MOVT	A1LbP,#HI(__exit)
+	ADD	A1LbP,A1LbP,#LO(__exit)
+	MOV	D1RtP,A1LbP			/* D1RtP = __exit */
+	OR	TXMASKI,D0Re0,D0Ar4		/* New TXMASKI */
+	MOV	PC,D1Ar5			/* Jump to fnMain */
+	.size	___TBIJump,.-___TBIJump
+
+/*
+ *	PTBICTX __TBISwitchInit( void *pStack, int (*fnMain)(),
+ *                             .... 4 extra 32-bit args .... );
+ *                             
+ * Generate a new soft thread context ready for it's first outing.
+ *
+ *	D1Ar1 - Region of memory to be used as the new soft thread stack
+ *	D0Ar2 - Main line routine for new soft thread
+ *	D1Ar3, D0Ar4, D1Ar5, D0Ar6 - arguments to be passed on stack
+ *	The routine returns the initial PTBICTX value for the new thread
+ */
+	.text
+	.balign	4
+	.global	___TBISwitchInit
+	.type	___TBISwitchInit,function
+___TBISwitchInit:
+	MOV	D0FrT,A0FrP			/* Need save return point */
+	ADD	A0FrP,A0StP,#0
+	SETL	[A0StP++],D0FrT,D1RtP		/* Save return to caller */
+	MOVT	A1LbP,#HI(__exit)
+	ADD	A1LbP,A1LbP,#LO(__exit)
+	MOV	D1RtP,A1LbP			/* Get address of __exit */
+	ADD	D1Ar1,D1Ar1,#7			/* Align stack to 64-bits */
+	ANDMB	D1Ar1,D1Ar1,#0xfff8		/*   by rounding base up */
+	MOV	A0.2,D1Ar1			/* A0.2 is new stack */
+	MOV	D0FrT,D1Ar1			/* Initial puesdo-frame pointer */
+	SETL	[A0.2++],D0FrT,D1RtP		/* Save return to __exit */
+	MOV	D1RtP,D0Ar2
+	SETL	[A0.2++],D0FrT,D1RtP		/* Save return to fnMain */
+	ADD	D0FrT,D0FrT,#8			/* Advance puesdo-frame pointer */
+	MSETL	[A0.2],D0Ar6,D0Ar4		/* Save extra initial args */
+	MOVT	D1RtP,#HI(___TBIStart)		/* Start up code for new stack */
+	ADD	D1RtP,D1RtP,#LO(___TBIStart)
+	SETL	[A0.2++],D0FrT,D1RtP		/* Save return to ___TBIStart */
+	ADD	D0FrT,D0FrT,#(8*3)		/* Advance puesdo-frame pointer */
+	MOV	D0Re0,A0.2			/* Return pCtx for new thread */
+	MOV	D1Re0,#0			/* pCtx:0 is default Arg1:Arg2 */
+/*
+ * Generate initial TBICTX state
+ */
+	MOVT	D1Ar1,#HI($LSwitchExit)		/* Async restore code */
+	ADD	D1Ar1,D1Ar1,#LO($LSwitchExit)
+	MOVT	D0Ar2,#TBICTX_SOFT_BIT		/* Only soft thread state */
+	ADD	D0Ar6,A0.2,#TBICTX_BYTES	/* New A0StP */
+	MOV	D1Ar5,A1GbP			/* Same A1GbP */
+	MOV	D0Ar4,D0FrT			/* Initial A0FrP */
+	MOV	D1Ar3,A1LbP			/* Same A1LbP */
+	SETL	[A0.2++],D0Ar2,D1Ar1		/* Set header fields */
+	MSETL	[A0.2],D0Re0,D0Ar6,D0Ar4,D0Ar2,D0FrT,D0.5,D0.6,D0.7
+	MOV	D0Ar2,#0			/* Zero values */
+	MOV	D1Ar1,#0
+	SETL	[A0.2++],D0Ar2,D1Ar1		/* Zero CurrRPT, CurrBPOBITS, */
+	SETL	[A0.2++],D0Ar2,D1Ar1		/*      CurrMODE, and pCurrCBuf */
+	MSETL	[A0.2],D0Ar6,D0Ar4,D0Ar2,D0FrT D0_5 /* Set DX and then AX regs */
+	B	$LSwitchExit			/* All done! */
+	.size	___TBISwitchInit,.-___TBISwitchInit
+
+	.text
+	.balign	4
+	.global	___TBIStart
+	.type	___TBIStart,function
+___TBIStart:
+	MOV	D1Ar1,D1Re0			/* Pass TBIRES args to call */
+	MOV	D0Ar2,D0Re0
+	MGETL	D0Re0,D0Ar6,D0Ar4,[A0FrP]	/* Get hidden args */
+	SUB	A0StP,A0FrP,#(8*3)		/* Entry stack pointer */
+	MOV	A0FrP,D0Re0			/* Entry frame pointer */
+	MOVT	A1LbP,#HI(__exit)
+	ADD	A1LbP,A1LbP,#LO(__exit)
+	MOV	D1RtP,A1LbP			/* D1RtP = __exit */
+	MOV	PC,D1Re0			/* Jump into fnMain */
+	.size	___TBIStart,.-___TBIStart
+
+/*
+ * End of tbisoft.S
+ */
diff --git a/arch/metag/tbx/tbistring.c b/arch/metag/tbx/tbistring.c
new file mode 100644
index 0000000..42edeaa
--- /dev/null
+++ b/arch/metag/tbx/tbistring.c
@@ -0,0 +1,145 @@
+/*
+ * tbistring.c
+ *
+ * Copyright (C) 2001, 2002, 2003, 2005, 2007, 2012 Imagination Technologies.
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ *
+ * String table functions provided as part of the thread binary interface for
+ * META processors
+ */
+
+#include <linux/stddef.h>
+#include <asm/tbx.h>
+
+/* There are not any functions to modify the string table currently, if
+   these are required at some later point I suggest having a seperate module
+   and ensuring that creating new entries does not interfere with reading old
+   entries in any way. */
+
+const char *__TBICmpStr( const char *pSrc1, const char *pSrc2 )
+{
+	/* Compare two strings until we reach the end or get a difference */
+	for (pSrc1--;;)
+	{
+		char Ch = *++pSrc1;
+
+		/* Compare against *pSrc2 */
+		if ( Ch != *pSrc2++ ) break;
+
+		if ( Ch == 0 )
+		{
+			/* Return NULL for precise match! */
+			pSrc1 = NULL;
+			break;
+		}
+	}
+	
+	return ( pSrc1 );
+}
+
+const TBISTR *__TBIFindStr( const TBISTR *pStart,
+                            const char *pStr, int MatchLen )
+{
+	const TBISTR *pSearch = pStart;
+	int Exact = 1;
+	
+	if ( MatchLen < 0 )
+	{
+		/* Make MatchLen always positive for the inner loop */
+		MatchLen = -MatchLen;
+		Exact = 0;
+	}
+	else
+	{
+		/* Also support historic behaviour, which expected 
+		   MatchLen to include null terminator */
+		if ( pStr[MatchLen-1] == '\0' )
+			MatchLen--;
+	}
+	
+	if ( pSearch == NULL )
+	{
+		/* Find global string table segment */
+		PTBISEG pSeg = __TBIFindSeg( NULL, TBID_SEG( TBID_THREAD_GLOBAL,
+		                        TBID_SEGSCOPE_GLOBAL, TBID_SEGTYPE_STRING) );
+		
+		if ( (pSeg == NULL) || (pSeg->Bytes < sizeof(TBISTR)) )
+		{
+			/* No string table! */
+			return (NULL);
+		}
+
+		/* Start of string table */
+		pSearch = pSeg->pGAddr;
+	}
+		
+	for (;;)
+	{
+		while ( pSearch->Tag == 0 )
+		{
+			/* Allow simple gaps which are just zero initialised */
+			pSearch = (const TBISTR *) (((const char *) pSearch) + 8);
+		}
+
+		if ( pSearch->Tag == METAG_TBI_STRE )
+		{
+			/* Reached the end of the table */
+			pSearch = NULL;
+			break;
+		}
+		
+		if ( ( pSearch->Len >= MatchLen )               &&
+		     ( (!Exact) || (pSearch->Len == MatchLen+1) ) &&
+		     ( pSearch->Tag != METAG_TBI_STRG )            )
+		{
+			/* Worth searching */
+			const char *pMatch = __TBICmpStr( pStr,
+			                        (const char *) pSearch->String );
+
+			/* Exact match? */
+			if ( pMatch == NULL ) break;
+			
+			/* Sufficient match? */
+			if ( (!Exact) && ((pMatch - pStr) >= MatchLen) ) break;
+		}
+
+		/* Next entry */
+		pSearch = (const TBISTR *) (((const char *) pSearch) + pSearch->Bytes);
+	}
+
+	return ( pSearch );
+}
+
+const void *__TBITransStr( const char *pStr, int Len )
+{
+	const TBISTR *pSearch = NULL;
+	const void *pRes = NULL;
+
+	for (;;)
+	{
+		/* Search onwards */
+		pSearch = __TBIFindStr( pSearch, pStr, Len );
+		
+		/* No translation returns NULL */
+		if ( pSearch == NULL ) break;
+
+		/* Skip matching entries with no translation data */
+		if ( pSearch->TransLen != METAG_TBI_STRX )
+		{
+			/* Calculate base of translation string */
+			pRes = ((const char *) pSearch->String) + ((pSearch->Len + 7) & (~7));
+			break;
+		}
+		
+		/* Next entry */
+		pSearch = (const TBISTR *) (((const char *) pSearch) + pSearch->Bytes);
+	}
+
+	/* Return base address of translation data or NULL */
+	return ( pRes );
+}
+
+/* End of tbistring.c */
diff --git a/arch/metag/tbx/tbitimer.S b/arch/metag/tbx/tbitimer.S
new file mode 100644
index 0000000..5dbedde
--- /dev/null
+++ b/arch/metag/tbx/tbitimer.S
@@ -0,0 +1,207 @@
+/*
+ * tbitimer.S
+ *
+ * Copyright (C) 2001, 2002, 2007, 2012 Imagination Technologies.
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ *
+ * TBI timer support routines and data values
+ */
+
+	.file	"tbitimer.S"
+/*
+ * Get data structures and defines from the main C header
+ */
+#include <asm/tbx.h>
+
+	.data
+	.balign	8
+	.global	___TBITimeB
+	.type	___TBITimeB,object
+___TBITimeB:
+	.quad	0		/* Background 'lost' ticks */
+	.size	___TBITimeB,.-___TBITimeB
+
+	.data
+	.balign	8
+	.global	___TBITimeI
+	.type	___TBITimeI,object
+___TBITimeI:
+	.quad	0		/* Interrupt 'lost' ticks */
+	.size	___TBITimeI,.-___TBITimeI
+
+	.data
+	.balign	8
+	.global	___TBITimes
+	.type	___TBITimes,object
+___TBITimes:
+	.long	___TBITimeB	/* Table of 'lost' tick values */
+	.long	___TBITimeI
+	.size	___TBITimes,.-___TBITimes
+
+/*
+ * Flag bits for control of ___TBITimeCore
+ */
+#define TIMER_SET_BIT  1
+#define TIMER_ADD_BIT  2
+
+/*
+ * Initialise or stop timer support
+ *
+ * Register Usage: D1Ar1 holds Id, D1Ar2 is initial delay or 0
+ *                 D0FrT is used to call ___TBITimeCore
+ *                 D0Re0 is used for the result which is TXSTAT_TIMER_BIT
+ *                 D0Ar4, D1Ar5, D0Ar6 are all used as scratch
+ *		  Other registers are those set by ___TBITimeCore
+ *			A0.3 is assumed to point at ___TBITime(I/B)
+ */
+	.text
+	.balign	4
+	.global	___TBITimerCtrl
+	.type	___TBITimerCtrl,function
+___TBITimerCtrl:
+	MOV	D1Ar5,#TIMER_SET_BIT		/* Timer SET request */
+	MOVT	D0FrT,#HI(___TBITimeCore)	/* Get timer core reg values */
+	CALL	D0FrT,#LO(___TBITimeCore)	/* and perform register update */
+	NEGS	D0Ar6,D0Ar2			/* Set flags from time-stamp */
+	ASR	D1Ar5,D0Ar6,#31			/* Sign extend D0Ar6 into D1Ar5 */
+	SETLNZ	[A0.3],D0Ar6,D1Ar5		/* ___TBITime(B/I)=-Start if enable */
+	MOV	PC,D1RtP			/* Return */
+	.size	___TBITimerCtrl,.-___TBITimerCtrl
+	
+/*
+ * Return ___TBITimeStamp value
+ *
+ * Register Usage: D1Ar1 holds Id
+ *                 D0FrT is used to call ___TBITimeCore
+ *                 D0Re0, D1Re0 is used for the result
+ *                 D1Ar3, D0Ar4, D1Ar5
+ *		  Other registers are those set by ___TBITimeCore
+ *			D0Ar6 is assumed to be the timer value read
+ *			A0.3 is assumed to point at ___TBITime(I/B)
+ */
+	.text
+	.balign	4
+	.global	___TBITimeStamp
+	.type	___TBITimeStamp,function
+___TBITimeStamp:
+	MOV	D1Ar5,#0			/* Timer GET request */
+	MOVT	D0FrT,#HI(___TBITimeCore)	/* Get timer core reg values */
+	CALL	D0FrT,#LO(___TBITimeCore)	/* with no register update */
+	ADDS	D0Re0,D0Ar4,D0Ar6		/* Add current time value */
+	ADD	D1Re0,D1Ar3,D1Ar5		/*  to 64-bit signed extend time */
+	ADDCS	D1Re0,D1Re0,#1			/* Support borrow too */
+	MOV	PC,D1RtP			/* Return */
+	.size	___TBITimeStamp,.-___TBITimeStamp
+
+/*
+ * Perform ___TBITimerAdd logic
+ *
+ * Register Usage: D1Ar1 holds Id, D0Ar2 holds value to be added to the timer
+ *                 D0Re0 is used for the result - new TIMER value
+ *                 D1Ar5, D0Ar6 are used as scratch
+ *		  Other registers are those set by ___TBITimeCore
+ *			D0Ar6 is assumed to be the timer value read
+ *			D0Ar4, D1Ar3 is the current value of ___TBITime(B/I)
+ */
+	.text
+	.balign	4
+	.global	___TBITimerAdd
+	.type	___TBITimerAdd,function
+___TBITimerAdd:
+	MOV	D1Ar5,#TIMER_ADD_BIT		/* Timer ADD request */
+	MOVT	D0FrT,#HI(___TBITimeCore)	/* Get timer core reg values */
+	CALL	D0FrT,#LO(___TBITimeCore)	/* with no register update */
+	ADD	D0Re0,D0Ar2,D0Ar6		/* Regenerate new value = result */
+	NEG	D0Ar2,D0Ar2			/* Negate delta */
+	ASR	D1Re0,D0Ar2,#31			/* Sign extend negated delta */
+	ADDS	D0Ar4,D0Ar4,D0Ar2		/* Add time added to ... */
+	ADD	D1Ar3,D1Ar3,D1Re0		/* ... real timer ... */
+	ADDCS	D1Ar3,D1Ar3,#1			/* ... with carry */
+	SETL	[A0.3],D0Ar4,D1Ar3		/* Update ___TBITime(B/I) */
+	MOV	PC,D1RtP			/* Return */
+	.size	___TBITimerAdd,.-___TBITimerAdd
+
+#ifdef TBI_1_4
+/*
+ * Perform ___TBITimerDeadline logic
+ *    NB: Delays are positive compared to the Wait values which are -ive
+ *
+ * Register Usage: D1Ar1 holds Id
+ *                 D0Ar2 holds Delay requested
+ *                 D0Re0 is used for the result - old TIMER Delay value
+ *                 D1Ar5, D0Ar6 are used as scratch
+ *                 Other registers are those set by ___TBITimeCore
+ *                 D0Ar6 is assumed to be the timer value read
+ *                 D0Ar4, D1Ar3 is the current value of ___TBITime(B/I)
+ *
+ */
+        .text
+        .type   ___TBITimerDeadline,function
+        .global ___TBITimerDeadline
+        .align  2
+___TBITimerDeadline:
+	MOV	D1Ar5,#TIMER_SET_BIT		/* Timer SET request */
+	MOVT	D0FrT,#HI(___TBITimeCore)	/* Get timer core reg values */
+	CALL	D0FrT,#LO(___TBITimeCore)	/* with no register update */
+	MOV	D0Re0,D0Ar6			/* Old value read = result */
+	SUB	D0Ar2,D0Ar6,D0Ar2		/* Delta from (old - new) */
+	ASR	D1Re0,D0Ar2,#31			/* Sign extend delta */
+	ADDS	D0Ar4,D0Ar4,D0Ar2		/* Add time added to ... */
+	ADD	D1Ar3,D1Ar3,D1Re0		/* ... real timer ... */
+	ADDCS	D1Ar3,D1Ar3,#1			/* ... with carry */
+	SETL	[A0.3],D0Ar4,D1Ar3		/* Update ___TBITime(B/I) */
+	MOV	PC,D1RtP			/* Return */
+        .size   ___TBITimerDeadline,.-___TBITimerDeadline
+#endif /* TBI_1_4 */
+
+/*
+ * Perform core timer access logic
+ *
+ * Register Usage: D1Ar1 holds Id, D0Ar2 holds input value for SET and
+ *                                             input value for ADD
+ *                 D1Ar5 controls op as SET or ADD as bit values
+ *                 On return D0Ar6, D1Ar5 holds the old 64-bit timer value
+ *                 A0.3 is setup to point at ___TBITime(I/B)
+ *                 A1.3 is setup to point at ___TBITimes
+ *                 D0Ar4, D1Ar3 is setup to value of ___TBITime(I/B)
+ */
+	.text
+	.balign	4
+	.global	___TBITimeCore
+	.type	___TBITimeCore,function
+___TBITimeCore:
+#ifndef METAC_0_1
+	TSTT	D1Ar1,#HI(TBID_ISTAT_BIT)	/* Interrupt level timer? */
+#endif
+	MOVT	A1LbP,#HI(___TBITimes)
+	ADD	A1LbP,A1LbP,#LO(___TBITimes)
+	MOV	A1.3,A1LbP			/* Get ___TBITimes address */
+#ifndef METAC_0_1
+	BNZ	$LTimeCoreI			/* Yes: Service TXTIMERI! */
+#endif
+	LSRS	D1Ar5,D1Ar5,#1			/* Carry = SET, Zero = !ADD */
+	GETD	A0.3,[A1.3+#0]			/* A0.3 == &___TBITimeB */
+	MOV	D0Ar6,TXTIMER			/* Always GET old value */
+	MOVCS	TXTIMER,D0Ar2			/* Conditional SET operation */
+	ADDNZ	TXTIMER,D0Ar2,D0Ar6		/* Conditional ADD operation */
+#ifndef METAC_0_1
+	B	$LTimeCoreEnd
+$LTimeCoreI:
+	LSRS	D1Ar5,D1Ar5,#1			/* Carry = SET, Zero = !ADD */
+	GETD	A0.3,[A1.3+#4]			/* A0.3 == &___TBITimeI */
+	MOV	D0Ar6,TXTIMERI			/* Always GET old value */
+	MOVCS	TXTIMERI,D0Ar2			/* Conditional SET operation */
+	ADDNZ	TXTIMERI,D0Ar2,D0Ar6		/* Conditional ADD operation */
+$LTimeCoreEnd:
+#endif
+	ASR	D1Ar5,D0Ar6,#31			/* Sign extend D0Ar6 into D1Ar5 */
+	GETL	D0Ar4,D1Ar3,[A0.3]		/* Read ___TBITime(B/I) */
+	MOV	PC,D0FrT			/* Return quickly */
+	.size	___TBITimeCore,.-___TBITimeCore
+
+/*
+ * End of tbitimer.S
+ */
-- 
1.7.7.6


