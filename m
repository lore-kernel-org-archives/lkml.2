Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab1CWIAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 04:00:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39246 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410Ab1CWIAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 04:00:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aPNZ0GzUOtf/mFF4MppxrL0krDFo1039tWWkaAEfIuW3Bj/zFEChd7H3AvtvNsKITC
         EUsZV98tdpc88E91R1iwty68teyaQCK/qNmdRNSyeFJp5pIww5E2Nle1yodgZ9cpI51I
         P7zc3HKXdLeIZmTO4aXq8vFG6/EWR5rQxFFxA=
Date: Wed, 23 Mar 2011 09:00:10 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 0.2/8] ptrace: Always put ptracee into appropriate
 execution state
Message-ID: <20110323080010.GV12003@htj.dyndns.org>
References: <1299614199-25142-1-git-send-email-tj@kernel.org>
 <20110322102046.GO12003@htj.dyndns.org>
 <20110322203322.GD28038@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110322203322.GD28038@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Mar 22, 2011 at 09:33:22PM +0100, Oleg Nesterov wrote:
> > +	/*
> > +	 * Reinstate GROUP_STOP_PENDING if group stop is in effect and
> > +	 * @child isn't dead.
> > +	 */
> > +	if (!(child->flags & PF_EXITING) &&
> > +	    (child->signal->flags & SIGNAL_STOP_STOPPED ||
> > +	     child->signal->group_stop_count))
> > +		child->group_stop |= GROUP_STOP_PENDING;
> 
> Why do we need to filter out PF_EXITING tasks? This doesn't look
> strictly necessary. And note that exit_signals() doesn't always
> take ->siglock, we can race anyway.

I don't think it's strictly necessary either but in the usual group
stop initiation path in do_signal_stop(), PF_EXITING is checked before
setting PENDING, so I think it's better to remain consistent with
that.

> > +	 * Note that @resume should be used iff @child
> > +	 * is in TASK_TRACED; otherwise, we might unduly disrupt
> > +	 * TASK_KILLABLE sleeps.
> 
> Yes. but, just in case,
> 
> > +	 */
> > +	if (child->group_stop & GROUP_STOP_PENDING || task_is_traced(child))
> > +		signal_wake_up(child, task_is_traced(child));
> 
> signal_wake_up() is not needed if task_is_traced(). Even if we added
> GROUP_STOP_PENDING, ptrace_stop() does recalc_sigpending_tsk() anyway
> before return.
> 
> So we could do
> 
> 	if (SIGNAL_STOP_STOPPED || group_stop_count) {
> 		child->group_stop |= GROUP_STOP_PENDING;
> 		signal_wake_up(child, 0);
> 	}
> 
> 	if (task_is_traced(child))
> 		wake_up_state(TASK_TRACED);
> 
> But probably a single wakeup looks more simple/clean, so I agree.

Yeah, I'd like to avoid mixing calls to wake_up_state() and
signal_wake_up().  It gets confusing and there's no reason for
micro-optimization here.

Thanks.

-- 
tejun
