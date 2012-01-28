Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab2A1VMY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 16:12:24 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49946 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab2A1VMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 16:12:23 -0500
MIME-Version: 1.0
In-Reply-To: <tip-b5740f4b2cb3503b436925eb2242bc3d75cd3dfe@git.kernel.org>
References: <20120117174031.3118.E1E9C6FF@jp.fujitsu.com> <tip-b5740f4b2cb3503b436925eb2242bc3d75cd3dfe@git.kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 28 Jan 2012 13:12:02 -0800
X-Google-Sender-Auth: 3flP1Q5-WVr02W_Vp68UpUn6yxQ
Message-ID: <CA+55aFyO0KxGQxYYUqmVrNqG6qVFnRT2g-kYYKtH5QG3vTnO=A@mail.gmail.com>
Subject: Re: [tip:sched/core] sched: Fix ancient race in do_exit()
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        y-goto@jp.fujitsu.com, akpm@linux-foundation.org, tglx@linutronix.de,
        oleg@redhat.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 28, 2012 at 4:03 AM, tip-bot for Yasunori Goto
<y-goto@jp.fujitsu.com> wrote:
>
> sched: Fix ancient race in do_exit()

Ugh.

It would be much nicer to just clear the rwsem waiter->task thing
*after* waking the task up, which would avoid this race entirely,
afaik.

Tell me, why wouldn't that work? rwsem_down_failed_common() does

        /* wait to be given the lock */
        for (;;) {
                if (!waiter.task)
                        break;
               ...

so then we wouldn't need the task refcount crap in rwsem either etc,
and we'd get rid of all races with wakeup.

I wonder why we're clearing that whole waiter->task so early.

                       Linus
