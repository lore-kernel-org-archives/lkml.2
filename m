Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab1EPNQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 09:16:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55031 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab1EPNQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 09:16:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fUX6ciSkVQPdSbVY0IzbhxVn8t1kZeaXZxxjOZi8fl+rTosSSxJEESmzhS1h1XvAxj
         0BvjmxUZm8DMfR7/0JSAskbpXQ1/L+0a1QPhf/Zlx/UsCpkCxDSXGUFGhSWSZ75A5HbQ
         Vo1WNLI6E+lkKPtGEoYXOKdrLv1tT0+5XsOhg=
Date: Mon, 16 May 2011 15:16:08 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 4/9] ptrace: relocate set_current_state(TASK_TRACED) in
 ptrace_stop()
Message-ID: <20110516131608.GX23665@htj.dyndns.org>
References: <1305301580-9924-1-git-send-email-tj@kernel.org>
 <1305301580-9924-5-git-send-email-tj@kernel.org>
 <20110516115711.GB4898@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516115711.GB4898@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Oleg.

On Mon, May 16, 2011 at 01:57:11PM +0200, Oleg Nesterov wrote:
> > and helps future updates to group stop participation.
> 
> OK, so I assume we need this change.

We don't necessarily need it but it makes things prettier later.

> But the comment looks a bit confusing to me. This is fine, I almost never
> read them ;) Just I'd like to ensure I din't miss something.

Oleg, IIRC, those comments were taken from your email pointing out
that set_current_state() needs to happen before clearing of TRAPPING,
so, if you're confused, I'm confused too. :-)

> > +	 * We're committing to trapping.  TRACED should be visible before
> > +	 * TRAPPING is cleared
> 
> This looks as if you explain the barrier in set_current_state(). And,
> btw, why can't we use __set_current_state() here ?
> 
> And. not only TRACED, at least ->exit_code should be visible as well.

The racy part was task_is_stopped_or_traced() in task_stopped_code()
and the value of exit_code doesn't matter at that point.  So, we need
at least smp_wmb() between __set_current_state() and clearing
TRAPPING.

> IOW. It is not that TRACED should be visible before jobctl &= ~JOBCTL_TRAPPING,
> we should correctly update the tracee before __wake_up_sync_key(), and I assume
> this is what the comment says.
> 
> Correct?

All we need to update on the tracee is tracee->state and
~JOBCTL_TRAPPING and __wake_up_sync_key() can be considered single
operation.  One doesn't make sense with the other.  Anyways, if you
wanna update the comment, please go ahead.

Thanks.

-- 
tejun
