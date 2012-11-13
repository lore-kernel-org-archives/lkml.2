Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab2KMLDP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 06:03:15 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45044 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab2KMLDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 06:03:12 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50A2279F.60003@jp.fujitsu.com>
Date: Tue, 13 Nov 2012 19:57:35 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: amurray@embedded-bits.co.uk
CC: linux-pci@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        tokunaga.keiich@jp.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, andi@firstfloor.org, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, hpa@zytor.com, bhelgaas@google.com,
        tglx@linutronix.de, yinghai@kernel.org, mingo@redhat.com,
        vgoyal@redhat.com, khalid@gonehiking.org
Subject: Re: [PATCH v6 1/5] x86, pci: add dummy pci device for early stage
References: <20121113090212.1180.12233.sendpatchset@indoh> <20121113090222.1180.36111.sendpatchset@indoh> <CAPcvp5FCDt5Sy9W7s4gsWuq7z9dATvk37hS_5XfrYepNiJN=nA@mail.gmail.com>
In-Reply-To: <CAPcvp5FCDt5Sy9W7s4gsWuq7z9dATvk37hS_5XfrYepNiJN=nA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/13 19:01), Andrew Murray wrote:
> Hello,
>
> Some comments inline...
>
> On 13 November 2012 09:07, Takao Indoh <indou.takao@jp.fujitsu.com> wrote:
>> From: Yinghai Lu <yinghai@kernel.org>
>>
>> So we can pass pci_dev *dev to reuse some generic pci functions.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
>> ---
>>   arch/x86/include/asm/pci-direct.h |    2 +
>>   arch/x86/pci/early.c              |   75 +++++++++++++++++++++++++++++++++++++
>>   2 files changed, 77 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/pci-direct.h b/arch/x86/include/asm/pci-direct.h
>> index b1e7a45..b6360d3 100644
>> --- a/arch/x86/include/asm/pci-direct.h
>> +++ b/arch/x86/include/asm/pci-direct.h
>> @@ -18,4 +18,6 @@ extern int early_pci_allowed(void);
>>   extern unsigned int pci_early_dump_regs;
>>   extern void early_dump_pci_device(u8 bus, u8 slot, u8 func);
>>   extern void early_dump_pci_devices(void);
>> +
>> +struct pci_dev *get_early_pci_dev(int num, int slot, int func);
>>   #endif /* _ASM_X86_PCI_DIRECT_H */
>> diff --git a/arch/x86/pci/early.c b/arch/x86/pci/early.c
>> index d1067d5..aea6b2b 100644
>> --- a/arch/x86/pci/early.c
>> +++ b/arch/x86/pci/early.c
>> @@ -109,3 +109,78 @@ void early_dump_pci_devices(void)
>>                  }
>>          }
>>   }
>> +
>> +static __init int
>> +early_pci_read(struct pci_bus *bus, unsigned int devfn, int where,
>> +                       int size, u32 *value)
>> +{
>> +       int num, slot, func;
>> +
>> +       num = bus->number;
>> +       slot = devfn >> 3;
>> +       func = devfn & 7;
>
> You may want to use the PCI_SLOT and PCI_FUNC macros in
> include/linux/pci.h to determine values for slot and func.
>
>> +       switch (size) {
>> +       case 1:
>> +               *value = read_pci_config_byte(num, slot, func, where);
>> +               break;
>> +       case 2:
>> +               *value = read_pci_config_16(num, slot, func, where);
>> +               break;
>> +       case 4:
>> +               *value = read_pci_config(num, slot, func, where);
>> +               break;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static __init int
>> +early_pci_write(struct pci_bus *bus, unsigned int devfn, int where,
>> +                       int size, u32 value)
>> +{
>> +       int num, slot, func;
>> +
>> +       num = bus->number;
>> +       slot = devfn >> 3;
>> +       func = devfn & 7;
>
> As above.
>
>> +       switch (size) {
>> +       case 1:
>> +               write_pci_config_byte(num, slot, func, where, (u8)value);
>> +               break;
>> +       case 2:
>> +               write_pci_config_16(num, slot, func, where, (u16)value);
>> +               break;
>> +       case 4:
>> +               write_pci_config(num, slot, func, where, (u32)value);
>> +               break;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static __initdata struct pci_ops pci_early_ops = {
>> +       .read  = early_pci_read,
>> +       .write = early_pci_write,
>> +};
>> +static __initdata struct pci_bus pci_early_bus = {
>> +       .ops = &pci_early_ops,
>> +};
>> +static __initdata char pci_early_init_name[8];
>> +static __initdata struct pci_dev pci_early_dev = {
>> +       .bus = &pci_early_bus,
>> +       .dev = {
>> +               .init_name = pci_early_init_name,
>> +       },
>> +};
>> +
>> +__init struct pci_dev *get_early_pci_dev(int num, int slot, int func)
>> +{
>> +       struct pci_dev *pdev;
>> +
>> +       pdev = &pci_early_dev;
>> +       pdev->devfn = (slot<<3) | (func & 7);
>
> You can use PCI_DEVFN here.

Yeah, I forgot to use these macros. I'll fix them, thanks!

Thanks,
Takao Indoh

>
>> +       pdev->bus->number = num;
>> +       sprintf((char *)pdev->dev.init_name, "%02x:%02x.%01x", num, slot, func);
>> +
>> +       return pdev;
>> +}
>> --
>> 1.7.1
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Andrew Murray
>
>

