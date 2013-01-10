Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582Ab3AJFLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 00:11:23 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:41227 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab3AJFLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 00:11:22 -0500
MIME-Version: 1.0
In-Reply-To: <20130109184950.GO3926@htj.dyndns.org>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
	<ad25c731a6ca1bd1269555245952f05c856a9759.1352196505.git.viresh.kumar@linaro.org>
	<20121126171539.GZ15971@htj.dyndns.org>
	<CAKohpom9=K976NmyFWtXx2UQyRcLAqsoGw-5AaqXRpSL6uxP_g@mail.gmail.com>
	<CAKohpokBMhto6xzp3MPGRJqstEkkC=kzgrKNhVXzi1Y8GejkXg@mail.gmail.com>
	<20130104150928.GC15633@mtj.dyndns.org>
	<CAKohpo=hhScCDUnDcqnZx4YzU_8nF1658jmSM_wzsOpSCxXwqA@mail.gmail.com>
	<20130107150422.GB3926@htj.dyndns.org>
	<CAKohponQP7+fUJtTysDiaDNQA0fTCcErb97gpKCxXpshSOuYfg@mail.gmail.com>
	<20130109184950.GO3926@htj.dyndns.org>
Date: Thu, 10 Jan 2013 10:34:09 +0530
Message-ID: <CAKohponWfu1q6fFRgpAgxCz14O0vyJuX313SkS99cj0=Kh6Wyw@mail.gmail.com>
Subject: Re: [PATCH V2 Resend 3/4] workqueue: Schedule work on non-idle cpu
 instead of current one
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Tejun Heo <tj@kernel.org>
Cc: rostedt@goodmis.org, Vincent Guittot <vincent.guittot@linaro.org>,
        pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        mingo@redhat.com, peterz@infradead.org, Arvind.Chauhan@arm.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 January 2013 00:19, Tejun Heo <tj@kernel.org> wrote:
> On Mon, Jan 07, 2013 at 11:37:22PM +0530, Viresh Kumar wrote:
>> We are talking about a core being idle from schedulers perspective :)
>
> But it's not like cpu doesn't consume power if scheduler considers it
> idle, right?  Can you please explain in detail how this contributes to
> saving power?  Is it primarily about routing work items to lower power
> CPUs?  And please don't point to presentation slides.  They don't seem
> to explain much better and patches and the code should be able to
> describe themselves.  Here, more so, as the desired behavior change
> and the resulting powersave are rather subtle.

I got your concerns. Firstly, when cpu is idle from schedulers perspective, it
consumes a lot of power.

queue_work_on_any_cpu() would queue the work on any other cpu only
when current cpu is idle from schedulers perspective, and this can only
happen when the cpu was actually idle (in low power state), woke up due
to some interrupt/timer and is asked to queue a work..

The idea is to choose other non-idle cpu at this point, so that current cpu
can immediately go into deeper idle state. With this cpus can stay longer
at deeper idle state, rather than running works.

And in cases, where works are rearmed from the handler, this can cause
sufficient power loss, which could be easily saved by pushing this work to
non-idle cpus.

The same approach is taken for deffered timers too, they are already using
such routine. .
