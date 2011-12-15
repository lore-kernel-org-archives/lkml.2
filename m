Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501Ab1LOBXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 20:23:50 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:41758 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628Ab1LOBXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 20:23:49 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Will Deacon <will.deacon@arm.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
References: <20111214183446.GB12703@mudshark.cambridge.arm.com>
Date: Wed, 14 Dec 2011 17:25:19 -0800
In-Reply-To: <20111214183446.GB12703@mudshark.cambridge.arm.com> (Will
	Deacon's message of "Wed, 14 Dec 2011 18:34:47 +0000")
Message-ID: <m1bora8w3k.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/c6yzyV4hZbiuraMe7/c9VHobnFQGhyh0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Will Deacon <will.deacon@arm.com>
X-Spam-Relay-Country: **
Subject: Re: IRQ migration on CPU offline path
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will Deacon <will.deacon@arm.com> writes:

> Hi Thomas,
>
> I've been looking at the IRQ migration code on x86 (fixup_irqs) for the CPU
> hotplug path in order to try and fix a bug we have on ARM with the
> desc->affinity mask not getting updated. Compared to irq_set_affinity, the code
> is pretty whacky (I guess because it's called via stop_machine) so I wondered if
> you could help me understand a few points:

There is a lot of craziness on that path because of poor hardware design
on x86 we can't know when an irq has actually be migrated, and other
nasties.

There is also the issue that I expect is still the case that we have the
generic layer asking us to cpu migration and the associated irq
migrations with the irqs disabled which at least for the bits of poorly
designed hardware made the entire path a best effort beast.

> (1) Affinity notifiers - we seem to ignore these and I guess they don't expect
>     to be called from this context. It could lead to the cpu_rmap stuff being
>     bogus, but that's not used for anything much. Do we just depend on people
>     having hotplug notifiers to deal with this?

> (2) Threaded handlers - I can't see where we update irqaction->thread_flags with
>     IRQTF_AFFINITY for handlers that are migrated by the scheduler when a CPU
>     goes down. Is this required?
>
> (3) On x86, we rely on the irq_chip updating the desc->affinity mask in
>     ->irq_set_affinity. It seems like we could use IRQ_SET_MASK_OK{_NOCOPY} for
>     this and, in the case of the ioapic, return IRQ_SET_MASK_OK_NOCOPY (removing
>     a redundant copy from the usual affinity path).

Possibly.  I forget which direction this code has gone, but we have the
interesting case that frequently on x86 we can be pinned to multiple and
the hardware only supports being pinned to a single cpu at a time.  So
the original logic was to put in the affinity mask what we had actually
done instead of what was requested.  And in that case the mask changes
so a NOCOPY doesn't feel appropriate but I don't understand that code.

> Of course, I could just be completely confused, which is why I haven't started
> hacking code just yet :)

If x86 becomes a good clean example in this corner case I would be
amazed.  Last I looked I almost marked it all as CONFIG_BROKEN because
we were trying to do the impossible.  Unfortunately peoples laptops
go through this path when they suspend and so it was more painful to
disable hacky racy mess than to keep living with it.

There has been an increase in the number of cases where it is possible
to actually perform the migration with irqs disabled so on a good day
that code might even work.  

Eric
