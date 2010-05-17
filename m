Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab0EQL4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 07:56:45 -0400
Received: from smtp-out.google.com ([74.125.121.35]:44938 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab0EQL4n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 07:56:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=NEchILSlMMhDxN6f9sho/JwfazYScpELNt35rIj2afegZT6VIIYFzgNFfsk5cVLfb
	mekZQ1YUZadW053VYztVQ==
MIME-Version: 1.0
In-Reply-To: <20100517114605.GB5291@nowhere>
References: <4bf11ea4.dd29e30a.026d.4627@mx.google.com>
	 <20100517114605.GB5291@nowhere>
Date: Mon, 17 May 2010 13:56:38 +0200
Message-ID: <AANLkTil2QBjH2qvnH7VKrg6s7RcKvHC1m0HZkDVDPzv5@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix errors path in perf_output_begin()
From: Stephane Eranian <eranian@google.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, acme@infradead.org,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 1:46 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Mon, May 17, 2010 at 12:46:01PM +0200, Stephane Eranian wrote:
>>   In case the sampling buffer has no "payload" pages, nr_pages is 0.
>>   The problem is that the error path in perf_output_begin() skips to
>>   a label which assumes perf_output_lock() has been issued which is
>>   not the case. That triggers a WARN_ON() is perf_output_unlock().
>>
>>   This patch fixes the problem by adding a new label and skipping
>>   perf_task_unlock() in case data->nr_pages is 0.
>>
>>   Signed-off-by: Stephane Eranian <eranian@google.com>
>>
>> --
>> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
>> index a4fa381..95137b6 100644
>> --- a/kernel/perf_event.c
>> +++ b/kernel/perf_event.c
>> @@ -3035,8 +3035,10 @@ int perf_output_begin(struct perf_output_handle *handle,
>>       handle->nmi     = nmi;
>>       handle->sample  = sample;
>>
>> -     if (!data->nr_pages)
>> -             goto fail;
>> +     if (!data->nr_pages) {
>> +             atomic_inc(&data->lost);
>> +             goto out;
>> +     }
>
>
>
> Oh indeed, handle->lock is in a random state.
> Whatever its value we have an unbalanced put_cpu()
> anyway.
>
Yes, I caught this problem while debugging the perf record -c
issue.

> And we don't race with someone else, data->lock = -1
> and will then warn.
>
> I just have a tiny doubt: should we really count this
> path to the lost events? I'm not sure when we can have
> data->nr_pages == 0, does this happen if we mmap after
> enabling the event?
>
Well, nr_pages = 0 means all you have is the sampling buffer
header page. You cannot save any sample, so you  actually
loose everything. Perf reports a dozen samples but those
are synthetic. The kernel cannot reject an mmap() for
just one page because of the remapped counters, thus it
has to handle this gracefully and at least report the lost
samples.

> All I know is that I observed I already lost events in
> this path using perf lock.
>
