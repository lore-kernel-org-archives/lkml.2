Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab1LBQfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 11:35:34 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:65367 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093Ab1LBQfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 11:35:33 -0500
MIME-Version: 1.0
Date: Sat, 3 Dec 2011 00:35:31 +0800
Message-ID: <CABexPfGvJB-Fvx2SbUbJaBVouAkv3UVmmfsTpp_zE8whpHVZEw@mail.gmail.com>
Subject: [Provisional Page Table] Why the linear address ranges starting both
 from 0 and PAGE_OFFSET are mapped to the same physical address range in the
 provisional page table?
From: zhihua che <zhihua.che@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, everyone
        I know that the kernel constructs a provisional page table in
head_32.S which maps the linear address ranges starting both from 0
and PAGE_OFFSET to the same physical address range.  My question is
why the linear address range starting from 0 needs to be mapped to the
same physical address range as the leaner address range starting from
PAGE_OFFSET does. I thought it's not necessary because the whole
kernel (the protected mode part) is linked to the VMA PAGE_OFFSET.
        But I found I was wrong. I'm writing a toy os which is also
linked to VMA PAGE_OFFSET and constructs a provisional page table as
the linux kernel does, and it works well with it. I mean it can enable
paging successfully and continue to execute as I expect after that
far-jump instruction. However, if I mapped only the linear address
starting from 0xc0000000, the far-jump instructions would load random
values to cs and eip respectfully and my os went crazy.
        Here are the relating codes which are actually the same as the
linux kernel (32bit and disable the PAE)

page_pde_offset = (__PAGE_OFFSET >> 20);

         movl $pa(__brk_base), %edi
         movl $pa(initial_page_table), %edx
         movl $PTE_IDENT_ATTR, %eax
1:
         leal PDE_IDENT_ATTR(%edi),%ecx
         movl %ecx,(%edx)                                        /*
Here, here */
         movl %ecx,page_pde_offset(%edx)
         addl $4,%edx
         movl $1024, %ecx
2:
         stosl
         addl $0x1000,%eax
         loop 2b

         . . .

         ljmp $__BOOT_CS, $1f
1:

Precisely, my kernel goes well if the labeled line is kept while it
jumps to a nowhere place if the line is commented.
I can't figure out why because my kernel and linux kernel are both
linked with virtual address greater than PAGE_OFFSET.
