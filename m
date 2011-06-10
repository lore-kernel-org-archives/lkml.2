Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab1FJJlG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 05:41:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34014 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab1FJJlD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 05:41:03 -0400
Subject: Re: [PATCH 1/3] printk: Release console_sem after logbuf_lock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        efault@gmx.de, Arne Jansen <lists@die-jansens.de>
In-Reply-To: <20110610093354.GH27280@elte.hu>
References: <20110609130647.937204592@chello.nl>
	 <20110609131307.493181962@chello.nl>
	 <20110609130617.f8aca966.akpm@linux-foundation.org>
	 <20110609202707.GA28951@elte.hu> <1307652883.2497.1028.camel@laptop>
	 <20110609140714.fc9ea187.akpm@linux-foundation.org>
	 <alpine.LSU.2.00.1106091655560.2710@sister.anvils>
	 <20110609170804.1b76e853.akpm@linux-foundation.org>
	 <20110610093354.GH27280@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Jun 2011 11:40:44 +0200
Message-ID: <1307698844.3941.105.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-10 at 11:33 +0200, Ingo Molnar wrote:
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > Some notes:
> > 
> > Stupid thing doesn't explain the magical locking though :( I'm 
> > 99.9% sure that putting an up() inside a spinlock_irq()ed region 
> > was deliberate.
> 
> My guess would be it's done so that pending irqs that have queued up 
> during our current printk-ing activities do not hit us with the 
> console still locked.

Ah, so we already flushed the buffer, but have console_sem locked, so
any interrupt that comes in and prints something will place it in the
buffer but find console_sem is taken, so not flush it.

Then when we're back to doing up() the buffer is filled and nobody will
flush it.

I guess, we can write it like:

	spin_unlock(&logbuf_lock);
	up(&console_sem);
	local_irq_restore(flags);

which would keep interrupt disabled over up(), but have the logbuf_lock
dropped.

