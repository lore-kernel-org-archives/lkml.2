Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab1HZO3B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 10:29:01 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:42385 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab1HZO27 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 10:28:59 -0400
MIME-Version: 1.0
Message-ID: <a2fc3885-b98d-4918-afcc-5eac083c7eb0@default>
Date: Fri, 26 Aug 2011 07:28:05 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        hughd@google.com, ngupta@vflare.org,
        Konrad Wilk <konrad.wilk@oracle.com>, JBeulich@novell.com,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        akpm@linux-foundation.org, riel@redhat.com, hannes@cmpxchg.org,
        matthew@wil.cx, Chris Mason <chris.mason@oracle.com>,
        sjenning@linux.vnet.ibm.com, jackdachef@gmail.com, cyclonusj@gmail.com
Subject: RE: Subject: [PATCH V7 2/4] mm: frontswap: core code
References: <20110823145815.GA23190@ca-server1.us.oracle.com>
 <20110825150532.a4d282b1.kamezawa.hiroyu@jp.fujitsu.com>
 <d0b4c414-e90f-4ae0-9b70-fd5b54d2b011@default
 20110826091619.1ad27e9c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110826091619.1ad27e9c.kamezawa.hiroyu@jp.fujitsu.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4E57AD89.0085:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: KAMEZAWA Hiroyuki [mailto:kamezawa.hiroyu@jp.fujitsu.com]
> Subject: Re: Subject: [PATCH V7 2/4] mm: frontswap: core code
> 
> On Thu, 25 Aug 2011 10:37:05 -0700 (PDT)
> Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
> 
> > > From: KAMEZAWA Hiroyuki [mailto:kamezawa.hiroyu@jp.fujitsu.com]
> > > Subject: Re: Subject: [PATCH V7 2/4] mm: frontswap: core code
> 
> > > BTW, Do I have a chance to implement frontswap accounting per cgroup
> > > (under memcg) ? Or Do I need to enable/disale switch for frontswap per memcg ?
> > > Do you think it is worth to do ?
> >
> > I'm not very familiar with cgroups or memcg but I think it may be possible
> > to implement transcendent memory with cgroup as the "guest" and the default
> > cgroup as the "host" to allow for more memory elasticity for cgroups.
> > (See http://lwn.net/Articles/454795/ for a good overview of all of
> > transcendent memory.)
> >
> Ok, I'll see it.
> 
> I just wonder following case.
> 
> Assume 2 memcgs.
> 	memcg X: memory limit = 300M.
> 	memcg Y: memory limit = 300M.
> 
> This limitation is done for performance isolation.
> When using frontswap, X and Y can cause resource confliction in frontswap and
> performance of X and Y cannot be predictable.

> > These are informational statistics so do not need to be protected
> > by a lock or an atomic-type.  If an increment is lost due to a cpu
> > race, it is not a problem.
> 
> Hmm...Personally, I don't like incorrect counters. Could you add comments ?
> Or How anout using percpu_counter ? (see lib/percpu_counter.c)

Since the exact values of these counters is not required
by any code (just information for userland), I think I will
just add a comment.

> > > What lock should be held to guard global variables ? swap_lock ?
> >
> > Which global variables do you mean and in what routines?  I think the
> > page lock is required for put/get (as documented in the comments)
> > but not the swap_lock.
> 
> My concern was race in counters. Even you allow race in frontswap_succ_puts++,
> 
> Don't you need some lock for
> 	sis->frontswap_pages++
> 	sis->frontswap_pages--

Hmmm... OK, you've convinced me.  If this counter should be one and
a race leaves it as zero, I think data corruption could result on
a swapoff or partial swapoff.  And after thinking about it, I
think I also need to check for locking on frontswap_set/clear
as I don't think these bitfield modifiers are atomic.

Thanks for pointing this out.  Good catch!  I will need to
play with this and test it so probably will not submit V8 until
next week as today is a vacation day for me.

Dan
