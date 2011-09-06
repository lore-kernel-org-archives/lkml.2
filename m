Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab1IFRpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 13:45:40 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51664 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab1IFRpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 13:45:33 -0400
Date: Wed, 7 Sep 2011 02:45:24 +0900
From: Tejun Heo <tj@kernel.org>
To: Jameson Graef Rollins <jrollins@finestructure.net>
Cc: Jonathan Nieder <jrnieder@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Amit Shah <amit.shah@redhat.com>, David Zeuthen <zeuthen@gmail.com>,
        Martin Pitt <martin.pitt@ubuntu.com>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        Jean Schurger <jean@schurger.org>,
        Jan =?iso-8859-1?Q?L=FCbbe?= <jluebbe@debian.org>,
        Matthijs Kooijman <matthijs@stdin.nl>,
        Nacho Barrientos Arias <nacho@debian.org>
Subject: Re: [regression] CD-ROM polling blocks suspend on some machines (Re:
 [PATCH 1/2] cdrom: always check_disk_change() on open)
Message-ID: <20110906174524.GN18425@mtj.dyndns.org>
References: <20110406121920.GC4142@mtj.dyndns.org>
 <20110903221456.GA2877@elie>
 <20110904024244.GB3083@htj.dyndns.org>
 <87y5y37o7h.fsf@servo.factory.finestructure.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y5y37o7h.fsf@servo.factory.finestructure.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Sep 04, 2011 at 06:49:38PM -0700, Jameson Graef Rollins wrote:
> I then rebooted into this new kernel and triggered the bug.  Attached is
> the dmesg output from right before and right after the bug was
> triggered.  The bug was triggered by ejecting my laptop from it's dock,
> and then trying to put it to sleep (which of course it failed to do).

If you wait (five mins) after triggering the problem, does the kernel
print further messages?  Also, can you please explain the steps needed
to trigger this problem?

> [  221.306959] cdrom_id        D 0000000000000000     0  2693   2689 0x00800004
> [  221.306969]  ffff88023180b8e8 0000000000000082 7fffffffffffffff ffff880200000000
> [  221.306978]  ffff8802314b83c0 ffff88023180bfd8 ffff88023180bfd8 0000000000012840
> [  221.306987]  ffff880232e18f60 ffff8802314b83c0 ffff88023180b938 000000018133e5cf
> [  221.306995] Call Trace:
> [  221.307011]  [<ffffffff8133ea82>] schedule_timeout+0x2f/0xd9
> [  221.307021]  [<ffffffff8133e86e>] wait_for_common+0x9e/0x115
> [  221.307029]  [<ffffffff8133e97b>] wait_for_completion+0x18/0x1a
> [  221.307035]  [<ffffffff8105b0fe>] flush_work+0x29/0x2f
> [  221.307042]  [<ffffffff8105b48a>] flush_delayed_work+0x3a/0x3e
> [  221.307047]  [<ffffffff81199bc6>] disk_clear_events+0x8f/0xf5
> [  221.307073]  [<ffffffff81121827>] check_disk_change+0x29/0x5b
> [  221.307081]  [<ffffffffa0069e71>] cdrom_open+0x44/0x4b2 [cdrom]
> [  221.307097]  [<ffffffffa010786b>] sr_block_open+0x90/0xb7 [sr_mod]
> [  221.307101]  [<ffffffff811226dd>] __blkdev_get+0xe5/0x39b
> [  221.307104]  [<ffffffff81122b5f>] blkdev_get+0x1cc/0x2bb
> [  221.307111]  [<ffffffff81122cb3>] blkdev_open+0x65/0x6a
> [  221.307115]  [<ffffffff810f98f2>] __dentry_open+0x185/0x29f
> [  221.307129]  [<ffffffff810fa842>] nameidata_to_filp+0x5b/0x62
> [  221.307135]  [<ffffffff81105843>] do_last+0x448/0x55d
> [  221.307138]  [<ffffffff81106483>] path_openat+0xc3/0x304
> [  221.307142]  [<ffffffff811066f7>] do_filp_open+0x33/0x81
> [  221.307150]  [<ffffffff810fa8b2>] do_sys_open+0x69/0xfb
> [  221.307153]  [<ffffffff810fa95f>] sys_open+0x1b/0x1d
> [  221.307157]  [<ffffffff81344d52>] system_call_fastpath+0x16/0x1b

Hmmm... so, this is cdrom_id waiting for event check work item to
complete.  The event work is executed on system_nrt_wq which is frozen
after all userland tasks are frozen so there's no reason for the above
to stall.  Can you please enable sysrq, trigger the problem and while
the system is in that 20 sec freeze stall, hit sysrq-t and report the
dmesg?

> [  242.681434] INFO: task cdrom_id:2693 blocked for more than 120 seconds.
> [  242.681438] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  242.681442] cdrom_id        D 0000000000000000     0  2693   2689 0x00000004
> [  242.681448]  ffff88023180b8e8 0000000000000082 7fffffffffffffff ffff880200000000
> [  242.681455]  ffff8802314b83c0 ffff88023180bfd8 ffff88023180bfd8 0000000000012840
> [  242.681460]  ffff880232e18f60 ffff8802314b83c0 ffff88023180b938 000000018133e5cf
> [  242.681466] Call Trace:
> [  242.681478]  [<ffffffff8133ea82>] schedule_timeout+0x2f/0xd9
> [  242.681490]  [<ffffffff8133e86e>] wait_for_common+0x9e/0x115
> [  242.681500]  [<ffffffff8133e97b>] wait_for_completion+0x18/0x1a
> [  242.681507]  [<ffffffff8105b0fe>] flush_work+0x29/0x2f

Does the cdrom eventually become usable afterwards?

Thanks.

-- 
tejun
