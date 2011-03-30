Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780Ab1C3TZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 15:25:50 -0400
Received: from relay3.sgi.com ([192.48.152.1]:37273 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754536Ab1C3TZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 15:25:49 -0400
Message-ID: <4D9383B7.40807@sgi.com>
Date: Wed, 30 Mar 2011 12:25:43 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        iommu@lists.linux-foundation.org, Mike Habeck <habeck@sgi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Intel pci: Remove Host Bridge devices from identity
 mapping
References: <20110329233602.272459647@gulag1.americas.sgi.com> <20110329233602.439245439@gulag1.americas.sgi.com> <20110330175137.GQ18712@sequoia.sous-sol.org> <4D9376DE.1060207@sgi.com> <20110330191511.GS18712@sequoia.sous-sol.org>
In-Reply-To: <20110330191511.GS18712@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Chris Wright wrote:
> * Mike Travis (travis@sgi.com) wrote:
>> Chris Wright wrote:
>>> * Mike Travis (travis@sgi.com) wrote:
>>>>    When the IOMMU is being used, each request for a DMA mapping requires
>>>>    the intel_iommu code to look for some space in the DMA mapping table.
>>>>    For most drivers this occurs for each transfer.
>>>>
>>>>    When there are many outstanding DMA mappings [as seems to be the case
>>>>    with the 10GigE driver], the table grows large and the search for
>>>>    space becomes increasingly time consuming.  Performance for the
>>>>    10GigE driver drops to about 10% of it's capacity on a UV system
>>>>    when the CPU count is large.
>>> That's pretty poor.  I've seen large overheads, but when that big it was
>>> also related to issues in the 10G driver.  Do you have profile data
>>> showing this as the hotspot?
>> Here's one from our internal bug report:
>>
>> Here is a profile from a run with iommu=on  iommu=pt  (no forcedac)
> 
> OK, I was actually interested in the !pt case.  But this is useful
> still.  The iova lookup being distinct from the identity_mapping() case.

I can get that as well, but having every device using maps caused it's
own set of problems (hundreds of dma maps).  Here's a list of devices
on the system under test.  You can see that even 'minor' glitches can
get magnified when there are so many...

Blade Location    NASID  PCI Address X Display   Device
----------------------------------------------------------------------
    0 r001i01b00      0  0000:01:00.0      -   Intel 82576 Gigabit Network Connection
    .          .      .  0000:01:00.1      -   Intel 82576 Gigabit Network Connection
    .          .      .  0000:04:00.0      -   LSI SAS1064ET Fusion-MPT SAS
    .          .      .  0000:05:00.0      -   Matrox MGA G200e
    2 r001i01b02      4  0001:02:00.0      -   Mellanox MT26428 InfiniBand
    3 r001i01b03      6  0002:02:00.0      -   Mellanox MT26428 InfiniBand
    4 r001i01b04      8  0003:02:00.0      -   Mellanox MT26428 InfiniBand
   11 r001i01b11     22  0007:02:00.0      -   Mellanox MT26428 InfiniBand
   13 r001i01b13     26  0008:02:00.0      -   Mellanox MT26428 InfiniBand
   15 r001i01b15     30  0009:07:00.0   :0.0   nVidia GF100 [Tesla S2050]
    .          .      .  0009:08:00.0   :1.1   nVidia GF100 [Tesla S2050]
   18 r001i23b02     36  000b:02:00.0      -   Mellanox MT26428 InfiniBand
   20 r001i23b04     40  000c:01:00.0      -   Intel 82599EB 10-Gigabit Network Connection
    .          .      .  000c:01:00.1      -   Intel 82599EB 10-Gigabit Network Connection
    .          .      .  000c:04:00.0      -   Mellanox MT26428 InfiniBand
   23 r001i23b07     46  000d:07:00.0      -   nVidia GF100 [Tesla S2050]
    .          .      .  000d:08:00.0      -   nVidia GF100 [Tesla S2050]
   25 r001i23b09     50  000e:01:00.0      -   Intel 82599EB 10-Gigabit Network Connection
    .          .      .  000e:01:00.1      -   Intel 82599EB 10-Gigabit Network Connection
    .          .      .  000e:04:00.0      -   Mellanox MT26428 InfiniBand
   26 r001i23b10     52  000f:02:00.0      -   Mellanox MT26428 InfiniBand
   27 r001i23b11     54  0010:02:00.0      -   Mellanox MT26428 InfiniBand
   29 r001i23b13     58  0011:02:00.0      -   Mellanox MT26428 InfiniBand
   31 r001i23b15     62  0012:02:00.0      -   Mellanox MT26428 InfiniBand
   34 r002i01b02     68  0013:01:00.0      -   Mellanox MT26428 InfiniBand
   35 r002i01b03     70  0014:02:00.0      -   Mellanox MT26428 InfiniBand
   36 r002i01b04     72  0015:01:00.0      -   Mellanox MT26428 InfiniBand
   41 r002i01b09     82  0018:07:00.0      -   nVidia GF100 [Tesla S2050]
    .          .      .  0018:08:00.0      -   nVidia GF100 [Tesla S2050]
   43 r002i01b11     86  0019:01:00.0      -   Mellanox MT26428 InfiniBand
   45 r002i01b13     90  001a:01:00.0      -   Mellanox MT26428 InfiniBand
   48 r002i23b00     96  001c:07:00.0      -   nVidia GF100 [Tesla S2050]
    .          .      .  001c:08:00.0      -   nVidia GF100 [Tesla S2050]
   50 r002i23b02    100  001d:02:00.0      -   Mellanox MT26428 InfiniBand
   52 r002i23b04    104  001e:01:00.0      -   Intel 82599EB 10-Gigabit Network Connection
    .          .      .  001e:01:00.1      -   Intel 82599EB 10-Gigabit Network Connection
    .          .      .  001e:04:00.0      -   Mellanox MT26428 InfiniBand
   57 r002i23b09    114  0020:01:00.0      -   Intel 82599EB 10-Gigabit Network Connection
    .          .      .  0020:01:00.1      -   Intel 82599EB 10-Gigabit Network Connection
    .          .      .  0020:04:00.0      -   Mellanox MT26428 InfiniBand
   58 r002i23b10    116  0021:02:00.0      -   Mellanox MT26428 InfiniBand
   59 r002i23b11    118  0022:02:00.0      -   Mellanox MT26428 InfiniBand
   61 r002i23b13    122  0023:02:00.0      -   Mellanox MT26428 InfiniBand
   63 r002i23b15    126  0024:02:00.0      -   Mellanox MT26428 InfiniBand

> 
>> uv48-sys was receiving and uv-debug sending.
>> ksoftirqd/640 was running at approx. 100% cpu utilization.
>> I had pinned the nttcp process on uv48-sys to cpu 64.
>>
>> # Samples: 1255641
>> #
>> # Overhead        Command  Shared Object  Symbol
>> # ........  .............  .............  ......
>> #
>>    50.27%ESC[m  ksoftirqd/640  [kernel]       [k] _spin_lock
>>    27.43%ESC[m  ksoftirqd/640  [kernel]       [k] iommu_no_mapping
> 
>> ...
>>      0.48%  ksoftirqd/640  [kernel]       [k] iommu_should_identity_map
>>      0.45%  ksoftirqd/640  [kernel]       [k] ixgbe_alloc_rx_buffers    [
>> ixgbe]
> 
> Note, ixgbe has had rx dma mapping issues (that's why I wondered what
> was causing the massive slowdown under !pt mode).

I think since this profile run, the network guys updated the ixgbe
driver with a later version.  (I don't know the outcome of that test.)

> 
> <snip>
>> I tracked this time down to identity_mapping() in this loop:
>>
>>       list_for_each_entry(info, &si_domain->devices, link)
>>               if (info->dev == pdev)
>>                       return 1;
>>
>> I didn't get the exact count, but there was approx 11,000 PCI devices
>> on this system.  And this function was called for every page request
>> in each DMA request.
> 
> Right, so this is the list traversal (and wow, a lot of PCI devices).

Most of the PCI devices were the 45 on each of 256 Nahalem sockets.
Also, there's a ton of bridges as well.

> Did you try a smarter data structure? (While there's room for another
> bit in pci_dev, the bit is more about iommu implementation details than
> anything at the pci level).
> 
> Or the domain_dev_info is cached in the archdata of device struct.
> You should be able to just reference that directly.
> 
> Didn't think it through completely, but perhaps something as simple as:
> 
> 	return pdev->dev.archdata.iommu == si_domain;

I can try this, thanks!

> 
> thanks,
> -chris
