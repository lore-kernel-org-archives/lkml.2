Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076Ab1EMN32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 09:29:28 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49485 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932345Ab1EMN3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 09:29:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XNX2MonXDTZtVWL897ZEEx9zhjj+d3twjpVEWfu1WH8JJTzyvZemYV80lNuHp1b4gK
         bPL+ySXycX5XMy0P/qBqfMSijcaHbobnTRCBHFdw/fJz01YeTxS3H+zQ1juTtPlK5OL+
         u+mPMN0/fjJlJ5JEefGylnw/y6t/N/bfwXRTQ=
Date: Fri, 13 May 2011 15:29:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] x86: Make the x86-64 stacktrace code safely
 callable from scheduler
Message-ID: <20110513132916.GB1840@nowhere>
References: <1305232326-9804-1-git-send-email-fweisbec@gmail.com>
 <1305232326-9804-3-git-send-email-fweisbec@gmail.com>
 <1305283706.22280.40.camel@frodo>
 <20110513124800.GA1840@nowhere>
 <1305292798.2466.29.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305292798.2466.29.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 03:19:58PM +0200, Peter Zijlstra wrote:
> On Fri, 2011-05-13 at 14:48 +0200, Frederic Weisbecker wrote:
> > I haven't observed any deadlock. trace events disable preemption and
> > other tracers do too (my changelog was buggy).
> > 
> > I just worried about potential other users, like a WARN_ON in the
> > scheduler or so.
> > 
> > My worry is the following scenario:
> > 
> > schedule() {
> >         acquire(rq)
> >                                                         set_tsk_need_resched
> >         WARN_ON() {
> >                 stack_trace() {
> >                         preempt_enable() {
> >                                 preempt_schedule() {
> 
> Would never happen, because rq->lock is a spinlock which holds another
> preempt count so preempt_enable() would never schedule.

Oh right.

> 
> >                                         acquire(rq)
> >                                 }
> >                         }
> >                 }
> >         }
> > }
> 
> 
> 
> > I don't know if it happens that one set TIF_NEED_RESCHED remotely,
> 
> Yes
> 
> > or if TIF_NEED_RESCHED can be set when we hold the rq,
> 
> Yes
> 
> >  and then we
> > can be followed by a WARN_ON, ...
> 
> Not quite sure, but possible.
> 
> > So I preferred to be careful. 
> 
> Still not quite seeing how all things could go bang.

Nah, forget about that, I was just confused ;)
