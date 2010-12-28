Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab0L1VYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 16:24:52 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52343 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab0L1VYv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 16:24:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JfTF/N/J/sVze2lnOK2+qUbrXFohrZ73gnMhu02SSl0UPrsB/MDwY2QWDJ2LId7NFj
         UklL8dDpuNuS2W3EHGIqic9dZmYbj7KXmp3IOWTqi/eQG18jKZabXY0w2MysK7K86MMR
         6ownojvZpDah/hZ03v8X0Bc67kGFFWcQA+btQ=
MIME-Version: 1.0
In-Reply-To: <20101228174204.GB13488@dumpdata.com>
References: <4CEB877D.9060709@kernel.org>
	<4CF75626.6000306@kernel.org>
	<alpine.LFD.2.00.1012021019060.2653@localhost6.localdomain6>
	<4CF7FA58.8070803@kernel.org>
	<alpine.LFD.2.00.1012022112400.2653@localhost6.localdomain6>
	<4CF7FF66.3010802@kernel.org>
	<alpine.LFD.2.00.1012022125401.2653@localhost6.localdomain6>
	<20101222125711.GI10809@elte.hu>
	<4D193533.6060103@kernel.org>
	<20101228174204.GB13488@dumpdata.com>
Date: Tue, 28 Dec 2010 13:24:50 -0800
X-Google-Sender-Auth: QI5Ctmyi6u-Udj_cg-Oda0UoD2c
Message-ID: <AANLkTing_OqRMAEpFX+OMciDLW8U2O_-DFFe+U_FFsOT@mail.gmail.com>
Subject: Re: [PATCH] x86, sparseirq: let nr_irqs equal to NR_IRQS
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 9:42 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Mon, Dec 27, 2010 at 04:54:11PM -0800, Yinghai Lu wrote:
>>
>>
>> For x86_64 system:
>> when we have 128 cpus with 5 ioapics, will have nr_irqs = 3064
>>       120 + 8 * 128 + 120 * 16
>> systems could take 20 pcie,  when intel 10g are used with
>> sriov and ixgbevf, every vf will need 3 irqs, and one device
>> have 64 vf. so will need 20 * 3 * 64 = 3840.
>> some 6 ports Intel 10gb may need more.
>>
>> Just remove that function for x86, and let nr_irqs to NR_IRQS
>> because We already have radix-tree and bit_map for searching desc for irq.
>
> Won't that make the arch_probe_nr_irqs be NR_IRQS_LEGACY?

int nr_irqs = NR_IRQS;

and

int __init __weak arch_probe_nr_irqs(void)
{
        return NR_IRQS_LEGACY;
}

int __init early_irq_init(void)
{
        int i, initcnt, node = first_online_node;
        struct irq_desc *desc;

        init_irq_default_affinity();

        /* Let arch update nr_irqs and return the nr of preallocated irqs */
        initcnt = arch_probe_nr_irqs();
        printk(KERN_INFO "NR_IRQS:%d nr_irqs:%d %d\n", NR_IRQS,
nr_irqs, initcnt);


that arch_probe_nr_irqs() is return for initcnt...

should change nr_irqs in the functions...

some confusing...


>
> I am looking at Linus's today tree, or is this patch based on some other tree?
>
>>
>> Notes: long before same vresion cause one of Ingo's setup udev hang...
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  arch/x86/kernel/apic/io_apic.c |   22 ----------------------
>>  1 file changed, 22 deletions(-)
>>
>> Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
>> +++ linux-2.6/arch/x86/kernel/apic/io_apic.c
>> @@ -3637,28 +3637,6 @@ int get_nr_irqs_gsi(void)
>>       return nr_irqs_gsi;
>>  }
>>
>> -#ifdef CONFIG_SPARSE_IRQ
>> -int __init arch_probe_nr_irqs(void)
>> -{
>> -     int nr;
>> -
>> -     if (nr_irqs > (NR_VECTORS * nr_cpu_ids))
>> -             nr_irqs = NR_VECTORS * nr_cpu_ids;
>> -
>> -     nr = nr_irqs_gsi + 8 * nr_cpu_ids;
>> -#if defined(CONFIG_PCI_MSI) || defined(CONFIG_HT_IRQ)
>> -     /*
>> -      * for MSI and HT dyn irq
>> -      */
>> -     nr += nr_irqs_gsi * 16;
>> -#endif
>> -     if (nr < nr_irqs)
>> -             nr_irqs = nr;
>> -
>> -     return NR_IRQS_LEGACY;
>> -}
>> -#endif
>> -
>>  static int __io_apic_set_pci_routing(struct device *dev, int irq,
>>                               struct io_apic_irq_attr *irq_attr)
>>  {
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
