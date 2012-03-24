Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab2CXQW7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 12:22:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33638 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab2CXQW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 12:22:58 -0400
Date: Sat, 24 Mar 2012 20:21:52 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Weinberger <richard@nod.at>, Paul Mundt <lethal@linux-sh.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 10/10] oom: Make find_lock_task_mm() sparse-aware
Message-ID: <20120324162151.GA3640@lizard>
References: <20120324102609.GA28356@lizard>
 <20120324103127.GJ29067@lizard>
 <1332593574.16159.31.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1332593574.16159.31.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 24, 2012 at 01:52:54PM +0100, Peter Zijlstra wrote:
[...]
> > p.s. I know Peter Zijlstra detest the __cond_lock() stuff, but untill
> >      we have anything better in sparse, let's use it. This particular
> >      patch helped me to detect one bug that I myself made during
> >      task->mm fixup series. So, it is useful.
> 
> Yeah, so Nacked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Also, why didn't lockdep catch it?

Because patch authors test their patches on architectures they own
(well, sometimes I do check patches on exotic architectures w/ qemu,
but it is less convenient than just build/sparse-test the patch w/
a cross compiler).

And since lockdep is a runtime checker, it is not very useful.

Sparse is a build-time checker, so it is even better in the sense
that it is able to catch bugs even in code that is executed rarely.

> Fix sparse already instead of smearing ugly all over.

Just wonder how do you see the feature implemented?

Something like this?

#define __ret_cond_locked(l, c)	__attribute__((ret_cond_locked(l, c)))
#define __ret_value		__attribute__((ret_value))
#define __ret_locked_nonnull(l)	__ret_cond_locked(l, __ret_value);

extern struct task_struct *find_lock_task_mm(struct task_struct *p)
	__ret_locked_nonnull(&__ret_value->alloc_lock);

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
