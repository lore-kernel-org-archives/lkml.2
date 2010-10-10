Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750899Ab0JJFM4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 01:12:56 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20613 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab0JJFMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 01:12:54 -0400
Message-ID: <4CB14B03.4000707@kernel.org>
Date: Sat, 09 Oct 2010 22:11:31 -0700
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
References: <20100930221351.682772535@linutronix.de> <20101003112312.GB9844@angua.secretlab.ca> <20101003112920.GB32736@n2100.arm.linux.org.uk> <AANLkTingVuhgdaLZ8U3bM+F2vZJ_kScwKqNtHW=g6DcH@mail.gmail.com> <alpine.LFD.2.00.1010031544340.14550@localhost6.localdomain6> <alpine.LFD.2.00.1010051219580.2556@localhost6.localdomain6> <4CACFC23.4080504@kernel.org> <alpine.LFD.2.00.1010070050410.17015@localhost6.localdomain6> <4CAD082B.40908@kernel.org> <4CAD1154.3080403@kernel.org> <alpine.LFD.2.00.1010070559480.17015@localhost6.localdomain6> <4CAD4EC3.5060809@kernel.org> <alpine.LFD.2.00.1010082346310.13094@localhost6.localdomain6> <alpine.LFD.2.00.1010082351450.13094@localhost6.localdomain6> <4CAFEEFA.1070000@kernel.org> <alpine.LFD.2.00.1010090758420.13094@localhost6.localdomain6> <4CB013CB.1040904@kernel.org> <alpine.LFD.2.00.1010091409450.2640@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1010091409450.2640@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2010 05:12 AM, Thomas Gleixner wrote:
> On Sat, 9 Oct 2010, Yinghai Lu wrote:
>> On 10/08/2010 11:10 PM, Thomas Gleixner wrote:
>>>> [   59.449366] IP: [<ffffffff8147d715>] acpi_pci_irq_find_prt_entry+0x85/0xb1
>>>
>>> I can hardly see how this is related to the irq work.
>>>
>>>> [   71.076886] Pid: 1, comm: swapper Tainted: G        W   2.6.36-rc7-tip-yh-01944-ge8a4c5f-dirty #171      /Sun Fire x4800
>>>> [   71.096947] RIP: 0010:[<ffffffff8141e232>]  [<ffffffff8141e232>] strcmp+0x4/0x21
>>>
>>> Ditto.
>>
>> don't know.
>>
>> but without merging your branch, those problems don't come out.
>>
>> only thing i can think about that you real free irq code could
>> stress or expose other subsystem's bug etc.
> 
> The first crash is in early boot and that code just fiddles with acpi
> internal stuff.
> 

Need following patch. Please fold it into corresponding commit.

Yinghai

[PATCH] sparseirq: Fix kstat_irqs allocation

Should allocate array according to cpu num.

Also remove extra desc_smp_init() calling, because it is called in
desc_set_defaults() already

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 kernel/irq/irqdesc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/irq/irqdesc.c
===================================================================
--- linux-2.6.orig/kernel/irq/irqdesc.c
+++ linux-2.6/kernel/irq/irqdesc.c
@@ -130,7 +130,9 @@ static struct irq_desc *alloc_desc(int i
 	desc = kzalloc_node(sizeof(*desc), gfp, node);
 	if (!desc)
 		return NULL;
-	desc->kstat_irqs = kzalloc_node(sizeof(*desc->kstat_irqs), gfp, node);
+	/* allocate based on nr_cpu_ids */
+	desc->kstat_irqs = kzalloc_node(nr_cpu_ids * sizeof(*desc->kstat_irqs),
+					 gfp, node);
 	if (!desc)
 		goto err_desc;
 
@@ -142,7 +144,6 @@ static struct irq_desc *alloc_desc(int i
 
 	desc_set_defaults(irq, desc, node);
 
-	desc_smp_init(desc, node);
 	return desc;
 
 err_kstat:
