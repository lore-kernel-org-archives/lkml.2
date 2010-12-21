Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933421Ab0LUBeD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 20:34:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59993 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933384Ab0LUBeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 20:34:02 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=GT7j54JQFWIA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=omOdbC7AAAAA:8 a=eCrDwqJm5saGu0qYzWEA:9 a=4J10diSZ6zW2UDxY66LkFQRYA7AA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] tracing: Fix preempt count leak
From: Steven Rostedt <rostedt@goodmis.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4D0FFB1A.7070407@cn.fujitsu.com>
References: <4D0089AC.1020802@cn.fujitsu.com>
	 <4D0FFB1A.7070407@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 20 Dec 2010 20:33:59 -0500
Message-ID: <1292895239.22905.67.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-21 at 08:55 +0800, Li Zefan wrote:
> Any comment?

oops, this was buried in my email. I'll look at it tomorrow.

-- Steve

> 
> 15:47, Li Zefan wrote:
> > While running my ftrace stress test, this showed up:
> > 
> > BUG: sleeping function called from invalid context at mm/mmap.c:233
> > ...
> > note: cat[3293] exited with preempt_count 1
> > 
> > The bug was introduced by commit 91e86e560d0b3ce4c5fc64fd2bbb99f856a30a4e
> > ("tracing: Fix recursive user stack trace")
> > 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > ---
> >  kernel/trace/trace.c |    6 ++----
> >  1 files changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index c380612..5767457 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -1313,12 +1313,10 @@ ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
> >  
> >  	__this_cpu_inc(user_stack_count);
> >  
> > -
> > -
> >  	event = trace_buffer_lock_reserve(buffer, TRACE_USER_STACK,
> >  					  sizeof(*entry), flags, pc);
> >  	if (!event)
> > -		return;
> > +		goto out_drop_count;
> >  	entry	= ring_buffer_event_data(event);
> >  
> >  	entry->tgid		= current->tgid;
> > @@ -1333,8 +1331,8 @@ ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
> >  	if (!filter_check_discard(call, entry, buffer, event))
> >  		ring_buffer_unlock_commit(buffer, event);
> >  
> > + out_drop_count:
> >  	__this_cpu_dec(user_stack_count);
> > -
> >   out:
> >  	preempt_enable();
> >  }


