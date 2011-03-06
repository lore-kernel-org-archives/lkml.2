Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab1CFTjO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 14:39:14 -0500
Received: from smtp-out.google.com ([74.125.121.67]:30667 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680Ab1CFTjL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 14:39:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dR2tkimywf7Oicq8VRkE2QoSXoAyix4CDBSyad8zRV5NSuC2XC12QxAPWWSD+Y/mFP
         ZpV/Wm+8V8sdDU6FfrVg==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1103020625290.10180@router.home>
References: <4D6CA852.3060303@cn.fujitsu.com>
	<AANLkTimXy2Yaj+NTDMNTWuLqHHfKZJhVDpeXj3CfMvBf@mail.gmail.com>
	<alpine.DEB.2.00.1103010909320.6253@router.home>
	<AANLkTim0Zjc7c9-7LCnEaYpV5PVN=5fNQpjMYqtZe-fk@mail.gmail.com>
	<alpine.DEB.2.00.1103020625290.10180@router.home>
Date: Sun, 6 Mar 2011 11:39:04 -0800
Message-ID: <AANLkTikk02f6kLiPFqqAGroJErQkHbJFfHzpHy4Y5P8Y@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 2, 2011 at 4:32 AM, Christoph Lameter <cl@linux.com> wrote:
> On Tue, 1 Mar 2011, Hugh Dickins wrote:
>
>> > Struct page may be larger for debugging purposes already because of the
>> > need for extended spinlock data.
>>
>> That was so for a long time, but I stopped it just over a year ago
>> with commit a70caa8ba48f21f46d3b4e71b6b8d14080bbd57a, stop ptlock
>> enlarging struct page.
>
> Strange. I just played around with in in January and the page struct size
> changes when I build kernels with full debugging. I have some
> cmpxchg_double patches here that depend on certain alignment in the page
> struct. Debugging causes all that stuff to get out of whack so that I had
> to do some special patches to make sure fields following the spinlock are
> properly aligned when the sizes change.

That puzzles me, it's not my experience and I don't have an
explanation: do you have time to investigate?

Uh oh, you're going to tell me you're working on an out-of-tree
architecture with a million cpus ;)  In that case, yes, I'm afraid
I'll have to update the SPLIT_PTLOCK_CPUS defaulting (for a million -
1 even).

>
>> If a union leads to "random junk" overwriting the page->mapping field
>> when the page is reused, and that junk could resemble the pointer in
>> question, then KSM would mistakenly think it still owned the page.
>> Very remote chance, and maybe it amounts to no more than a leak.  But
>> I'd still prefer we keep page->mapping for pointers (sometimes with
>> lower bits set as flags).
>
> DESTROY BY RCU uses the lru field which follows the mapping field in page
> struct. Why would random junk overwrite the mapping field?

Random junk does not overwrite the mapping field with the current
implementation of DESTROY_BY_RCU.  But you and Jiangshan were
discussing how to change it, so I was warning of this issue with
page->mapping.

But I would anyway agree with Jiangshan, that it's preferable not to
bloat struct page size just for this DESTROY_BY_RCU issue, even if it
is only an issue when debugging.

Hugh
