Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab3AJTC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 14:02:26 -0500
Received: from mail.gnuher.de ([78.47.12.54]:60279 "EHLO mail.gnuher.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766Ab3AJTCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 14:02:25 -0500
X-Greylist: delayed 1080 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jan 2013 14:02:25 EST
Date: Thu, 10 Jan 2013 19:44:20 +0100
From: Sven Geggus <lists@fuchsschwanzdomain.de>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Subject: reproducible w1 oops on recent kernels (at least since 3.2.x)
Message-ID: <20130110184419.GA4524@geggus.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-MimeOLE: Produced By Exchange Microsoft V6.6.6
User-Agent: Mutt/1.5.21 (2010-09-15)
X-remote-host: diesel.geggus.net [2a01:198:297:1:21c:c0ff:fefa:8a7b]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I first thought this to be a Raspberry Pi thing, but its not. Looks
like w1 driver is broken in some platform and busmaster independent
way at least since kernel 3.2.x (which Raspberry Pi uses).

Here is what to do to repoduce the bug on x86:

Get owfs from owfs.org and compile with w1 support or just install
owserver from your favourite Linux distribution.  I'm using version
2.8p15-1 from debian testing.

1. connect a 1-wire device to your computer and load the appropriate
   kernel module (I'm using a DS9490, so the module is ds2490.ko, but
   the bug also happens with other modules like w1-gpio)
2. run "owserver --error_print 2 --error_level 99 --foreground --w1"
3. run "owdir" on another terminal
4. system crashes with the following oops:

--cut--
Driver for 1-wire Dallas network protocol.
usbcore: registered new interface driver DS9490R
w1_master_driver w1_bus_master1: Family 81 for 81.000000247ca7.41 is not registered.
PGD 16ff067 PUD 1700067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP 
Modules linked in: ds2490 wire cn sha256_generic bluetooth crc16 binfmt_misc nfsd coretemp kvm_intel kvm snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep microcode i2c_i801 uhci_hcd
CPU 1 
Pid: 4631, comm: owserver Not tainted 3.7.1 #1                  /DG45ID
RIP: 0010:[<ffffffff8104baf0>]  [<ffffffff8104baf0>] kthread_should_stop+0x10/0x1b
RSP: 0018:ffff880223d79b00  EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffff88022f144000 RCX: 0000000000000000
RDX: 0000000000000001 RSI: 0000000000000286 RDI: 0000000000000000
RBP: 00000000ffffffff R08: ffff880223d78000 R09: 0000000000000000
R10: 0000000000000001 R11: dead000000100100 R12: ffff88022f1440b0
R13: 0000000000000040 R14: ffffffffa006f7fa R15: 0000000000000000
FS:  00007fdf7fd80700(0000) GS:ffff88023bc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffffffffffc8 CR3: 000000021c83c000 CR4: 00000000000407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process owserver (pid: 4631, threadinfo ffff880223d78000, task ffff880232f4e740)
Stack:
 ffffffffa006ee9c ffff880232cc60c0 0100000000000000 0000000000000000
 000000f000000001 ffffea000744b070 0000000000000001 ffff88021c8a3824
 ffff88022f144000 ffff88021c8a3810 ffff88022f144038 0000000000000000
Call Trace:
 [<ffffffffa006ee9c>] ? w1_search+0x11d/0x188 [wire]
 [<ffffffffa006ef3e>] ? w1_search_process_cb+0x37/0x91 [wire]
 [<ffffffffa006fbbc>] ? w1_cn_callback+0x2fd/0x42e [wire]
 [<ffffffffa0034585>] ? cn_rx_skb+0xb7/0xea [cn]
 [<ffffffff81458e29>] ? netlink_unicast+0x123/0x1ae
 [<ffffffff814591a7>] ? netlink_sendmsg+0x27d/0x2ed
 [<ffffffff81428229>] ? sock_sendmsg+0x98/0xb5
 [<ffffffff8142a7db>] ? sys_sendto+0xdb/0x104
 [<ffffffff810ef7cd>] ? vfs_write+0xfa/0x141
 [<ffffffff810efa27>] ? sys_write+0x60/0x77
 [<ffffffff8150e0a9>] ? system_call_fastpath+0x16/0x1b
Code: ff c6 05 93 71 73 00 01 eb 06 48 89 df 5b ff e0 48 c7 c0 ea ff ff ff 5b c3 90 90 65 48 8b 04 25 c0 b7 00 00 48 8b 80 88 02 00 00 <48> 8b 40 c8 48 d1 e8 83 e0 01 c3 f0 ff 47 10 48 8b 87 88 02 00 
 RSP <ffff880223d79b00>
CR2: ffffffffffffffc8
---[ end trace 3131d23f4378d60e ]---
--cut--

Regards

Sven

P.S.: Looks like this is the same bug, as the one reported at
https://bugzilla.redhat.com/show_bug.cgi?id=857954

-- 
"Those who do not understand Unix are condemned to reinvent it, poorly"
(Henry Spencer)

/me is giggls@ircnet, http://sven.gegg.us/ on the Web
