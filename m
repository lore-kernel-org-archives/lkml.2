Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab1ANMEY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 07:04:24 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35529 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab1ANMER convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 07:04:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WOiwzHyu0lWGns3ttuKToKpTVMhFY6vzjwxAhfl5sTNFrOwa8jOhL8sqHHn+JMks+3
         XsSXdbJARzCsZHo5W4/Ba8q0ivZmTqAoG+jh5eF6UjcwUHOLEUzq5sKo6pihO/ogTMg+
         7ECaLdGQw5aUCI7AMdNG0L6KJmZGN91ASVFLc=
MIME-Version: 1.0
In-Reply-To: <20110114105808.GA619@flint.arm.linux.org.uk>
References: <20110114105808.GA619@flint.arm.linux.org.uk>
Date: Fri, 14 Jan 2011 23:04:15 +1100
Message-ID: <AANLkTikHVsRra=jUHsOzyjtA+=RJXtbgNtUBkcR8m+8q@mail.gmail.com>
Subject: Re: BUG: __d_rehash explodes on boot
From: Nick Piggin <npiggin@gmail.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <npiggin@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 9:58 PM, Russell King <rmk@arm.linux.org.uk> wrote:
> __d_rehash is dereferencing an almost-NULL pointer on my ARM926.
> CONFIG_SMP=n and CONFIG_DEBUG_SPINLOCK=y.
>
> The faulting instruction is:    strne   r3, [r2, #4]
> and as can be seen from the register dump below, r2 is 0x00000001, hence
> the faulting 0x00000005 address.
>
> __d_rehash is essentially:
>
>        spin_lock_bucket(b);
>        entry->d_flags &= ~DCACHE_UNHASHED;
>        hlist_bl_add_head_rcu(&entry->d_hash, &b->head);
>        spin_unlock_bucket(b);
>
> which is:
>
>        bit_spin_lock(0, (unsigned long *)&b->head.first);
>        entry->d_flags &= ~DCACHE_UNHASHED;
>        hlist_bl_add_head_rcu(&entry->d_hash, &b->head);
>        __bit_spin_unlock(0, (unsigned long *)&b->head.first);
>
> bit_spin_lock(0, ptr) sets bit 0 of *ptr, in this case b->head.first if
> CONFIG_SMP or CONFIG_DEBUG_SPINLOCK is set:
>
> #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
>        while (unlikely(test_and_set_bit_lock(bitnum, addr))) {
>                while (test_bit(bitnum, addr)) {
>                        preempt_enable();
>                        cpu_relax();
>                        preempt_disable();
>                }
>        }
> #endif
>
> So, b->head.first starts off NULL, and becomes a non-NULL (address 1).
> hlist_bl_add_head_rcu() does this:
>
> static inline void hlist_bl_add_head_rcu(struct hlist_bl_node *n,
>                                        struct hlist_bl_head *h)
> {
>        first = hlist_bl_first(h);
>        n->next = first;
>        if (first)
>                first->pprev = &n->next;
>
> It is the store to first->pprev which is faulting.
>
> hlist_bl_first():
>
> static inline struct hlist_bl_node *hlist_bl_first(struct hlist_bl_head *h)
> {
>        return (struct hlist_bl_node *)
>                ((unsigned long)h->first & ~LIST_BL_LOCKMASK);
> }
>
> but:
> #if defined(CONFIG_SMP)
> #define LIST_BL_LOCKMASK        1UL
> #else
> #define LIST_BL_LOCKMASK        0UL
> #endif
>
> So, we have one piece of code which sets bit 0 of addresses, and another
> bit of code which doesn't clear it before dereferencing the pointer if
> !CONFIG_SMP && CONFIG_DEBUG_SPINLOCK.  With the patch below, I can again
> sucessfully boot the kernel on my Versatile PB/926 platform.
>
> Kernel messages:
> ...
> Calibrating delay loop... 104.24 BogoMIPS (lpj=521216)
> pid_max: default: 32768 minimum: 301
> Mount-cache hash table entries: 512
> CPU: Testing write buffer coherency: ok
> Unhandled fault: alignment exception (0x801) at 0x00000005
> Internal error: : 801 [#1]
> last sysfs file:
> Modules linked in:
> CPU: 0    Not tainted  (2.6.37+ #533)
> PC is at __d_rehash+0x74/0xb8
> LR is at _d_rehash+0x4c/0x60
> pc : [<c00c2bc8>]    lr : [<c00c2c58>]    psr: 20000013
> sp : c183fd18  ip : c09cb8c0  fp : c183fd24
> r10: c183fdd8  r9 : c183fdec  r8 : c183fde4
> r7 : c1401940  r6 : c183fe7c  r5 : c1401710  r4 : c14016c0
> r3 : c14016c8  r2 : 00000001  r1 : 20000013  r0 : c14016c0
> Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> Control: 0005317f  Table: 00004000  DAC: 00000017
> Process kworker/u:0 (pid: 9, stack limit = 0xc183e270)
> Stack: (0xc183fd18 to 0xc1840000)
> <trimmed>
> Backtrace:
> [<c00c2b54>] (__d_rehash+0x0/0xb8) from [<c00c2c58>] (_d_rehash+0x4c/0x60)
> [<c00c2c0c>] (_d_rehash+0x0/0x60) from [<c00c38a0>] (d_rehash+0x24/0x30)
> [<c00c387c>] (d_rehash+0x0/0x30) from [<c00d059c>] (simple_lookup+0x44/0x50)
> [<c00d0558>] (simple_lookup+0x0/0x50) from [<c00bb03c>] (d_alloc_and_lookup+0x50/0x6c)
> [<c00bafec>] (d_alloc_and_lookup+0x0/0x6c) from [<c00bb424>] (do_lookup+0x1b8/0x278)
> [<c00bb26c>] (do_lookup+0x0/0x278) from [<c00bcd68>] (link_path_walk+0x210/0xbec)
> [<c00bcb58>] (link_path_walk+0x0/0xbec) from [<c00bd958>] (do_path_lookup+0x44/0xd0)
> [<c00bd914>] (do_path_lookup+0x0/0xd0) from [<c00be624>] (do_filp_open+0xe4/0x5f8)
> [<c00be540>] (do_filp_open+0x0/0x5f8) from [<c00b7b10>] (open_exec+0x2c/0x90)
> [<c00b7ae4>] (open_exec+0x0/0x90) from [<c00b8408>] (do_execve+0x88/0x264)
> [<c00b8380>] (do_execve+0x0/0x264) from [<c0039254>] (kernel_execve+0x40/0x88)
> [<c0039214>] (kernel_execve+0x0/0x88) from [<c005c000>] (____call_usermodehelper+0x88/0x98)
> [<c005bf78>] (____call_usermodehelper+0x0/0x98) from [<c004cc90>] (do_exit+0x0/0x5f8)
> Code: e59c2000 e3520000 12803008 e5802008 (15823004)
> ---[ end trace 1b75b31a2719ed1c ]---
>
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
>  include/linux/list_bl.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
> index b2adbb4..5bad17d 100644
> --- a/include/linux/list_bl.h
> +++ b/include/linux/list_bl.h
> @@ -16,7 +16,7 @@
>  * some fast and compact auxiliary data.
>  */
>
> -#if defined(CONFIG_SMP)
> +#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
>  #define LIST_BL_LOCKMASK       1UL
>  #else
>  #define LIST_BL_LOCKMASK       0UL

Sigh. Thanks. I guess it is the only thing we can do to keep
the UP optimisation...
