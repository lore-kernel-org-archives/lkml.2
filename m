Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab0JDAuG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 20:50:06 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:47099 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab0JDAuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 20:50:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
References: <20100930221351.682772535@linutronix.de>
	<m1wrpzfctu.fsf@fess.ebiederm.org>
	<alpine.LFD.2.00.1010032034420.14550@localhost6.localdomain6>
Date: Sun, 03 Oct 2010 17:49:51 -0700
In-Reply-To: <alpine.LFD.2.00.1010032034420.14550@localhost6.localdomain6>
	(Thomas Gleixner's message of "Sun, 3 Oct 2010 21:16:47 +0200 (CEST)")
Message-ID: <m162xibx3k.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Thomas Gleixner <tglx@linutronix.de>
X-Spam-Relay-Country: 
Subject: Re: [patch 00/47] Sparse irq rework
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> On Sun, 3 Oct 2010, Eric W. Biederman wrote:
>> Thomas Gleixner <tglx@linutronix.de> writes:
>> > Rationale:
>> > ----------
>> >
>> > The current sparse_irq allocator has several short comings due to
>> > failures in the design or the lack of it:
>> >
>> >  - Requires iteration over the number of active irqs to find a free slot
>> >    Some architectures have grown their own workarounds for this.
>> >
>> >  - Freeing of irq descriptors is not possible
>> >
>> >  - Racy between create_irq_nr and destroy_irq plugged by horrible
>> >    callbacks
>> >
>> >  - Migration of active irq descriptors is not possible
>> 
>> I believe you have distored the design when aiming for migration
>> of active irq descriptors (which you have not even implemented yet).
>> 
>> How do you plan to remove the radix tree lookup from the irq
>> handling path?
>
> Not at all and it's not even even a requirement to remove the lookup
> for implementing live migration.

It sounds like it is a requirement to *keep* the lookup for supporting
live migration.  *Keeping* the lookup I see as a serious problem.  If we
do this right the only users of the radix tree will be drivers using the
functions in interrupt.h.

>> Those files provide the genirq irq chip implementation especially
>> drivers/pci/msi.c.  Of course they will do what every other irq_chip
>> implementation does to get access to data.  There is an unpleasant
>> difference between which generic irq data field htirq.c uses and msi.c
>> which may be worth cleaning up.  But otherwise I don't see any
>> fundamental problems.
>
> The fundamental problem I hit, was the hack which handed down irq_desc
> to avoid the lookup. If it had been msi_desc in the first place, then
> I would not even need to touch the msi code to cleanup x86.

Just because you intend to rename the irq_desc irq_data...

It isn't a hack for an irq method to look at irq_desc.  At least not
until your irq_data changes go through.  This has nothing to do with
how x86 is structured and everything to do with your irq_data
``cleanup'' which appears to be mostly about code churn, for very little
apparent benefit.

In the current state of the kernel I find it very hard to swallow that
having a genirq client using irq_desc (which is the only way to
implement somethings) is a hack.

Eric
