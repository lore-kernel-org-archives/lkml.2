Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab1HEQS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 12:18:28 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:40486 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754549Ab1HEQS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 12:18:27 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: HIKGUo4VM1ljkSPD_68kmqNH.J8UuXXXcwpEfv4W0YDP83x
 eGDx0i6NswMlzVU.vSavZy.b9g0FbZdyAV5xAFaryEc0.tF_BoRR2DTmW1y7
 bgJDWpdICONxsx3sWTxiQaxMp2i1s8k8Vd0W0F6IRMxivq4xAnIqWBy9fU3q
 yc_hpwD4OOK25xbKX69IILZTYNXFXK.wsilrAHMqBU0mFPIZJqUu9sRLqIUo
 vw9bFpKXkidL9.ivai.VbxwFA_UW6maDu41wg0Q919L7a4yvcOs8KNK2iYlY
 nxUmeoya4gldw9pzSqKldzIwwTOdDLmG55gs.U9bq4WzAe2z3k7thWTDC27v
 zHHKFqIqRqz.YCd92xqYTBjuj_5rTsZ0CWU3ZgKGg.dowpDuap04eqRCZxhG
 qCDJ_CVVbZLXpEJMIaOordA--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 5 Aug 2011 11:18:24 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [x86] Fix prefetch instruction
Message-ID: <alpine.DEB.2.00.1108051116520.28580@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prefetchnta instruction used for prefetching on x86 is a special instruction
used for streaming that is usually used to avoid polluting the l2 and l3 caches.
The cacheline will be evicted rapidly.

What we need is a prefetch that puts the cacheline in all levels of the cache hierachy instead.
Change the instruction to do that.

Acked-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Christoph Lameter <cl@linux.com>


---
 arch/x86/include/asm/processor.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/x86/include/asm/processor.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/processor.h	2011-08-04 13:12:39.000000000 -0500
+++ linux-2.6/arch/x86/include/asm/processor.h	2011-08-04 13:16:31.000000000 -0500
@@ -829,7 +829,7 @@ extern char			ignore_fpu_irq;
 static inline void prefetch(const void *x)
 {
 	alternative_input(BASE_PREFETCH,
-			  "prefetchnta (%1)",
+			  "prefetcht0 (%1)",
 			  X86_FEATURE_XMM,
 			  "r" (x));
 }
