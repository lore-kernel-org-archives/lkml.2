Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab0GCU2G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 16:28:06 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36117 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab0GCU2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 16:28:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=piLfb8/YLT1MEeLdq33GqP4zEBm6CF7HI48MqNcqloHtFHTcdPAxi2BuysCFwAsYAN
         UFzkqtbNib1KQlTKUvKMW0zaOvi8aeEvlqokLvAirebRUMSs1dSX9fkxo674rlML/gNC
         ZKHvHhHcjpJleDD3QMEk0aeIEBlhJIWWtsK9Q=
Date: Sat, 3 Jul 2010 22:28:17 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       David Miller <davem@davemloft.net>, Borislav Petkov <bp@amd64.org>
Subject: Re: [RFC PATCH 5/6] perf: Fix race in callchains
Message-ID: <20100703202814.GA5232@nowhere>
References: <1277998562-21366-1-git-send-regression-fweisbec@gmail.com> <1277998562-21366-6-git-send-regression-fweisbec@gmail.com> <1278094055.1917.285.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278094055.1917.285.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 08:07:35PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-07-01 at 17:36 +0200, Frederic Weisbecker wrote:
> > Now that software events don't have interrupt disabled anymore in
> > the event path, callchains can nest on any context. So seperating
> > nmi and others contexts in two buffers has become racy.
> > 
> > Fix this by providing one buffer per nesting level. Given the size
> > of the callchain entries (2040 bytes * 4), we now need to allocate
> > them dynamically.
> 
> OK so I guess you want to allocate them because 8k per cpu is too much
> to always have about?



Right. I know that really adds complexity and I hesitated much before
doing so. But I think that's quite necessary.


 
> > +static int get_callchain_buffers(void)
> > +{
> > +	int i;
> > +	int err = 0;
> > +	struct perf_callchain_entry_cpus *buf;
> > +
> > +	mutex_lock(&callchain_mutex);
> > +
> > +	if (WARN_ON_ONCE(++nr_callchain_events < 1)) {
> > +		err = -EINVAL;
> > +		goto exit;
> > +	}
> > +
> > +	if (nr_callchain_events > 1)
> > +		goto exit;
> > +
> > +	for (i = 0; i < 4; i++) {
> > +		buf = kzalloc(sizeof(*buf), GFP_KERNEL);
> > +		/* free_event() will clean the rest */
> > +		if (!buf) {
> > +			err = -ENOMEM;
> > +			goto exit;
> > +		}
> > +		buf->entries = alloc_percpu(struct perf_callchain_entry);
> > +		if (!buf->entries) {
> > +			kfree(buf);
> > +			err = -ENOMEM;
> > +			goto exit;
> > +		}
> > +		rcu_assign_pointer(callchain_entries[i], buf);
> > +	}
> > +
> > +exit:
> > +	mutex_unlock(&callchain_mutex);
> > +
> > +	return err;
> > +}
> 
> > +static void put_callchain_buffers(void)
> > +{
> > +	int i;
> > +	struct perf_callchain_entry_cpus *entry;
> > +
> > +	mutex_lock(&callchain_mutex);
> > +
> > +	if (WARN_ON_ONCE(--nr_callchain_events < 0))
> > +		goto exit;
> > +
> > +	if (nr_callchain_events > 0)
> > +		goto exit;
> > +
> > +	for (i = 0; i < 4; i++) {
> > +		entry = callchain_entries[i];
> > +		if (entry) {
> > +			callchain_entries[i] = NULL;
> > +			call_rcu(&entry->rcu_head, release_callchain_buffers);
> > +		}
> > +	}
> > +
> > +exit:
> > +	mutex_unlock(&callchain_mutex);
> > +}
> 
> If you make nr_callchain_events an atomic_t, then you can do the
> refcounting outside the mutex. See the existing user of
> atomic_dec_and_mutex_lock().
> 
> I would also split it in get/put and alloc/free functions for clarity.



Ok I will.




> I'm not at all sure why you're using RCU though.
> 
> > @@ -1895,6 +2072,8 @@ static void free_event(struct perf_event *event)
> >  			atomic_dec(&nr_comm_events);
> >  		if (event->attr.task)
> >  			atomic_dec(&nr_task_events);
> > +		if (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN)
> > +			put_callchain_buffers();
> >  	}
> >  
> >  	if (event->buffer) {
> 
> If this was the last even, there's no callchain user left, so nobody can
> be here:
> 
> > @@ -3480,14 +3610,20 @@ static void perf_event_output(struct perf_event *event, int nmi,
> >  	struct perf_output_handle handle;
> >  	struct perf_event_header header;
> >  
> > +	/* protect the callchain buffers */
> > +	rcu_read_lock();
> > +
> >  	perf_prepare_sample(&header, data, event, regs);
> >  
> >  	if (perf_output_begin(&handle, event, header.size, nmi, 1))
> > -		return;
> > +		goto exit;
> >  
> >  	perf_output_sample(&handle, &header, data, event);
> >  
> >  	perf_output_end(&handle);
> > +
> > +exit:
> > +	rcu_read_unlock();
> >  }
> 
> Rendering that RCU stuff superfluous.


May be I'm omitting something that would make it non-rcu-safe.

But consider a perf event running on CPU 1. And you close the fd on
CPU 0. CPU 1 has started to use a callchain buffer but receives an IPI
to retire the event from the cpu. But still it has yet to finish his
callchain processing.

If right after that CPU 0 releases the callchain buffers, CPU 1 may
crash in the middle.

So you need to wait for the grace period to end.

