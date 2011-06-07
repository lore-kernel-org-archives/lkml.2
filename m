Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab1FGLyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 07:54:16 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33562 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab1FGLyP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 07:54:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RqODb9ohqJFzy2uEVwK+jxO6NQ7+zDuLwV9cDi+GTigSsrOYl4xMIXyLd97QZKQTyg
         M7GGDWndz/RMmosxMW+ePfOGTRhOAoVwMgTgjtShyL5VYbcIVT2w8s+SCKusNShEnW1D
         bQLRTb0VvimcZMBpulPlTidmcVKVbOBODMtYY=
MIME-Version: 1.0
In-Reply-To: <1307445525.31814.26.camel@gandalf.stny.rr.com>
References: <1307445525.31814.26.camel@gandalf.stny.rr.com>
Date: Tue, 7 Jun 2011 14:54:14 +0300
X-Google-Sender-Auth: P7SbiZOG3zSyTAcit_y7GPSmYdU
Message-ID: <BANLkTinUcZFW6-GKQgWn-KhzEA0Qbaz8PA@mail.gmail.com>
Subject: Re: [PATCH] slob/lockdep: Fix gfp flags passed to lockdep
From: Pekka Enberg <penberg@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Matt Mackall <mpm@selenic.com>, Paul Mundt <lethal@linux-sh.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 7, 2011 at 2:18 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Doing a ktest.pl randconfig, I stumbled across the following bug
> on boot up:
>
> ------------[ cut here ]------------
> WARNING: at /home/rostedt/work/autotest/nobackup/linux-test.git/kernel/lockdep.c:2649 lockdep_trace_alloc+0xed/0x100()
> Hardware name:
> Modules linked in:
> Pid: 0, comm: swapper Not tainted 3.0.0-rc1-test-00054-g1d68b67 #1
> Call Trace:
>  [<ffffffff810626ad>] warn_slowpath_common+0xad/0xf0
>  [<ffffffff8106270a>] warn_slowpath_null+0x1a/0x20
>  [<ffffffff810b537d>] lockdep_trace_alloc+0xed/0x100
>  [<ffffffff81182fb0>] __kmalloc_node+0x30/0x2f0
>  [<ffffffff81153eda>] pcpu_mem_alloc+0x13a/0x180
>  [<ffffffff82be022c>] percpu_init_late+0x48/0xc2
>  [<ffffffff82bd630c>] ? mem_init+0xd8/0xe3
>  [<ffffffff82bbcc73>] start_kernel+0x1c2/0x449
>  [<ffffffff82bbc35c>] x86_64_start_reservations+0x163/0x167
>  [<ffffffff82bbc493>] x86_64_start_kernel+0x133/0x142^M
> ---[ end trace a7919e7f17c0a725 ]---
>
> Then I ran a ktest.pl config_bisect and it came up with this config
> as the problem:
>
>  CONFIG_SLOB
>
> Looking at what is different between SLOB and SLAB and SLUB, I found
> that the gfp flags are masked against gfp_allowed_mask in
> SLAB and SLUB, but not SLOB.
>
> On boot up, interrupts are disabled and lockdep will warn if some flags
> are set in gfp and interrupts are disabled. But these flags are masked
> off with the gfp_allowed_mask during boot. Because SLOB does not
> mask the flags against gfp_allowed_mask it triggers the warn on.
>
> Adding this mask fixes the bug. I also found that kmem_cache_alloc_node()
> was missing both the mask and the lockdep check, and that was added too.
>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Nick Piggin <npiggin@kernel.dk>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>
> diff --git a/mm/slob.c b/mm/slob.c
> index 46e0aee..0ae8818 100644
> --- a/mm/slob.c
> +++ b/mm/slob.c
> @@ -482,6 +482,8 @@ void *__kmalloc_node(size_t size, gfp_t gfp, int node)
>        int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
>        void *ret;
>
> +       gfp &= gfp_allowed_mask;
> +
>        lockdep_trace_alloc(gfp);
>
>        if (size < PAGE_SIZE - align) {
> @@ -608,6 +610,10 @@ void *kmem_cache_alloc_node(struct kmem_cache *c, gfp_t flags, int node)
>  {
>        void *b;
>
> +       flags &= gfp_allowed_mask;
> +
> +       lockdep_trace_alloc(flags);
> +
>        if (c->size < PAGE_SIZE) {
>                b = slob_alloc(c->size, flags, c->align, node);
>                trace_kmem_cache_alloc_node(_RET_IP_, b, c->size,

Matt, any objections to merging this?
