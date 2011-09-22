Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab1IVVUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 17:20:09 -0400
Received: from claw.goop.org ([74.207.240.146]:54635 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914Ab1IVVUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 17:20:01 -0400
Message-ID: <4E7BA677.9090907@goop.org>
Date: Thu, 22 Sep 2011 14:19:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] Re: [PATCH 0/6] xen: don't call vmalloc_sync_all()
 when mapping foreign pages
References: <1316090411-22608-1-git-send-email-david.vrabel@citrix.com> <4E727017.4030001@goop.org> <alpine.DEB.2.00.1109211124050.8700@kaball-desktop> <4E7A3394.3090806@goop.org> <alpine.DEB.2.00.1109221131390.8700@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1109221131390.8700@kaball-desktop>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2011 04:06 AM, Stefano Stabellini wrote:
> On Wed, 21 Sep 2011, Jeremy Fitzhardinge wrote:
>> On 09/21/2011 03:42 AM, Stefano Stabellini wrote:
>>> On Thu, 15 Sep 2011, Jeremy Fitzhardinge wrote:
>>>> This series is relying on regular ram mappings are already synced to all
>>>> tasks, but I'm not sure that's necessarily guaranteed (for example, if
>>>> you hotplug new memory into the domain, the new pages won't be mapped
>>>> into every mm unless they're synced).
>>> the series is using GFP_KERNEL, so this problem shouldn't occur, right?
>> What properties do you think GFP_KERNEL guarantees?
> That the memory is below 4G and always mapped in the kernel 1:1 region.

Hm, but that's not quite the same thing as "mapped into every
pagetable".  Lowmem pages always have a kernel virtual address, and its
always OK to touch them at any point in kernel code[*] because one can
rely on the fault handler to create mappings as needed - but that
doesn't mean they're necessarily mapped by present ptes in the current
pagetable.

[*] - except NMI handlers

> Regarding memory hotplug it looks like that x86_32 is mapping new memory
> ZONE_HIGHMEM, therefore avoiding any problems with GFP_KERNEL allocations.
> On the other hand x86_64 is mapping the memory ZONE_NORMAL and calling
> init_memory_mapping on the new range right away. AFAICT changes to
> the 1:1 mapping in init_mm are automatically synced across all mm's
> because the pgd is shared?

TBH I'm not sure.  vmalloc_sync_one/all does seem to do *something* on
64-bit, but I was never completely sure what regions of the address
space were already shared.  I *think* it might be that the pgd and pud
are not shared, but the pmd down is, so if you add a new pmd you need to
sync it into all the puds (and puds into pgds if you add a new one of
those).

But I'd be happier pretending that vmalloc_sync_* just doesn't exist,
and deal with it at the hypercall level - in the short term, by just
making sure that the callers touch all those pages before passing them
into the hypercall.

    J
