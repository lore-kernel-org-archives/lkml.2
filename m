Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759039Ab2K3SCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:02:41 -0500
Received: from cpanel23.proisp.no ([88.87.44.74]:54395 "EHLO
	cpanel23.proisp.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757281Ab2K3SCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:02:39 -0500
X-Greylist: delayed 1285 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Nov 2012 13:02:38 EST
Message-ID: <50B8EFBF.2050403@numascale.com>
Date: Fri, 30 Nov 2012 18:41:19 +0100
From: Steffen Persvold <sp@numascale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Daniel J Blueman <daniel@numascale-asia.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 RESEND] Add NumaChip remote PCI support
References: <1353487196-10204-1-git-send-email-daniel@numascale-asia.com> <CAErSpo67Brp8H=Jw77NzA4xL52aRNi+YDw+gM++3y8XqfTWyzA@mail.gmail.com> <50B84418.5070804@numascale-asia.com> <CAErSpo5veyd4NhayHkoB1bLJhU7pkHBhTDNyk-1vWupEcv6K3A@mail.gmail.com>
In-Reply-To: <CAErSpo5veyd4NhayHkoB1bLJhU7pkHBhTDNyk-1vWupEcv6K3A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel23.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel23.proisp.no: authenticated_id: sp+numascale.com/only user confirmed/virtual account not confirmed
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

On 11/30/2012 17:45, Bjorn Helgaas wrote:
> On Thu, Nov 29, 2012 at 10:28 PM, Daniel J Blueman
[]
>> We could expose pci_dev_base via struct x86_init_pci; the extra complexity
>> and performance tradeoff may not be worth it for a single case perhaps?
>
> Oh, right, I forgot that you can't decide this at build-time.  This is
> PCI config access, which is not a performance path, so I'm not really
> concerned about it from that angle, but you make a good point about
> the complexity.
>
> The reason I'm interested in this is because MMCONFIG is a generic
> PCIe feature but is currently done via several arch-specific
> implementations, so I'm starting to think about how we can make parts
> of it more generic.  From that perspective, it's nicer to parameterize
> an existing implementation than to clone it because it makes
> refactoring opportunities more obvious.
>
> Backing up a bit, I'm curious about exactly why you need to check for
> the limit to begin with.  The comment says "Ensure AMD Northbridges
> don't decode reads to other devices," but that doesn't seem strictly
> accurate.  You're not changing anything in the hardware to prevent it
> from *decoding* a read, so it seems like you're actually just
> preventing the read in the first place.
>
> What happens without the limit check?  Do you get a response timeout
> and a machine check?  Read from the wrong device?'

The latter. I'm not sure how familiar you are with how pci config reads 
are decoded and handled on coherent hypertransport fabrics; The way it 
works *within* one coherent HT fabric is that the CPU will redirect all 
config space access above a configured max HT node (a setting in the AMD 
northbridge) to a specific I/O link (non-coherent link) which usually 
links up with a "southbridge" device that responds with a target abort 
(non-existing device).

However, this only works when a CPU core is accessing local HT devices. 
In our architecture, we "glue" together multiple HT fabrics and when a 
CPU core sends a pci config space request (mmconfig) to a remote machine 
(via our hardware) this re-direction is not applied anymore. The result 
is that when a mmconfig read comes in to a coherent HT device on bus00 
which is non-existent, one of the other HT nodes on that remote node 
will respond to the read, leading to "phantom" devices (i.e lspci will 
show more HT northbridges than what's really physically present) *or* 
worst case scenario will be that the transaction hangs (alternatively 
times out, leading to MCE and other bad things).

This is why we're checking accesses to bus0, device24-31 and returning a 
"fake" target abort scenario if the access was to a non-existing HT 
device. In other words, we're doing in software what a "normal" HT based 
platform would do in hardware.

>
> As far as I can tell, you still describe your MMCONFIG area with an
> MCFG table (since you use pci_mmconfig_lookup() to find the region).
> That table only includes the starting and ending bus numbers, so the
> assumption is that the MMCONFIG space is valid for every possible
> device on those buses.  So it seems like your system is not really
> compatible with the spec here.
>
> Because the MCFG table can't describe finer granularity than start/end
> bus numbers, we manage MMCONFIG regions as (segment, start_bus,
> end_bus, address) tuples.  Maybe if we tracked it with slightly finer
> granularity, e.g., (segment, start_bus, end_bus, end_bus_device,
> address), you could have some sort of MCFG-parsing quirk that reduces
> the size of the MMCONFIG region you register for bus 0.
>
> Just brainstorming here; it's not obvious to me yet what the best solution is.
>
> Bjorn
>

Kind regards,
-- 
Steffen Persvold, Chief Architect NumaChip
Numascale AS - www.numascale.com
Tel: +47 92 49 25 54 Skype: spersvold
