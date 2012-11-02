Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950Ab2KBXK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 19:10:58 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35083 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab2KBXK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 19:10:56 -0400
MIME-Version: 1.0
In-Reply-To: <2859519.IO8aRDjQvR@vostro.rjw.lan>
References: <CA+55aFwwTc4QXKqiECgE9NOE2zjC6GsGHHydGP9YDbgQSbw9Aw@mail.gmail.com>
 <2471412.ilAVQkroSv@vostro.rjw.lan> <CA+55aFzfbvb4HsY0viCXC0FnVt7fcyhzyZgR4R6tu5uYC8qzPA@mail.gmail.com>
 <2859519.IO8aRDjQvR@vostro.rjw.lan>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 2 Nov 2012 16:10:34 -0700
X-Google-Sender-Auth: KIisW5roydiuEhExYHzo5X1LXC4
Message-ID: <CA+55aFx+w2hFifGTr_u76D9d_sDKxKJBDd2L4p0GVk-RXCczMA@mail.gmail.com>
Subject: Re: Linux 3.7-rc3
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>, Michal Hocko <mhocko@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 2, 2012 at 3:43 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> Well, not everything is rosy in the suspend land, though.  This is a
> failure to freeze khubd during the second in a row attempt to suspend to
> RAM (your current tree):

Ugh. So khubd is blocked in usb_start_wait_urb(), and apparently the
timeout for that block is longer than the freezing timeout.

There's a comment about why khubd needs to be freezable, but I wonder
if that whole thing isn't doing something wrong. Causing the suspend
to fail is definitely always the wrong thing.

Greg?

> [  125.780766] [ INFO: suspicious RCU usage. ]
> [  125.780804] 3.7.0-rc3+ #988 Not tainted
> [  125.780838] -------------------------------
> [  125.780875] /home/rafael/src/linux/kernel/sched/core.c:4497 suspicious rcu_dereference_check() usage!

Heh. The RCU usage is from the debug printout from sched_show_task(),
so it's "related", but it's a totally independent issue.

It's apparently because we've not done a "rcu_read_lock()" around that
sequence, but I seriously doubt we care. But it's technically a real
bug - even if the fix might be to just not print out the parent pid
(or to just ignore the bug and turn the rcu dereference into an
ACCESS_ONCE() or something.

Ingo, Peter, any comments about that sched/core.c:4497 RCU usage?

                Linus
