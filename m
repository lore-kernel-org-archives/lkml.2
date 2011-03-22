Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab1CVIEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 04:04:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62469 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab1CVIEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 04:04:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MBnYpJUexaxCoDZ9azbYTeD2Q1WCTUDSaLGbWzoO1hdKORH9kM6yqe5w2wTTQ6jMFh
         maAMKpAAJrFSyR/9D8pYFmAjI/KWks/cqCxxhBoWGcap00s9iXoh815iBZyV+BNQ22iC
         5eeN7aKJe9lv0ngU79SntphO7/TSrT7UjloW0=
Date: Tue, 22 Mar 2011 09:04:44 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 7/8] job control: Notify the real parent of job control
 events regardless of ptrace
Message-ID: <20110322080444.GM12003@htj.dyndns.org>
References: <1299614199-25142-1-git-send-email-tj@kernel.org>
 <1299614199-25142-8-git-send-email-tj@kernel.org>
 <20110321174306.GA29895@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110321174306.GA29895@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 06:43:06PM +0100, Oleg Nesterov wrote:
> > + * Test whether the target task of the usual cldstop notification - the
> > + * real_parent of the group_leader of @child - is the ptracer.
> > + */
> > +static bool real_parent_is_ptracer(struct task_struct *child)
> > +{
> > +	return child->parent == child->group_leader->real_parent;
> > +}
> 
> Again, I am not sure we do not need same_thread_group(), but this
> is minor.

Yeah, same_thread_group() would be better.

> Hmm... in fact I can't convince myself we really need to look at
> child->group_leader, will recheck... Anyway, this is minor too.

Care to elaborate?

> > @@ -1757,7 +1768,20 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
> >  	spin_unlock_irq(&current->sighand->siglock);
> >  	read_lock(&tasklist_lock);
> >  	if (may_ptrace_stop()) {
> > -		do_notify_parent_cldstop(current, task_ptrace(current), why);
> > +		/*
> > +		 * Notify parents of the stop.
> > +		 *
> > +		 * While ptraced, there are two parents - the ptracer and
> > +		 * the real_parent of the group_leader.  The ptracer should
> > +		 * know about every stop while the real parent is only
> > +		 * interested in the completion of group stop.  The states
> > +		 * for the two don't interact with each other.  Notify
> > +		 * separately unless they're gonna be duplicates.
> > +		 */
> > +		do_notify_parent_cldstop(current, true, why);
> > +		if (gstop_done && !real_parent_is_ptracer(current))
> > +			do_notify_parent_cldstop(current, false, why);
> 
> OK.
> 
> But what about "else" branch? If gstop_done == T but debugger has gone
> between spin_unlock(siglock) and read_lock(tasklist), we should do
> something.
> 
> ptrace_untrace() restores GROUP_STOP_PENDING in this case, so this task
> will stop again. But notification is lost.
> 
> Just in case, it is not that I blame this patch. Just I think we need
> a bit more changes here. Unless I missed something.

You mean when may_ptrace_stop() fails, right?  Yeah, we need
notification in the else clause.  Will add it.

Thanks.

-- 
tejun
