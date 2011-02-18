Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200Ab1BRJHQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 04:07:16 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:54241 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008Ab1BRJHH convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:7:1>);
	Fri, 18 Feb 2011 04:07:07 -0500
Message-Id: <4D5E44FB0200007800032A2F@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 18 Feb 2011 09:07:55 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Jesse Barnes" <jesse.barnes@intel.com>, "Yinghai Lu" <yinghai@kernel.org>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <arozansk@redhat.com>,
        <mchehab@redhat.com>, "Michal Marek" <mmarek@suse.cz>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [PATCH, resend] x86/PCI: don't export a __devinit function
References: <4D5D562A0200007800032744@vpn.id2.novell.com>
 <AANLkTik8B_evoOh_B9=2w=5nDAheZZiZLWyLGHavPy1c@mail.gmail.com>
In-Reply-To: <AANLkTik8B_evoOh_B9=2w=5nDAheZZiZLWyLGHavPy1c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 17.02.11 at 18:21, Yinghai Lu <yinghai@kernel.org> wrote:
> On Thu, Feb 17, 2011 at 8:08 AM, Jan Beulich <JBeulich@novell.com> wrote:
>> Exporting a __devinit function (pcibios_scan_specific_bus()) isn't
>> correct. (Michal, any reason why modpost only warns about exported
>> __init functions?) Short of being able to think of a better solution,
>> and short of making the whole call tree (reaching into the arch-
>> independent part of the PCI subsystem) non-__devinit, export the
>> symbol only when HOTPLUG is enabled (which is always the case for non-
>> expert configurations), use section mismatch avoidance annotations for
>> that case (knowing that __devinit functions will not be discarded),
>> and mark the symbol __devinit only in the !HOTPLUG case.
>>
>> Consequently, EDAC_I7CORE (consuming the export) then has to depend on
>> HOTPLUG. A fundamental question of course if whether this driver has
>> to use that function in the first place (i.e. whether it wouldn't be
>> better to just remove the export) - the problem it tries to address
>> happens on other systems too, but the PCI bus the devices in question
>> live on isn't necessarily bus 255. For the affected system I have, the
>> alternative approach is to set pcibios_last_bus from __pci_mmcfg_init()
>> based on the highest bus number on segment 0 being covered by MCFG.
>>
>> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Cc: Aristeu Sergio <arozansk@redhat.com>
>> Cc: Michal Marek <mmarek@suse.cz>
>>
>> ---
>>  arch/x86/pci/legacy.c |   21 ++++++++++++++++++---
>>  drivers/edac/Kconfig  |    2 +-
>>  2 files changed, 19 insertions(+), 4 deletions(-)
>>
>> --- 2.6.38-rc5/arch/x86/pci/legacy.c
>> +++ 2.6.38-rc5-x86-pci-section-conflict/arch/x86/pci/legacy.c
>> @@ -36,7 +36,23 @@ int __init pci_legacy_init(void)
>>        return 0;
>>  }
>>
>> -void __devinit pcibios_scan_specific_bus(int busn)
>> +#ifdef CONFIG_HOTPLUG
>> +static void __ref
>> +#else
>> +static inline void
>> +#endif
>> +_pci_scan_bus_on_node(int busno, int node)
>> +{
>> +       pci_scan_bus_on_node(busno, &pci_root_ops, node);
>> +}
>> +
>> +#ifdef CONFIG_HOTPLUG
>> +EXPORT_SYMBOL_GPL(pcibios_scan_specific_bus);
>> +void
>> +#else
>> +void __devinit
>> +#endif
> 
> anyway to avoid or reduce those #ifdef?

Yes, they look ugly, but no, I have no better idea (other than
creating single-use abstractions that wouldn't look any better).

Jan

