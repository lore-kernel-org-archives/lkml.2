Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab0JSQEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 12:04:10 -0400
Received: from mail.agmk.net ([91.192.224.71]:56856 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753863Ab0JSQEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:04:08 -0400
From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #20472] [2.6.35.5 -> .7] INFO: task rpcbind:14163 blocked for more than 120 seconds.
Date: Tue, 19 Oct 2010 18:03:59 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35.7; KDE/4.5.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Trond Myklebust <trond.myklebust@fys.uio.no>,
        Arkadiusz Miskiewicz <arekm@maven.pl>
References: <TP5BfCZNRXD.A._8.uj1uMB@chimera> <201010181951.34620.pluto@agmk.net> <201010182336.51265.rjw@sisk.pl>
In-Reply-To: <201010182336.51265.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201010191804.00147.pluto@agmk.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 October 2010 23:36:51 Rafael J. Wysocki wrote:
> On Monday, October 18, 2010, Paweł Sikora wrote:
> > On Sunday 17 October 2010 22:21:48 Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a summary report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.35.  Please verify if it still should be listed and let the tracking team
> > > know (either way).
> > 
> > hi,
> > 
> > hot news from the front, recent tests on the pld-linux.org vendor kernel
> > show that the random task blocking in 2.6.35.7 during medium/heavy load (~4..25)
> > is related to the grsecurity patch. we'll forward problem report to the
> > grsec maintainer asap...
> 
> So, to make things clear, this is not a mainline kernel issue, is it?

i thought that was a grsecurity issue but now i have a testcase that
casues task blocking on my machine with the vanilla 2.6.35.7 kernel:

steps to repoduce:

on console 1:
- run 'make -j32' in kernel tree and wait several second for make forks
  and medium system load (~15).

on console 2:
- run 'sync' from root account to bump load more.

on console 3:
- observe 'tail -f /var/log/kernel' for blocking issues.

[  360.517917] INFO: task sync:6712 blocked for more than 120 seconds.
[  360.517920] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  360.517922] sync          D 00000000ffff4c7c     0  6712   2770 0x00000000
[  360.517926]  ffff88021ac71d18 0000000000000086 ffff880200000000 0000000000004000
[  360.517930]  0000000000013700 0000000000013700 ffff88021ac71fd8 ffff88021ac71fd8
[  360.517933]  ffff880205593020 0000000000013700 ffff88021ac71fd8 0000000000004000
[  360.517936] Call Trace:
[  360.517944]  [<ffffffff813b8dbd>] schedule_timeout+0x20d/0x2f0
[  360.517949]  [<ffffffff8103baba>] ? enqueue_entity+0xea/0x170
[  360.517951]  [<ffffffff8103bc09>] ? enqueue_task_fair+0x49/0x50
[  360.517954]  [<ffffffff813b8945>] wait_for_common+0xc5/0x150
[  360.517957]  [<ffffffff81040430>] ? default_wake_function+0x0/0x10
[  360.517959]  [<ffffffff813b8a78>] wait_for_completion+0x18/0x20
[  360.517963]  [<ffffffff8113b343>] sync_inodes_sb+0x83/0x170
[  360.517967]  [<ffffffff8113f890>] ? sync_one_sb+0x0/0x20
[  360.517969]  [<ffffffff8113f880>] __sync_filesystem+0x80/0x90
[  360.517972]  [<ffffffff8113f8ab>] sync_one_sb+0x1b/0x20
[  360.517975]  [<ffffffff8111d2c7>] iterate_supers+0x77/0xc0
[  360.517978]  [<ffffffff8113f7bb>] sync_filesystems+0x1b/0x20
[  360.517980]  [<ffffffff8113f92c>] sys_sync+0x1c/0x40
[  360.517984]  [<ffffffff81002d6b>] system_call_fastpath+0x16/0x1b

the 'make' is running on ext4 filesystem with underlying mdadm (raid10)
created from 2 caviar raid edition disks. the cpu is intel quad core
Q9300 with 8GB of ddr2 ram.
