Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab1DFI46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 04:56:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61006 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954Ab1DFI45 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 04:56:57 -0400
MIME-Version: 1.0
X-Originating-IP: [203.101.61.7]
In-Reply-To: <1302008671.17430.10.camel@frodo>
References: <AANLkTi=FrmB=u09wvLoXzQstnV3h-U58R728t3k6_-B-@mail.gmail.com>
	<20110331112559.090948a7@lxorguk.ukuu.org.uk>
	<AANLkTimyVsoRYqoXWYMQz_AN3Uo31NBifmiwDUijWnvS@mail.gmail.com>
	<20110331143329.GA14441@home.goodmis.org>
	<AANLkTi=orUZrXHQSYXdrOWTJ35vd+41BKD5Crx16n4B1@mail.gmail.com>
	<1301665592.2160.19.camel@gandalf.stny.rr.com>
	<BANLkTik5MGz9YgU0oh30ZUesv+c3QEB+rA@mail.gmail.com>
	<1302008671.17430.10.camel@frodo>
Date: Wed, 6 Apr 2011 14:26:54 +0530
Message-ID: <BANLkTimZjTT1B2BxZdrEMMh+e-6ScL0T-w@mail.gmail.com>
Subject: Re: locks inside receive_buf
From: Pavan Savoy <pavan_savoy@sify.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 5, 2011 at 6:34 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2011-04-05 at 16:43 +0530, Pavan Savoy wrote:
>
>> > The program counter is at st_int_recv+0x2a0 when this happened, so that
>> > function is probably where you accessed some structure that was not
>> > initialized.
>> >
>> >        foo->bar
>> >
>> > if foo is NULL, you'll get that error.
>> >
>> >> LR is at schedule+0x414/0x4e8
>> >
>> > LR is Link Register, or where this function was called from.
>> >
>> > Now why is the scheduler calling your function, I have no idea.
>>
>> Well this is exactly the problem I have and hence the question
>> regarding sleep in tty's receive_buf function.
>>
>> the function called st_recv or st_int_recv() is basically my line
>> discipline's receive_buf function - which happens like zillions of
>> times properly with tty->disc_data being populated with what I
>> need....
>>
>> However on a corner case - when I perform some operation - which has
>> absolutely NO relation to TTY (at most may be console is using 1 uart)
>> - Everything breaks loose...
>
> Well, if this corner case that you perform causes the corruption, I
> think they are related. What corner case do you do?

corner case meaning - doing something totally un-related to this driver ...
like turning the WLAN driver On/Off....

>> If I bump into a NULL pointer it is because the tty->disc_data is NULL ....
>> However my check for tty->disc_data being NULL also is fine - i.e when
>> I do get this error - my disc_data is NOT null ... But not sure what
>> (which data) is NULL ??
>
> How are you checking for NULL?
>
>        if (data == NULL)
>
> may not work as the error shows:

Nope, I thought of that, SO now I check for the last member of the
structure to be NULL...
Imagining I got the wrong disc_data in the TTY during crash ...

so I check for (st_gdata->tty == NULL)
where my tty is the last member of the structure
struct st_data_s {
....
....

struct tty_struct *tty;
} st_gdata;


> "Unable to handle kernel NULL pointer dereference at virtual address 0000001a"
>
> Where data (or what ever it was using) was 0x1a not 0. We consider NULL
> anything less that a page size. Because of something just like this. You
> have a structure pointer that is NULL, accessing the element may not be
> NULL.
>
>>
>> So now back to the question - What cannot I do inside tty's receive_buf ?
>
> I don't know, but it may not be the issue. Something else may be broken.
>
> Perhaps you can't schedule, which means you can't use something like a
> mutex. But if that was the issue, the scheduler itself would give you a
> nasty warning that you are scheduling in non-schedulable context.

I did another thing, I faked a NULL pointer exception in my function
st_int_recv() - to check for the LR and PC and the trace as to how
they would look,

so the trace told me right things, (I set st_gdata NULL and tried to
access st_gdata->lock inside the spin_lock_irqsave routine inside the
function st_int_recv() ... )

[<c04c605c>] (__raw_spin_lock_irqsave+0x0/0xa4) from [<c04c6110>]
(_raw_spin_lock_irqsave+0x10/0x14)
 r5:ee510000 r4:eeb1fd19
[<c04c6100>] (_raw_spin_lock_irqsave+0x0/0x14) from [<bf000c40>]
(st_int_recv+0x3c/0x308 [st_drv])
[<bf000c04>] (st_int_recv+0x0/0x308 [st_drv]) from [<bf000148>]
(st_tty_receive+0x5c/0x78 [st_drv])
[<bf0000ec>] (st_tty_receive+0x0/0x78 [st_drv]) from [<c026104c>]
(flush_to_ldisc+0xfc/0x170)
 r7:00000003 r6:ee5100f0 r5:ee5100a4 r4:ee510000
[<c0260f50>] (flush_to_ldisc+0x0/0x170) from [<c009c3cc>]
(worker_thread+0x154/0x1e0)
[<c009c278>] (worker_thread+0x0/0x1e0) from [<c00a017c>] (kthread+0x84/0x8c)
[<c00a00f8>] (kthread+0x0/0x8c) from [<c008db58>] (do_exit+0x0/0x5f0)

and the
PC is at __raw_spin_lock_irqsave+0x34/0xa4
LR is at _raw_spin_lock_irqsave+0x10/0x14

suggest that the st_int_recv() is being called from
_raw_spin_lock_irqsave and the exception occured a few lines inside
the st_int_recv() before in and around the code
[<c04c605c>] (__raw_spin_lock_irqsave+0x0/0xa4) from [<c04c6110>]
(_raw_spin_lock_irqsave+0x10/0x14)
 r5:ee510000 r4:eeb1fd19
[<c04c6100>] (_raw_spin_lock_irqsave+0x0/0x14) from [<bf000c40>]
(st_int_recv+0x3c/0x308 [st_drv])
[<bf000c04>] (st_int_recv+0x0/0x308


But what I don't understand is the older log which I sent, where the
PC is at st_int_recv+0x284/0x314 [st_drv]
LR is at _raw_spin_lock_irqsave+0x10/0x14

which suggests that the function - st_int_recv() is about to be called
- But NOT yet called...
and so the doubt as to something is going wrong in the TTY layer and
not exactly inside my function...





> -- Steve
>
>
>
