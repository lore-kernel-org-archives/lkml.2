Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab0EQL5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 07:57:31 -0400
Received: from smtp-out.google.com ([74.125.121.35]:45113 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab0EQL53 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 07:57:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Sj0qv3Bo0q1xaHrPitwF/ppwtTt3RHmh4xAhgfDBJGal6Bossk9hoqm8ABfb3iG1w
	7I171UNhU/ZqBsI0Aer2w==
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1005171303260.21420@localhost.localdomain>
References: <4bf11ea4.dd29e30a.026d.4627@mx.google.com>
	 <alpine.LFD.2.00.1005171303260.21420@localhost.localdomain>
Date: Mon, 17 May 2010 13:57:25 +0200
Message-ID: <AANLkTinvvU2G-KxSK6cAU-fYQyCF1m_5i282oq8rbJ8-@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix errors path in perf_output_begin()
From: Stephane Eranian <eranian@google.com>
To: John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       acme@infradead.org, perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 1:04 PM, John Kacur <jkacur@redhat.com> wrote:
>
>
> On Mon, 17 May 2010, Stephane Eranian wrote:
>
>>   In case the sampling buffer has no "payload" pages, nr_pages is 0.
>>   The problem is that the error path in perf_output_begin() skips to
>>   a label which assumes perf_output_lock() has been issued which is
>>   not the case. That triggers a WARN_ON() is perf_output_unlock().
>>
>>   This patch fixes the problem by adding a new label and skipping
>>   perf_task_unlock() in case data->nr_pages is 0.
>
> It does? Your code looks good to me, but the description above is
> a little flawed, since no new label is added.
>
Sorry about that. I had written the text before the final version of the patch!
I will resubmit.

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
>>
>>       have_lost = atomic_read(&data->lost);
>>       if (have_lost)
>> --
>
