Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab1HKUKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 16:10:52 -0400
Received: from smtp-out.google.com ([216.239.44.51]:30568 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab1HKUKv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 16:10:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=Gs+2uFTXVyTVCbFH8pnwevry1WZwrK9s5vFPg0ZsJwQqZB+yeqwvZdbd3wXc6c/bp
	Go+v10rDowGnj3FKYdQcA==
MIME-Version: 1.0
In-Reply-To: <1313091323.8491.30.camel@twins>
References: <1312999364-21104-1-git-send-email-zakmagnus@chromium.org>
	<1312999364-21104-2-git-send-email-zakmagnus@chromium.org>
	<1313091323.8491.30.camel@twins>
Date: Thu, 11 Aug 2011 13:10:48 -0700
X-Google-Sender-Auth: RK6dYcCMNngn1L6r-8Zw5rq06Do
Message-ID: <CAAuSN90BtbRaqkde0iKNQJvpa22AeKJLfyjO6NYqc3kdhqHXtg@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] Output stall data in debugfs
From: Alex Neronskiy <zakmagnus@chromium.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Don Zickus <dzickus@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please don't send email to zakmagnus@chromium.com. That does not
exist. The correct address is zakmagnus@chromium.org. I messed up my
own email address somewhere somehow.

On Thu, Aug 11, 2011 at 12:35 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2011-08-10 at 11:02 -0700, Alex Neronskiy wrote:
>> @@ -210,22 +236,27 @@ void touch_softlockup_watchdog_sync(void)
>>  /* watchdog detector functions */
>>  static void update_hardstall(unsigned long stall, int this_cpu)
>>  {
>>         if (stall > hardstall_thresh && stall > worst_hardstall) {
>>                 unsigned long flags;
>> +               spin_lock_irqsave(&hardstall_write_lock, flags);
>> +               if (stall > worst_hardstall) {
>> +                       int write_ind = hard_read_ind;
>> +                       int locked = spin_trylock(&hardstall_locks[write_ind]);
>> +                       /* cannot wait, so if there's contention,
>> +                        * switch buffers */
>> +                       if (!locked)
>> +                               write_ind = !write_ind;
>> +
>>                         worst_hardstall = stall;
>> +                       hardstall_traces[write_ind].nr_entries = 0;
>> +                       save_stack_trace(&hardstall_traces[write_ind]);
>>
>> +                       /* tell readers to use the new buffer from now on */
>> +                       hard_read_ind = write_ind;
>> +                       if (locked)
>> +                               spin_unlock(&hardstall_locks[write_ind]);
>> +               }
>> +               spin_unlock_irqrestore(&hardstall_write_lock, flags);
>>         }
>>  }
>
> That must be the most convoluted locking I've seen in a while.. OMG!
>
> What's wrong with something like:
>
> static void update_stall(struct stall *s, unsigned long stall)
> {
>        if (stall <= s->worst)
>                return;
>
> again:
>        if (!raw_spin_trylock(&s->lock[s->idx])) {
>                s->idx ^= 1;
>                goto again;
>        }
>
>        if (stall <= s->worst)
>                goto unlock;
>
>        s->worst = stall;
>        s->trace[s->idx].nr_entries = 0;
>        save_stack_trace(&s->trace[s->idx]);
>
> unlock:
>        raw_spin_unlock(&s->lock[s->idx]);
> }
>
>
> And have your read side do:
>
>
> static void show_stall_trace(struct seq_file *f, void *v)
> {
>        struct stall *s = f->private;
>        int i, idx = ACCESS_ONCE(s->idx);
>
>        mutex_lock(&stall_mutex);
>
>        raw_spin_lock(&s->lock[idx]);
>        seq_printf(f, "stall: %d\n", s->worst);
>        for (i = 0; i < s->trace[idx].nr_entries; i++) {
>                seq_printf(f, "[<%pK>] %pS\n",
>                        (void *)s->trace->entries[i],
>                        (void *)s->trace->entries[i]);
>        }
>        raw_spin_unlock(&s->lock[idx]);
>
>        mutex_unlock(&stall_mutex);
> }
>
>
> Yes its racy on s->worst, but who cares (if you do care you can keep a
> copy in s->delay[idx] or so). Also, it might be better to not do the
> spinlock but simply use an atomic bitop to set an in-use flag, there is
> no reason to disable preemption over the seq_printf() loop.
One change here is to use raw_spin functions. Okay, sure. Another is
to use a mutex instead of a spinlock among the readers. Makes a lot of
sense.

Another change is to allow concurrent writers. The readers are
serialized but the writers are concurrent; isn't that a strange
design? The way the "main" index is changed also looks problematic. A
writer will switch the index before anything useful is even known to
be in the buffer, and then a reader can go ahead and get that lock and
read something potentially very old and misleading. I don't think
that's okay.
