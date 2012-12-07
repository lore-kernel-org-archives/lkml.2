Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424926Ab2LGCIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 21:08:24 -0500
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:39521 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423613Ab2LGCIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 21:08:23 -0500
X-AuditID: 85900ec0-d687bb900000152f-8e-50c14f0e5129
Message-ID: <50C14F5A.50807@hitachi.com>
Date: Fri, 07 Dec 2012 11:07:22 +0900
From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH v2 -tip 3/4] tracing: make a snapshot feature available
 from userspace
References: <20121017025608.2627.87497.stgit@falsita>		 <20121017025619.2627.96794.stgit@falsita>	 <1353030384.9391.19.camel@gandalf.local.home>	 <50B84822.6010409@hitachi.com> <1354285026.6276.157.camel@gandalf.local.home>
In-Reply-To: <1354285026.6276.157.camel@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Steven,

(2012/11/30 23:17), Steven Rostedt wrote:
[snip]
 >
 > Actually, I would have:
 >
 >   status\input |     0      |     1      |    else    |
 >  --------------+------------+------------+------------+
 >  not allocated |(do nothing)| alloc+swap |   EINVAL   |
 >  --------------+------------+------------+------------+
 >    allocated   |    free    |   swap     |   clear    |
 >  --------------+------------+------------+------------+
 >
 > Perhaps we don't need to do the clear on swap, just let the trace
 > continue where it left off? But in case we should swap...
 >

I think we don't need the clear on swap too.
I'll update my patches like this table.

 > There's a fast way to clear the tracer. Look at what the wakeup tracer
 > does. We can make that generic. If you want, I can write that code up
 > too. Hmm, maybe I'll do that, as it will speed things up for
 > everyone :-)
 >

(I looked over the wakeup tracer, but I couldn't find that code...)

 >
 >> I think it is almost OK, but there is a problem.
 >> When we echo "1" to the allocated snapshot, the clear operation adds
 >> some delay because the time cost of tracing_reset_online_cpus() is in
 >> proportion to the number of CPUs.
 >> (It takes 72ms in my 8 CPU environment.)
 >>
 >> So, when the snapshot is already cleared by echoing "else" values, we
 >> can avoid the delay on echoing "1" by keeping "cleared" status
 >> internally. For example, we can add the "cleared" flag to struct tracer.
 >> What do you think about it?
 >>
 >>  >
 >>  > Also we can add a "trace_snapshot" to the kernel parameters to 
have it
 >>  > allocated on boot. But I can add that if you update these patches.
 >>  >
 >>
 >> OK, I'll update my patches.
 >
 > This part (kernel parameter) can be a separate patch.
 >

Yes.

 >
 >>  > Either test here, or better yet, put the test into
 >>  > tracing_reset_online_cpus().
 >>  >
 >>  >     if (!buffer)
 >>  >         return;
 >>  >
 >>
 >> I see. I'll add the test to tracing_reset_online_cpus(). Should I make a
 >> separated patch?
 >
 > It's a small change, you can add it to your patch or make it separate.
 > I'll leave that up to you.
 >

I see. Perhaps I'll make it separate.

 >> [snip]
 >>  >> +static ssize_t tracing_snapshot_read(struct file *filp, char 
__user *ubuf,
 >>  >> +                     size_t cnt, loff_t *ppos)
 >>  >> +{
 >>  >> +    ssize_t ret = 0;
 >>  >> +
 >>  >> +    mutex_lock(&trace_types_lock);
 >>  >> +    if (current_trace && current_trace->use_max_tr)
 >>  >> +        ret = -EBUSY;
 >>  >> +    mutex_unlock(&trace_types_lock);
 >>  >
 >>  > I don't like this, as it is racy. The current tracer could change 
after
 >>  > the unlock, and your back to the problem.
 >>  >
 >>
 >> You're right...
 >> This is racy.
 >>
 >>  > Now what we may be able to do, but it would take a little 
checking for
 >>  > lock ordering with trace_access_lock() and 
trace_event_read_lock(), but
 >>  > we could add the mutex to trace_types_lock to both s_start() and
 >>  > s_stop() and do the check in s_start() if iter->snapshot is true.
 >>  >
 >>
 >> If I catch your meaning, do s_start() and s_stop() become like following
 >> code?
 >> (Now, s_start() is used from two files - "trace" and "snapshot", so we
 >> should change static "old_tracer" to per open-file.)
 >
 > Actually, lets nuke all the old_tracer totally, and instead do:
 >
 > if (unlikely(strcmp(iter->trace->name, current_trace->name) != 0)) {
 >
 > You can make this into a separate patch. You can add a check if
 > current_trace is not NULL too, but I need to fix that, as current_trace
 > should never be NULL (except for very early boot). But don't worry about
 > that, I'll handle that.
 >

O.K. I'll change all the old_tracer checking to the strcmp.

 > Or I can write up this patch and send it to you, and you can include it
 > in your series.
 >
 >> static void *s_start(struct seq_file *m, loff_t *pos)
 >> {
 >>       struct trace_iterator *iter = m->private;
 >> -    static struct tracer *old_tracer;
 >> ...
 >>       /* copy the tracer to avoid using a global lock all around */
 >>       mutex_lock(&trace_types_lock);
 >> -    if (unlikely(old_tracer != current_trace && current_trace)) {
 >> -        old_tracer = current_trace;
 >> +    if (unlikely(iter->old_tracer != current_trace && current_trace)) {
 >> +        iter->old_tracer = current_trace;
 >>           *iter->trace = *current_trace;
 >>       }
 >>       mutex_unlock(&trace_types_lock);
 >>
 >> +    if (iter->snapshot && iter->trace->use_max_tr)
 >> +        return ERR_PTR(-EBUSY);
 >> +
 >> ...
 >> }
 >>
 >> static void s_stop(struct seq_file *m, void *p)
 >> {
 >>       struct trace_iterator *iter = m->private;
 >>
 >> +    if (iter->snapshot && iter->trace->use_max_tr)
 >> +        return;
 >
 > This part shouldn't be needed, as if s_start fails it wont call
 > s_stop(). But if you are paranoid (like I am ;-) then we can do:
 >
 >     if (WARN_ON_ONCE(iter->snapshot && iter->trace->use_max_tr)
 >         return;

I think that seq_read() calls s_stop() even if s_start() failed.

seq_read()@fs/seq_file.c:

         p = m->op->start(m, &pos);
         while (1) {
                 err = PTR_ERR(p);
                 if (!p || IS_ERR(p))
                         break;
                 ...
         }
         m->op->stop(m, p);

So, I think we need the check in s_stop(), don't we?


Thanks,
Hiraku Toyooka
