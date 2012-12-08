Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279Ab2LHWvD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 17:51:03 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:56189 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab2LHWvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 17:51:00 -0500
MIME-Version: 1.0
In-Reply-To: <20121208150252.GI12011@gmail.com>
References: <1353200692-6039-1-git-send-email-fweisbec@gmail.com>
	<20121208150252.GI12011@gmail.com>
Date: Sat, 8 Dec 2012 23:50:59 +0100
Message-ID: <CAFTL4hzTDU9h0jiKq6drkgmQ+Vn26nWSr6UoLAPMK+vffb5uYw@mail.gmail.com>
Subject: Re: [GIT PULL v2] printk: Make it usable on nohz cpus
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Anish Kumar <anish198519851985@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/8 Ingo Molnar <mingo@kernel.org>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> Ingo,
>>
>> Please pull the printk support in dynticks mode patches that can
>> be found at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git tags/printk-dynticks-for-mingo-v2
>>
>> for you to fetch changes up to 74876a98a87a115254b3a66a14b27320b7f0acaa:
>>
>>   printk: Wake up klogd using irq_work (2012-11-18 01:01:49 +0100)
>>
>> It is based on v3.7-rc4.
>>
>> Changes since previous pull request include support for irq
>> work flush on CPU offlining and acks from Steve. The rest
>> hasn't changed except some comment fix.
>
> Since this changes kernel/printk.c it needs Linus's ack.
>
> I looked through the older submissions but found no good summary
> of these changes: it would be nice if you could write up a good
> high level description of these changes - why has printk based
> kernel message logging become problematic on nohz, what are the
> symptoms to users, and what are the solution alternatives you
> found and please justify the irq_work extension variant you
> picked.
>
> I more or less accept the fact that fixes are needed here, but
> the linecount appears a bit high. It's possibly unavoidable, but
> would be nice to have a discussion of it, as printk is something
> we really, really want to keep as simple as possible.

Sorry, I focused too much on details and it indeed lacks a detailed
general explanation.

printk() is problematic for the full dynticks implementation that we
are working on because it depends on the tick to stay periodic in
order to wake up the potential readers sleeping on the syslog()
syscall.

printk() can be called about anywhere (sort of), so when a new message
is written in the buffer while there are pending readers, printk wakes
them up asynchronously instead of doing it in place in order to avoid
some gory locking scenarios with the scheduler locks.

This asynchronous wake up is handled by a hook on the timer tick:
printk_tick(). This is called every timer interrupt. So if we stop the
tick outside idle, and some printk() is called while the CPU runs in
full dynticks mode while we have pending readers, those may not be
woken for a while. Hence the user may miss some important message.

So if we want to enter in full dynticks mode safely, I fear we don't
have much choices. We need to find some event driven rather than
periodic driven way to perform the asynchronous wake up. The irq work
subsystem is a very good fit for that because:

* it can typically raise self-IPIs (some archs haven't implemented
that yet but this will be a requirement for full dynticks mode)
* it's light, simple and standalone. This is what we want for an API
used by printk()
* this is lockless, which is a requirement for printk at this stage.

Also irq work subsystem has its own hook on the timer tick in case the
arch can't perform self-IPIs. So if the tick is not stopped while
printk() is called, we can even avoid the IPI. This may be desirable
if we have situations with lots of printk() in a short period of time:
this can avoid an IPI storm.

Also this is an immediate benefit for mainline because we can now
remove the ad-hoc printk_tick() timer hook. One less function call and
per-cpu check from the timer interrupt is a win.

What do you guys think?
