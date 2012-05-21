Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab2EUNcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 09:32:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756371Ab2EUNcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 09:32:46 -0400
Message-ID: <4FBA43C9.1080509@redhat.com>
Date: Mon, 21 May 2012 09:31:53 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111104 Red Hat/3.1.16-2.el6_1 Thunderbird/3.1.16
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, kvm@vger.kernel.org,
        B07421@freescale.com, aik@ozlabs.ru, benh@kernel.crashing.org,
        linux-pci@vger.kernel.org, agraf@suse.de, qemu-devel@nongnu.org,
        chrisw@sous-sol.org, B08248@freescale.com,
        iommu@lists.linux-foundation.org, gregkh@linuxfoundation.org,
        avi@redhat.com, benve@cisco.com, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, david@gibson.dropbear.id.au
Subject: Re: [PATCH 05/13] pci: New pci_acs_enabled()
References: <20120511222148.30496.68571.stgit@bling.home>		 <20120511225602.30496.80438.stgit@bling.home>		 <CAErSpo58hKPFb5duOi64sWuR5AJDTVp0rRHkQLotYE3CMXRRhA@mail.gmail.com>		 <1337035766.6954.74.camel@bling.home>		 <CAErSpo48ES5iLDCh1WzmHezSEYhPjhtgD5uxoY-TCTKgUBab2g@mail.gmail.com>		 <1337116157.6954.212.camel@bling.home> <4FB3ABCF.4030708@redhat.com>	 <1337185318.6954.243.camel@bling.home> <4FB6D47C.4010003@redhat.com> <1337395622.28883.43.camel@bling.home>
In-Reply-To: <1337395622.28883.43.camel@bling.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2012 10:47 PM, Alex Williamson wrote:
> On Fri, 2012-05-18 at 19:00 -0400, Don Dutile wrote:
>> On 05/18/2012 06:02 PM, Alex Williamson wrote:
>>> On Wed, 2012-05-16 at 09:29 -0400, Don Dutile wrote:
>>>> On 05/15/2012 05:09 PM, Alex Williamson wrote:
>>>>> On Tue, 2012-05-15 at 13:56 -0600, Bjorn Helgaas wrote:
>>>>>> On Mon, May 14, 2012 at 4:49 PM, Alex Williamson
>>>>>> <alex.williamson@redhat.com>    wrote:
>>>>>>> On Mon, 2012-05-14 at 16:02 -0600, Bjorn Helgaas wrote:
>>>>>>>> On Fri, May 11, 2012 at 4:56 PM, Alex Williamson
>>>>>>>> <alex.williamson@redhat.com>    wrote:
>>>>>>>>> In a PCIe environment, transactions aren't always required to
>>>>>>>>> reach the root bus before being re-routed.  Peer-to-peer DMA
>>>>>>>>> may actually not be seen by the IOMMU in these cases.  For
>>>>>>>>> IOMMU groups, we want to provide IOMMU drivers a way to detect
>>>>>>>>> these restrictions.  Provided with a PCI device, pci_acs_enabled
>>>>>>>>> returns the furthest downstream device with a complete PCI ACS
>>>>>>>>> chain.  This information can then be used in grouping to create
>>>>>>>>> fully isolated groups.  ACS chain logic extracted from libvirt.
>>>>>>>>
>>>>>>>> The name "pci_acs_enabled()" sounds like it returns a boolean, but it doesn't.
>>>>>>>
>>>>>>> Right, maybe this should be:
>>>>>>>
>>>>>>> struct pci_dev *pci_find_upstream_acs(struct pci_dev *pdev);
>>>>>>>
>>>> +1; there is a global in the PCI code, pci_acs_enable,
>>>> and a function pci_enable_acs(), which the above name certainly
>>>> confuses.  I recommend  pci_find_top_acs_bridge()
>>>> would be most descriptive.
>> Finally, with my email filters fixed, I can see this email... :)
>
> Welcome back ;)
>
Indeed... and I recvd 3 copies of this reply,
so the pendulum has flipped the other direction... ;-)

>>> Yep, the new API I'm working with is:
>>>
>>> bool pci_acs_enabled(struct pci_dev *pdev, u16 acs_flags);
>>> bool pci_acs_path_enabled(struct pci_dev *start,
>>>                             struct pci_dev *end, u16 acs_flags);
>>>
>> ok.
>>
>>>>>>>> I'm not sure what "a complete PCI ACS chain" means.
>>>>>>>>
>>>>>>>> The function starts from "dev" and searches *upstream*, so I'm
>>>>>>>> guessing it returns the root of a subtree that must be contained in a
>>>>>>>> group.
>>>>>>>
>>>>>>> Any intermediate switch between an endpoint and the root bus can
>>>>>>> redirect a dma access without iommu translation,
>>>>>>
>>>>>> Is this "redirection" just the normal PCI bridge forwarding that
>>>>>> allows peer-to-peer transactions, i.e., the rule (from P2P bridge
>>>>>> spec, rev 1.2, sec 4.1) that the bridge apertures define address
>>>>>> ranges that are forwarded from primary to secondary interface, and the
>>>>>> inverse ranges are forwarded from secondary to primary?  For example,
>>>>>> here:
>>>>>>
>>>>>>                       ^
>>>>>>                       |
>>>>>>              +--------+-------+
>>>>>>              |                |
>>>>>>       +------+-----+    +-----++-----+
>>>>>>       | Downstream |    | Downstream |
>>>>>>       |    Port    |    |    Port    |
>>>>>>       |   06:05.0  |    |   06:06.0  |
>>>>>>       +------+-----+    +------+-----+
>>>>>>              |                 |
>>>>>>         +----v----+       +----v----+
>>>>>>         | Endpoint|       | Endpoint|
>>>>>>         | 07:00.0 |       | 08:00.0 |
>>>>>>         +---------+       +---------+
>>>>>>
>>>>>> that rule is all that's needed for a transaction from 07:00.0 to be
>>>>>> forwarded from upstream to the internal switch bus 06, then claimed by
>>>>>> 06:06.0 and forwarded downstream to 08:00.0.  This is plain old PCI,
>>>>>> nothing specific to PCIe.
>>>>>
>>>>> Right, I think the main PCI difference is the point-to-point nature of
>>>>> PCIe vs legacy PCI bus.  On a legacy PCI bus there's no way to prevent
>>>>> devices talking to each other, but on PCIe the transaction makes a
>>>>> U-turn at some point and heads out another downstream port.  ACS allows
>>>>> us to prevent that from happening.
>>>>>
>>>> detail: PCIe up/downstream routing is really done by an internal switch;
>>>>            ACS forces the legacy, PCI base-limit address routing and *forces*
>>>>            the switch to always route the transaction from a downstream port
>>>>            to the upstream port.
>>>>
>>>>>> I don't understand ACS very well, but it looks like it basically
>>>>>> provides ways to prevent that peer-to-peer forwarding, so transactions
>>>>>> would be sent upstream toward the root (and specifically, the IOMMU)
>>>>>> instead of being directly claimed by 06:06.0.
>>>>>
>>>>> Yep, that's my meager understanding as well.
>>>>>
>>>> +1
>>>>
>>>>>>> so we're looking for
>>>>>>> the furthest upstream device for which acs is enabled all the way up to
>>>>>>> the root bus.
>>>>>>
>>>>>> Correct me if this is wrong: To force device A's DMAs to be processed
>>>>>> by an IOMMU, ACS must be enabled on the root port and every downstream
>>>>>> port along the path to A.
>>>>>
>>>>> Yes, modulo this comment in libvirt source:
>>>>>
>>>>>        /* if we have no parent, and this is the root bus, ACS doesn't come
>>>>>         * into play since devices on the root bus can't P2P without going
>>>>>         * through the root IOMMU.
>>>>>         */
>>>>>
>>>> Correct. PCIe spec says roots must support ACS. I believe all the
>>>> root bridges that have an IOMMU have ACS wired in/on.
>>>
>>> Would you mind looking for the paragraph that says this?  I'd rather
>>> code this into the iommu driver callers than core PCI code if this is
>>> just a platform standard.
>>>
>> In section 6.12.1.1 of PCIe Base spec, rev 3.0, it states:
>> ACS upstream fwding: Must be implemented by Root Ports if the RC supports
>>                        Redirected Request Validation;
>
> Huh?  (If support ACS.RR then must support ACS.UF) != must support ACS.
>
UF?

>> -- which means, if a Root port allows a peer-to-peer transaction to another
>>      one of its ports, then it has to support ACS.
>
> I don't get that at all from 6.12.1.1, especially given the first
> sentence of that section:
>
>          This section applies to Root Ports and Downstream Switch Ports
>          that implement an ACS Extended Capability structure.
>
>
hmmm, well I did.  The root port section is different than Downstream ports
as well.  downstream ports *must* support peer-xfers due to positive decoding
of base/limit addresses, and ACS is optional in downstream ports.
Peer-to-peer btwn root ports is optional.
so, I don't get what you don't get... ;-)
.. but, I understand how the spec can be read/interpreted differently,
    given it's clarity (did lawyers write it?!?!!), so I could be interpreting
    incorrectly.

>> So, this means that:
>> (a) if a Root complex with multiple ports can't do peer-to-peer to another port,
>>       ACS isn't needed
>> (b) if a Root complex w/multiple ports can do peer-to-peer to another port,
>>       it must have ACS capability if it does...
>> and since the linux code turns on ACS for all ports with an ACS cap,
>> it degenerates (in Linux) that all Root ports are implementing the
>> end functionality of ACS==on, all traffic goes up to IOMMU in RC.
>>
I thought I explained how I interpreted the root-port part of ACS above,
so maybe you can tell me how you think my interpretation is incorrect.

>>>>> So we assume that a redirect at the point of the iommu will factor in
>>>>> iommu translation.
>>>>>
>>>>>> If so, I think you're trying to find out the closest upstream device X
>>>>>> such that everything leading to X has ACS enabled.  Every device below
>>>>>> X can DMA freely to other devices below X, so they would all have to
>>>>>> be in the same isolated group.
>>>>>
>>>>> Yes
>>>>>
>>>>>> I tried to work through some examples to develop some intuition about this:
>>>>>
>>>>> (inserting fixed url)
>>>>>> http://www.asciiflow.com/#3736558963405980039
>>>>>
>>>>>> pci_acs_enabled(00:00.0) = 00:00.0 (on root bus (but doesn't it matter
>>>>>> if 00:00.0 is PCIe or if RP has ACS?))
>>>>>
>>>>> Hmm, the latter is the assumption above.  For the former, I think
>>>>> libvirt was probably assuming that PCI devices must have a PCIe device
>>>>> upstream from them because x86 doesn't have assignment friendly IOMMUs
>>>>> except on PCIe.  I'll need to work on making that more generic.
>>>>>
>>>>>> pci_acs_enabled(00:01.0) = 00:01.0 (on root bus)
>>>>>> pci_acs_enabled(01:00.0) = 01:00.0 (acs_dev = 00:01.0, 01:00.0 is not
>>>>>> PCIe; seems wrong)
>>>>>
>>>>> Oops, I'm calling pci_find_upstream_pcie_bridge() first on any of my
>>>>> input devices, so this was passing for me.  I'll need to incorporate
>>>>> that generically.
>>>>>
>>>>>> pci_acs_enabled(00:02.0) = 00:02.0 (on root bus; seems wrong if RP
>>>>>> doesn't have ACS)
>>>>>
>>>>> Yeah, let me validate the libvirt assumption.  I see ACS on my root
>>>>> port, so maybe they're just assuming it's always enabled or that the
>>>>> precedence favors IOMMU translation.  I'm also starting to think that we
>>>>> might want "from" and "to" struct pci_dev parameters to make it more
>>>>> flexible where the iommu lives in the system.
>>>>>
>>>> see comment above wrt root ports that have IOMMUs in them.
>>>
>>> Except it really seems to be platform convention where the IOMMU lives.
>>> The DMAR for VT-d describes which devices and hierarchies a DRHD is used
>>> for and from that we can make assumptions about where it physically
>>> lives.  AMD-Vi exposes a PCI device as the IOMMU, but it's just a peer
>>> function on the root bus.  For now I'm just allowing
>>> pci_acs_path_enabled to take NULL for and end, which means "up to the
>>> root bus".
>>>
>> ATM, VT-d IOMMUs are only in the RCs, so, ACS at each downstream port
>> in a tree would/should return 'true' to the acs_enabled check when it gets to a Root port.
>> For AMD-Vi, I thought the same held true, ATM, but I have to dig through
>> yet-another spec (or ask Joerg to check-in to this thread&  provide the details).
>
> But are we programming to convention or spec?  And I'm still confused
> about why we assume the root port isn't susceptible to redirection
> before IOMMU translation.  One of the benefits of the
> pci_acs_path_enable() API is that it pushes convention out to the IOMMU
> driver.  So it's intel-iommu.c's problem whether to test for ACS support
> to the RC or to a given level (and for that matter know whether IOMMU
> translation takes precedence over redirection in the RC).
>
Agreed. the best design here would be for the intel-iommu.c to test for ACS
wrt the root port (not to be confused with root complex) since Intel-IOMMUs
are not 'attached' to a PCI bus.  Now, AMD's IOMMUs are attached to a PCI bus,
so maybe it can be simplified in that case.... but it may be best to mimic
the iommu-set-acs-for-root-port attribute the same manner.

>>>>
>>>>>> pci_acs_enabled(02:00.0) = 00:02.0 (acs_dev = 00:02.0, 02:00.0 has no ACS cap)
>>>>>> pci_acs_enabled(03:00.0) = 00:02.0 (acs_dev = 00:02.0)
>>>>>> pci_acs_enabled(02:01.0) = 02:01.0 (acs_dev = 00:02.0, 02:01.0 has ACS enabled)
>>>>>> pci_acs_enabled(04:00.0) = 04:00.0 (acs_dev = 02:01.0, 04:00.0 is not
>>>>>> a bridge; seems wrong if 04:00 is a multi-function device)
>>>>>
>>>>> AIUI, ACS is not an endpoint property, so this is what should happen.  I
>>>>> don't think multifunction plays a role other than how much do we trust
>>>>> the implementation to not allow back channels between functions (the
>>>>> answer should probably be not at all).
>>>>>
>>>> correct. ACS is a *bridge* property.
>>>> The unknown wrt multifunction devices is that such devices *could* be implemented
>>>> by a hidden (not responding to PCI cfg accesses from downstream port) PCI bridge
>>>> btwn the functions within a device.
>>>> Such a bridge could allow peer-to-peer xactions and there is no way for OS's to
>>>> force ACS.  So, one has to ask the hw vendors if such a hidden device exists
>>>> in the implementation, and whether peer-to-peer is enabled/allowed -- a hidden PCI
>>>> bridge/PCIe-switch could just be hardwired to push all IO to upstream port,
>>>> and allow parent bridge re-route it back down if peer-to-peer is desired.
>>>> Debate exists whether multifunction devices are 'secure' b/c of this unknown.
>>>> Maybe a PCIe (min., SRIOV) spec change is needed in this area to
>>>> determine this status about a device (via pci cfg/cap space).
>>>
>>> Well, there is actually a section of the ACS part of the spec
>>> identifying valid flags for multifunction devices.  Secretly I'd like to
>>> use this as justification for blacklisting all multifunction devices
>>> that don't explicitly support ACS, but that makes for pretty course
>>> granularity.  For instance, all these devices end up in a group:
>>>
>>>      +-14.0  ATI Technologies Inc SBx00 SMBus Controller
>>>      +-14.2  ATI Technologies Inc SBx00 Azalia (Intel HDA)
>>>      +-14.3  ATI Technologies Inc SB7x0/SB8x0/SB9x0 LPC host controller
>>>      +-14.4-[05]----0e.0  VIA Technologies, Inc. VT6306/7/8 [Fire II(M)] IEEE 1394 OHCI Controller
>>>
>>>     00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge (rev 40)
>>>
>>> And these in another:
>>>
>>>      +-15.0-[06]----00.0  Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller
>>>      +-15.1-[07]----00.0  Etron Technology, Inc. EJ168 USB 3.0 Host Controller
>>>      +-15.2-[08]--
>>>      +-15.3-[09]--
>>>
>>>     00:15.0 PCI bridge: ATI Technologies Inc SB700/SB800/SB900 PCI to PCI bridge (PCIE port 0)
>>>     00:15.1 PCI bridge: ATI Technologies Inc SB700/SB800/SB900 PCI to PCI bridge (PCIE port 1)
>>>     00:15.2 PCI bridge: ATI Technologies Inc SB900 PCI to PCI bridge (PCIE port 2)
>>>     00:15.3 PCI bridge: ATI Technologies Inc SB900 PCI to PCI bridge (PCIE port 3)
>>>
>>> Am I misinterpreting the spec or is this the correct, if strict,
>>> interpretation?
>>>
>>> Alex
>>>
>> Well, in digging into the ACS-support in Root port question above,
>> I just found out about this ACS support status for multifunctions too.
>> I need more time to read/digest, but a quick read says MFDs should have
>> an ACS cap with relevant RO-status&  control bits to direct/control
>> peer-to-peer and ACS-upstream.  Lack of an ACS struct implies(?)
>> peer-to-peer can happen, and thus, the above have to be in the same iommu group.
>> Unfortunately, I think a large lot of MFDs don't have ACS caps,
>> and don't/can't do peer-to-peer, so the above is heavy-handed,
>> albeit to spec.
>> Maybe we need a (large?) pci-quirk for the list of existing
>> MFDs that don't have ACS caps that would enable the above devices
>> to be in separate groups.
>> On the flip side, it solves some of the quirks for MFDs that
>> use the wrong BDF in their src-id dma packets! :) -- they default
>> to the same group now...
>
> Yep, sounds like you might agree with my patch, it's heavy handed, but
Yes, but we should design-in a quirk check list for MFDs,
b/c we already know some will fail when they should pass this check,
b/c the hw was made post ACS, or the vendors didn't see the benefit
of ACS reporting (even if the funcitonality was enabling bit-settings
that did nothing hw-wise), b/c they didn't understand the use case (VFIO,
dev-assignment to virt guests, etc.).

> seems to adhere to the spec.  That probably just means we need an option
> to allow a more lenient interpretation, that maybe we don't have to
> support.  Thanks,
Right.  As I said, a hook to do quirk-level additions from the get-go
would speed this expected need/addition.

>
> Alex
>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

