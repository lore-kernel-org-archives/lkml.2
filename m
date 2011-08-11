Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab1HKTgE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 15:36:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:34586 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab1HKTgD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 15:36:03 -0400
Subject: Re: [PATCH v6 2/2] Output stall data in debugfs
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Neronskiy <zakmagnus@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Don Zickus <dzickus@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Alex Neronskiy <zakmagnus@chromium.com>
Date: Thu, 11 Aug 2011 21:35:22 +0200
In-Reply-To: <1312999364-21104-2-git-send-email-zakmagnus@chromium.org>
References: <1312999364-21104-1-git-send-email-zakmagnus@chromium.org>
	 <1312999364-21104-2-git-send-email-zakmagnus@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1313091323.8491.30.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 11:02 -0700, Alex Neronskiy wrote:
> @@ -210,22 +236,27 @@ void touch_softlockup_watchdog_sync(void)
>  /* watchdog detector functions */
>  static void update_hardstall(unsigned long stall, int this_cpu)
>  {
>         if (stall > hardstall_thresh && stall > worst_hardstall) {
>                 unsigned long flags;
> +               spin_lock_irqsave(&hardstall_write_lock, flags);
> +               if (stall > worst_hardstall) {
> +                       int write_ind = hard_read_ind;
> +                       int locked = spin_trylock(&hardstall_locks[write_ind]);
> +                       /* cannot wait, so if there's contention,
> +                        * switch buffers */
> +                       if (!locked)
> +                               write_ind = !write_ind;
> +
>                         worst_hardstall = stall;
> +                       hardstall_traces[write_ind].nr_entries = 0;
> +                       save_stack_trace(&hardstall_traces[write_ind]);
>  
> +                       /* tell readers to use the new buffer from now on */
> +                       hard_read_ind = write_ind;
> +                       if (locked)
> +                               spin_unlock(&hardstall_locks[write_ind]);
> +               }
> +               spin_unlock_irqrestore(&hardstall_write_lock, flags);
>         }
>  } 

That must be the most convoluted locking I've seen in a while.. OMG!

What's wrong with something like:

static void update_stall(struct stall *s, unsigned long stall)
{
	if (stall <= s->worst)
		return;

again:
	if (!raw_spin_trylock(&s->lock[s->idx])) {
		s->idx ^= 1;
		goto again;
	}

	if (stall <= s->worst)
		goto unlock;

	s->worst = stall;
	s->trace[s->idx].nr_entries = 0;
	save_stack_trace(&s->trace[s->idx]);

unlock:
	raw_spin_unlock(&s->lock[s->idx]);
}


And have your read side do:


static void show_stall_trace(struct seq_file *f, void *v)
{
	struct stall *s = f->private;
	int i, idx = ACCESS_ONCE(s->idx);

	mutex_lock(&stall_mutex);

	raw_spin_lock(&s->lock[idx]);
	seq_printf(f, "stall: %d\n", s->worst);
	for (i = 0; i < s->trace[idx].nr_entries; i++) {
		seq_printf(f, "[<%pK>] %pS\n", 
			(void *)s->trace->entries[i],
			(void *)s->trace->entries[i]);
	}
	raw_spin_unlock(&s->lock[idx]);

	mutex_unlock(&stall_mutex);
}


Yes its racy on s->worst, but who cares (if you do care you can keep a
copy in s->delay[idx] or so). Also, it might be better to not do the
spinlock but simply use an atomic bitop to set an in-use flag, there is
no reason to disable preemption over the seq_printf() loop.


