Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab1BNQmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:42:10 -0500
Received: from lo.gmane.org ([80.91.229.12]:37966 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756057Ab1BNQmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:42:07 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Arkadiusz =?ISO-8859-2?Q?Mi=B6kiewicz?= <arekm@maven.pl>
Subject: Re: b44 driver causes panic when using swiotlb
Followup-To: gmane.linux.kernel
Date: Mon, 14 Feb 2011 17:41:54 +0100
Message-ID: <ijbm0i$n7h$1@dough.gmane.org>
References: <20110131105412.7252a09c@katamari> <20110201225443U.fujita.tomonori@lab.ntt.co.jp> <20110214205945W.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-2"
Content-Transfer-Encoding: 8Bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 87-207-113-141.dynamic.chello.pl
User-Agent: KNode/4.4.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:

> On Tue, 1 Feb 2011 22:54:56 +0900
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
>> On Mon, 31 Jan 2011 10:54:12 -0500
>> Chuck Ebbert <cebbert@redhat.com> wrote:
>> 
>> > The b44 driver is triggering this panic in swiotlb_map_page():
>> > 
>> >         if (!dma_capable(dev, dev_addr, size))
>> >                 panic("map_single: bounce buffer is not DMA'ble");
>> > 
>> > The kernel log says the bounce buffers are at 0xdb400000, but b44 can
>> > only do DMA to the first 1GB of memory:
>> 
>> Can you try this? b44 has the own bouncing mechanism so if swiotlb
>> returns an error, the driver can allocate an appropriate buffer.
>> 
>> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
>> index c47bbe1..93ca08b 100644
>> --- a/lib/swiotlb.c
>> +++ b/lib/swiotlb.c
>> @@ -686,8 +686,10 @@ dma_addr_t swiotlb_map_page(struct device *dev,
>> struct page *page,
>>  /*
>>  * Ensure that the address returned is DMA'ble
>>  */
>> -	if (!dma_capable(dev, dev_addr, size))
>> -		panic("map_single: bounce buffer is not DMA'ble");
>> +	if (!dma_capable(dev, dev_addr, size)) {
>> +		swiotlb_tbl_unmap_single(dev, map, size, dir);
>> +		dev_addr = swiotlb_virt_to_bus(dev, 
io_tlb_overflow_buffer);
>> +	}
>>  
>>  return dev_addr;
>>  }
> 
> Ping, any chance to try this?

Friend machine oopsed on network with b44 on 2.6.37, so we tried this patch 
and network card was detected nicely and was actually usable. The oops 
started to happen after he upgraded memory from 2GB to 4GB in his dell 
vostro 1500 notebook.

03:00.0 Ethernet controller: Broadcom Corporation BCM4401-B0 100Base-TX (rev 
02)

# grep b44 dmesg.log
[    8.524297] b44 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    8.576838] b44: b44.c:v2.0
[    8.593920] b44 ssb1:0: eth0: Broadcom 44xx/47xx 10/100BaseT Ethernet 
00:1c:23:9b:3f:5f
[   55.350228] b44 ssb1:0: eth0: Link is up at 100 Mbps, full duplex
[   55.350233] b44 ssb1:0: eth0: Flow control is off for TX and off for RX


> Thanks,

-- 
Arkadiusz Mi¶kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/

