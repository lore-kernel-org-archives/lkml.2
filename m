Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258Ab0CaWh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 18:37:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:58285 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755817Ab0CaWhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 18:37:23 -0400
Subject: Re: start_kernel(): bug: interrupts were enabled early
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       Rabin Vincent <rabin@rab.in>, lkml <linux-kernel@vger.kernel.org>,
       penberg@cs.helsinki.fi, cl@linux-foundation.org,
       linux-arch@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20100331142821.425555e9.akpm@linux-foundation.org>
References: <20100325194100.GA2364@debian>
	 <20100331134048.da4e35a7.akpm@linux-foundation.org>
	 <4BB3B4DB.7040904@kernel.org>
	 <20100331135220.c6695a51.akpm@linux-foundation.org>
	 <4BB3BAD6.50308@zytor.com>
	 <20100331142821.425555e9.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Apr 2010 09:35:58 +1100
Message-ID: <1270074958.7101.77.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-31 at 14:28 -0700, Andrew Morton wrote:
> 
> Well, it's all a bit nasty.  kmem_cache_create() does a lot of stuff,
> including calling into the page allocator with GFP_KERNEL - expecting
> kmem_cache_create() to preserve local_irq_disable() is a bit
> optimistic.

Well, the sl*b allocator -has- been modified to avoid enabling IRQs
early, at least I remember we did that when we moved it to be
initialized earlier.

> radix_tree_init() calls hotcpu_notifier() which also does
> mutex_lock(&cpu_add_remove_lock);
> 
> The easiest fix is to reposition the interrutps-are-now-enabled point
> in start_kernel().  But I have a feeling that some versions of
> early_irq_init() won't like that.

Yeah that won't work. Interrupts must not be enabled before at least
init_IRQ() and time_init(). The problem is that until all these guys
have gone through their initializations, there may be pending spurrious
crap coming from the HW (timers, external IRQs, profile IRQs) due to
such HW not yet properly "sanitized" by the kernel.

Plenty of archs have those assumptions wired in. I don't think moving
the IRQ enable point earlier is the right approach.

Cheers,
Ben.


