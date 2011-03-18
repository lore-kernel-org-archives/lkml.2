Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab1CROxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 10:53:37 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:48732 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab1CROxc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 10:53:32 -0400
From: "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
CC: "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Date: Fri, 18 Mar 2011 14:52:29 +0000
Subject: RE: [RFC][PATCH v2]: PCI: PCIe links may not get configured for
 ASPM under POWERSAVE mode
Thread-Topic: [RFC][PATCH v2]: PCI: PCIe links may not get configured for
 ASPM under POWERSAVE mode
Thread-Index: AcvlNYK6zKgGHzEOQkKb5df0am5oxAARa8DQ
Message-ID: <66D9D2F0CDB5C9428E6166B01EC85EE162ED1DE852@GVW0676EXC.americas.hpqcorp.net>
References: <20110318041801.2349.33357.sendpatchset@nchumbalkar.americas.hpqcorp.net>
 <4D82EDAC.8070307@jp.fujitsu.com>
In-Reply-To: <4D82EDAC.8070307@jp.fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>-----Original Message-----
>From: Kenji Kaneshige [mailto:kaneshige.kenji@jp.fujitsu.com]
>Sent: Friday, March 18, 2011 12:29 AM
>To: Chumbalkar, Nagananda
>Cc: jbarnes@virtuousgeek.org; rjw@sisk.pl; mjg59@srcf.ucam.org; linux-
>kernel@vger.kernel.org; linux-pci@vger.kernel.org
>Subject: Re: [RFC][PATCH v2]: PCI: PCIe links may not get configured for
>ASPM under POWERSAVE mode
>
>(2011/03/18 13:21), Naga Chumbalkar wrote:
>> v2 ->  v1:
>> 	. Kept the logic in pci_raw_set_power_state
>> 	. Changed the ASPM enabling logic
>> 	. Modified the text that describes the problem
>>
>> v1	: http://marc.info/?l=linux-pci&m=130013164703283&w=2
>>
>> The assumption made in commit 41cd766b065970ff6f6c89dd1cf55fa706c84a3d
>> (PCI: Don't enable aspm before drivers have had a chance to veto it)
>that
>> pci_enable_device() will result in re-configuring ASPM when
>aspm_policy is
>> POWERSAVE is no longer valid.  This is due to commit
>> 97c145f7c87453cec90e91238fba5fe2c1561b32 (PCI: read current power
>state
>> at enable time) which resets dev->current_state to D0. This makes the
>> equality check (below) become true, so pcie_aspm_pm_state_change()
>never
>> gets called.
>> ./drivers/pci/pci.c: pci_raw_set_pci_power_state()
>> 546         /* Check if we're already there */
>> 547         if (dev->current_state == state)
>> 548                 return 0;
>>
>> So OSPM doesnn't configure the PCIe links for ASPM.
>>
>> The patch below does the following:
>> At the end of each Root Bridge scan make a call to configure ASPM when
>the
>> ASPM policy is set to "powersave" mode. Note that if a previous pass
>had
>> completed the configuration for all devices under that Bridge then the
>> configuration will not take place again because
>pcie_config_aspm_link()
>> checks to see if the link is already in the requested state.
>> We won't reconfigure ASPM when _OSC control is not granted.
>
>Which _OSC controls do we need for configuring ASPM?

There is no _OSC Control bit for ASPM. However, we expect the BIOS to 
support _OSC for a Root Bridge that originates a PCIe hierarchy. If this
is not the case - would it be okay to disable ASPM also?

Commit 852972acff8f10f3a15679be2059bb94916cba5d (ACPI: Disable ASPM if the 
Platform won't provide _OSC control for PCIe) describes the above scenario.

To quote from there: 
The PCI SIG documentation for the _OSC OS/firmware handshaking interface
states:

"If the _OSC control method is absent from the scope of a host bridge
device, then the operating system must not enable or attempt to use any
features defined in this section for the hierarchy originated by the host
bridge."

The obvious interpretation of this is that the OS should not attempt to use
PCIe hotplug, PME or AER - however, the specification also notes that an
_OSC method is *required* for PCIe hierarchies, and experimental validation
with An Alternative OS indicates that it doesn't use any PCIe functionality
if the _OSC method is missing. That arguably means we shouldn't be using
MSI or extended config space, but right now our problems seem to be limited
to vendors being surprised when ASPM gets enabled on machines when other
OSs refuse to do so. So, for now, let's just disable ASPM if the _OSC
method doesn't exist or refuses to hand over PCIe capability control.

- naga -


