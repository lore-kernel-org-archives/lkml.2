Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab1DANqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 09:46:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47547 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913Ab1DANqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 09:46:34 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=6MGA-aeKMwUA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=QWcd7baMV8BiqIDhaxQA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: locks inside receive_buf
From: Steven Rostedt <rostedt@goodmis.org>
To: Pavan Savoy <pavan_savoy@sify.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTi=orUZrXHQSYXdrOWTJ35vd+41BKD5Crx16n4B1@mail.gmail.com>
References: <AANLkTi=FrmB=u09wvLoXzQstnV3h-U58R728t3k6_-B-@mail.gmail.com>
	 <20110331112559.090948a7@lxorguk.ukuu.org.uk>
	 <AANLkTimyVsoRYqoXWYMQz_AN3Uo31NBifmiwDUijWnvS@mail.gmail.com>
	 <20110331143329.GA14441@home.goodmis.org>
	 <AANLkTi=orUZrXHQSYXdrOWTJ35vd+41BKD5Crx16n4B1@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 01 Apr 2011 09:46:32 -0400
Message-ID: <1301665592.2160.19.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-01 at 12:42 +0530, Pavan Savoy wrote:
> On Thu, Mar 31, 2011 at 8:03 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Thu, Mar 31, 2011 at 04:48:29PM +0530, Pavan Savoy wrote:
> >>
> >> Alright, so I see the work gets into the default kthread queue I suppose...?
> >> However, I am quite puzzled by this kind of OOPS (pasted below...)
> >>
> >> Where I know the TTY called my receive_buf (which is st_tty_receive) -
> >> which internally calls my parsing function st_int_recv() .....
> >> I was just wondering, whether it is worth making this internal parsing
> >> function a tasklet by itself ?
> >>
> >> I kind of do lot of stuff inside the st_int_recv() - including doing a
> >> tty->ops->write....
> >> copy in and out of skb queues - So are all this long enough sleeps?
> >>
> >> PC is at st_int_recv+0x2a0/0x354 [st_drv]
> >> LR is at schedule+0x414/0x4e8
> >
> > Um, what was the cause of the oops? You did not include that.
> 
> How do I understand this ? a NULL pointer exception occurred in
> function schedule?

It did not happen in the scheduler, it happened in st_int_recv.

> 
> Unable to handle kernel NULL pointer dereference at virtual address 0000001a
> pgd = c0004000
> [0000001a] *pgd=00000000
> Internal error: Oops: 17 [#1] PREEMPT SMP
> last sysfs file: /sys/devices/virtual/bluetooth/hci0/rfkill0/state
> Modules linked in: tiwlan_drv test_drv(P) gps_drv(C) fm_drv(C)
> btwilink st_drv [last unloaded: tiwlan_drv]
> CPU: 0    Tainted: P        WC   (2.6.35.7-00242-ga4e3b34-dirty #1)
> PC is at st_int_recv+0x2a0/0x354 [st_drv]

The program counter is at st_int_recv+0x2a0 when this happened, so that
function is probably where you accessed some structure that was not
initialized.

	foo->bar

if foo is NULL, you'll get that error.

> LR is at schedule+0x414/0x4e8

LR is Link Register, or where this function was called from.

Now why is the scheduler calling your function, I have no idea.


> pc : [<bf000fc0>]    lr : [<c04c3ff0>]    psr: 80000013
> sp : efc55ed0  ip : efc55dc0  fp : efc55f0c
> r10: 00000008  r9 : eec4de60  r8 : 00000004
> r7 : 00000000  r6 : 00000007  r5 : ee77bc8f  r4 : ef0f3480
> r3 : 00000000  r2 : 00000000  r1 : 00000020  r0 : 0000001f
> Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> Control: 10c53c7d  Table: af3a004a  DAC: 00000015
> 

[ snip ]

> Backtrace:
> [<bf000d20>] (st_int_recv+0x0/0x354 [st_drv]) from [<bf000170>]
> (st_tty_receive+0x70/0x9c [st_drv])
> [<bf000100>] (st_tty_receive+0x0/0x9c [st_drv]) from [<c02616b4>]
> (flush_to_ldisc+0xfc/0x170)
>  r6:ef10e8f0 r5:ef10e8a4 r4:ef10e800
> [<c02615b8>] (flush_to_ldisc+0x0/0x170) from [<c009bf30>]
> (worker_thread+0x154/0x1e0)
> [<c009bddc>] (worker_thread+0x0/0x1e0) from [<c009fce0>] (kthread+0x84/0x8c)
> [<c009fc5c>] (kthread+0x0/0x8c) from [<c008d6bc>] (do_exit+0x0/0x5f0)
>  r7:00000013 r6:c008d6bc r5:c009fc5c r4:efc41f10
> Code: e288a004 e3a01020 e3a02000 e794310a (e1d301ba)
> ---[ end trace 34f2f99c655b5328 ]---
> Kernel panic - not syncing: Fatal exception

The backtrace does not even show the scheduler, so that may just be due
to some other kind of corruption.

Looks like something is not right with the st_drv code.

-- Steve


