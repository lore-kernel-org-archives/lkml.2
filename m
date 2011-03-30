Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab1C3Sa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 14:30:59 -0400
Received: from relay3.sgi.com ([192.48.152.1]:44168 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754628Ab1C3Sa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 14:30:57 -0400
Message-ID: <4D9376DE.1060207@sgi.com>
Date: Wed, 30 Mar 2011 11:30:54 -0700
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
References: <20110329233602.272459647@gulag1.americas.sgi.com> <20110329233602.439245439@gulag1.americas.sgi.com> <20110330175137.GQ18712@sequoia.sous-sol.org>
In-Reply-To: <20110330175137.GQ18712@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Chris Wright wrote:
> * Mike Travis (travis@sgi.com) wrote:
>>     When the IOMMU is being used, each request for a DMA mapping requires
>>     the intel_iommu code to look for some space in the DMA mapping table.
>>     For most drivers this occurs for each transfer.
>>
>>     When there are many outstanding DMA mappings [as seems to be the case
>>     with the 10GigE driver], the table grows large and the search for
>>     space becomes increasingly time consuming.  Performance for the
>>     10GigE driver drops to about 10% of it's capacity on a UV system
>>     when the CPU count is large.
> 
> That's pretty poor.  I've seen large overheads, but when that big it was
> also related to issues in the 10G driver.  Do you have profile data
> showing this as the hotspot?

Here's one from our internal bug report:

Here is a profile from a run with iommu=on  iommu=pt  (no forcedac)

uv48-sys was receiving and uv-debug sending.
ksoftirqd/640 was running at approx. 100% cpu utilization.
I had pinned the nttcp process on uv48-sys to cpu 64.

# Samples: 1255641
#
# Overhead        Command  Shared Object  Symbol
# ........  .............  .............  ......
#
    50.27%ESC[m  ksoftirqd/640  [kernel]       [k] _spin_lock
    27.43%ESC[m  ksoftirqd/640  [kernel]       [k] iommu_no_mapping
...
      0.48%  ksoftirqd/640  [kernel]       [k] iommu_should_identity_map
      0.45%  ksoftirqd/640  [kernel]       [k] ixgbe_alloc_rx_buffers    [
ixgbe]
      0.42%  ksoftirqd/640  [kernel]       [k] ioat2_tx_submit_unlock    [
ioatdma]
      0.29%  ksoftirqd/640  [kernel]       [k] uv_read_rtc
      0.25%  ksoftirqd/640  [kernel]       [k] __alloc_skb
      0.20%  ksoftirqd/640  [kernel]       [k] try_to_wake_up
      0.19%  ksoftirqd/640  [kernel]       [k] ____cache_alloc_node
      0.19%  ksoftirqd/640  [kernel]       [k] kmem_cache_free
      0.19%  ksoftirqd/640  [kernel]       [k] __netdev_alloc_skb
      0.18%  ksoftirqd/640  [kernel]       [k] tcp_v4_rcv
      0.15%  ksoftirqd/640  [kernel]       [k] resched_task
      0.15%  ksoftirqd/640  [kernel]       [k] tcp_data_queue
      0.13%  ksoftirqd/640  [kernel]       [k] xfrm4_policy_check
      0.11%  ksoftirqd/640  [kernel]       [k] get_page_from_freelist
      0.10%  ksoftirqd/640  [kernel]       [k] sched_clock_cpu
      0.10%  ksoftirqd/640  [kernel]       [k] sock_def_readable
...

I tracked this time down to identity_mapping() in this loop:

       list_for_each_entry(info, &si_domain->devices, link)
               if (info->dev == pdev)
                       return 1;

I didn't get the exact count, but there was approx 11,000 PCI devices
on this system.  And this function was called for every page request
in each DMA request.

Here's an excerpt from our internal bug report:

I also looked at the cpu utilization uv. Its at 22% for the nttcp process
and ksoftirqd is not at the top so I think this means the fix is working.

Another run
uv-debug:~/eddiem/nttcp-1.52 # ./nttcp -T -l 1048576 -P 60 192.168.1.2
Running for 60 seconds...
     Bytes  Real s   CPU s Real-MBit/s  CPU-MBit/s   Calls  Real-C/s   CPU-C/s
l51671728128   60.00   13.52   6889.4548  30582.1259   49278    821.29    3645.7
151671728128   60.00   12.53   6889.4660  32983.4024  123666   2061.07    9867.4

Trying it from the other side shows nttcp on uv at 44% cpu.

uv41-sys:~/eddiem/nttcp-1.52 # ./nttcp -T -l 1048576 -P 60 192.168.1.1
Running for 60 seconds...
     Bytes  Real s   CPU s Real-MBit/s  CPU-MBit/s   Calls  Real-C/s   CPU-C/s
l51292143616   60.00   26.40   6838.9326  15544.4581   48917    815.28    1853.1
151292456796   60.00    7.35   6839.0407  55809.8528   93530   1558.84   12720.9


Note that our networking experts also tuned the 10GigE parameters which
helped bring the speed back up to almost line speed.  (The 10GigE was
by far the most affected driver, but even the 1GigE driver lost performance.)

There was also changes for the irq_rebalancer and disabling sched domains
2 and 3 (which was being hit by idle_rebalancer).  I remember sched domain 3
had all 4096 cpus but I forgot what sd 2 had.)

Also, running the network test on the same node as where the cards were
helped as well.

If you really need them, I can sign up for some system time and get better
before/after profile data specifically for these IOMMU changes?

Thanks,
Mike

> 
>>     The workaround is to specify the iommu=pt option which sets up a 1:1
>>     identity map for those devices that support enough DMA address bits to
>>     cover the physical system memory.  This is the "pass through" option.
>>
>>     But this can only be accomplished by those devices that pass their
>>     DMA data through the IOMMU (VTd).  But Host Bridge Devices connected
>>     to System Sockets do not pass their data through the VTd, thus the
>>     following error occurs:
>>
>>     IOMMU: hardware identity mapping for device 1000:3e:00.0
>>     Failed to setup IOMMU pass-through
>>     BUG: unable to handle kernel NULL pointer dereference at 000000000000001c
>>
>>     This patch fixes that problem but removing Host Bridge devices from
>>     being identity mapped, given that they do not generate DMA ops anyways.
>>
>> Signed-off-by: Mike Travis <travis@sgi.com>
>> Reviewed-by: Mike Habeck <habeck@sgi.com>
>> ---
>>  drivers/pci/intel-iommu.c |    6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> --- linux.orig/drivers/pci/intel-iommu.c
>> +++ linux/drivers/pci/intel-iommu.c
>> @@ -46,6 +46,7 @@
>>  #define ROOT_SIZE		VTD_PAGE_SIZE
>>  #define CONTEXT_SIZE		VTD_PAGE_SIZE
>>  
>> +#define IS_HOSTBRIDGE_DEVICE(pdev) ((pdev->class >> 8) == PCI_CLASS_BRIDGE_HOST)
>>  #define IS_GFX_DEVICE(pdev) ((pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY)
>>  #define IS_ISA_DEVICE(pdev) ((pdev->class >> 8) == PCI_CLASS_BRIDGE_ISA)
>>  #define IS_AZALIA(pdev) ((pdev)->vendor == 0x8086 && (pdev)->device == 0x3a3e)
>> @@ -2183,7 +2184,7 @@ static int iommu_should_identity_map(str
>>  	 * take them out of the 1:1 domain later.
>>  	 */
>>  	if (!startup)
>> -		return pdev->dma_mask > DMA_BIT_MASK(32);
>> +		return pdev->dma_mask == DMA_BIT_MASK(64);
> 
> This looks unrelated, why the change?
> 
>>  	return 1;
>>  }
>> @@ -2198,6 +2199,9 @@ static int __init iommu_prepare_static_i
>>  		return -EFAULT;
>>  
>>  	for_each_pci_dev(pdev) {
>> +		/* Skip PCI Host Bridge devices */
>> +		if (IS_HOSTBRIDGE_DEVICE(pdev))
>> +			continue;
>>  		if (iommu_should_identity_map(pdev, 1)) {
> 
> Should this host bridge check go into iommu_should_identity_map?
> 
> I understand skipping the extra host bridges, but what is the NULL ptr deref
> coming from?  Just to be sure this isn't a bandaid.
> 
> thanks,
> -chris
> 
