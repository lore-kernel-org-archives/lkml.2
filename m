Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab0EUVGH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 17:06:07 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:38406 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab0EUVGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 17:06:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=n6hWMrr1jlMMsDXnBZWgGTcVSU05Fnjm+g5HwvkoovYLsbT0JxRufUDvn7FEUQsIKT
         /INjfm876GbD8RWmodyLSx/pjP1J6lT3PWjSnrWAN5HVU41jtVaxlx2rOeWOQBXYQD1+
         uIfsfBhtIIU+q1LGRRwb4hwAlL+rb5pp1iDj8=
MIME-Version: 1.0
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 21 May 2010 16:58:53 -0400
Message-ID: <AANLkTilVZ3GCU_hsfVNeR4oG6ETREb9UeJ0Cv_5hSwVZ@mail.gmail.com>
Subject: missing .data.shared_align placement in vmlinux
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

am i missing something or does the .data.shared_align section lack
definition in vmlinux.lds.h and all arch vmlinux.lds.S files ?

with the recent change "net: remove time limit in process_backlog()",
the softnet_data variable changed from "DEFINE_PER_CPU()" to
"DEFINE_PER_CPU_ALIGNED()" which moved it from the .data section to
the .data.shared_align section.  i'm not saying this patch is wrong,
just that is what caused me to notice this larger problem.  no one
else in the kernel is using this aligned macro variant, so i imagine
that's why no one has noticed yet.

since .data.shared_align isnt declared in any vmlinux files that i can
see, the linker just places it last.  this "just works" for most
people, but when building a ROM kernel on Blackfin systems, it causes
section overlap errors:
bfin-uclinux-ld.real: section .init.data [00000000202e06b8 ->
00000000202e48b7] overlaps section .data.shared_aligned
[00000000202e06b8 -> 00000000202e0723]
i imagine other arches which support the ROM config option and thus do
funky placement would see similar issues ...

on x86, it is stuck in a dedicated section:
  [ 8] .data             PROGBITS        ffffffff810ec000 2ec000
0303a8 00  WA  0   0 4096
  [ 9] .data.shared_alig PROGBITS        ffffffff8111c3c0 31c3c0
0000c8 00  WA  0   0 64

the ifdef forest in asm-generic/percpu.h is beyond a quick glance &
fix, so i leave it up to someone else ;)
-mike
