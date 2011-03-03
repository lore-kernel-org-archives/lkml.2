Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab1CCCkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 21:40:14 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53981 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758091Ab1CCCkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 21:40:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GsqGRlih4bJRiIVwUHuGjsxSQCPtxreYa0PklZfj90TjqNHz5yDJCpCMy2uVvP1T/7
         lFfTi8sMdbLeOXp9B1GPL7fbthDwkXrAlTc54dSLCd/sYetaFvWA0/XDQr1hMaKalgXm
         E7POu4l/12WHsAOnh0+6bt6bDLaoEAU3nsOZg=
Date: Thu, 3 Mar 2011 03:40:06 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH 1/3] perf script: change process_event prototype
Message-ID: <20110303024003.GC1946@nowhere>
References: <1299086960-26964-1-git-send-email-daahern@cisco.com>
 <1299086960-26964-2-git-send-email-daahern@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299086960-26964-2-git-send-email-daahern@cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 10:29:18AM -0700, David Ahern wrote:
> Prepare for handling of samples for any event type.
> 
> Signed-off-by: David Ahern <daahern@cisco.com>
> ---
>  tools/perf/builtin-script.c                        |   40 +++++++++++--------
>  .../util/scripting-engines/trace-event-python.c    |   20 ++++++++-

What about Perl?

>  tools/perf/util/trace-event-scripting.c            |    8 +--
>  tools/perf/util/trace-event.h                      |    6 ++-
>  4 files changed, 47 insertions(+), 27 deletions(-)
> 
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index 5f40df6..0bee150 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -20,6 +20,27 @@ static u64			last_timestamp;
>  static u64			nr_unordered;
>  extern const struct option	record_options[];
>  
> +static void process_event(union perf_event *event,
> +			  struct perf_sample *sample,
> +			  struct perf_session *session)
> +{
> +	struct thread *thread = perf_session__findnew(session, event->ip.pid);
> +
> +	if (thread == NULL) {
> +		pr_debug("problem processing %d event, skipping it.\n",
> +			 event->header.type);
> +		return;
> +	}

Seems the thread is needed by any endpoints. It would be better to resolve
it from process_sample_event and pass it to the process_event() handler.

> +
> +	/*
> +	 * FIXME: better resolve from pid from the struct trace_entry
> +	 * field, although it should be the same than this perf
> +	 * event pid
> +	 */
> +	print_event(sample->cpu, sample->raw_data, sample->raw_size,
> +		    sample->time, thread->comm);
> +}
[...]
> diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
> index 2040b85..5b03fb6 100644
> --- a/tools/perf/util/scripting-engines/trace-event-python.c
> +++ b/tools/perf/util/scripting-engines/trace-event-python.c
> @@ -204,9 +204,9 @@ static inline struct event *find_cache_event(int type)
>  	return event;
>  }
>  
> -static void python_process_event(int cpu, void *data,
> -				 int size __unused,
> -				 unsigned long long nsecs, char *comm)
> +static void python_process_event(union perf_event *pevent,
> +				struct perf_sample *sample,
> +				struct perf_session *session)
>  {
>  	PyObject *handler, *retval, *context, *t, *obj, *dict = NULL;
>  	static char handler_name[256];
> @@ -218,6 +218,20 @@ static void python_process_event(int cpu, void *data,
>  	int type;
>  	int pid;

Please avoid such blank line in the middle of local vars declaration.

> +	int cpu = sample->cpu;
> +	void *data = sample->raw_data;
> +	unsigned long long nsecs = sample->time;
> +	char *comm;
> +	struct thread *thread;
> +
> +	thread = perf_session__findnew(session, pevent->ip.pid);
> +	if (thread == NULL) {
> +		pr_debug("problem processing %d event, skipping it.\n",
> +			 pevent->header.type);
> +		return;
> +	}
> +	comm = thread->comm;
> +
