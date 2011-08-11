Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab1HKTnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 15:43:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:54814 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab1HKTne convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 15:43:34 -0400
Subject: Re: [PATCH v6 2/2] Output stall data in debugfs
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Neronskiy <zakmagnus@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Don Zickus <dzickus@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Alex Neronskiy <zakmagnus@chromium.com>
Date: Thu, 11 Aug 2011 21:43:11 +0200
References: <1312999364-21104-1-git-send-email-zakmagnus@chromium.org>
	 <1312999364-21104-2-git-send-email-zakmagnus@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1313091791.8491.33.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zakmagnus seems to bounce, so who am I talking to anyway..

On Thu, 2011-08-11 at 21:35 +0200, Peter Zijlstra wrote:
> 
> static void show_stall_trace(struct seq_file *f, void *v)
> {
>         struct stall *s = f->private;
>         int i, idx = ACCESS_ONCE(s->idx);
> 
>         mutex_lock(&stall_mutex);
> 
>         raw_spin_lock(&s->lock[idx]);
>         seq_printf(f, "stall: %d\n", s->worst);
>         for (i = 0; i < s->trace[idx].nr_entries; i++) {
>                 seq_printf(f, "[<%pK>] %pS\n", 
>                         (void *)s->trace->entries[i],
>                         (void *)s->trace->entries[i]);
>         }
>         raw_spin_unlock(&s->lock[idx]);
> 
>         mutex_unlock(&stall_mutex);
> }
> 
> 
> Yes its racy on s->worst, but who cares (if you do care you can keep a
> copy in s->delay[idx] or so). Also, it might be better to not do the
> spinlock but simply use an atomic bitop to set an in-use flag, there is
> no reason to disable preemption over the seq_printf() loop. 

That also cures another problem you have, a seq_file buffer is only 1
page large, you should be using the seqfile iterator interface and print
one line at a time.. now clearly that won't work with preemption
disabled either.


