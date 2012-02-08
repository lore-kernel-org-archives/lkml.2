Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab2BHWwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 17:52:30 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:56189 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145Ab2BHWw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 17:52:29 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Don Zickus <dzickus@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        kexec-list <kexec@lists.infradead.org>
Subject: Re: [PATCH] x86, kdump: No need to disable ioapic in crash path
References: <1328206323-25580-1-git-send-email-dzickus@redhat.com>
	<m1r4ycsts1.fsf@fess.ebiederm.org> <20120207215741.GD5650@redhat.com>
	<20120207221924.GH6346@redhat.com> <m1r4y6i5cw.fsf@fess.ebiederm.org>
	<20120208201145.GX5650@redhat.com>
Date: Wed, 08 Feb 2012 14:55:14 -0800
In-Reply-To: <20120208201145.GX5650@redhat.com> (Don Zickus's message of "Wed,
	8 Feb 2012 15:11:45 -0500")
Message-ID: <m1sjilc4vh.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19ukrf1yAd8bUUQHkB6fv6IR15QrlxwIkc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don Zickus <dzickus@redhat.com> writes:

> On Tue, Feb 07, 2012 at 03:35:59PM -0800, Eric W. Biederman wrote:
>> Vivek Goyal <vgoyal@redhat.com> writes:
>> 
>> > On Tue, Feb 07, 2012 at 04:57:41PM -0500, Don Zickus wrote:
>> >> On Thu, Feb 02, 2012 at 03:24:46PM -0800, Eric W. Biederman wrote:
>> >> > > Eric, brought up a point that because the boot code was restructured we may
>> >> > > not need to disable the io apic any more in the crash path.  The original
>> >> > > concern that led to the development of disable_IO_APIC, was that the TSC
>> >> > > calibration on boot up relied on the PIT timer for reference.  Access
>> >> > > to the PIT required 8259 interrupts to be working.  This wouldn't work
>> >> > > if the ioapic needed to be configured.  So on panic path, the ioapic was
>> >> > > reconfigured to use virtual wire mode to allow the 8259 to passthrough.
>> >> > 
>> >> > A small clarification originally it was the jiffies calibration that
>> >> > would fail if we could cause the PIT to generate interrupts through the
>> >> > 8259.  The boot would then hang at calibrating jiffies.
>> >> 
>> >> Ok.  Thanks!
>> >
>> > So now what has changed? Do we setup LAPIC and IOAPIC early enough to
>> > receive PIT interrupts in regular mode (non-virtual wire mode) or
>> > something else?
>> 
>> Yes.  Part of the Moorstown work required that this be done because
>> moorsetown did not support legacy mode.  Last I looked the code hadn't
>> been generalized beyond Moorsetown but empirically it works now.
>> 
>> Don as to what to test the only case I can think of that might be spooky
>> is a screaming interrupt during the handover.  You might want to try
>> playing with lkcdtm to try some of the more exotic crash scenarios.  But
>> all I expect further testing might reveal are places where we are not
>> as robust in initializing the hardware as we might be.  Things that
>> might have been papered over by the ioapic shutdown.
>
> I ran lkdtm by panic'ing in the interrupt handle thus leaving device
> interrupt un-ack'd and the apic might have been un-ack'd too (jprobes
> hooked in at do_IRQ).  3 out 3 times the second kernel came up on my core2
> quad.

That sounds like more than enough basic testing for me.  Document your
testing in a patch description and let's get the unnecessary local apic
and ioapic stomping removed from the kexec on panic path.

There were bugs.  We deleted the code that had them.  The bugs are gone
and there are no new problems goes over very well in my book.

Eric

