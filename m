Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878Ab0HQQPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 12:15:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751957Ab0HQQPd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 12:15:33 -0400
MIME-Version: 1.0
In-Reply-To: <20100816.211218.189709876.davem@davemloft.net>
References: <20100816.211218.189709876.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 17 Aug 2010 09:14:37 -0700
Message-ID: <AANLkTikDXoRMRL0y_Y_7qVS=9LOw_yLS9MuUgq2dTCZf@mail.gmail.com>
Subject: Re: tasks getting stuck on mmap_sem?
To: David Miller <davem@davemloft.net>, Michel Lespinasse <walken@google.com>,
        David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 9:12 PM, David Miller <davem@davemloft.net> wrote:
>
> I just started seeing this with current GIT, is it related
> to the page table locking shuffle of a few days ago?

No. Looks like the rwsem changes broke sparc too. ia64 had some problems too.

ia64 had the type problems, but even after they were fixed there was
reports of something similar. So I am starting to suspect that there
is something more serious going on here - possibly hidden on x86 due
to the strong memory ordering. And possibly just because mmap_sem is
_mostly_ just used by a single thread. Threaded apps are still
uncommon.

Adding the guilty parties to the cc, leaving your backtrace quoted.

                       Linus

---
> [21029.265646] INFO: task git:16643 blocked for more than 120 seconds.
> [21029.267054] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [21029.268412] git           D 000000000072f804     0 16643  16273 0x210001101000080
> [21029.269809] Call Trace:
> [21029.271062]  [000000000072f778] rwsem_down_failed_common+0x90/0xb8
> [21029.272390]  [000000000072f804] __down_read+0x30/0x40
> [21029.273689]  [0000000000731148] do_sparc64_fault+0x238/0x788
> [21029.274996]  [00000000004079e8] sparc64_realfault_common+0x10/0x20
> [21029.276347] INFO: task git:16644 blocked for more than 120 seconds.
> [21029.277655] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [21029.278993] git           D 000000000072f874     0 16644  16273 0x210041101000080
> [21029.280348] Call Trace:
> [21029.281542]  [000000000072f778] rwsem_down_failed_common+0x90/0xb8
> [21029.282818]  [000000000072f874] __down_write+0x34/0x44
> [21029.284057]  [00000000004d9c44] SyS_mmap_pgoff+0xc8/0x118
> [21029.285293]  [0000000000406154] linux_sparc_syscall32+0x34/0x40
>  ...
>
> etc.  it's a set of git threads computing deltas for a remote pull
> request to the machine.
>
