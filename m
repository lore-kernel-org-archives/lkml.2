Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab1GFOqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 10:46:22 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:20839 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753457Ab1GFOqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 10:46:21 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: rGwEr4oVM1nnpLngUTDOevCdMMVG9aJJikduphIaHsYDu1_
 e8D9.CcC_OeSKRFnn97PECXioFVdvD5267OPEfOlr5eqQshR0dxh7Hfm1.5y
 f4gyvE7iKYDo_UiyY7qzchum0_oIhGF_KMkPoCZRvSxwm_S.HjFr_pF7ZObx
 DSu30Sa0cOjr.KEYG0zvthq6mlXjPNnZ.zJslLAfMpHV7_p09yrPW8xLiPxf
 52336Yf1CO4q4N.7SEwnU8IzcL1oTHuGDe2k0g7DfPRPWgPiNRiHPKZJgbb8
 hqPP05YW2yFCvhWssptS5EGJeobUMa2DsofuOb7A2KFvUy8FQ
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 6 Jul 2011 09:46:18 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Jonathan Cameron <jic23@cam.ac.uk>
cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Build issue with linux next. duplicate member _count in
 mm_types.h
In-Reply-To: <4E143120.2020501@cam.ac.uk>
Message-ID: <alpine.DEB.2.00.1107060933460.17202@router.home>
References: <4E143120.2020501@cam.ac.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jul 2011, Jonathan Cameron wrote:

> Getting:
>
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
> make[1]: `include/generated/mach-types.h' is up to date.
>   CC      arch/arm/kernel/asm-offsets.s
> In file included from include/linux/sched.h:64:0,
>                  from arch/arm/kernel/asm-offsets.c:13:
> include/linux/mm_types.h:74:15: error: duplicate member '_count'
> make[1]: *** [arch/arm/kernel/asm-offsets.s] Error 1
> make: *** [prepare0] Error 2
>
> Issue looks to have been introduced by
>
>     mm: Rearrange struct page
>
> fc9bb8c768abe7ae10861c3510e01a95f98d5933
>
> Guessing it's a known issue, but just thought I'd flag it up in case
> it's something very specific about my build.
>
> gcc-2.6 armv7a
>
> Reverting that patch works, but given I don't know the history, I'm
> not proposing doing that in general!

Well _count exists in two unionized structs but always has the same offset
within the larger struct. Maybe ARM creates different offsets there for
some reason?

The following is a patch to restructure the union / structs combo in such
a way that only a single definition of _count

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 include/linux/mm_types.h |   25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

Index: linux-2.6/include/linux/mm_types.h
===================================================================
--- linux-2.6.orig/include/linux/mm_types.h	2011-07-06 09:35:10.078120512 -0500
+++ linux-2.6/include/linux/mm_types.h	2011-07-06 09:44:47.388116815 -0500
@@ -49,32 +49,27 @@ struct page {
 					 * see PAGE_MAPPING_ANON below.
 					 */
 	/* Second double word */
-	union {
-		struct {
+	struct {
+		union {
 			pgoff_t index;		/* Our offset within mapping. */
+			void *freelist;		/* slub first free object */
+		};
+
+		union {
 			atomic_t _mapcount;	/* Count of ptes mapped in mms,
 							 * to show when page is mapped
 							 * & limit reverse map searches.
 							 */
-			atomic_t _count;		/* Usage count, see below. */
-		};

-		struct {			/* SLUB cmpxchg_double area */
-			void *freelist;
-			union {
-				unsigned long counters;
-				struct {
+			/* Used for cmpxchg_double in slub */
+			unsigned long counters;
+			struct {
 					unsigned inuse:16;
 					unsigned objects:15;
 					unsigned frozen:1;
-					/*
-					 * Kernel may make use of this field even when slub
-					 * uses the rest of the double word!
-					 */
-					atomic_t _count;
-				};
 			};
 		};
+		atomic_t _count;		/* Usage count, see below. */
 	};

 	/* Third double word block */
