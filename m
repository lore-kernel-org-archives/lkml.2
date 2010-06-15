Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285Ab0FOEXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 00:23:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901Ab0FOEXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 00:23:08 -0400
Date: Mon, 14 Jun 2010 21:21:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
Cc: tytso@mit.edu, Salman <sqazi@google.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, peterz@infradead.org, tytso@google.com,
       torvalds@linux-foundation.org, walken@google.com,
       Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be
 reused immediately.
Message-Id: <20100614212150.4dcb1feb.akpm@linux-foundation.org>
In-Reply-To: <20100615032608.GB30479@drongo>
References: <AANLkTinlnb-HsDia4X2qgRjkTL_Z5CfVKYHRFwREoyIn@mail.gmail.com>
	<20100611224902.5039.60134.stgit@bumblebee1.mtv.corp.google.com>
	<20100614165851.6bdfe485.akpm@linux-foundation.org>
	<20100615005619.GI6666@thunk.org>
	<20100614185556.afdc5304.akpm@linux-foundation.org>
	<20100615032608.GB30479@drongo>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jun 2010 13:26:08 +1000 Paul Mackerras <paulus@samba.org> wrote:

> On Mon, Jun 14, 2010 at 06:55:56PM -0700, Andrew Morton wrote:
> 
> > > kernel/sched_clock.c:   if (cmpxchg64(&scd->clock, old_clock, clock) != old_cloc
> > 
> > I guess that'll flush out any stragglers.
> 
> And break most non-x86 32-bit architectures, including 32-bit powerpc.

If CONFIG_SMP=y, yes.  On UP there's a generic implementation
(include/asm-generic/cmpxchg-local.h, include/asm-generic/cmpxchg.h)

> Fortunately that code is only used if CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
> is set, and it looks like only x86 and ia64 set it.
> 

If that happens then the best fix is for those architectures to get
themselves a cmpxchg64().  Unless for some reason it's simply
unimplementable?  Worst case I guess one could use a global spinlock. 
Second-worst-case: hashed spinlocks.
