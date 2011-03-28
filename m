Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab1C1I6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 04:58:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37949 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab1C1I62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 04:58:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Z9BIA2nVvvRQQYMtdcG1C79UifaiAFsTL5+0viTKzHn3Y5NQg/1fvTbHV4VNVb/fso
         2K6K0I7bM+qwlzgQyw9mavUIoO20bsHU/Db6loQckv9G+3XC9GH3/Pnt5cG/XSwQRInj
         ZC9aRVjs8ai4kTFgMEo/JStceHiGTax9yxDaU=
Date: Mon, 28 Mar 2011 10:58:24 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, roland@hack.frob.com
Subject: Re: [PATCHSET] ptrace,signal: Improve ptrace and job control
 interaction
Message-ID: <20110328085824.GE16530@htj.dyndns.org>
References: <1300874766-12941-1-git-send-email-tj@kernel.org>
 <20110323183837.GA27680@redhat.com>
 <20110325142630.GD1409@htj.dyndns.org>
 <20110326182554.GA24315@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110326182554.GA24315@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Sat, Mar 26, 2011 at 07:25:54PM +0100, Oleg Nesterov wrote:
> > Explicit wake_up_state() without kick_process() is okay there because
> > if the code assumes that the tasks are guaranteed to pass through
> > signal delivery path whenever event worthy of notification happens
> > (either SIGNAL_STOP_STOPPED or group_stop_count is set).  PTRACE_CONT
> > breaks that as the tracee could be running in userland and thus the
> > solution is to add kick_process() as in signal_wake_up().
> >
> > Am I making any sense?
> 
> Perhaps. This depends on how we define/implement the new behaviour.
> 
> It is not clear to me what the new trap should actually do. And how.
> Either way, prepare_signal(SIGCONT) should do something with the
> ptraced threads, and this is what we should care about. Probably
> we can set TIF_SIGPENDING if task_ptrace() is true.
> 
> Anyway we should ensure SIGCONT can't race with detach.

Hmmm... setting TIF_SIGPENDING and kicking the task to enter signal
delivery path doesn't have any side effect when it's running in
userland, which is the problematic case here anyway.  Is there any
reason we should be careful about this?

> > * Before CLD_STOPPED notification for the incomplete-stop/cont
> >   sequence can be made, recalc_sigpending() happens.
> >
> > * CLD_STOPPED notification is pending but TIF_SIGPENDING isn't set and
> >   the task isn't in signal delivery path and can continue execution.
> 
> This doesn't matter, or I misunderstood.
> 
> We only add "SIGNAL_CLD_* | SIGNAL_STOP_CONTINUED" if we know there
> is at least one thread in get_signal_to_deliver()->do_signal_stop()
> paths. In this case we do not rely on TIF_SIGPENDING at all.

We set SIGNAL_CLD_STOPPED if group_stop_count wasn't zero, ie. if
group stop has initiated, which will be delivered as soon as any task
enters signal delivery path.  So, there's a path that we schedule a
notification and doesn't enforce the delivery until something happens
and a task in the group gets called into signal delivery path somehow,
which is wrong.  We need to call them into the delivery path on the
generation of the notification regardless of ptrace.

Thanks.

-- 
tejun
