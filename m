Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab2BOTOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:14:33 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42605 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab2BOTOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:14:30 -0500
Subject: Re: Uninline kcalloc
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Xi Wang <xi.wang@gmail.com>
In-Reply-To: <alpine.DEB.2.00.1202141605240.32407@router.home>
Date: Wed, 15 Feb 2012 14:14:25 -0500
Cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jesper Juhl <jj@chaosbits.net>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>
Content-Transfer-Encoding: 7bit
Message-Id: <07635976-4FC3-4E14-9B94-CE4D6446FD4E@gmail.com>
References: <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com> <32FA0BD0-7C0D-4ED4-B375-4736FC70AC05@gmail.com> <4F33CEAE.60400@gmail.com> <alpine.LNX.2.00.1202092346300.32491@swampdragon.chaosbits.net> <20120209150652.5b1d19dc.akpm@linux-foundation.org> <FE5A0944-E520-4D3F-987E-A357411DD60B@gmail.com> <alpine.DEB.2.00.1202130958470.23562@router.home> <20120213194446.GD26353@mwanda> <alpine.DEB.2.00.1202131424020.25908@router.home> <20120214072017.GF26353@mwanda> <alpine.DEB.2.00.1202140858080.20013@router.home> <8F83835C-366C-46AC-A50A-3F680B7D2D83@gmail.com> <alpine.DEB.2.00.1202141032410.22250@router.home> <ADCFB33D-7284-4D3F-8280-545AF82EC744@gmail.com> <alpine.DEB.2.00.1202141329360.24883@router.home> <20120214124518.f42bc03e.akpm@linux-foundation.org> <CAOJsxLEdSr983jQ00_YuSWr3=pfmQHbebX87347K6v1HoCiyLw@mail.gmail.com> <alpine.DEB.2.00.1202141503470.29019@router.home> <59F64CB9-832E-4F7C-8A6C-E2CD18563795@gmail.com> <alpine.DEB.2.00.1202141605240.32407@router.home>
To: Christoph Lameter <cl@linux.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 14, 2012, at 5:08 PM, Christoph Lameter wrote:
> kcalloc is still there. Certainly useful for legacy purposes. But I'd feel
> better if I had fine grained control over the size of my allocation rather
> than rely on the slab allocators to check up on my multiplication.
> 
> With these patches both is possible. And if you want the check of an
> allocation that is not zeroed then you can do so because you have a
> function that will perform the size check for you without calling into the
> slab allocator.

In the code you proposed, where calculate_array_size() returns 0
for overflow, one has to write:

        size_t s = calculate_array_size(n, size);
        if (s)
                p = kmalloc(s, ...);

This "if" thing is just too verbose --- you need three lines to
allocate an array.

We could change calculate_array_size() to return ULONG_MAX or some
large number with which kmalloc() would fail.  Then one would write:

        p = kmalloc(calculate_array_size(n, size), ...);

This looks better to me.  The advantage is that we don't need another
allocator (and avoid this name picking game).  The disadvantage is
that the semantics of calculate_array_size(), returning ULONG_MAX
on overflow, sounds sort of strange.

- xi

