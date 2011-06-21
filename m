Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab1FUUmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 16:42:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753791Ab1FUUma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 16:42:30 -0400
Date: Tue, 21 Jun 2011 22:40:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, hch@infradead.org
Subject: Re: [PATCH 3/7] ptrace: move SIGTRAP on exec(2) logic to
	ptrace_event()
Message-ID: <20110621204001.GB6738@redhat.com>
References: <1308322240-8247-1-git-send-email-tj@kernel.org> <1308322240-8247-4-git-send-email-tj@kernel.org> <20110620202504.GB17157@redhat.com> <BANLkTimuRogA6St5GP0sRd1CY5u=jBABBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimuRogA6St5GP0sRd1CY5u=jBABBg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21, Tejun Heo wrote:
>
> Hello,
>
> On Mon, Jun 20, 2011 at 10:25 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > Why does this make ptrace_event() smarter?
> >
> > OK, tracehooks should die. But why should we move this special case
> > into ptrace_event? Say, a simple
> >
> >        static inline void ptrace_exec_event(...)
> >        {
> >                if (!ptrace_event_enabled(PTRACE_EVENT_EXEC))
> >                        send_sig(SIGTRAP, current, 0);
> >                else
> >                        ptrace_event(PTRACE_EVENT_EXEC);
> >        }
> >
> > in fs/exec.c looks a bit better to me.
>
> The intention is to concentrate ptrace specific logic in
> ptrace_event().  We'll have more of them, mostly dependent on
> PT_SEIZED and I don't think it's a good idea to scatter them across
> the kernel.  They're of no interest outside of ptrace after all.  I
> think it's better to have them collected in one place than scattered
> around.

This was one of the reasons for tracehooks ;)

OK, we can move this helper to ptrace.h although I do not think this
makes sense. As for "scattered around", imho the code which calculates
trace in do_fork() falls into the same category.

I still can't understand why ptrace_event() should check EVENT_EXEC.
This is the special case, it should be handled specially. And while
I think this is not that important, this is not friendly to do_fork,
compiler has to generate the code to check event.

But OK, I applied 1-5 and 7. This is minor, and we can reconsider this
later. I mean, right now I think I'll send the cleanup later, and you
will have to explain your nack ;)

Oleg.

