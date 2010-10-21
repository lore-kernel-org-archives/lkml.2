Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666Ab0JUXRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 19:17:31 -0400
Received: from claw.goop.org ([74.207.240.146]:34381 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996Ab0JUXRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 19:17:30 -0400
Message-ID: <4CC0CA07.3000306@goop.org>
Date: Thu, 21 Oct 2010 16:17:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: the arch/x86 maintainers <x86@kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] x86: define arch_vm_get_page_prot to set _PAGE_IOMAP
 on VM_IO vmas
References: <4CC0C14E.5080205@goop.org> <4CC0C318.90401@zytor.com>
In-Reply-To: <4CC0C318.90401@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/21/2010 03:47 PM, H. Peter Anvin wrote:
> On 10/21/2010 03:40 PM, Jeremy Fitzhardinge wrote:
>> Set _PAGE_IOMAP in ptes mapping a VM_IO vma.  This says that the mapping
>> is of a real piece of physical hardware, and not just system memory.
>>
>> Xen, in particular, uses to this to inhibit the normal pfn->mfn conversion
>> that would normally happen - in other words, treat the address directly
>> as a machine physical address without converting it from pseudo-physical.
>>
>> [ Impact: make VM_IO mappings map the right thing under Xen ]
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>
> Am I the only one who thinks this seems extremely odd that the guest is
> trusted to make this distinction?

Xen PV guests are always responsible for constructing ptes with machine
addresses in them (ie, doing their own pseudo-physical to machine
address conversion), and Xen verifies that the pages they want to map
either belong to them or have been granted to them.  The _PAGE_IOMAP
flag is a kernel-internal one which allows us to distinguish between
ptes intended to map memory vs machine hardware addresses; it is not
part of the Xen ABI.

If you're passing a device through to a domain, the domain is given
access to the device's address space so it can legally map those pages
(and if an IOMMU is available, the device is constrained to only DMA
that domain's memory).

    J
