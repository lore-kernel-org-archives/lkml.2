Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab1AXLOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 06:14:24 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56346 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab1AXLOX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 06:14:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=D8OXy2CkJdS/NhGxJek6tr0FV/CjA7qnrJ3yVIyKij5CKUM6MYfnhRD9XsbVXr0+9i
         tGg0WgLRngKCjx6njGbZJgfS8hRYeTZGq/5uZWlMow0T6lsO7KieXpxmM8mWcFkV++s0
         SA1gS4eIQAlSMa1BIv2F1+rErR47IBY1vOQjw=
MIME-Version: 1.0
In-Reply-To: <20110124104510.GW2232@cmpxchg.org>
References: <20110121153431.191134dd.kamezawa.hiroyu@jp.fujitsu.com>
	<20110121153726.54f4a159.kamezawa.hiroyu@jp.fujitsu.com>
	<20110124101402.GT2232@cmpxchg.org>
	<20110124191535.514ef2d9.kamezawa.hiroyu@jp.fujitsu.com>
	<20110124104510.GW2232@cmpxchg.org>
Date: Mon, 24 Jan 2011 20:14:22 +0900
Message-ID: <AANLkTi=sg5HpCTdXgEVYS5rCqtoVVho6dxn8giwZ4kmY@mail.gmail.com>
Subject: Re: [PATCH 1/7] memcg : comment, style fixes for recent patch of move_parent
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/24 Johannes Weiner <hannes@cmpxchg.org>:
> On Mon, Jan 24, 2011 at 07:15:35PM +0900, KAMEZAWA Hiroyuki wrote:
>> On Mon, 24 Jan 2011 11:14:02 +0100
>> Johannes Weiner <hannes@cmpxchg.org> wrote:
>>
>> > On Fri, Jan 21, 2011 at 03:37:26PM +0900, KAMEZAWA Hiroyuki wrote:
>> > > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> > >
>> > > A fix for 987eba66e0e6aa654d60881a14731a353ee0acb4
>> > >
>> > > A clean up for mem_cgroup_move_parent().
>> > >  - remove unnecessary initialization of local variable.
>> > >  - rename charge_size -> page_size
>> > >  - remove unnecessary (wrong) comment.
>> > >
>> > > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> > > ---
>> > >  mm/memcontrol.c |   17 +++++++++--------
>> > >  1 file changed, 9 insertions(+), 8 deletions(-)
>> > >
>> > > Index: mmotm-0107/mm/memcontrol.c
>> > > ===================================================================
>> > > --- mmotm-0107.orig/mm/memcontrol.c
>> > > +++ mmotm-0107/mm/memcontrol.c
>> > > @@ -2265,7 +2265,7 @@ static int mem_cgroup_move_parent(struct
>> > >   struct cgroup *cg = child->css.cgroup;
>> > >   struct cgroup *pcg = cg->parent;
>> > >   struct mem_cgroup *parent;
>> > > - int charge = PAGE_SIZE;
>> > > + int page_size;
>> > >   unsigned long flags;
>> > >   int ret;
>> > >
>> > > @@ -2278,22 +2278,23 @@ static int mem_cgroup_move_parent(struct
>> > >           goto out;
>> > >   if (isolate_lru_page(page))
>> > >           goto put;
>> > > - /* The page is isolated from LRU and we have no race with splitting */
>> > > - charge = PAGE_SIZE << compound_order(page);
>> > > +
>> > > + page_size = PAGE_SIZE << compound_order(page);
>> >
>> > Okay, so you remove the wrong comment, but that does not make the code
>> > right.  What protects compound_order from reading garbage because the
>> > page is currently splitting?
>> >
>>
>> ==
>> static int mem_cgroup_move_account(struct page_cgroup *pc,
>>                 struct mem_cgroup *from, struct mem_cgroup *to,
>>                 bool uncharge, int charge_size)
>> {
>>         int ret = -EINVAL;
>>         unsigned long flags;
>>
>>         if ((charge_size > PAGE_SIZE) && !PageTransHuge(pc->page))
>>                 return -EBUSY;
>> ==
>>
>> This is called under compound_lock(). Then, if someone breaks THP,
>> -EBUSY and retry.
>
> This charge_size contains exactly the garbage you just read from an
> unprotected compound_order().  It could be anything if the page is
> split concurrently.

Then, my recent fix to LRU accounting which use compound_order() is racy, too ?

I'll replace compound_order() with
  if (PageTransHuge(page))
      size = HPAGE_SIZE.

Does this work ?
If there are no way to aquire size of page without lock, I need to add one.
Any idea?

Thanks,
-Kame
