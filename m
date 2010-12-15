Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab0LOXNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 18:13:38 -0500
Received: from www.tglx.de ([62.245.132.106]:59019 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755635Ab0LOXNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 18:13:07 -0500
Message-Id: <20101215230352.411894017@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 15 Dec 2010 23:12:31 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Jan Kiszka <jan.kiszka@web.de>
Subject: [RFC patch 0/4] genirq: Provide adaptive irq oneshot functionality
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Warning: This is completely untested. Jan managed to confuse me even
way beyond my base confusion level, so testing seems to be the
appropriate reparation.

The final goal of these modifications is to allow an adaptive oneshot
mode for possibly shared interrupts. If the interrupt is not shared
then oneshot mode should be used as it is more efficient than
masking/unmasking at the device level. When the interrupt becomes
shared then the oneshot mode needs to be disabled and device level
masking must be done.

That requires transitioning from one state to the other which needs
the help of the interrupt handler of the device which asked for this
feature.

This has been implemented before by Jan Kiszka in several iterations
and I have to admit that I led Jan down the wrong road when I
suggested to put the shared status into irq_data.

Seems my brain tricked me as I'm about to add a status field to
irq_data for irq chips consumption, but of course that does not help
interrupt handlers as they need to retrieve that information on every
handler invocation, which is involves a radix tree lookup in the worst
case.

Though avoiding the initialy proposed notifier ugliness in the first
place and (ab^H^Hre)using the interrupt handler which has to be aware about
the shared/non shared state already turned out to be a not too bad
idea. Just my init idea sucked a bit.

Instead of retrieving irq_data we encode the shared state and the
transition to it into the lower two bits of the dev_id pointer which
is the second argument to the interrupt handler if and only if the
driver requested the interrupt with the new IRQF_ADAPTIVE_SHARED flag
set.

Thanks,

	tglx


