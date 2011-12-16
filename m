Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305Ab1LPKva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 05:51:30 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47926 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758949Ab1LPKvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 05:51:10 -0500
Date: Fri, 16 Dec 2011 10:51:01 +0000
From: Will Deacon <will.deacon@arm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: IRQ migration on CPU offline path
Message-ID: <20111216105101.GB30477@mudshark.cambridge.arm.com>
References: <20111214183446.GB12703@mudshark.cambridge.arm.com>
 <m1bora8w3k.fsf@fess.ebiederm.org>
 <20111215162824.GM15131@mudshark.cambridge.arm.com>
 <m1bor95bop.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1bor95bop.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 05:26:46AM +0000, Eric W. Biederman wrote:
> > Argh, ok. Does this mean that other architectures should just preserve the
> > interface that x86 gives (for example not triggering IRQ affinity
> > notifiers)?
> 
> Interesting.  In this case the affinity notifier is an ugly hack for
> exactly one driver.  The affinity notifier is new (This January) and
> buggy.  Among other things there appears to be a clear reference count
> leak on the affinity notify structure. 
> 
> Honestly I don't see much to justify the existence of the affinity
> notifiers, and especially their requirement that they be called in
> process context.

One case I could see (ok, I'm clutching slightly at straws here) is for
modules that want to control the affinity of an IRQ that they are
controlling. irq_set_affinity is not an exported symbol, so they could use
irq_set_affinity_hint to try and stop userspace daemons from messing with
them and use notifiers to keep track of what they ended up with.

> At a practical level since the architects of the affinity notifier
> didn't choose to add notification on migration I don't see why
> you should care.

Suits me :)

> This isn't an x86 versus the rest of the world.  This is a 
> Solarflare driver vs the rest of the kernel issue.  When the Solarflar
> developers care they can fix up arm and all of the rest of the
> architectures that support cpu hot unplug.

Sure, I just think that whatever we do, it should be consistent across
archs, even if it's a driver that is to blame.

> As for threaded interrupt handlers there is probably something
> reasonable that can be done there.  My guess is threaded interrupt
> handlers should be handled the same way any other thread is handled
> during cpu hot-unplug.  And if something needs to be done I expect the
> generic code can do it.

My first thoughts were that we needed to call irq_set_thread_affinity to set
the IRQTF_AFFINITY bit in the threaD_flags, but actually looking at
irq_thread_check_affinity, I think you're right. The scheduler will deal
with this for us when it migrates kernel threads off the dying CPU.

So the conclusion is: ignore the IRQ affinity notifiers, update the affinity
mask in the irq_data and let the scheduler do the rest.

Thanks for the help!

Will
