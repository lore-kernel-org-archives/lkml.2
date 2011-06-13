Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab1FMOKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 10:10:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42456 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab1FMOK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 10:10:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dQVnEnRkJUVq/7RNO4H9A6ohOBg8arvFb9Zxm7kLQXV3KX0tAnPJsmqL8coE7zTDKU
         NN9/cfTgon/mNeuZuw/l7ipFyhu+XbjJ98w3VhDpbdjJMQZTWfxZz8q4Vwv2hYY3d7H9
         tEiCo+RJtmUc9TqG9o9xxPoqOPp7xHJBoyXeM=
Date: Mon, 13 Jun 2011 16:10:23 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com
Subject: Re: [PATCH 17/17] ptrace: implement PTRACE_LISTEN
Message-ID: <20110613141023.GA8141@htj.dyndns.org>
References: <1306710760-16440-1-git-send-email-tj@kernel.org>
 <1306710760-16440-18-git-send-email-tj@kernel.org>
 <20110602173330.GA20384@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110602173330.GA20384@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Thu, Jun 02, 2011 at 07:33:30PM +0200, Oleg Nesterov wrote:
> >  	p_code = task_stopped_code(p, ptrace);
> > -	if (unlikely(!p_code))
> > +	if (unlikely(!p_code) || p->jobctl & JOBCTL_LISTENING)
> >  		goto unlock_sig;
> 
> Up to you, but perhaps this JOBCTL_LISTENING check should go into
> task_stopped_code() ? Or do you think we can't check it without
> siglock?

So updated.  I don't think it's gonna introduce any new race
condition.

> > +		/*
> > +		 * If NOTIFY is set, it means event happened between start
> > +		 * of this trap and now.  Trigger re-trap immediately.
> > +		 */
> > +		if (child->jobctl & JOBCTL_TRAP_NOTIFY)
> > +			signal_wake_up(child, true);
> 
> Again, I won't insist if you prefer signal_wake_up(), but afaics
> wake_up_state(__TASK_TRACED) should be enough.

Re-trapping from attach/detach paths are already using
signal_wake_up() and I think it would be better to keep it consistent.

> > @@ -838,7 +840,7 @@ static void ptrace_trap_notify(struct task_struct *t)
> >  	assert_spin_locked(&t->sighand->siglock);
> >
> >  	task_set_jobctl_pending(t, JOBCTL_TRAP_NOTIFY);
> > -	signal_wake_up(t, 0);
> > +	signal_wake_up(t, t->jobctl & JOBCTL_LISTENING);
> >  }
> 
> OK. The only thing I can't understand is why prepare_signal(SIGCONT)
> calls ptrace_trap_notify() unconditionally. How about
> 
> 		if (likely(!(t->ptrace & PT_SEIZED)))
> 			wake_up_state(t, __TASK_STOPPED);
> 	-	else
> 	+	else if (why)
> 			ptrace_trap_notify(t);
> 
> ?

I'm having a Deja Vu.  Did I reply to this already?  Anyways, here are
my rationales.

* Tracer should be able to handle seemingly spurious notifications.
  e.g. rapid SIGSTOP/CONT sequence may generate seemingly spurious
  notifications even when it actually isn't spurious.

  SIGCONT always generating notification is correct and I don't see
  good reasons to optimize it.  Moreover, I think it doesn't hurt to
  have a way to reliably trigger spurious notification.

* If we're gonna optimize out SIGCONT processing if the target process
  doesn't need it, the proper way would be testing stopped state and
  exit before walking through the group list.  However, I think it's
  done the current way for a reason - always trying to wake up on
  SIGCONT is more robust in case something went out of sync &&
  optimizing spurious SIGCONT doesn't really help anyone.

So, I'd like to keep this one as it currently is.  It's more robust
and useful this way.

Thanks.

-- 
tejun
