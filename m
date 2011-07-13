Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab1GMSgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 14:36:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab1GMSgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 14:36:40 -0400
Date: Wed, 13 Jul 2011 20:33:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, vda.linux@googlemail.com,
        jan.kratochvil@redhat.com, pedro@codesourcery.com, indan@nul.nu,
        bdonlan@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ptrace: fix ptrace_signal() && STOP_DEQUEUED
	interaction
Message-ID: <20110713183322.GA12535@redhat.com>
References: <20110707190301.GA25332@redhat.com> <20110707190324.GB25332@redhat.com> <20110713100404.GG2872@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110713100404.GG2872@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 07/13, Tejun Heo wrote:
>
> Sorry about the long delay.

No, no, you shouldn't use this mantra.  I hold the copyright!

> On Thu, Jul 07, 2011 at 09:03:24PM +0200, Oleg Nesterov wrote:
> > Without the patch it hangs. After the patch SIGSTOP "injected" by the
> > tracer is not ignored and stops the tracee.
>
> I always felt the ability to 'inject' different signal there is rather
> useless and prone to induce weird issues.  It would be better if
> ptrace_signal() is part of signal delivery action after all the checks
> so that the ptracer says whether to proceed with the action or not but
> no more.  Well...

Oh, probably. If the tracer wants a different signr, it can simply do
tkill() + PTRACE_CONT(0). I agree. Although perhaps this is needed for
gdb, I dunno. But we can't change this.

And, I'd like to clarify... It is not that I think it is that important
to ensure PTRACE_CONT(SIGSTOP) will actually stop the tracee if the tracer
changes the original signal. I simply do not know if it is used this way.

The only important thing, imho, the behaviour shouldn't depend on
/dev/random, with this patch it is at least clearly defined.

> > So lets add STOP_DEQUEUED _before_ we report the signal. It has no effect
> > unless sig_kernel_stop() == T after the tracer resumes us, and in the
> > latter case the pending STOP_DEQUEUED means no SIGCONT in between, we
> > should stop.
>
> Anyways, yes, this seems to be a nice improvement but it looks very
> weird (and difficult to comprehend) to be setting STOP_DEQUEUED
> unconditionally in ptrace_signal().

Yeeees, agreed. I even added the comment to explain this weirdness.

> Wouldn't it be better to flip the
> flag so that we have CONT_RECEIVED before doing this?

May be. You know, I thought about this when I did ee77f075
"signal: Turn SIGNAL_STOP_DEQUEUED into GROUP_STOP_DEQUEUED".

Or may be we can simply rename it into STOP_ALLOWED. In this case
we can even set it unconditionally before dequeue_signal().


Anyway, whatever we do, this patch doesn't complicate the
CONT_RECEIVED/STOP_ALLOWED change. Can't we do this later?

Oleg.

