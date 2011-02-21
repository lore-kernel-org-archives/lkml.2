Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab1BUR7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 12:59:40 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:20805 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab1BUR7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 12:59:38 -0500
Message-ID: <4D62A799.4090507@kernel.org>
Date: Mon, 21 Feb 2011 09:57:45 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: tglx@linutronix.de, linux-kernel@vger.kernel.org, mingo@redhat.com,
        hpa@zytor.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/core] genirq: Make nr_irqs runtime expandable
References: <tip-e7bcecb7b1d29b9ad5af939149a945658620ca8f@git.kernel.org> <4D6014F9.8040605@kernel.org> <4D628B38.7040105@metafoo.de>
In-Reply-To: <4D628B38.7040105@metafoo.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D62A7FE.01B1,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2011 07:56 AM, Lars-Peter Clausen wrote:
> On 02/19/2011 08:07 PM, Yinghai Lu wrote:
...

>> [PATCH] genirq: use IRQ_BITMAP_BITS as search size
>>
>> instead of nr_irqs.
>>
>> Otherwise bitmap_find_next_area could exit with larger start and in extreme
>> case we could fail to get wrong irqs return.
>>
>> For example:
>> IRQ_BITMAP_BITS=10240
>> nr_irqs=8192
>> cnt=2048
>>
>> and bit 0 to bit 8190 are set already.
>>
>> before patch start from bit_find_next_area() will be 8191+2048.
>> later irq_expand_nr_irqs will set nr_irqs 10240.
>> finally irq_alloc_descs will return [8191+2048, 8191+2048+2047] happily..
>>
>> with this patch, will get correct [8191, 8191+2047]
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  kernel/irq/irqdesc.c |    5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> Index: linux-2.6/kernel/irq/irqdesc.c
>> ===================================================================
>> --- linux-2.6.orig/kernel/irq/irqdesc.c
>> +++ linux-2.6/kernel/irq/irqdesc.c
>> @@ -346,12 +346,13 @@ irq_alloc_descs(int irq, unsigned int fr
>>  
>>  	mutex_lock(&sparse_irq_lock);
>>  
>> -	start = bitmap_find_next_zero_area(allocated_irqs, nr_irqs, from, cnt, 0);
>> +	start = bitmap_find_next_zero_area(allocated_irqs, IRQ_BITMAP_BITS,
>> +						 from, cnt, 0);
>>  	ret = -EEXIST;
>>  	if (irq >=0 && start != irq)
>>  		goto err;
>>  
>> -	if (start >= nr_irqs) {
>> +	if (start + cnt > nr_irqs) {
>>  		ret = irq_expand_nr_irqs(cnt);
> Just a minor thing, but if there are still unused irqs available at the end of
> the current range, you'll end up expanding the range more then you need to.
> So either do
> 	irq_expand_nr_irqs(nr_irqs - start + cnt);
> or change irq_expand_nr_irqs to let it take the new total number of irqs.

yes. please check second way that you suggested.

[PATCH -v2] genirq: use IRQ_BITMAP_BITS as search size

Otherwise bitmap_find_next_area could exit with larger start and in extreme
case we could fail to get wrong irqs return.

For example:
IRQ_BITMAP_BITS=10240
nr_irqs=8192
cnt=2048

and bit 0 to bit 8190 are set already.

before patch start from bit_find_next_area() will be 8191+2048.
later irq_expand_nr_irqs will set nr_irqs 10240.
finally irq_alloc_descs will return [8191+2048, 8191+2048+2047] happily..

with this patch, will get correct [8191, 8191+2047]

-v2: let irq_expand_nr_irqs take new nr_irqs instead of cnt, so do not
	increase nr_irqs too much extra.
	Suggested by "Lars-Peter" Clausen <lars@metafoo.de>

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 kernel/irq/irqdesc.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

Index: linux-2.6/kernel/irq/irqdesc.c
===================================================================
--- linux-2.6.orig/kernel/irq/irqdesc.c
+++ linux-2.6/kernel/irq/irqdesc.c
@@ -207,11 +207,11 @@ struct irq_desc * __ref irq_to_desc_allo
 	return NULL;
 }
 
-static int irq_expand_nr_irqs(unsigned int cnt)
+static int irq_expand_nr_irqs(int new_nr_irqs)
 {
-	if (nr_irqs + cnt > IRQ_BITMAP_BITS)
+	if (new_nr_irqs > IRQ_BITMAP_BITS)
 		return -ENOMEM;
-	nr_irqs += cnt;
+	nr_irqs = new_nr_irqs;
 	return 0;
 }
 
@@ -298,7 +298,7 @@ static inline int alloc_descs(unsigned i
 	return start;
 }
 
-static int irq_expand_nr_irqs(unsigned int cnt)
+static int irq_expand_nr_irqs(int new_nr_irqs)
 {
 	return -ENOMEM;
 }
@@ -346,13 +346,14 @@ irq_alloc_descs(int irq, unsigned int fr
 
 	mutex_lock(&sparse_irq_lock);
 
-	start = bitmap_find_next_zero_area(allocated_irqs, nr_irqs, from, cnt, 0);
+	start = bitmap_find_next_zero_area(allocated_irqs, IRQ_BITMAP_BITS,
+						 from, cnt, 0);
 	ret = -EEXIST;
 	if (irq >=0 && start != irq)
 		goto err;
 
-	if (start >= nr_irqs) {
-		ret = irq_expand_nr_irqs(cnt);
+	if (start + cnt > nr_irqs) {
+		ret = irq_expand_nr_irqs(start + cnt);
 		if (ret)
 			goto err;
 	}


> 
> Btw., with this patch in place does it make sense to initialize nr_irqs to
> anything else then initcnt in early_irq_init?

i have one for x86 and it will set nr_irqs to nr_irqs_gsi

[PATCH] x86, irq: keep nr_irqs as low as possible

For sparseirq, We can expand nr_irqs later if needed, so could
keep it from small for beginning.

Assign it to  minium value of vectors of all cpus and gsi pins


Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/io_apic.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -3642,16 +3642,11 @@ int __init arch_probe_nr_irqs(void)
 {
 	int nr;
 
-	if (nr_irqs > (NR_VECTORS * nr_cpu_ids))
-		nr_irqs = NR_VECTORS * nr_cpu_ids;
+	nr = NR_VECTORS * nr_cpu_ids;
+	if (nr < nr_irqs)
+		nr_irqs = nr;
 
-	nr = nr_irqs_gsi + 8 * nr_cpu_ids;
-#if defined(CONFIG_PCI_MSI) || defined(CONFIG_HT_IRQ)
-	/*
-	 * for MSI and HT dyn irq
-	 */
-	nr += nr_irqs_gsi * 16;
-#endif
+	nr = nr_irqs_gsi;
 	if (nr < nr_irqs)
 		nr_irqs = nr;
 

