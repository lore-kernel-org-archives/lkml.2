Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758989Ab2BOLBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 06:01:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399Ab2BOLBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 06:01:35 -0500
Date: Wed, 15 Feb 2012 16:31:22 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>
Subject: Re: vsyscall=emulate regression
Message-ID: <20120215110122.GA3136@amit.redhat.com>
References: <20120203082748.GB782@amit.redhat.com>
 <20120214122205.GA29418@amit.redhat.com>
 <CALCETrVCzErebXrVk8Bi+k1TjigD3XvJsmZFVZb=ksmSCOTVLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrVCzErebXrVk8Bi+k1TjigD3XvJsmZFVZb=ksmSCOTVLg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) 14 Feb 2012 [08:26:22], Andy Lutomirski wrote:
> On Tue, Feb 14, 2012 at 4:22 AM, Amit Shah <amit.shah@redhat.com> wrote:
> > On (Fri) 03 Feb 2012 [13:57:48], Amit Shah wrote:
> >> Hello,
> >>
> >> I'm booting some latest kernels on a Fedora 11 (released June 2009)
> >> guest.  After the recent change of default to vsyscall=emulate, the
> >> guest fails to boot (init segfaults).
> >>
> >> I also tried vsyscall=none, as suggested by hpa, and that fails as
> >> well.  Only vsyscall=native works fine.
> >>
> >> The commit that introduced the kernel parameter,
> >>
> >> 3ae36655b97a03fa1decf72f04078ef945647c1a
> >>
> >> is bad too.
> >
> > I suggest we revert 2e57ae0515124af45dd889bfbd4840fd40fcc07d till we
> > track down and fix the vsyscal=emulate case.
> 
> Hi-
> 
> Sorry, I lost track of this one.  I can't reproduce it, although I
> doubt I've set up the right test environment.  But this is fishy:
> 
> init[1]: segfault at ffffffffff600400 ip ffffffffff600400 sp
> 00007fff9c8ba098 error 5
> 
> Error 5, if I'm decoding it correctly, is a userspace read (i.e. not
> execute) fault.  The vsyscall emulation changes shouldn't have had any
> effect on reads there.
> 
> Can you try booting the initramfs here:
> http://web.mit.edu/luto/www/linux/vsyscall_initramfs.img
> with your kernel image (i.e. qemu-kvm -kernel <whatever> -initrd
> vsyscall_initramfs.img -whatever_else) and seeing what happens?  It
> works for me.

This too results in a similar error.

> I'm also curious what happens if you run without kvm (i.e. straight
> qemu)

Interesting; without kvm, this does work fine.

> and what your .config on the guest kernel is.  It sounds like
> something's wrong with your fixmap, which makes me wonder if your
> qemu/kernel combo is capable of booting even a modern distro
> (up-to-date F16, say) -- the vvar page uses identical fixmap flags as
> the vsyscall page in vsyscall=emulate and vsyscall=none mode.

I didn't try a modern distro, but looks like this is enough evidence
for now to check the kvm emulator code.  I tried the same guests on a
newer kernel (Fedora 16's 3.2), and things worked fine except for
vsyscall=none, panic message below.

> What host cpu are you on and what qemu flags do you use?

$ cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Duo CPU     E6550  @ 2.33GHz
stepping        : 11
cpu MHz         : 2000.000
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm lahf_lm dts tpr_shadow vnmi flexpriority
bogomips        : 4654.73
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

>  Maybe
> something is wrong with your emulator.

Yes, looks like it.  Thanks!

This is what I get with vsyscall=none, where emulate and native work
fine on the 3.2 kernel on different host hardware, the guest stays the
same:


[    2.874661] debug: unmapping init memory ffffffff8167f000..ffffffff818dc000
[    2.876778] Write protecting the kernel read-only data: 6144k
[    2.879111] debug: unmapping init memory ffff880001318000..ffff880001400000
[    2.881242] debug: unmapping init memory ffff8800015a0000..ffff880001600000
[    2.884637] init[1] vsyscall attempted with vsyscall=none ip:ffffffffff600400 cs:33 sp:7fff2f48fe18 ax:7fff2f48fe50 si:7fff2f48ff08 di:0
[    2.888078] init[1]: segfault at ffffffffff600400 ip ffffffffff600400 sp 00007fff2f48fe18 error 15
[    2.888193] Refined TSC clocksource calibration: 2691.293 MHz.
[    2.892748] 
[    2.895219] Kernel panic - not syncing: Attempted to kill init!


		Amit
