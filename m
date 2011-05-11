Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab1EKUSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 16:18:54 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53996 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab1EKUSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 16:18:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dOWDSbZ4jUQ+sw2F/fXz6YvVBK/knj+DkfLNlJ8SBENM6z76zMPTjLvK9Q7auOstJ+
         4qAhdCttKj8jbFOkkM9VSPwSzAyU2ULOSPskOFKj5XskM0zQeI98/h+FOCRxxfuG1qlt
         QIRc0qJMvLAgDwSbQQ3EXFiIoaqTQ7xwLGeBc=
Date: Wed, 11 May 2011 22:18:48 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 11/11] ptrace: implement group stop notification for
 ptracer
Message-ID: <20110511201848.GF24245@mtj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-12-git-send-email-tj@kernel.org>
 <20110511195824.GA4047@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110511195824.GA4047@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Oleg.

On Wed, May 11, 2011 at 09:58:24PM +0200, Oleg Nesterov wrote:
> > +	/*
> > +	 * If @t is currently trapped for group stop or INTERRUPT
> > +	 * (JOBCTL_TRAPPED set), it should re-trap with new exit_code
> > +	 * indicating continuation so that the ptracer can notice the
> > +	 * event; otherwise, use normal signal delivery wake up.
> > +	 *
> > +	 * The re-trapping sets JOBCTL_TRAPPING such that the transition is
> > +	 * hidden from the ptracer.
> > +	 *
> > +	 * This means that if @t is trapped for other reasons than group
> > +	 * stop or INTERRUPT, the notification trap won't be delievered
> > +	 * until the current one is complete.  This is the intended
> > +	 * behavior.
> > +	 */
> > +	if (task_is_traced(t) && (t->jobctl & JOBCTL_TRAPPED)) {
> > +		t->jobctl |= JOBCTL_TRAPPING;
> > +		signal_wake_up(t, true);
> 
> and its tracer can be inside sys_ptrace().
> 
> No, I don't think this can be right. Otherwise, why ptrace_check_attach()
> calls wait_task_inactive() ? The tracee can be scheduled but only if killed,
> in this case we don't care.
>
> I know very little about this low-level (and worse, arch dependant) magic,
> but even on x86 this doesn't look safe. Suppose that the tracer changes the
> fpu state of the tracer and __switch_to(next_p == tracee) does
> __math_state_restore() before the tracer finishes.

Yeah, yeah, it's dangerous to let ptrace operations while the target
task is still on CPU.  It shouldn't happen.

> Or PTRACE_GETSIGINFO can fail while it shouldn't, but this is minor.
> 
> Hmm. I think we need a bit more discussion, even ignoring the implementation
> details.

Hmmm... this whole re-trapping thing is turning out to be more
problematic than expected.  Maybe it would be better to somehow notify
ptracer directly from prepare_signal().

Thanks.

-- 
tejun
