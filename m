Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab1ESKeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 06:34:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51673 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab1ESKeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 06:34:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=S8aY2YmPb7J5CzhG51CXBs4aiaEkAsFSJ5Xd8iBhImV6nqxOHYORunkrkOr0xe1hGT
         2V8DhqWvzK8haShBAM5DBl0SXhaKqnCEP5pz6IohB+c7noZt9uPuRf+167yc7WyrWlU8
         ukKQGNww63ez++6AJSNj4o15Hc09iTHOvxHG4=
Date: Thu, 19 May 2011 12:34:12 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Message-ID: <20110519103412.GD627@htj.dyndns.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
 <1305569849-10448-4-git-send-email-tj@kernel.org>
 <20110518181756.GA30250@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518181756.GA30250@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, May 18, 2011 at 08:17:56PM +0200, Oleg Nesterov wrote:
> On 05/16, Tejun Heo wrote:
> >
> > @@ -315,6 +338,9 @@ static int ptrace_attach(struct task_struct *task)
> >  	if (task_is_stopped(task)) {
> >  		task->jobctl |= JOBCTL_TRAP_STOP | JOBCTL_TRAPPING;
> >  		signal_wake_up(task, 1);
> > +	} else if (seize) {
> > +		task->jobctl |= JOBCTL_TRAP_STOP;
> 
> So, this can race with do_signal_stop(), it can clear TRAP_STOP and
> JOBCTL_STOP_PENDING can guarantee the tracee will trap later.

Confused.  How can do_signal_stop() clear TRAP_STOP?

> > +	 * When PT_SEIZED, it's used for both group stop and explicit
> > +	 * SEIZE/INTERRUPT traps.  Both generate PTRACE_EVENT_STOP trap
> > +	 * with accompanying siginfo.
> > +	 *
> > +	 * When !PT_SEIZED, it's used only for group stop trap with
> > +	 * CLD_STOPPED as exit_code and no siginfo.
> >  	 */
> >  	if (unlikely(current->jobctl & JOBCTL_TRAP_MASK)) {
> > -		signr = current->jobctl & JOBCTL_STOP_SIGMASK;
> > -		WARN_ON_ONCE(!signr);
> > -		ptrace_stop(signr, CLD_STOPPED, 0, NULL);
> > -		current->exit_code = 0;
> > +		if (current->ptrace & PT_SEIZED) {
> > +			ptrace_do_notify(SIGTRAP | PTRACE_EVENT_STOP << 8,
> > +					 CLD_STOPPED);
> 
> So. When PT_SEIZED, we always report PTRACE_EVENT_STOP and PTRACE_GET_SIGINFO
> always works.
> 
> Personally I agree, this looks more clean and natural.

Yeah, I like it much better.  INTERRUPT trap and group stop trap being
separate while sharing some attributes was disturbing.

Thanks.

-- 
tejun
