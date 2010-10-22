Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab0JVQoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 12:44:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56298 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754548Ab0JVQoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 12:44:19 -0400
Message-ID: <4CC1BF58.9020001@zytor.com>
Date: Fri, 22 Oct 2010 09:44:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: define arch_vm_get_page_prot to set _PAGE_IOMAP
 on VM_IO vmas
References: <4CC0C14E.5080205@goop.org> <4CC0C318.90401@zytor.com> <4CC0CA07.3000306@goop.org> <4CC0DEB8.1060309@zytor.com> <20101022150826.GA23325@dumpdata.com>
In-Reply-To: <20101022150826.GA23325@dumpdata.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2010 08:08 AM, Konrad Rzeszutek Wilk wrote:
>>
>> Okay, could you clarify this part a bit?  Why does the kernel need to
>> know the difference between "pseudo-physical" and "machine addresses" at
>> all?  If they overlap, there is a problem, and if they don't overlap, it
>> will be a 1:1 mapping anyway...
> 
> The flag (_PAGE_IOMAP) is used when we set the PTE so that the MFN value is
> used instead of the PFN. We need that b/c when a driver does page_to_pfn()
> it ends up using the PFN as bus address to write out registers data.
> 
> Without this patch, the page->virt->PFN value is used and the PFN != to real MFN
> so we end up writing in a memory address that the PCI device has no idea about.
> By setting the PTE with the MFN, the virt->PFN gets the real MFN value.
> 
> The drivers I am talking about are mostly, if not all, located in drivers/gpu
> and it looks that we are missing two more patches to utilize the patch
> that Jeremy posted.
> 
> Please note that I am _not_ suggesting that the two patches
> below should go out - I still need to post them on drm mailing list.
> 

I'm still seriously confused.  If I understand this correctly, we're
talking about DMA addresses here (as opposed to PIO addresses, i.e.
BARs), right?

It's the bimodality that really bothers me.  I understand of course that
Xen imposes yet another address remapping layer, but I'm having a hard
time understanding any conditions under with we would need that layer to
go away, as long as DMA addresses are translated via the DMA APIs -- and
if they aren't, then iommus will break, too.

As such, I don't grok this page flag and what it does, and why it's
needed.  I'm not saying it's *wrong*, I'm saying the design is opaque to
me and I'm not sure it is the right solution.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

