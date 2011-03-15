Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab1COD16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 23:27:58 -0400
Received: from smtp-out.google.com ([74.125.121.67]:46194 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab1COD14 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 23:27:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=pTkiX6hgdLwqzCmWG9Hbt2tCE0QlYseNrjtb1yZA+YdflO9bSyAdRWZ454ELQbYV7C
         S7YCiViGFL27I1wb5eyA==
MIME-Version: 1.0
In-Reply-To: <20110314211002.GD4998@quack.suse.cz>
References: <1299869011-26152-1-git-send-email-gthelen@google.com>
 <1299869011-26152-9-git-send-email-gthelen@google.com> <20110314175408.GE31120@redhat.com>
 <20110314211002.GD4998@quack.suse.cz>
From: Greg Thelen <gthelen@google.com>
Date: Mon, 14 Mar 2011 20:27:33 -0700
Message-ID: <AANLkTikCt90o2qRV=0cJijtnA_W44dcUCBOmZ53Biv07@mail.gmail.com>
Subject: Re: [PATCH v6 8/9] memcg: check memcg dirty limits in page writeback
To: Jan Kara <jack@suse.cz>
Cc: Vivek Goyal <vgoyal@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, linux-fsdevel@vger.kernel.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Chad Talbott <ctalbott@google.com>,
        Justin TerAvest <teravest@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 2:10 PM, Jan Kara <jack@suse.cz> wrote:
> On Mon 14-03-11 13:54:08, Vivek Goyal wrote:
>> On Fri, Mar 11, 2011 at 10:43:30AM -0800, Greg Thelen wrote:
>> > If the current process is in a non-root memcg, then
>> > balance_dirty_pages() will consider the memcg dirty limits as well as
>> > the system-wide limits.  This allows different cgroups to have distinct
>> > dirty limits which trigger direct and background writeback at different
>> > levels.
>> >
>> > If called with a mem_cgroup, then throttle_vm_writeout() queries the
>> > given cgroup for its dirty memory usage limits.
>> >
>> > Signed-off-by: Andrea Righi <arighi@develer.com>
>> > Signed-off-by: Greg Thelen <gthelen@google.com>
>> > Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> > Acked-by: Wu Fengguang <fengguang.wu@intel.com>
>> > ---
>> > Changelog since v5:
>> > - Simplified this change by using mem_cgroup_balance_dirty_pages() rather than
>> >   cramming the somewhat different logic into balance_dirty_pages().  This means
>> >   the global (non-memcg) dirty limits are not passed around in the
>> >   struct dirty_info, so there's less change to existing code.
>>
>> Yes there is less change to existing code but now we also have a separate
>> throttlig logic for cgroups.
>>
>> I thought that we are moving in the direction of IO less throttling
>> where bdi threads always do the IO and Jan Kara also implemented the
>> logic to distribute the finished IO pages uniformly across the waiting
>> threads.
>  Yes, we'd like to avoid doing IO from balance_dirty_pages(). But if the
> logic in cgroups specific part won't get too fancy (which it doesn't seem
> to be the case currently), it shouldn't be too hard to convert it to the new
> approach.

Handling memcg hierarchy was something that was not trivial to implement in
mem_cgroup_balance_dirty_pages.

> We can talk about it at LSF but at least with my approach to IO-less
> balance_dirty_pages() it would be easy to convert cgroups throttling to
> the new way. With Fengguang's approach it might be a bit harder since he
> computes a throughput and from that necessary delay for a throttled task
> but with cgroups that is impossible to compute so he'd have to add some
> looping if we didn't write enough pages from the cgroup yet. But still it
> would be reasonable doable AFAICT.

I am definitely interested in finding a way to merge these feature
cleanly together.

>> Keeping it separate for cgroups, reduces the complexity but also forks
>> off the balancing logic for root and other cgroups. So if Jan Kara's
>> changes go in, it automatically does not get used for memory cgroups.
>>
>> Not sure how good a idea it is to use a separate throttling logic for
>> for non-root cgroups.
>  Yeah, it looks a bit odd. I'd think that we could just cap
> task_dirty_limit() by a value computed from a cgroup limit and be done
> with that but I probably miss something...

That is an interesting idea.  When looking at upstream balance_dirty_pages(),
the result of task_dirty_limit() is compared per bdi_nr_reclaimable and
bdi_nr_writeback.  I think we should be comparing memcg usage to memcg limits
to catch cases where memcg usage is above memcg limits.
Or am I missing something in your apporach?

> Sure there is also a different
> background limit but that's broken anyway because a flusher thread will
> quickly stop doing writeback if global background limit is not exceeded.
> But that's a separate topic so I'll reply with this to a more appropriate
> email ;)

;)  I am also interested in the this bg issue, but I should also try
to stay on topic.

>                                                                Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
