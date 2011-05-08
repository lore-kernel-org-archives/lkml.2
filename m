Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab1EHPzx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 11:55:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40372 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab1EHPzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 11:55:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=o5NyxPMXvm/4M9JMYqIPc1TSmM+UXY/Och1KKVn0beuiRcV4OlBhfMlnqr4aQgiFpa
         rUluv66C5APiiW7JsJexcffRNHlsZ1eudg3fQr5DbUC1LLzXRhSWdfcHqniNQgi/e0h6
         2IfAhW4uoq4rYxBcgpXPfHjnUjW+Q8n6u74LU=
Date: Sun, 8 May 2011 17:55:47 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH ptrace] ptrace: fix signal->wait_chldexit usage in
 task_clear_group_stop_trapping()
Message-ID: <20110508155547.GA1661@htj.dyndns.org>
References: <20110506095222.GB8824@htj.dyndns.org>
 <20110508133543.GA4820@redhat.com>
 <20110508140221.GA29783@htj.dyndns.org>
 <20110508153435.GA11046@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110508153435.GA11046@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, May 08, 2011 at 05:34:35PM +0200, Oleg Nesterov wrote:
> But this is subjective too, and I agree that the future patches can
> change the current trivial contract. So:
> 
> Reviewed-by: Oleg Nesterov <oleg@redhat.com>
> 
> I'll add this fix to my tree.

Great, thanks.

> > > Hmm. This is minor and off-topic, but perhaps it makes sense to move
> > > the code which sets/waits GROUP_STOP_TRAPPING from ptrace_attach() to
> > > the separate function, it can be called outside of tasklist_lock and
> > > cred_guard_mutex.
> >
> > I'm confused.  It should be set while siglock is held.  Which place
> > are you suggesting?
> 
> Of course, we should take siglock. I meant, we could probably make
> 
> 	static void ptrace_s_stopped_traced(struct task_struct *task)
> 	{
> 		bool wait_trap = false;
> 
> 		spin_lock(&task->sighand->siglock);
> 		/*
> 		 * If the task is already STOPPED, set GROUP_STOP_PENDING and
> 		 * TRAPPING, and kick it so that it transits to TRACED.  TRAPPING
> 		 * will be cleared if the child completes the transition or any
> 		 * event which clears the group stop states happens.  We'll wait
> 		 * for the transition to complete before returning from this
> 		 * function.
> 		 *
> 		 * This hides STOPPED -> RUNNING -> TRACED transition from the
> 		 * attaching thread but a different thread in the same group can
> 		 * still observe the transient RUNNING state.  IOW, if another
> 		 * thread's WNOHANG wait(2) on the stopped tracee races against
> 		 * ATTACH, the wait(2) may fail due to the transient RUNNING.
> 		 *
> 		 * The following task_is_stopped() test is safe as both transitions
> 		 * in and out of STOPPED are protected by siglock.
> 		 */
> 		if (task_is_stopped(task)) {
> 			task->group_stop |= GROUP_STOP_PENDING | GROUP_STOP_TRAPPING;
> 			signal_wake_up(task, 1);
> 			wait_trap = true;
> 		}
> 		spin_unlock(&task->sighand->siglock);
> 
> 		if (wait_trap)
> 			wait_event(current->signal->wait_chldexit,
> 				   !(task->group_stop & GROUP_STOP_TRAPPING));
> 		return retval;
> 	}
> 
> called by ptrace_attach() at the end.

Ah, okay.  Yeah, that might be a good idea but in the just posted
patch series, I implemented a different helper and moved the wait back
into ptrace_check_attach(), so if it needs further cleanup, it would
be great if we could do it on top of the series.

Thanks.

-- 
tejun
