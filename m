Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209Ab1CDCG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 21:06:28 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:39619 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759044Ab1CDCG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 21:06:26 -0500
Subject: BUG at mm/mmap.c:2309 when cx18.ko and cx18-alsa.ko loaded
From: Andy Walls <awalls@md.metrocast.net>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 21:06:40 -0500
Message-ID: <1299204400.2812.35.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2011-03-04_01:2011-03-04,2011-03-03,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1012030000 definitions=main-1103030179
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got a BUG when loading the cx18.ko module (which in turn requests the
cx18-alsa.ko module) on a kernel built from this repository

	http://git.linuxtv.org/media_tree.git staging/for_v2.6.39

which I beleive is based on 2.6.38-rc2.

The BUG is mmap related and I'm almost certain it has to do with
userspace accessing cx18-alsa.ko ALSA device nodes, since cx18.ko
doesn't provide any mmap() related file ops.

So here is my transcription of a fuzzy digital photo of the screen:

kernel BUG at /home/andy/cx18dev/git/media_tree/mm/mmap.c:2309!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/module/snd_pcm/initstate
Modules linked in: tda9887 tda8290 mxl5005s s5h1409 tuner_simple ...
...
Pid: 2580, comm: udevd Not tainted 2.6.38-rc2-cx18-vb2-proto+
RIP: 0010:[<ffffffff810eb50b>]  [<ffffffff810eb50b>] exit_mmap+0x10f/0x11e
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0020000000000000
RDX: 0000000000160011 RSI: ffffea____c42___ RDI: 0000000000000202
RBP: ffff____18c1f_58 R08: ffff____________ R09: 0000000000000004
R10: ffff_______bb_38 R11: 0000000000000000 R12: ffff____344a6680
R13: 00007fff22______ R14: ffff____________ R15: 0000000000000001
...
CR2: 0000000000000000 ...
....
Process udevd (pid: 25__, threadinfo ffff________, ...
Stack:
 000000000000015e ffff00003bc0e1d0 0000000000000246 ....
.....
Call Trace:
... mmput+0x63/0xcf
... exit_mm+0x132/0x13f
... do_exit+0x238/0x749
... ? __dequeue_signal+0xfa/0x12f
... do_group_exit+0x7d/0xa5
... get_signal_to_deliver+0x371/0x395
... do_signal+0x72/0x692
... ? do_page_fault+0x24a/0x391
... ? printk+0x41/0x47
... ? sigprocmask+0xa3/0xcd
... do_notify_resume+0x2c/0x64
... retint_signal+0x48/0x8c

Code: ff ff 48 8b 7d d8 4c 89 ea 31 f6 e8 3e fe ff ff 48 89 df e8 78 fe
ff ff 48 85 c0 48 89 c3 75 f0 49 83 bc 24 e0 00 00 00 00 74 04 <0f> 0b
eb fe 48 83 c4 18 5b 41 5c 41 5d c9 c3 55 48 89 e5 41 57
RIP  [<ffffffff810eb50b>] exit_mmap+0x10f/0x11e
 RSP <ffff880018c1fc28>
general protection fault: 0000 [#2] SMP
last sysfs file: /sys/devices/virtual/sound/card2/uevent
CPU 1
Modules linked in: cx18-alsa tda9887 tda8290 mxl5005s s5h1409
tuner_simple tuner_types cs5345 tuner cx18 dvb_core cx2341x v4l2_common
videodev v4l2_compat_ioctl32


I'm not very familiar with mmap() nor ALSA and I did not author the
cx18-alsa part of the cx18 driver, so any hints at where to look for the
problem are appreciated.

Regards,
Andy

