Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab0LORSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 12:18:55 -0500
Received: from canuck.infradead.org ([134.117.69.58]:59699 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab0LORSy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 12:18:54 -0500
Subject: Re: [cpuops cmpxchg V2 3/5] irq_work: Use per cpu atomics instead
 of regular atomics
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <alpine.DEB.2.00.1012151059430.13049@router.home>
References: <20101214162842.542421046@linux.com>
	 <20101214162854.218751478@linux.com>  <4D08EDA9.3090801@kernel.org>
	 <1292431839.2708.30.camel@laptop>
	 <alpine.DEB.2.00.1012151059430.13049@router.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 15 Dec 2010 18:18:37 +0100
Message-ID: <1292433517.2708.41.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-15 at 11:04 -0600, Christoph Lameter wrote:

> Prefixes are faster than explicit address calculations. A prefix allows
> you to integrate the per cpu address calculation into an arithmetic
> operation.

Well, depends on how often you need that address I'd think. If you'd
have a per-cpu struct and need to frob lots of variables in that struct
it might be cheaper to simply compute the struct address once and then
use relative addresses than to prefix everything with %fs.

> A prefix is one byte which is less that multiple arithmetic operations to
> calculate an address.

I thought you'd only need a single arithmetic op to calculate the
address, anyway at some point those 1 byte prefixes will add up to more
than the ops saved.

In the current code you add 2 bytes (although you safe one from loosing
the LOCK prefix, but that could have been achieved by using
cmpxchg_local() as well. These 2 bytes are probably less than the
address computation for head (and not needing the head pointer again
saves on register pressure) so its probably a win here.

Still, non of this is really fast-path code, so I really wonder why
we're optimizing this over keeping the code obvious.

> I am not sure that the preempt_disable/enable is needed. They are just
> there because you had a get/put_cpu there.
> 
> If the code is run from hardirq context then preempt is already disabled.
> We can just drop those then.

Afaik the current callers are all from IRQ/NMI context, but I don't want
to mandate callers be from such contexts.

The problem is that we need to guarantee we raise the self-IPI on the
same cpu we queued the worklet on.
