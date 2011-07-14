Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab1GNGpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 02:45:13 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36604 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab1GNGpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 02:45:11 -0400
Date: Thu, 14 Jul 2011 08:45:06 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, vda.linux@googlemail.com,
        jan.kratochvil@redhat.com, pedro@codesourcery.com, indan@nul.nu,
        bdonlan@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ptrace: fix ptrace_signal() && STOP_DEQUEUED
 interaction
Message-ID: <20110714064457.GA3455@htj.dyndns.org>
References: <20110707190301.GA25332@redhat.com>
 <20110707190324.GB25332@redhat.com>
 <20110713100404.GG2872@htj.dyndns.org>
 <20110713183322.GA12535@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110713183322.GA12535@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Wed, Jul 13, 2011 at 08:33:22PM +0200, Oleg Nesterov wrote:
> > On Thu, Jul 07, 2011 at 09:03:24PM +0200, Oleg Nesterov wrote:
> > > Without the patch it hangs. After the patch SIGSTOP "injected" by the
> > > tracer is not ignored and stops the tracee.
> >
> > I always felt the ability to 'inject' different signal there is rather
> > useless and prone to induce weird issues.  It would be better if
> > ptrace_signal() is part of signal delivery action after all the checks
> > so that the ptracer says whether to proceed with the action or not but
> > no more.  Well...
> 
> Oh, probably. If the tracer wants a different signr, it can simply do
> tkill() + PTRACE_CONT(0). I agree. Although perhaps this is needed for
> gdb, I dunno. But we can't change this.

Yeah, we can't change it.  I was just thinking out loud.  Sending
signals from ptrace code path seems generally wrong.  In this case, if
the signal becomes blocked inbetween, the signal gets sent again.
Seeing the same signal being delivered twice can be confusing.
Moreover, SIGCONT can be blocked and the action of 'sending' it has
side effects, so re-sending it is simply wrong.  This should have been
ack/nack for the action to take.

Anyways, not much point in ranting about it at this point, I guess.

> > Wouldn't it be better to flip the
> > flag so that we have CONT_RECEIVED before doing this?
> 
> May be. You know, I thought about this when I did ee77f075
> "signal: Turn SIGNAL_STOP_DEQUEUED into GROUP_STOP_DEQUEUED".
> 
> Or may be we can simply rename it into STOP_ALLOWED. In this case
> we can even set it unconditionally before dequeue_signal().
> 
> Anyway, whatever we do, this patch doesn't complicate the
> CONT_RECEIVED/STOP_ALLOWED change. Can't we do this later?

Never mind.  I for some reason thought flipping the flag would make
the extra step in ptrace_signal() unnecessary.  We need to clear it
all the same so it doesn't really improve anything.  I think the
current version should be fine (maybe the comment can be beefed up a
bit?).

Thanks.

-- 
tejun
