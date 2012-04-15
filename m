Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab2DOWij (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 18:38:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab2DOWii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 18:38:38 -0400
Date: Mon, 16 Apr 2012 00:38:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Chuck Ebbert <chuckebbert.lk@gmail.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: ptrace && fpu_lazy_restore
Message-ID: <20120415223808.GA26214@redhat.com>
References: <20120414235238.GA11131@redhat.com> <CA+55aFxJykAy4=9WVOnUOy1PUBYLmPy9mJmydoYZpQEbSkfvJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxJykAy4=9WVOnUOy1PUBYLmPy9mJmydoYZpQEbSkfvJQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14, Linus Torvalds wrote:
>
> So I actually think that I would prefer the patch that invalidates the
> FPU caches more aggressively. Sure, we don't really *need* to
> invalidate if we're just reading, but I'd almost prefer to just have
> it done once in "init_fpu()".

Agreed. I'll send your patch back to you tomorrow.

> The only case where we care about the FPU caches remaining is actually
> the nice normal "we just switched tasks through normal scheduling".

Yes. And there is another case when fpu_lazy_restore() returns the
false positive.

Suppose that fpu_owner_task exits on CPU_0, and then fork() reuses
its task_struct. The new child is still fpu_owner_task and this is
obviously wrong (unless of course another thread uses fpu).

Initially I thought this should be fixed too, but it seems that
"p->fpu_counter = 0" in copy_thread() saves us.

This looks a bit fragile... And could you confirm this is really
fine?


Btw, do we really need this "old->thread.fpu.last_cpu = ~0" in
the "else" branch of switch_fpu_prepare()? Just curious, I guees
this doesn't matter since we reset old->fpu_counter. But if we
can remove this line, then perhaps we can another optimization.

Oleg.

