Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab1AXJGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 04:06:32 -0500
Received: from adelie.canonical.com ([91.189.90.139]:36620 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab1AXJG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 04:06:29 -0500
Message-ID: <4D3D4109.9020103@canonical.com>
Date: Mon, 24 Jan 2011 10:06:17 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        xen-devel@lists.xensource.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: [PATCH] xen: p2m: correctly initialize partial
 p2m	leave
References: <4D3848DF.9000906@canonical.com> <20110120151032.GD5092@dumpdata.com> <4D3D04CE.2050905@goop.org>
In-Reply-To: <4D3D04CE.2050905@goop.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2011 05:49 AM, Jeremy Fitzhardinge wrote:
> On 01/20/2011 07:10 AM, Konrad Rzeszutek Wilk wrote:
>> On Thu, Jan 20, 2011 at 03:38:23PM +0100, Stefan Bader wrote:
>>> There have been changes and code been moved around, so this is just a quick
>>> rebase of the change I tested on a 2.6.37 based kernel. The basic problem seem
>>> still valid, though.
>> Nice catch..
> 
> Indeed!
> 
>>> Initially I thought of adding a cc to stable into the s-o-b, but the patch needs
>>> to be adapted anyway (I can supply that version if the way I fixed the issue
>>> looks ok).
>>>
>>> Regards,
>>> Stefan
>>> >From 1e9c9514caf0399c88ae9288e6db8e3d1c4b4be5 Mon Sep 17 00:00:00 2001
>>> From: Stefan Bader <stefan.bader@canonical.com>
>>> Date: Thu, 20 Jan 2011 11:37:43 +0100
>>> Subject: [PATCH] xen: p2m: correctly initialize partial p2m leave
>>>
>>> After changing the p2m mapping to a tree by
>>>
>>>   commit 58e05027b530ff081ecea68e38de8d59db8f87e0
>>>     xen: convert p2m to a 3 level tree
>>>
>>> and trying to boot a DomU with 615MB of memory, the following crash was
>>> observed in the dump:
>>>
>>> kernel direct mapping tables up to 26f00000 @ 1ec4000-1fff000
>>> BUG: unable to handle kernel NULL pointer dereference at (null)
>>> IP: [<c0107397>] xen_set_pte+0x27/0x60
>>> *pdpt = 0000000000000000 *pde = 0000000000000000
>>>
>>> Adding further debug statements showed that when trying to set up
>>> pfn=0x26700 the returned mapping was invalid.
>>>
>>> pfn=0x266ff calling set_pte(0xc1fe77f8, 0x6b3003)
>>> pfn=0x26700 calling set_pte(0xc1fe7800, 0x3)
>>>
>>> Although the last_pfn obtained from the startup info is 0x26700, which
>>> should in turn not be hit, the additional 8MB which are added as extra
>>> memory normally seem to be ok. This lead to looking into the initial
>>> p2m tree construction, which uses the smaller value and assuming that
>>> there is other code handling the extra memory.
>>>
>>> When the p2m tree is set up, the leaves are directly pointed to the
>>> array which the domain builder set up. But if the mapping is not on a
>>> boundary that fits into one p2m page, this will result in the last leaf
>>> being only partially valid. And as the invalid entries are not
>>> initialized in that case, things go badly wrong.
>>>
>>> I am trying to fix that by checking whether the current leaf is a
>>> complete map and if not, allocate a completely new page and copy only
>>> the valid pointers there. This may not be the most efficient or elegant
>>> solution, but at least it seems to allow me booting DomUs with memory
>>> assignments all over the range.
> 
> Since the p2m page is just a normal page that happens to have been
> initialized by the domain builder, I think we can just fill the tail of
> the page with INVALID_P2M_ENTRY in place, rather than having to allocate
> a new one.
> 
>     J

That was exactly the detail I was not sure about and did not want to make
assumptions after only spending a little bit digging around in the code. The
safest assumption was to expect other data to be possibly located after the p2m
array. Please feel free to clean up the code any time.

-Stefan
