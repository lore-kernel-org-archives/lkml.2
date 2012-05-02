Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab2EBUYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 16:24:50 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:51861 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407Ab2EBUYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 16:24:48 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Don Zickus <dzickus@redhat.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>, "x86\@kernel.org" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kexec-list <kexec@lists.infradead.org>,
        Vivek Goyal <vgoyal@redhat.com>
References: <1330546129-4812-1-git-send-email-dzickus@redhat.com>
	<20120315202652.GA13930@redhat.com>
	<5C4C569E8A4B9B42A84A977CF070A35B2E31C6F859@USINDEVS01.corp.hds.com>
	<20120430205354.GA32472@redhat.com>
	<5C4C569E8A4B9B42A84A977CF070A35B2E4D461583@USINDEVS01.corp.hds.com>
	<87vckemkyt.fsf@xmission.com> <20120502195919.GU32472@redhat.com>
Date: Wed, 02 May 2012 13:24:35 -0700
In-Reply-To: <20120502195919.GU32472@redhat.com> (Don Zickus's message of
	"Wed, 2 May 2012 15:59:19 -0400")
Message-ID: <8762cel4ak.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+Zbc+AC4IffHxsBUrMxxr1DFfaeBAYFIg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Don Zickus <dzickus@redhat.com>
X-Spam-Relay-Country: **
Subject: Re: [PATCH] x86, kdump: No need to disable ioapic in crash path
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don Zickus <dzickus@redhat.com> writes:

> On Wed, May 02, 2012 at 12:39:06PM -0700, Eric W. Biederman wrote:
>> Seiji Aguchi <seiji.aguchi@hds.com> writes:
>> 
>> >> Perhaps calling setup_IO_APIC before setup_local_APIC would be a better fix?
>> >
>> > I checked Intel develper's manual and there is no restriction about the order of enabling IO_APIC/local_APIC.
>> > So, it may work.
>> >
>> > But, I don't understand why we have to change the stable boot-up code.
>> 
>> Because the boot-up code is buggy.  We need to get a better handle on
>> how it is buggy but apparently an interrupt coming in at the wrong
>> moment while booting with interrupts on the interrupt flag on the cpus
>> disalbed puts us in a state where we fail to boot.
>> 
>> We should be able to boot with apics enabled, and we almost can
>> emperically there are a few bugs.
>> 
>> The kdump path is particularly good at finding bugs.
>> 
>> > If kdump disables both local_apic and IO_APIC in proper way in 1st kernel,  2nd kernel works without any change.
>> 
>> We can not guarnatee disabling the local apics in the first kernel.
>> 
>> Ultimately the less we do in the first kernel the more reliable kdump is
>> going to be.  Disabling the apics has been a long standing bug work
>> around.
>> 
>> At worst we may have been a smidge premature in using assuming the
>> kernel can boot with the apics enabled but it I would hope we can
>> track down and fix the boot up code.
>> 
>> Probably what we want to do is not to disable the I/O apics but
>> to program the I/O apics before we enable the local apic so that
>> we have control of the in-comming interrupts.  But I haven't
>> looked at this in nearly enough detail to even guess what needs
>> to happen.
>
> Hi Eric,
>
> Thanks for the info.  I have don't have a problem with what you say above,
> I think that is a noble effort worth pursuing.  From a high level
> perspective, I am trying to understand how that is supposed to be
> acheived.  Getting the code to match the theory is probably easier to do
> than throw random patches/hacks at various kdump problems as they
> arise.

The very basic theory is:

--- Prepare to handle a crash (load kdump kernel etc)

panic.
locally disable interrupts
do things that can only be done in the panicing kernel
jump to purgatory

It is pretty clear from Peter Anvin's comments that we can perform a
generic nmi disable in the panicing kernel just by disabling nmi's
handling in the local apic.  We need to confirm that but it sounds
like a single write.

We shoot down other cpus in a best effort in the crashing kernel because
that is the only way we can possibly get their cpu registers.

> (this leaves apics and virt stuff untouched?)

We have to disable virt stuff because you can't change cpu modes with
virt stuff enabled (trying causes faults).  But disabling the virt stuff
is just a register write.

> 2nd kernel:
>
> normal early boot stuff
> setup memory
> setup scheduler
> ...
> program ioapic/lapic??
>    #currently this is down _after_ boot cpu interrupts are enabled
>    #which seem problematic if you have leftover screaming interrupts
>    #probably a reason for this like timers or something

Yes, we need to figure out how to deal with screaming interrupts in
this stage.  I have not long ago disabled msi interrupts at pci bus
scan time for a similar reason.  The msi interrupts I encountered were
not technically screaming but I did encounter one that was firing ever
couple of microseconds which is effectively the same as screaming.

Basically I don't particularly care how we do this so long as the
screamming or rapid fire interrupts don't stop the boot.

> enable boot cpu interrupts
> setup boot cpu
> setup other cpus
> ....

Eric

