Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab1DAHMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 03:12:52 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37366 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596Ab1DAHMv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 03:12:51 -0400
MIME-Version: 1.0
X-Originating-IP: [203.101.61.7]
In-Reply-To: <20110331143329.GA14441@home.goodmis.org>
References: <AANLkTi=FrmB=u09wvLoXzQstnV3h-U58R728t3k6_-B-@mail.gmail.com>
	<20110331112559.090948a7@lxorguk.ukuu.org.uk>
	<AANLkTimyVsoRYqoXWYMQz_AN3Uo31NBifmiwDUijWnvS@mail.gmail.com>
	<20110331143329.GA14441@home.goodmis.org>
Date: Fri, 1 Apr 2011 12:42:49 +0530
Message-ID: <AANLkTi=orUZrXHQSYXdrOWTJ35vd+41BKD5Crx16n4B1@mail.gmail.com>
Subject: Re: locks inside receive_buf
From: Pavan Savoy <pavan_savoy@sify.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 8:03 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, Mar 31, 2011 at 04:48:29PM +0530, Pavan Savoy wrote:
>>
>> Alright, so I see the work gets into the default kthread queue I suppose...?
>> However, I am quite puzzled by this kind of OOPS (pasted below...)
>>
>> Where I know the TTY called my receive_buf (which is st_tty_receive) -
>> which internally calls my parsing function st_int_recv() .....
>> I was just wondering, whether it is worth making this internal parsing
>> function a tasklet by itself ?
>>
>> I kind of do lot of stuff inside the st_int_recv() - including doing a
>> tty->ops->write....
>> copy in and out of skb queues - So are all this long enough sleeps?
>>
>> PC is at st_int_recv+0x2a0/0x354 [st_drv]
>> LR is at schedule+0x414/0x4e8
>
> Um, what was the cause of the oops? You did not include that.

How do I understand this ? a NULL pointer exception occurred in
function schedule?

Unable to handle kernel NULL pointer dereference at virtual address 0000001a
pgd = c0004000
[0000001a] *pgd=00000000
Internal error: Oops: 17 [#1] PREEMPT SMP
last sysfs file: /sys/devices/virtual/bluetooth/hci0/rfkill0/state
Modules linked in: tiwlan_drv test_drv(P) gps_drv(C) fm_drv(C)
btwilink st_drv [last unloaded: tiwlan_drv]
CPU: 0    Tainted: P        WC   (2.6.35.7-00242-ga4e3b34-dirty #1)
PC is at st_int_recv+0x2a0/0x354 [st_drv]
LR is at schedule+0x414/0x4e8
pc : [<bf000fc0>]    lr : [<c04c3ff0>]    psr: 80000013
sp : efc55ed0  ip : efc55dc0  fp : efc55f0c
r10: 00000008  r9 : eec4de60  r8 : 00000004
r7 : 00000000  r6 : 00000007  r5 : ee77bc8f  r4 : ef0f3480
r3 : 00000000  r2 : 00000000  r1 : 00000020  r0 : 0000001f
Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 10c53c7d  Table: af3a004a  DAC: 00000015

LR: 0xc04c3f70:
3f70  e5973160 e0223003 e1b03423 0a000001 e1a00007 ebee318c e59f3130 e597216c
3f90  e593316c e1520003 0a000001 e1a00007 ebee2997 e5970024 e1a01007 e2800103
3fb0  ebee31f8 e59530d4 e1a00005 e3530000 058530d8 05848460 e5951004 e5992004
3fd0  ebee0877 e1a01000 e59f50c4 e5963014 e59f40c0 e7950103 e0840000 ebeef300
3ff0  e5968014 e7953108 e0844003 ea000001 e1a00004 eb000842 e5943484 e3530000
4010  0a00000e e1a00004 eb000982 e5943454 e593302c e5933024 e3530000 e1a05000
4030  0a000001 e1a00004 e12fff33 e1a00004 e1a01005 eb000846 e3a03000 e5843484
4050  e596300c e5933014 e3530000 ba000004 eb0009fe e3500000 b5945454 b285ad06

SP: 0xefc55e50:
ADDRCONF(NETDEV_UP): tiwlan0: link is not ready
5e50  00000000 00000000 60000013 30203430 34302065 20313020 ffffffff efc55ebc
5e70  00000007 00000000 efc55f0c efc55e88 c0045c6c c0045484 0000001f 00000020
5e90  00000000 00000000 ef0f3480 ee77bc8f 00000007 00000000 00000004 eec4de60
5eb0  00000008 efc55f0c efc55dc0 efc55ed0 c04c3ff0 bf000fc0 80000013 ffffffff
5ed0  eec4de60 ef0f34f4 ef0f34e0 ef0f3508 c04c3764 00000007 ee77bc8f ef10e800
5ef0  00000007 60000013 eec4de60 ef10e8c4 efc55f3c efc55f10 bf000170 bf000d2c
5f10  00000001 ee77bc8f 00000007 00000000 efc55f3c ef10e800 ef10e8a4 ef10e8f0
5f30  efc55f74 efc55f40 c02616b4 bf00010c ee77bc8f ee77bd8f efc55f64 c1b5b7c0

IP: 0xefc55d40:
5d40  efc55d7c efc55d60 c004d424 c04c3750 c05bc74a 0000001a 00000017 00000000
5d60  efc55e88 00000000 00000113 00000008 efc55da4 efc55d80 c004d540 c004a5ec
5d80  efc55e88 efc3d5e0 0000001a efc55e88 00000000 00000017 efc55ddc efc55da8
5da0  c004d730 c004d4e0 c0044000 c06a6df4 efc55e04 00000017 c064cde8 0000001a
5dc0  efc55e88 00000004 00000113 00000008 efc55e84 efc55de0 c00454b4 c004d56c
5de0  00000003 0000001c 0000001f 0000001c eec4de60 c06623f8 efc55e1c efc55e08
5e00  c04c42d0 c04c3be8 00000002 00000001 efc55ea4 efc55e20 c008ae24 c04c429c
5e20  efc55f0c 00000004 c0216344 c04c3750 c05d2bf5 bf0021de bf0021e2 60000013

FP: 0xefc55e8c:
5e8c  00000020 00000000 00000000 ef0f3480 ee77bc8f 00000007 00000000 00000004
5eac  eec4de60 00000008 efc55f0c efc55dc0 efc55ed0 c04c3ff0 bf000fc0 80000013
5ecc  ffffffff eec4de60 ef0f34f4 ef0f34e0 ef0f3508 c04c3764 00000007 ee77bc8f
5eec  ef10e800 00000007 60000013 eec4de60 ef10e8c4 efc55f3c efc55f10 bf000170
5f0c  bf000d2c 00000001 ee77bc8f 00000007 00000000 efc55f3c ef10e800 ef10e8a4
5f2c  ef10e8f0 efc55f74 efc55f40 c02616b4 bf00010c ee77bc8f ee77bd8f efc55f64
5f4c  c1b5b7c0 efc54000 c02615b8 c1b5b7d0 c1b5b7c8 ef10e8c8 ef10e8c4 efc55fbc
5f6c  efc55f78 c009bf30 c02615c4 efc55f8c 00000000 efc3d5e0 c00a00ac efc55f88

R4: 0xef0f3400:
3400  00000000 00000000 00000000 00000000 eec4de80 00000037 00000000 00000000
3420  00000000 ef0f3480 000a2b0f 0006000f 65642f01 74742f76 00314f79 00000000
3440  00000000 00000000 00000000 00000000 00000100 002dc6c0 00000000 00000000
3460  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
3480  00000000 ef10e800 00000000 00000000 00000000 00000000 00000000 00000000
34a0  00000000 00000000 00000000 00000000 00000000 bf018008 00000000 00000000
34c0  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000004
34e0  ef0f34e0 ef0f34e0 00000000 00000000 00000000 ef0f34f4 ef0f34f4 00000000

R5: 0xee77bc0f:
bc0c  0000007a 00000100 0000007a 0000007a 00000000 00000000 00000000 00000000
bc2c  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
bc4c  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
bc6c  00000000 00000000 00000000 f0011000 01040e04 04000c52 1901050e 3002000c
bc8c  04323033 0301040e 0000000c 00000000 00000000 00000000 00000000 00000000
bcac  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
bccc  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
bcec  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
bd0c  040503f0 5601040e 0e04000c 0c550105 00000000 00000000 00000000 00000000

R9: 0xeec4dde0:
dde0  006d696b 00200200 00000002 00000000 00000000 00000000 00000000 00000000
de00  6d726966 65726177 00000000 00000000 eec4de10 eec4de10 eec4de18 eec4de18
de20  eec4de20 eec4de20 00000000 0000b918 00000000 00000000 00000000 00000000
de40  eec4de40 eec4de40 00000000 0000b8f0 00000000 00000000 00000000 00000000
de60  bf002f44 00000002 00000002 00000000 00000000 00000000 00000000 00000000
de80  eec4de80 eec4de80 00000000 000ddbc8 00000000 00000000 00000000 00000000
dea0  00000001 00000001 00000000 00000000 ef183c0c ef183c0c efc72338 efc72338
dec0  eec4dec0 eec4dec0 00000000 000ea5c0 00000000 00000000 00000000 00000000
Process events/0 (pid: 7, stack limit = 0xefc542f8)
Stack: (0xefc55ed0 to 0xefc56000)
5ec0:                                     eec4de60 ef0f34f4 ef0f34e0 ef0f3508
5ee0: c04c3764 00000007 ee77bc8f ef10e800 00000007 60000013 eec4de60 ef10e8c4
5f00: efc55f3c efc55f10 bf000170 bf000d2c 00000001 ee77bc8f 00000007 00000000
5f20: efc55f3c ef10e800 ef10e8a4 ef10e8f0 efc55f74 efc55f40 c02616b4 bf00010c
5f40: ee77bc8f ee77bd8f efc55f64 c1b5b7c0 efc54000 c02615b8 c1b5b7d0 c1b5b7c8
5f60: ef10e8c8 ef10e8c4 efc55fbc efc55f78 c009bf30 c02615c4 efc55f8c 00000000
5f80: efc3d5e0 c00a00ac efc55f88 efc55f88 c007d330 efc41f10 efc55fc4 c009bddc
5fa0: c1b5b7c0 00000000 00000000 00000000 efc55ff4 efc55fc0 c009fce0 c009bde8
5fc0: 00000000 00000000 00000000 00000000 efc55fd0 efc55fd0 efc41f10 c009fc5c
5fe0: c008d6bc 00000013 00000000 efc55ff8 c008d6bc c009fc68 00000000 00000000
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
 r7:00000013 r6:c008d6bc r5:c009fc5c r4:efc41f10
Code: e288a004 e3a01020 e3a02000 e794310a (e1d301ba)
---[ end trace 34f2f99c655b5328 ]---
Kernel panic - not syncing: Fatal exception



> -- Steve
>
>> pc : [<bf000fc0>]    lr : [<c04c3ff0>]    psr: 80000013
>> sp : efc55ed0  ip : efc55dc0  fp : efc55f0c
>> r10: 00000008  r9 : eec4de60  r8 : 00000004
>> r7 : 00000000  r6 : 00000007  r5 : ee77bc8f  r4 : ef0f3480
>> r3 : 00000000  r2 : 00000000  r1 : 00000020  r0 : 0000001f
>> Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
>> Control: 10c53c7d  Table: af3a004a  DAC: 00000015
>>
>> <snip...>
>>
>> Backtrace:
>> [<bf000d20>] (st_int_recv+0x0/0x354 [st_drv]) from [<bf000170>]
>> (st_tty_receive+0x70/0x9c [st_drv])
>> [<bf000100>] (st_tty_receive+0x0/0x9c [st_drv]) from [<c02616b4>]
>> (flush_to_ldisc+0xfc/0x170)
>>  r6:ef10e8f0 r5:ef10e8a4 r4:ef10e800
>> [<c02615b8>] (flush_to_ldisc+0x0/0x170) from [<c009bf30>]
>> (worker_thread+0x154/0x1e0)
>> [<c009bddc>] (worker_thread+0x0/0x1e0) from [<c009fce0>] (kthread+0x84/0x8c)
>> [<c009fc5c>] (kthread+0x0/0x8c) from [<c008d6bc>] (do_exit+0x0/0x5f0)
>>
>
