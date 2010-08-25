Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab0HYJT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 05:19:56 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48516 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752664Ab0HYJTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 05:19:52 -0400
Subject: Re: Possible kmemleak issue, but I'm confused
From: Catalin Marinas <catalin.marinas@arm.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4C744DC5.3040106@am.sony.com>
References: <4C744DC5.3040106@am.sony.com>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Wed, 25 Aug 2010 10:19:45 +0100
Message-ID: <1282727985.3650.19.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Aug 2010 09:19:45.0570 (UTC) FILETIME=[A87A4820:01CB4436]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

On Tue, 2010-08-24 at 23:55 +0100, Tim Bird wrote:
> I wasn't sure what list to post this to.  Is there a list where
> kmemleak is predominately discussed, outside of LKML?

There isn't much traffic on kmemleak apart from people reporting its
output. So LKML is the right list for this (it was always discussed on
LKML).

> I have a "fix" for kmemleak that we are using in Sony's
> Linux kernel (circa 2.6.29), that I wanted to discuss with
> you and possibly push upstream.  However, I'm confused about
> the status of kmemleak in current mainline.

Kmemleak is fully functional in the current mainline. From time to time
we need to plug some false positive but otherwise it is fine.

> In our patch set against 2.6.29, there are some kmemleak
> instrumentation hooks in kernel/module.c, in the routines
> percpu_modalloc and  percpu_modfree.  I thought that all
> of kmemleak got mainlined in 2.6.34, but I don't see these
> hooks in Linus' latest tree.
> 
> I found the commit that we are modifying, in your tree at:
> http://git.kernel.org/?p=linux/kernel/git/cmarinas/linux-2.6-cm.git;a=commitdiff;h=4f2294b6dc88d99295230d97fef2c9863cec44c3
> 
> What is the status of this patch relative to linux-next or Linus'
> tree?

This patch was merged in 2.6.31-rc1 but parts of it were later dropped
in 2.6.34-rc1 (commit 23fb064b) when Tejun removed the legacy percpu
allocator. The new percpu allocator in mm/percpu.c uses standard
allocation methods like alloc_bootmem or kzalloc and kmemleak handles
these already, so no need for extra code in kernel/module.c.

> The kmemleak_alloc and kmemleak_free in percpu_modalloc
> and percpu_modfree routines are capturing allocations/frees
> of percpu data areas when a module is loaded or unloaded,
> respectively.  However, on some platforms, the percpu
> memory area is instantiated by the bootmem allocator,
> and the memory in question is already tracked by kmemleak.

I only tested kmemleak on ARM and x86 and it was fine at the time.
Anyway, it currently doesn't matter since we dropped this kmemleak
callback entirely from percpu_modalloc/modfree.

> When a module is loaded and unloaded multiple times, it
> causes problems for kmemleak.  The bug report I'm looking at
> says "kmemleak stops", but I don't know what that means. I
> can ask for clarification if needed.

If the kmemleak gets called with a block already registered, it prints a
warning and disables itself.

> Have you heard of this issue?

No but it is possible with older kernels.

> Our solution was just to make these specific calls to kmemleak_alloc
> and kmemleak_free (in module.c) compile-time configurable.
> I suspect that there is a better way to do this -- possibly by
> detecting or noting that this situation exists for certain
> platforms, and avoiding it without specific user interaction.

For the 2.6.29 kernel (not mainline), you could have it compile-tome
configurable. Another option would be to hack create_object() in
mm/kmemleak.c to not call kmemleak_stop("Cannot insert ..."), though
this method could potentially hide other problems with kmemleak
callbacks.

-- 
Catalin

