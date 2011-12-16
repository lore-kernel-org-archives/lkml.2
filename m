Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288Ab1LPFZQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 00:25:16 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:58178 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab1LPFZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 00:25:14 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Will Deacon <will.deacon@arm.com>
Cc: "tglx\@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20111214183446.GB12703@mudshark.cambridge.arm.com>
	<m1bora8w3k.fsf@fess.ebiederm.org>
	<20111215162824.GM15131@mudshark.cambridge.arm.com>
Date: Thu, 15 Dec 2011 21:26:46 -0800
In-Reply-To: <20111215162824.GM15131@mudshark.cambridge.arm.com> (Will
	Deacon's message of "Thu, 15 Dec 2011 16:28:24 +0000")
Message-ID: <m1bor95bop.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19LWtpOFs8mGvswkkNn376coRNcpWkO/Po=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0052]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Will Deacon <will.deacon@arm.com>
X-Spam-Relay-Country: **
Subject: Re: IRQ migration on CPU offline path
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will Deacon <will.deacon@arm.com> writes:

> Hi Eric,
>
> Cheers for the response.
>
> On Thu, Dec 15, 2011 at 01:25:19AM +0000, Eric W. Biederman wrote:
>> Will Deacon <will.deacon@arm.com> writes:
>> > I've been looking at the IRQ migration code on x86 (fixup_irqs) for the CPU
>> > hotplug path in order to try and fix a bug we have on ARM with the
>> > desc->affinity mask not getting updated. Compared to irq_set_affinity, the code
>> > is pretty whacky (I guess because it's called via stop_machine) so I wondered if
>> > you could help me understand a few points:
>> 
>> There is a lot of craziness on that path because of poor hardware design
>> on x86 we can't know when an irq has actually be migrated, and other
>> nasties.
>> 
>> There is also the issue that I expect is still the case that we have the
>> generic layer asking us to cpu migration and the associated irq
>> migrations with the irqs disabled which at least for the bits of poorly
>> designed hardware made the entire path a best effort beast.
>
> Argh, ok. Does this mean that other architectures should just preserve the
> interface that x86 gives (for example not triggering IRQ affinity
> notifiers)?

Interesting.  In this case the affinity notifier is an ugly hack for
exactly one driver.  The affinity notifier is new (This January) and
buggy.  Among other things there appears to be a clear reference count
leak on the affinity notify structure. 

Honestly I don't see much to justify the existence of the affinity
notifiers, and especially their requirement that they be called in
process context.

At a practical level since the architects of the affinity notifier
didn't choose to add notification on migration I don't see why
you should care.

This isn't an x86 versus the rest of the world.  This is a 
Solarflare driver vs the rest of the kernel issue.  When the Solarflar
developers care they can fix up arm and all of the rest of the
architectures that support cpu hot unplug.

>> If x86 becomes a good clean example in this corner case I would be
>> amazed.  Last I looked I almost marked it all as CONFIG_BROKEN because
>> we were trying to do the impossible.  Unfortunately peoples laptops
>> go through this path when they suspend and so it was more painful to
>> disable hacky racy mess than to keep living with it.
>> 
>> There has been an increase in the number of cases where it is possible
>> to actually perform the migration with irqs disabled so on a good day
>> that code might even work.  
>
> Right, so this stuff is fairly fragile. We can probably get a reasonable
> version working on ARM (with the GIC present) but I'm not sure what to do
> about the notifiers I mentioned earlier and proper migration of threaded
> interrupt handlers.

Yes. It looks like the irq migration notifiers are just broken by design.

As for threaded interrupt handlers there is probably something
reasonable that can be done there.  My guess is threaded interrupt
handlers should be handled the same way any other thread is handled
during cpu hot-unplug.  And if something needs to be done I expect the
generic code can do it.

Eric
