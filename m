Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab1E3NhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 09:37:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab1E3NhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 09:37:21 -0400
Date: Mon, 30 May 2011 15:35:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: Ptrace documentation, draft #3
Message-ID: <20110530133547.GA4739@redhat.com>
References: <BANLkTikH4k0MfTwNzNJN-P85ER4-hKdifw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikH4k0MfTwNzNJN-P85ER4-hKdifw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20, Denys Vlasenko wrote:
>
 ??? How tracer knows which of its many tracees _are_ threads of that
> particular process? (It may trace more than one process; it may even
> don't keep track of its tracees' thread group relations at all...)

I think the tracer should track the tgid relations if it wants to know
this. Although we can add the simple PTREAD_ request which provides some
info including tgid.

> ??? what happens if two threads execve at the same time? Clearly, only
> one of them succeeds, but *which* one? Think "strace -f" or
> multi-threaded process here:
>
>   ** we get death notification: leader died: **
>  PID0 exit(0)                            = ?
>   ** we get syscall-entry-stop in thread 1: **
>  PID1 execve("/bin/foo", "foo" <unfinished ...>
>   ** we get syscall-entry-stop in thread 2: **
>  PID2 execve("/bin/bar", "bar" <unfinished ...>
>   ** we get PTRACE_EVENT_EXEC for PID0, we issue PTRACE_SYSCALL **
>   ** we get syscall-exit-stop for PID0: **
>  PID0 <... execve resumed> )             = 0
>
> ??? Question: WHICH execve succeeded? Can tracer figure it out?

Afaics, in general the tracer can't figure it out. Well, in this
particular case the tracer can inspect the arguments when the winner
(now it is PID0) reports the syscall-exit.

Also. All threads but the winner can report PTRACE_EVENT_EXIT. But once
again, we have problems with PTRACE_EVENT_EXIT/fatal_signal_pending().

Oleg.

