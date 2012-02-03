Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab2BCRdW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 12:33:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756877Ab2BCRdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 12:33:21 -0500
Date: Fri, 3 Feb 2012 23:02:56 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: vsyscall=emulate regression
Message-ID: <20120203173256.GB12054@amit.redhat.com>
References: <20120203082748.GB782@amit.redhat.com>
 <CALCETrUpXNkUSGh59+dy=+ocy2=J7G7=nXs4L1girsWFZVGC9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrUpXNkUSGh59+dy=+ocy2=J7G7=nXs4L1girsWFZVGC9g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On (Fri) 03 Feb 2012 [07:30:55], Andy Lutomirski wrote:
> On Fri, Feb 3, 2012 at 12:27 AM, Amit Shah <amit.shah@redhat.com> wrote:
> > Hello,
> >
> > I'm booting some latest kernels on a Fedora 11 (released June 2009)
> > guest.  After the recent change of default to vsyscall=emulate, the
> > guest fails to boot (init segfaults).
> 
> Which kernel is the host running

Host is a RHEL6 kernel, 2.6.32-217.el6.x86_64

> and which kernel is the guest
> running? And which kernel has the vsyscall=emulate parameter?

The host stays the same; I'm only using the x86-64 F11 guest with
newer kernel versions.  I compile the kernels on the host, and use
qemu's -kernel parameter so the guest boots off that kernel.

Only the guest gets the vsyscall= parameters.

>  If
> vsyscall=emulate is a problem on a pre-3.3 kernel, can you try
> something containing commit 4fc3490114bb159bd4fff1b3c96f4320fe6fb08f?
> (UML, for example, is known to have serious issues without that fix.)

I've tried all kernels v3.0 to v3.3-git.  From the commit that
introduced the vsyscall=emulate parameter, using 'emulate' has failed
to boot this guest.  I only noticed it recently when it was made the
default.

> Otherwise, can you tell me what hypervisor you're using

Sorry, I'm using kvm.  qemu is also from RHEL6,
qemu-kvm-0.12.1.2-2.209.el6.x86_64, but even upstream qemu.git makes
init fail similarly.

> and what init
> version (i.e. the rpm) so I can try to reproduce it?

upstart-0.6.5-10.el6.x86_64

>  A pointer to an
> actual image would work, too.

It's mostly a stock F11 install, so fetching the iso and installing it
locally, and using a command line similar to:

qemu-kvm -snapshot -kernel ~/src/linux/arch/x86/boot/bzImage
/guests/f11-auto.qcow2 -serial stdio -append 'console=tty0
console=ttyS0 root=/dev/sda2 vsyscall=emulate'

will work.

>  A copy of the oops would also be nice.

There's not much, but here it is anyway:

EXT4-fs (sda2): couldn't mount as ext3 due to feature incompatibilities
EXT4-fs (sda2): couldn't mount as ext2 due to feature incompatibilities
EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
VFS: Mounted root (ext4 filesystem) readonly on device 8:2.
debug: unmapping init memory ffffffff8167f000..ffffffff818e1000
Write protecting the kernel read-only data: 6144k
debug: unmapping init memory ffff8800012fe000..ffff880001400000
debug: unmapping init memory ffff880001584000..ffff880001600000
init[1]: segfault at ffffffffff600400 ip ffffffffff600400 sp 00007fff103d72f8 error 5
Kernel panic - not syncing: Attempted to kill init!


That's with current git snapshot.  With the commit that introduced
vsyscal= I had gotten this:

EXT4-fs (sda2): couldn't mount as ext3 due to feature incompatibilities
EXT4-fs (sda2): couldn't mount as ext2 due to feature incompatibilities
EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
VFS: Mounted root (ext4 filesystem) readonly on device 8:2.
debug: unmapping init memory ffffffff81679000..ffffffff818db000
Write protecting the kernel read-only data: 6144k
debug: unmapping init memory ffff8800012e6000..ffff880001400000
debug: unmapping init memory ffff880001579000..ffff880001600000
init[1]: segfault at ffffffffff600400 ip ffffffffff600400 sp 00007fff9c8ba098 error 5
Kernel panic - not syncing: Attempted to kill init!
Pid: 1, comm: init Not tainted 3.0.0+ #189
Call Trace:
 [<ffffffff812de4e9>] panic+0x9b/0x1a2
 [<ffffffff8102ba99>] ? get_parent_ip+0x11/0x41
 [<ffffffff81039ff6>] do_exit+0xb0/0x6f0
 [<ffffffff8103a6bf>] do_group_exit+0x89/0xb7
 [<ffffffff81048ffa>] get_signal_to_deliver+0x419/0x438
 [<ffffffff810016dd>] do_signal+0x72/0x5e4
 [<ffffffff8101e827>] ? do_page_fault+0x177/0x338
 [<ffffffff812de631>] ? printk+0x41/0x48
 [<ffffffff810dd93d>] ? discard_slab+0x3e/0x40
 [<ffffffff810dea12>] ? __slab_free+0x13a/0x145
 [<ffffffff810ef4fd>] ? putname+0x32/0x3b
 [<ffffffff810ef4fd>] ? putname+0x32/0x3b
 [<ffffffff810df179>] ? kmem_cache_free+0x7d/0xce
 [<ffffffff812e1adf>] ? retint_signal+0x11/0x92
 [<ffffffff81001c69>] do_notify_resume+0x1a/0x37
 [<ffffffff812e1b1b>] retint_signal+0x4d/0x92


		Amit
