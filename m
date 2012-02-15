Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab2BOTgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:36:24 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51663 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972Ab2BOTgX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:36:23 -0500
MIME-Version: 1.0
In-Reply-To: <20120215110122.GA3136@amit.redhat.com>
References: <20120203082748.GB782@amit.redhat.com> <20120214122205.GA29418@amit.redhat.com>
 <CALCETrVCzErebXrVk8Bi+k1TjigD3XvJsmZFVZb=ksmSCOTVLg@mail.gmail.com> <20120215110122.GA3136@amit.redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 15 Feb 2012 11:36:02 -0800
Message-ID: <CALCETrUmk+kpG9qLqSfrMP8Go9affMJCgybHFoK7Z2wm7ABXpA@mail.gmail.com>
Subject: [KVM paravirt issue?] Re: vsyscall=emulate regression
To: Amit Shah <amit.shah@redhat.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, kvm people-

Here's a strange failure.  It could be a bug in something
RHEL6-specific, but it could be a generic issue that only triggers
with a paravirt guest with old userspace on a non-ept host.  There was
a bug like this on Xen, and I'm wondering something's wrong on kvm as
well.

For background, a change in 3.1 (IIRC) means that, when
vsyscall=emulate or vsyscall=none, the vsyscall page in the fixmap is
NX.  It seems like Amit's machine is marking the physical PTE present
but unreadable.  So I could have messed up, or there could be a subtle
bug somewhere.  Any ideas?

I'll try to reproduce on a non-ept host later on, but that will
involve finding one.

On Wed, Feb 15, 2012 at 3:01 AM, Amit Shah <amit.shah@redhat.com> wrote:
> On (Tue) 14 Feb 2012 [08:26:22], Andy Lutomirski wrote:
>> On Tue, Feb 14, 2012 at 4:22 AM, Amit Shah <amit.shah@redhat.com> wrote:
>> Can you try booting the initramfs here:
>> http://web.mit.edu/luto/www/linux/vsyscall_initramfs.img
>> with your kernel image (i.e. qemu-kvm -kernel <whatever> -initrd
>> vsyscall_initramfs.img -whatever_else) and seeing what happens?  It
>> works for me.
>
> This too results in a similar error.

Can you post the exact error?  I'm interested in how far it gets
before it fails.

> I didn't try a modern distro, but looks like this is enough evidence
> for now to check the kvm emulator code.  I tried the same guests on a
> newer kernel (Fedora 16's 3.2), and things worked fine except for
> vsyscall=none, panic message below.

vsyscall=none isn't supposed to work unless you're running a very
modern distro *and* you have no legacy static binaries *and* you
aren't using anything written in Go (sigh).  It will probably either
never become the default or will take 5-10 years.


> model name      : Intel(R) Core(TM)2 Duo CPU     E6550  @ 2.33GHz
> flags           : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm lahf_lm dts tpr_shadow vnmi flexpriority

Hmm.  You don't have ept.  If your guest kernel supports paravirt,
then you might use the hypercall interface instead of programming the
fixmap directly.

>
> This is what I get with vsyscall=none, where emulate and native work
> fine on the 3.2 kernel on different host hardware, the guest stays the
> same:
>
>
> [    2.874661] debug: unmapping init memory ffffffff8167f000..ffffffff818dc000
> [    2.876778] Write protecting the kernel read-only data: 6144k
> [    2.879111] debug: unmapping init memory ffff880001318000..ffff880001400000
> [    2.881242] debug: unmapping init memory ffff8800015a0000..ffff880001600000
> [    2.884637] init[1] vsyscall attempted with vsyscall=none ip:ffffffffff600400 cs:33 sp:7fff2f48fe18 ax:7fff2f48fe50 si:7fff2f48ff08 di:0

This like (vsyscall attempted) means that the emulation worked
correctly.  Your other traces didn't have it or anything like it,
which mostly rules out do_emulate_vsyscall issues.

--Andy
