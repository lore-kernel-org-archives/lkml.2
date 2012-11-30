Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758331Ab2K3ORK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 09:17:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24625 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758310Ab2K3ORI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 09:17:08 -0500
X-Authority-Analysis: v=2.0 cv=f9bK9ZOM c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=O7yW5i6_SjkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=apWNB6VHehcA:10 a=qnRtVIaIrdebiBWiOgoA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1354285026.6276.157.camel@gandalf.local.home>
Subject: Re: [PATCH v2 -tip 3/4] tracing: make a snapshot feature available
 from userspace
From: Steven Rostedt <rostedt@goodmis.org>
To: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Cc: yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>
Date: Fri, 30 Nov 2012 09:17:06 -0500
In-Reply-To: <50B84822.6010409@hitachi.com>
References: <20121017025608.2627.87497.stgit@falsita>
		 <20121017025619.2627.96794.stgit@falsita>
	 <1353030384.9391.19.camel@gandalf.local.home>
	 <50B84822.6010409@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-30 at 14:46 +0900, Hiraku Toyooka wrote:
> Hi, Steven,
> 
> Thank you for your review.
> 
> (2012/11/16 10:46), Steven Rostedt wrote:
> [snip]
>  > I was thinking about this some more, and I don't like the
>  > snapshot_allocate part. Also, I think the snapshot should not be
>  > allocated by default, and not used until the user explicitly asks for
>  > it.
>  >
>  > Have this:
>  >
>  > ---
>  >  # cat snapshot
>  > Snapshot is not allocated. To allocate it write the ASCII "1" into
>  > this file:
>  >
>  >   echo 1 > snapshot
>  >
>  > This will allocate the buffer for you. To free the snapshot echo "0"
>  > into this file.
>  >
>  >   echo "0" > snapshot
>  >
>  > Anything else will reset the snapshot if it is allocated, or return
>  > EINVAL if it is not allocated.
>  > ---
>  >
> 
> Your idea about "snapshot" is like following table, isn't it?
> 
>   status\input |     0      |     1      |    else    |
> --------------+------------+------------+------------+
> not allocated |   EINVAL   | alloc+swap |   EINVAL   |
> --------------+------------+------------+------------+
>    allocated   |    free    | clear+swap |   clear    |
> --------------+------------+------------+------------+

Actually, I would have:

  status\input |     0      |     1      |    else    |
 --------------+------------+------------+------------+
 not allocated |(do nothing)| alloc+swap |   EINVAL   |
 --------------+------------+------------+------------+
   allocated   |    free    |   swap     |   clear    |
 --------------+------------+------------+------------+

Perhaps we don't need to do the clear on swap, just let the trace
continue where it left off? But in case we should swap...

There's a fast way to clear the tracer. Look at what the wakeup tracer
does. We can make that generic. If you want, I can write that code up
too. Hmm, maybe I'll do that, as it will speed things up for
everyone :-)


> 
> I think it is almost OK, but there is a problem.
> When we echo "1" to the allocated snapshot, the clear operation adds
> some delay because the time cost of tracing_reset_online_cpus() is in
> proportion to the number of CPUs.
> (It takes 72ms in my 8 CPU environment.)
> 
> So, when the snapshot is already cleared by echoing "else" values, we
> can avoid the delay on echoing "1" by keeping "cleared" status
> internally. For example, we can add the "cleared" flag to struct tracer.
> What do you think about it?
> 
>  >
>  > Also we can add a "trace_snapshot" to the kernel parameters to have it
>  > allocated on boot. But I can add that if you update these patches.
>  >
> 
> OK, I'll update my patches.

This part (kernel parameter) can be a separate patch.


>  > Either test here, or better yet, put the test into
>  > tracing_reset_online_cpus().
>  >
>  >     if (!buffer)
>  >         return;
>  >
> 
> I see. I'll add the test to tracing_reset_online_cpus(). Should I make a
> separated patch?

It's a small change, you can add it to your patch or make it separate.
I'll leave that up to you.

> 
> [snip]
>  >> +static ssize_t tracing_snapshot_read(struct file *filp, char __user 
> *ubuf,
>  >> +                     size_t cnt, loff_t *ppos)
>  >> +{
>  >> +    ssize_t ret = 0;
>  >> +
>  >> +    mutex_lock(&trace_types_lock);
>  >> +    if (current_trace && current_trace->use_max_tr)
>  >> +        ret = -EBUSY;
>  >> +    mutex_unlock(&trace_types_lock);
>  >
>  > I don't like this, as it is racy. The current tracer could change after
>  > the unlock, and your back to the problem.
>  >
> 
> You're right...
> This is racy.
> 
>  > Now what we may be able to do, but it would take a little checking for
>  > lock ordering with trace_access_lock() and trace_event_read_lock(), but
>  > we could add the mutex to trace_types_lock to both s_start() and
>  > s_stop() and do the check in s_start() if iter->snapshot is true.
>  >
> 
> If I catch your meaning, do s_start() and s_stop() become like following
> code?
> (Now, s_start() is used from two files - "trace" and "snapshot", so we
> should change static "old_tracer" to per open-file.)

Actually, lets nuke all the old_tracer totally, and instead do:

if (unlikely(strcmp(iter->trace->name, current_trace->name) != 0)) {

You can make this into a separate patch. You can add a check if
current_trace is not NULL too, but I need to fix that, as current_trace
should never be NULL (except for very early boot). But don't worry about
that, I'll handle that.

Or I can write up this patch and send it to you, and you can include it
in your series.

> 
> static void *s_start(struct seq_file *m, loff_t *pos)
> {
>       struct trace_iterator *iter = m->private;
> -    static struct tracer *old_tracer;
> ...
>       /* copy the tracer to avoid using a global lock all around */
>       mutex_lock(&trace_types_lock);
> -    if (unlikely(old_tracer != current_trace && current_trace)) {
> -        old_tracer = current_trace;
> +    if (unlikely(iter->old_tracer != current_trace && current_trace)) {
> +        iter->old_tracer = current_trace;
>           *iter->trace = *current_trace;
>       }
>       mutex_unlock(&trace_types_lock);
> 
> +    if (iter->snapshot && iter->trace->use_max_tr)
> +        return ERR_PTR(-EBUSY);
> +
> ...
> }
> 
> static void s_stop(struct seq_file *m, void *p)
> {
>       struct trace_iterator *iter = m->private;
> 
> +    if (iter->snapshot && iter->trace->use_max_tr)
> +        return;

This part shouldn't be needed, as if s_start fails it wont call
s_stop(). But if you are paranoid (like I am ;-) then we can do:

	if (WARN_ON_ONCE(iter->snapshot && iter->trace->use_max_tr)
		return;



-- Steve


