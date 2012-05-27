Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab2E0Bll (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:41:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53721 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129Ab2E0Blg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:41:36 -0400
Message-ID: <4FC18646.8010301@gmail.com>
Date: Sun, 27 May 2012 09:41:26 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
        Dimitri Sivanich <sivanich@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: check for valid irq_cfg pointer in smp_irq_move_cleanup_interrupt
References: <20120521164959.GE16454@sgi.com>   <alpine.LFD.2.02.1205212304580.3231@ionos>  <20120521211917.GA25567@sgi.com>   <alpine.LFD.2.02.1205212324260.3231@ionos> <20120523181636.GA2032@sgi.com>   <20120523190414.GA5263@sgi.com>   <1337801086.1997.197.camel@sbsiddha-desk.sc.intel.com>   <20120523200226.GA6936@sgi.com>   <1337816970.1997.207.camel@sbsiddha-desk.sc.intel.com>   <20120524143711.GA24711@sgi.com>  <1337883560.7938.9.camel@sbsiddha-desk.sc.intel.com>  <alpine.LFD.2.02.1205242113400.3231@ionos> <1337991809.7938.36.camel@sbsiddha-desk.sc.intel.com> <alpine.LFD.2.02.1205261216160.3231@ionos>
In-Reply-To: <alpine.LFD.2.02.1205261216160.3231@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have realized the same issue with typical usages of for_each_irq_desc(), 
which may access freed memory with SPARSE_IRQ. My naive solution was to
avoid freeing irq_desc even SPARSE_IRQ_ is enabled.

        for_each_irq_desc(i, desc) {
                raw_spin_lock_irq(&desc->lock);

On 05/26/2012 06:18 PM, Thomas Gleixner wrote:
> On Fri, 25 May 2012, Suresh Siddha wrote:
>> On Thu, 2012-05-24 at 21:16 +0200, Thomas Gleixner wrote:
>> There are other (not-so common) irq desc references, like in the
>> show_interrupts() (cat /proc/interrupts path) etc, that does things like
>> this in the process context:
>>
>>         desc = irq_to_desc(i);
>>         if (!desc)
>>                 return 0;
>>
>>         raw_spin_lock_irqsave(&desc->lock, flags);
>>
>> May be we should introduce something like
>> get_irq_desc_locked()/put_irq_desc_locked() that can safely access the
>> irq desc with pre-emption/irq's disabled and lock it etc. And the
>> synchronize_sched() will enable the destroy_irq()/free_desc() to free it
>> safely etc.
> 
> I want to avoid that and instead use proper refcounting. The reason is
> that we want to move the irq descriptor when the affinity changes
> nodes, and for that we need refcounting anyway.
> 
> Thanks,
> 
> 	tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

