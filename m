Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab0JaGj5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 02:39:57 -0400
Received: from eagle.jhcloos.com ([207.210.242.212]:48649 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab0JaGjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 02:39:55 -0400
From: James Cloos <cloos@jhcloos.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Eli Billauer <eli@billauer.co.il>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: open() on /dev/tty takes 30 seconds on 2.6.36
In-Reply-To: <201010310436.18613.arnd@arndb.de> (Arnd Bergmann's message of
	"Sun, 31 Oct 2010 04:36:18 +0100")
References: <4CCBCD8E.1020601@billauer.co.il>
	<20101030114634.b19c4e0c.akpm@linux-foundation.org>
	<4CCCB663.7010100@billauer.co.il> <201010310436.18613.arnd@arndb.de>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0.50 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2009 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Sun, 31 Oct 2010 02:34:22 -0400
Message-ID: <m31v766fax.fsf@jhcloos.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Hashcash: 1:30:101031:arnd@arndb.de::k+xDxTR7smz3pJXC:00059nhy
X-Hashcash: 1:30:101031:eli@billauer.co.il::rWFIRIgF1/SkPi92:000000000000000000000000000000000000000000Ewu0E
X-Hashcash: 1:30:101031:akpm@linux-foundation.org::+vftUJDfRt9xZ4qI:00000000000000000000000000000000000370VU
X-Hashcash: 1:30:101031:linux-kernel@vger.kernel.org::gzU5VKlsBVeW4jrq:00000000000000000000000000000000Wczj4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[I'm not sure whether this is the same issue, but in case it helps... -JimC]

I was about to prepare a bug report about a similar issue which as hit
my (normally headless) compute node.  It happened once before I first
booted 2.6.36, and once running 2.6.36.  The last two kernels which
I compiled before v2.6.36 were 9c03f16 and bfa88ea; I cannot remember
whether I ever booted 9c03f16.  I may have compiled v2.6.36 before
trying 9c03f16. The box is a Phenom, 64bit kernel and userland.

All of the ptys stopped working, which seems like it might be related to
a change in tty locking.

Everything else worked normally; only pty i/o stopped.  I couldn't log
in, or use any of my open terminals, but pipes, networking, disk i/o,
et al were all OK.

I was able to use 'ssh server dmesg' to get the dmesg; it had this to say:

WARNING: at kernel/workqueue.c:1180 worker_enter_idle+0xd6/0xe2()
Hardware name: MS-7642
Modules linked in: tcp_diag inet_diag ipt_addrtype xt_dscp xt_string xt_owner xt_multiport xt_iprange xt_hashlimit xt_DSCP xt_NFQUEUE xt_mark xt_connmark tun snd_pcm_oss snd_mixer_oss snd_usb_audio snd_usbmidi_lib snd_rawmidi tpm_tis tpm ppdev parport_pc tpm_bios parport serio_raw edac_core k10temp pcspkr i2c_piix4 shpchp
Pid: 8061, comm: kworker/0:1 Not tainted 2.6.36-carbon1 #18
Call Trace:
 [<ffffffff81050c60>] warn_slowpath_common+0x85/0x9d
 [<ffffffff81050c92>] warn_slowpath_null+0x1a/0x1c
 [<ffffffff81066861>] worker_enter_idle+0xd6/0xe2
 [<ffffffff81068453>] worker_thread+0x182/0x19b
 [<ffffffff810682d1>] ? worker_thread+0x0/0x19b
 [<ffffffff8106ba81>] kthread+0x82/0x8a
 [<ffffffff8100aae4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8106b9ff>] ? kthread+0x0/0x8a
 [<ffffffff8100aae0>] ? kernel_thread_helper+0x0/0x10
---[ end trace 756b0818a6415dca ]---

That was followed by a number of task blocked for more than 120 seconds
messages, all due to waiting for pty input or output.  An example trace:

INFO: task gpg:15408 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
gpg           D ffff8802507ec380     0 15408  15390 0x00000000
 ffff8802cf24fd88 0000000000000082 ffff880200000001 0000000000014b00
 0000000000014b00 ffff88010a45ae20 ffff8802cf24ffd8 0000000000014b00
 0000000000014b00 0000000000014b00 0000000000014b00 ffff8802cf24ffd8
Call Trace:
 [<ffffffff815ae2fc>] schedule_timeout+0x36/0xe3
 [<ffffffff81047b2b>] ? get_parent_ip+0x11/0x41
 [<ffffffff81047b2b>] ? get_parent_ip+0x11/0x41
 [<ffffffff815b2b6d>] ? sub_preempt_count+0x97/0xaa
 [<ffffffff815ad8a5>] wait_for_common+0xab/0x105
 [<ffffffff8104c1c4>] ? default_wake_function+0x0/0x14
 [<ffffffff81047b2b>] ? get_parent_ip+0x11/0x41
 [<ffffffff81065dd1>] ? __need_more_worker+0x15/0x2c
 [<ffffffff810d39ba>] ? lru_add_drain_per_cpu+0x0/0x10
 [<ffffffff815ad9b7>] wait_for_completion+0x1d/0x1f
 [<ffffffff81066d0d>] flush_work+0x110/0x12e
 [<ffffffff81066777>] ? wq_barrier_func+0x0/0x14
 [<ffffffff81068831>] schedule_on_each_cpu+0xa8/0xd7
 [<ffffffff810d3472>] lru_add_drain_all+0x15/0x17
 [<ffffffff810e7786>] sys_mlock+0x30/0xdf
 [<ffffffff81009cc2>] system_call_fastpath+0x16/0x1b

(I didn't save the dmesg the first time it happened; I wanted to try .36
before filing a bug report, in case it had already been fixed.)

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
