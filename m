Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab1HKTvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 15:51:36 -0400
Received: from smtp-out.google.com ([216.239.44.51]:21720 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab1HKTve convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 15:51:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=E9NW+bHBF/6KHgOpJLvOCPlujEInn7SzOaYT/g4YxY5kpFnnIkwe/67Hd+uqfDmX4
	E0nd/NGymx7Rb1KB+eO6A==
MIME-Version: 1.0
In-Reply-To: <1313091791.8491.33.camel@twins>
References: <1312999364-21104-1-git-send-email-zakmagnus@chromium.org>
	<1312999364-21104-2-git-send-email-zakmagnus@chromium.org>
	<1313091791.8491.33.camel@twins>
Date: Thu, 11 Aug 2011 12:51:30 -0700
X-Google-Sender-Auth: DrG5q2Q9iRLJxuM9kFHeraPHjKY
Message-ID: <CAAuSN92aJ2unHgSDi-385ejbEsRHTavxi11cnL_z806a6Z+FZw@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] Output stall data in debugfs
From: Alex Neronskiy <zakmagnus@chromium.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Don Zickus <dzickus@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Alex Neronskiy <zakmagnus@chromium.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 12:43 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> zakmagnus seems to bounce, so who am I talking to anyway..
>
> On Thu, 2011-08-11 at 21:35 +0200, Peter Zijlstra wrote:
>>
>> static void show_stall_trace(struct seq_file *f, void *v)
>> {
>>         struct stall *s = f->private;
>>         int i, idx = ACCESS_ONCE(s->idx);
>>
>>         mutex_lock(&stall_mutex);
>>
>>         raw_spin_lock(&s->lock[idx]);
>>         seq_printf(f, "stall: %d\n", s->worst);
>>         for (i = 0; i < s->trace[idx].nr_entries; i++) {
>>                 seq_printf(f, "[<%pK>] %pS\n",
>>                         (void *)s->trace->entries[i],
>>                         (void *)s->trace->entries[i]);
>>         }
>>         raw_spin_unlock(&s->lock[idx]);
>>
>>         mutex_unlock(&stall_mutex);
>> }
>>
>>
>> Yes its racy on s->worst, but who cares (if you do care you can keep a
>> copy in s->delay[idx] or so). Also, it might be better to not do the
>> spinlock but simply use an atomic bitop to set an in-use flag, there is
>> no reason to disable preemption over the seq_printf() loop.
>
> That also cures another problem you have, a seq_file buffer is only 1
> page large, you should be using the seqfile iterator interface and print
> one line at a time.. now clearly that won't work with preemption
> disabled either.
I didn't want to hold on to a lock while the lines were iterated over,
and instead just dump it in one go. I guess it's not a big deal to do
that, though. Nonetheless, is one page not enough?
