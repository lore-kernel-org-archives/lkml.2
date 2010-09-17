Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab0IQNHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 09:07:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43775 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab0IQNHI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 09:07:08 -0400
Subject: Re: [PATCH -tip -v5] irq_work: generic hard-irq context callbacks
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        paulus <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, dhowells <dhowells@redhat.com>,
        Russell King <rmk@arm.linux.org.uk>, Kyle McMartin <kyle@mcmartin.ca>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        davem <davem@davemloft.net>, Linux-Arch <linux-arch@vger.kernel.org>
In-Reply-To: <1284689131.32373.63.camel@yhuang-dev>
References: <1284689131.32373.63.camel@yhuang-dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 17 Sep 2010 15:06:42 +0200
Message-ID: <1284728802.28028.470.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-17 at 10:05 +0800, Huang Ying wrote:
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> In order for other NMI context users that want to run things from
> hard-IRQ context, extract the perf_event callback mechanism.
> 
> Huang Ying: some fixes

I got complaints about a lacking changelog, how about something like the
below?

---

Provide a mechanism that allows running code in IRQ context. It is most
useful for NMI code that needs to interact with the rest of the system
-- like wakeup a task to drain buffers.

Perf currently has such a mechanism, so extract that and provide it as a
generic feature, independent of perf so that others may also benefit.

The IRQ context callback is generated through self-IPIs where possible,
or on architectures like powerpc which have soft-disabled IRQs, its ran
on the soft-enable path.

Architectures that don't have anything like this get to do with a
callback from the timer tick. These architectures can call
irq_run_work() at the tail of any IRQ handlers that might enqueue such
work (like the perf IRQ handler) to avoid undue latencies in processing
the work.

---
