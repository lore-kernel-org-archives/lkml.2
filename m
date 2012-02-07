Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061Ab2BGWJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 17:09:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756744Ab2BGWJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 17:09:48 -0500
Date: Tue, 7 Feb 2012 16:57:41 -0500
From: Don Zickus <dzickus@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        kexec-list <kexec@lists.infradead.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] x86, kdump: No need to disable ioapic in crash path
Message-ID: <20120207215741.GD5650@redhat.com>
References: <1328206323-25580-1-git-send-email-dzickus@redhat.com>
 <m1r4ycsts1.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1r4ycsts1.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 03:24:46PM -0800, Eric W. Biederman wrote:
> > Eric, brought up a point that because the boot code was restructured we may
> > not need to disable the io apic any more in the crash path.  The original
> > concern that led to the development of disable_IO_APIC, was that the TSC
> > calibration on boot up relied on the PIT timer for reference.  Access
> > to the PIT required 8259 interrupts to be working.  This wouldn't work
> > if the ioapic needed to be configured.  So on panic path, the ioapic was
> > reconfigured to use virtual wire mode to allow the 8259 to passthrough.
> 
> A small clarification originally it was the jiffies calibration that
> would fail if we could cause the PIT to generate interrupts through the
> 8259.  The boot would then hang at calibrating jiffies.

Ok.  Thanks!

> 
> > Those concerns don't hold true now, thanks to the fast TSC calibration code
> > not needing the PIT.  As a result, we can remove this call and simplify the
> > locking needed in the panic path.
> >
> > I tested kdump on an Ivy Bridge platform, a Pentium4 and an old athlon that
> > did not have an ioapic.  All three were successful.
> >
> > Cc: Eric W. Biederman <ebiederm@xmission.com>
> > Cc: Vivek Goyal <vgoyal@redhat.com>
> > Signed-off-by: Don Zickus <dzickus@redhat.com>
> >
> > ---
> > I will probably need some help with my explaination as to why this line is not
> > needed.  Any input is appreciated!
> 
> Can you test and verify that we also do not need the lapic_shutdown()
> call and the disable_local_APIC call on the other processors.  The same
> reasoning that supports us not needing to disable the IO_APIC also
> supports us not needing to disable local apic.

I did that and it seemed to work on my Ivy Bridge and core2 quad systems.

> 
> Removing disable_IO_APIC in and of itself and then booting isn't quite
> sufficient as a practical test to prove this code always works.
> Sometimes the IOAPIC was not hooked up to interesting interrupt sources
> like the 8259.

So what systems should I look for to test?

Cheers,
Don
