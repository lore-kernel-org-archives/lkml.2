Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab1BRJL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 04:11:27 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:49870 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757707Ab1BRJLV convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Fri, 18 Feb 2011 04:11:21 -0500
Message-Id: <4D5E45FB0200007800032A45@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 18 Feb 2011 09:12:11 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Mauro Carvalho Chehab" <mchehab@redhat.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <arozansk@redhat.com>,
        "Michal Marek" <mmarek@suse.cz>, <linux-kernel@vger.kernel.org>,
        "Jesse Barnes" <jbarnes@virtuousgeek.org>, <hpa@zytor.com>
Subject: Re: [PATCH, resend] x86/PCI: don't export a __devinit function
References: <4D5D562A0200007800032744@vpn.id2.novell.com>
 <4D5D6517.5060600@redhat.com>
In-Reply-To: <4D5D6517.5060600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 17.02.11 at 19:12, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> Em 17-02-2011 14:08, Jan Beulich escreveu:
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
>> HOTPLUG. 
> 
> Having the entire i7core_edac driver depending on HOTPLUG, just because
> a few BIOSes want to hide the non-core PCI devices doesn't seem nice.
> One alternative would be to enclose the code that needs this function
> with #ifdef CONFIG_HOTPLUG.

Yes, I can certainly do it that way, unless the below could serve to
make the export unnecessary altogether.

>> A fundamental question of course if whether this driver has
>> to use that function in the first place (i.e. whether it wouldn't be
>> better to just remove the export) - the problem it tries to address
>> happens on other systems too, but the PCI bus the devices in question
>> live on isn't necessarily bus 255. For the affected system I have, the
>> alternative approach is to set pcibios_last_bus from __pci_mmcfg_init()
>> based on the highest bus number on segment 0 being covered by MCFG.
> 
> I received a few days ago a report that some BIOSes that hide those
> PCI devices also use a different address for the last bus (0x3f, instead
> of 0xff). So, it seems that the better would be to use an alternative
> way to retrieve the last bus.

Like this:

--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -606,6 +606,16 @@ static void __init __pci_mmcfg_init(int 
 	if (list_empty(&pci_mmcfg_list))
 		return;
 
+	if (pcibios_last_bus < 0) {
+		const struct pci_mmcfg_region *cfg;
+
+		list_for_each_entry(cfg, &pci_mmcfg_list, list) {
+			if (cfg->segment)
+				break;
+			pcibios_last_bus = cfg->end_bus;
+		}
+	}
+
 	if (pci_mmcfg_arch_init())
 		pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
 	else {

I (unsuccessfully so far) tried to find someone at Intel who could
confirm that this approach is usable namely on those Xeon 55xx
systems that the edac driver tries to deal with, which is why I
didn't submit this so far.

Jan

