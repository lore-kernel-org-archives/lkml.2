Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab1HAPuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 11:50:10 -0400
Received: from exprod5og107.obsmtp.com ([64.18.0.184]:55532 "EHLO
	exprod5og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab1HAPuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 11:50:08 -0400
Message-ID: <4E36CB29.2030907@ge.com>
Date: Mon, 01 Aug 2011 16:50:01 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: gregkh@suse.de, cota@braap.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] staging: vme: allow explicit assignment of bus numbers
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch> <1312194053-32310-3-git-send-email-manohar.vanga@cern.ch> <4E36A4EA.30404@ge.com> <20110801143102.GA9705@becoht-mvanga>
In-Reply-To: <20110801143102.GA9705@becoht-mvanga>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Aug 2011 15:46:57.0289 (UTC) FILETIME=[3E860790:01CC5062]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/11 15:31, Manohar Vanga wrote:
> Hi Martyn,
> 
>> I assume this is in a system where there are more than one type of bridge
>> (i.e. a ca91c042 and tsi148).
> 
> Yes. This is referring to multiple bridges on a single PCI bus (in the case of
> the existing bridges). In practice we have only a single bridge of a single
> type. We can however have multiple types of bridges (eg. 1 TSI148 and 1 Universe).
> This solution is specifically for such situations.
> 
>> I'm not sure that passing a list of bus numbers to each driver is the correct
>> way to resolve this. This issue also exists for hard drives and ethernet
>> devices as well.
> 
> This solution won't help the cases where multiple bridges of the same type are
> present (as we cannot control probe order) however in the case of multiple
> bridges of differing types, it helps in deterministically assigning numbers to
> the bridge.
> 
> The array was created simply for the reason that the code allows for multiple
> bridges of the same kind. In practice we have only one of a specific kind.
> 
>> The network subsystem either has or uses a mechanism to allow udev rules to
>> rename the devices (this seems to be done by MAC address on my system).
>>
>> I believe drive ordering is resolved to some extent with UUIDs. Persistent
>> device naming can be provided by using udev rules to create symlinks (such as
>> "/dev/cdrom" etc), with the drives are determined by system topology.
>>
>> I'm wondering whether re-ordering the bus numbering based on system topology
>> using udev rules (where persistent bus numbering is required), or bind based
>> on system topology and not need persistent numbering at all).
> 
> The problem here is that it is kernel space that requires a consistent
> numbering so creating symlinks is not a useful solution for this. (unless the
> driver loader script queries each device for its UUID at startup which seems
> a little like a roundabout way).
> 

No I'm thinking more along the lines of how the persistent device names seem
to be created. For example, on my system udev is used to create a symlink
called "/dev/cdrom" using this udev rule:

SUBSYSTEM=="block", ENV{ID_CDROM}=="?*",
ENV{ID_PATH}=="pci-0000:00:1f.2-scsi-1:0:0:0", SYMLINK+="cdrom",
ENV{GENERATED}="1"

The bit that might be more useful to us is the ENV{ID_PATH}, the
"pci-0000:00:1f.2" bit in particular. If I'm not mistaken, this is sufficient
to identify a PCI device (such as a VME bridge)


> The VME drivers require a list of bus numbers that it passes to the VME
> driver so it knows which buses/bridges to probe on. We need to pass this to
> the drivers during load time. Are you recommending we change this to UUID's?
> 

I'm thinking of the topology that is used in the above example to uniquely
identify a specific SATA device.

We could either provide the above paths, or rename buses similar to how
network interfaces are renamed (hence why I mentioned them as well). Of course
renaming the buses has the disadvantage that the correct names will only be in
place once the board has got to user space, so the drivers would have to be
built as modules.

> Also, if we replace a card entirely (eg. in the case of a malfunction), the
> UUID changes and we need to update a lot of local files to maintain the
> automated startup (Please correct me if I'm wrong here). This would become a
> mess to maintain really quickly.
> 

I assume that you replace like with like, so the bridges are found in the same
order (if you have more than one of the same bridge). In this case the
topology will be the same, so you should reliably be able to replace cards.

> In this patch, we don't solve the issue of multiple bridges of the same kind
> but we solve the automation issue in cases of different types of bridge.

As long as you only have one type of each...

I'm wondering whether an approach as above may reliably solve both.

Martyn

> We already maintain a database with configuration options for each crate
> and a bus number can be easily added. This won't change in the case of card
> replacement.
> 
> --
> /manohar


-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)127322748                          | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
