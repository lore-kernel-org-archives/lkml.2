Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab1DKRmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 13:42:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56585 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751990Ab1DKRmG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 13:42:06 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=n+ckDXVk6rN=Mgh+BApbrPqPfmg@mail.gmail.com>
References: <BANLkTi=n+ckDXVk6rN=Mgh+BApbrPqPfmg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 11 Apr 2011 10:41:44 -0700
Message-ID: <BANLkTi=R_D9ujCFeKv_o_U83GAR35X3TOQ@mail.gmail.com>
Subject: Re: Crash with kfree(null) on MacBook? kobject_set_name_vargs
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Botting <andy@andybotting.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/10 Rafał Miłecki <zajec5@gmail.com>:
> I'm writing new axi bus driver and one of the early testers reported
> it crashing for him. Andy is using MacBook and backtrace+debugging
> pretty clearly point to kfree being called on null string.
>
> The most interesting part of code is:
> axi_info("[axi_register_cores][%d] current name: %s\n", i, core->dev.kobj.name);
> axi_info("[axi_register_cores][%d] calling dev_set_name with %d, %d
> for 0x%03X\n", i, 0/*bus->busnumber*/, dev_id, core->id.id);
> err = dev_set_name(&core->dev, "axi%d:%d", 0/*bus->busnumber*/, dev_id);
> axi_info("[axi_register_cores][%d] dev_set_name result: %d\n", i, err);
>
> The result is:
> [axi_register_cores][1] current name: (null)
> [axi_register_cores][1] calling dev_set_name with 0, 0 for 0x812
> BUG: unable to handle kernel paging request at ffffeba400000000
> IP: [<ffffffff8108c4d4>] kfree+0x2a/0x8a
>
> Whole code: http://pastie.org/1779473
> Whole result: http://pastie.org/1779416
>
> Can you help me with this issue, please? On my machine everything goes fine:
> [axi_register_cores][1] current name: (null)
> [axi_register_cores][1] calling dev_set_name with 0, 0 for 0x812
> [axi_register_cores][1] dev_set_name result: 0
> [axi_register_cores][1] Register dev for core 0x812
>
> bcopeland on #linux-wireless suggested turning on SLAB or SLUB. Is
> this going to provide some interesting info?

The disassembly of the oopsing code (kfree()) is:

   0:	41 54                	push   %r12
   2:	48 83 ff 10          	cmp    $0x10,%rdi
   6:	55                   	push   %rbp
   7:	53                   	push   %rbx
   8:	48 89 fb             	mov    %rdi,%rbx
   b:	76 78                	jbe    0x85
   d:	9c                   	pushfq
   e:	5d                   	pop    %rbp
   f:	fa                   	cli
  10:	e8 85 21 f9 ff       	callq  0xfffffffffff9219a
  15:	48 ba 00 00 00 00 00 	movabs $0xffffea0000000000,%rdx
  1c:	ea ff ff
  1f:	48 c1 e8 0c          	shr    $0xc,%rax
  23:	48 6b c0 38          	imul   $0x38,%rax,%rax
  27:	48 01 d0             	add    %rdx,%rax
  2a:*	48 8b 10             	mov    (%rax),%rdx     <-- trapping instruction
  2d:	66 85 d2             	test   %dx,%dx
  30:	79 04                	jns    0x36

and from that you can see that the parameter that was passed in to
kfree (which was originally in %rdi) is now in %rbx.

That, in turn, is 0x202.

So it's not NULL. The fact that

  axi_info("[axi_register_cores][%d] current name: %s\n", i,
core->dev.kobj.name);

prints out NULL is because the string printout code does this:

        if ((unsigned long)s < PAGE_SIZE)
                s = "(null)";


which admittedly is not very helpful in this case (but it's usually
nicer than just oopsing).

So code->dev.kobj.name is corrupt even before.

Where that corruption comes from, I have no idea, but there is no
point in blaming kfree() or dev_set_name().

                           Linus
