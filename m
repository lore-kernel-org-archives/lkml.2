Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab2BPScw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 13:32:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36391 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab2BPScv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 13:32:51 -0500
Subject: Re: Uninline kcalloc
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Xi Wang <xi.wang@gmail.com>
In-Reply-To: <alpine.DEB.2.00.1202160845320.25847@router.home>
Date: Thu, 16 Feb 2012 13:32:45 -0500
Cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jesper Juhl <jj@chaosbits.net>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>
Content-Transfer-Encoding: 7bit
Message-Id: <5716B9E7-4E65-42ED-B429-92B278BC1E56@gmail.com>
References: <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com> <FE5A0944-E520-4D3F-987E-A357411DD60B@gmail.com> <alpine.DEB.2.00.1202130958470.23562@router.home> <20120213194446.GD26353@mwanda> <alpine.DEB.2.00.1202131424020.25908@router.home> <20120214072017.GF26353@mwanda> <alpine.DEB.2.00.1202140858080.20013@router.home> <8F83835C-366C-46AC-A50A-3F680B7D2D83@gmail.com> <alpine.DEB.2.00.1202141032410.22250@router.home> <ADCFB33D-7284-4D3F-8280-545AF82EC744@gmail.com> <alpine.DEB.2.00.1202141329360.24883@router.home> <20120214124518.f42bc03e.akpm@linux-foundation.org> <CAOJsxLEdSr983jQ00_YuSWr3=pfmQHbebX87347K6v1HoCiyLw@mail.gmail.com> <alpine.DEB.2.00.1202141503470.29019@router.home> <59F64CB9-832E-4F7C-8A6C-E2CD18563795@gmail.com> <alpine.DEB.2.00.1202141605240.32407 @router.home> <07635976-4FC3-4E14-9B94-CE4D6446FD4E@gmail.com> <alpine.DEB.2.00.1202151324060.28225@router.home> <E307A48D-2146-4052-8A84-E7FA690A6703@gmail.com> <alpine.DEB.2.00.1202160845320.25847@router.home>
To: Christoph Lameter <cl@linux.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 16, 2012, at 9:51 AM, Christoph Lameter wrote:
> Then there is
> 
> vzalloc
> kzalloc
> vmalloc_32
> alloc_bootmem (MAXORDER limit may not work)
> alloc_remap
> 
> ...
> 
> This would also work for special subsystem allocations like
> 
> usb_alloc_coherent
> dm_vcalloc
> devres_alloc
> 
> ....
> 
> 
> The use of a function or macro makes the overflow check much more
> universal and allows these array allocations to occur with different
> allocation functions throughout the kernel.

No, it does NOT.  It can be easily misued to introduce more bugs.

1) Should calculate_array_size() return 0 on overflow, as you
   orginally proposed?

No, as Dan, Pekka, and some others already pointed out.

2) Should calculate_array_size() return something like
   KMALLOC_MAX_SIZE + 1?

No, because you intended to use it with other allocators such as
vmalloc().

3) Should calculate_array_size() return ULONG_MAX/SIZE_MAX/-1?

No!  Consider devres_alloc() you mentioned.  Then you do

devres_alloc(..., calculate_array_size(n, size), ...).

It internally invokes kmalloc() with allocation size:

sizeof(struct devres) + calculate_array_size(n, size).

When n * size overflows, calculate_array_size() returns ULONG_MAX,
and the allocation size wraps around to a small integer!

I like the idea of "do not add an allocator unless necessary".
However, "universal" calculate_array_size() just doesn't work,
unless you can find the correct semantics or limit its use.
It can be easily misused and bring more trouble than it's worth.

- xi

