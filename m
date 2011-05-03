Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab1ECXfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 19:35:11 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59981 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab1ECXfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 19:35:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=STkSOKMKRYSvX9vY03MQpFHYLNbJs8tPucLJS4X4eChuJEfpFJ1ttaTQWlDZqet6XA
         JomzsWsUYDzbhar0bmp7gn9ZG/acoSmgPpgRpvyNaVUKq1u8Tgv8fwdWRZn3ggs74U34
         JqaI5WcMdgU436ADQjw5Xnfbj2fYkeaQtCoeU=
Date: Wed, 4 May 2011 01:35:06 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] tracing: Don't call wakeup() when committing the
 event
Message-ID: <20110503233503.GH2678@nowhere>
References: <1304456616-30281-1-git-send-email-vnagarnaik@google.com>
 <20110503214142.GC2678@nowhere>
 <BANLkTinA8M8Ok2jghtCoeBiTfw6n3NSziA@mail.gmail.com>
 <20110503220948.GE2678@nowhere>
 <1304462852.25414.2417.camel@gandalf.stny.rr.com>
 <20110503230812.GF2678@nowhere>
 <BANLkTikRxY_NiNG+z+t_BDwDAom_rpNmdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikRxY_NiNG+z+t_BDwDAom_rpNmdg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 04:27:22PM -0700, Vaibhav Nagarnaik wrote:
> On Tue, May 3, 2011 at 4:08 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > On Tue, May 03, 2011 at 06:47:32PM -0400, Steven Rostedt wrote:
> >> On Wed, 2011-05-04 at 00:09 +0200, Frederic Weisbecker wrote:
> >>
> >> > I wonder if we should have a lite version of wake_up() that checks
> >> > if the list of waiters is empty before locking the queue.
> >> > After all we don't care much about tight races for tracing.
> >>
> >> Since tracing is a special case here, we probably could get away to just
> >> do it ourselves. That is, have our own flag that determines if we should
> >> wakeup or not.
> >
> > Yep, agreed.
> >
> How about this? Check if the waitqueue is active and if true, operate on the
> trace_wait queue.
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 06f4458..e03ee24 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -353,7 +353,7 @@ void trace_wake_up(void)
>  {
>  	int cpu;
> 
> -	if (trace_flags & TRACE_ITER_BLOCK)
> +	if (trace_flags & TRACE_ITER_BLOCK || !waitqueue_active(&trace_wait))
>  		return;
>  	/*
>  	 * The runqueue_is_locked() can fail, but this is the best we
> 

Hehe, seems it should work :)

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
