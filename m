Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab1EDOff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 10:35:35 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:32195 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753167Ab1EDOfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 10:35:34 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: lsihS18VM1lg90w49LpXQaPaeUSuNMb3vRl_d1eiCGA8vFg
 rDq2AL5aK4IfyHu6PukP_nJ.8WybqLk2P8rZe4AKnGCRVxh.kg5fe3R1.Vde
 D6_Z0YspDxJsbOKvsJ3lpPqI1WLWUEnjxJV8SUxMKR_TRaeOslx8Fz94Midm
 o_wy3CMu7MbMNBPwxW91EOEgBK3z7pAM5eyTP._xj4pbAPFNBW01Qs5yAK4T
 mqg8mVzp7LKHnJhShM3Z4MFy0leW06cTIFrpQoVBHeQSGKa0Yxs.Ww60RLgb
 I0KfSroC5dakRgszHgz38W6txjCFgFGS9qaUCJL4zaRkD97Ab
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 4 May 2011 09:35:30 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
In-Reply-To: <20110504142532.GC17294@htj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1105040934570.5495@router.home>
References: <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com> <20110504083559.GB25724@elte.hu> <alpine.LFD.2.02.1105041124080.3005@ionos> <20110504101932.GA3392@elte.hu> <alpine.LFD.2.02.1105041233280.3005@ionos> <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com>
 <20110504112746.GE8007@htj.dyndns.org> <alpine.LFD.2.02.1105041417330.3005@ionos> <20110504132022.GA17294@htj.dyndns.org> <alpine.LFD.2.02.1105041539050.3005@ionos> <20110504142532.GC17294@htj.dyndns.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, Tejun Heo wrote:

> The cmpxchg_double optimization made the fast path go quite faster
> when CPU supports it but it may as well slow things down considerably
> if CPU doesn't, due to extra irq on/off's.  Anyways, here's hoping
> that the slow down is acceptable compared to the base code without
> cmpxchg_double and the ugliness can be removed.

I think we are all in agreement. First path to fix the percpu macros:


Subject: percpu: Fix irqsafe_cpu_cmpxchg_double

The function in the macro was not updated when the function was given a bool return value.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 include/linux/percpu.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2011-05-04 09:33:08.000000000 -0500
+++ linux-2.6/include/linux/percpu.h	2011-05-04 09:33:39.000000000 -0500
@@ -948,7 +948,7 @@ do {									\
 	irqsafe_generic_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
 # endif
 # define irqsafe_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	__pcpu_double_call_return_int(irqsafe_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
+	__pcpu_double_call_return_bool(irqsafe_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
 #endif

 #endif /* __LINUX_PERCPU_H */
