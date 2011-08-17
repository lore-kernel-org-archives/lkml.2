Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab1HQMHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 08:07:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898Ab1HQMG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 08:06:59 -0400
Date: Wed, 17 Aug 2011 14:04:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, Petr Vandrovec <petr@vandrovec.name>,
        Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 40/41] ncpfs: Use set_current_blocked()
Message-ID: <20110817120405.GA10709@redhat.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org> <1313071035-12047-41-git-send-email-matt@console-pimps.org> <20110816175643.GI29190@redhat.com> <1313528170.3436.200.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313528170.3436.200.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16, Matt Fleming wrote:
>
> On Tue, 2011-08-16 at 19:56 +0200, Oleg Nesterov wrote:
> > On 08/11, Matt Fleming wrote:
> > >
> > > As described in e6fa16ab ("signal: sigprocmask() should do
> > > retarget_shared_pending()") the modification of current->blocked is
> > > incorrect as we need to check whether the signal we're about to block
> > > is pending in the shared queue.
> >
> > I'd wish I could understand this code but this seems impossible ;)
>
> Yeah, I gave up after staring at it for about twenty minutes. I couldn't
> fathom the logic behind it.
>
> > IOW, "This doesn't seem right at all." looks reasonable, and the
> > PF_EXITING adds even more confusion.
>
> Definitely. If I was more confident in this area of the kernel I would
> have just deleted it ;-)

Same here ;)

> Because the thread doesn't hold ->siglock over do_ncp_rpc_call() another
> thread could change the signal handler for SIGINT or SIGQUIT mid-call.
> Which makes the code under "if (server->m.flags & NCP_MOUNT_INTR)"
> pointless.

(indeed, and see below)

> > Why do we take ->siglock in the first place?
> >
> > I think it is not needed. We can calculate mask/blocked lockless and
> > use set_task_blocked(). This also makes sense because __set_task_blocked
> > is not exported ;)
>
> Eek! Sorry, I didn't realise this didn't compile.
>
> > the sighand->action[] checks are racy anyway in the mt case, siglock
> > can't help.
>
> Hmm.. really? I thought that ->siglock serialised modifications to
> sighand->action[] even in the mt case, no?

Sure. But another thread can change sighand->action[] right after we
drop ->siglock. So how can this lock help? We simply read the word,
this is atomic and doesn't need the locking.

Oleg.

