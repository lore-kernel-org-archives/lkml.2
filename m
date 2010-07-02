Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606Ab0GBNYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 09:24:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49665 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756314Ab0GBNYP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 09:24:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dJudZsLa1WWjPY1xEUANQ8fOTtHjextRUQdX0oL80SsSun9R3cT+4VKTxR4IBVUn2w
         kH+t1CCnzjPtYBJkVyI42tnIzC4IRiCM66Se7rbxGkvXFIFU257xlMr05Gz6KIDPaZLX
         f4wv04yDoKVhBrU/+YoXRy5ImHtIDh1SSA53E=
MIME-Version: 1.0
In-Reply-To: <20100702125628.GK10072@secunet.com>
References: <AANLkTimVTMsVkSBHWLve8t76-YkoSYposgv9wHir_wPa@mail.gmail.com>
	<20100702125628.GK10072@secunet.com>
Date: Fri, 2 Jul 2010 17:24:13 +0400
X-Google-Sender-Auth: 1rM6-60Q2SlRHwunYXOgEGoHOe4
Message-ID: <AANLkTimH9IKkqqLADjUbycKD8bh4oX8oCxSDTCGxv4r1@mail.gmail.com>
Subject: Re: [PATCH] Fixed division by zero bug in kernel/padata.c
From: Dan Kruchinin <dkruchinin@acm.org>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No problem. Here is fixed patch:
--
 When boot CPU(typically CPU #0) is excluded from padata cpumask and
 user enters halt command from console, kernel faults on division by zero;
 This occurs because during the halt kernel shuts down each non-boot CPU one
 by one. After it shuts down the last CPU that is set in the padata cpumask,
 the only working CPU in the system is a boot CPU(#0) and it's the only CPU that
 is set in the cpu_active_mask. Hence when padata_cpu_callback calls
 __padata_remove_cpu(and hence padata_alloc_pd) it appears that padata
cpumask and
 cpu_active mask aren't intersect. Hence the following code in
padata_alloc_pd causes
 a DZ error exception:
  cpumask_and(pd->cpumask, cpumask, cpu_active_mask); // pd->cpumask
will be empty
  ...
  num_cpus = cpumask_weight(pd->cpumask); // num_cpus = 0
  pd->max_seq_nr = (MAX_SEQ_NR / num_cpus) * num_cpus - 1; // DZ!


Signed-off-by: Dan Kruchinin <dkruchinin@acm.org>
---
 kernel/padata.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index fdd8ae6..dcddac0 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -435,6 +435,9 @@ static struct parallel_data
*padata_alloc_pd(struct padata_instance *pinst,
 	}

 	num_cpus = cpumask_weight(pd->cpumask);
+	if (!num_cpus)
+		goto err_free_cpumask;
+
 	pd->max_seq_nr = (MAX_SEQ_NR / num_cpus) * num_cpus - 1;

 	setup_timer(&pd->timer, padata_reorder_timer, (unsigned long)pd);
@@ -446,6 +449,8 @@ static struct parallel_data
*padata_alloc_pd(struct padata_instance *pinst,

 	return pd;

+err_free_cpumask:
+	free_cpumask_var(pd->cpumask);
 err_free_queue:
 	free_percpu(pd->queue);
 err_free_pd:
-- 
1.7.1


On Fri, Jul 2, 2010 at 4:56 PM, Steffen Klassert
<steffen.klassert@secunet.com> wrote:
> On Fri, Jul 02, 2010 at 03:59:54PM +0400, Dan Kruchinin wrote:
>>  When boot CPU(typically CPU #0) is excluded from padata cpumask and
>>  user enters halt command from console, kernel faults on division by zero;
>>  This occurs because during the halt kernel shuts down each non-boot CPU one
>>  by one and after it shuts down the last CPU that is set in the padata cpumask,
>>  the only working CPU in the system is a boot CPU(#0) and it's the only CPU that
>>  is set in the cpu_active_mask. Hence when padata_cpu_callback calls
>>  __padata_remove_cpu(which calls padata_alloc_pd) it appears that
>> padata cpumask and
>>  cpu_active_mask aren't intersect. Hence the following code in
>> padata_alloc_pd causes
>>  a DZ error exception:
>>   cpumask_and(pd->cpumask, cpumask, cpu_active_mask); // pd->cpumask
>> will be empty
>>   ...
>>   num_cpus = cpumask_weight(pd->cpumask); // num_cpus = 0
>>   pd->max_seq_nr = (MAX_SEQ_NR / num_cpus) * num_cpus - 1; // DZ!
>>
>
> Good catch!
>
>>
>> Signed-off-by: Dan Kruchinin <dkruchinin@acm.org>
>> ---
>>  kernel/padata.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/padata.c b/kernel/padata.c
>> index fdd8ae6..dbe6d26 100644
>> --- a/kernel/padata.c
>> +++ b/kernel/padata.c
>> @@ -434,7 +434,7 @@ static struct parallel_data
>> *padata_alloc_pd(struct padata_instance *pinst,
>>               atomic_set(&queue->num_obj, 0);
>>       }
>>
>> -     num_cpus = cpumask_weight(pd->cpumask);
>> +     num_cpus = cpumask_weight(pd->cpumask) + 1;
>>       pd->max_seq_nr = (MAX_SEQ_NR / num_cpus) * num_cpus - 1;
>>
>
> num_cpus should stay the number of cpus in this cpumask, this is required
> to handle a smooth overrun of the sequence numbers.
> I think it's better to return with an error and to stop the instance
> if somebody takes away the last cpu in our cpumask. We can't run with an
> empty cpumask anyway.
>
> Let us look again at this on monday.
>
> Thanks again for catching this,
>
> Steffen
>



-- 
W.B.R.
Dan Kruchinin
