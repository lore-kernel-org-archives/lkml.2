Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab2JRI1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 04:27:15 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:39900 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab2JRI1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 04:27:11 -0400
MIME-Version: 1.0
In-Reply-To: <tip-8323f26ce3425460769605a6aece7a174edaa7d1@git.kernel.org>
References: <1340364965.18025.71.camel@twins>
	<tip-8323f26ce3425460769605a6aece7a174edaa7d1@git.kernel.org>
Date: Thu, 18 Oct 2012 02:27:10 -0600
X-Google-Sender-Auth: N7XPkScFupdNgq_0mqBVpjw2FtI
Message-ID: <CAE5mzvjPXAZdOi1p8AB47zOQzgAErBU66gAS8spnpOs+=-+azA@mail.gmail.com>
Subject: Re: [tip:sched/core] sched: Fix race in task_group()
From: cwillu <cwillu@cwillu.com>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, tglx@linutronix.de,
        stefan.bader@canonical.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 8:21 AM, tip-bot for Peter Zijlstra
<peterz@infradead.org> wrote:
> Commit-ID:  8323f26ce3425460769605a6aece7a174edaa7d1
> Gitweb:     http://git.kernel.org/tip/8323f26ce3425460769605a6aece7a174edaa7d1
> Author:     Peter Zijlstra <peterz@infradead.org>
> AuthorDate: Fri, 22 Jun 2012 13:36:05 +0200
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Tue, 24 Jul 2012 13:58:20 +0200
>
> sched: Fix race in task_group()
>
> Stefan reported a crash on a kernel before a3e5d1091c1 ("sched:
> Don't call task_group() too many times in set_task_rq()"), he
> found the reason to be that the multiple task_group()
> invocations in set_task_rq() returned different values.
>
> Looking at all that I found a lack of serialization and plain
> wrong comments.
>
> The below tries to fix it using an extra pointer which is
> updated under the appropriate scheduler locks. Its not pretty,
> but I can't really see another way given how all the cgroup
> stuff works.
>
> Reported-and-tested-by: Stefan Bader <stefan.bader@canonical.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/r/1340364965.18025.71.camel@twins
> Signed-off-by: Ingo Molnar <mingo@kernel.org>

I just finished bisecting a crash on boot to this commit; booting with
"noautogroup" brings it back.

3.5.4 is the latest -stable that still boots, and none of the 3.6 rc's
boot at all.

Photo of the bug (3.6.0next is 3.6 + btrfs's for-linus):
https://lh5.googleusercontent.com/-0DY-YYhgvzs/UHdB-BQdzMI/AAAAAAAAAEg/QhY9rgxnv98/s811/2012-10-11
