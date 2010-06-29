Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab0F2PKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 11:10:42 -0400
Received: from smtp.outflux.net ([198.145.64.163]:37604 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756444Ab0F2PKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 11:10:40 -0400
Date: Tue, 29 Jun 2010 08:09:52 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sanitize task->comm to avoid leaking escape codes
Message-ID: <20100629150952.GF4175@outflux.net>
References: <20100623181129.GM5876@outflux.net>
 <20100623194145.GA19628@redhat.com>
 <20100623202335.GA4424@x200>
 <20100628130028.73757a46.akpm@linux-foundation.org>
 <20100628210342.GW4175@outflux.net>
 <AANLkTinlrnSEwnWn_qcvdfqXM6b_bA3hbBjBrqgpQnKX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinlrnSEwnWn_qcvdfqXM6b_bA3hbBjBrqgpQnKX@mail.gmail.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 11:45:14AM +0300, Alexey Dobriyan wrote:
> On Tue, Jun 29, 2010 at 12:03 AM, Kees Cook <kees.cook@canonical.com> wrote:
> > On Mon, Jun 28, 2010 at 01:00:28PM -0700, Andrew Morton wrote:
> >> Surely it would be better to fix the tools which display this info
> >> rather than making the kernel tell fibs.
> >
> > The strncpy in get_task_comm() is totally wrong -- it's testing the length
> > of task->comm.
> 
> It also fills not just any buffer but buffer which is TASK_COMM_LEN byte wide.
> 
> > Why should get_task_comm not take a destination buffer length argument?
> 
> If you pass too small, you needlessly truncate output.

If you pass too small a buffer, get_task_comm will happily write all over
the caller's stack past the end of the buffer if the contents of task->comm
are large enough:

        strncpy(buf, tsk->comm, sizeof(tsk->comm));

The "n" argument to get_task_comm's use of strncpy is totally wrong --
it needs to be the size of the destination, not the size of the source.
Luckily, everyone using get_task_comm currently uses buffers that are
sizeof(task->comm).

> If you pass too large, you waste space.

Right.

-Kees

-- 
Kees Cook
Ubuntu Security Team
