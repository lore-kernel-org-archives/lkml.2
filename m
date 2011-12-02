Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206Ab1LBRO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 12:14:57 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65254 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177Ab1LBRO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 12:14:56 -0500
MIME-Version: 1.0
Date: Sat, 3 Dec 2011 01:14:55 +0800
Message-ID: <CABexPfGv2TsALh44kif26SDu7JH=S9k+=MGWmW4QvkwMjuhh-Q@mail.gmail.com>
Subject: [Provisional Page Table] Why the linear address ranges starting both
 from 0 and PAGE_OFFSET are mapped to a same physical address range in
 provisional page table?
From: zhihua che <zhihua.che@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone
        I know that the linux kernel constructs a provisional page
table to map the linear address ranges starting both from 0 and
PAGE_OFFSET to a same physical address range. I thought it's not
necessary because the kernel, precisely the protected mode part, is
linked to the VMA PAGE_OFFSET.
        But i found I was wrong. I'm writing a toy os which is similar
with the linux kernel. it also constructs a provisional page table as
the linux kernel does. In the first place it works well with it. I
mean it can enable the paging successfully and execute as I expect
after that far-jump instruction. However, if the provisional page
table maps only the linear address range starting from PAGE_OFFSET, my
kernel would load the cs and eip with random values right after that
far-jump instruction and went crazy. By the way, my kernel is also
linked to VMA PAGE_OFFSET.
        Here are the relating codes. Obviously the are the same with
the linux kernel (32-bit and disable PAE)

page_pde_offset = (__PAGE_OFFSET >> 20);

        movl $pa(__brk_base), %edi
        movl $pa(initial_page_table), %edx
        movl $PTE_IDENT_ATTR, %eax
1:
        leal PDE_IDENT_ATTR(%edi),%ecx
        movl %ecx,(%edx)                                   /* this
special line */
        movl %ecx,page_pde_offset(%edx)
        addl $4,%edx
        movl $1024, %ecx
2:
        stosl
        addl $0x1000,%eax
        loop 2b

        . . .

        ljmp __BOOT_CS, 1f
1:

        Precisely,  my kernel goes well if the special line above is
kept while it could go crazy if the line is commented.
        I can't figure out why because my kernel and the linux are
both linked to a VMA equal with or greater than PAGE_OFFSET. The lower
linear addresses are not accessed at all.
