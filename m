Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab1EYSar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 14:30:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643Ab1EYSaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 14:30:46 -0400
Date: Wed, 25 May 2011 20:29:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Message-ID: <20110525182919.GB16575@redhat.com>
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <1305569849-10448-4-git-send-email-tj@kernel.org> <201105180240.56754.vda.linux@googlemail.com> <20110518095539.GU20624@htj.dyndns.org> <20110523124314.GA7232@redhat.com> <20110524102834.GC10334@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110524102834.GC10334@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24, Tejun Heo wrote:
>
> Hello, Oleg.
>
> On Mon, May 23, 2011 at 02:43:14PM +0200, Oleg Nesterov wrote:
> > On 05/18, Tejun Heo wrote:
> > > I've been thinking about Jan's suggestion to make ATTACH and DETACH
> > > not require tracee to trap. We already have this for DETACH for cases
> > > where the tracer is killed
> >
> > Yes, I still think that the new DETACH_XXX request which doesn't need
> > the stopped tracee makes sense. Yes, we have PTRACE_INTERRUPT. But please
> > recall the previous discussion, it is possible that the tracee can't
> > react to PTRACE_INTERRUPT and trap because it waits for other threads
> > we are tracing.
>
> Yeah, untrapped DETACH sounds nice but as you've already acknowledged
> in another reply, we have those nasty disable traps.

Yes. Which I never thought about, I alway assume PTRACE_DETACH_ASYNC
is trivial, but it is not. Lets forget it for now.

> > And. Currently there is no way to detach a zombie leader. Perhaps we
> > should change do_wait(), but it is not clear what should we do if the
> > tracer is the real parent (we already discussed this a bit).
>
> Hmmm... maybe just allow detaching zombie leader?

Yes, I think we should do this.

If we change PTRACE_DETACH (or add the new request) to allow this, then
I think it it should detach any zombie, leader or not.

Or we can change do_wait() to detach a zombie leader. In this case it
is not clear what should we do if the debugger is the real parent.
Perhaps do_wait() should do the same: detach a leader (but not reap).
When the last thread does, the real parent will be notified again.
IOW, wait(tgid) can succeed twice.

> As it's guaranteed
> to be not running, we don't have problem with ptrace_disable.

Agreed. In fact it can be running, but it can't return to the user-space,
and I think this is enough.

ptrace_detach()->ptrace_disable() can race with SIGKILL anyway, this means
it should safe to call it if the tracee is exiting/exited.

Oleg.

