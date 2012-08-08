Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103Ab2HHF4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 01:56:46 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:49021 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455Ab2HHF4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 01:56:45 -0400
Date: Wed, 8 Aug 2012 01:56:41 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Cyril Chemparathy <cyril@ti.com>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 01/22] ARM: add mechanism for late code patching
In-Reply-To: <50219C45.7030601@ti.com>
Message-ID: <alpine.LFD.2.02.1208080106500.5231@xanadu.home>
References: <1343775898-28345-1-git-send-email-cyril@ti.com> <1343775898-28345-2-git-send-email-cyril@ti.com> <alpine.LFD.2.02.1208040045360.5231@xanadu.home> <50219C45.7030601@ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Aug 2012, Cyril Chemparathy wrote:

> Hi Nicolas,
> 
> On 8/4/2012 1:38 AM, Nicolas Pitre wrote:
> [...]
> > > extern unsigned __patch_table_begin, __patch_table_end;
> > 
> > You could use "exttern void __patch_table_begin" so those symbols don't
> > get any type that could be misused by mistake, while you still can take
> > their addresses.
> > 
> 
> Looks like we'll have to stick with a non-void type here.  The compiler throws
> a warning when we try to take the address of a void.

Ah, I see. Bummer.  This used not to be the case with older gcc 
versions.

> [...]
> > Did you verify with some test program that your patching routines do
> > produce the same opcodes as the assembled equivalent for all possible
> > shift values?  Especially for Thumb2 code which isn't as trivial to get
> > right as the ARM one.
> > 
> 
> We've refactored the patching code into separate functions as:
> 
> static int do_patch_imm8_arm(u32 insn, u32 imm, u32 *ninsn);
> static int do_patch_imm8_thumb(u32 insn, u32 imm, u32 *ninsn);
> 
> 
> With this, the following test code has been used to verify the generated
> instruction encoding:
> 
> u32 arm_check[] = {
> 	0xe2810041, 0xe2810082, 0xe2810f41, 0xe2810f82, 0xe2810e41,
> 	0xe2810e82, 0xe2810d41, 0xe2810d82, 0xe2810c41, 0xe2810c82,
> 	0xe2810b41, 0xe2810b82, 0xe2810a41, 0xe2810a82, 0xe2810941,
> 	0xe2810982, 0xe2810841, 0xe2810882, 0xe2810741, 0xe2810782,
> 	0xe2810641, 0xe2810682, 0xe2810541, 0xe2810582, 0xe2810441,
> };

Instead of using this array you could let the assembler do it for you 
like this:

asm (" \n\
	.arm \n\
arm_check: \n\
        .set shft, 0 \n\
        .rep 12 \n\
        add     r1, r2, #0x81 << \shft \n\
        .set shft, \shft + 2 \n\
        .endr \n\
");

> u32 thumb_check[] = {
> 	0xf1010081, 0xf5017081, 0xf5017001, 0xf5016081, 0xf5016001,
> 	0xf5015081, 0xf5015001, 0xf5014081, 0xf5014001, 0xf5013081,
> 	0xf5013001, 0xf5012081, 0xf5012001, 0xf5011081, 0xf5011001,
> 	0xf5010081, 0xf5010001, 0xf1017081, 0xf1017001, 0xf1016081,
> 	0xf1016001, 0xf1015081, 0xf1015001, 0xf1014081, 0xf1014001,

Same idea here.


Nicolas
