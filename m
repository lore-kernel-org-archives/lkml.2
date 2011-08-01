Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab1HAO6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 10:58:04 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42043 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab1HAO5z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 10:57:55 -0400
MIME-Version: 1.0
In-Reply-To: <20110801133954.GA11452@albatros>
References: <CAOLZvyEQNS3dwQ+6bh2o6kADp7Gd3xOpah8y1_AhqJ2FWSP9VA@mail.gmail.com>
	<20110801133954.GA11452@albatros>
Date: Mon, 1 Aug 2011 16:57:54 +0200
Message-ID: <CAOLZvyEGHW3GUskhQoGnELynegzcM0-XAUTrf89hjODE1bzhqA@mail.gmail.com>
Subject: Re: shm broken on MIPS in current -git
From: Manuel Lauss <manuel.lauss@googlemail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, Linux-MIPS <linux-mips@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 1, 2011 at 3:39 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> Manuel,
>
> On Mon, Aug 01, 2011 at 14:51 +0200, Manuel Lauss wrote:
>> CPU 0 Unable to handle kernel paging request at virtual address
>> 00000000, epc == 80527c64, ra == 8024afb8
>> Oops[#1]:
> [...]
>> epc   : 80527c64 __down_write_nested+0x68/0xf0
>
> Could you post the asm code of __down_write_nested() of your image?
> What pointer is NULL?  Looks like MIPS handles namespaces in usermode
> helpers other way.

I'm no MIPS expert, but this looks like a problem with the waiter_list
in struct rw_semaphore:

Dump of assembler code for function __down_write_nested:
   0x80530ee4 <+0>:     addiu   sp,sp,-48
   0x80530ee8 <+4>:     sw      ra,44(sp)
   0x80530eec <+8>:     sw      s1,40(sp)
   0x80530ef0 <+12>:    sw      s0,36(sp)
   0x80530ef4 <+16>:    mfc0    v1,c0_status
   0x80530ef8 <+20>:    ori     at,v1,0x1f
   0x80530efc <+24>:    xori    at,at,0x1f
   0x80530f00 <+28>:    mtc0    at,c0_status
   0x80530f04 <+32>:    lw      v0,0(a0)
   0x80530f08 <+36>:    beqz    v0,0x80530fa4 <__down_write_nested+192>
   0x80530f0c <+40>:    addiu   a2,a0,4
tsk = current:
   0x80530f10 <+44>:    lw      s0,0(gp)
set_task_state(tsk, UNINTERRUPTIBLE):
   0x80530f14 <+48>:    li      v0,2
   0x80530f18 <+52>:    sw      v0,0(s0)
waiter.tsk = tsk, ...
   0x80530f1c <+56>:    sw      v0,28(sp)
   0x80530f20 <+60>:    sw      s0,24(sp)
get_task_struct():
   0x80530f24 <+64>:    addiu   v0,s0,8
   0x80530f28 <+68>:    ll      a1,0(v0)
   0x80530f2c <+72>:    addiu   a1,a1,1
   0x80530f30 <+76>:    sc      a1,0(v0)
   0x80530f34 <+80>:    beqz    a1,0x80530f28 <__down_write_nested+68>
list_add_tail:
   0x80530f38 <+84>:    addiu   a1,sp,16   ; a1 = &waiter.list
   0x80530f3c <+88>:    lw      v0,8(a0)     ; v0 = &sem->wait_list
   0x80530f40 <+92>:    sw      a1,8(a0)
   0x80530f44 <+96>:    sw      a2,16(sp)
   0x80530f48 <+100>:   sw      v0,20(sp)
   0x80530f4c <+104>:   sw      a1,0(v0)     <===== oops here, because v0 = 0
spin_unlock_irqrestore:
   0x80530f50 <+108>:   mfc0    at,c0_status
   0x80530f54 <+112>:   andi    v1,v1,0x1
   0x80530f58 <+116>:   ori     at,at,0x1f
   0x80530f5c <+120>:   xori    at,at,0x1f
   0x80530f60 <+124>:   or      v1,v1,at
   0x80530f64 <+128>:   mtc0    v1,c0_status
[...]
   0x80530f68 <+132>:   lw      v0,24(sp)
   0x80530f6c <+136>:   beqz    v0,0x80530f8c <__down_write_nested+168>
   0x80530f70 <+140>:   li      s1,2
   0x80530f74 <+144>:   jal     0x8052ef94 <schedule>
   0x80530f78 <+148>:   nop
   0x80530f7c <+152>:   sw      s1,0(s0)
   0x80530f80 <+156>:   lw      v0,24(sp)
   0x80530f84 <+160>:   bnez    v0,0x80530f74 <__down_write_nested+144>
   0x80530f88 <+164>:   nop
   0x80530f8c <+168>:   sw      zero,0(s0)
   0x80530f90 <+172>:   lw      ra,44(sp)
   0x80530f94 <+176>:   lw      s1,40(sp)
   0x80530f98 <+180>:   lw      s0,36(sp)
   0x80530f9c <+184>:   jr      ra
   0x80530fa0 <+188>:   addiu   sp,sp,48
   0x80530fa4 <+192>:   lw      v0,4(a0)
   0x80530fa8 <+196>:   bne     v0,a2,0x80530f10 <__down_write_nested+44>
   0x80530fac <+200>:   li      a1,-1
   0x80530fb0 <+204>:   sw      a1,0(a0)
   0x80530fb4 <+208>:   mfc0    at,c0_status
   0x80530fb8 <+212>:   andi    v1,v1,0x1
   0x80530fbc <+216>:   ori     at,at,0x1f
   0x80530fc0 <+220>:   xori    at,at,0x1f
   0x80530fc4 <+224>:   or      v1,v1,at
   0x80530fc8 <+228>:   mtc0    v1,c0_status
   0x80530fcc <+232>:   j       0x80530f94 <__down_write_nested+176>
   0x80530fd0 <+236>:   lw      ra,44(sp)


Manuel Lauss
