Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab0IPOl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 10:41:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375Ab0IPOl2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 10:41:28 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Linux-Kernel <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] cfq: improve fsync performance for small files
References: <201007202209.04627.czoccolo@gmail.com>
	<AANLkTinajj76EBUQE6RXeQmZ9AEWU1g3x+pyW3Cmku0x@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 16 Sep 2010 10:34:49 -0400
In-Reply-To: <AANLkTinajj76EBUQE6RXeQmZ9AEWU1g3x+pyW3Cmku0x@mail.gmail.com>
	(Corrado Zoccolo's message of "Sun, 12 Sep 2010 16:40:49 +0200")
Message-ID: <x491v8tvjsm.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo <czoccolo@gmail.com> writes:

> Hi Jens,
> any comment on this patch, or the problem we are trying to solve?

Bueller?  Bueller?

>
> On Tue, Jul 20, 2010 at 10:09 PM, Corrado Zoccolo <czoccolo@gmail.com> wrote:
>> Fsync performance for small files achieved by cfq on high-end disks is
>> lower than what deadline can achieve, due to idling introduced between
>> the sync write happening in process context and the journal commit.
>>
>> Moreover, when competing with a sequential reader, a process writing
>> small files and fsync-ing them is starved.
>>
>> This patch fixes the two problems by:
>> - marking journal commits as WRITE_SYNC, so that they get the REQ_NOIDLE
>>  flag set,
>> - force all queues that have REQ_NOIDLE requests to be put in the noidle
>>  tree.
>>
>> Having the queue associated to the fsync-ing process and the one associated
>>  to journal commits in the noidle tree allows:
>> - switching between them without idling,
>> - fairness vs. competing idling queues, since they will be serviced only
>>  after the noidle tree expires its slice.
>>
>> Acked-by: Vivek Goyal <vgoyal@redhat.com>
>> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
>> Tested-by: Jeff Moyer <jmoyer@redhat.com>
>> Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
>> ---
>>  block/cfq-iosched.c |   18 ++++--------------
>>  fs/jbd/commit.c     |    2 +-
>>  fs/jbd2/commit.c    |    2 +-
>>  3 files changed, 6 insertions(+), 16 deletions(-)
>>
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index eb4086f..49dada4 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -216,7 +216,6 @@ struct cfq_data {
>>        enum wl_type_t serving_type;
>>        unsigned long workload_expires;
>>        struct cfq_group *serving_group;
>> -       bool noidle_tree_requires_idle;
>>
>>        /*
>>         * Each priority tree is sorted by next_request position.  These
>> @@ -2126,7 +2125,6 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
>>        slice = max_t(unsigned, slice, CFQ_MIN_TT);
>>        cfq_log(cfqd, "workload slice:%d", slice);
>>        cfqd->workload_expires = jiffies + slice;
>> -       cfqd->noidle_tree_requires_idle = false;
>>  }
>>
>>  static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd)
>> @@ -3108,7 +3106,9 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>>        if (cfqq->queued[0] + cfqq->queued[1] >= 4)
>>                cfq_mark_cfqq_deep(cfqq);
>>
>> -       if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
>> +       if (cfqq->next_rq && (cfqq->next_rq->cmd_flags & REQ_NOIDLE))
>> +               enable_idle = 0;
>> +       else if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
>>            (!cfq_cfqq_deep(cfqq) && CFQQ_SEEKY(cfqq)))
>>                enable_idle = 0;
>>        else if (sample_valid(cic->ttime_samples)) {
>> @@ -3421,17 +3421,7 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
>>                        cfq_slice_expired(cfqd, 1);
>>                else if (sync && cfqq_empty &&
>>                         !cfq_close_cooperator(cfqd, cfqq)) {
>> -                       cfqd->noidle_tree_requires_idle |=
>> -                               !(rq->cmd_flags & REQ_NOIDLE);
>> -                       /*
>> -                        * Idling is enabled for SYNC_WORKLOAD.
>> -                        * SYNC_NOIDLE_WORKLOAD idles at the end of the tree
>> -                        * only if we processed at least one !REQ_NOIDLE request
>> -                        */
>> -                       if (cfqd->serving_type == SYNC_WORKLOAD
>> -                           || cfqd->noidle_tree_requires_idle
>> -                           || cfqq->cfqg->nr_cfqq == 1)
>> -                               cfq_arm_slice_timer(cfqd);
>> +                       cfq_arm_slice_timer(cfqd);
>>                }
>>        }
>>
>> diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
>> index 28a9dda..d97a0c6 100644
>> --- a/fs/jbd/commit.c
>> +++ b/fs/jbd/commit.c
>> @@ -317,7 +317,7 @@ void journal_commit_transaction(journal_t *journal)
>>        int first_tag = 0;
>>        int tag_flag;
>>        int i;
>> -       int write_op = WRITE;
>> +       int write_op = WRITE_SYNC;
>>
>>        /*
>>         * First job: lock down the current transaction and wait for
>> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
>> index 75716d3..a078744 100644
>> --- a/fs/jbd2/commit.c
>> +++ b/fs/jbd2/commit.c
>> @@ -369,7 +369,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>>        int tag_bytes = journal_tag_bytes(journal);
>>        struct buffer_head *cbh = NULL; /* For transactional checksums */
>>        __u32 crc32_sum = ~0;
>> -       int write_op = WRITE;
>> +       int write_op = WRITE_SYNC;
>>
>>        /*
>>         * First job: lock down the current transaction and wait for
>> --
>> 1.6.2.5
>>
>>
>>
