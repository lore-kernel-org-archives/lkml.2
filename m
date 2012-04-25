Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab2DYNE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 09:04:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab2DYNEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 09:04:25 -0400
Date: Wed, 25 Apr 2012 15:03:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Roland McGrath <roland@hack.frob.com>
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120425130329.GA16413@redhat.com>
References: <CA+55aFxia+u3VAf0qN-2wv7DyAQZK-Z8=n=cqUvo--+C905aFg@mail.gmail.com> <20120420160848.GG6871@ZenIV.linux.org.uk> <20120420164239.GH6871@ZenIV.linux.org.uk> <CA+55aFzuTspDyyLaOA-g-dTWydaUeeWo9uVGR+rZ=ZJzPW_Ocw@mail.gmail.com> <20120420180748.GI6871@ZenIV.linux.org.uk> <20120423180150.GA6871@ZenIV.linux.org.uk> <20120424072617.GB6871@ZenIV.linux.org.uk> <20120425030659.GE6871@ZenIV.linux.org.uk> <20120425123746.GA15560@redhat.com> <20120425125042.GF6871@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120425125042.GF6871@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25, Al Viro wrote:
>
> On Wed, Apr 25, 2012 at 02:37:46PM +0200, Oleg Nesterov wrote:
> > As for sys_sigsuspend() and this race in particular:
> >
> > > Arrival of a signal that has userland handler
> > > and that isn't blocked by the mask given to sigsuspend() should terminate
> > > sigsuspend().
> >
> > Yes. But note that do_signal() restores the old sigmask. This means that
> > the signal we get after the first do_signal() was not blocked before
> > sigsuspend() was called. So, to some extent, we can pretend that the
> > handler was executed before sigsuspend() and it was never restarted.
>
> Signal might have already arrived by the time we restore sigmask.

Yes, and it sets TIF_SIGPENDING, but unless I missed something this doesn't
matter.

> So no,
> it might have been blocked prior to sigsuspend().

If it was not blocked, then the next do_signal()->get_signal_to_deliver()
returns 0 and clears TIF_SIGPENDING. After that we finally re-enter
sys_sigsuspend() and (assuming it unblocks this sig) notice this pending
signal again and return -EINTR eventually.

Oleg.

