Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab1BAAyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 19:54:25 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43061 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab1BAAyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 19:54:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wtae7s021FBYoQKlX7v31fKfOY1k9wtG0yE/fH0dD2VtQzs8Vx3/d5TXp82V8JuZZR
         v8v2/7Lnfkptn+uZJmldFk7z6zkpKAPcWXXX974qtn5KCzLkfEIw0toM+OxEuC2Xhacu
         NIfZf8tSTB8Rb/VOuvjhy7enY7vTX5Kgcb0Ek=
Message-ID: <4D4759BD.2000006@gmail.com>
Date: Mon, 31 Jan 2011 18:54:21 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: b44 driver causes panic when using swiotlb
References: <20110131105412.7252a09c@katamari> <20110131163639.GA32095@tassilo.jf.intel.com>
In-Reply-To: <20110131163639.GA32095@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2011 10:36 AM, Andi Kleen wrote:
> On Mon, Jan 31, 2011 at 10:54:12AM -0500, Chuck Ebbert wrote:
>> The b44 driver is triggering this panic in swiotlb_map_page():
>>
>>          if (!dma_capable(dev, dev_addr, size))
>>                  panic("map_single: bounce buffer is not DMA'ble");
>>
>> The kernel log says the bounce buffers are at 0xdb400000, but b44 can
>> only do DMA to the first 1GB of memory:
>
> b44 needs to use GFP_DMA then and do its own custom bouncing.
> The standard pci_map_* bounce buffering is only designed for at least
> 32bit capable devices.

That seems wrong - it's a documented API and that restriction isn't 
documented. Either it should comply with the request or return a failure 
if it can't accomodate it, not just blow up internally. There's no 
reason the driver should have to deal with this on its own.

In this case the DMA mapping code  should really be falling back to 
GFP_DMA automatically if the IOMMU aperture is outside the DMA mask of 
the device.

>
> BTW I'm pretty sure this worked at some point, must have regressed
> somehow.

