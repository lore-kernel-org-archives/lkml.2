Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab1GMPzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 11:55:16 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:34263 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754596Ab1GMPzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 11:55:15 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: E5LCc1YVM1kfc_SRieQe.RV9XvW6Nxiqxou2r8RUaxjVmBY
 YFjre12GY0GPVRQcFqlXuAAIBVS32LITXoESZJtVzMU2jQ5r7T2SAj6eVjwh
 kppeca9I0zytilqQLPQ59a59wzBrWX7f8NrTcXQ0CCCazqUcXT18I6UZ6pMI
 2vy23Yk5NPS2Fxy.j4YieIAjVUdJLjsxBNcupVE9d_ulBOMpXWcUYdSvisgZ
 RrEWlmSXQ_PEkELGMISHMnnP_4P94M_AE2Sm4Q1j05z238ENyRHadf7oi6yO
 IoOs515qbuwisO6bECf8iozlH5BRtBTsX7ZTzBWS2E.nTvbHu
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 13 Jul 2011 10:55:12 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Hugh Dickins <hughd@google.com>
cc: Pekka Enberg <penberg@kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH next/mmotm] slub: partly fix freeze in __slab_free
In-Reply-To: <alpine.DEB.2.00.1107131041170.29034@router.home>
Message-ID: <alpine.DEB.2.00.1107131054270.29034@router.home>
References: <alpine.LSU.2.00.1107111156310.13035@sister.anvils> <1310413167.2860.3.camel@edumazet-laptop> <4E1BE5F9.10401@kernel.org> <alpine.DEB.2.00.1107121010060.1672@router.home> <alpine.DEB.2.00.1107121046000.2530@router.home>
 <alpine.LSU.2.00.1107130357560.4184@sister.anvils> <alpine.DEB.2.00.1107131041170.29034@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: slub: disable interrupts in cmpxchg_double_slab when falling back to pagelock.

Disable interrupts when falling back to the use of the page lock in
cmpxchg_double_slab().

Becomes necessary since __slab_free will call cmpxchg_double_slab without disabling
interrupts.

A bit bad because the invocations from the allocation path of cmpxchg_double_slab
occur with interrupts already disabled (but there are plans to enable
interrupts there as well in the future).

Signed-off-by: Christoph Lameter <cl@linux.com>


---
 mm/slub.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-07-13 10:51:07.867138834 -0500
+++ linux-2.6/mm/slub.c	2011-07-13 10:51:20.957138752 -0500
@@ -368,14 +368,19 @@ static inline bool cmpxchg_double_slab(s
 	} else
 #endif
 	{
+		unsigned long flags;
+
+		local_irq_save(flags);
 		slab_lock(page);
 		if (page->freelist == freelist_old && page->counters == counters_old) {
 			page->freelist = freelist_new;
 			page->counters = counters_new;
 			slab_unlock(page);
+			local_irq_restore(flags);
 			return 1;
 		}
 		slab_unlock(page);
+		local_irq_restore(flags);
 	}

 	cpu_relax();
