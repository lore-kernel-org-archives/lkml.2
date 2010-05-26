Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933951Ab0EZIpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 04:45:22 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:50452 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536Ab0EZIpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 04:45:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=QQHiogWSav8ijKjksMfuF9pUkwUh+NhAyFAXnoQXwOZMlYFUfA8bRNiuJYzsKYgZ5v
         sz8eh++xztXaVJjqCuFiQk+yQtc4Yg5hEazWZqwkRn6q+Hx7kQvUROPXiUhGQhOkTJzq
         UCwwJzy4pc8onJhAPgsx5jE/eci3PlIknLtts=
Date: Wed, 26 May 2010 10:48:11 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.34 hard lock ppp/do_tty_hangup, regression
Message-ID: <20100526084811.GA5890@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am getting a perfectly reproducible hard lock when killing a ppp connection
that is in promiscuous mode, this USB device:

   Bus 005 Device 003: ID 19d2:0063 ONDA Communication S.p.A.

In my case I run "tcptrack -i ppp0" in a terminal window and as soon as I kill
pppd the machine freezes hard.

Is this a known problem?

I had some non-fatal lockups in 2.6.30* that my be related so I have attached the
messages here:


May 16 22:19:18 localhost kernel: [    0.000000] Linux version 2.6.33.2v1 (rz@rz) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #3 SMP Thu Apr 8 14:27:58 CEST 2010
....
....
....
....
May 19 00:44:36 localhost pppd[20619]: Terminating on signal 2
May 19 00:44:36 localhost pppd[20619]: Connect time 318.2 minutes.
May 19 00:44:36 localhost pppd[20619]: Sent 5172200 bytes, received 83501101 bytes.
May 19 00:44:36 localhost kernel: [81980.706871] device ppp0 left promiscuous mode
May 19 00:44:42 localhost pppd[20619]: Connection terminated.
May 19 00:44:51 localhost pppd[20619]: ioctl(TIOCSETD, N_TTY): Interrupted system call (line 562)
May 19 00:48:16 localhost kernel: [82200.358010] INFO: task events/0:9 blocked for more than 120 seconds.
May 19 00:48:16 localhost kernel: [82200.358014] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 19 00:48:16 localhost kernel: [82200.358017] events/0      D 00004a96     0     9      2 0x00000000
May 19 00:48:16 localhost kernel: [82200.358022]  f7095e48 00000082 6041d18c 00004a96 00004a96 6041fa09 f0b93e22 00000dd4
May 19 00:48:16 localhost kernel: [82200.358029]  c09bb3c0 c09bb3c0 c09bb3c0 0000287d f708a460 f708a700 c24083c0 00000000
May 19 00:48:16 localhost kernel: [82200.358036]  f708a460 60420163 00004a96 00000002 00000000 f708a460 c240840c 00004a96
May 19 00:48:16 localhost kernel: [82200.358044] Call Trace:
May 19 00:48:16 localhost kernel: [82200.358053]  [<c0736810>] schedule_timeout+0x16/0x9a
May 19 00:48:16 localhost kernel: [82200.358059]  [<c045951f>] ? trace_hardirqs_off_caller+0x18/0x91
May 19 00:48:16 localhost kernel: [82200.358063]  [<c0459f7f>] ? trace_hardirqs_on_caller+0x18/0x12e
May 19 00:48:16 localhost kernel: [82200.358066]  [<c045a0a0>] ? trace_hardirqs_on+0xb/0xd
May 19 00:48:16 localhost kernel: [82200.358069]  [<c07373ba>] __down_common+0x76/0xad
May 19 00:48:16 localhost kernel: [82200.358072]  [<c073743c>] __down+0x12/0x14
May 19 00:48:16 localhost kernel: [82200.358076]  [<c044f437>] down+0x22/0x2f
May 19 00:48:16 localhost kernel: [82200.358082]  [<fa863bef>] ppp_asynctty_close+0x4a/0x89 [ppp_async]
May 19 00:48:16 localhost kernel: [82200.358086]  [<fa863c36>] ppp_asynctty_hangup+0x8/0xc [ppp_async]
May 19 00:48:16 localhost kernel: [82200.358091]  [<c060ec35>] tty_ldisc_hangup+0x64/0x19c
May 19 00:48:16 localhost kernel: [82200.358095]  [<c0608c56>] do_tty_hangup+0xe4/0x2d7
May 19 00:48:16 localhost kernel: [82200.358098]  [<c0448303>] worker_thread+0x1a1/0x272
May 19 00:48:16 localhost kernel: [82200.358102]  [<c04482b9>] ? worker_thread+0x157/0x272
May 19 00:48:16 localhost kernel: [82200.358105]  [<c0608b72>] ? do_tty_hangup+0x0/0x2d7
May 19 00:48:16 localhost kernel: [82200.358108]  [<c044b52b>] ? autoremove_wake_function+0x0/0x33
May 19 00:48:16 localhost kernel: [82200.358112]  [<c0448162>] ? worker_thread+0x0/0x272
May 19 00:48:16 localhost kernel: [82200.358115]  [<c044b1d9>] kthread+0x61/0x66
May 19 00:48:16 localhost kernel: [82200.358118]  [<c044b178>] ? kthread+0x0/0x66
May 19 00:48:16 localhost kernel: [82200.358122]  [<c04035ba>] kernel_thread_helper+0x6/0x1a
May 19 00:48:16 localhost kernel: [82200.358124] INFO: lockdep is turned off.
May 19 00:48:16 localhost kernel: [82200.358170] INFO: task X:3712 blocked for more than 120 seconds.
May 19 00:48:16 localhost kernel: [82200.358171] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 19 00:48:16 localhost kernel: [82200.358174] X             D 00004a96     0  3712   3694 0x00400084
May 19 00:48:16 localhost kernel: [82200.358178]  f6b37a24 00003092 98a9c70e 00004a96 ffffffff 00000000 c25038ec 00000000
May 19 00:48:16 localhost kernel: [82200.358185]  c09bb3c0 c09bb3c0 c09bb3c0 c09b66fc f4abb690 f4abb930 c24083c0 00000000
May 19 00:48:16 localhost kernel: [82200.358192]  04decd95 00000002 00000000 f4abb690 00000002 00000000 00003046 c24036fc
May 19 00:48:16 localhost kernel: [82200.358199] Call Trace:
May 19 00:48:16 localhost kernel: [82200.358203]  [<c0736810>] schedule_timeout+0x16/0x9a
May 19 00:48:16 localhost kernel: [82200.358207]  [<c0736681>] ? wait_for_common+0x31/0xec
May 19 00:48:16 localhost kernel: [82200.358211]  [<c0459f7f>] ? trace_hardirqs_on_caller+0x18/0x12e
May 19 00:48:16 localhost kernel: [82200.358214]  [<c045a0a0>] ? trace_hardirqs_on+0xb/0xd
May 19 00:48:16 localhost kernel: [82200.358217]  [<c07366f7>] wait_for_common+0xa7/0xec
May 19 00:48:16 localhost kernel: [82200.358221]  [<c0431bbc>] ? default_wake_function+0x0/0xd
May 19 00:48:16 localhost kernel: [82200.358225]  [<c07367ae>] wait_for_completion+0x12/0x14
May 19 00:48:16 localhost kernel: [82200.358228]  [<c0448c56>] flush_work+0xa1/0xb2
May 19 00:48:16 localhost kernel: [82200.358231]  [<c044865e>] ? wq_barrier_func+0x0/0xd
May 19 00:48:16 localhost kernel: [82200.358234]  [<c0448dc9>] flush_delayed_work+0x40/0x43
May 19 00:48:16 localhost kernel: [82200.358238]  [<c060f4d9>] tty_flush_to_ldisc+0xd/0xf
May 19 00:48:16 localhost kernel: [82200.358241]  [<c060b631>] n_tty_poll+0x54/0x127
May 19 00:48:16 localhost kernel: [82200.358244]  [<c060b5dd>] ? n_tty_poll+0x0/0x127
May 19 00:48:16 localhost kernel: [82200.358247]  [<c0608322>] tty_poll+0x4c/0x62
May 19 00:48:16 localhost kernel: [82200.358252]  [<c04d8907>] do_select+0x3a8/0x5cf
May 19 00:48:16 localhost kernel: [82200.358256]  [<c042730d>] ? update_curr+0x177/0x17f
May 19 00:48:16 localhost kernel: [82200.358260]  [<c04d8ed1>] ? __pollwait+0x0/0xac
May 19 00:48:16 localhost kernel: [82200.358263]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:48:16 localhost kernel: [82200.358266]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:48:16 localhost kernel: [82200.358269]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:48:16 localhost kernel: [82200.358272]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:48:16 localhost kernel: [82200.358274]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:48:16 localhost kernel: [82200.358277]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:48:16 localhost kernel: [82200.358280]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:48:16 localhost kernel: [82200.358283]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:48:16 localhost kernel: [82200.358286]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:48:16 localhost kernel: [82200.358289]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:48:16 localhost kernel: [82200.358292]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:48:16 localhost kernel: [82200.358295]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:48:16 localhost kernel: [82200.358298]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:48:16 localhost kernel: [82200.358301]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:48:16 localhost kernel: [82200.358304]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:48:16 localhost kernel: [82200.358307]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:48:16 localhost kernel: [82200.358309]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:48:16 localhost kernel: [82200.358312]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:48:16 localhost kernel: [82200.358316]  [<c04d8c7c>] core_sys_select+0x14e/0x1ce
May 19 00:48:16 localhost kernel: [82200.358321]  [<c04adcfd>] ? might_fault+0x47/0x81
May 19 00:48:16 localhost kernel: [82200.358324]  [<c04d7279>] ? do_vfs_ioctl+0x49b/0x4d5
May 19 00:48:16 localhost kernel: [82200.358327]  [<c0452e70>] ? ktime_get_ts+0xd0/0xda
May 19 00:48:16 localhost kernel: [82200.358330]  [<c04d8eb3>] sys_select+0x6e/0x8c
May 19 00:48:16 localhost kernel: [82200.358334]  [<c0738295>] syscall_call+0x7/0xb
May 19 00:48:16 localhost kernel: [82200.358336] INFO: lockdep is turned off.

May 19 00:50:16 localhost kernel: [82320.358012] INFO: task events/0:9 blocked for more than 120 seconds.
May 19 00:50:16 localhost kernel: [82320.358016] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 19 00:50:16 localhost kernel: [82320.358019] events/0      D 00004a96     0     9      2 0x00000000
May 19 00:50:16 localhost kernel: [82320.358024]  f7095e48 00000082 6041d18c 00004a96 00004a96 6041fa09 f0b93e22 00000dd4
May 19 00:50:16 localhost kernel: [82320.358032]  c09bb3c0 c09bb3c0 c09bb3c0 0000287d f708a460 f708a700 c24083c0 00000000
May 19 00:50:16 localhost kernel: [82320.358039]  f708a460 60420163 00004a96 00000002 00000000 f708a460 c240840c 00004a96
May 19 00:50:16 localhost kernel: [82320.358046] Call Trace:
May 19 00:50:16 localhost kernel: [82320.358056]  [<c0736810>] schedule_timeout+0x16/0x9a
May 19 00:50:16 localhost kernel: [82320.358061]  [<c045951f>] ? trace_hardirqs_off_caller+0x18/0x91
May 19 00:50:16 localhost kernel: [82320.358065]  [<c0459f7f>] ? trace_hardirqs_on_caller+0x18/0x12e
May 19 00:50:16 localhost kernel: [82320.358068]  [<c045a0a0>] ? trace_hardirqs_on+0xb/0xd
May 19 00:50:16 localhost kernel: [82320.358071]  [<c07373ba>] __down_common+0x76/0xad
May 19 00:50:16 localhost kernel: [82320.358074]  [<c073743c>] __down+0x12/0x14
May 19 00:50:16 localhost kernel: [82320.358079]  [<c044f437>] down+0x22/0x2f
May 19 00:50:16 localhost kernel: [82320.358085]  [<fa863bef>] ppp_asynctty_close+0x4a/0x89 [ppp_async]
May 19 00:50:16 localhost kernel: [82320.358088]  [<fa863c36>] ppp_asynctty_hangup+0x8/0xc [ppp_async]
May 19 00:50:16 localhost kernel: [82320.358093]  [<c060ec35>] tty_ldisc_hangup+0x64/0x19c
May 19 00:50:16 localhost kernel: [82320.358097]  [<c0608c56>] do_tty_hangup+0xe4/0x2d7
May 19 00:50:16 localhost kernel: [82320.358101]  [<c0448303>] worker_thread+0x1a1/0x272
May 19 00:50:16 localhost kernel: [82320.358104]  [<c04482b9>] ? worker_thread+0x157/0x272
May 19 00:50:16 localhost kernel: [82320.358107]  [<c0608b72>] ? do_tty_hangup+0x0/0x2d7
May 19 00:50:16 localhost kernel: [82320.358111]  [<c044b52b>] ? autoremove_wake_function+0x0/0x33
May 19 00:50:16 localhost kernel: [82320.358114]  [<c0448162>] ? worker_thread+0x0/0x272
May 19 00:50:16 localhost kernel: [82320.358117]  [<c044b1d9>] kthread+0x61/0x66
May 19 00:50:16 localhost kernel: [82320.358120]  [<c044b178>] ? kthread+0x0/0x66
May 19 00:50:16 localhost kernel: [82320.358124]  [<c04035ba>] kernel_thread_helper+0x6/0x1a
May 19 00:50:16 localhost kernel: [82320.358126] INFO: lockdep is turned off.
May 19 00:50:16 localhost kernel: [82320.358171] INFO: task X:3712 blocked for more than 120 seconds.
May 19 00:50:16 localhost kernel: [82320.358173] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 19 00:50:16 localhost kernel: [82320.358175] X             D 00004a96     0  3712   3694 0x00400084
May 19 00:50:16 localhost kernel: [82320.358180]  f6b37a24 00003092 98a9c70e 00004a96 ffffffff 00000000 c25038ec 00000000
May 19 00:50:16 localhost kernel: [82320.358187]  c09bb3c0 c09bb3c0 c09bb3c0 c09b66fc f4abb690 f4abb930 c24083c0 00000000
May 19 00:50:16 localhost kernel: [82320.358193]  04decd95 00000002 00000000 f4abb690 00000002 00000000 00003046 c24036fc
May 19 00:50:16 localhost kernel: [82320.358201] Call Trace:
May 19 00:50:16 localhost kernel: [82320.358205]  [<c0736810>] schedule_timeout+0x16/0x9a
May 19 00:50:16 localhost kernel: [82320.358208]  [<c0736681>] ? wait_for_common+0x31/0xec
May 19 00:50:16 localhost kernel: [82320.358212]  [<c0459f7f>] ? trace_hardirqs_on_caller+0x18/0x12e
May 19 00:50:16 localhost kernel: [82320.358215]  [<c045a0a0>] ? trace_hardirqs_on+0xb/0xd
May 19 00:50:16 localhost kernel: [82320.358218]  [<c07366f7>] wait_for_common+0xa7/0xec
May 19 00:50:16 localhost kernel: [82320.358222]  [<c0431bbc>] ? default_wake_function+0x0/0xd
May 19 00:50:16 localhost kernel: [82320.358226]  [<c07367ae>] wait_for_completion+0x12/0x14
May 19 00:50:16 localhost kernel: [82320.358229]  [<c0448c56>] flush_work+0xa1/0xb2
May 19 00:50:16 localhost kernel: [82320.358232]  [<c044865e>] ? wq_barrier_func+0x0/0xd
May 19 00:50:16 localhost kernel: [82320.358235]  [<c0448dc9>] flush_delayed_work+0x40/0x43
May 19 00:50:16 localhost kernel: [82320.358239]  [<c060f4d9>] tty_flush_to_ldisc+0xd/0xf
May 19 00:50:16 localhost kernel: [82320.358242]  [<c060b631>] n_tty_poll+0x54/0x127
May 19 00:50:16 localhost kernel: [82320.358245]  [<c060b5dd>] ? n_tty_poll+0x0/0x127
May 19 00:50:16 localhost kernel: [82320.358248]  [<c0608322>] tty_poll+0x4c/0x62
May 19 00:50:16 localhost kernel: [82320.358252]  [<c04d8907>] do_select+0x3a8/0x5cf
May 19 00:50:16 localhost kernel: [82320.358256]  [<c042730d>] ? update_curr+0x177/0x17f
May 19 00:50:16 localhost kernel: [82320.358260]  [<c04d8ed1>] ? __pollwait+0x0/0xac
May 19 00:50:16 localhost kernel: [82320.358263]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:50:16 localhost kernel: [82320.358266]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:50:16 localhost kernel: [82320.358269]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:50:16 localhost kernel: [82320.358272]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:50:16 localhost kernel: [82320.358275]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:50:16 localhost kernel: [82320.358278]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:50:16 localhost kernel: [82320.358280]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:50:16 localhost kernel: [82320.358283]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:50:16 localhost kernel: [82320.358286]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:50:16 localhost kernel: [82320.358289]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:50:16 localhost kernel: [82320.358292]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:50:16 localhost kernel: [82320.358295]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:50:16 localhost kernel: [82320.358298]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:50:16 localhost kernel: [82320.358301]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:50:16 localhost kernel: [82320.358304]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:50:16 localhost kernel: [82320.358306]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:50:16 localhost kernel: [82320.358309]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:50:16 localhost kernel: [82320.358312]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:50:16 localhost kernel: [82320.358315]  [<c04d8c7c>] core_sys_select+0x14e/0x1ce
May 19 00:50:16 localhost kernel: [82320.358321]  [<c04adcfd>] ? might_fault+0x47/0x81
May 19 00:50:16 localhost kernel: [82320.358324]  [<c04d7279>] ? do_vfs_ioctl+0x49b/0x4d5
May 19 00:50:16 localhost kernel: [82320.358327]  [<c0452e70>] ? ktime_get_ts+0xd0/0xda
May 19 00:50:16 localhost kernel: [82320.358330]  [<c04d8eb3>] sys_select+0x6e/0x8c
May 19 00:50:16 localhost kernel: [82320.358334]  [<c0738295>] syscall_call+0x7/0xb
May 19 00:50:16 localhost kernel: [82320.358335] INFO: lockdep is turned off.
May 19 00:52:16 localhost kernel: [82440.358012] INFO: task events/0:9 blocked for more than 120 seconds.
May 19 00:52:16 localhost kernel: [82440.358017] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 19 00:52:16 localhost kernel: [82440.358019] events/0      D 00004a96     0     9      2 0x00000000
May 19 00:52:16 localhost kernel: [82440.358024]  f7095e48 00000082 6041d18c 00004a96 00004a96 6041fa09 f0b93e22 00000dd4
May 19 00:52:16 localhost kernel: [82440.358032]  c09bb3c0 c09bb3c0 c09bb3c0 0000287d f708a460 f708a700 c24083c0 00000000
May 19 00:52:16 localhost kernel: [82440.358039]  f708a460 60420163 00004a96 00000002 00000000 f708a460 c240840c 00004a96
May 19 00:52:16 localhost kernel: [82440.358046] Call Trace:
May 19 00:52:16 localhost kernel: [82440.358056]  [<c0736810>] schedule_timeout+0x16/0x9a
May 19 00:52:16 localhost kernel: [82440.358061]  [<c045951f>] ? trace_hardirqs_off_caller+0x18/0x91
May 19 00:52:16 localhost kernel: [82440.358065]  [<c0459f7f>] ? trace_hardirqs_on_caller+0x18/0x12e
May 19 00:52:16 localhost kernel: [82440.358068]  [<c045a0a0>] ? trace_hardirqs_on+0xb/0xd
May 19 00:52:16 localhost kernel: [82440.358071]  [<c07373ba>] __down_common+0x76/0xad
May 19 00:52:16 localhost kernel: [82440.358074]  [<c073743c>] __down+0x12/0x14
May 19 00:52:16 localhost kernel: [82440.358079]  [<c044f437>] down+0x22/0x2f
May 19 00:52:16 localhost kernel: [82440.358084]  [<fa863bef>] ppp_asynctty_close+0x4a/0x89 [ppp_async]
May 19 00:52:16 localhost kernel: [82440.358088]  [<fa863c36>] ppp_asynctty_hangup+0x8/0xc [ppp_async]
May 19 00:52:16 localhost kernel: [82440.358093]  [<c060ec35>] tty_ldisc_hangup+0x64/0x19c
May 19 00:52:16 localhost kernel: [82440.358096]  [<c0608c56>] do_tty_hangup+0xe4/0x2d7
May 19 00:52:16 localhost kernel: [82440.358100]  [<c0448303>] worker_thread+0x1a1/0x272
May 19 00:52:16 localhost kernel: [82440.358104]  [<c04482b9>] ? worker_thread+0x157/0x272
May 19 00:52:16 localhost kernel: [82440.358107]  [<c0608b72>] ? do_tty_hangup+0x0/0x2d7
May 19 00:52:16 localhost kernel: [82440.358110]  [<c044b52b>] ? autoremove_wake_function+0x0/0x33
May 19 00:52:16 localhost kernel: [82440.358113]  [<c0448162>] ? worker_thread+0x0/0x272
May 19 00:52:16 localhost kernel: [82440.358117]  [<c044b1d9>] kthread+0x61/0x66
May 19 00:52:16 localhost kernel: [82440.358120]  [<c044b178>] ? kthread+0x0/0x66
May 19 00:52:16 localhost kernel: [82440.358124]  [<c04035ba>] kernel_thread_helper+0x6/0x1a
May 19 00:52:16 localhost kernel: [82440.358126] INFO: lockdep is turned off.
May 19 00:52:16 localhost kernel: [82440.358171] INFO: task X:3712 blocked for more than 120 seconds.
May 19 00:52:16 localhost kernel: [82440.358173] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 19 00:52:16 localhost kernel: [82440.358175] X             D 00004a96     0  3712   3694 0x00400084
May 19 00:52:16 localhost kernel: [82440.358179]  f6b37a24 00003092 98a9c70e 00004a96 ffffffff 00000000 c25038ec 00000000
May 19 00:52:16 localhost kernel: [82440.358187]  c09bb3c0 c09bb3c0 c09bb3c0 c09b66fc f4abb690 f4abb930 c24083c0 00000000
May 19 00:52:16 localhost kernel: [82440.358193]  04decd95 00000002 00000000 f4abb690 00000002 00000000 00003046 c24036fc
May 19 00:52:16 localhost kernel: [82440.358200] Call Trace:
May 19 00:52:16 localhost kernel: [82440.358205]  [<c0736810>] schedule_timeout+0x16/0x9a
May 19 00:52:16 localhost kernel: [82440.358208]  [<c0736681>] ? wait_for_common+0x31/0xec
May 19 00:52:16 localhost kernel: [82440.358212]  [<c0459f7f>] ? trace_hardirqs_on_caller+0x18/0x12e
May 19 00:52:16 localhost kernel: [82440.358215]  [<c045a0a0>] ? trace_hardirqs_on+0xb/0xd
May 19 00:52:16 localhost kernel: [82440.358218]  [<c07366f7>] wait_for_common+0xa7/0xec
May 19 00:52:16 localhost kernel: [82440.358223]  [<c0431bbc>] ? default_wake_function+0x0/0xd
May 19 00:52:16 localhost kernel: [82440.358226]  [<c07367ae>] wait_for_completion+0x12/0x14
May 19 00:52:16 localhost kernel: [82440.358229]  [<c0448c56>] flush_work+0xa1/0xb2
May 19 00:52:16 localhost kernel: [82440.358232]  [<c044865e>] ? wq_barrier_func+0x0/0xd
May 19 00:52:16 localhost kernel: [82440.358236]  [<c0448dc9>] flush_delayed_work+0x40/0x43
May 19 00:52:16 localhost kernel: [82440.358239]  [<c060f4d9>] tty_flush_to_ldisc+0xd/0xf
May 19 00:52:16 localhost kernel: [82440.358242]  [<c060b631>] n_tty_poll+0x54/0x127
May 19 00:52:16 localhost kernel: [82440.358245]  [<c060b5dd>] ? n_tty_poll+0x0/0x127
May 19 00:52:16 localhost kernel: [82440.358248]  [<c0608322>] tty_poll+0x4c/0x62
May 19 00:52:16 localhost kernel: [82440.358252]  [<c04d8907>] do_select+0x3a8/0x5cf
May 19 00:52:16 localhost kernel: [82440.358257]  [<c042730d>] ? update_curr+0x177/0x17f
May 19 00:52:16 localhost kernel: [82440.358261]  [<c04d8ed1>] ? __pollwait+0x0/0xac
May 19 00:52:16 localhost kernel: [82440.358264]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:52:16 localhost kernel: [82440.358267]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:52:16 localhost kernel: [82440.358270]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:52:16 localhost kernel: [82440.358273]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:52:16 localhost kernel: [82440.358276]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:52:16 localhost kernel: [82440.358279]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:52:16 localhost kernel: [82440.358281]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:52:16 localhost kernel: [82440.358284]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:52:16 localhost kernel: [82440.358287]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:52:16 localhost kernel: [82440.358290]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:52:16 localhost kernel: [82440.358293]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:52:16 localhost kernel: [82440.358296]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:52:16 localhost kernel: [82440.358299]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:52:16 localhost kernel: [82440.358302]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:52:16 localhost kernel: [82440.358305]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:52:16 localhost kernel: [82440.358307]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:52:16 localhost kernel: [82440.358310]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:52:16 localhost kernel: [82440.358313]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:52:16 localhost kernel: [82440.358316]  [<c04d8c7c>] core_sys_select+0x14e/0x1ce
May 19 00:52:16 localhost kernel: [82440.358322]  [<c04adcfd>] ? might_fault+0x47/0x81
May 19 00:52:16 localhost kernel: [82440.358325]  [<c04d7279>] ? do_vfs_ioctl+0x49b/0x4d5
May 19 00:52:16 localhost kernel: [82440.358328]  [<c0452e70>] ? ktime_get_ts+0xd0/0xda
May 19 00:52:16 localhost kernel: [82440.358331]  [<c04d8eb3>] sys_select+0x6e/0x8c
May 19 00:52:16 localhost kernel: [82440.358335]  [<c0738295>] syscall_call+0x7/0xb
May 19 00:52:16 localhost kernel: [82440.358337] INFO: lockdep is turned off.
May 19 00:54:16 localhost kernel: [82560.358012] INFO: task events/0:9 blocked for more than 120 seconds.
May 19 00:54:16 localhost kernel: [82560.358016] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 19 00:54:16 localhost kernel: [82560.358018] events/0      D 00004a96     0     9      2 0x00000000
May 19 00:54:16 localhost kernel: [82560.358023]  f7095e48 00000082 6041d18c 00004a96 00004a96 6041fa09 f0b93e22 00000dd4
May 19 00:54:16 localhost kernel: [82560.358031]  c09bb3c0 c09bb3c0 c09bb3c0 0000287d f708a460 f708a700 c24083c0 00000000
May 19 00:54:16 localhost kernel: [82560.358038]  f708a460 60420163 00004a96 00000002 00000000 f708a460 c240840c 00004a96
May 19 00:54:16 localhost kernel: [82560.358045] Call Trace:
May 19 00:54:16 localhost kernel: [82560.358055]  [<c0736810>] schedule_timeout+0x16/0x9a
May 19 00:54:16 localhost kernel: [82560.358060]  [<c045951f>] ? trace_hardirqs_off_caller+0x18/0x91
May 19 00:54:16 localhost kernel: [82560.358064]  [<c0459f7f>] ? trace_hardirqs_on_caller+0x18/0x12e
May 19 00:54:16 localhost kernel: [82560.358067]  [<c045a0a0>] ? trace_hardirqs_on+0xb/0xd
May 19 00:54:16 localhost kernel: [82560.358070]  [<c07373ba>] __down_common+0x76/0xad
May 19 00:54:16 localhost kernel: [82560.358074]  [<c073743c>] __down+0x12/0x14
May 19 00:54:16 localhost kernel: [82560.358078]  [<c044f437>] down+0x22/0x2f
May 19 00:54:16 localhost kernel: [82560.358083]  [<fa863bef>] ppp_asynctty_close+0x4a/0x89 [ppp_async]
May 19 00:54:16 localhost kernel: [82560.358087]  [<fa863c36>] ppp_asynctty_hangup+0x8/0xc [ppp_async]
May 19 00:54:16 localhost kernel: [82560.358092]  [<c060ec35>] tty_ldisc_hangup+0x64/0x19c
May 19 00:54:16 localhost kernel: [82560.358095]  [<c0608c56>] do_tty_hangup+0xe4/0x2d7
May 19 00:54:16 localhost kernel: [82560.358099]  [<c0448303>] worker_thread+0x1a1/0x272
May 19 00:54:16 localhost kernel: [82560.358102]  [<c04482b9>] ? worker_thread+0x157/0x272
May 19 00:54:16 localhost kernel: [82560.358105]  [<c0608b72>] ? do_tty_hangup+0x0/0x2d7
May 19 00:54:16 localhost kernel: [82560.358109]  [<c044b52b>] ? autoremove_wake_function+0x0/0x33
May 19 00:54:16 localhost kernel: [82560.358112]  [<c0448162>] ? worker_thread+0x0/0x272
May 19 00:54:16 localhost kernel: [82560.358116]  [<c044b1d9>] kthread+0x61/0x66
May 19 00:54:16 localhost kernel: [82560.358119]  [<c044b178>] ? kthread+0x0/0x66
May 19 00:54:16 localhost kernel: [82560.358123]  [<c04035ba>] kernel_thread_helper+0x6/0x1a
May 19 00:54:16 localhost kernel: [82560.358125] INFO: lockdep is turned off.
May 19 00:54:16 localhost kernel: [82560.358169] INFO: task X:3712 blocked for more than 120 seconds.
May 19 00:54:16 localhost kernel: [82560.358171] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 19 00:54:16 localhost kernel: [82560.358173] X             D 00004a96     0  3712   3694 0x00400084
May 19 00:54:16 localhost kernel: [82560.358177]  f6b37a24 00003092 98a9c70e 00004a96 ffffffff 00000000 c25038ec 00000000
May 19 00:54:16 localhost kernel: [82560.358184]  c09bb3c0 c09bb3c0 c09bb3c0 c09b66fc f4abb690 f4abb930 c24083c0 00000000
May 19 00:54:16 localhost kernel: [82560.358191]  04decd95 00000002 00000000 f4abb690 00000002 00000000 00003046 c24036fc
May 19 00:54:16 localhost kernel: [82560.358198] Call Trace:
May 19 00:54:16 localhost kernel: [82560.358202]  [<c0736810>] schedule_timeout+0x16/0x9a
May 19 00:54:16 localhost kernel: [82560.358206]  [<c0736681>] ? wait_for_common+0x31/0xec
May 19 00:54:16 localhost kernel: [82560.358209]  [<c0459f7f>] ? trace_hardirqs_on_caller+0x18/0x12e
May 19 00:54:16 localhost kernel: [82560.358213]  [<c045a0a0>] ? trace_hardirqs_on+0xb/0xd
May 19 00:54:16 localhost kernel: [82560.358216]  [<c07366f7>] wait_for_common+0xa7/0xec
May 19 00:54:16 localhost kernel: [82560.358220]  [<c0431bbc>] ? default_wake_function+0x0/0xd
May 19 00:54:16 localhost kernel: [82560.358224]  [<c07367ae>] wait_for_completion+0x12/0x14
May 19 00:54:16 localhost kernel: [82560.358227]  [<c0448c56>] flush_work+0xa1/0xb2
May 19 00:54:16 localhost kernel: [82560.358230]  [<c044865e>] ? wq_barrier_func+0x0/0xd
May 19 00:54:16 localhost kernel: [82560.358233]  [<c0448dc9>] flush_delayed_work+0x40/0x43
May 19 00:54:16 localhost kernel: [82560.358237]  [<c060f4d9>] tty_flush_to_ldisc+0xd/0xf
May 19 00:54:16 localhost kernel: [82560.358240]  [<c060b631>] n_tty_poll+0x54/0x127
May 19 00:54:16 localhost kernel: [82560.358243]  [<c060b5dd>] ? n_tty_poll+0x0/0x127
May 19 00:54:16 localhost kernel: [82560.358246]  [<c0608322>] tty_poll+0x4c/0x62
May 19 00:54:16 localhost kernel: [82560.358250]  [<c04d8907>] do_select+0x3a8/0x5cf
May 19 00:54:16 localhost kernel: [82560.358254]  [<c042730d>] ? update_curr+0x177/0x17f
May 19 00:54:16 localhost kernel: [82560.358258]  [<c04d8ed1>] ? __pollwait+0x0/0xac
May 19 00:54:16 localhost kernel: [82560.358261]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:54:16 localhost kernel: [82560.358264]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:54:16 localhost kernel: [82560.358267]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:54:16 localhost kernel: [82560.358270]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:54:16 localhost kernel: [82560.358273]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:54:16 localhost kernel: [82560.358276]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:54:16 localhost kernel: [82560.358279]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:54:16 localhost kernel: [82560.358281]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:54:16 localhost kernel: [82560.358284]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:54:16 localhost kernel: [82560.358287]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:54:16 localhost kernel: [82560.358290]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:54:16 localhost kernel: [82560.358293]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:54:16 localhost kernel: [82560.358296]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:54:16 localhost kernel: [82560.358299]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:54:16 localhost kernel: [82560.358302]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:54:16 localhost kernel: [82560.358305]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:54:16 localhost kernel: [82560.358308]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:54:16 localhost kernel: [82560.358310]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 19 00:54:16 localhost kernel: [82560.358314]  [<c04d8c7c>] core_sys_select+0x14e/0x1ce
May 19 00:54:16 localhost kernel: [82560.358319]  [<c04adcfd>] ? might_fault+0x47/0x81
May 19 00:54:16 localhost kernel: [82560.358322]  [<c04d7279>] ? do_vfs_ioctl+0x49b/0x4d5
May 19 00:54:16 localhost kernel: [82560.358325]  [<c0452e70>] ? ktime_get_ts+0xd0/0xda
May 19 00:54:16 localhost kernel: [82560.358329]  [<c04d8eb3>] sys_select+0x6e/0x8c
May 19 00:54:16 localhost kernel: [82560.358332]  [<c0738295>] syscall_call+0x7/0xb
May 19 00:54:16 localhost kernel: [82560.358334] INFO: lockdep is turned off.


and another interesting case:

May 19 19:36:08 localhost kernel: [    0.000000] Linux version 2.6.33.2v1 (rz@rz) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #3 SMP Thu Apr 8 14:27:58 CEST 2010
....
....
....
May 20 00:23:54 localhost kernel: [17520.343017] INFO: task events/1:10 blocked for more than 120 seconds.
May 20 00:23:54 localhost kernel: [17520.343020] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 20 00:23:54 localhost kernel: [17520.343023] events/1      D 00000fc0     0    10      2 0x00000000
May 20 00:23:54 localhost kernel: [17520.343027]  f7097e48 00000082 b19aeb18 00000fc0 f7097e74 c045b644 f7097e74 c045b6c8
May 20 00:23:54 localhost kernel: [17520.343034]  c09bb3c0 c09bb3c0 c09bb3c0 e882a416 f708b690 f708b930 c25083c0 00000001
May 20 00:23:54 localhost kernel: [17520.343041]  f708b690 b19ee045 00000fc0 00000002 00000002 00000001 f708bb88 00004576
May 20 00:23:54 localhost kernel: [17520.343047] Call Trace:
May 20 00:23:54 localhost kernel: [17520.343057]  [<c045b644>] ? __lock_acquire+0xa67/0xbb7
May 20 00:23:54 localhost kernel: [17520.343060]  [<c045b6c8>] ? __lock_acquire+0xaeb/0xbb7
May 20 00:23:54 localhost kernel: [17520.343066]  [<c0736810>] schedule_timeout+0x16/0x9a
May 20 00:23:54 localhost kernel: [17520.343069]  [<c0459e04>] ? mark_held_locks+0x43/0x5b
May 20 00:23:54 localhost kernel: [17520.343072]  [<c0737ffb>] ? _raw_spin_unlock_irq+0x22/0x2b
May 20 00:23:54 localhost kernel: [17520.343076]  [<c045a074>] ? trace_hardirqs_on_caller+0x10d/0x12e
May 20 00:23:54 localhost kernel: [17520.343079]  [<c045a0a0>] ? trace_hardirqs_on+0xb/0xd
May 20 00:23:54 localhost kernel: [17520.343082]  [<c07373ba>] __down_common+0x76/0xad
May 20 00:23:54 localhost kernel: [17520.343085]  [<c073743c>] __down+0x12/0x14
May 20 00:23:54 localhost kernel: [17520.343089]  [<c044f437>] down+0x22/0x2f
May 20 00:23:54 localhost kernel: [17520.343094]  [<fa85cbef>] ppp_asynctty_close+0x4a/0x89 [ppp_async]
May 20 00:23:54 localhost kernel: [17520.343097]  [<fa85cc36>] ppp_asynctty_hangup+0x8/0xc [ppp_async]
May 20 00:23:54 localhost kernel: [17520.343102]  [<c060ec35>] tty_ldisc_hangup+0x64/0x19c
May 20 00:23:54 localhost kernel: [17520.343106]  [<c0608c56>] do_tty_hangup+0xe4/0x2d7
May 20 00:23:54 localhost kernel: [17520.343110]  [<c0448303>] worker_thread+0x1a1/0x272
May 20 00:23:54 localhost kernel: [17520.343113]  [<c04482b9>] ? worker_thread+0x157/0x272
May 20 00:23:54 localhost kernel: [17520.343116]  [<c0608b72>] ? do_tty_hangup+0x0/0x2d7
May 20 00:23:54 localhost kernel: [17520.343119]  [<c044b52b>] ? autoremove_wake_function+0x0/0x33
May 20 00:23:54 localhost kernel: [17520.343122]  [<c0448162>] ? worker_thread+0x0/0x272
May 20 00:23:54 localhost kernel: [17520.343125]  [<c044b1d9>] kthread+0x61/0x66
May 20 00:23:54 localhost kernel: [17520.343137]  [<c044b178>] ? kthread+0x0/0x66
May 20 00:23:54 localhost kernel: [17520.343141]  [<c04035ba>] kernel_thread_helper+0x6/0x1a
May 20 00:23:54 localhost kernel: [17520.343144] 2 locks held by events/1/10:
May 20 00:23:54 localhost kernel: [17520.343146]  #0:  (events){+.+.+.}, at: [<c04482b9>] worker_thread+0x157/0x272
May 20 00:23:54 localhost kernel: [17520.343153]  #1:  ((&tty->hangup_work)#2){+.+...}, at: [<c04482b9>] worker_thread+0x157/0x272
May 20 00:23:54 localhost kernel: [17520.343207] INFO: task X:3782 blocked for more than 120 seconds.
May 20 00:23:54 localhost kernel: [17520.343208] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 20 00:23:54 localhost kernel: [17520.343211] X             D 00000fc4     0  3782   3764 0x00400084
May 20 00:23:54 localhost kernel: [17520.343215]  ec9d1a24 00003092 5fe0c262 00000fc4 00000000 00000001 ebd31720 ebd31230
May 20 00:23:54 localhost kernel: [17520.343225]  c09bb3c0 c09bb3c0 c09bb3c0 ebd31230 ebd31230 ebd314d0 c24083c0 00000000
May 20 00:23:54 localhost kernel: [17520.343234]  0000006a 00000002 00000000 ebd31230 00000000 00000001 00003046 ebd31230
May 20 00:23:54 localhost kernel: [17520.343243] Call Trace:
May 20 00:23:54 localhost kernel: [17520.343248]  [<c0736810>] schedule_timeout+0x16/0x9a
May 20 00:23:54 localhost kernel: [17520.343251]  [<c0736681>] ? wait_for_common+0x31/0xec
May 20 00:23:54 localhost kernel: [17520.343255]  [<c0737ffb>] ? _raw_spin_unlock_irq+0x22/0x2b
May 20 00:23:54 localhost kernel: [17520.343258]  [<c045a074>] ? trace_hardirqs_on_caller+0x10d/0x12e
May 20 00:23:54 localhost kernel: [17520.343262]  [<c045a0a0>] ? trace_hardirqs_on+0xb/0xd
May 20 00:23:54 localhost kernel: [17520.343265]  [<c07366f7>] wait_for_common+0xa7/0xec
May 20 00:23:54 localhost kernel: [17520.343270]  [<c0431bbc>] ? default_wake_function+0x0/0xd
May 20 00:23:54 localhost kernel: [17520.343273]  [<c07367ae>] wait_for_completion+0x12/0x14
May 20 00:23:54 localhost kernel: [17520.343277]  [<c0448c56>] flush_work+0xa1/0xb2
May 20 00:23:54 localhost kernel: [17520.343280]  [<c044865e>] ? wq_barrier_func+0x0/0xd
May 20 00:23:54 localhost kernel: [17520.343283]  [<c0448dc9>] flush_delayed_work+0x40/0x43
May 20 00:23:54 localhost kernel: [17520.343287]  [<c060f4d9>] tty_flush_to_ldisc+0xd/0xf
May 20 00:23:54 localhost kernel: [17520.343290]  [<c060b631>] n_tty_poll+0x54/0x127
May 20 00:23:54 localhost kernel: [17520.343294]  [<c060b5dd>] ? n_tty_poll+0x0/0x127
May 20 00:23:54 localhost kernel: [17520.343297]  [<c0608322>] tty_poll+0x4c/0x62
May 20 00:23:54 localhost kernel: [17520.343301]  [<c04d8907>] do_select+0x3a8/0x5cf
May 20 00:23:54 localhost kernel: [17520.343305]  [<c04d8ed1>] ? __pollwait+0x0/0xac
May 20 00:23:54 localhost kernel: [17520.343309]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 20 00:23:54 localhost kernel: [17520.343312]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 20 00:23:54 localhost kernel: [17520.343315]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 20 00:23:54 localhost kernel: [17520.343318]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 20 00:23:54 localhost kernel: [17520.343321]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 20 00:23:54 localhost kernel: [17520.343325]  [<c04595a3>] ? trace_hardirqs_off+0xb/0xd
May 20 00:23:54 localhost kernel: [17520.343328]  [<c073803c>] ? _raw_spin_unlock_irqrestore+0x38/0x4c
May 20 00:23:54 localhost kernel: [17520.343332]  [<c0431bb1>] ? try_to_wake_up+0x31f/0x32a
May 20 00:23:54 localhost kernel: [17520.343335]  [<c0459029>] ? register_lock_class+0x17/0x2a4
May 20 00:23:54 localhost kernel: [17520.343339]  [<c0459bf5>] ? mark_lock+0x1e/0x1ea
May 20 00:23:54 localhost kernel: [17520.343342]  [<c0459bf5>] ? mark_lock+0x1e/0x1ea
May 20 00:23:54 localhost kernel: [17520.343345]  [<c0459bf5>] ? mark_lock+0x1e/0x1ea
May 20 00:23:54 localhost kernel: [17520.343349]  [<c045af51>] ? __lock_acquire+0x374/0xbb7
May 20 00:23:54 localhost kernel: [17520.343353]  [<c045b9a0>] ? lock_release_non_nested+0x84/0x1db
May 20 00:23:54 localhost kernel: [17520.343357]  [<c04adcfd>] ? might_fault+0x47/0x81
May 20 00:23:54 localhost kernel: [17520.343361]  [<c04adcfd>] ? might_fault+0x47/0x81
May 20 00:23:54 localhost kernel: [17520.343364]  [<c04add32>] ? might_fault+0x7c/0x81
May 20 00:23:54 localhost kernel: [17520.343369]  [<c05b3723>] ? _copy_from_user+0x2d/0x106
May 20 00:23:54 localhost kernel: [17520.343373]  [<c04d7c5c>] ? copy_from_user+0x8/0xa
May 20 00:23:54 localhost kernel: [17520.343376]  [<c04d8c7c>] core_sys_select+0x14e/0x1ce
May 20 00:23:54 localhost kernel: [17520.343380]  [<c04adcfd>] ? might_fault+0x47/0x81
May 20 00:23:54 localhost kernel: [17520.343384]  [<c0452e70>] ? ktime_get_ts+0xd0/0xda
May 20 00:23:54 localhost kernel: [17520.343387]  [<c04d8eb3>] sys_select+0x6e/0x8c
May 20 00:23:54 localhost kernel: [17520.343391]  [<c0738295>] syscall_call+0x7/0xb
May 20 00:23:54 localhost kernel: [17520.343393] no locks held by X/3782.
May 20 00:25:54 localhost kernel: [17640.343015] INFO: task events/1:10 blocked for more than 120 seconds.
May 20 00:25:54 localhost kernel: [17640.343018] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 20 00:25:54 localhost kernel: [17640.343021] events/1      D 00000fc0     0    10      2 0x00000000
May 20 00:25:54 localhost kernel: [17640.343025]  f7097e48 00000082 b19aeb18 00000fc0 f7097e74 c045b644 f7097e74 c045b6c8
May 20 00:25:54 localhost kernel: [17640.343032]  c09bb3c0 c09bb3c0 c09bb3c0 e882a416 f708b690 f708b930 c25083c0 00000001
May 20 00:25:54 localhost kernel: [17640.343039]  f708b690 b19ee045 00000fc0 00000002 00000002 00000001 f708bb88 00004576
May 20 00:25:54 localhost kernel: [17640.343045] Call Trace:
May 20 00:25:54 localhost kernel: [17640.343055]  [<c045b644>] ? __lock_acquire+0xa67/0xbb7
May 20 00:25:54 localhost kernel: [17640.343058]  [<c045b6c8>] ? __lock_acquire+0xaeb/0xbb7
May 20 00:25:54 localhost kernel: [17640.343064]  [<c0736810>] schedule_timeout+0x16/0x9a
May 20 00:25:54 localhost kernel: [17640.343067]  [<c0459e04>] ? mark_held_locks+0x43/0x5b
May 20 00:25:54 localhost kernel: [17640.343071]  [<c0737ffb>] ? _raw_spin_unlock_irq+0x22/0x2b
May 20 00:25:54 localhost kernel: [17640.343074]  [<c045a074>] ? trace_hardirqs_on_caller+0x10d/0x12e
May 20 00:25:54 localhost kernel: [17640.343077]  [<c045a0a0>] ? trace_hardirqs_on+0xb/0xd
May 20 00:25:54 localhost kernel: [17640.343080]  [<c07373ba>] __down_common+0x76/0xad
May 20 00:25:54 localhost kernel: [17640.343084]  [<c073743c>] __down+0x12/0x14
May 20 00:25:54 localhost kernel: [17640.343087]  [<c044f437>] down+0x22/0x2f
May 20 00:25:54 localhost kernel: [17640.343092]  [<fa85cbef>] ppp_asynctty_close+0x4a/0x89 [ppp_async]
May 20 00:25:54 localhost kernel: [17640.343096]  [<fa85cc36>] ppp_asynctty_hangup+0x8/0xc [ppp_async]
May 20 00:25:54 localhost kernel: [17640.343101]  [<c060ec35>] tty_ldisc_hangup+0x64/0x19c
May 20 00:25:54 localhost kernel: [17640.343104]  [<c0608c56>] do_tty_hangup+0xe4/0x2d7
May 20 00:25:54 localhost kernel: [17640.343108]  [<c0448303>] worker_thread+0x1a1/0x272
May 20 00:25:54 localhost kernel: [17640.343111]  [<c04482b9>] ? worker_thread+0x157/0x272
May 20 00:25:54 localhost kernel: [17640.343114]  [<c0608b72>] ? do_tty_hangup+0x0/0x2d7
May 20 00:25:54 localhost kernel: [17640.343118]  [<c044b52b>] ? autoremove_wake_function+0x0/0x33
May 20 00:25:54 localhost kernel: [17640.343121]  [<c0448162>] ? worker_thread+0x0/0x272
May 20 00:25:54 localhost kernel: [17640.343124]  [<c044b1d9>] kthread+0x61/0x66
May 20 00:25:54 localhost kernel: [17640.343135]  [<c044b178>] ? kthread+0x0/0x66
May 20 00:25:54 localhost kernel: [17640.343140]  [<c04035ba>] kernel_thread_helper+0x6/0x1a
May 20 00:25:54 localhost kernel: [17640.343143] 2 locks held by events/1/10:
May 20 00:25:54 localhost kernel: [17640.343145]  #0:  (events){+.+.+.}, at: [<c04482b9>] worker_thread+0x157/0x272
May 20 00:25:54 localhost kernel: [17640.343152]  #1:  ((&tty->hangup_work)#2){+.+...}, at: [<c04482b9>] worker_thread+0x157/0x272
May 20 00:25:54 localhost kernel: [17640.343206] INFO: task X:3782 blocked for more than 120 seconds.
May 20 00:25:54 localhost kernel: [17640.343208] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 20 00:25:54 localhost kernel: [17640.343210] X             D 00000fc4     0  3782   3764 0x00400084
May 20 00:25:54 localhost kernel: [17640.343215]  ec9d1a24 00003092 5fe0c262 00000fc4 00000000 00000001 ebd31720 ebd31230
May 20 00:25:54 localhost kernel: [17640.343224]  c09bb3c0 c09bb3c0 c09bb3c0 ebd31230 ebd31230 ebd314d0 c24083c0 00000000
May 20 00:25:54 localhost kernel: [17640.343233]  0000006a 00000002 00000000 ebd31230 00000000 00000001 00003046 ebd31230
May 20 00:25:54 localhost kernel: [17640.343242] Call Trace:
May 20 00:25:54 localhost kernel: [17640.343247]  [<c0736810>] schedule_timeout+0x16/0x9a
May 20 00:25:54 localhost kernel: [17640.343251]  [<c0736681>] ? wait_for_common+0x31/0xec
May 20 00:25:54 localhost kernel: [17640.343254]  [<c0737ffb>] ? _raw_spin_unlock_irq+0x22/0x2b
May 20 00:25:54 localhost kernel: [17640.343258]  [<c045a074>] ? trace_hardirqs_on_caller+0x10d/0x12e
May 20 00:25:54 localhost kernel: [17640.343261]  [<c045a0a0>] ? trace_hardirqs_on+0xb/0xd
May 20 00:25:54 localhost kernel: [17640.343265]  [<c07366f7>] wait_for_common+0xa7/0xec
May 20 00:25:54 localhost kernel: [17640.343269]  [<c0431bbc>] ? default_wake_function+0x0/0xd
May 20 00:25:54 localhost kernel: [17640.343273]  [<c07367ae>] wait_for_completion+0x12/0x14
May 20 00:25:54 localhost kernel: [17640.343276]  [<c0448c56>] flush_work+0xa1/0xb2
May 20 00:25:54 localhost kernel: [17640.343280]  [<c044865e>] ? wq_barrier_func+0x0/0xd
May 20 00:25:54 localhost kernel: [17640.343283]  [<c0448dc9>] flush_delayed_work+0x40/0x43
May 20 00:25:54 localhost kernel: [17640.343287]  [<c060f4d9>] tty_flush_to_ldisc+0xd/0xf
May 20 00:25:54 localhost kernel: [17640.343290]  [<c060b631>] n_tty_poll+0x54/0x127
May 20 00:25:54 localhost kernel: [17640.343294]  [<c060b5dd>] ? n_tty_poll+0x0/0x127
May 20 00:25:54 localhost kernel: [17640.343297]  [<c0608322>] tty_poll+0x4c/0x62
May 20 00:25:54 localhost kernel: [17640.343301]  [<c04d8907>] do_select+0x3a8/0x5cf
May 20 00:25:54 localhost kernel: [17640.343305]  [<c04d8ed1>] ? __pollwait+0x0/0xac
May 20 00:25:54 localhost kernel: [17640.343308]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 20 00:25:54 localhost kernel: [17640.343311]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 20 00:25:54 localhost kernel: [17640.343315]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 20 00:25:54 localhost kernel: [17640.343318]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 20 00:25:54 localhost kernel: [17640.343321]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 20 00:25:54 localhost kernel: [17640.343324]  [<c04595a3>] ? trace_hardirqs_off+0xb/0xd
May 20 00:25:54 localhost kernel: [17640.343328]  [<c073803c>] ? _raw_spin_unlock_irqrestore+0x38/0x4c
May 20 00:25:54 localhost kernel: [17640.343331]  [<c0431bb1>] ? try_to_wake_up+0x31f/0x32a
May 20 00:25:54 localhost kernel: [17640.343335]  [<c0459029>] ? register_lock_class+0x17/0x2a4
May 20 00:25:54 localhost kernel: [17640.343338]  [<c0459bf5>] ? mark_lock+0x1e/0x1ea
May 20 00:25:54 localhost kernel: [17640.343341]  [<c0459bf5>] ? mark_lock+0x1e/0x1ea
May 20 00:25:54 localhost kernel: [17640.343345]  [<c0459bf5>] ? mark_lock+0x1e/0x1ea
May 20 00:25:54 localhost kernel: [17640.343348]  [<c045af51>] ? __lock_acquire+0x374/0xbb7
May 20 00:25:54 localhost kernel: [17640.343352]  [<c045b9a0>] ? lock_release_non_nested+0x84/0x1db
May 20 00:25:54 localhost kernel: [17640.343357]  [<c04adcfd>] ? might_fault+0x47/0x81
May 20 00:25:54 localhost kernel: [17640.343360]  [<c04adcfd>] ? might_fault+0x47/0x81
May 20 00:25:54 localhost kernel: [17640.343364]  [<c04add32>] ? might_fault+0x7c/0x81
May 20 00:25:54 localhost kernel: [17640.343368]  [<c05b3723>] ? _copy_from_user+0x2d/0x106
May 20 00:25:54 localhost kernel: [17640.343372]  [<c04d7c5c>] ? copy_from_user+0x8/0xa
May 20 00:25:54 localhost kernel: [17640.343375]  [<c04d8c7c>] core_sys_select+0x14e/0x1ce
May 20 00:25:54 localhost kernel: [17640.343379]  [<c04adcfd>] ? might_fault+0x47/0x81
May 20 00:25:54 localhost kernel: [17640.343383]  [<c0452e70>] ? ktime_get_ts+0xd0/0xda
May 20 00:25:54 localhost kernel: [17640.343386]  [<c04d8eb3>] sys_select+0x6e/0x8c
May 20 00:25:54 localhost kernel: [17640.343389]  [<c0738295>] syscall_call+0x7/0xb
May 20 00:25:54 localhost kernel: [17640.343392] no locks held by X/3782.
May 20 00:27:54 localhost kernel: [17760.343015] INFO: task events/1:10 blocked for more than 120 seconds.
May 20 00:27:54 localhost kernel: [17760.343018] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 20 00:27:54 localhost kernel: [17760.343021] events/1      D 00000fc0     0    10      2 0x00000000
May 20 00:27:54 localhost kernel: [17760.343025]  f7097e48 00000082 b19aeb18 00000fc0 f7097e74 c045b644 f7097e74 c045b6c8
May 20 00:27:54 localhost kernel: [17760.343033]  c09bb3c0 c09bb3c0 c09bb3c0 e882a416 f708b690 f708b930 c25083c0 00000001
May 20 00:27:54 localhost kernel: [17760.343039]  f708b690 b19ee045 00000fc0 00000002 00000002 00000001 f708bb88 00004576
May 20 00:27:54 localhost kernel: [17760.343046] Call Trace:
May 20 00:27:54 localhost kernel: [17760.343055]  [<c045b644>] ? __lock_acquire+0xa67/0xbb7
May 20 00:27:54 localhost kernel: [17760.343059]  [<c045b6c8>] ? __lock_acquire+0xaeb/0xbb7
May 20 00:27:54 localhost kernel: [17760.343064]  [<c0736810>] schedule_timeout+0x16/0x9a
May 20 00:27:54 localhost kernel: [17760.343068]  [<c0459e04>] ? mark_held_locks+0x43/0x5b
May 20 00:27:54 localhost kernel: [17760.343071]  [<c0737ffb>] ? _raw_spin_unlock_irq+0x22/0x2b
May 20 00:27:54 localhost kernel: [17760.343075]  [<c045a074>] ? trace_hardirqs_on_caller+0x10d/0x12e
May 20 00:27:54 localhost kernel: [17760.343078]  [<c045a0a0>] ? trace_hardirqs_on+0xb/0xd
May 20 00:27:54 localhost kernel: [17760.343081]  [<c07373ba>] __down_common+0x76/0xad
May 20 00:27:54 localhost kernel: [17760.343084]  [<c073743c>] __down+0x12/0x14
May 20 00:27:54 localhost kernel: [17760.343088]  [<c044f437>] down+0x22/0x2f
May 20 00:27:54 localhost kernel: [17760.343093]  [<fa85cbef>] ppp_asynctty_close+0x4a/0x89 [ppp_async]
May 20 00:27:54 localhost kernel: [17760.343096]  [<fa85cc36>] ppp_asynctty_hangup+0x8/0xc [ppp_async]
May 20 00:27:54 localhost kernel: [17760.343101]  [<c060ec35>] tty_ldisc_hangup+0x64/0x19c
May 20 00:27:54 localhost kernel: [17760.343104]  [<c0608c56>] do_tty_hangup+0xe4/0x2d7
May 20 00:27:54 localhost kernel: [17760.343108]  [<c0448303>] worker_thread+0x1a1/0x272
May 20 00:27:54 localhost kernel: [17760.343111]  [<c04482b9>] ? worker_thread+0x157/0x272
May 20 00:27:54 localhost kernel: [17760.343114]  [<c0608b72>] ? do_tty_hangup+0x0/0x2d7
May 20 00:27:54 localhost kernel: [17760.343118]  [<c044b52b>] ? autoremove_wake_function+0x0/0x33
May 20 00:27:54 localhost kernel: [17760.343121]  [<c0448162>] ? worker_thread+0x0/0x272
May 20 00:27:54 localhost kernel: [17760.343124]  [<c044b1d9>] kthread+0x61/0x66
May 20 00:27:54 localhost kernel: [17760.343134]  [<c044b178>] ? kthread+0x0/0x66
May 20 00:27:54 localhost kernel: [17760.343139]  [<c04035ba>] kernel_thread_helper+0x6/0x1a
May 20 00:27:54 localhost kernel: [17760.343142] 2 locks held by events/1/10:
May 20 00:27:54 localhost kernel: [17760.343143]  #0:  (events){+.+.+.}, at: [<c04482b9>] worker_thread+0x157/0x272
May 20 00:27:54 localhost kernel: [17760.343151]  #1:  ((&tty->hangup_work)#2){+.+...}, at: [<c04482b9>] worker_thread+0x157/0x272
May 20 00:27:54 localhost kernel: [17760.343204] INFO: task X:3782 blocked for more than 120 seconds.
May 20 00:27:54 localhost kernel: [17760.343206] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 20 00:27:54 localhost kernel: [17760.343208] X             D 00000fc4     0  3782   3764 0x00400084
May 20 00:27:54 localhost kernel: [17760.343213]  ec9d1a24 00003092 5fe0c262 00000fc4 00000000 00000001 ebd31720 ebd31230
May 20 00:27:54 localhost kernel: [17760.343222]  c09bb3c0 c09bb3c0 c09bb3c0 ebd31230 ebd31230 ebd314d0 c24083c0 00000000
May 20 00:27:54 localhost kernel: [17760.343232]  0000006a 00000002 00000000 ebd31230 00000000 00000001 00003046 ebd31230
May 20 00:27:54 localhost kernel: [17760.343241] Call Trace:
May 20 00:27:54 localhost kernel: [17760.343246]  [<c0736810>] schedule_timeout+0x16/0x9a
May 20 00:27:54 localhost kernel: [17760.343249]  [<c0736681>] ? wait_for_common+0x31/0xec
May 20 00:27:54 localhost kernel: [17760.343253]  [<c0737ffb>] ? _raw_spin_unlock_irq+0x22/0x2b
May 20 00:27:54 localhost kernel: [17760.343257]  [<c045a074>] ? trace_hardirqs_on_caller+0x10d/0x12e
May 20 00:27:54 localhost kernel: [17760.343260]  [<c045a0a0>] ? trace_hardirqs_on+0xb/0xd
May 20 00:27:54 localhost kernel: [17760.343264]  [<c07366f7>] wait_for_common+0xa7/0xec
May 20 00:27:54 localhost kernel: [17760.343268]  [<c0431bbc>] ? default_wake_function+0x0/0xd
May 20 00:27:54 localhost kernel: [17760.343272]  [<c07367ae>] wait_for_completion+0x12/0x14
May 20 00:27:54 localhost kernel: [17760.343275]  [<c0448c56>] flush_work+0xa1/0xb2
May 20 00:27:54 localhost kernel: [17760.343278]  [<c044865e>] ? wq_barrier_func+0x0/0xd
May 20 00:27:54 localhost kernel: [17760.343282]  [<c0448dc9>] flush_delayed_work+0x40/0x43
May 20 00:27:54 localhost kernel: [17760.343286]  [<c060f4d9>] tty_flush_to_ldisc+0xd/0xf
May 20 00:27:54 localhost kernel: [17760.343289]  [<c060b631>] n_tty_poll+0x54/0x127
May 20 00:27:54 localhost kernel: [17760.343292]  [<c060b5dd>] ? n_tty_poll+0x0/0x127
May 20 00:27:54 localhost kernel: [17760.343296]  [<c0608322>] tty_poll+0x4c/0x62
May 20 00:27:54 localhost kernel: [17760.343300]  [<c04d8907>] do_select+0x3a8/0x5cf
May 20 00:27:54 localhost kernel: [17760.343304]  [<c04d8ed1>] ? __pollwait+0x0/0xac
May 20 00:27:54 localhost kernel: [17760.343307]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 20 00:27:54 localhost kernel: [17760.343310]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 20 00:27:54 localhost kernel: [17760.343313]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 20 00:27:54 localhost kernel: [17760.343317]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 20 00:27:54 localhost kernel: [17760.343320]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 20 00:27:54 localhost kernel: [17760.343323]  [<c04595a3>] ? trace_hardirqs_off+0xb/0xd
May 20 00:27:54 localhost kernel: [17760.343327]  [<c073803c>] ? _raw_spin_unlock_irqrestore+0x38/0x4c
May 20 00:27:54 localhost kernel: [17760.343330]  [<c0431bb1>] ? try_to_wake_up+0x31f/0x32a
May 20 00:27:54 localhost kernel: [17760.343334]  [<c0459029>] ? register_lock_class+0x17/0x2a4
May 20 00:27:54 localhost kernel: [17760.343337]  [<c0459bf5>] ? mark_lock+0x1e/0x1ea
May 20 00:27:54 localhost kernel: [17760.343341]  [<c0459bf5>] ? mark_lock+0x1e/0x1ea
May 20 00:27:54 localhost kernel: [17760.343344]  [<c0459bf5>] ? mark_lock+0x1e/0x1ea
May 20 00:27:54 localhost kernel: [17760.343348]  [<c045af51>] ? __lock_acquire+0x374/0xbb7
May 20 00:27:54 localhost kernel: [17760.343351]  [<c045b9a0>] ? lock_release_non_nested+0x84/0x1db
May 20 00:27:54 localhost kernel: [17760.343356]  [<c04adcfd>] ? might_fault+0x47/0x81
May 20 00:27:54 localhost kernel: [17760.343360]  [<c04adcfd>] ? might_fault+0x47/0x81
May 20 00:27:54 localhost kernel: [17760.343363]  [<c04add32>] ? might_fault+0x7c/0x81
May 20 00:27:54 localhost kernel: [17760.343368]  [<c05b3723>] ? _copy_from_user+0x2d/0x106
May 20 00:27:54 localhost kernel: [17760.343372]  [<c04d7c5c>] ? copy_from_user+0x8/0xa
May 20 00:27:54 localhost kernel: [17760.343375]  [<c04d8c7c>] core_sys_select+0x14e/0x1ce
May 20 00:27:54 localhost kernel: [17760.343379]  [<c04adcfd>] ? might_fault+0x47/0x81
May 20 00:27:54 localhost kernel: [17760.343383]  [<c0452e70>] ? ktime_get_ts+0xd0/0xda
May 20 00:27:54 localhost kernel: [17760.343386]  [<c04d8eb3>] sys_select+0x6e/0x8c
May 20 00:27:54 localhost kernel: [17760.343389]  [<c0738295>] syscall_call+0x7/0xb
May 20 00:27:54 localhost kernel: [17760.343392] no locks held by X/3782.
May 20 00:29:54 localhost kernel: [17880.343017] INFO: task events/1:10 blocked for more than 120 seconds.
May 20 00:29:54 localhost kernel: [17880.343020] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 20 00:29:54 localhost kernel: [17880.343023] events/1      D 00000fc0     0    10      2 0x00000000
May 20 00:29:54 localhost kernel: [17880.343028]  f7097e48 00000082 b19aeb18 00000fc0 f7097e74 c045b644 f7097e74 c045b6c8
May 20 00:29:54 localhost kernel: [17880.343035]  c09bb3c0 c09bb3c0 c09bb3c0 e882a416 f708b690 f708b930 c25083c0 00000001
May 20 00:29:54 localhost kernel: [17880.343041]  f708b690 b19ee045 00000fc0 00000002 00000002 00000001 f708bb88 00004576
May 20 00:29:54 localhost kernel: [17880.343048] Call Trace:
May 20 00:29:54 localhost kernel: [17880.343058]  [<c045b644>] ? __lock_acquire+0xa67/0xbb7
May 20 00:29:54 localhost kernel: [17880.343061]  [<c045b6c8>] ? __lock_acquire+0xaeb/0xbb7
May 20 00:29:54 localhost kernel: [17880.343067]  [<c0736810>] schedule_timeout+0x16/0x9a
May 20 00:29:54 localhost kernel: [17880.343071]  [<c0459e04>] ? mark_held_locks+0x43/0x5b
May 20 00:29:54 localhost kernel: [17880.343074]  [<c0737ffb>] ? _raw_spin_unlock_irq+0x22/0x2b
May 20 00:29:54 localhost kernel: [17880.343077]  [<c045a074>] ? trace_hardirqs_on_caller+0x10d/0x12e
May 20 00:29:54 localhost kernel: [17880.343081]  [<c045a0a0>] ? trace_hardirqs_on+0xb/0xd
May 20 00:29:54 localhost kernel: [17880.343084]  [<c07373ba>] __down_common+0x76/0xad
May 20 00:29:54 localhost kernel: [17880.343087]  [<c073743c>] __down+0x12/0x14
May 20 00:29:54 localhost kernel: [17880.343091]  [<c044f437>] down+0x22/0x2f
May 20 00:29:54 localhost kernel: [17880.343096]  [<fa85cbef>] ppp_asynctty_close+0x4a/0x89 [ppp_async]
May 20 00:29:54 localhost kernel: [17880.343100]  [<fa85cc36>] ppp_asynctty_hangup+0x8/0xc [ppp_async]
May 20 00:29:54 localhost kernel: [17880.343105]  [<c060ec35>] tty_ldisc_hangup+0x64/0x19c
May 20 00:29:54 localhost kernel: [17880.343108]  [<c0608c56>] do_tty_hangup+0xe4/0x2d7
May 20 00:29:54 localhost kernel: [17880.343112]  [<c0448303>] worker_thread+0x1a1/0x272
May 20 00:29:54 localhost kernel: [17880.343115]  [<c04482b9>] ? worker_thread+0x157/0x272
May 20 00:29:54 localhost kernel: [17880.343118]  [<c0608b72>] ? do_tty_hangup+0x0/0x2d7
May 20 00:29:54 localhost kernel: [17880.343122]  [<c044b52b>] ? autoremove_wake_function+0x0/0x33
May 20 00:29:54 localhost kernel: [17880.343125]  [<c0448162>] ? worker_thread+0x0/0x272
May 20 00:29:54 localhost kernel: [17880.343136]  [<c044b1d9>] kthread+0x61/0x66
May 20 00:29:54 localhost kernel: [17880.343140]  [<c044b178>] ? kthread+0x0/0x66
May 20 00:29:54 localhost kernel: [17880.343144]  [<c04035ba>] kernel_thread_helper+0x6/0x1a
May 20 00:29:54 localhost kernel: [17880.343147] 2 locks held by events/1/10:
May 20 00:29:54 localhost kernel: [17880.343149]  #0:  (events){+.+.+.}, at: [<c04482b9>] worker_thread+0x157/0x272
May 20 00:29:54 localhost kernel: [17880.343156]  #1:  ((&tty->hangup_work)#2){+.+...}, at: [<c04482b9>] worker_thread+0x157/0x272
May 20 00:29:54 localhost kernel: [17880.343208] INFO: task X:3782 blocked for more than 120 seconds.
May 20 00:29:54 localhost kernel: [17880.343210] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 20 00:29:54 localhost kernel: [17880.343213] X             D 00000fc4     0  3782   3764 0x00400084
May 20 00:29:54 localhost kernel: [17880.343218]  ec9d1a24 00003092 5fe0c262 00000fc4 00000000 00000001 ebd31720 ebd31230
May 20 00:29:54 localhost kernel: [17880.343227]  c09bb3c0 c09bb3c0 c09bb3c0 ebd31230 ebd31230 ebd314d0 c24083c0 00000000
May 20 00:29:54 localhost kernel: [17880.343236]  0000006a 00000002 00000000 ebd31230 00000000 00000001 00003046 ebd31230
May 20 00:29:54 localhost kernel: [17880.343245] Call Trace:
May 20 00:29:54 localhost kernel: [17880.343250]  [<c0736810>] schedule_timeout+0x16/0x9a
May 20 00:29:54 localhost kernel: [17880.343254]  [<c0736681>] ? wait_for_common+0x31/0xec
May 20 00:29:54 localhost kernel: [17880.343257]  [<c0737ffb>] ? _raw_spin_unlock_irq+0x22/0x2b
May 20 00:29:54 localhost kernel: [17880.343261]  [<c045a074>] ? trace_hardirqs_on_caller+0x10d/0x12e
May 20 00:29:54 localhost kernel: [17880.343264]  [<c045a0a0>] ? trace_hardirqs_on+0xb/0xd
May 20 00:29:54 localhost kernel: [17880.343268]  [<c07366f7>] wait_for_common+0xa7/0xec
May 20 00:29:54 localhost kernel: [17880.343272]  [<c0431bbc>] ? default_wake_function+0x0/0xd
May 20 00:29:54 localhost kernel: [17880.343276]  [<c07367ae>] wait_for_completion+0x12/0x14
May 20 00:29:54 localhost kernel: [17880.343279]  [<c0448c56>] flush_work+0xa1/0xb2
May 20 00:29:54 localhost kernel: [17880.343282]  [<c044865e>] ? wq_barrier_func+0x0/0xd
May 20 00:29:54 localhost kernel: [17880.343286]  [<c0448dc9>] flush_delayed_work+0x40/0x43
May 20 00:29:54 localhost kernel: [17880.343290]  [<c060f4d9>] tty_flush_to_ldisc+0xd/0xf
May 20 00:29:54 localhost kernel: [17880.343294]  [<c060b631>] n_tty_poll+0x54/0x127
May 20 00:29:54 localhost kernel: [17880.343297]  [<c060b5dd>] ? n_tty_poll+0x0/0x127
May 20 00:29:54 localhost kernel: [17880.343300]  [<c0608322>] tty_poll+0x4c/0x62
May 20 00:29:54 localhost kernel: [17880.343304]  [<c04d8907>] do_select+0x3a8/0x5cf
May 20 00:29:54 localhost kernel: [17880.343308]  [<c04d8ed1>] ? __pollwait+0x0/0xac
May 20 00:29:54 localhost kernel: [17880.343312]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 20 00:29:54 localhost kernel: [17880.343315]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 20 00:29:54 localhost kernel: [17880.343318]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 20 00:29:54 localhost kernel: [17880.343321]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 20 00:29:54 localhost kernel: [17880.343324]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 20 00:29:54 localhost kernel: [17880.343328]  [<c04595a3>] ? trace_hardirqs_off+0xb/0xd
May 20 00:29:54 localhost kernel: [17880.343331]  [<c073803c>] ? _raw_spin_unlock_irqrestore+0x38/0x4c
May 20 00:29:54 localhost kernel: [17880.343335]  [<c0431bb1>] ? try_to_wake_up+0x31f/0x32a
May 20 00:29:54 localhost kernel: [17880.343338]  [<c0459029>] ? register_lock_class+0x17/0x2a4
May 20 00:29:54 localhost kernel: [17880.343341]  [<c0459bf5>] ? mark_lock+0x1e/0x1ea
May 20 00:29:54 localhost kernel: [17880.343345]  [<c0459bf5>] ? mark_lock+0x1e/0x1ea
May 20 00:29:54 localhost kernel: [17880.343348]  [<c0459bf5>] ? mark_lock+0x1e/0x1ea
May 20 00:29:54 localhost kernel: [17880.343352]  [<c045af51>] ? __lock_acquire+0x374/0xbb7
May 20 00:29:54 localhost kernel: [17880.343356]  [<c045b9a0>] ? lock_release_non_nested+0x84/0x1db
May 20 00:29:54 localhost kernel: [17880.343360]  [<c04adcfd>] ? might_fault+0x47/0x81
May 20 00:29:54 localhost kernel: [17880.343364]  [<c04adcfd>] ? might_fault+0x47/0x81
May 20 00:29:54 localhost kernel: [17880.343367]  [<c04add32>] ? might_fault+0x7c/0x81
May 20 00:29:54 localhost kernel: [17880.343372]  [<c05b3723>] ? _copy_from_user+0x2d/0x106
May 20 00:29:54 localhost kernel: [17880.343376]  [<c04d7c5c>] ? copy_from_user+0x8/0xa
May 20 00:29:54 localhost kernel: [17880.343379]  [<c04d8c7c>] core_sys_select+0x14e/0x1ce
May 20 00:29:54 localhost kernel: [17880.343384]  [<c04adcfd>] ? might_fault+0x47/0x81
May 20 00:29:54 localhost kernel: [17880.343387]  [<c0452e70>] ? ktime_get_ts+0xd0/0xda
May 20 00:29:54 localhost kernel: [17880.343390]  [<c04d8eb3>] sys_select+0x6e/0x8c
May 20 00:29:54 localhost kernel: [17880.343394]  [<c0738295>] syscall_call+0x7/0xb
May 20 00:29:54 localhost kernel: [17880.343396] no locks held by X/3782.
May 20 00:31:54 localhost kernel: [18000.343016] INFO: task events/1:10 blocked for more than 120 seconds.
May 20 00:31:54 localhost kernel: [18000.343019] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 20 00:31:54 localhost kernel: [18000.343022] events/1      D 00000fc0     0    10      2 0x00000000
May 20 00:31:54 localhost kernel: [18000.343027]  f7097e48 00000082 b19aeb18 00000fc0 f7097e74 c045b644 f7097e74 c045b6c8
May 20 00:31:54 localhost kernel: [18000.343034]  c09bb3c0 c09bb3c0 c09bb3c0 e882a416 f708b690 f708b930 c25083c0 00000001
May 20 00:31:54 localhost kernel: [18000.343041]  f708b690 b19ee045 00000fc0 00000002 00000002 00000001 f708bb88 00004576
May 20 00:31:54 localhost kernel: [18000.343047] Call Trace:
May 20 00:31:54 localhost kernel: [18000.343056]  [<c045b644>] ? __lock_acquire+0xa67/0xbb7
May 20 00:31:54 localhost kernel: [18000.343060]  [<c045b6c8>] ? __lock_acquire+0xaeb/0xbb7
May 20 00:31:54 localhost kernel: [18000.343066]  [<c0736810>] schedule_timeout+0x16/0x9a
May 20 00:31:54 localhost kernel: [18000.343069]  [<c0459e04>] ? mark_held_locks+0x43/0x5b
May 20 00:31:54 localhost kernel: [18000.343073]  [<c0737ffb>] ? _raw_spin_unlock_irq+0x22/0x2b
May 20 00:31:54 localhost kernel: [18000.343076]  [<c045a074>] ? trace_hardirqs_on_caller+0x10d/0x12e
May 20 00:31:54 localhost kernel: [18000.343079]  [<c045a0a0>] ? trace_hardirqs_on+0xb/0xd
May 20 00:31:54 localhost kernel: [18000.343082]  [<c07373ba>] __down_common+0x76/0xad
May 20 00:31:54 localhost kernel: [18000.343085]  [<c073743c>] __down+0x12/0x14
May 20 00:31:54 localhost kernel: [18000.343089]  [<c044f437>] down+0x22/0x2f
May 20 00:31:54 localhost kernel: [18000.343094]  [<fa85cbef>] ppp_asynctty_close+0x4a/0x89 [ppp_async]
May 20 00:31:54 localhost kernel: [18000.343098]  [<fa85cc36>] ppp_asynctty_hangup+0x8/0xc [ppp_async]
May 20 00:31:54 localhost kernel: [18000.343103]  [<c060ec35>] tty_ldisc_hangup+0x64/0x19c
May 20 00:31:54 localhost kernel: [18000.343106]  [<c0608c56>] do_tty_hangup+0xe4/0x2d7
May 20 00:31:54 localhost kernel: [18000.343110]  [<c0448303>] worker_thread+0x1a1/0x272
May 20 00:31:54 localhost kernel: [18000.343113]  [<c04482b9>] ? worker_thread+0x157/0x272
May 20 00:31:54 localhost kernel: [18000.343116]  [<c0608b72>] ? do_tty_hangup+0x0/0x2d7
May 20 00:31:54 localhost kernel: [18000.343120]  [<c044b52b>] ? autoremove_wake_function+0x0/0x33
May 20 00:31:54 localhost kernel: [18000.343123]  [<c0448162>] ? worker_thread+0x0/0x272
May 20 00:31:54 localhost kernel: [18000.343134]  [<c044b1d9>] kthread+0x61/0x66
May 20 00:31:54 localhost kernel: [18000.343137]  [<c044b178>] ? kthread+0x0/0x66
May 20 00:31:54 localhost kernel: [18000.343142]  [<c04035ba>] kernel_thread_helper+0x6/0x1a
May 20 00:31:54 localhost kernel: [18000.343145] 2 locks held by events/1/10:
May 20 00:31:54 localhost kernel: [18000.343147]  #0:  (events){+.+.+.}, at: [<c04482b9>] worker_thread+0x157/0x272
May 20 00:31:54 localhost kernel: [18000.343154]  #1:  ((&tty->hangup_work)#2){+.+...}, at: [<c04482b9>] worker_thread+0x157/0x272
May 20 00:31:54 localhost kernel: [18000.343207] INFO: task X:3782 blocked for more than 120 seconds.
May 20 00:31:54 localhost kernel: [18000.343209] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 20 00:31:54 localhost kernel: [18000.343212] X             D 00000fc4     0  3782   3764 0x00400084
May 20 00:31:54 localhost kernel: [18000.343217]  ec9d1a24 00003092 5fe0c262 00000fc4 00000000 00000001 ebd31720 ebd31230
May 20 00:31:54 localhost kernel: [18000.343226]  c09bb3c0 c09bb3c0 c09bb3c0 ebd31230 ebd31230 ebd314d0 c24083c0 00000000
May 20 00:31:54 localhost kernel: [18000.343235]  0000006a 00000002 00000000 ebd31230 00000000 00000001 00003046 ebd31230
May 20 00:31:54 localhost kernel: [18000.343245] Call Trace:
May 20 00:31:54 localhost kernel: [18000.343249]  [<c0736810>] schedule_timeout+0x16/0x9a
May 20 00:31:54 localhost kernel: [18000.343253]  [<c0736681>] ? wait_for_common+0x31/0xec
May 20 00:31:54 localhost kernel: [18000.343256]  [<c0737ffb>] ? _raw_spin_unlock_irq+0x22/0x2b
May 20 00:31:54 localhost kernel: [18000.343260]  [<c045a074>] ? trace_hardirqs_on_caller+0x10d/0x12e
May 20 00:31:54 localhost kernel: [18000.343264]  [<c045a0a0>] ? trace_hardirqs_on+0xb/0xd
May 20 00:31:54 localhost kernel: [18000.343267]  [<c07366f7>] wait_for_common+0xa7/0xec
May 20 00:31:54 localhost kernel: [18000.343272]  [<c0431bbc>] ? default_wake_function+0x0/0xd
May 20 00:31:54 localhost kernel: [18000.343275]  [<c07367ae>] wait_for_completion+0x12/0x14
May 20 00:31:54 localhost kernel: [18000.343279]  [<c0448c56>] flush_work+0xa1/0xb2
May 20 00:31:54 localhost kernel: [18000.343282]  [<c044865e>] ? wq_barrier_func+0x0/0xd
May 20 00:31:54 localhost kernel: [18000.343285]  [<c0448dc9>] flush_delayed_work+0x40/0x43
May 20 00:31:54 localhost kernel: [18000.343289]  [<c060f4d9>] tty_flush_to_ldisc+0xd/0xf
May 20 00:31:54 localhost kernel: [18000.343293]  [<c060b631>] n_tty_poll+0x54/0x127
May 20 00:31:54 localhost kernel: [18000.343296]  [<c060b5dd>] ? n_tty_poll+0x0/0x127
May 20 00:31:54 localhost kernel: [18000.343299]  [<c0608322>] tty_poll+0x4c/0x62
May 20 00:31:54 localhost kernel: [18000.343303]  [<c04d8907>] do_select+0x3a8/0x5cf
May 20 00:31:54 localhost kernel: [18000.343307]  [<c04d8ed1>] ? __pollwait+0x0/0xac
May 20 00:31:54 localhost kernel: [18000.343311]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 20 00:31:54 localhost kernel: [18000.343314]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 20 00:31:54 localhost kernel: [18000.343317]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 20 00:31:54 localhost kernel: [18000.343320]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 20 00:31:54 localhost kernel: [18000.343323]  [<c04d8f7d>] ? pollwake+0x0/0x63
May 20 00:31:54 localhost kernel: [18000.343327]  [<c04595a3>] ? trace_hardirqs_off+0xb/0xd
May 20 00:31:54 localhost kernel: [18000.343330]  [<c073803c>] ? _raw_spin_unlock_irqrestore+0x38/0x4c
May 20 00:31:54 localhost kernel: [18000.343334]  [<c0431bb1>] ? try_to_wake_up+0x31f/0x32a
May 20 00:31:54 localhost kernel: [18000.343338]  [<c0459029>] ? register_lock_class+0x17/0x2a4
May 20 00:31:54 localhost kernel: [18000.343341]  [<c0459bf5>] ? mark_lock+0x1e/0x1ea
May 20 00:31:54 localhost kernel: [18000.343344]  [<c0459bf5>] ? mark_lock+0x1e/0x1ea
May 20 00:31:54 localhost kernel: [18000.343348]  [<c0459bf5>] ? mark_lock+0x1e/0x1ea
May 20 00:31:54 localhost kernel: [18000.343351]  [<c045af51>] ? __lock_acquire+0x374/0xbb7
May 20 00:31:54 localhost kernel: [18000.343355]  [<c045b9a0>] ? lock_release_non_nested+0x84/0x1db
May 20 00:31:54 localhost kernel: [18000.343360]  [<c04adcfd>] ? might_fault+0x47/0x81
May 20 00:31:54 localhost kernel: [18000.343363]  [<c04adcfd>] ? might_fault+0x47/0x81
May 20 00:31:54 localhost kernel: [18000.343367]  [<c04add32>] ? might_fault+0x7c/0x81
May 20 00:31:54 localhost kernel: [18000.343372]  [<c05b3723>] ? _copy_from_user+0x2d/0x106
May 20 00:31:54 localhost kernel: [18000.343375]  [<c04d7c5c>] ? copy_from_user+0x8/0xa
May 20 00:31:54 localhost kernel: [18000.343379]  [<c04d8c7c>] core_sys_select+0x14e/0x1ce
May 20 00:31:54 localhost kernel: [18000.343383]  [<c04adcfd>] ? might_fault+0x47/0x81
May 20 00:31:54 localhost kernel: [18000.343386]  [<c0452e70>] ? ktime_get_ts+0xd0/0xda
May 20 00:31:54 localhost kernel: [18000.343390]  [<c04d8eb3>] sys_select+0x6e/0x8c
May 20 00:31:54 localhost kernel: [18000.343393]  [<c0738295>] syscall_call+0x7/0xb
May 20 00:31:54 localhost kernel: [18000.343396] no locks held by X/3782.

Regards
Richard
