Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab0KHULV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 15:11:21 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54773 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab0KHULU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 15:11:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=h2MwiR0TKiPP8e1SfvrgAqusUgueGH8O+B+AWG2Z8xH5R4l+jedK676CCLVHW2oXS7
         /zzjgDQXh7/XA+YAWgq2n55zCyDBEDZkMKcytw7LEQOjBTe6WFqNJ/5qoItxqzkj06+B
         ZIzl3I63hSRSRjz0+nYhAZnEEyruXzuFvnXlI=
Date: Mon, 8 Nov 2010 21:11:14 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Q: perf_event && event->owner
Message-ID: <20101108201108.GA6777@nowhere>
References: <20101108145647.GA3426@redhat.com> <20101108145754.GB3434@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101108145754.GB3434@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 03:57:54PM +0100, Oleg Nesterov wrote:
> Another thing I can't understand, event->owner/owner_entry.
> 
> Say, some thread calls sys_perf_event_open() and creates the event.
> It becomes its owner. Now this thread exits, but fd/event are still
> here, and event->owner refers to the dead task_struct.



Hmm, it seems to me that the last reference to the events are
put in __perf_event_exit_task, and then free_event() is called
there, which rcu queues the event to be released.

Not sure where is the issue here.


 
> ptrace looks even more strange. Debugger can attach the breakpoint
> to the tracee and then exit/detach. ->ptrace_bps events still point
> to the same (may be dead) task. Even if another debugger attaches
> and reuses these events.



Hmm, in this case ptrace_bps will continue to trigger on the task
they were applied.

On the other hand, you're right, I'm not sure that the debugger is
the correct owner for the breakpoints.
I think it works though, looking at perf_event_create_kernel_counter():

	event->owner = current;
	get_task_struct(current);

(current is the debugger)

On perf_event_release_kernel():

	put_task_struct(event->owner);

So even if the debugger dies, we keep a valid owner, it works but just makes
few sense as the debugger can change.
Perhaps the real owner should be the task on which we attach our breakpoint.

What do you think?

