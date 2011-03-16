Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab1CPBCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 21:02:46 -0400
Received: from smtp-out.google.com ([74.125.121.67]:60666 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1CPBCo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 21:02:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ZrXtBd9DoSSnml/cvMU3m3cFw0736MA9YJ1IrvfsVD4L4Rp1kuBaHz/wOuYSR87rt2
         8+juY4BNxnH4tO9FQQOg==
MIME-Version: 1.0
In-Reply-To: <20110315225409.GD5740@redhat.com>
References: <1299869011-26152-1-git-send-email-gthelen@google.com>
 <1299869011-26152-10-git-send-email-gthelen@google.com> <20110315225409.GD5740@redhat.com>
From: Greg Thelen <gthelen@google.com>
Date: Tue, 15 Mar 2011 18:00:16 -0700
Message-ID: <AANLkTin=N8PDK7Z4xke3M01FY0scEBx_NMGx0GC2S+ro@mail.gmail.com>
Subject: Re: [PATCH v6 9/9] memcg: make background writeback memcg aware
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        linux-fsdevel@vger.kernel.org, Andrea Righi <arighi@develer.com>,
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

On Tue, Mar 15, 2011 at 3:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Mar 11, 2011 at 10:43:31AM -0800, Greg Thelen wrote:
>> Add an memcg parameter to bdi_start_background_writeback().  If a memcg
>> is specified then the resulting background writeback call to
>> wb_writeback() will run until the memcg dirty memory usage drops below
>> the memcg background limit.  This is used when balancing memcg dirty
>> memory with mem_cgroup_balance_dirty_pages().
>>
>> If the memcg parameter is not specified, then background writeback runs
>> globally system dirty memory usage falls below the system background
>> limit.
>>
>> Signed-off-by: Greg Thelen <gthelen@google.com>
>> ---
>
> [..]
>> -static inline bool over_bground_thresh(void)
>> +static inline bool over_bground_thresh(struct mem_cgroup *mem_cgroup)
>>  {
>>       unsigned long background_thresh, dirty_thresh;
>>
>> +     if (mem_cgroup) {
>> +             struct dirty_info info;
>> +
>> +             if (!mem_cgroup_hierarchical_dirty_info(
>> +                         determine_dirtyable_memory(), false,
>> +                         mem_cgroup, &info))
>> +                     return false;
>> +
>> +             return info.nr_file_dirty +
>> +                     info.nr_unstable_nfs > info.background_thresh;
>> +     }
>> +
>>       global_dirty_limits(&background_thresh, &dirty_thresh);
>>
>>       return (global_page_state(NR_FILE_DIRTY) +
>> @@ -683,7 +694,8 @@ static long wb_writeback(struct bdi_writeback *wb,
>>                * For background writeout, stop when we are below the
>>                * background dirty threshold
>>                */
>> -             if (work->for_background && !over_bground_thresh())
>> +             if (work->for_background &&
>> +                 !over_bground_thresh(work->mem_cgroup))
>>                       break;
>>
>>               wbc.more_io = 0;
>> @@ -761,23 +773,6 @@ static unsigned long get_nr_dirty_pages(void)
>>               get_nr_dirty_inodes();
>>  }
>>
>> -static long wb_check_background_flush(struct bdi_writeback *wb)
>> -{
>> -     if (over_bground_thresh()) {
>> -
>> -             struct wb_writeback_work work = {
>> -                     .nr_pages       = LONG_MAX,
>> -                     .sync_mode      = WB_SYNC_NONE,
>> -                     .for_background = 1,
>> -                     .range_cyclic   = 1,
>> -             };
>> -
>> -             return wb_writeback(wb, &work);
>> -     }
>> -
>> -     return 0;
>> -}
>> -
>>  static long wb_check_old_data_flush(struct bdi_writeback *wb)
>>  {
>>       unsigned long expired;
>> @@ -839,15 +834,17 @@ long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
>>                */
>>               if (work->done)
>>                       complete(work->done);
>> -             else
>> +             else {
>> +                     if (work->mem_cgroup)
>> +                             mem_cgroup_bg_writeback_done(work->mem_cgroup);
>>                       kfree(work);
>> +             }
>>       }
>>
>>       /*
>>        * Check for periodic writeback, kupdated() style
>>        */
>>       wrote += wb_check_old_data_flush(wb);
>> -     wrote += wb_check_background_flush(wb);
>
> Hi Greg,
>
> So in the past we will leave the background work unfinished and try
> to finish queued work first.
>
> I see following line in wb_writeback().
>
>                /*
>                 * Background writeout and kupdate-style writeback may
>                 * run forever. Stop them if there is other work to do
>                 * so that e.g. sync can proceed. They'll be restarted
>                 * after the other works are all done.
>                 */
>                if ((work->for_background || work->for_kupdate) &&
>                    !list_empty(&wb->bdi->work_list))
>                        break;
>
> Now you seem to have converted background writeout also as queued
> work item. So it sounds wb_writebac() will finish that background
> work early and never take it up and finish other queued items. So
> we might finish queued items still flusher thread might exit
> without bringing down the background ratio of either root or memcg
> depending on the ->mem_cgroup pointer.
>
> May be requeuing the background work at the end of list might help.

Good catch!  I agree that an interrupted queued bg writeback work item
should be requeued to the tail.

> Thanks
> Vivek
