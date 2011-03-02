Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944Ab1CBEbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 23:31:20 -0500
Received: from smtp-out.google.com ([216.239.44.51]:40157 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757860Ab1CBEbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 23:31:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XLrbND6HbvtnvXQ2Fhh7QIyzQ3hR1uTn7aF240VbNHFVoi7oyI+pTgEW+7V4kKn81D
         wGnTwbl1kgsmVILChphQ==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1103010909320.6253@router.home>
References: <4D6CA852.3060303@cn.fujitsu.com>
	<AANLkTimXy2Yaj+NTDMNTWuLqHHfKZJhVDpeXj3CfMvBf@mail.gmail.com>
	<alpine.DEB.2.00.1103010909320.6253@router.home>
Date: Tue, 1 Mar 2011 20:31:14 -0800
Message-ID: <AANLkTim0Zjc7c9-7LCnEaYpV5PVN=5fNQpjMYqtZe-fk@mail.gmail.com>
Subject: Re: [PATCH 2/4] slub,rcu: don't assume the size of struct rcu_head
From: Hugh Dickins <hughd@google.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 1, 2011 at 7:11 AM, Christoph Lameter <cl@linux.com> wrote:
> On Tue, 1 Mar 2011, Pekka Enberg wrote:
>
> > The SLAB and SLUB patches are fine by me if there are going to be real
> > users for this. Christoph, Paul?
>
> The solution is a bit overkill. It would be much simpler to add a union to
> struct page that has lru and the rcu in there similar things can be done
> for SLAB and the network layer. A similar issue already exists for the
> spinlock in struct page. Lets follow the existing way of handling this.
>
> Struct page may be larger for debugging purposes already because of the
> need for extended spinlock data.

That was so for a long time, but I stopped it just over a year ago
with commit a70caa8ba48f21f46d3b4e71b6b8d14080bbd57a, stop ptlock
enlarging struct page.

Partly out of shame at how large struct page was growing when lockdep
is on, but also a subtle KSM reason which might apply here too: KSM
relies on the content of page->mapping to be kernel pointer to a
relevant structure, NULLed when the page is freed.

If a union leads to "random junk" overwriting the page->mapping field
when the page is reused, and that junk could resemble the pointer in
question, then KSM would mistakenly think it still owned the page.
Very remote chance, and maybe it amounts to no more than a leak.  But
I'd still prefer we keep page->mapping for pointers (sometimes with
lower bits set as flags).

Hugh
