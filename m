Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab1KWKjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 05:39:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884Ab1KWKjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 05:39:15 -0500
Date: Wed, 23 Nov 2011 16:08:52 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Miche Baker-Harvey <miche@google.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Greg Kroah-Hartman <gregkh@suse.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Anton Blanchard <anton@samba.org>, Mike Waychison <mikew@google.com>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Eric Northrup <digitaleric@google.com>
Subject: Re: [PATCH v3 2/3] hvc_init(): Enforce one-time initialization.
Message-ID: <20111123103852.GG16665@amit-x200.redhat.com>
References: <20111108214452.28884.14840.stgit@miche.sea.corp.google.com>
 <20111108214504.28884.61814.stgit@miche.sea.corp.google.com>
 <874nybqo0o.fsf@rustcorp.com.au>
 <CAB8RdapbaueyWLJuJDE_ZdvLkRNM4sQHTxgmgO=jrnXZ6YPSmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAB8RdapbaueyWLJuJDE_ZdvLkRNM4sQHTxgmgO=jrnXZ6YPSmA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Thu) 17 Nov 2011 [10:57:37], Miche Baker-Harvey wrote:
> Rusty, Michael, Stephen, et al,
> 
> Thanks for your comments on these patches.
> 
> For what I'm trying to do, all three patches are necessary, but maybe
> I'm going about it the wrong way. Your input would be appreciated.
> I'm in no way claiming that these patches are "right", just that it's
> working for me, and that what's in the current pool is not.
> 
> What I'm trying to do is:
> On X86,
> under KVM,
> start a virtio console device,
> with multiple ports on the device,
> at least one of which is also a console (as well as ttyS0).
> 
> (Eventually, we want to be able to add virtio console ports on the
> fly, and to have multiple virtio console ports be consoles.)

Are you using kvm-tool to do this?  QEMU can already hot-plug ports
and virtio-console (virtio-serial) devices.

> When all three of the patches are in place, this works great. (By
> great, I mean that getty's start up on all of ttyS0, hvc0 and hvc1,
> and console output goes to ttyS0 and to hvc0.
> "who" shows three users:  ttyS0, hvc0, and hvc1.
> "cat /proc/consoles" shows both ttyS0 and hvc0.
> I can use all three getty's, and console output really does appear on
> both the consoles.
> 
> Based on Rusty's comments, I tried removing each of the patches
> individually. Here's what happens today. I've seen other failure modes
> depending on what precisely I'm passing the guest.
> There's three patches:
> 1/3 "fix locking of vtermno"
> 2/3 "enforce one-time initialization with hvc_init
> "3/3 "use separate struct console * for each console"
> 
> If I remove the "fix locking of vtermno", I only get one virtio
> console terminal.  "who" shows the ttyS0 and the hvc0, and I can log
> into the gettys on both. I don't get the second virtio console getty.
> Interestingly, hvc0 shows up in /proc/consoles twice, and in fact the
> console output is dumped twice to hvc0 (as you'd expect from looking
> at printk.c, each line appears twice, followed by the next line.)

I don't really understand why.  "fix locking of vtermno" adds locks in
init_port_console(), which is called from add_port(), which should be
serialised due to port additions being on work items on the same
workqueue.  I don't see a race here.

> If I remove the "enforce one-time initialization with hvc_init" patch,
> which makes sure only a single thread is doing the hvc_init, and gates
> anyone from continuing until it has completed, I get different
> failures, including hangs, and dereferences of NULL pointers.
> 
> If I remove the "use separate struct console * for each console"patch,
> what I'm seeing now is that while all of ttyS0, hvc0, and hvc1 are
> present with gettys running on them, of the three, only ttyS0 is a
> console.

I don't see any difference in my testing with and without these
patches.

This is how I tested with qemu:

./x86_64-softmmu/qemu-system-x86_64 -m 512 -smp 2 -chardev
socket,path=/tmp/foo,server,nowait,id=foo -chardev
socket,path=/tmp/bar,server,nowait,id=bar -device virtio-serial
-device virtconsole,chardev=foo,nr=4 -device
virtconsole,chardev=bar,nr=3 -net none  -kernel
/home/amit/src/linux/arch/x86/boot/bzImage -append 'root=/dev/sda1
console=tty0 console=ttyS0' -initrd /tmp/initramfs.img
/guests/f14-nolvm.qcow2 -enable-kvm -snapshot

With this setup, with and without patches, I can spawn two consoles
via:

/sbin/agetty /dev/hvc0 9600 vt100
/sbin/agetty /dev/hvc1 9600 vt100

(Strange thing is, the second one gives a 'password incorrect' error
on login attempts, while the first one logs in fine.  I do remember
testing multiple consoles just fine a year and a half back, so no idea
why this isn't behaving as expected -- but it mostly looks like a
userspace issue rather than kernel one.)

As mentioned earlier, I've not looked at the hvc code, but given my
testing results, I'd like to first understand what you're seeing and
what your environment is.

		Amit
