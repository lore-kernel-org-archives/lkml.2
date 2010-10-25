Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab0JYVoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 17:44:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751210Ab0JYVoY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 17:44:24 -0400
MIME-Version: 1.0
In-Reply-To: <20101025212706.27798.23957.stgit@warthog.procyon.org.uk>
References: <20101025212706.27798.23957.stgit@warthog.procyon.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 25 Oct 2010 14:43:35 -0700
Message-ID: <AANLkTi=_siOR8QtXdW07ZY1mFG9_A2806erd64cRNRCb@mail.gmail.com>
Subject: Re: [PATCH] workqueue: Fix alignment calculation in alloc_cwqs()
To: David Howells <dhowells@redhat.com>
Cc: akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>,
        linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Mark Salter <msalter@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 2:27 PM, David Howells <dhowells@redhat.com> wrote:
> In the MN10300 arch, we occasionally see an assertion being tripped in
> alloc_cwqs() at the following line:
>
>        /* just in case, make sure it's actually aligned */
>  --->  BUG_ON(!IS_ALIGNED(wq->cpu_wq.v, align));
>        return wq->cpu_wq.v ? 0 : -ENOMEM;
>
> The values are:
>
>        wa->cpu_wq.v => 0x902776e0
>        align => 0x100
>
> and align is calculated by the following:
>
>        const size_t align = max_t(size_t, 1 << WORK_STRUCT_FLAG_BITS,
>                                   __alignof__(unsigned long long));
>
> which is wrong.  __alignof__() returns its value in bytes, but:
>
>        1 << WORK_STRUCT_FLAG_BITS
>
> returns the value in bits.  It needs dividing by the number of bits in a byte.

No it doesn't. Those bits really require that many bytes of alignment.

Think about it: if the low 8 bits of the pointer are used for flags,
then the actual pointer itself needs to be aligned to a 256-byte
boundary.

So the code is right. If needs to ask for "1 << WORK_STRUCT_FLAG_BITS"
alignment, and if it doesn't get it (because the allocator is somehow
broken - percpu allocator issues?), things will break.

                     Linus
