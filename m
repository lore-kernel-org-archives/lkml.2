Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab2A2S22 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 13:28:28 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47422 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab2A2S21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 13:28:27 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFz20=H0ZubZEAmEbv0gL8j3C5Kgt4m2+5MU63uVipZt0Q@mail.gmail.com>
References: <20120117174031.3118.E1E9C6FF@jp.fujitsu.com> <tip-b5740f4b2cb3503b436925eb2242bc3d75cd3dfe@git.kernel.org>
 <CA+55aFyO0KxGQxYYUqmVrNqG6qVFnRT2g-kYYKtH5QG3vTnO=A@mail.gmail.com>
 <20120129160711.GA20803@redhat.com> <CA+55aFz20=H0ZubZEAmEbv0gL8j3C5Kgt4m2+5MU63uVipZt0Q@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 29 Jan 2012 10:28:06 -0800
X-Google-Sender-Auth: lB6ePrkAM6s9Fmwex3JVv2f_sI0
Message-ID: <CA+55aFx4nJwxWab4x8pKM+NEHPx_3kHbwf3xzQOLEpaXMks-CA@mail.gmail.com>
Subject: Re: [tip:sched/core] sched: Fix ancient race in do_exit()
To: Oleg Nesterov <oleg@redhat.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, y-goto@jp.fujitsu.com,
        akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 29, 2012 at 9:44 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So it may be completely and utterly broken for some subtle reason, but
> I don't see what it would be. It seems to clean up and simplify the
> logic, and remove all the bogus workarounds for the fact that we used
> to do things stupidly.
>
> But maybe there's some reason for those "stupid" things. I just don't see it.

Hmm. Ok, so I see one reason for it. The silly extraneous "set task to
TASK_UNINTERRUPTIBLE" shouldn't matter normally - even if there are
spurious wakeups (say, disk IO while taking a page fault - not that I
see why we'd be on any wait queues yet), we'll just schedule a bit
more than we need in the extremely unlikely case that they hit us.

But for RT tasks with higher priorities, looping - even if we call
schedule() all the time - can cause livelocks. Damn. So while I don't
think the spurious wakeup is a big issue (I don't think it happens in
practice), it could lead to problems.

I think we could possibly use the "flags" field to do that "are we
just about to get woken up" logic, and set TASK_UNINTERRUPTIBLE in the
loop - and just clear "flags" before doing the wakeup (the same way we
used to clear "task"). Dunno. Ideas?

                         Linus
