Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab2HONFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 09:05:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381Ab2HONFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 09:05:46 -0400
Date: Wed, 15 Aug 2012 15:01:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: yama_ptrace_access_check(): possible recursive locking detected
Message-ID: <20120815130159.GA3221@redhat.com>
References: <20120726134748.GA20605@localhost> <CAGXu5j+xjud3w4cYXADM-KvFPvnkaKp49j5x-wdZ66wUJjkX0g@mail.gmail.com> <20120810015222.GA19286@localhost> <CAGXu5jK_ZJqmcJ7JcnpwNb5R3x8=ay_shD16ZA3q-7Lwi8S=qg@mail.gmail.com> <20120815030110.GA24836@localhost> <CAGXu5j+0FUYdBqsotn_vp1EbG=dcURAA1sxv+yFzaJuUkdAh0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+0FUYdBqsotn_vp1EbG=dcURAA1sxv+yFzaJuUkdAh0A@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14, Kees Cook wrote:
>
> Okay, I've now managed to reproduce this locally. I added a bunch of
> debugging, and I think I understand what's going on. This warning is,
> actually, a false positive.

Sure. I mean that yes, this warning doesn't mean we already hit deadlock.

> get used recursively (the task_struct->alloc_lock), but they are
> separate instantiations ("task" is never "current").

Yes. But suppose that we have 2 tasks T1 and T2,

	- T1 does ptrace(PTRACE_ATTACH, T2);

	- T2 does ptrace(PTRACE_ATTACH, T1);

at the same time. This can lead to the "real" deadlock, no?

> So Oleg's suggestion of removing the locking around the reading of
> ->comm is wrong since it really does need the lock.

Nothing bad can happen without the lock. Yes, printk() can print
some string "in between" if we race with set_task_comm() but this
is all.

BTW, set_task_comm()->wmb() and memset() should die. There are
not needed afaics, and the comment is misleading.

Oleg.

