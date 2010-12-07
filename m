Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab0LGVAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 16:00:40 -0500
Received: from lo.gmane.org ([80.91.229.12]:35370 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015Ab0LGVAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 16:00:39 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Russ Dill <Russ.Dill@gmail.com>
Subject: Re: [PATCH 10/19] =?utf-8?b?dHR5X2xkaXNjOg==?= Fix BUG() on hangup
Date: Tue, 7 Dec 2010 21:00:25 +0000 (UTC)
Message-ID: <loom.20101207T215255-187@post.gmane.org>
References: <20101112213215.GB9294@kroah.com> <1289598066-10112-10-git-send-email-gregkh@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 63.226.32.16 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.12) Gecko/20101026 Firefox/3.6.12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman <gregkh <at> suse.de> writes:

> 
> From: Philippe Rétornaz <philippe.retornaz <at> epfl.ch>
> 
> A kernel BUG when bluetooth rfcomm connection drop while the associated
> serial port is open is sometime triggered.
> 
> It seems that the line discipline can disappear between the
> tty_ldisc_put and tty_ldisc_get. This patch fall back to the N_TTY line
> discipline if the previous discipline is not available anymore.
> 
> Signed-off-by: Philippe Retornaz <philippe.retornaz <at> epfl.ch>
> Acked-by: Alan Cox <alan <at> linux.intel.com>
> Cc: stable <stable <at> kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh <at> suse.de>

I think I've run into this issue with a pl2303 adapter on device removal
with v2.6.32.15:

[  134.572454] ------------[ cut here ]------------
[  134.576038] kernel BUG at drivers/char/tty_ldisc.c:707!
[  134.576038] invalid opcode: 0000 [#1] SMP 
[  134.576038] last sysfs file:
/sys/devices/pci0000:00/0000:00:1d.7/usb1/1-6/1-6:1.0/host2/target2:0:0/
2:0:0:0/block/sdb/ro
[  134.576038] Modules linked in: -----
[  134.576038] 
[  134.576038] Pid: 268, comm: khubd Not tainted (2.6.32.15-1 #1)
Catalyst
[  134.576038] EIP: 0060:[<c122323e>] EFLAGS: 00010202 CPU: 0
[  134.576038] EIP is at tty_ldisc_reinit+0x3e/0x50
[  134.576038] EAX: ffffffea EBX: f660e000 ECX: f6b28210 EDX: 00000001
[  134.576038] ESI: 0000006e EDI: f660e000 EBP: f7092d6c ESP: f7092d64
[  134.576038]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  134.576038] Process khubd (pid: 268, ti=f7092000 task=f71330c0
task.ti=f7092000)
[  134.576038] Stack:
[  134.576038]  f660e014 00000000 f7092d84 c12234be 00000001 f660e188
f660e188 f660e000
[  134.576038] <0> f7092db0 c121c291 00000296 00000000 00000000 00000001
00000296 f660e000
[  134.576038] <0> f660e000 f7240800 00000000 f7092db8 c121c4cd f7092de4
c12ee98c 00000002
[  134.576038] Call Trace:
[  134.576038]  [<c12234be>] ? tty_ldisc_hangup+0x1ae/0x1e0
[  134.576038]  [<c121c291>] ? do_tty_hangup+0x111/0x340
[  134.576038]  [<c121c4cd>] ? tty_vhangup+0xd/0x10
[  134.576038]  [<c12ee98c>] ? usb_serial_disconnect+0x8c/0x170
[  134.576038]  [<c12c6831>] ? usb_unbind_interface+0xf1/0x130
[  134.576038]  [<c125b972>] ? __device_release_driver+0x72/0xd0
[  134.576038]  [<c125ba90>] ? device_release_driver+0x20/0x40
[  134.576038]  [<c125ae6c>] ? bus_remove_device+0x7c/0xe0
[  134.576038]  [<c1258c97>] ? device_remove_attrs+0x37/0xb0
[  134.576038]  [<c1258e14>] ? device_del+0x104/0x1a0
[  134.576038]  [<c12c33bc>] ? usb_disable_device+0xbc/0x1f0
[  134.576038]  [<c12bcfa5>] ? usb_disconnect+0xb5/0x1b0
[  134.576038]  [<c12be91f>] ? hub_thread+0x64f/0x17e0
[  134.576038]  [<c103234e>] ? try_to_wake_up+0xbe/0x380
[  134.576038]  [<c104a8d0>] ? autoremove_wake_function+0x0/0x50
[  134.576038]  [<c12be2d0>] ? hub_thread+0x0/0x17e0
[  134.576038]  [<c104a684>] ? kthread+0x74/0x80
[  134.576038]  [<c104a610>] ? kthread+0x0/0x80
[  134.576038]  [<c10039ff>] ? kernel_thread_helper+0x7/0x18
[  134.576038] Code: 34 e8 c7 fe ff ff 89 f0 c7 43 34 00 00 00 00 e8 d9
fc ff ff 3d 00 f0 ff ff 77 10 89 43 34 89 f2 89 d8 e8 b6 fd ff
[  134.576038] EIP: [<c122323e>] tty_ldisc_reinit+0x3e/0x50 SS:ESP
0068:f7092d64
[  134.813426] ---[ end trace dd3cfdb471d33e40 ]---

I'd like to flag this patch for possible stable inclusion.


