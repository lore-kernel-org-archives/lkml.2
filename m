Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab0ELPP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 11:15:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:35873 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab0ELPP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 11:15:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rW2h+jCKYxnUddE/YJei+xkILAeQDNVZAV5RYBBpaiK62J0FPAUVuRBhrxnjmvWz7Q
         5BusUt+3CQAKEi1+V+SVuYCzr/YEo7OwiVnfdj8G/eml9ZNXBOctKBL1DOxKZEpfC9lb
         FZAkkCVk7BYJ1VFkyjWHkdg6EqR3iGK41wvAo=
Date: Wed, 12 May 2010 17:15:22 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 11/11] Uprobes traceevents patch.
Message-ID: <20100512151517.GD5405@nowhere>
References: <20100331155106.4181.50759.sendpatchset@localhost6.localdomain6> <20100331155311.4181.85103.sendpatchset@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100331155311.4181.85103.sendpatchset@localhost6.localdomain6>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 09:23:11PM +0530, Srikar Dronamraju wrote:
> +static void uprobe_trace_func(struct uprobe *up, struct pt_regs *regs)
> +{
> +	struct trace_uprobe *tp = container_of(up, struct trace_uprobe, up);
> +	struct uprobe_trace_entry *entry;
> +	struct ring_buffer_event *event;
> +	struct ring_buffer *buffer;
> +	int size, i, pc;
> +	unsigned long irq_flags;
> +	struct ftrace_event_call *call = &tp->call;
> +
> +	tp->nhit++;
> +
> +	local_save_flags(irq_flags);
> +	pc = preempt_count();
> +
> +	size = SIZEOF_UPROBE_TRACE_ENTRY(tp->nr_args);
> +
> +	event = trace_current_buffer_lock_reserve(&buffer, call->id, size,
> +						  irq_flags, pc);
> +	if (!event)
> +		return;
> +
> +	entry = ring_buffer_event_data(event);
> +	entry->nargs = tp->nr_args;
> +	entry->ip = (unsigned long)up->vaddr;
> +	for (i = 0; i < tp->nr_args; i++)
> +		entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
> +
> +	if (!filter_current_check_discard(buffer, call, entry, event))
> +		trace_nowake_buffer_unlock_commit(buffer, event, irq_flags, pc);



You can use the non-nowake version I think. nowake is for events that might
occur when we hold the rq lock, hence when it's too dangerous to wake up.
It doesn't seem to be the case since we came here after a trap in userspace.

