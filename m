Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab1EJNr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 09:47:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33936 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab1EJNr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 09:47:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FhaJXhovWdm7UIN7TlQkzQ/d1A+aDucmnK/hyjObEb7XWFViByFNuyMUsD+gAIFqri
         Ae+Hsk/mdZnb+WhfqYLe44IFPzoWASNqMGVAxUc3thVSHKG7BpgBmGJdzs4alcdhGtui
         cEFD8gJeQzqFM8CRsPWmIICydG9lMelKXuG9k=
Date: Tue, 10 May 2011 15:47:52 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 02/11] ptrace: implement PTRACE_SEIZE
Message-ID: <20110510134752.GW1661@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-3-git-send-email-tj@kernel.org>
 <20110509161838.GA27473@redhat.com>
 <20110510094650.GQ1661@htj.dyndns.org>
 <20110510132001.GA21834@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110510132001.GA21834@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Oleg.

On Tue, May 10, 2011 at 03:20:01PM +0200, Oleg Nesterov wrote:
> > Hmmm... if killed, the tracee would go through __ptrace_unlink() which
> > always clears JOBCTL_TRAP_MASK which includes JOBCTL_TRAP_SEIZE.  What
> > am I missing?
> 
> No. If killed, the tracee becomes a zombie (but see below). __ptrace_unlink()
> won't be called until the tracee does wait().

Ah, right.

> Yes, and thus the tracee will loop forever until the tracer detaches, so
> it can't even become a zombie. And the tracer can't detach via ptrace().

I think this basically is the same problem as the using TRAPPING on
PTRACE_DETACH one.  Do you recall the original version where TRAPPING
was cleared on kill via clear_pending instead of at the end of
do_signal_stop()?  I think that's what we should do.  We should be
clearing these conditions when the actions which should override these
conditions happen instead of trying to put them in the tracee
expecting control to be at certain places and to me
task_clear_jobctl_stop_pending() seems to be the best place to do
that.  We might need to rename it and maybe add a parameter tho.

How does it sound to you?  It would solve the TRAPPING issue too.

> > > I never understood why ptrace_stop()->sigkill_pending() logic, I think
> > > we should check fatal_signal_pending() unconditionally.
> >
> > Probably the best way to do it is adding fatal_signal_pending() into
> > may_ptrace_stop() so that the failure path shares most of the code
> > path instead of doing quick dirty exit?  It's just nasty to have early
> > exit above there and walking through the normal code path wouldn't
> > hurt SIGKILL either.
> 
> Yes, probably. But, apart from the user-visible change which needs another
> discussion, there are more problems. fatal_signal_pending() can "wrongly"
> return false if the caller is tracehook_report_exit(). OTOH, it can correctly
> return true (exec), but we probably want to stop. Let's discuss this later,
> I think this has nothing to do with your patches. The main problem is not
> fatal_signal_pending(), we need the better definition of explicit SIGKILL
> behaviour. Not for ptrace only, there are other issues.

Alright, let's put it aside for now.

Thank you.

-- 
tejun
