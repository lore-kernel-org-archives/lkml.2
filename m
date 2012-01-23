Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811Ab2AWFii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 00:38:38 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:57429 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab2AWFih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 00:38:37 -0500
Message-ID: <1327297111.4129.27.camel@work-vm>
Subject: Lapic vector priorites
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Clark Williams <williams@redhat.com>, Nivedita Singhvi <niv@us.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>, vosburgh@us.ibm.com
Date: Sun, 22 Jan 2012 21:38:31 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012305-4242-0000-0000-00000095F826
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
	I got a question this weekend about irq priorities where it was looking
like the hrtimer_interrupt was bring delayed under heavy load spikes.
The issue hasn't been conclusively determined, but this reminded me of
the old issue that cropped up occasionally with 2.4 (maybe with
clustered apic addressing?) where we got lost-ticks that were caused by
irq storms, due to the timer interrupt being lower priority then the
scsi controller.

I'm really not that familiar with the lapic code, but reading over some
of the documentation I could find through searches, and then looking at
the lapic vector layout in the kernel, I'm now a little curious.

>From what I've read the irq priority is set by the vector, where 0x0 is
the highest and 0xFF is the lowest.

In irq_vectors.h I see:
#define NMI_VECTOR			0x02
#define MCE_VECTOR			0x12

So really critical stuff being very low. Makes sense. Then:

#define FIRST_EXTERNAL_VECTOR		0x20

Then a gap. Then:

#define IRQ0_VECTOR		((FIRST_EXTERNAL_VECTOR + 16) & ~15)
...
#define IRQ15_VECTOR			(IRQ0_VECTOR + 15)

Ok, so IRQ0 is at vector 0x30 and IRQ15 is at 0x3f

Then there's other cpu specific bits way up at 0xf3-0xff.

And then I see:
/*
 * Local APIC timer IRQ vector is on a different priority level,
 * to work around the 'lost local interrupt if more than 2 IRQ
 * sources per level' errata.
 */
#define LOCAL_TIMER_VECTOR		0xef


So, from this it seems that the lapic timer is going to be a lower
priority then most of the irq space (or atleast irqs 0-15) . Making it
possible to see timer latencies from irq storms.  Is that right?  Or do
all the irqs really come in via:
#define IRQ_WORK_VECTOR			0xf6


I realize from the comment that the lapic needs to be on its own range
to avoid the errata, but could that range be 0x2X (moving whatever goes
in the 0x2X range elsewhere)?  I did a brief test setting the lapic to
0x2f and my simple test machine booted, so it seems this might be
possible.

I realize from all the bug reports over the last number of years how
fragile the lapic code is (or more accurately how poor and quirky the
hardware is), but it seemed like having timer irqs be behind other
devices would be a possible latency source that would likely have -rt
effects (I looked, but I don't see anything in the -rt patch set playing
with irq vectors - maybe this issue is avoided in other ways?).

Am I just misunderstanding all of this?

thanks
-john

