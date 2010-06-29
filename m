Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab0F2X5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 19:57:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:36397 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753598Ab0F2X5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 19:57:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,508,1272870000"; 
   d="scan'208";a="581234686"
Message-ID: <4C2A8879.8010000@intel.com>
Date: Tue, 29 Jun 2010 16:57:45 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Chris Li <lkml@chrisli.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: BUG in drivers/dma/ioat/dma_v2.c:314
References: <AANLkTinMqI7hmBYt4eN2oTLZt9_FkoNDHb-9ZF3Z7vls@mail.gmail.com>	<4C29420D.2010406@intel.com> <AANLkTikJvUIcx744weazBmOfyZzEu8NgYZ4oaLP2TbZ0@mail.gmail.com>
In-Reply-To: <AANLkTikJvUIcx744weazBmOfyZzEu8NgYZ4oaLP2TbZ0@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------010000060302080509060307"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010000060302080509060307
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 6/29/2010 4:20 PM, Chris Li wrote:
> On Mon, Jun 28, 2010 at 5:45 PM, Dan Williams<dan.j.williams@intel.com>  wrote:
>> Looks like that dev_err() did not make it to the console.  The attached
>> patch should get us some more debug information.  This will stop the driver
>> from making forward progress (applies to current -git).  I suspect this may
>> be triggering from the driver self test, but to be safe you should set
>> CONFIG_NET_DMA=n and CONFIG_ASYNC_TX_DMA=n.
>
> OK, with the patch it does not kernel panic any more.
>
> Here is the prink from ioatdma.
>

Thanks.

[..]
> 0000:00:0f.0: ioat2_timer_event: Channel halted (10)

This says that we got an invalid chain address error when trying to 
start the engine.  If there was a driver problem with init I would have 
expected to see reports from other systems.  The attached patch will 
print out what chain address we are setting.  The hardware expects a 
64-byte aligned address which should be guaranteed by the use of 
pci_pool_alloc().

However, if you are up for another experiment, I'd like to see what 
happens if you disable VT-d.  Maybe it is a misconfigured iommu table 
that is blocking the engine's access to memory?

> I attach the full dmesg in case you need it. Is it possible that
> the Mac Pro is MSI only and ioatdma is not happy about that?

Not really, MSI is the preferred mode of operation, and as I said 
earlier if something like this were broken I would expect reports from 
other platforms??

--
Dan

--------------010000060302080509060307
Content-Type: text/plain;
 name="report-chainaddr.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="report-chainaddr.patch"

diff --git a/drivers/dma/ioat/dma_v2.h b/drivers/dma/ioat/dma_v2.h
index a2c413b..47ab35e 100644
--- a/drivers/dma/ioat/dma_v2.h
+++ b/drivers/dma/ioat/dma_v2.h
@@ -149,6 +149,8 @@ static inline void ioat2_set_chainaddr(struct ioat2_dma_chan *ioat, u64 addr)
 {
 	struct ioat_chan_common *chan = &ioat->base;
 
+	dev_info(to_dev(chan), "%s: chainaddr: %llx\n", __func__,
+		 (unsigned long long) addr);
 	writel(addr & 0x00000000FFFFFFFF,
 	       chan->reg_base + IOAT2_CHAINADDR_OFFSET_LOW);
 	writel(addr >> 32,

--------------010000060302080509060307--
