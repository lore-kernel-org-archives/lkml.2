Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653Ab2CZOdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 10:33:41 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47871 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473Ab2CZOdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 10:33:40 -0400
Message-ID: <4F707E39.50502@gmail.com>
Date: Mon, 26 Mar 2012 22:33:29 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Yevgeny Petrilin <yevgenyp@mellanox.co.il>, linux-pci@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: IRQ affinity enforced only after first interrupt.
References: <4F7031A4.70601@mellanox.co.il> <CAErSpo7ciBYG1-jCL3F6bFcktmJj4H-SXn_1NcRnhc-gPDsHUw@mail.gmail.com>
In-Reply-To: <CAErSpo7ciBYG1-jCL3F6bFcktmJj4H-SXn_1NcRnhc-gPDsHUw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The architecture specific code will determine whether the IRQ could be migrated
in process context. For example, the IRQ_MOVE_PCNTXT flag will be set on x86
systems if interrupt remapping is enabled.

On 03/26/2012 10:28 PM, Bjorn Helgaas wrote:
> [This is not really a PCI question, so +cc Thomas, LKML.]
> 
> On Mon, Mar 26, 2012 at 3:06 AM, Yevgeny Petrilin
> <yevgenyp@mellanox.co.il> wrote:
>> Hello,
>>
>> I'm working on an issue where affinity changes to IRQ only have effect after the first interrupt which still happens on the original core.
>> I understand that the decision regarding it takes place in this code:
>>
>>        if (irq_can_move_pcntxt(data)) {
>>                ret = chip->irq_set_affinity(data, mask, false);
>>                switch (ret) {
>>                case IRQ_SET_MASK_OK:
>>                        cpumask_copy(data->affinity, mask);
>>                case IRQ_SET_MASK_OK_NOCOPY:
>>                        irq_set_thread_affinity(desc);
>>                        ret = 0;
>>                }
>>        } else {
>>                irqd_set_move_pending(data);
>>                irq_copy_pending(desc, mask);
>>        }
>>
>> Which means that the "IRQD_MOVE_PCNTXT" flag is not set in irq_data->state_use_accessors.
>> I was able to add this flag using irq_modify_status(), which is probably not the way to go.
>> This option also doesn't exist in older kernels (2.6.32)
>>
>> So the question is, when irq_desc is created, how is it determined that "IRQD_MOVE_PCNTXT" flag is set?
>>
>> Thanks,
>> Yevgeny
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

