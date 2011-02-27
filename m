Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab1B0Riq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 12:38:46 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31119 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab1B0Rio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 12:38:44 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6270"; a="76756645"
From: David Brown <davidb@codeaurora.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/4] msm: scm: Mark inline asm as volatile
References: <1298573085-23217-1-git-send-email-sboyd@codeaurora.org>
	<1298573085-23217-2-git-send-email-sboyd@codeaurora.org>
	<1298635017.958.0.camel@e102144-lin.cambridge.arm.com>
	<8yapqqe3bs3.fsf@huya.qualcomm.com> <1298805034.4626.4.camel@jazzbox>
X-Hashcash: 1:20:110227:linux-kernel@vger.kernel.org::ilpCcYjqwTUi/Vot:0000000000000000000000000000000000ssb
X-Hashcash: 1:20:110227:linux-arm-msm@vger.kernel.org::I6Lv6tO0Qz17jfIP:000000000000000000000000000000001z1s
X-Hashcash: 1:20:110227:sboyd@codeaurora.org::bgtyafzqKyBt967r:000000000000000000000000000000000000000000/K4
X-Hashcash: 1:20:110227:linux-arm-kernel@lists.infradead.org::jtDcr/XGYbj83Xjc:00000000000000000000000003WhO
X-Hashcash: 1:20:110227:will.deacon@arm.com::c7Y/VerpkfamPMMu:000000000000000000000000000000000000000000FSJF
Date: Sun, 27 Feb 2011 09:38:43 -0800
In-Reply-To: <1298805034.4626.4.camel@jazzbox> (Will Deacon's message of "Sun,
	27 Feb 2011 11:10:33 +0000")
Message-ID: <8yalj112x98.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 27 2011, Will Deacon wrote:

> On Sat, 2011-02-26 at 18:12 +0000, David Brown wrote:
>> On Fri, Feb 25 2011, Will Deacon wrote:
>
>> > These asm blocks all have sensible looking output constraints. Why
>> > do they need to be marked volatile?
>> 
>> Without the volatile, the compiler is free to assume the only side
>> effects of the asm are to modify the output registers.  The volatile is
>> needed to indicate to the compiler that the asm has other side effects.
>
> As far as I know, volatile asm does two things:
>
> (1) It stops the compiler from reordering the asm block with respect to
> other volatile statements.
>
> (2) It prevents the compiler from optimising the block away when
> dataflow analysis indicates it's not required.
>
> If side-effects need to be indicated, won't a memory clobber do the
> trick?

Per the gcc manual:

    If your assembler instructions access memory in an unpredictable
   fashion, add `memory' to the list of clobbered registers.  This will
   cause GCC to not keep memory values cached in registers across the
   assembler instruction and not optimize stores or loads to that
   memory.  You will also want to add the `volatile' keyword if the
   memory affected is not listed in the inputs or outputs of the `asm',
   as the `memory' clobber does not count as a side-effect of the `asm'.
   If you know how large the accessed memory is, you can add it as input
   or output but if this is not known, you should add `memory'.  As an
   example, if you access ten bytes of a string, you can use a memory
   input like:

The smc instruction is similar to a syscall.  When in the secure world,
the processor is making state changes.  It's not quite correct to
declare this as memory, because the memory used when secure isn't even
accessible to us.  As far as I can tell, the volatile is the only way to
tell the compiler this.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
