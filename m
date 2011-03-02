Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab1CBMcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 07:32:10 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:20459 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753648Ab1CBMcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 07:32:08 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: kmC6RtIVM1kEgyalKCoHWDP1aXxjBBNUIY8OMl0AGyGTBEc
 HmZM97bK7PT.RllrKbAPwzsnP67GbxA8cISkCLuLQ0qTQz2B2Ud_n9PeN6a5
 ltN7B60IWi5lvWnZ5acyE7nn1n5UXTl9WFWVm1apLXkhjm9Baz04vl_kl3Ib
 ElwMkWf9KbHD0EJYyIpebW53qQCAE3pPAOfFyH3bGrevp.Sc1.F6LDLdYDq4
 P4f.u0dLiTcgeQBs7N1L.jGmOxS3FEWK07mtCcakZyRz2xXZc68fxZDkPr4t
 yB69AVvZJNDk.mQNNZv2EKLEFpCsidnRA7uQD22BEJ8RB3C0-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 2 Mar 2011 06:32:03 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Hugh Dickins <hughd@google.com>
cc: Pekka Enberg <penberg@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/4] slub,rcu: don't assume the size of struct rcu_head
In-Reply-To: <AANLkTim0Zjc7c9-7LCnEaYpV5PVN=5fNQpjMYqtZe-fk@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1103020625290.10180@router.home>
References: <4D6CA852.3060303@cn.fujitsu.com> <AANLkTimXy2Yaj+NTDMNTWuLqHHfKZJhVDpeXj3CfMvBf@mail.gmail.com> <alpine.DEB.2.00.1103010909320.6253@router.home> <AANLkTim0Zjc7c9-7LCnEaYpV5PVN=5fNQpjMYqtZe-fk@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Mar 2011, Hugh Dickins wrote:

> > Struct page may be larger for debugging purposes already because of the
> > need for extended spinlock data.
>
> That was so for a long time, but I stopped it just over a year ago
> with commit a70caa8ba48f21f46d3b4e71b6b8d14080bbd57a, stop ptlock
> enlarging struct page.

Strange. I just played around with in in January and the page struct size
changes when I build kernels with full debugging. I have some
cmpxchg_double patches here that depend on certain alignment in the page
struct. Debugging causes all that stuff to get out of whack so that I had
to do some special patches to make sure fields following the spinlock are
properly aligned when the sizes change.

> If a union leads to "random junk" overwriting the page->mapping field
> when the page is reused, and that junk could resemble the pointer in
> question, then KSM would mistakenly think it still owned the page.
> Very remote chance, and maybe it amounts to no more than a leak.  But
> I'd still prefer we keep page->mapping for pointers (sometimes with
> lower bits set as flags).

DESTROY BY RCU uses the lru field which follows the mapping field in page
struct. Why would random junk overwrite the mapping field?

