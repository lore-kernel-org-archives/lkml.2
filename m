Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab2A1PeG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 10:34:06 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58256 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab2A1Pdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 10:33:37 -0500
MIME-Version: 1.0
Date: Sat, 28 Jan 2012 13:33:36 -0200
Message-ID: <CAC22fU0Tzq0pJOh3JOyfsHoUpEX2E=8=e2=daJ04i0onadJdwg@mail.gmail.com>
Subject: task blocked on page_fault and epoll_wait for more than 120 seconds
From: Robert Pipca <robertpipca@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a AIO-based webcache on an ISP.

When traffic peaks on traffic higher 100Mbps with 14.000 packets per
second, I started getting these on dmesg:


cached         D ffff880321861670     0  1177  29036 0x00000000
 ffff880395b59e20 0000000000000082 ffffea0008314b00 ffff880395b59fd8
 0000000000012580 ffff880395b59fd8 ffff880321861670 0000000000012580
 0000000000012580 0000000000012580 0000000000012580 ffff880321861670
Call Trace:
 [<ffffffff81522d3b>] rwsem_down_failed_common+0x96/0xc8
 [<ffffffff81522dbd>] rwsem_down_read_failed+0x26/0x30
 [<ffffffff81036128>] ? get_parent_ip+0x11/0x41
 [<ffffffff8122a5c4>] call_rwsem_down_read_failed+0x14/0x30
 [<ffffffff815224a0>] ? down_read+0x12/0x14
 [<ffffffff81022038>] do_page_fault+0x12c/0x239
 [<ffffffff8152384f>] page_fault+0x1f/0x30



cached         D 0000000000000002     0  1286  29036 0x00000000
 ffff88026502be20 0000000000000082 ffffffff81089b28 ffff88026502bfd8
 0000000000012580 ffff88026502bfd8 ffff88042e174350 0000000000012580
 0000000000012580 0000000000012580 0000000000012580 ffff88042e174350
Call Trace:
 [<ffffffff81089b28>] ? perf_event_task_sched_in+0x1c/0x98
 [<ffffffff81522d3b>] rwsem_down_failed_common+0x96/0xc8
 [<ffffffff81522fd7>] ? _raw_spin_unlock_irqrestore+0x2c/0x37
 [<ffffffff81522dbd>] rwsem_down_read_failed+0x26/0x30
 [<ffffffff815223f3>] ? do_nanosleep+0x7b/0xb3
 [<ffffffff8122a5c4>] call_rwsem_down_read_failed+0x14/0x30
 [<ffffffff815224a0>] ? down_read+0x12/0x14
 [<ffffffff81022038>] do_page_fault+0x12c/0x239
 [<ffffffff8152384f>] page_fault+0x1f/0x30


Even on epoll_wait I started being blocked:


cached         D 0000000000000005     0  1292  29036 0x00000000
 ffff8803cbd39a00 0000000000000082 0000000000000000 ffff8803cbd39fd8
 0000000000012580 ffff8803cbd39fd8 ffff88043d01c350 0000000000012580
 0000000000012580 0000000000012580 0000000000012580 ffff88043d01c350
Call Trace:
 [<ffffffff81522d3b>] rwsem_down_failed_common+0x96/0xc8
 [<ffffffff81522dbd>] rwsem_down_read_failed+0x26/0x30
 [<ffffffff8122a5c4>] call_rwsem_down_read_failed+0x14/0x30
 [<ffffffff812297bd>] ? copy_user_generic_string+0x2d/0x40
 [<ffffffff815224a0>] ? down_read+0x12/0x14
 [<ffffffff81022038>] do_page_fault+0x12c/0x239
 [<ffffffff8152384f>] page_fault+0x1f/0x30
 [<ffffffff812297bd>] ? copy_user_generic_string+0x2d/0x40
 [<ffffffff814959c7>] ? copy_from_user+0x9/0xb
 [<ffffffff81497fcb>] tcp_sendmsg+0x53b/0x8b5
 [<ffffffff81449fe9>] __sock_sendmsg+0x67/0x73
 [<ffffffff8144a528>] sock_sendmsg+0xa3/0xbc
 [<ffffffff81089b28>] ? perf_event_task_sched_in+0x1c/0x98
 [<ffffffff81036128>] ? get_parent_ip+0x11/0x41
 [<ffffffff81036128>] ? get_parent_ip+0x11/0x41
 [<ffffffff8103637f>] ? add_preempt_count+0xad/0xb2
 [<ffffffff81036128>] ? get_parent_ip+0x11/0x41
 [<ffffffff810bffd8>] ? fget_light+0x93/0xa9
 [<ffffffff8144a5a9>] ? sockfd_lookup_light+0x1b/0x53
 [<ffffffff8144bfa2>] sys_sendto+0xfa/0x120
 [<ffffffff810eb90d>] ? sys_epoll_wait+0x28f/0x2a7
 [<ffffffff81002a2b>] system_call_fastpath+0x16/0x1b


My uname -a is:


Linux cached 2.6.35.13 #2 SMP PREEMPT Mon Jan 16 18:11:04 BRST 2012
x86_64 Intel(R) Xeon(R) CPU X3440 @ 2.53GHz GenuineIntel GNU/Linux

Is there any more info I can provide to help track down this issue?

Thanks,

- Robert
