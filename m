Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759281Ab0KRP7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 10:59:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757046Ab0KRP7Y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 10:59:24 -0500
MIME-Version: 1.0
In-Reply-To: <20101118094342.GA10382@elte.hu>
References: <201011172159.oAHLx1tu001236@hera.kernel.org> <20101117140526.d532b373.randy.dunlap@oracle.com>
 <AANLkTimO6CN9wOQco_1bqRmwBS7KfWW1CvumKFuiOWGH@mail.gmail.com> <20101118094342.GA10382@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 18 Nov 2010 07:57:08 -0800
Message-ID: <AANLkTi=Xoo90jiaQBMxchFkKXt0dgre0tWe-LnVR6aSD@mail.gmail.com>
Subject: Re: [build failure] Re: BKL: remove extraneous #include <smp_lock.h>
To: Ingo Molnar <mingo@elte.hu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 1:43 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Latest -git fails to build in some circumstances:
>
>  drivers/net/irda/sir_dev.c: In function ‘sirdev_schedule_request’:
>  drivers/net/irda/sir_dev.c:292:244: error: dereferencing pointer to incomplete type

Yeah. That's the "in_atomic()" check (stupid testing by just splitting
that one thing over three lines instead of one and seeing which one
gcc complains about), and it wants the declaration for "struct
task_struct".

And that file has a very minimal #includes. I'd even be impressed at
how small the list is, if it actually made any sense.  It looks like
_all_ includes in that file are pretty much incidental ;)

At a quick glance I'm not even seeing how it's including hardirq.h,
but clearly it's not enough.

Equally clearly it looks like the _correct_ fix is to move
"lock_depth" into the thread structure together with the preempt
count. Of course, I'm not sure whether that's really worth it, or
whether we should just be lazy and include <sched.h> with everything
that entails into hardirq.h.

How painful would it be to move lock_depth into thread_struct? I guess
we don't have anything that cares about structure offsets in assembly
for that thing.  I should just try.

                             Linus
