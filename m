Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451Ab0CaV3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 17:29:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753360Ab0CaV32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 17:29:28 -0400
Date: Wed, 31 Mar 2010 14:28:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Rabin Vincent <rabin@rab.in>,
       lkml <linux-kernel@vger.kernel.org>, penberg@cs.helsinki.fi,
       cl@linux-foundation.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-arch@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: start_kernel(): bug: interrupts were enabled early
Message-Id: <20100331142821.425555e9.akpm@linux-foundation.org>
In-Reply-To: <4BB3BAD6.50308@zytor.com>
References: <20100325194100.GA2364@debian>
	<20100331134048.da4e35a7.akpm@linux-foundation.org>
	<4BB3B4DB.7040904@kernel.org>
	<20100331135220.c6695a51.akpm@linux-foundation.org>
	<4BB3BAD6.50308@zytor.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Mar 2010 14:12:54 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 03/31/2010 01:52 PM, Andrew Morton wrote:
> > On Wed, 31 Mar 2010 13:47:23 -0700
> > Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> >> spin_unlock_irq from arm is different from other archs?
> > 
> > No, spin_unlock_irq() unconditionally enables interrupts on all
> > architectures.
> 
> So I found checkin 60ba96e546da45d9e22bb04b84971a25684e4d46 in the
> bk-historic git tree:
> 
> [PATCH] rwsem: Make rwsems use interrupt disabling spinlocks
> 
> The attached patch makes read/write semaphores use interrupt disabling
> spinlocks in the slow path, thus rendering the up functions and trylock
> functions available for use in interrupt context.  This matches the
> regular semaphore behaviour.
> 
> I've assumed that the normal down functions must be called with
> interrupts enabled (since they might schedule), and used the
> irq-disabling spinlock variants that don't save the flags.
> 
> Signed-Off-By: David Howells <dhowells@redhat.com>
> Tested-by: Badari Pulavarty <pbadari@us.ibm.com>
> Signed-off-by: Linus Torvalds <torvalds@osdl.org>
> 
> What we have here is a case of this assumption being violated, because
> the lock is taken with interrupts disabled on a path where contention
> cannot happen (because the code is single-threaded at this point), but
> the lock is taken due to reuse of generic code.
> 
> The obvious way to fix this would be to use
> spin_lock_irqsave..spin_lock_irqrestore in __down_read as well as in the
> other locations; I don't have a good feel for what the cost of doing so
> would be, though.  On x86 it's fairly expensive simply because the only
> way to save the state is to push it on the stack, which the compiler
> doesn't deal well with, but this code isn't used on x86.
> 

Well, it's all a bit nasty.  kmem_cache_create() does a lot of stuff,
including calling into the page allocator with GFP_KERNEL - expecting
kmem_cache_create() to preserve local_irq_disable() is a bit optimistic.

radix_tree_init() calls hotcpu_notifier() which also does
mutex_lock(&cpu_add_remove_lock);

The easiest fix is to reposition the interrutps-are-now-enabled point
in start_kernel().  But I have a feeling that some versions of
early_irq_init() won't like that.


