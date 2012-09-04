Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab2IDQou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 12:44:50 -0400
Received: from smtp.citrix.com ([66.165.176.89]:61976 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757135Ab2IDQot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 12:44:49 -0400
X-IronPort-AV: E=Sophos;i="4.80,367,1344211200"; 
   d="scan'208";a="36719631"
Message-ID: <50462FFE.7070100@citrix.com>
Date: Tue, 4 Sep 2012 17:44:46 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Stefano Panella <stefano.panella@citrix.com>
CC: David Vrabel <david.vrabel@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH 1/1] XEN: Use correct masking in	xen_swiotlb_alloc_coherent.
References: <1346407072-6405-1-git-send-email-stefano.panella@citrix.com>	<5040B249.4000306@citrix.com>	<20120831164010.GA18929@localhost.localdomain>	<50460B2E.3020200@citrix.com>	<20120904143731.GC23361@phenom.dumpdata.com>	<50461654.5040901@citrix.com> <50461A59.2050504@citrix.com>
In-Reply-To: <50461A59.2050504@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/12 16:12, Stefano Panella wrote:
> On 09/04/2012 03:55 PM, David Vrabel wrote:
>> On 04/09/12 15:37, Konrad Rzeszutek Wilk wrote:
>>> On Tue, Sep 04, 2012 at 03:07:42PM +0100, Stefano Panella wrote:
>>>> So if hwdev->coherent_dma_mask is set to 0xffffffffffffffff our
>>>> dma_mask will
>>>> be u64 set to 0xffffffffffffffff even if we set it to
>>>> DMA_BIT_MASK(32) previously.
>>> That is what I was missing. Let me include that in the git commit and
>>> also
>>> put this patch on the stable tree.
>> Note that this appears to be a work around for a bug in the sound system
>> or Intel HDA device driver which is incorrectly truncating a dma_addr_t
>> to a u32.  So by ensuring a DMA_BIT_MASK(32) when the dma_addr_t is
>> truncated it still works.
>>
>> David
> Sorry David, I am not completely sure I understand your argument in
> favour of a bug in the
> sound system or Intel HDA device driver. Could you please elaborate more
> in detail about this?

The HDA driver claims to support 64-bit DMA addresses, so it should be
perfectly fine for the Xen DMA mapping/allocation functions to return
DMA addresses > 4 GiB.  For most devices this seems to work just fine.

I think that somewhere between the buffer being mapped or allocated and
the address being programmed into the hardware, the 64-bit dma_addr_t
value is being truncated to 32 bits giving an invalid DMA address.

The patch would avoid this by setting the DMA mask to 32-bit and only
returning DMA address < 4 GiB which can quite happily be stuffed into a
u32 without losing bits.

I think it would be useful (without the patch applied) to print the DMA
addresses returned by the allocate/mapping functions and the address
programmed into the hardware.  It will be easily to spot if it got
truncated or not.

David
