Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab2AJC7O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 21:59:14 -0500
Received: from mail.windriver.com ([147.11.1.11]:40192 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab2AJC7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 21:59:13 -0500
Message-ID: <4F0BA99E.1090006@windriver.com>
Date: Tue, 10 Jan 2012 10:59:42 +0800
From: "tiejun.chen" <tiejun.chen@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] kmemleak/module: only scan the existed data section
References: <1325059891-20540-1-git-send-email-tiejun.chen@windriver.com> <CAHkRjk5fuubEQaq2CD1cGE=W+Lf6svE6fN8KyDrY6=i3-=b_RA@mail.gmail.com>
In-Reply-To: <CAHkRjk5fuubEQaq2CD1cGE=W+Lf6svE6fN8KyDrY6=i3-=b_RA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas wrote:
> On 28 December 2011 08:11, Tiejun Chen <tiejun.chen@windriver.com> wrote:
>> We should only scan the sections containing data and it's size is not
>> zero as well.
>>
>> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
>> ---
>> �kernel/module.c | � �2 ++
>> �1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/module.c b/kernel/module.c
>> index 12cfa2b..0b93c30 100644
>> --- a/kernel/module.c
>> +++ b/kernel/module.c
>> @@ -2045,6 +2045,8 @@ static void kmemleak_load_module(struct module *mod, Elf_Ehdr *hdr,
>> � � � � � � � �if (strncmp(secstrings + sechdrs[i].sh_name, ".data", 5) != 0
>> � � � � � � � � � �&& strncmp(secstrings + sechdrs[i].sh_name, ".bss", 4) != 0)
>> � � � � � � � � � � � �continue;
>> + � � � � � � � if (sechdrs[i].sh_size == 0)
>> + � � � � � � � � � � � continue;
>>
>> � � � � � � � �kmemleak_scan_area((void *)sechdrs[i].sh_addr,
>> � � � � � � � � � � � � � � � � � sechdrs[i].sh_size, GFP_KERNEL);
> 
> I would rather move this check to kmemleak.c. But why would it be
> needed? Performance? A zero-size area shouldn't be scanned anyway.

When we call layout_sections() to calculate sh_entsize, often a zero-sized
.data/.bss section would be ordered as a middle of all valid sections. For example,
------
Symbol			Addr		size

.init.			0xf96d3000
......
.data(or .bss) 		0xf96d3180	0
......			0xf96d4000		

If so kmemleak_scan_area(0xf96d3180,0,GFP_KERNEL) is fine as we expect since
0xf96d3180 is always within a valid address scopes summarized all section,
0xf96d3000 ~  0xf96d4000. But sometimes if that is arranged as a last section:
-----
Symbol			Addr		size

.init.			0xf96d3000
......
.data(or .bss) 		0xf96d3180	0


An then the following call trace is triggered
......
kmemleak: Adding scan area to unknown object at 0xf96d3180
Call Trace:
[e9095de0] [c0008588] show_stack+0x68/0x1d8 (unreliable)
[e9095e30] [c0690094] dump_stack+0x2c/0x44
[e9095e40] [c015a190] kmemleak_scan_area+0x128/0x184
[e9095e70] [c00a145c] load_module+0xa98/0x1c04
[e9095f10] [c00a2650] sys_init_module+0x88/0x24c
[e9095f40] [c0012f7c] ret_from_syscall+0x0/0x4
--- Exception: c01 at 0xff63564
    LR = 0x10003414

Tiejun
