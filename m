Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711Ab1BDOtH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 09:49:07 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37654 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab1BDOtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 09:49:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dSh9iD6d+jhl+koCBWF5RtFu+Ra8kotSeDJCf/YCz9TA9UJWpnQJ8NF9h8VbLjCEBr
         5mNZImzRe+R4YJJ0SI13jJtFDow37LlLmtY57C0BZSciYKbvRD2siXN5gs1M/WpYY7vc
         ywLCgXOd/P+7TkmUICqPeXRdwUiG7qR6k6Jpo=
Date: Fri, 4 Feb 2011 15:48:58 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110204144858.GI12133@htj.dyndns.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
 <1296227324-25295-11-git-send-email-tj@kernel.org>
 <20110203204122.GA26371@redhat.com>
 <20110203204154.GB26371@redhat.com>
 <20110203213640.1F516180995@magilla.sf.frob.com>
 <20110203214450.GA29496@redhat.com>
 <20110204105343.GA12133@htj.dyndns.org>
 <20110204130455.GA3671@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110204130455.GA3671@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, guys.

On Fri, Feb 04, 2011 at 02:04:55PM +0100, Oleg Nesterov wrote:
> > Hmm... I can't reproduce the problem here,
> 
> Very strange. Do you mean the test-case doesn't die? (on vanilla kernel).

Heh, it turns out the second child was attaching before the first
succeeded stopping itself, so when it gets detached for the first
time, the first child then stops generating new exit_code.  Adding a
small delay to the parent after the first child started made it
reliably fail on the vanially kernel.

> > but isn't the problematic
> > part here the mixing of ptrace and group stop and sliently
> > transforming group stop into ptrace
> 
> Not exactly,
> 
> > and ptracer consuming the usual
> > exit code instead of the ptrace specific one?
> 
> Well, unless the task dies nobody except ptrace can use ->exit_code.
> 
> The problem is:
> 
> 	- the task T stops, it sets ->exit_code exactly because
> 	  the tracer can attach after that
> 
> 	- the tracer attaches, does wait(), consumes exit_code
> 	  and exits
> 
> 	- another tracer attaches, but exit_code == 0
> 
> There is no STOPPED/TRACED transformation at all.

But it is.  It happens because there is no clear distinction between
group stop and ptrace_stop.  With my first series applied, it doesn't
happen anymore because ptracer _never_ depends on or consumes group
stop exit_code.  The exit_code is cached in task->group_stop and used
when the tracee enters ptrace_stop() for group stop.  It doesn't
matter how many times it gets detached, re-attached or someone else
consuming the group stop exit_code.

> > Also, I don't agree with the notion that doing something entirely new
> > would magically solve all the problems.  Improvements are achieved
> > through evolution.  For ptrace, the situation definitely is aggravated
> > by the use of wait
> 
> ... and reparenting, and signals.
> 
> > and weird interaction with group stop,
> 
> Yes. And to me the main problem is not the current behaviour. The
> problem is that we never tried to define the correct behavior.
> OK, real_parent can miss the notification. We can fix this, but
> for what? The tracer can resume the thread "silently", this doesn't
> look very good anyway.

Yes, I agree it's ugly but that's what we already have.  I think we
can still achieve well-defined behavior even with ptracer allowed to
diddle with the task while group stop is in effect.  It may not be
immediately intuitive but I personally think it actually would be more
useful to do things that way, as long as we clearly lay out what are
supported what are undefined.

I think a good compromise would be guaranteeing that when the ptracer
goes away, the tracee would put into the state the real parent can
agree to and the real parent to be notified that it has happened.  We
are already skipping all notifications to the real parent for ptraced
children, there's no pressing need to change that.  If there becomes a
real pressing requirement to change that.

> But even this doesn't matter. We can not change ptrace API so that,
> say, it does not reparent the tracee. Once we do this, we already
> have the new API.

I would argue that we can get by well enough by trimming and updating
the curren ptrace API.

> So, personally I think we need the new API. And we already have
> utrace which allows to implement "anything" on top of it, including
> the old ptrace for compatibility.

I could be wrong (with pretty high probability) but I don't really see
the pressing need for a completely new API.  ptrace sure is ugly and
quirky but it's something people are already used to.

> Well, perhaps I am wrong, this is only my opinion.

That's all anyone can do anyway and I'm much more likely to be wrong
on the subject than you and Roland.  I just hope to find out where I'm
wrong.

Thank you.

-- 
tejun
