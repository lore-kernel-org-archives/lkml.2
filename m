Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031306Ab2HGWxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:53:19 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55610 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031207Ab2HGWxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:53:11 -0400
Message-ID: <50219C45.7030601@ti.com>
Date: Tue, 7 Aug 2012 18:52:53 -0400
From: Cyril Chemparathy <cyril@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, <catalin.marinas@arm.com>, <linux@arm.linux.org.uk>,
        <will.deacon@arm.com>
Subject: Re: [PATCH 01/22] ARM: add mechanism for late code patching
References: <1343775898-28345-1-git-send-email-cyril@ti.com> <1343775898-28345-2-git-send-email-cyril@ti.com> <alpine.LFD.2.02.1208040045360.5231@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1208040045360.5231@xanadu.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

On 8/4/2012 1:38 AM, Nicolas Pitre wrote:
[...]
>> extern unsigned __patch_table_begin, __patch_table_end;
>
> You could use "exttern void __patch_table_begin" so those symbols don't
> get any type that could be misused by mistake, while you still can take
> their addresses.
>

Looks like we'll have to stick with a non-void type here.  The compiler 
throws a warning when we try to take the address of a void.

[...]
> Did you verify with some test program that your patching routines do
> produce the same opcodes as the assembled equivalent for all possible
> shift values?  Especially for Thumb2 code which isn't as trivial to get
> right as the ARM one.
>

We've refactored the patching code into separate functions as:

static int do_patch_imm8_arm(u32 insn, u32 imm, u32 *ninsn);
static int do_patch_imm8_thumb(u32 insn, u32 imm, u32 *ninsn);


With this, the following test code has been used to verify the generated 
instruction encoding:

u32 arm_check[] = {
	0xe2810041, 0xe2810082, 0xe2810f41, 0xe2810f82, 0xe2810e41,
	0xe2810e82, 0xe2810d41, 0xe2810d82, 0xe2810c41, 0xe2810c82,
	0xe2810b41, 0xe2810b82, 0xe2810a41, 0xe2810a82, 0xe2810941,
	0xe2810982, 0xe2810841, 0xe2810882, 0xe2810741, 0xe2810782,
	0xe2810641, 0xe2810682, 0xe2810541, 0xe2810582, 0xe2810441,
};

u32 thumb_check[] = {
	0xf1010081, 0xf5017081, 0xf5017001, 0xf5016081, 0xf5016001,
	0xf5015081, 0xf5015001, 0xf5014081, 0xf5014001, 0xf5013081,
	0xf5013001, 0xf5012081, 0xf5012001, 0xf5011081, 0xf5011001,
	0xf5010081, 0xf5010001, 0xf1017081, 0xf1017001, 0xf1016081,
	0xf1016001, 0xf1015081, 0xf1015001, 0xf1014081, 0xf1014001,
};

int do_test(void)
{
	int i, ret;
	u32 ninsn, insn;
	
	insn = arm_check[0];
	for (i = 0; i < ARRAY_SIZE(arm_check); i++) {
		ret = do_patch_imm8_arm(insn, 0x41 << i, &ninsn);
		if (ret < 0)
			pr_err("patch failed at shift %d\n", i);
		if (ninsn != arm_check[i])
			pr_err("mismatch at %d, expect %x, got %x\n",
			       i, arm_check[i], ninsn);
	}

	insn = thumb_check[0];
	for (i = 0; i < ARRAY_SIZE(thumb_check); i++) {
		ret = do_patch_imm8_thumb(insn, 0x81 << i, &ninsn);
		if (ret < 0)
			pr_err("patch failed at shift %d\n", i);
		if (ninsn != thumb_check[i])
			pr_err("mismatch at %d, expect %x, got %x\n",
			       i, thumb_check[i], ninsn);
	}
}

Any ideas on improving these tests?

-- 
Thanks
- Cyril
