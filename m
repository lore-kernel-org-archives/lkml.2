Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab1BOBo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 20:44:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50116 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab1BOBoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 20:44:54 -0500
Message-ID: <4D59DA8C.9020108@cn.fujitsu.com>
Date: Tue, 15 Feb 2011 09:44:44 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Justin TerAvest <teravest@google.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        Chad Talbott <ctalbott@google.com>, Divyesh Shah <dpshah@google.com>
Subject: Re: [PATCH 3/6 v4] cfq-iosched: Introduce vdisktime and io weight
 for CFQ queue
References: <4D51ED26.8050809@cn.fujitsu.com> <4D539804.9090308@cn.fujitsu.com> <AANLkTimi=7_CEJy2m6Dhcy-aszXKBBL0fbC8mbD9JLOP@mail.gmail.com>
In-Reply-To: <AANLkTimi=7_CEJy2m6Dhcy-aszXKBBL0fbC8mbD9JLOP@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-15 09:43:53,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-15 09:43:57,
	Serialize complete at 2011-02-15 09:43:57
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin TerAvest wrote:
> On Wed, Feb 9, 2011 at 11:47 PM, Gui Jianfeng
> <guijianfeng@cn.fujitsu.com> wrote:
>> Introduce vdisktime and io weight for CFQ queue scheduling. Currently, io priority
>> maps to a range [100,1000]. It also gets rid of cfq_slice_offset() logic and makes
>> use the same scheduling algorithm as CFQ group does. This helps for CFQ queue and
>> group scheduling on the same service tree.
> 
> Hi Gui,
> I have a couple of questions inline.
> 
> Thanks,
> Justin
> 
>> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
>> ---
>>  block/cfq-iosched.c |  219 +++++++++++++++++++++++++++++++++++++++------------
>>  1 files changed, 167 insertions(+), 52 deletions(-)
>>
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index f3a126e..41cef2e 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -39,6 +39,13 @@ static const int cfq_hist_divisor = 4;
>>  */
>>  #define CFQ_IDLE_DELAY         (HZ / 5)
>>
>> +/*
>> + * The base boosting value.
>> + */
>> +#define CFQ_BOOST_SYNC_BASE          (HZ / 10)
>> +#define CFQ_BOOST_ASYNC_BASE          (HZ / 25)
>> +
>> +
>>  /*
>>  * below this threshold, we consider thinktime immediate
>>  */
>> @@ -99,10 +106,7 @@ struct cfq_entity {
>>        struct cfq_rb_root *service_tree;
>>        /* service_tree member */
>>        struct rb_node rb_node;
>> -       /* service_tree key, represent the position on the tree */
>> -       unsigned long rb_key;
>> -
>> -       /* group service_tree key */
>> +       /* service_tree key */
>>        u64 vdisktime;
>>        bool is_group_entity;
>>        unsigned int weight;
>> @@ -114,6 +118,8 @@ struct cfq_entity {
>>  struct cfq_queue {
>>        /* The schedule entity */
>>        struct cfq_entity cfqe;
>> +       /* Reposition time */
>> +       unsigned long reposition_time;
> 
> Can this be addition time or something else instead? This is set, even
> when we are not repositioning among service trees.

Hi Justin,

how about position_time :)

> 
>>        /* reference count */
>>        int ref;
>>        /* various state flags, see below */
>> @@ -312,6 +318,24 @@ struct cfq_data {
>>        struct rcu_head rcu;
>>  };
>>
>> +/*
>> + * Map io priority(7 ~ 0) to io weight(100 ~ 1000) as follows
>> + *     prio       0    1     2    3    4    5    6     7
>> + *     weight  1000  868   740  612  484  356  228   100
>> + */
>> +static inline unsigned int cfq_prio_to_weight(unsigned short ioprio)
>> +{
>> +       unsigned int step;
>> +
>> +       BUG_ON(ioprio >= IOPRIO_BE_NR);
>> +
>> +       step = (BLKIO_WEIGHT_MAX - BLKIO_WEIGHT_MIN) / (IOPRIO_BE_NR - 1);
>> +       if (ioprio == 0)
>> +               return BLKIO_WEIGHT_MAX;
>> +
>> +       return BLKIO_WEIGHT_MIN + (IOPRIO_BE_NR - ioprio - 1) * step;
>> +}
>> +
>>  static inline struct cfq_queue *
>>  cfqq_of_entity(struct cfq_entity *cfqe)
>>  {
>> @@ -840,16 +864,6 @@ cfq_find_next_rq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>>        return cfq_choose_req(cfqd, next, prev, blk_rq_pos(last));
>>  }
>>
>> -static unsigned long cfq_slice_offset(struct cfq_data *cfqd,
>> -                                     struct cfq_queue *cfqq)
>> -{
>> -       /*
>> -        * just an approximation, should be ok.
>> -        */
>> -       return (cfqq->cfqg->nr_cfqq - 1) * (cfq_prio_slice(cfqd, 1, 0) -
>> -                      cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio));
>> -}
>> -
>>  static inline s64
>>  entity_key(struct cfq_rb_root *st, struct cfq_entity *entity)
>>  {
>> @@ -1199,6 +1213,21 @@ static inline void cfq_put_cfqg(struct cfq_group *cfqg) {}
>>
>>  #endif /* GROUP_IOSCHED */
>>
>> +static inline u64 cfq_get_boost(struct cfq_data *cfqd,
>> +                                struct cfq_queue *cfqq)
>> +{
>> +       u64 d;
>> +
>> +       if (cfq_cfqq_sync(cfqq))
>> +               d = CFQ_BOOST_SYNC_BASE << CFQ_SERVICE_SHIFT;
>> +       else
>> +               d = CFQ_BOOST_ASYNC_BASE << CFQ_SERVICE_SHIFT;
>> +
>> +       d = d * BLKIO_WEIGHT_DEFAULT;
>> +       do_div(d, cfqq->cfqe.weight);
>> +       return d;
>> +}
> 
> The logic for cfq_get_boost() looks a lot like cfq_scale_slice().
> Instead of duplicating code, can't it just be
> u64 d;
> if (cfq_cfqq_sync(cfqq))
>         return cfq_scale_slice(CFQ_BOOST_SYNC_BASE, cfqq->cfqe);
> else
>         return cfq_scale_slice(CFQ_BOOST_ASYNC_BASE, cfqq->cfqe);
> 

Ok, I think this should work.

> 
>> +
>>  /*
>>  * The cfqd->service_trees holds all pending cfq_queue's that have
...

> I'm confused by this line. Why are we doing some adjustment for cfqe
> weight that we weren't doing previously? I think
> cfq_group_service_tree_add below will still do the total_weight
> adjustment.

later patch does the integration for cfqq and cfqg.

Thanks,
Gui

> 
>> +       cfqq->reposition_time = jiffies;
>>        if ((add_front || !new_cfqq) && !group_changed)
>>                return;
>>        cfq_group_service_tree_add(cfqd, cfqq->cfqg);
>> @@ -1414,14 +1481,18 @@ static void cfq_add_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>>  static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>>  {
