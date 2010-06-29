Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab0F2TOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 15:14:25 -0400
Received: from smtp.outflux.net ([198.145.64.163]:50531 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab0F2TOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 15:14:24 -0400
Date: Tue, 29 Jun 2010 12:13:06 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sanitize task->comm to avoid leaking escape codes
Message-ID: <20100629191306.GJ4175@outflux.net>
References: <20100623181129.GM5876@outflux.net>
 <20100623194145.GA19628@redhat.com>
 <20100623202335.GA4424@x200>
 <20100628130028.73757a46.akpm@linux-foundation.org>
 <20100628210342.GW4175@outflux.net>
 <AANLkTinlrnSEwnWn_qcvdfqXM6b_bA3hbBjBrqgpQnKX@mail.gmail.com>
 <20100629150952.GF4175@outflux.net>
 <20100629115956.03c4a0b4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100629115956.03c4a0b4.akpm@linux-foundation.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 11:59:56AM -0700, Andrew Morton wrote:
> On Tue, 29 Jun 2010 08:09:52 -0700
> Kees Cook <kees.cook@canonical.com> wrote:
> 
> > On Tue, Jun 29, 2010 at 11:45:14AM +0300, Alexey Dobriyan wrote:
> > > On Tue, Jun 29, 2010 at 12:03 AM, Kees Cook <kees.cook@canonical.com> wrote:
> > > > On Mon, Jun 28, 2010 at 01:00:28PM -0700, Andrew Morton wrote:
> > > >> Surely it would be better to fix the tools which display this info
> > > >> rather than making the kernel tell fibs.
> > > >
> > > > The strncpy in get_task_comm() is totally wrong -- it's testing the length
> > > > of task->comm.
> > > 
> > > It also fills not just any buffer but buffer which is TASK_COMM_LEN byte wide.
> > > 
> > > > Why should get_task_comm not take a destination buffer length argument?
> > > 
> > > If you pass too small, you needlessly truncate output.
> > 
> > If you pass too small a buffer, get_task_comm will happily write all over
> > the caller's stack past the end of the buffer if the contents of task->comm
> > are large enough:
> > 
> >         strncpy(buf, tsk->comm, sizeof(tsk->comm));
> > 
> > The "n" argument to get_task_comm's use of strncpy is totally wrong --
> > it needs to be the size of the destination, not the size of the source.
> > Luckily, everyone using get_task_comm currently uses buffers that are
> > sizeof(task->comm).
> 
> It's not "totally wrong" at all.  get_task_comm() *requires* that it be

Using strncpy with n as the source buffer length is meaningless here
(tsk->comm is always null terminated at TASK_COMM_LEN or earlier).

> passed a buffer of at least TASK_COMM_LEN bytes.  sizeof(tsk->comm)
> equals TASK_COMM_LEN and always will do so.  We could replace the
> sizeof with TASK_COMM_LEN for cosmetic reasons but that's utter
> nitpicking.  But then, the comment right there says "buf must be at
> least sizeof(tsk->comm) in size".  That's so simple that even a kernel
> developer could understand it?

If so, strncpy should just be replaced with strcpy.  You're assuming buf
will always be at least TASK_COMM_LEN.  We know the source buffer size is
TASK_COMM_LEN because it's already defined that way.  There is nothing in
the build or runtime that makes sure that buf is at least TASK_COMM_LEN.

> Do we need a runtime check every time to make sure that some developer
> didn't misunderstand such a simple thing?  Seems pretty pointless -
> there are a zillion such runtime checks we could add.  It'd be better
> to do
> 
> #define get_task_comm(buf, tsk) {			\
> 	BUILD_BUG_ON(sizeof(buf) < TASK_COMM_LEN);	\
> 	__get_task_comm(buf, tsk);			\
> }
> 
> and save the runtime bloat.  But again, what was special about this
> particular programmer error?  There are five or six instances of
> strcpy(foo, current->comm).  Do we need runtime checks there as well??

I can't see how it could be a bad thing.  Why not try to do some defensive
programming here?  It's a trivial fix and your define would block this from
ever being a problem.

As I said before, either get_task_comm() is considered sensitive or
it's not.  If it is, I've sent a few patches that might help.  If it's
not, then code should not be criticised for using it.

-Kees

-- 
Kees Cook
Ubuntu Security Team
