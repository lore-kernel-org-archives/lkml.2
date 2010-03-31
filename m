Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab0CaCxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 22:53:05 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48198 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554Ab0CaCxB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 22:53:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Qmx+EzFbA3mkiGo+SYdABtPhxeC+dtPly+X9KIms5ZPj796xRa+JgHYiNr67x91QXc
         D+yxVjZZH8xghMeWemNtsPi2xmyJeWwN+7F7Re7v93mr53mMwC97O4vFOXW75P8dVVgj
         /jBfzN2fqM9Y6dHPj3/eThhCuw9ts2GBLGJGs=
MIME-Version: 1.0
In-Reply-To: <20100331102755.92a89ca5.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100316170808.GA29400@redhat.com>
	 <20100330135634.09e6b045.akpm@linux-foundation.org>
	 <20100331092815.c8b9d89c.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100330173721.cbd442cb.akpm@linux-foundation.org>
	 <20100331094124.43c49290.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100330182258.59813fe6.akpm@linux-foundation.org>
	 <20100331102755.92a89ca5.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 31 Mar 2010 11:53:00 +0900
Message-ID: <n2m28c262361003301953iea82f541u227e7227a23702e@mail.gmail.com>
Subject: Re: [PATCH] exit: fix oops in sync_mm_rss
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Michael S. Tsirkin" <mst@redhat.com>, cl@linux-foundation.org,
       lee.schermerhorn@hp.com, rientjes@google.com,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       "David S. Miller" <davem@davemloft.net>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Troels Liebe Bentsen <tlb@rapanden.dk>,
       linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 10:27 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Tue, 30 Mar 2010 18:22:58 -0400
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> On Wed, 31 Mar 2010 09:41:24 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>
>> > > With this fixed, the test for non-zero tsk->mm is't really needed in
>> > > do_exit(), is it?  I guess it makes sense though - sync_mm_rss() only
>> > > really works for kernel threads by luck..
>> >
>> > At first, I considered so, too. But I changed my mind to show
>> > "we know tsk->mm can be NULL here!" by code.
>> > Because __sync_mm_rss_stat() has BUG_ON(!mm), the code reader will think
>> > tsk->mm shouldn't be NULL always.
>> >
>> > Doesn't make sense ?
>>
>> uh, not really ;)
>>
>>
>> I think we should do this too:
>>
>> --- a/mm/memory.c~exit-fix-oops-in-sync_mm_rss-fix
>> +++ a/mm/memory.c
>> @@ -131,7 +131,6 @@ static void __sync_task_rss_stat(struct
>>
>>       for (i = 0; i < NR_MM_COUNTERS; i++) {
>>               if (task->rss_stat.count[i]) {
>> -                     BUG_ON(!mm);
>>                       add_mm_counter(mm, i, task->rss_stat.count[i]);
>>                       task->rss_stat.count[i] = 0;
>>               }
>> _
>>
>> Because we just made sure it can't happen, and if it _does_ happen, the
>> oops will tell us the samme thing that the BUG_ON() would have.
>>
>
> Hmm, then, finaly..
> ==
>
> task->rss_stat wasn't initialized to 0 at copy_process().
> And __sync_task_rss_stat() should be static.
> removed BUG_ON(!mm) in __sync_task_rss_stat() for avoiding to show
> wrong information to code readers. Anyway, if !mm && task->rss_stat
> has some value, panic will happen.
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>


-- 
Kind regards,
Minchan Kim
