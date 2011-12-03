Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab1LCEwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 23:52:53 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59364 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab1LCEwt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 23:52:49 -0500
MIME-Version: 1.0
In-Reply-To: <CABexPfERzvC+f7S2s8YUrN-Zk_O+6r-mCijSo4B3i+j5G1hfAg@mail.gmail.com>
References: <CABexPfGvJB-Fvx2SbUbJaBVouAkv3UVmmfsTpp_zE8whpHVZEw@mail.gmail.com>
	<CAMzpN2haQjckBGkA1ujaCD0iehAsC2S-xO7eN89S+u+FQ65zXw@mail.gmail.com>
	<CABexPfERzvC+f7S2s8YUrN-Zk_O+6r-mCijSo4B3i+j5G1hfAg@mail.gmail.com>
Date: Sat, 3 Dec 2011 12:52:49 +0800
Message-ID: <CABexPfEhd39nvypacU1c_mr1+yygqZuq9ZfxEtm1YAY_D21OLQ@mail.gmail.com>
Subject: [Provisional Page Table] Why the linear address ranges starting both
 from 0 and PAGE_OFFSET are mapped to the same physical address range in the
 provisional page table?
From: zhihua che <zhihua.che@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Dec 2, 2011 at 11:35 AM, zhihua che <zhihua.che@gmail.com> wrote:
>> Hi, everyone
>>        I know that the kernel constructs a provisional page table in
>> head_32.S which maps the linear address ranges starting both from 0
>> and PAGE_OFFSET to the same physical address range.  My question is
>> why the linear address range starting from 0 needs to be mapped to the
>> same physical address range as the leaner address range starting from
>> PAGE_OFFSET does. I thought it's not necessary because the whole
>> kernel (the protected mode part) is linked to the VMA PAGE_OFFSET.
>>        But I found I was wrong. I'm writing a toy os which is also
>> linked to VMA PAGE_OFFSET and constructs a provisional page table as
>> the linux kernel does, and it works well with it. I mean it can enable
>> paging successfully and continue to execute as I expect after that
>> far-jump instruction. However, if I mapped only the linear address
>> starting from 0xc0000000, the far-jump instructions would load random
>> values to cs and eip respectfully and my os went crazy.
>
> The identity mapping is required for the brief period between when
> paging is enabled and the jump to the virtual address.  Once paging is
> enabled, eip still points to the low address for the next instruction,
> and the instruction fetch will cause a page fault if the identity
> mapping doesn't exist.
>
> --
> Brian Gerst


What you said means after setting the paging flag in cr0 and before
the far-jumping, the cs and eip still point to the low linear address
range (here is the range starting from 1M), so the kernel need this
range to be mapped as the higher linear address range (here is the
range starting from PAGE_OFFSET) is.  Right?

I think your explanation makes sense.

And furthermore, based on your explanation, I guess the lower linear
address range mapping can be removed after the kernel jumps to the
higher linear address. Precisely, the first page directory entries
(which was filled by that "movl %ecx,(%edx)" instruction above) can be
cleared after the ljmp __BOOT_CS, 1f instruction, because since then,
the cs and eip have been loaded with higher virtual address. Am I
right?

Harvey
