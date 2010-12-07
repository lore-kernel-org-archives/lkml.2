Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab0LGTBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 14:01:09 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:22971 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab0LGTBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 14:01:07 -0500
Message-ID: <4CFE8045.2030101@kernel.org>
Date: Tue, 07 Dec 2010 10:43:17 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Feng Tang <feng.tang@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/platform] x86: Unify current 3 similar ways of saving
 IRQ info
References: <1291349518-3502-1-git-send-email-feng.tang@intel.com> <tip-a6427a341985e0379060c86b50fcdb59883e4102@git.kernel.org> <4CFD226C.60308@kernel.org> <20101207133204.4d913c5a@feng-i7> <alpine.LFD.2.00.1012071654080.2653@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1012071654080.2653@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2010 07:56 AM, Thomas Gleixner wrote:
> On Tue, 7 Dec 2010, Feng Tang wrote:
>> On Tue, 7 Dec 2010 01:50:36 +0800
>> Yinghai Lu <yinghai@kernel.org> wrote:
>>  
>> +static void assign_to_mp_irq(struct mpc_intsrc *m,
>> +				    struct mpc_intsrc *mp_irq)
>> +{
>> +	mp_irq->dstapic = m->dstapic;
>> +	mp_irq->type = m->type;
>> +	mp_irq->irqtype = m->irqtype;
>> +	mp_irq->irqflag = m->irqflag;
>> +	mp_irq->srcbus = m->srcbus;
>> +	mp_irq->srcbusirq = m->srcbusirq;
>> +	mp_irq->dstirq = m->dstirq;
> 
>   Can we please use the mrst version with memcpy ?
> 
>> +}
>> +
>> +static int mp_irq_mpc_intsrc_cmp(struct mpc_intsrc *mp_irq,
>> +					struct mpc_intsrc *m)
>> +{
>> +	if (mp_irq->dstapic != m->dstapic)
>> +		return 1;
>> +	if (mp_irq->type != m->type)
>> +		return 2;
>> +	if (mp_irq->irqtype != m->irqtype)
>> +		return 3;
>> +	if (mp_irq->irqflag != m->irqflag)
>> +		return 4;
>> +	if (mp_irq->srcbus != m->srcbus)
>> +		return 5;
>> +	if (mp_irq->srcbusirq != m->srcbusirq)
>> +		return 6;
>> +	if (mp_irq->dstirq != m->dstirq)
>> +		return 7;
>> +
>> +	return 0;
> 
>   Same here. No caller is interested in the detailed return value.
> 

ok, after look at code and git log,  i knew the reasons for those strange duplicated functions.

Alexy changed

 /* MP IRQ source entries */
-struct mpc_config_intsrc mp_irqs[MAX_IRQ_SOURCES];
+struct mp_config_intsrc mp_irqs[MAX_IRQ_SOURCES];

to make it decouple that with mpstable definition. so mptable will have mpc_intsrc, and acpi etc will use mp_config_intsrc

and he planed to add more member to mp_config_intsrc .... never happened.

then I added those functions with different parameters.

one year later JSR changed all back to mpc_instr...

so now have some duplicated functions....

even in mpparse.c we now have

static void print_MP_intsrc_info(struct mpc_intsrc *m)
{
        apic_printk(APIC_VERBOSE, "Int: type %d, pol %d, trig %d, bus %02x,"
                " IRQ %02x, APIC ID %x, APIC INT %02x\n",
                m->irqtype, m->irqflag & 3, (m->irqflag >> 2) & 3, m->srcbus,
                m->srcbusirq, m->dstapic, m->dstirq);
}

static void __init print_mp_irq_info(struct mpc_intsrc *mp_irq)
{
        apic_printk(APIC_VERBOSE, "Int: type %d, pol %d, trig %d, bus %02x,"
                " IRQ %02x, APIC ID %x, APIC INT %02x\n",
                mp_irq->irqtype, mp_irq->irqflag & 3,
                (mp_irq->irqflag >> 2) & 3, mp_irq->srcbus,
                mp_irq->srcbusirq, mp_irq->dstapic, mp_irq->dstirq);
}

...

So yes, we should use simple versions in arch/x86/kernel/acpi/boot.c. ( assume functions mrst.c are copied from there)

and should kill print_mp_irq_info or print_MP_intsrc_info...

Thanks

	Yinghai
