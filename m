Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab0K3T0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:26:44 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:42853 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752580Ab0K3T0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:26:43 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Ykyy.9UVM1mY8TD7pystaxenu74CiPEBh0wKQx9OFP3sCCK
 6k0czmo1eX3Fo2c4bIOZbRjzwMDqc5JbqReL5tflOmiB51TRSFuZomD4zrZ1
 z0nS6Y2PIK4RslXmLex07pAZ19r5G0_b3WEwnJJPdoQj1TYmxxJroPEtD4qQ
 fDVZ1yauEW31ddpTIODngaC3Vgv.kRDTqQFG75l.h.YKZ3mqJnbU2m0c2YJM
 8pDC1gOm5u_CrbASXrWRTHfTrpoVjUKBWu9qbbTTBDkNM.Nc3h4Q_
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 30 Nov 2010 13:26:39 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org
Subject: Re: [thisops uV3 07/18] highmem: Use this_cpu_xx_return()
 operations
In-Reply-To: <1291144408.2904.232.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1011301325180.3134@router.home>
References: <20101130190707.457099608@linux.com>  <20101130190845.216537525@linux.com> <1291144408.2904.232.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010, Eric Dumazet wrote:

> >  {
> > -	int idx = --__get_cpu_var(__kmap_atomic_idx);
> > +	int idx = __this_cpu_dec_return(__kmap_atomic_idx);
>
> __this_cpu_dec_return() is only needed if CONFIG_DEBUG_HIGHMEM
>
> >  #ifdef CONFIG_DEBUG_HIGHMEM
> >  	BUG_ON(idx < 0);
> >  #endif
> >
>
> You could change kmap_atomic_idx_pop() to return void, and use
> __this_cpu_dec(__kmap_atomic_idx)

The following would do?


Subject: highmem: Use this_cpu_dec instead of __this_cpu_dec_return if !DEBUG_HIGHMEM

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 include/linux/highmem.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/highmem.h
===================================================================
--- linux-2.6.orig/include/linux/highmem.h	2010-11-30 13:23:44.000000000 -0600
+++ linux-2.6/include/linux/highmem.h	2010-11-30 13:24:54.000000000 -0600
@@ -95,14 +95,19 @@ static inline int kmap_atomic_idx(void)
 	return __this_cpu_read(__kmap_atomic_idx) - 1;
 }

+#ifdef CONFIG_DEBUG_HIGHMEM
 static inline int kmap_atomic_idx_pop(void)
 {
 	int idx = __this_cpu_dec_return(__kmap_atomic_idx);
-#ifdef CONFIG_DEBUG_HIGHMEM
 	BUG_ON(idx < 0);
-#endif
 	return idx;
 }
+#else
+static inline void kmap_atomic_idx_pop(void)
+{
+	__this_cpu_dec(__kmap_atomic_idx);
+}
+#endif

 #endif

