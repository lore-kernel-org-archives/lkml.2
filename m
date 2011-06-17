Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287Ab1FQPMn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 11:12:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56619 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759210Ab1FQPMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 11:12:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=v+/P6oAKhKGyJfWO1BRha8FLdiiD/yraUGXfJrFTFNcQ5v4br3Qm6921qJRXMLhGKM
         cQgai23H50QCtDedt892ZsH57HoQG02B9v8NMFC3FJe+Qxr/0H2H9/mqNxfRGbX1A5KH
         6oD4HVMtttlPB2A3PQtpZGDc71bOxf7CZVhAw=
Date: Fri, 17 Jun 2011 17:12:36 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com
Subject: Re: [PATCH 4/5] ptrace: implement TRAP_NOTIFY and use it for group
 stop events
Message-ID: <20110617151236.GI2611@htj.dyndns.org>
References: <1308043218-23619-1-git-send-email-tj@kernel.org>
 <1308043218-23619-5-git-send-email-tj@kernel.org>
 <20110616195138.GB14786@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110616195138.GB14786@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Thu, Jun 16, 2011 at 09:51:38PM +0200, Oleg Nesterov wrote:
> I already applied this series. But somehow I have the fuzzy feeling we
> can simplify JOBCTL_TRAP_NOTIFY/JOBCTL_TRAP_STOP logic later. No, I can't
> explain what I mean ;)

Heh, yeah, please go ahead.

> One question,
> 
> > @@ -1797,8 +1824,10 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
> >  	if (why == CLD_STOPPED && (current->jobctl & JOBCTL_STOP_PENDING))
> >  		gstop_done = task_participate_group_stop(current);
> >
> > -	/* any trap clears pending STOP trap */
> > +	/* any trap clears pending STOP trap, STOP trap clears NOTIFY */
> >  	task_clear_jobctl_pending(current, JOBCTL_TRAP_STOP);
> > +	if (info && info->si_code >> 8 == PTRACE_EVENT_STOP)
> > +		task_clear_jobctl_pending(current, JOBCTL_TRAP_NOTIFY);
> 
> OK, but can't we check why == CLD_STOPPED instead of PTRACE_EVENT_STOP?

Yeap, sure.  The reason why I used PTRACE_EVENT_STOP was because
PTRACE_LISTEN needs the same test and it doesn't have access to @why.
Maybe it's better to create ptrace_is_trap_stop(si)?

> In fact, can't we move all code above under 'if (why == CLD_STOPPED)' ?
> JOBCTL_TRAP_STOP can't be set otherwise, no? I am almost sure I missed
> something though.

JOBCTL_TRAP_STOP should also be cleared on CLD_TRAPPED traps.  ie. If
the ptracer does PTRACE_INTERRUPT and then wait(2) reports
PTRACE_EVENT_FORK, there won't be another PTRACE_EVENT_STOP.

Thanks.

-- 
tejun
