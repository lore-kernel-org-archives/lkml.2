Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab0KQEBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 23:01:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757546Ab0KQEBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 23:01:23 -0500
Date: Tue, 16 Nov 2010 19:57:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH -v4 1/2] lib, Make gen_pool memory allocator lockless
Message-Id: <20101116195720.23287038.akpm@linux-foundation.org>
In-Reply-To: <1289963005.8719.1238.camel@yhuang-dev>
References: <1289868791-16658-1-git-send-email-ying.huang@intel.com>
	<1289868791-16658-2-git-send-email-ying.huang@intel.com>
	<20101116135038.fcaa90ca.akpm@linux-foundation.org>
	<1289960281.8719.1218.camel@yhuang-dev>
	<20101116183506.41e77e1a.akpm@linux-foundation.org>
	<1289963005.8719.1238.camel@yhuang-dev>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010 11:03:25 +0800 Huang Ying <ying.huang@intel.com> wrote:

> It seems that Steven thinks many architectures without NMI-safe cmpxchg
> have no real NMI too.

Could be.

Really, we should nail this down and work out the matrix of
what-works-with-what, and then arrange for the things which _won't_
work to be either non-Kconfigurable or non-compilable.

The worst thing we could do would be to advertise some code as
"nmi-safe!!", then to have someone go and use it on that basis, only
for their users to later discover ghastly rare races.

> In the patch description and comments, it is said that on architectures
> without NMI-safe cmpxchg, gen_pool can not be used in NMI handler
> safely.
> 
> Or do you think it is better to use a spin_trylock based fallback if
> NMI-safe cmpxchg is not available? Or require cmpxchg implementation
> uses spin_trylock instead of spin_lock?

As a first step, a typical thing to do would be to create
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG, define that in the appropriate
architectures, make ftrace and perf and genpool and anything else
dependent upon that at Kconfig-time.

A spin_trylock_irqsave() implementation would do what?  Rarely fail the
memory allocation attempt if the trylock failed?  I guess that's
acceptable in the context of gen_pool, because memory allocators are
expected to fail, and everyone carefully tests the allocation-failed
error paths (lol).

But rare failures may not be useful within the context of future
clients of the "lockless" list implementation so I'd say that a safer
approach would be to make the list implementation require
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG and be done with it.

So that's all pretty simple so far.  However...

The list implementation is still useful to
non-CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG clients, as long as they aren't
using it from NMI context, yes?

In which case I suppose we could add a library of lockless_list_foo()
functions which are usable from non-NMI contexts and which are
available to all configs.  And on top of that implement a library of
nmi_safe_lockless_list_foo() functions which are just wrappers around
lockless_list_foo(), but which are only available if
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y.

Which is getting to be a bit of a pain, so you might choose to
disregard everything after "However..." ;)
