Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab2AVMsj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 07:48:39 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54979 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab2AVMsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 07:48:38 -0500
MIME-Version: 1.0
Date: Sun, 22 Jan 2012 12:48:37 +0000
X-Google-Sender-Auth: 2uUYu8bx3TnUFG0bTwH6pYrxV_U
Message-ID: <CAO+b5-orBaZMmmw1_5Jo+oSEDu8yXrXt-cAcZxQeqkmFkP8efA@mail.gmail.com>
Subject: exit_aio() hang after I/O failure
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <htejun@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Apparently processes can hang in exit_aio() with at least kernel 3.2.1
after an I/O failure. Has anyone seen this before ?

This occurred after a SCSI device had been removed entirely (and hence
after all I/O requests were killed by scsi_remove_host()).

>From sysrq-t:

fio             D ffff88006546ab40     0  8966   8965 0x00000004
 ffff88011dab1b88 0000000000000046 ffff880100000000 ffff88012fa11d80
 ffff88006546a880 ffff88011dab1fd8 ffff88011dab1fd8 ffff88011dab1fd8
 ffff880128b89440 ffff88006546a880 ffff88011dab1ce8 0000000181039871
Call Trace:
 [<ffffffff813b360f>] schedule+0x3f/0x60
 [<ffffffff813b368f>] io_schedule+0x5f/0x80
 [<ffffffff811719e0>] wait_for_all_aios+0xc0/0x100
 [<ffffffff8103c210>] ? try_to_wake_up+0x270/0x270
 [<ffffffff81172955>] exit_aio+0x55/0xc0
 [<ffffffff8104119d>] mmput+0x2d/0x110
 [<ffffffff810478cd>] exit_mm+0x10d/0x130
 [<ffffffff81047f4c>] do_exit+0x65c/0x850
 [<ffffffff810484a4>] do_group_exit+0x44/0xb0
 [<ffffffff81057cb8>] get_signal_to_deliver+0x218/0x5a0
 [<ffffffff81002065>] do_signal+0x65/0x700
 [<ffffffff8106925a>] ? hrtimer_try_to_cancel+0x4a/0xb0
 [<ffffffff810692e2>] ? hrtimer_cancel+0x22/0x30
 [<ffffffff813b43c4>] ? do_nanosleep+0xa4/0xd0
 [<ffffffff813b4326>] ? do_nanosleep+0x6/0xd0
 [<ffffffff81069ea0>] ? hrtimer_nanosleep+0xa0/0x150
 [<ffffffff81002775>] do_notify_resume+0x55/0x70
 [<ffffffff811dcd6e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
 [<ffffffff813bcff3>] int_signal+0x12/0x17

Bart.
