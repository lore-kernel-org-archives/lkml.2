Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab2E2Ic1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 04:32:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:51284 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab2E2Ic0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 04:32:26 -0400
Message-ID: <1338280335.14636.27.camel@twins>
Subject: Re: [RFC PATCH 00/10] Cleanup
 ipi_call_lock[_irq]()/ipi_call_unlock[_irq]()
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, ralf@linux-mips.org, sshtylyov@mvista.com,
        david.daney@cavium.com, nikunj@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, axboe@kernel.dk, mingo@kernel.org,
        tglx@linutronix.de, akpm@linux-foundation.org,
        srivatsa.bhat@linux.vnet.ibm.com
Date: Tue, 29 May 2012 10:32:15 +0200
In-Reply-To: <1338280115.14636.26.camel@twins>
References: <1338275765-3217-1-git-send-email-yong.zhang0@gmail.com>
	 <1338280115.14636.26.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-29 at 10:28 +0200, Peter Zijlstra wrote:
> On Tue, 2012-05-29 at 15:15 +0800, Yong Zhang wrote:
> > As discussed with Srivatsa [1], it seems there is no need to keep
> > ipi_call_[un]lock_irq() when cpu bring-up/down. Because:
> > 
> > 1) call_function.lock used in smp_call_function_many() is just to protect
> >    call_function.queue and &data->refs, cpu_online_mask is outside of the
> >    lock. And it's not necessary to protect cpu_online_mask,
> >    because data->cpumask is pre-calculate and even if a cpu is brougt up
> >    when calling arch_send_call_function_ipi_mask(), it's harmless because
> >    validation test in generic_smp_call_function_interrupt() will take care
> >    of it.
> > 
> > 2) For cpu down issue, stop_machine() will guarantee that no concurrent
> >    smp_call_fuction() is processing. 
> 
> But that lock was only taken around setting a cpu online, so the offline
> case is pretty much irrelevant for these patches, right?

Ah, I see, some archs also did it on offline.

> That said, is there an alternative to stop_machine on the down side?
> 
> I guess flipping the cpu offline and then doing synchronize_sched()
> should suffice.

