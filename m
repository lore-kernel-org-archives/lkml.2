Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613Ab0KDRUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 13:20:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751106Ab0KDRUG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 13:20:06 -0400
MIME-Version: 1.0
In-Reply-To: <201011030356.13878.rjw@sisk.pl>
References: <201010292358.27975.rjw@sisk.pl> <AANLkTikF+8VsxyjmXUc_6Epd923g5DCxneNArFNTGrZ_@mail.gmail.com>
 <201011030356.13878.rjw@sisk.pl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 4 Nov 2010 13:19:17 -0400
Message-ID: <AANLkTin5YPkzw1oX+v3TtZeAkS2S6Q+=+zOxb+3Ug9h3@mail.gmail.com>
Subject: Re: [GIT PULL] One more power management fix for 2.6.37
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 2, 2010 at 10:56 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> Can you boot with initcall_debug and try to suspend, please?  That should tell
> us what device this actually happens to.

Well, I was running with a lot of debugging for a while, and nothing
bad happened over several suspends. So I gave up on it. And then today
I got this one.. Which was followed immedately by a bluez error, which
may or may not be a coincidence.

That said, I guess I haven't historically had bluetooth enabled on
this laptop, and so it's certainly possible that it's some old problem
that I just hadn't seen before. I don't use the laptop very much, and
before the KS summit trip I re-installed the whole system, so I have
no history with this configuration.

Does this trigger any ideas?

The errors do seem to have a pattern: something got zeroed. The NULL
pointer dereference is the "sock->ops->poll()" call, but "sock->ops"
is NULL. And then there's that "VFS: Close: file count is 0" thing -
obviously something got zeroed too early.

The kref_get() warning is also about a variable being surprisingly zero.

So it smells like suspend/resume ends up zeroing some block of memory.
I just don't see why it always would seem to trigger in kref_get(). If
it was some random memory zeroing, I'd expect the result to be more
random, and not hit just that one specific WARN_ON().

                Linus

---
  [ 8652.088706] PM: resume of devices complete after 3268.593 msecs
  [ 8652.104357] ------------[ cut here ]------------
  [ 8652.104368] WARNING: at lib/kref.c:34 kref_get+0x23/0x2c()
  [ 8652.104371] Hardware name: HP Compaq 2510p Notebook PC
  [ 8652.104374] Modules linked in: iwlagn [last unloaded: scsi_wait_scan]
  [ 8652.104382] Pid: 18012, comm: pm-suspend Not tainted
2.6.37-rc1-00027-gff8b16d #14
  [ 8652.104385] Call Trace:
  [ 8652.104395]  [<ffffffff81036082>] warn_slowpath_common+0x80/0x98
  [ 8652.104401]  [<ffffffff810360af>] warn_slowpath_null+0x15/0x17
  [ 8652.104407]  [<ffffffff8120002b>] kref_get+0x23/0x2c
  [ 8652.104412]  [<ffffffff811fee27>] kobject_get+0x1a/0x21
  [ 8652.104418]  [<ffffffff812d84cb>] get_device+0x14/0x1a
  [ 8652.104425]  [<ffffffff812dfce5>] dpm_resume_end+0x230/0x37c
  [ 8652.104432]  [<ffffffff81060a09>] suspend_devices_and_enter+0x158/0x188
  [ 8652.104437]  [<ffffffff81060b04>] enter_state+0xcb/0xcf
  [ 8652.104442]  [<ffffffff810602cf>] state_store+0xa7/0xc6
  [ 8652.104447]  [<ffffffff811fec37>] kobj_attr_store+0x17/0x19
  [ 8652.104453]  [<ffffffff810f75e8>] sysfs_write_file+0xf2/0x12e
  [ 8652.104460]  [<ffffffff810ab9a8>] vfs_write+0xb0/0x12f
  [ 8652.104465]  [<ffffffff810abc04>] sys_write+0x45/0x6c
  [ 8652.104472]  [<ffffffff81001fab>] system_call_fastpath+0x16/0x1b
  [ 8652.104476] ---[ end trace dca322e94d9e9dd5 ]---
  bluetoothd[2862]: HCI dev 0 down
  bluetoothd[2862]: Adapter /org/bluez/2857/hci0 has been disabled
  bluetoothd[2862]: Stopping security manager 0
  bluetoothd[2862]: HCI dev 0 unregistered
  bluetoothd[2862]: Unregister path: /org/bluez/2857/hci0
  bluetoothd[2862]: HCI dev 0 registered
  [ 8652.104877] Restarting tasks ... done.
  [ 8652.119373] video LNXVIDEO:00: Restoring backlight state
  dbus-daemon: [system] Rejected send message, 2 matched rules;
type="error", sender=":1.46" (uid=500 pid=3534 comm="blueto$
  bluetoothd[2862]: HCI dev 0 up
  bluetoothd[2862]: Starting security manager 0
  bluetoothd[2862]: Parsing /etc/bluetooth/serial.conf failed: No such
file or directory
  bluetoothd[2862]: Adapter /org/bluez/2857/hci0 has been enabled
  [ 8652.191020] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000040
  [ 8652.191125] IP: [<ffffffff81457fcb>] sock_poll+0x12/0x17
  [ 8652.191200] PGD 0
  [ 8652.191226] Oops: 0000 [#1] SMP
  [ 8652.191266] last sysfs file: /sys/devices/virtual/dmi/id/chassis_type
  [ 8652.191325] CPU 1
  [ 8652.191348] Modules linked in: iwlagn [last unloaded: scsi_wait_scan]
  [ 8652.191420]
  [ 8652.191441] Pid: 2862, comm: bluetoothd Tainted: G        W
2.6.37-rc1-00027-gff8b16d #14 30C9/HP Compaq 2510p Noteb$
  [ 8652.191550] RIP: 0010:[<ffffffff81457fcb>]  [<ffffffff81457fcb>]
sock_poll+0x12/0x17
  [ 8652.191641] RSP: 0018:ffff8800787c1b38  EFLAGS: 00010246
  [ 8652.191713] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
ffffffff81672390
  [ 8652.191780] RDX: 0000000000000000 RSI: ffff88003dbfc500 RDI:
ffff8800379fc9c0
  [ 8652.191849] RBP: ffff8800787c1b38 R08: 0000000000000000 R09:
0000000000000000
  [ 8652.191922] R10: 0000000000000001 R11: 0000000000000246 R12:
00007ff0d9208910
  [ 8652.191980] R13: ffff8800787c1df8 R14: ffff8800787c1e54 R15:
0000000000000001
  [ 8652.192045] FS:  00007ff0d7a4a720(0000) GS:ffff88007e500000(0000)
knlGS:0000000000000000
  [ 8652.192138] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [ 8652.192198] CR2: 0000000000000040 CR3: 000000007bb8f000 CR4:
00000000000006e0
  [ 8652.192272] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
  [ 8652.192342] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
  [ 8652.192408] Process bluetoothd (pid: 2862, threadinfo
ffff8800787c0000, task ffff88007b89e9b0)
  [ 8652.192488] Stack:
  [ 8652.192512]  ffff8800787c1f38 ffffffff810ba4df ffff8800379fc9c0
0000000000000000
  [ 8652.192610]  ffff88007b89e9b0 ffff8800787c1e84 0000000000000000
0000000000000000
  [ 8652.192696]  0000000000000000 0000000000000000 ffffffff810b95f3
0000000000000019
  [ 8652.192779] Call Trace:
  [ 8652.192806]  [<ffffffff810ba4df>] do_sys_poll+0x23f/0x3d0
  [ 8652.192853]  [<ffffffff810b95f3>] ? __pollwait+0x0/0xc7
  [ 8652.192898]  [<ffffffff810b96ba>] ? pollwake+0x0/0x4f
  [ 8652.192940]  [<ffffffff810b96ba>] ? pollwake+0x0/0x4f
  [ 8652.192982]  [<ffffffff810b96ba>] ? pollwake+0x0/0x4f
  [ 8652.193024]  [<ffffffff810b96ba>] ? pollwake+0x0/0x4f
  [ 8652.193066]  [<ffffffff810b96ba>] ? pollwake+0x0/0x4f
  [ 8652.193108]  [<ffffffff810b96ba>] ? pollwake+0x0/0x4f
  [ 8652.193153]  [<ffffffff81462968>] ? verify_iovec+0x4c/0x9c
  [ 8652.193206]  [<ffffffff8145afc0>] ? sys_sendmsg+0x1e5/0x249
  [ 8652.193252]  [<ffffffff810bae2b>] ? d_kill+0x55/0x5d
  [ 8652.193300]  [<ffffffff810bb33a>] ? dput+0x24/0x126
  [ 8652.193342]  [<ffffffff810acc9d>] ? fput+0x1b1/0x1c0
  [ 8652.193389]  [<ffffffff810ba70d>] sys_poll+0x50/0xba
  [ 8652.193390]  [<ffffffff81001fab>] system_call_fastpath+0x16/0x1b
  [ 8652.193390] Code: 48 8b 87 10 01 00 00 a9 00 00 01 00 74 07 88 d0
83 c8 02 88 06 31 c0 c9 c3 55 48 89 f2 48 89 e5 48 8$
  [ 8652.193390] RIP  [<ffffffff81457fcb>] sock_poll+0x12/0x17
  [ 8652.193390]  RSP <ffff8800787c1b38>
  [ 8652.198050] CR2: 0000000000000040
  [ 8652.341807] ---[ end trace dca322e94d9e9dd6 ]---
  pulseaudio[3284]: bluetooth-util.c: Error from ListDevices reply:
org.freedesktop.DBus.Error.NoReply
  [ 8652.344611] VFS: Close: file count is 0
