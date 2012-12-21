Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab2LUDE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 22:04:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14067 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab2LUDEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 22:04:23 -0500
X-Authority-Analysis: v=2.0 cv=QPnqt33L c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=ml8GsI79ucgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=QqmOOhKOIa8A:10 a=3nbZYyFuAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=LF-a_cy58SoTcdpIQz4A:9 a=PUjeQqilurYA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1356059062.5896.87.camel@gandalf.local.home>
Subject: Re: [PATCH v3 -tip 2/4] tracing: replace static old_tracer with
 strcmp
From: Steven Rostedt <rostedt@goodmis.org>
To: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Cc: masami.hiramatsu.pt@hitachi.com, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Thu, 20 Dec 2012 22:04:22 -0500
In-Reply-To: <20121219070243.31200.73060.stgit@liselsia>
References: <20121219070218.31200.64647.stgit@liselsia>
	 <20121219070243.31200.73060.stgit@liselsia>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-19 at 16:02 +0900, Hiraku Toyooka wrote:
> Currently, read functions for trace buffer use static "old_tracer"
> for detecting changes of current tracer. This is because we can
> assume that these functions are used from only one file ("trace").
> 
> But we are adding snapshot feature for ftrace, then those functions
> are called from two files. So we remove all static "old_tracer", and
> replace those with string comparison between current and previous
> tracers.

I reworded what you wrote:

---
Currently the trace buffer read functions use a static variable
"old_tracer" for detecting if the current tracer changes. This was
suitable for a single trace file ("trace"), but to add a snapshot
feature that will use the same function for its file, a check against
a static variable is not sufficient.

To use the output functions for two different files, instead of storing
the current tracer in a static variable, as the trace iterator
descriptor
contains a pointer to the original current tracer's name, that pointer
can now be used to check if the current tracer has changed between
different reads of the trace file.
---

And I also realized a more efficient approach.

> 
> Signed-off-by: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: linux-kernel@vger.kernel.org
> ---
>  kernel/trace/trace.c |   18 ++++++------------
>  1 file changed, 6 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index a8ce008..8d05a44 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1948,7 +1948,6 @@ void tracing_iter_reset(struct trace_iterator *iter, int cpu)
>  static void *s_start(struct seq_file *m, loff_t *pos)
>  {
>  	struct trace_iterator *iter = m->private;
> -	static struct tracer *old_tracer;
>  	int cpu_file = iter->cpu_file;
>  	void *p = NULL;
>  	loff_t l = 0;
> @@ -1956,10 +1955,9 @@ static void *s_start(struct seq_file *m, loff_t *pos)
>  
>  	/* copy the tracer to avoid using a global lock all around */
>  	mutex_lock(&trace_types_lock);
> -	if (unlikely(old_tracer != current_trace && current_trace)) {
> -		old_tracer = current_trace;
> +	if (unlikely(current_trace &&
> +		     strcmp(iter->trace->name, current_trace->name) != 0))
>  		*iter->trace = *current_trace;

As iter->trace is a copy of current_trace, it points to everything that
the current_trace pointed to. As the current_trace->name is a pointer to
a const char string that never changes, we don't need to do the strcmp()
you can simply do a direct comparison:

	if (unlikely(current_trace && iter->trace->name != current_trace->name)) {

I would add a comment about that too:
	/*
	 * iter->trace is a copy of current_trace, the pointer to the
	 * name may be used instead of a strcmp(), as iter->trace->name
	 * will point to the same string as current_trace->name.
	 */

-- Steve


> -	}
>  	mutex_unlock(&trace_types_lock);
>  
>  	atomic_inc(&trace_record_cmdline_disabled);
> @@ -3481,7 +3479,6 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
>  		  size_t cnt, loff_t *ppos)
>  {
>  	struct trace_iterator *iter = filp->private_data;
> -	static struct tracer *old_tracer;
>  	ssize_t sret;
>  
>  	/* return any leftover data */
> @@ -3493,10 +3490,9 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
>  
>  	/* copy the tracer to avoid using a global lock all around */
>  	mutex_lock(&trace_types_lock);
> -	if (unlikely(old_tracer != current_trace && current_trace)) {
> -		old_tracer = current_trace;
> +	if (unlikely(current_trace &&
> +		     strcmp(iter->trace->name, current_trace->name) != 0))
>  		*iter->trace = *current_trace;
> -	}
>  	mutex_unlock(&trace_types_lock);
>  
>  	/*
> @@ -3652,7 +3648,6 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
>  		.ops		= &tracing_pipe_buf_ops,
>  		.spd_release	= tracing_spd_release_pipe,
>  	};
> -	static struct tracer *old_tracer;
>  	ssize_t ret;
>  	size_t rem;
>  	unsigned int i;
> @@ -3662,10 +3657,9 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
>  
>  	/* copy the tracer to avoid using a global lock all around */
>  	mutex_lock(&trace_types_lock);
> -	if (unlikely(old_tracer != current_trace && current_trace)) {
> -		old_tracer = current_trace;
> +	if (unlikely(current_trace &&
> +		     strcmp(iter->trace->name, current_trace->name) != 0))
>  		*iter->trace = *current_trace;
> -	}
>  	mutex_unlock(&trace_types_lock);
>  
>  	mutex_lock(&iter->mutex);


