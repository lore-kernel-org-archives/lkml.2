Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785Ab0FVBmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 21:42:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752630Ab0FVBme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 21:42:34 -0400
Date: Mon, 21 Jun 2010 18:41:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
Cc: Edward Allcutt <edward@allcutt.me.uk>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Randy Dunlap <rdunlap@xenotime.net>, Jiri Kosina <jkosina@suse.cz>,
       Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Neil Horman <nhorman@tuxdriver.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: limit maximum concurrent coredumps
Message-Id: <20100621184116.92f85696.akpm@linux-foundation.org>
In-Reply-To: <20100622012303.BD72E402AD@magilla.sf.frob.com>
References: <1277164737-30055-1-git-send-email-edward@allcutt.me.uk>
	<20100622012303.BD72E402AD@magilla.sf.frob.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010 18:23:03 -0700 (PDT) Roland McGrath <roland@redhat.com> wrote:

> A core dump is just an instance of a process suddenly reading lots of its
> address space and doing lots of filesystem writes, producing the kinds of
> thrashing that any such instance might entail.  It really seems like the
> real solution to this kind of problem will be in some more general kind of
> throttling of processes (or whatever manner of collections thereof) when
> they got hog-wild on page-ins or filesystem writes, or whatever else.  I'm
> not trying to get into the details of what that would be.  But I have to
> cite this hack as the off-topic kludge that it really is.  That said, I do
> certainly sympathize with the desire for a quick hack that addresses the
> scenario you experience.

yup.

> For the case you described, it seems to me that constraining concurrency
> per se would be better than punting core dumps when too concurrent.  That
> is, you should not skip the dump when you hit the limit.  Rather, you
> should block in do_coredump() until the next dump already in progress
> finishes.  (It should be possible to use TASK_KILLABLE so that those dumps
> in waiting can be aborted with a follow-on SIGKILL.  But Oleg will have to
> check on the signals details being right for that.)

yup.

Might be able to use semaphores for this.  Use sema_init(),
down_killable() and up().

Modifying the max concurrency value would require a loop of up()s and
down()s, probably all surrounded by a mutex_lock.  Which is a bit ugly,
and should be done in kernel/semaphore.c I guess.

> That won't make your crashers each complete quickly, but it will prevent
> the thrashing.  Instead of some crashers suddenly not producing dumps at
> all, they'll just all queue up waiting to finish crashing but not using any
> CPU or IO resources.  That way you don't lose any core dumps unless you
> want to start SIGKILL'ing things (which oom_kill might do if need be),
> you just don't die in flames trying to do nothing but dump cores.

A global knob is a bit old-school.  Perhaps it should be a per-memcg
knob or something.



otoh, one could perhaps toss all these tasks into a blkio_cgroup and
solve this problem with the block IO controller.  After all, that's
what it's for.

