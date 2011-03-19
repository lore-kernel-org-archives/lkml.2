Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab1CSD7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 23:59:08 -0400
Received: from smtp-out.google.com ([74.125.121.67]:56394 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905Ab1CSD7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 23:59:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=qZKYkjRDO9JLrIXeO1gs7KOa7wiRw7U5QDq8HHsmE9tgG52DAspVF35VP5ny82hxto
         8fShKeMLGgyyvJKgQdYQ==
Date: Fri, 18 Mar 2011 20:58:38 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/4] slub,rcu: don't assume the size of struct rcu_head
In-Reply-To: <alpine.DEB.2.00.1103171006270.12540@router.home>
Message-ID: <alpine.LSU.2.00.1103182037340.18458@sister.anvils>
References: <4D6CA852.3060303@cn.fujitsu.com> <AANLkTimXy2Yaj+NTDMNTWuLqHHfKZJhVDpeXj3CfMvBf@mail.gmail.com> <alpine.DEB.2.00.1103010909320.6253@router.home> <AANLkTim0Zjc7c9-7LCnEaYpV5PVN=5fNQpjMYqtZe-fk@mail.gmail.com> <alpine.DEB.2.00.1103020625290.10180@router.home>
 <AANLkTikk02f6kLiPFqqAGroJErQkHbJFfHzpHy4Y5P8Y@mail.gmail.com> <alpine.DEB.2.00.1103171006270.12540@router.home>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Mar 2011, Christoph Lameter wrote:
> On Sun, 6 Mar 2011, Hugh Dickins wrote:
> 
> > >> That was so for a long time, but I stopped it just over a year ago
> > >> with commit a70caa8ba48f21f46d3b4e71b6b8d14080bbd57a, stop ptlock
> > >> enlarging struct page.
> > >
> > > Strange. I just played around with in in January and the page struct size
> > > changes when I build kernels with full debugging. I have some
> > > cmpxchg_double patches here that depend on certain alignment in the page
> > > struct. Debugging causes all that stuff to get out of whack so that I had
> > > to do some special patches to make sure fields following the spinlock are
> > > properly aligned when the sizes change.
> >
> > That puzzles me, it's not my experience and I don't have an
> > explanation: do you have time to investigate?
> >
> > Uh oh, you're going to tell me you're working on an out-of-tree
> > architecture with a million cpus ;)  In that case, yes, I'm afraid
> > I'll have to update the SPLIT_PTLOCK_CPUS defaulting (for a million -
> > 1 even).
> 
> No I am not working on any out of tree structure. Just regular dual socket
> server boxes with 24 processors (which is a normal business machine
> configuration these days).
> 
> But then there is also CONFIG_GENERIC_LOCKBREAK. That does not affect
> things?

CONFIG_GENERIC_LOCKBREAK adds an unsigned int break_lock after the
int-sized arch_spinlock_t: which would make no difference on 64-bit
anyway (the two ints fitting into one long), and makes no difference
on 32-bit because we have put
	struct {
		unsigned long private;
		struct address_space *mapping;
	};
into the union with spinlock_t ptl - the arch_spinlock_t then
overlays private and the break_lock overlays mapping.

I'd much rather have had simple elements in that union, but it's
precisely because of 32-bit CONFIG_GENERIC_LOCKBREAK that we need
that structure in there.

(It is important to the KSM assumption about page->mapping that
what goes into break_lock is either 0 or 1: in neither case could
page->mapping look like a kmem address + 3.)

Hugh
