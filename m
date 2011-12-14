Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954Ab1LNSfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 13:35:00 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47977 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757371Ab1LNSe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 13:34:57 -0500
Date: Wed, 14 Dec 2011 18:34:47 +0000
From: Will Deacon <will.deacon@arm.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: IRQ migration on CPU offline path
Message-ID: <20111214183446.GB12703@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

I've been looking at the IRQ migration code on x86 (fixup_irqs) for the CPU
hotplug path in order to try and fix a bug we have on ARM with the
desc->affinity mask not getting updated. Compared to irq_set_affinity, the code
is pretty whacky (I guess because it's called via stop_machine) so I wondered if
you could help me understand a few points:

(1) Affinity notifiers - we seem to ignore these and I guess they don't expect
    to be called from this context. It could lead to the cpu_rmap stuff being
    bogus, but that's not used for anything much. Do we just depend on people
    having hotplug notifiers to deal with this?

(2) Threaded handlers - I can't see where we update irqaction->thread_flags with
    IRQTF_AFFINITY for handlers that are migrated by the scheduler when a CPU
    goes down. Is this required?

(3) On x86, we rely on the irq_chip updating the desc->affinity mask in
    ->irq_set_affinity. It seems like we could use IRQ_SET_MASK_OK{_NOCOPY} for
    this and, in the case of the ioapic, return IRQ_SET_MASK_OK_NOCOPY (removing
    a redundant copy from the usual affinity path).

Of course, I could just be completely confused, which is why I haven't started
hacking code just yet :)

Cheers and sorry for the barrage of questions!,

Will
