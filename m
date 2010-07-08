Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab0GHKak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 06:30:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:32973 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab0GHKai convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 06:30:38 -0400
Subject: Re: FYI: mmap_sem OOM patch
From: Peter Zijlstra <peterz@infradead.org>
To: Michel Lespinasse <walken@google.com>
Cc: linux-mm <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Divyesh Shah <dpshah@google.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20100707231134.GA26555@google.com>
References: <20100707231134.GA26555@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 08 Jul 2010 12:30:09 +0200
Message-ID: <1278585009.1900.31.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-07 at 16:11 -0700, Michel Lespinasse wrote:
> What happens is we end up with a single thread in the oom loop (T1)
> that ends up killing a sibling thread (T2).  That sibling thread will
> need to acquire the read side of the mmap_sem in the exit path.  It's
> possible however that yet a different thread (T3) is in the middle of
> a virtual address space operation (mmap, munmap) and is enqueue to
> grab the write side of the mmap_sem behind yet another thread (T4)
> that is stuck in the OOM loop (behind T1) with mmap_sem held for read
> (like allocating a page for pagecache as part of a fault.
> 
>       T1              T2              T3              T4
>       .               .               .               .
>    oom:               .               .               .
>    oomkill            .               .               .
>       ^    \          .               .               .
>      /|\    ---->  do_exit:           .               .
>       |            sleep in           .               .
>       |            read(mmap_sem)     .               .
>       |                     \         .               .
>       |                      ----> mmap               .
>       |                            sleep in           .
>       |                            write(mmap_sem)    .
>       |                                     \         .
>       |                                      ----> fault
>       |                                            holding read(mmap_sem)
>       |                                            oom
>       |                                               |
>       |                                               /
>       \----------------------------------------------/ 

So what you do is use recursive locking to side-step a deadlock.
Recursive locking is poor taste and leads to very ill defined locking
rules.

One way to fix this is to have T4 wake from the oom queue and return an
allocation failure instead of insisting on going oom itself when T1
decides to take down the task.


