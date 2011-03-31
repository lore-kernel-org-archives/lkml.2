Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347Ab1CaLSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 07:18:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59923 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab1CaLSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 07:18:31 -0400
MIME-Version: 1.0
X-Originating-IP: [203.101.61.10]
In-Reply-To: <20110331112559.090948a7@lxorguk.ukuu.org.uk>
References: <AANLkTi=FrmB=u09wvLoXzQstnV3h-U58R728t3k6_-B-@mail.gmail.com>
	<20110331112559.090948a7@lxorguk.ukuu.org.uk>
Date: Thu, 31 Mar 2011 16:48:29 +0530
Message-ID: <AANLkTimyVsoRYqoXWYMQz_AN3Uo31NBifmiwDUijWnvS@mail.gmail.com>
Subject: Re: locks inside receive_buf
From: Pavan Savoy <pavan_savoy@sify.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 3:55 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Wed, 30 Mar 2011 17:51:27 +0530
> Pavan Savoy <pavan_savoy@sify.com> wrote:
>
>> Hi,
>>
>> Does holding a lock make any sense inside the line discipline's
>> ops->receive_buf?
>> I see the locks being held and released - during some calls like
>> flush_to_ldisc, which end up calling receive_buf....
>>
>>
>> and yes, I would like to have a lock because, there are other
>> functions in my ldisc driver executed in process context ...
>> Is there some hints as to what should be the do's and don'ts inside
>> the ldisc ops functions ? (say tty_wakeup ...)
>
> It's not well documented no. Your ld->receive_buf is single threaded and
> runs from a sleeping context (but please don't sleep too long)

Alright, so I see the work gets into the default kthread queue I suppose...?
However, I am quite puzzled by this kind of OOPS (pasted below...)

Where I know the TTY called my receive_buf (which is st_tty_receive) -
which internally calls my parsing function st_int_recv() .....
I was just wondering, whether it is worth making this internal parsing
function a tasklet by itself ?

I kind of do lot of stuff inside the st_int_recv() - including doing a
tty->ops->write....
copy in and out of skb queues - So are all this long enough sleeps?

PC is at st_int_recv+0x2a0/0x354 [st_drv]
LR is at schedule+0x414/0x4e8
pc : [<bf000fc0>]    lr : [<c04c3ff0>]    psr: 80000013
sp : efc55ed0  ip : efc55dc0  fp : efc55f0c
r10: 00000008  r9 : eec4de60  r8 : 00000004
r7 : 00000000  r6 : 00000007  r5 : ee77bc8f  r4 : ef0f3480
r3 : 00000000  r2 : 00000000  r1 : 00000020  r0 : 0000001f
Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 10c53c7d  Table: af3a004a  DAC: 00000015

<snip...>

Backtrace:
[<bf000d20>] (st_int_recv+0x0/0x354 [st_drv]) from [<bf000170>]
(st_tty_receive+0x70/0x9c [st_drv])
[<bf000100>] (st_tty_receive+0x0/0x9c [st_drv]) from [<c02616b4>]
(flush_to_ldisc+0xfc/0x170)
 r6:ef10e8f0 r5:ef10e8a4 r4:ef10e800
[<c02615b8>] (flush_to_ldisc+0x0/0x170) from [<c009bf30>]
(worker_thread+0x154/0x1e0)
[<c009bddc>] (worker_thread+0x0/0x1e0) from [<c009fce0>] (kthread+0x84/0x8c)
[<c009fc5c>] (kthread+0x0/0x8c) from [<c008d6bc>] (do_exit+0x0/0x5f0)



> The output path from user space will be in a sleeping context too, but
> you can call the write method of the tty your driver is using from
> interrupt context or holding a spinlock (eg from timers)
>
>
>
>
