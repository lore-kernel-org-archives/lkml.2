Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab2BBBbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 20:31:24 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:43241 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab2BBBbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 20:31:23 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, vgoyal@redhat.com,
        kexec-list <kexec@lists.infradead.org>
Subject: Re: [PATCH] x86, kdump, ioapic: Fix kdump race with migrating irq
References: <1328045114-4489-1-git-send-email-dzickus@redhat.com>
	<m1ipjr4jaa.fsf@fess.ebiederm.org> <20120131222751.GE5650@redhat.com>
	<m1vcnr33c8.fsf@fess.ebiederm.org> <20120201230414.GL5650@redhat.com>
Date: Wed, 01 Feb 2012 17:34:01 -0800
In-Reply-To: <20120201230414.GL5650@redhat.com> (Don Zickus's message of "Wed,
	1 Feb 2012 18:04:14 -0500")
Message-ID: <m1ehuevx12.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19kmI9C5+5N/g5NO7rY52byUKqVne/7SbE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don Zickus <dzickus@redhat.com> writes:

> On Tue, Jan 31, 2012 at 02:38:15PM -0800, Eric W. Biederman wrote:
>> Don Zickus <dzickus@redhat.com> writes:
>> 
>> > On Tue, Jan 31, 2012 at 02:08:29PM -0800, Eric W. Biederman wrote:
>> >> > The problem is that although kdump tries to shutdown minimal hardware,
>> >> > it still needs to disable the IO APIC.  This requires spinlocks which
>> >> > may be held by another cpu.  This other cpu is being held infinitely in
>> >> > an NMI context by kdump in order to serialize the crashing path.  Instant
>> >> > deadlock.
>> >> 
>> >> Can you test to see if kexec on panic still needs to disable the IO
>> >> APIC.  Last I looked we were close if not all of the way there to not
>> >> needing to boot the kernel in pic mode?
>> >
>> > Ok, so you just blindly remove disable_IO_APIC from
>> > native_machine_crash_shutdown and re-run some panic tests on various
>> > machines?  What about the disable_IO_APIC path in native_machine_shutdown?
>> >
>> 
>> Yes.  Just native_machine_crash_shutdown.
>> 
>> native_machine_shutdown is the case when all is good and we attempt to
>> put the hardware back the way we found it.
>
> Ok.
>
>> 
>> Any normal x86 machine that the kernel runs in ioapic mode should be
>> enough to get a first approximation.
>> 
>> > Also, where could I look to see if that work was done?  Is that in the
>> > ioapic setup code?
>> 
>> The primary question is do we call the ioapic setup code without calling
>> the pic setup code first.  On some embedded x86 platforms we certainly
>> do.  I don't know if that code has been generalized.
>> 
>> Historically the problem is that we started the pit timer in pic mode
>> and used that to calibrate the delay loop.
>> 
>> So what we are looking to verify is that the linux kernel boot skip
>> pic mode entirely.
>
> It seems to boot fine on an Ivy Bridge machine and a single cpu Pentium4.
> I will try and athlon3 and a nehalem tomorrow.
>
> Talking to folks here and trying to read the code it seems like the PIT
> stuff is delayed until after the IOAPIC is configured using Fast TSC
> calibration as a mechanism to work around the PIT??
>
> I attached the output of the Pentium4 when kdumping.  Not sure what to
> really look for to verify the PIC is being skipped.  Perhaps you know?

The important part is the kexec on panic works without shutting down
the ioapic.  There should be no corner case issues it should either
work it should fail.

The problem used to be that we always would initialize the PIT interrupt
in the 8259 interrupt controller before we would initialize the ioapics
and that would kill the boot.

If I have read your testing correctly you are apparently booting in the
kexec on panic case.  That seems to be successful to me.  So we should
be able to just remove the ioapic shutdown code from
machine_crash_shutdown as it is no longer needed.

Thank you for being careful and testing on a number of different
platforms. 

The only case I can think that won't work without ioapic disables
is using a crash kernel that doesn't emable the ioapics.

Eric
