Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab0LWQgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 11:36:10 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40564 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab0LWQgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 11:36:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=t9jgD51EvthnKhXtcakcC8sYKy5bPfCgUIPnQd68O+YsFb8qA/QDUKPiBOf/t+nQrM
         RY6V8/MOY4gVlgFnXxc/O32DnR31rEIFk1Tqz7ffSjI/vwF7i0AKiLXixLYQHwOVWwWw
         KjwMfTKFJEgP3dEVeZxOPNLLWwkR2vXqzFTMQ=
Date: Thu, 23 Dec 2010 17:33:15 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 09/16] ptrace: make do_signal_stop() use ptrace_stop()
 if the task is being ptraced
Message-ID: <20101223163315.GD18482@htj.dyndns.org>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
 <1291654624-6230-10-git-send-email-tj@kernel.org>
 <20101223122634.GA365@redhat.com>
 <20101223135330.GA18482@htj.dyndns.org>
 <20101223160648.GA10096@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101223160648.GA10096@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 05:06:48PM +0100, Oleg Nesterov wrote:
> > Yes, before the change, the task would respond to SIGCONT before the
> > first ptrace request succeeds after attach.
> 
> Not exactly. But perhaps you meant that even without this change,
> any ptrace() request after ptrace(PTRACE_CONT, SIGSTOP) will change
> child->state = TASK_TRACED, and kill(SIGCONT) won't work after that.

Yeap, exactly.

> > To me, this doesn't seem to be anything intentional tho.  It seems
> > a lot of ptrace and group stop interactions is in the grey area
> > with only the current (quirky, I'm afraid) behavior drawing almost
> > arbitrary lines across different behaviors.
> 
> Agreed.
> 
> However. Strangely, I didn't think about this before. With this
> change, it is not possible to trace/debug the application so that
> it can properly react to SIGCONT. Yes, currently we have a lot
> more problems here, including do_wait, so probably this doesn't
> matter.
> 
> Still I'd like to know what Jan and Roland think. I am paranoid,
> yes ;)

Definitely.

Hmm... the mention of SIGCONT behavior reminds me of your mention of
notification behavior on the other message.  I might write a more
detailed reply there but, anyways, I don't think we'll be able to find
one good behavior with the current set of operations.  If we hide the
group stop handling and notification from the ptracer, it would allow,
for example, transparent strace, but it will at the same time restrict
what a debugger can do behind the tracee's back in a regressive way
(ie. the current users would notice).

I think it would be better to introduce a few new ptrace operations
and give them more control in clearly defined and hopefully intutive
way.  For example, a ptracer is notified when a task is stopping for
group stop and it should be able to decide and tell the kernel whether
to participate in the group stop or not.  For SIGCONT, likewise, the
kernel can notify all ptracers in the group and can notify the real
parent if all ptracers decide to participate in the continuation.

That way, debuggers can still work behind the real parent's back (they
often want to) while audit type tools can sniff transparently.  I
think the trickier part would be adapting the existing operations so
that they have clearly defined (mostly) compatible behavior while not
hindering too much with addition of new capabilities.

Thanks.

-- 
tejun
