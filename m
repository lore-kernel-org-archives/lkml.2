Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459Ab0ESNHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 09:07:25 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54558 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab0ESNHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 09:07:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=azItP83KmwhFdlpJaL3NlF8lHmYrByiiqR8TDm2rWlVCiJSDYTk3tf3SA37JMj9m57
         AWIQixhioRylmd+7/y2TWIiwVS6qdld0Lfrjfhtkds7YHySBLtMy+SwghRYqybE4TDix
         se1HmGkcqIhi00oupKXvkeUTgRWbVGhBzAk7g=
Date: Wed, 19 May 2010 21:07:09 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: schedule() && prev/current (Was: [PATCH 3/3] Make
 get_current() __attribute__((const)))
Message-ID: <20100519130709.GA2216@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20100518164537.6194.73366.stgit@warthog.procyon.org.uk>
 <20100518164547.6194.94193.stgit@warthog.procyon.org.uk>
 <20100518212220.GA5092@redhat.com>
 <1274250079.5605.9967.camel@twins>
 <20100519102743.GA10040@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100519102743.GA10040@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 12:27:43PM +0200, Oleg Nesterov wrote:
> On 05/19, Peter Zijlstra wrote:
> >
> > On Tue, 2010-05-18 at 23:22 +0200, Oleg Nesterov wrote:
> >
> > > And, looking at this patch I think that schedule() can be simplified
> > > a little bit.
> > >
> > > "sched: Reassign prev and switch_count when reacquire_kernel_lock() fail"
> > > commit 6d558c3ac9b6508d26fd5cadccce51fc9d726b1c says:
> > >
> > > 	Assume A->B schedule is processing,
> > > 	...
> > > 	Then on B's context,
> > > 	...
> > > 	prev and switch_count are related to A
> > >
> > > How so? switch_count - yes, we should change it. But prev must be
> > > equal to B, and it must be equal to current. When we return from
> > > switch_to() registers/stack should be restored correctly, so we
> > > can do
> >
> > What if schedule() got called at a different stack depth than we are
> > now?
> >
> > I don't think we can assume anything about the stack context we just
> > switched to.
> 
> Not sure I understand...
> 
> OK. Firstly, we shouldn't worry about the freshly forked tasks, they
> never "return" from switch_to() but call ret_from_fork()->schedule_tail(),
> right?
> 
> Now suppose that A calls schedule() and we switch to B. When switch_to()
> returns on B's context, this context (register/stack) matches the previous
> context which was used by B when it in turn called schedule(), correct?
> 
> IOW. B calls schedule, prev == B. schedule() picks another task, prev
> is saved on B's stck after switch_to(). A calls schedule(), prev == A
> before context_switch(A, B), but after that switch_to() switches to
> B's stack and prev == B.
> 
> No?

I think you are right.

> 
> 
> I am looking into the git history now... and I guess I understand why
> reacquire_kernel_lock() uses current. Because schedule() did something
> like
> 
> 	prev = context_switch(prev, next);	// prev == last
> 
> 	finish_task_switch(prev);
> 
> 	reacquire_kernel_lock(current);		// prev != current

This is what I think when I wrote that patch. Now the task switch is
entirely finished in context_switch(). So commit log in 6d558c3a has
some flaw in it. The "prev" is also a churn.

Thanks,
Yong
