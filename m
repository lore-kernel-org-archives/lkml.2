Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab0JKCXO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 22:23:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:34082 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab0JKCXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 22:23:13 -0400
Message-ID: <4CB27483.1000109@kernel.org>
Date: Sun, 10 Oct 2010 19:20:51 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 00/47] Sparse irq rework
References: <20100930221351.682772535@linutronix.de> <20101003112312.GB9844@angua.secretlab.ca> <20101003112920.GB32736@n2100.arm.linux.org.uk> <AANLkTingVuhgdaLZ8U3bM+F2vZJ_kScwKqNtHW=g6DcH@mail.gmail.com> <alpine.LFD.2.00.1010031544340.14550@localhost6.localdomain6> <alpine.LFD.2.00.1010051219580.2556@localhost6.localdomain6> <4CACFC23.4080504@kernel.org> <alpine.LFD.2.00.1010070050410.17015@localhost6.localdomain6> <4CAD082B.40908@kernel.org> <4CAD1154.3080403@kernel.org> <alpine.LFD.2.00.1010070559480.17015@localhost6.localdomain6> <4CAD4EC3.5060809@kernel.org> <alpine.LFD.2.00.1010082346310.13094@localhost6.localdomain6> <alpine.LFD.2.00.1010082351450.13094@localhost6.localdomain6> <4CAFEEFA.1070000@kernel.org> <4CB00122.3030301@kernel.org> <alpine.LFD.2.00.1010090829150.13094@localhost6.localdomain6> <4CB014F5.5080209@kernel.org> <alpine.LFD.2.00.1010101130160.2413@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1010101130160.2413@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2010 02:32 AM, Thomas Gleixner wrote:
> On Sat, 9 Oct 2010, Yinghai Lu wrote:
>> On 10/08/2010 11:34 PM, Thomas Gleixner wrote:
>>> On Fri, 8 Oct 2010, Yinghai Lu wrote:
>>>> +	/* only handle fall out from setup_IO_APIC_irqs() */
>>>
>>> What's the fallout ? And why are we coming here in the first place
>>> when the irq is < 16 ?
>>
>> setup_IO_APIC_irqs only handle apic_id == 0 or apic_id > 0 but irq < 16 via acpi override.
>>
>> it seems IBM's system have apic_id == 1, and sci irq is using 30.
>>
>> so at that time add that setup_IO_APIC_irq_extra() to workaround it.
>> but it seems we set that two time when irq < 16.
>>
>>>
>>>> +	if (!((apic_id > 0) && (irq > 16)))
>>>> +		return;
> 
> I added this into the queue, but simplified it to 
> 
>   if (apic_id == 0 || irq < NR_IRQS_LEGACY)
> 
> Folded in the other fix and pushed out an updated tree.
> 

ok. please check another small fix.

diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index b3805f3..2fb9df4 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -130,10 +130,11 @@ static struct irq_desc *alloc_desc(int irq, int node)
 	desc = kzalloc_node(sizeof(*desc), gfp, node);
 	if (!desc)
 		return NULL;
+
 	/* allocate based on nr_cpu_ids */
 	desc->kstat_irqs = kzalloc_node(nr_cpu_ids * sizeof(*desc->kstat_irqs),
 					 gfp, node);
-	if (!desc)
+	if (!desc->kstat_irqs)
 		goto err_desc;
 
 	if (alloc_masks(desc, gfp, node))
@@ -226,6 +227,7 @@ struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 static unsigned int kstat_irqs_all[NR_IRQS][NR_CPUS];
 int __init early_irq_init(void)
 {
+	int node = first_online_node;
 	struct irq_desc *desc;
 	int count;
 	int i;
@@ -241,8 +243,8 @@ int __init early_irq_init(void)
 		desc[i].irq_data.irq = i;
 		desc[i].irq_data.chip = &no_irq_chip;
 		desc[i].kstat_irqs = kstat_irqs_all[i];
-		alloc_masks(desc + i, GFP_KERNEL, first_online_node);
-		desc_smp_init(desc + i, first_online_node);
+		alloc_masks(desc + i, GFP_KERNEL, node);
+		desc_smp_init(desc + i, node);
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
 	}
 	return arch_early_irq_init();
