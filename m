Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab0DLShu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 14:37:50 -0400
Received: from smtp-out.google.com ([74.125.121.35]:26786 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab0DLShp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 14:37:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=BLP3HcN8d2EreCcCAsQjYErDDIL0qCWbhWgckwW8fTVHJghHUouCiuTSdsP02QncO
	3+tKwPwmCI+ULvtbQ8Krw==
MIME-Version: 1.0
In-Reply-To: <20100412143015.GC1294@redhat.com>
References: <20100410023509.17767.21937.stgit@austin.mtv.corp.google.com> 
	<20100412143015.GC1294@redhat.com>
From: Divyesh Shah <dpshah@google.com>
Date: Mon, 12 Apr 2010 11:37:22 -0700
Message-ID: <g2kaf41c7c41004121137l23f8c87fh19129dc483a6712@mail.gmail.com>
Subject: Re: [PATCH] blkio: Changes to more io-controller stats patches to 
	address
To: Vivek Goyal <vgoyal@redhat.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, nauman@google.com,
       ctalbott@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 7:30 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Apr 09, 2010 at 07:35:35PM -0700, Divyesh Shah wrote:
>> review comments.
>>
>> Changelog: (in response to Vivek Goyal's comments)
>> o group blkiocg_update_blkio_group_dequeue_stats() with other DEBUG functions
>> o rename blkiocg_update_set_active_queue_stats() to
>>   blkiocg_update_avg_queue_size_stats()
>> o s/request/io/ in blkiocg_update_request_add_stats() and
>>   blkiocg_update_request_remove_stats()
>> o Call cfq_del_timer() at request dispatch() instead of
>>   blkiocg_update_idle_time_stats()
>>
>> Signed-off-by: Divyesh Shah<dpshah@google.com>
>> ---
>>
>
> [..]
>> @@ -2395,11 +2395,7 @@ static int cfq_dispatch_requests(struct request_queue *q, int force)
>>       }
>>
>>       cfq_log_cfqq(cfqd, cfqq, "dispatched a request");
>> -     /*
>> -      * This is needed since we don't exactly match the mod_timer() and
>> -      * del_timer() calls in CFQ.
>> -      */
>> -     blkiocg_update_idle_time_stats(&cfqq->cfqg->blkg);
>> +     cfq_del_timer(cfqd, cfqq);
>
> I am trying to think that why do we need this call here. What is that path
> which does not delete the timer upon receiving request and lets fix that.
>
> One of the possible path when you got the request but still leave the
> timer on is following.
>
> cfq_rq_enqueued()
>        if(request_not_big_enough)
>                leave_timer_on
>                cfq_mark_cfqq_must_dispatch(cfqq);
>
> I guess we need to leave timer on so that if an unplug does not come in, a
> timer expirty will dispatch the request from the queue.
>
> In this case we can probably call here blkiocg_update_idle_time_stats()
> directly. Anyway, that's the right thing to do otherwise our idle time
> stats are little wrong as we got a request from the application and idle
> timer is over. Now this is additional wait time enforced by cfq so that
> lots of small requests are not dispatched to disk.

Good point. Will send an updated version of this patch.

>
> Thanks
> Vivek
>
