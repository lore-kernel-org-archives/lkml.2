Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934783Ab0KQMhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 07:37:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:52602 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933291Ab0KQMha convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 07:37:30 -0500
Subject: Re: [patch] trace: Add user-space event tracing/injection
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1289996994.2109.731.camel@laptop>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
	 <4CE38C53.8090606@kernel.org>  <20101117120740.GA24972@elte.hu>
	 <1289996994.2109.731.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 17 Nov 2010 13:37:14 +0100
Message-ID: <1289997434.2109.738.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 13:29 +0100, Peter Zijlstra wrote:
> > +             case PR_TASK_PERF_USER_TRACE:
> > +             {
> > +                     void __user *uevent_ptr = (void *)arg2;
> > +                     char kstring[MAX_USER_TRACE_SIZE+1];
> > +                     unsigned long uevent_len = arg3;
> > +
> > +                     if (uevent_len > MAX_USER_TRACE_SIZE)
> > +                             return -EINVAL;
> > +                     if (copy_from_user(kstring, uevent_ptr, uevent_len))
> > +                             return -EFAULT;
> > +                     kstring[uevent_len] = 0;
> > +
> > +                     trace_user(kstring);
> > +                     return 0;
> > +             } 

That implementation can be improved upon, no need to actually do the
copy_from_user() when the tracepoint isn't enabled.

Also, do we really need a max size here? I know ftrace (and the perf
tracepoint interface) are currently limited to 1 page of trace data but
that can be fixed (although not trivially).

Also, -EINVAL isn't really a helpful error code in that case, -EMSGSIZE
seems like a good candidate.

And the uevent name is already taken for something else, re-using it
here might cause confusion.
