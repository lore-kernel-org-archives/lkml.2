Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab1BGQb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 11:31:29 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33251 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab1BGQb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 11:31:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YWy3pBtaUe7apKrp8Q3U/KVNdZ/j9mK9qvVns5BdVt6Teb6yJ0/NpJB6oypkDxmkh6
         J5FI8SE+UpAMM8pbic7oin5StZVtYkZU/mjd4AnVMVJLOL/aND0qP6P1zAUR/gwqWwoN
         cD+m5wxhFrGyFSw+V64K15MaRIP4bLtBJGmY4=
Date: Mon, 7 Feb 2011 17:31:21 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110207163121.GB16992@htj.dyndns.org>
References: <20110203213640.1F516180995@magilla.sf.frob.com>
 <20110203214450.GA29496@redhat.com>
 <20110204105343.GA12133@htj.dyndns.org>
 <20110204130455.GA3671@redhat.com>
 <20110204144858.GI12133@htj.dyndns.org>
 <20110204170602.GB15301@redhat.com>
 <20110205133926.GM12133@htj.dyndns.org>
 <20110207134235.GB22538@redhat.com>
 <20110207141135.GA16992@htj.dyndns.org>
 <20110207153723.GA27997@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110207153723.GA27997@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Oleg.

On Mon, Feb 07, 2011 at 04:37:23PM +0100, Oleg Nesterov wrote:
> On 02/07, Tejun Heo wrote:
> >  http://article.gmane.org/gmane.linux.kernel/1095119
> >  http://article.gmane.org/gmane.linux.kernel/1095603
> 
> Yes, I tried to read this... But I have to admit I can hardly understand
> your discussion with Roland. More precisely, I don't understand what
> exactly you have in mind.

Heh, okay, I'll try harder.  :-)

> One (may be off-topic) note,
> 
> 	On 01/31, Tejun Heo wrote:
> 	>
> 	> On Fri, Jan 28, 2011 at 01:30:09PM -0800, Roland McGrath wrote:
> 	> > > A visible behavior change is increased likelihood of delayed group
> 	> > > stop completion if the thread group contains one or more ptraced
> 	> > > tasks.
> 	> >
> 	> > I object to that difference in behavior.  As I've said before, I don't
> 	> > think there should be any option to circumvent a group stop via ptrace.
> 	> > If you think otherwise, you have a hard road to convince me of it.
> 
> I agree with Roland here.
> 
> 	> Yes, I do have some other ideas.  When a ptraced task gets a stop
> 	> signal, its delivery is controlled by the tracer, right?
> 
> Right, but note that the tracer does not fully control the group-stop.
> One a thread dequeues SIGSTOP (and please note this thread can be !traced),
> all other threads (traced or not) should participate.

I don't know.  Maybe it's more consistent that way and I'm not
fundamentally against that but it is a big behavior change and I don't
think it falls in the corner case category.  Please read on.

> As for SIGCONT priority, see below.
> 
> > Notifying the parent w/o making group stop superior to ptrace sure is
> > a possibility.
> 
> Could you please reiterate? I think I missed something before, and
> now I do not really understand what do you mean.

I was trying to say that it's still possible to deliver group stop
notifications to the real parent while letting the ptracer override
group stop with PTRACE_CONT.

> > > > For example, the problem in this thread is cleanly solved by
> > > > really examining the problem and fixing the problem at the source (the
> > > > mixup of group and ptrace stop)
> > >
> > > Yes, but I am worried that this change (in its current form) makes
> > > impossible to create a TASK_STOPPED tracee, but you already know this.
> >
> > Why is that a problem?
> 
> See above. Because I think ptrace should not "hide" jctl stops (at
> least by default), and SIGCONT should work in this case.
>
> > A ptraced task stops in TASK_TRACED.
> 
> Unless it reacts to SIGSTOP/group_stop_count.

What do you do about PTRACE requests while a task is group stopped?
Reject them?  Block them?

> > I agree that what
> > you're describing seems like a good compromise.  What I was objecting
> > to was putting group stop mechanism in general on top of ptrace.  I
> > can't see how that would work.
> 
> And I still can't understand why this can't work ;)
> 
> And I don't really understand "putting group stop mechanism in general
> on top of ptrace". It is very possible I am wrong, but I see this from
> the different angle: stop/ptrace should be "parallel".

Hmmm... currently ptrace overrides group stop and has full control
over when and where the tracee stops and continues, which I think is a
quite visible assumption.  I don't think it's an extreme corner case
we can break.  For example, if a user gdb's a program which raises one
of the stop signals, currently the user expects to be able to continue
the program from whithin the gdb.  If we make group stop override
ptrace, there's no other recourse than sending signal from outside.

It is a deep rooted assumption that ptracer has full control over
execution of the tracee.  I can't see how we would be able to change
that.  Moreover, although it may not be immediately intuitive, I
actually think it is more useful behavior for ptrace for
e.g. debugging multithread behavior as long as we can keep the whole
thing well defined.

> > I think it should only include the case where the
> > tracee actually stops for group stop excluding all other trapping
> > points.
> 
> I was thinking about this too and probably this makes sense. But
> I think at least initial changes should keep the current behaviour
> (assuming this behaviour is fixed).

But if you make the other change but not this one, we end up with
ptrace which doesn't notify the ptracer what's going on.  Apart from
_polling_ /proc/tid/status, there is no mechanism to discover the
tracee's state.  The only thing it achieves is the integrity of group
stop and I'm not really sure whether that's something worth achieving
at the cost of debugging capabilities especially when we don't _have_
to lose them.

> > But, I don't think this really changes the need for state tracking.
> > We would still have to put the tracee into approriate mode on detach.
> 
> Sure, but we already have SIGNAL_STOP_STOPPED/group_signal_stop. I meant,
> we do not need to remember the state per-thread.

Yeah, yeah, I was still thinking about allowing PTRACE_CONT in which
case we need to keep track of who did what.

> As for SIGCONT. Roland suggests (roughly) to change ptrace_resume()
> so that it doesn't wakeup the stopped tracee until the real SIGCONT
> comes. And this makes sense to me.

I agree it adds more integrity to group stop but at the cost of
debugging capabilities.  I'm not yet convinced integrity of group stop
is that important.  Why is it such a big deal?

> 	> For example, if a gdb traced task is instructed to participate in a
> 	> group stop and then hits a ptrace trap, it would have to participate
> 	> in the group stop as it enters ptrace trap, right?  gdb's wait(2)
> 	> would complete indicating ptrace trap.  After the user tells the task
> 	> to continue, the task shouldn't resume until SIGCONT is received;
> 
> Yes. But to me, this looks correct! The tracee shouldn't resume exactly
> because it is stopped.
> 
> 	> however, at this point, there's no way for gdb to tell what's going on
> 	> with the tracee.
> 
> Yes. I think this should be improved somehow, currently gdb can only
> look in /proc/tid/status to detect this case.
> 
> 	> If ptrace behaved like that from the beginning, gdb would have behaved
> 	> differently and worked around those cases but that hasn't been the
> 	> case
> 
> Cough... I thought we agreed it is better to break some corner cases
> but make ptrace more consistent ;)

Yeah, yeah, sure.  I just don't agree it is a corner case that we can
change.  It looks like a quite fundamental assumption/expectation to
me and changing it takes away existing debugging capabilities.  It's
something people would actually be using / used to.

> But yes, I see your point. And while I think that Roland's suggestion is
> fine, I also have another proposal
> 
> 	- never send CLD_CONTINUED to the tracer, always send it to parent.
> 
> 	  Firstly, this is completely pointless: ptrace is per-thread, while
> 	  this notification is per-process

CLD_STOPPED is too but while ptrace is attached the notifications are
made per-task and delivered to the tracer.  But, if there's no side
effect to worry about, sure.

> 	- change do_wait() so that WCONTINUED for real_parent
> 
> 	- change ptrace_resume() to check SIGNAL_STOP_STOPPED case. It should
> 	  act as SIGCONT in this case. Yes: "act as SIGCONT" needs more
> 	  discussion.

I don't know.  I think this is the key question.  Whether to de-throne
PTRACE_CONT such that it cannot override group stop.  As I've already
said several times already, I think it is a pretty fundamental
property of ptrace and change to it would be quite visible, in
negative way, from userland.  Furthermore, I think actually the
current behavior is more desirable, not from the POV of group stop
integrity but from that of debugging capabilities.  I don't think
group stop integrity is that important as long as we can keep the
state well defined while ptraced && consistent after the debugger is
gone.

Thanks.

-- 
tejun
