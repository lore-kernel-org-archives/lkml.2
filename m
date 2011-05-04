Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab1EDOqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 10:46:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:45219 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab1EDOql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 10:46:41 -0400
Date: Wed, 4 May 2011 16:46:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
In-Reply-To: <20110504142532.GC17294@htj.dyndns.org>
Message-ID: <alpine.LFD.2.02.1105041640020.3005@ionos>
References: <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com> <20110504083559.GB25724@elte.hu> <alpine.LFD.2.02.1105041124080.3005@ionos> <20110504101932.GA3392@elte.hu> <alpine.LFD.2.02.1105041233280.3005@ionos> <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com>
 <20110504112746.GE8007@htj.dyndns.org> <alpine.LFD.2.02.1105041417330.3005@ionos> <20110504132022.GA17294@htj.dyndns.org> <alpine.LFD.2.02.1105041539050.3005@ionos> <20110504142532.GC17294@htj.dyndns.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, Tejun Heo wrote:

> Hello,
> 
> On Wed, May 04, 2011 at 04:10:29PM +0200, Thomas Gleixner wrote:
> > > cases where the generic implementation is used.  Has anyone measured
> > > the difference against before the whole this_cpu conversion?
> > 
> > Yes, that really wants to be done. The whole CMPXCHG_LOCAL ifdeffery
> > should have been avoided in the first place. this_cpu_cmpxchg can
> > really be implemented with preempt_enable/disable and the irqsafe
> > variant in any case.
> 
> Yeah, slub code looks pretty scary with the #ifdefs.  IIUC, the
> problem was that cmpxchg_double is an optimization for fast path which
> was already very light weight and an extra locked op or irq on/off
> would have made considerable difference.
> 
> The cmpxchg_double optimization made the fast path go quite faster
> when CPU supports it but it may as well slow things down considerably
> if CPU doesn't, due to extra irq on/off's.  Anyways, here's hoping

Not really.

CMPXCHG_LOCAL=n

	local_irq_save();
	  handle_everything();
	local_irq_restore();

vs.

CMPXCHG_LOCAL=y

	do_prep();
	local_irq_save();
	  emulate_cmpxchg();
	local_irq_restore();
	do_rest();

So you have local irq disable/enable in both cases. So for the case
where you don't have a local cmpxchg8b/16b available it's not worse
versus irq disable/enable than now. It just has the possible repeat
case when stuff changed between the prep and the actual cmpxchg, which
is the same problem when cmpxchg8b/16 is available.

Thanks,

	tglx



