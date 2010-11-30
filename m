Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab0K3Txc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:53:32 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:35274 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756511Ab0K3TxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:53:16 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: fczF0MgVM1nPJxcmSr96cJ3QSB1t9RjT_v7Nh.muN8Dsagb
 AeInvvrjXw6ri5J2eOUGCVSHWCT6jYA2URKkQBJYHMDpJnmEy8RSobVdwbec
 hTpWHdGx2V9bUnylZqMD4GCe.In5_jIgxk6hhK0gQQZ6ab8HdU1eaObg3ARh
 zuDV7fPlb5S871fK0z54N_Xf8IwNW9oxyarlaYsFUexPHFvpWTu0I1R__QrA
 bkvbeu1As_esA9zzHpQuzInEFSn7Tru0TcysAnXC3yNvsIlak.EUrMF4l5.p
 6_YgH8afY.68hPYGNw0UO
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 30 Nov 2010 13:53:11 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Eric Dumazet <eric.dumazet@gmail.com>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org
Subject: Re: [thisops uV3 07/18] highmem: Use this_cpu_xx_return()
 operations
In-Reply-To: <1291145910.32004.1166.camel@laptop>
Message-ID: <alpine.DEB.2.00.1011301352390.4039@router.home>
References: <20101130190707.457099608@linux.com>  <20101130190845.216537525@linux.com>  <1291144408.2904.232.camel@edumazet-laptop>  <alpine.DEB.2.00.1011301325180.3134@router.home>  <1291145391.2904.247.camel@edumazet-laptop>
 <1291145910.32004.1166.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010, Peter Zijlstra wrote:

> On Tue, 2010-11-30 at 20:29 +0100, Eric Dumazet wrote:
> >
> > well maybe a single prototype ;)
> >
> > static inline void kmap_atomic_idx_pop(void)
> > {
> > #ifdef CONFIG_DEBUG_HIGHMEM
> >         int idx = __this_cpu_dec_return(__kmap_atomic_idx);
> >         BUG_ON(idx < 0);
> > #else
> >       __this_cpu_dec(__kmap_atomic_idx);
> > #endif
> > }
>
> Right, at least a consistent prototype, the above looks fine to me.

Ok with right spacing this is:

Subject: highmem: Use this_cpu_dec instead of __this_cpu_dec_return if
!DEBUG_HIGHMEM

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 include/linux/highmem.h |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux-2.6/include/linux/highmem.h
===================================================================
--- linux-2.6.orig/include/linux/highmem.h	2010-11-30 13:23:44.000000000 -0600
+++ linux-2.6/include/linux/highmem.h	2010-11-30 13:51:39.000000000 -0600
@@ -95,13 +95,15 @@ static inline int kmap_atomic_idx(void)
 	return __this_cpu_read(__kmap_atomic_idx) - 1;
 }

-static inline int kmap_atomic_idx_pop(void)
+static inline void kmap_atomic_idx_pop(void)
 {
-	int idx = __this_cpu_dec_return(__kmap_atomic_idx);
 #ifdef CONFIG_DEBUG_HIGHMEM
+	int idx = __this_cpu_dec_return(__kmap_atomic_idx);
+
 	BUG_ON(idx < 0);
+#else
+	__this_cpu_dec(__kmap_atomic_idx);
 #endif
-	return idx;
 }

 #endif

