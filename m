Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab1FFPKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:10:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:38874 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1FFPKE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:10:04 -0400
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arne Jansen <lists@die-jansens.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <20110606145827.GD30348@elte.hu>
References: <20110605110132.GB23463@elte.hu>
	 <20110605111933.GA24592@elte.hu> <20110605113627.GA25724@elte.hu>
	 <4DEB6F3A.3000109@die-jansens.de> <20110605133958.GA27812@elte.hu>
	 <4DEB8A93.30601@die-jansens.de> <20110605141003.GB29338@elte.hu>
	 <4DEB933C.1070900@die-jansens.de> <20110605151323.GA30590@elte.hu>
	 <1307349530.2353.7374.camel@twins>  <20110606145827.GD30348@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 06 Jun 2011 17:09:49 +0200
Message-ID: <1307372989.2322.136.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 16:58 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Sun, 2011-06-05 at 17:13 +0200, Ingo Molnar wrote:
> > 
> > > Now, this patch alone just removes a debugging check - but i'm not 
> > > sure the debugging check is correct - we take the pi_lock in a raw 
> > > way - which means it's not lockdep covered.
> > 
> > Ever since tglx did s/raw_/arch_/g raw_ is covered by lockdep.
> 
> It's not lockdep covered due to the lockdep_off(), or am i missing 
> something?

Your initial stmt was about the raw_ part, raw_ locks are tracked by
lockdep ever since tglx renamed them to arch_ and introduced new raw_
primitives.

But yeah, the lockdep_off() stuff also disables all tracking, on top of
that it also makes lock_is_held() return an unconditional false (even if
the lock was acquired before lockdep_off and thus registered).

My patch that fixes lock_is_held() should avoid false
lockdep_assert_held() explosions and this this printk() while rq->lock
problem.

Removing lockdep_off() usage from printk() would also be nice, but Mike
triggered logbuf_lock <-> rq->lock inversion with that due to the
up(&console_sem) wakeup muck.

Ideally we'd pull the up() out from under logbuf_lock, am looking at
that.
