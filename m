Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab1BHWVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 17:21:43 -0500
Received: from smtp-out.google.com ([74.125.121.67]:5057 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab1BHWVm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 17:21:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=uTIk8ehYYOoeO5zI5ijkzRl7KqBQOU9ecUVrAj45YdBVCcDr81tUzRYz5jd6XURCey
         UX6+J0C2zzHTa/Rdyt4g==
MIME-Version: 1.0
In-Reply-To: <20110208194826.GC29081@redhat.com>
References: <1297192697-29978-1-git-send-email-teravest@google.com> <20110208194826.GC29081@redhat.com>
From: Justin TerAvest <teravest@google.com>
Date: Tue, 8 Feb 2011 14:21:18 -0800
Message-ID: <AANLkTimawcpJRFPW5kKdZtKQ_PvKHc6oFSOVAcqy39Y9@mail.gmail.com>
Subject: Re: [PATCH] Don't wait if queue already has requests.
To: Vivek Goyal <vgoyal@redhat.com>
Cc: jaxboe@fusionio.com, ctalbott@google.com, mrubin@google.com,
        jmoyer@redhat.com, guijianfeng@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 8, 2011 at 11:48 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Feb 08, 2011 at 11:18:17AM -0800, Justin TerAvest wrote:
>> Commit 7667aa0630407bc07dc38dcc79d29cc0a65553c1 added logic to wait for
>> the last queue of the group to become busy (have at least one request),
>> so that the group does not lose out for not being continuously
>> backlogged. The commit did not check for the condition that the last
>> queue already has some requests. As a result, if the queue already has
>> requests, wait_busy is set. Later on, cfq_select_queue() checks the
>> flag, and decides that since the queue has a request now and wait_busy
>> is set, the queue is expired.  This results in early expiration of the
>> queue.
>
> Hi Justin,
>
> wait_busy will be set only if slice has expired or about to be expired. So
> even if we are setting wait_busy flag, it is not a huge deal even if
> select_queue() expires it? Anyway queue has consumed or almost consumed
> its allocated slice?

Correct, the queue will have consumed or almost consumed its allocated
slice. However, this must be happening often enough because there is a
measurable impact in our testing.

>
> Having said that, it does not make sense to set wait_busy flag if
> cfqq has requests. So I would be fine with the patch. I am just
> curious that how did you see a difference in practice.

In practice,
  - We see some better isolation between tasks with this patch alone
(Possibly those writes are getting marked SYNC somehow, or it's
another timing change)
  - With other patches that introduce isolation between buffered
writes, we see that isolation works better, especially for cgroups
with small weights.

>
>>
>> This patch fixes the problem by adding a check to see if queue already
>> has requests. If it does, wait_busy is not set. As a result, time slices
>> do not expire early.
>>
>> The queues with more than one request are usually buffered writers.
>> Testing shows improvement in isolation between buffered writers.
>
> Upstream code puts all the buffered WRITES in root cgroup. So there
> is no isolation between buffered WRITES?

This was a mistake on my part, we have other patches that add
isolation between buffered writes; I just took this one out of order.
If you'd like, we can hold on this patch for now and I can resend this
later, but I think the actual patch itself is still good.

My apologies for the confusion.

Thanks,
Justin

>
> Thanks
> Vivek
>
>>
>> Signed-off-by: Justin TerAvest <teravest@google.com>
>> ---
>>  block/cfq-iosched.c |    4 ++++
>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index 501ffdf..5dcc353 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -3432,6 +3432,10 @@ static bool cfq_should_wait_busy(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>>  {
>>       struct cfq_io_context *cic = cfqd->active_cic;
>>
>> +     /* If the queue already has requests, don't wait */
>> +     if (!RB_EMPTY_ROOT(&cfqq->sort_list))
>> +             return false;
>> +
>>       /* If there are other queues in the group, don't wait */
>>       if (cfqq->cfqg->nr_cfqq > 1)
>>               return false;
>> --
>> 1.7.3.1
>
