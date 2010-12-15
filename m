Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab0LOQvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 11:51:40 -0500
Received: from canuck.infradead.org ([134.117.69.58]:38756 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab0LOQvj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:51:39 -0500
Subject: Re: [cpuops cmpxchg V2 3/5] irq_work: Use per cpu atomics instead
 of regular atomics
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <4D08EDA9.3090801@kernel.org>
References: <20101214162842.542421046@linux.com>
	 <20101214162854.218751478@linux.com>  <4D08EDA9.3090801@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 15 Dec 2010 17:50:39 +0100
Message-ID: <1292431839.2708.30.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-15 at 17:32 +0100, Tejun Heo wrote:
> On 12/14/2010 05:28 PM, Christoph Lameter wrote:
> > The irq work queue is a per cpu object and it is sufficient for
> > synchronization if per cpu atomics are used. Doing so simplifies
> > the code and reduces the overhead of the code.
> > 
> > Before:
> > 
> > christoph@linux-2.6$ size kernel/irq_work.o
> >    text	   data	    bss	    dec	    hex	filename
> >     451	      8	      1	    460	    1cc	kernel/irq_work.o
> > 
> > After:
> > 
> > christoph@linux-2.6$ size kernel/irq_work.o 
> >    text	   data	    bss	    dec	    hex	filename
> >     438	      8	      1	    447	    1bf	kernel/irq_work.o
> > 
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Peter, can you please ack this one?

I guess so, I don't much like the bare preempt_disable/enable there, and
I'm wondering, aren't %fs prefixed insn slower than regular insn? Does
it really pay to avoid this one address computation if there's multiple
users in a function. %fs prefixes do take another byte, so it will also
result in larger code at some point.
