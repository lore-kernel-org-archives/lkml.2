Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab1EKTxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 15:53:39 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40899 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab1EKTxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 15:53:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DuLGjtI1pFNM4H2eSRzpPN5jbrqthiTb/68pvywo1bXSgCxGBXbnc9//JdFsL1L4aK
         7JOEObfH+Wg4pjOrZYw7G2LvHoPsUJs4GLDkJjm2/0sQjXjtngbXLAtIQuioNX7G38qw
         eS+f4WpoBZ+zkEW8MywFQj2w61U2em9sckl+8=
Date: Wed, 11 May 2011 21:53:33 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 10/11] ptrace: move JOBCTL_TRAPPING wait to wait(2) and
 ptrace_check_attach()
Message-ID: <20110511195333.GE24245@mtj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-11-git-send-email-tj@kernel.org>
 <20110511164947.GA26383@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110511164947.GA26383@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, May 11, 2011 at 06:49:47PM +0200, Oleg Nesterov wrote:
> On 05/08, Tejun Heo wrote:
> > this patch moves TRAPPING wait from attach completion path to
> > operations which are actually affected by the transition - wait(2) and
> > following ptrace(2) requests.
> 
> You know, I'd wish I could find the serious bugs in this patch. The
> code becomes really hairy. -EAGAIN in do_wait() doesn't make it more
> simple ;)

I don't know.  Why is retrying hairy?  The whole waiting logic is
built for clean retries.  The suggested change just does it without
intervening sleeping and waking up.  I don't see anything particularly
hairy there.

> > Both wait and ptrace paths are updated to retry the operation after
> > TRAPPING wait.  Note that wait_task_stopped() now always grabs siglock
> > for ptrace waits.  This can be avoided with "task_stopped_code() ->
> > rmb() -> TRAPPING -> rmb() -> task_stopped_code()" sequence
> 
> And so far I think this would be better, because it seems we can avoid
> the retry logic.

Well, the above memory barrier dance wouldn't really change whether
retry logic is required or not and I'd _really_ like to avoid complex
barrier dances.  Even the typical write-B wmb() write-A / read-A rmb()
read-B barriers often confuse people.  I don't wanna throw in stacked
wmb()/rmb() pairs there even if that means an extra locking for ptrace
waits.

> First of all, this patch returns one of the user-visible and undesirable
> changes. The tracer know that the task is stopped, attaches, and then it
> can see the TASK_RUNNING tracee after ptrace(PTRACE_ATTACH) returns.

Yes, it does.  Sorry about forgetting to mention it in the patch
description.  I believe this is something we can swallow.

> I agree, this looks minor. But if we can tolerate this, probably we can
> tolerate another oddity: wait_task_stopped() can succeed and eat the
> stop code before the tracee actually stopps, no?
> 
> IOW, ignoring mb's and read-ordering, suppose that we simply change
> task_stopped_code:
> 
> 		if (ptrace) {
> 	-		if (task_is_stopped_or_traced(p))
> 	+		if (task_is_traced(p) || JOBCTL_TRAPPING)
> 				return &p->exit_code;
> 		} else {
> 
> As for ptrace_check_attach(), it can simply do wait_event(), we
> only need to verify the caller is the tracer. No need to play with
> lock/unlock/retry.
> 
> What do you think?

Hmmm... interesting.  Yeah, the state is visible only through wait(2)
and ptrace(2) and for wait(2) TRAPPING is as good as STOPPED/TRACED
and we can wait all we want in ptrace_check_attach().  I'll think more
about it but seems like a nice idea.

Thank you.

-- 
tejun
