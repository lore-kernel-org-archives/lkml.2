Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966844Ab2EQP24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 11:28:56 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62979 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967056Ab2EQP2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 11:28:53 -0400
MIME-Version: 1.0
Date: Thu, 17 May 2012 23:28:51 +0800
Message-ID: <CA++uP6MrvbaaBg3iCZDwYFTQdujPHaKYhAC5FFt+r9M_J-AJ_Q@mail.gmail.com>
Subject: a volatile related bug in kernel/timer.c ?
From: KwongYuan Wong <wong.kwongyuan@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

  currently, I am working on a private mips-like chip, and I came
across the following senario:

  in the function "del_timer" in kernel/timer.c, there is the following code

954  if (timer_pending(timer)) {
955    base = lock_timer_base(timer, &flags);
956    if (timer_pending(timer)) {


suppose timer_pending(timer) check in line 954 is A, and in line 956 is B.

because the timer_pending(timer) check is very simple, so the result
may be saved in a register, and that register is reused
by both A and B.  While this should be wrong? the check at B should

reload the value from memory instead of using previous
result kept in register,  because lock_timer_base may have side-effect
which change the result of time_pending?

so I guess a barrier() is needed, so that the code should be the following?

if (timer_pending(timer)) {
  base = lock_timer_base(timer, &flags);
  barrier();
  if (timer_pending(timer)) {


in my chip, the generated assembly is like the following:
( the function "lock_timer_base" in inlined also)

1017 del_timer:
1018         .set    noreorder
1019         .set    nomacro
1020
1021         lw    $5,0($4)
1022         addu  $3,$0,$0
1023         beq   $5,$0,.L121            <=== $5 is the value of the

first "timer_pending(timer)"
1024         nop
1025
1026         lw    $3,20($4)
1027         addiu $2,$0,-2

1028         and   $6,$3,$2
1029         beq   $6,$0,.L122
1030         nop
1031
1032 .L125:
1033         .set push ; .set opportunistic
1034  # 69 "include/asm/irqflags.h" 1
1035         __raw_local_irq_save $7
1036  # 0 "" 2
1037         .set pop
1038         addu  $3,$0,$0
1039         beq   $5,$0,.L124             <=== in the second check,
it's reused,
                                                                   but
it should not, $5 should be updated from memory?
1040         nop

I am a compiler engineer, a newbie in kernel,  please feel free to
point out if there is anything wrong

thanks very much

---
Warmest, regards,
WANG.Jiong
