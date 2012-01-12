Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab2ALDAf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 22:00:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33095 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab2ALDAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 22:00:34 -0500
Date: Wed, 11 Jan 2012 19:05:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Xiaotian Feng <dannyfeng@tencent.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Stephen Wilson <wilsons@start.ca>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] proc: fix null pointer deref in proc_pid_permission()
Message-Id: <20120111190516.e1aa65ef.akpm@linux-foundation.org>
In-Reply-To: <CAJn8CcEcy5CQHD4UhrOaBYU+yDnMQ5aTs1YGOqrOTB2JgM4=sw@mail.gmail.com>
References: <1326307625-11561-1-git-send-email-xtfeng@gmail.com>
	<20120111204330.GT2618@outflux.net>
	<20120111135847.d28425c6.akpm@linux-foundation.org>
	<CAGXu5jKNWMYnTdh-t2C9gG2PL+frRSOY=O5hyuHmN2uyQ3YFbg@mail.gmail.com>
	<CAJn8CcEcy5CQHD4UhrOaBYU+yDnMQ5aTs1YGOqrOTB2JgM4=sw@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jan 2012 10:45:30 +0800 Xiaotian Feng <xtfeng@gmail.com> wrote:

> On Thu, Jan 12, 2012 at 6:41 AM, Kees Cook <keescook@chromium.org> wrote:
> > On Wed, Jan 11, 2012 at 1:58 PM, Andrew Morton
> > <akpm@linux-foundation.org> wrote:
> >> On Wed, 11 Jan 2012 12:43:30 -0800
> >> Kees Cook <keescook@chromium.org> wrote:
> >>> On Wed, Jan 11, 2012 at 01:47:05PM -0500, Xiaotian Feng wrote:
> >>> > get_proc_task() can fail to search the task and return NULL, put_task_struct()
> >>> > will then bomb the kernel with following oops:
> >>> >
> >>> > [ 1870.574045] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
> >>> > [ 1870.574065] IP: [<ffffffff81217d34>] proc_pid_permission+0x64/0xe0
> >>> > [ 1870.574088] PGD 112075067 PUD 112814067 PMD 0
> >>> > [ 1870.574106] Oops: 0002 [#1] PREEMPT SMP
> >>> >
> >>> > This is a regression introduced by commit 0499680a, kernel should
> >>> > return -ESRCH if get_proc_task() failed.
> >>>
> >>> Nice catch!
> >>>
> >>> However since this error is returned to userspace, shouldn't this be
> >>> -ENOENT instead?
> >>
> >> Failed get_proc_task() frequently results in -ESRCH. __And less
> >> frequently results in -ENOENT.
> >>
> >> It seems odd that inode_operations.permission() would ever return
> >> anything other than zero or -EPERM.
> >
> > Right, but won't this show up at ESRCH from open(2)? If this is used
> > as-is, we just need to have the manpages updated.
> >
> 
> You're right, some of get_proc_task() returns -ENOENT.

More of them return -ESRCH.  I lightly checked whether these can be
returned to open() and it seems not.

>  Maybe we should
> return -ENOENT to avoid breaking userspace tools. Andrew?

It's unclear to me that making it ENOENT will fix more than it breaks. 
procfs accesses can return all sorts of things (ENOENT, ENOMEM, ESRCH,
more...) and with "procfs: add hidepid= and gid= mount options" they
can now return different errors, notably EACCESS from
generic_permission() as well as your ESRCH.

We return such a random sprinkle of errors in there that hopefully
we've trained userspace developers to not depend upon any particular
errno!

ESRCH sounds better to me, because it more accurately reflects what
went wrong.  But I'm not very confident in that...


