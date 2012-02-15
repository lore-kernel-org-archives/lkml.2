Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078Ab2BOOTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 09:19:10 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:52423 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758236Ab2BOOTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 09:19:07 -0500
Message-ID: <4F3BBED4.2090101@linux.vnet.ibm.com>
Date: Wed, 15 Feb 2012 19:49:00 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: akpm@linux-foundation.org, kosaki.motohiro@gmail.com,
        linux-kernel@vger.kernel.org, venki@google.com, rusty@rustcorp.com.au,
        Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] lib/cpumask.c: Optimize __any_online_cpu() calculation
References: <20120215123208.15623.73499.stgit@srivatsabhat.in.ibm.com> <1329310627.2437.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
In-Reply-To: <1329310627.2437.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
x-cbid: 12021514-9574-0000-0000-000001649C31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2012 06:27 PM, Eric Dumazet wrote:

> Le mercredi 15 février 2012 à 18:05 +0530, Srivatsa S. Bhat a écrit :
>> __any_online_cpu() uses a for loop at the moment.
>> Instead, use cpumask_* operations to speed it up.
>>
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>> ---
>> Actually, the patch posted at https://lkml.org/lkml/2012/2/15/101 removed
>> the last user of any_online_cpu() (and hence __any_online_cpu()).
>> However, since this is an exported symbol, I refrained from removing this
>> function altogether.
> 
> Just remove the export/function and eventually leave the helper ?
> 
> #define any_online_cpu(mask) cpumask_any_and(mask, cpu_online_mask)
> 


That sounds good. Here is v2 of the patch.
(Since this v2 touches include/linux/cpumask.h, I rebased it on top of the
patch posted at: https://lkml.org/lkml/2012/2/15/2. Even without that
patch it should apply with minor line number changes..)

---
From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2] lib/cpumask.c: Remove __any_online_cpu()

__any_online_cpu() is not optimal and also unnecessary.
So, replace its use by faster cpumask_* operations.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/cpumask.h |    3 +--
 lib/cpumask.c           |   12 ------------
 2 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 42fec19..d3ccd2d 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -808,11 +808,10 @@ static inline const struct cpumask *get_cpu_mask(unsigned int cpu)
 #else /* NR_CPUS > 1 */
 int __first_cpu(const cpumask_t *srcp);
 int __next_cpu(int n, const cpumask_t *srcp);
-int __any_online_cpu(const cpumask_t *mask);
 
 #define first_cpu(src)		__first_cpu(&(src))
 #define next_cpu(n, src)	__next_cpu((n), &(src))
-#define any_online_cpu(mask) __any_online_cpu(&(mask))
+#define any_online_cpu(mask) cpumask_any_and(&mask, cpu_online_mask)
 #define for_each_cpu_mask(cpu, mask)			\
 	for ((cpu) = -1;				\
 		(cpu) = next_cpu((cpu), (mask)),	\
diff --git a/lib/cpumask.c b/lib/cpumask.c
index af3e5817..0470742 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -26,18 +26,6 @@ int __next_cpu_nr(int n, const cpumask_t *srcp)
 EXPORT_SYMBOL(__next_cpu_nr);
 #endif
 
-int __any_online_cpu(const cpumask_t *mask)
-{
-	int cpu;
-
-	for_each_cpu(cpu, mask) {
-		if (cpu_online(cpu))
-			break;
-	}
-	return cpu;
-}
-EXPORT_SYMBOL(__any_online_cpu);
-
 /**
  * cpumask_next_and - get the next cpu in *src1p & *src2p
  * @n: the cpu prior to the place to search (ie. return will be > @n)


