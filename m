Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab0DOGwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 02:52:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:59841 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab0DOGwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 02:52:11 -0400
Subject: Re: linux-next: boot failure after merge of the final tree (tip
 related)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-next@vger.kernel.org,
       ppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20100415161214.04637496.sfr@canb.auug.org.au>
References: <20100415161214.04637496.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Apr 2010 16:48:30 +1000
Message-ID: <1271314110.13059.159.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-15 at 16:12 +1000, Stephen Rothwell wrote:
> 
> Caused by commit bd6d29c25bb1a24a4c160ec5de43e0004e01f72b ("lockstat:
> Make lockstat counting per cpu").  This added a WARN_ON_ONCE to
> debug_atomic_inc() which is called from trace_hardirqs_on_caller()
> with
> irqs enabled.
> 
> Line 2301 is:
> 
>         if (unlikely(curr->hardirqs_enabled)) {
>                 debug_atomic_inc(redundant_hardirqs_on);   <--- 2301
>                 return;
>         }
> 
> This is especially bad since on PowerPC, WARN_ON is a TRAP and the
> return
> path from the TRAP also calls trace_hardirqs_on_caller(), so the TRAP
> recurses ... 

I think this is because our syscall entry pretty much force-enable irqs.

I remember deciding back then that getting lockdep balanced in that area
was tricky and I didn't do it to avoid adding more overhead to the
syscall path but I suppose I could revisit if necessary.

Cheers,
Ben.

