Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab2BKSap (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 13:30:45 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51882 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab2BKSao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 13:30:44 -0500
MIME-Version: 1.0
In-Reply-To: <CAO+b5-q9zYWiBLJMyXEfY1EhOyQtKLs5rPyx+n+Tf79=6WiK1g@mail.gmail.com>
References: <CAO+b5-orBaZMmmw1_5Jo+oSEDu8yXrXt-cAcZxQeqkmFkP8efA@mail.gmail.com>
	<x49ipk2bdkn.fsf@segfault.boston.devel.redhat.com>
	<CAO+b5-q9zYWiBLJMyXEfY1EhOyQtKLs5rPyx+n+Tf79=6WiK1g@mail.gmail.com>
Date: Sat, 11 Feb 2012 18:30:42 +0000
X-Google-Sender-Auth: FhofrXWqyuv2lnwb5lflZqWW5QE
Message-ID: <CAO+b5-pCQmz=c5na5vmLAWm=2Ps2ts33v2ZMkJGTjaMohzysLA@mail.gmail.com>
Subject: Re: exit_aio() hang after I/O failure
From: Bart Van Assche <bvanassche@acm.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <htejun@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 4:47 PM, Bart Van Assche <bvanassche@acm.org> wrote:
> On Mon, Jan 23, 2012 at 4:15 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> > Bart Van Assche <bvanassche@acm.org> writes:
> > > Apparently processes can hang in exit_aio() with at least kernel 3.2.1
> > > after an I/O failure. Has anyone seen this before ?
> > >
> > > This occurred after a SCSI device had been removed entirely (and hence
> > > after all I/O requests were killed by scsi_remove_host()).
> >
> > Fixed here:
> >
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=69e4747ee9727d660b88d7e1efe0f4afcb35db1b
>
> Thanks a lot for the feedback - I'll give this patch a try.

Bad news: I've been able to reproduce exactly the same call stack with
kernel 3.2.5. That kernel version includes the aforementioned commit.

# echo t >/proc/sysrq-trigger
[ ... ]
fio             D 0000000000000001     0 25052  25008 0x00000004
 ffff88001c32fb88 0000000000000046 ffff880000000000 ffff88007d949bc8
 ffff88001c8e14d0 ffff88001c32ffd8 ffff88001c32ffd8 ffff88001c32ffd8
 ffff880128b894d0 ffff88001c8e14d0 ffff88001c32fb88 000000018106f24d
Call Trace:
 [<ffffffff813b683f>] schedule+0x3f/0x60
 [<ffffffff813b68ef>] io_schedule+0x8f/0xd0
 [<ffffffff81174410>] wait_for_all_aios+0xc0/0x100
 [<ffffffff8103c3c0>] ? try_to_wake_up+0x270/0x270
 [<ffffffff81175385>] exit_aio+0x55/0xc0
 [<ffffffff810413cd>] mmput+0x2d/0x110
 [<ffffffff81047c1d>] exit_mm+0x10d/0x130
 [<ffffffff810482b1>] do_exit+0x671/0x860
 [<ffffffff81033c1e>] ? finish_task_switch+0x4e/0xe0
 [<ffffffff81048804>] do_group_exit+0x44/0xb0
 [<ffffffff81058018>] get_signal_to_deliver+0x218/0x5a0
 [<ffffffff81002065>] do_signal+0x65/0x700
 [<ffffffff811740d0>] ? aio_read_evt+0x150/0x150
 [<ffffffff8103c3c0>] ? try_to_wake_up+0x270/0x270
 [<ffffffff81002785>] do_notify_resume+0x65/0x80
 [<ffffffff811df84e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
 [<ffffffff813c0333>] int_signal+0x12/0x17
[ ... ]

Bart.
