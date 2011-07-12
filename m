Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab1GLPz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 11:55:27 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:39368 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753855Ab1GLPzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 11:55:25 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: zLwiK4wVM1nRJHsjIjMlMvc0WqUURi7aH3yfnWaW8pAcafM
 JZ_IP_zmDChaQku3oFZiNQA9TgR7eCMsJUFDsNYoowcBCgRV3I6AzjEenu89
 iYPerAilLaMVbRqt5P3G8TIrYU9mB8zztYJYYvDr9fliALNQUPFyTS7ZRQvT
 VzoYWwtlQdLa.Si1YsXzfEV8MxoPOXWpZW_Xq.O0kG9ymBfkD6plFEyteQxJ
 u4SqbbscDd2YQz1eMSV3Y3vVUk.8LjSD6Cfy5sxdzBRF92oAqhieYYjRnYHh
 U8tgNYGefTLiQN3v9xYqECV_asghTTSJj0_Bk5aILny8UB47N.jJnFL3yrv.
 pkFRdOh2EVrWCFWctMhwXlkvm
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 12 Jul 2011 10:55:22 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Eric Dumazet <eric.dumazet@gmail.com>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH next/mmotm] slub: partly fix freeze in __slab_free
In-Reply-To: <alpine.DEB.2.00.1107121010060.1672@router.home>
Message-ID: <alpine.DEB.2.00.1107121046000.2530@router.home>
References: <alpine.LSU.2.00.1107111156310.13035@sister.anvils> <1310413167.2860.3.camel@edumazet-laptop> <4E1BE5F9.10401@kernel.org> <alpine.DEB.2.00.1107121010060.1672@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wish there would be some easier way to overlay fields. The counters
field exists to allow an easier reference to the bitfield structure in
order to pass it to cmpxchg_double_slab.

In 64 bit the counters field needs to overlay the bitfields and _count
since we can only pass 64 bits integers to cmpxchg_double_slab.

On 32 bit counters field only covers the bitfields.

The "new" page struct in __slab_free is only partially populated and the
overlays are used for conversion between structs and words in order to be
able to pass the struct contents by value.

Signed-off-by: Christoph Lameter <cl@linux.com>


---
 include/linux/mm_types.h |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

Index: linux-2.6/include/linux/mm_types.h
===================================================================
--- linux-2.6.orig/include/linux/mm_types.h	2011-07-12 10:14:08.057706223 -0500
+++ linux-2.6/include/linux/mm_types.h	2011-07-12 10:14:14.117706184 -0500
@@ -56,20 +56,26 @@ struct page {
 		};

 		union {
-			atomic_t _mapcount;	/* Count of ptes mapped in mms,
+			/* Used for cmpxchg_double in slub */
+			unsigned long counters;
+
+			struct {
+
+				union {
+					atomic_t _mapcount;	/* Count of ptes mapped in mms,
 							 * to show when page is mapped
 							 * & limit reverse map searches.
 							 */

-			/* Used for cmpxchg_double in slub */
-			unsigned long counters;
-			struct {
-				unsigned inuse:16;
-				unsigned objects:15;
-				unsigned frozen:1;
+					struct {
+						unsigned inuse:16;
+						unsigned objects:15;
+						unsigned frozen:1;
+					};
+				};
+				atomic_t _count;		/* Usage count, see below. */
 			};
 		};
-		atomic_t _count;		/* Usage count, see below. */
 	};

 	/* Third double word block */
