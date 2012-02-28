Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965697Ab2B1QCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 11:02:44 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61036 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965242Ab2B1QCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 11:02:42 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of levinsasha928@gmail.com designates 10.50.195.131 as permitted sender) smtp.mail=levinsasha928@gmail.com; dkim=pass header.i=levinsasha928@gmail.com
MIME-Version: 1.0
In-Reply-To: <1330441686.11248.93.camel@twins>
References: <1330442692.3719.7.camel@lappy> <1330435782.11248.89.camel@twins>
 <CA+1xoqfMad+s4-E-Nn29m3=bVASEkH38ZNvWg2vY99ZizdAT3Q@mail.gmail.com>
 <1330438853.11248.90.camel@twins> <CA+1xoqdRES=RwUw8C+8=6neu7t0JZeBAxSaoT2+VA-Z+pvD6oQ@mail.gmail.com>
 <1330439166.11248.92.camel@twins> <CA+1xoqeEa2E7iu+RPiHTYoQO3739UKQm_PjAbxZA0-f+ped+tA@mail.gmail.com>
 <1330441686.11248.93.camel@twins>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Tue, 28 Feb 2012 18:02:22 +0200
Message-ID: <CA+1xoqfUyM-yc5oFWB=q4HPxDeqHxA4FfBuEc2Xp2oSEvPHh-Q@mail.gmail.com>
Subject: Re: lockdep: Warning & NULL ptr deref
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Dave Jones <davej@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 5:08 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2012-02-28 at 16:55 +0200, Sasha Levin wrote:
>> > Hmm, cute, does a kernel without lockdep explode too? If its proper
>> > memory corruption one would expect that.
>>
>> Looks like it only happens when lockdep is there, it also happens in
>> the same lockdep line of code all the time.
>
> OK, that smells.. no good idea then on how this could happen :/

I have some more details which may help:

1. It actually happens almost every time. I stop trinity, trigger
sysrq twice and it shows up. It doesn't happen while trinity is
running.
2. It always happens when trying to print locks held by ksoftirqd ("1
lock held by ksoftirqd/0/3:")
3. If it helps any, the bug we were originally trying to find is that
trinity leaves a bunch of zombie processes, with this kernel stack:


[  328.028320] trinity         x ffff880038eded40  5200  5178      1 0x00000000
[  328.028320]  ffff880037eafd28 0000000000000086 0000000000000001
ffff880037eaffd8
[  328.028320]  00000000001d4340 ffff880037eae000 00000000001d4340
00000000001d4340
[  328.028320]  00000000001d4340 00000000001d4340 ffff880037eaffd8
00000000001d4340
[  328.028320] Call Trace:
[  328.028320]  [<ffffffff826e1c1a>] schedule+0x3a/0x50
[  328.028320]  [<ffffffff810b2251>] do_exit+0x2f1/0x4d0
[  328.028320]  [<ffffffff810b24cc>] do_group_exit+0x5c/0xd0
[  328.028320]  [<ffffffff810c1b1c>] get_signal_to_deliver+0x1dc/0x3d0
[  328.028320]  [<ffffffff8104bcc3>] do_signal+0x53/0x130
[  328.028320]  [<ffffffff81070000>] ? default_init_apic_ldr+0x20/0x70
[  328.028320]  [<ffffffff810e25bd>] ? sub_preempt_count+0x9d/0xd0
[  328.028320]  [<ffffffff826e3366>] ? _raw_spin_unlock_irq+0x46/0x70
[  328.028320]  [<ffffffff826e413f>] ? retint_signal+0x11/0x92
[  328.028320]  [<ffffffff8104be25>] do_notify_resume+0x65/0x80
[  328.028320]  [<ffffffff8187c61e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  328.028320]  [<ffffffff826e417b>] retint_signal+0x4d/0x92
