Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab0JOALX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 20:11:23 -0400
Received: from mail-pz0-f66.google.com ([209.85.210.66]:41122 "EHLO
	mail-pz0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab0JOALV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 20:11:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=vGu/MSiFJG6EaUytyh1G5Oysd8DQ5ggfo4N0Mp3cp2GmuzyPI2WSD8K29gGMjK+DbG
         9mudQvE1qmE2n9aFduzB4x4aISVSwaduq5UPXFFQOO1mjGHoP9oxyLtXPkZs1lVle7Iq
         VhzhiSoW9sd4SG15cr71/tq1sKCy6YMtDotuc=
MIME-Version: 1.0
Date: Thu, 14 Oct 2010 16:58:51 -0700
Message-ID: <AANLkTi=29x3ng4uhUAMewe5Gr25ayDknJS9iGS4c51Yw@mail.gmail.com>
Subject: kernel won't boot if kernel image passes 0xffffffff82000000
From: Rong Xu <rong.xu3@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found that if the kernel image passes 0xffffffff82000000, the kernel won't
boot. It dies in very early stage of booting, right after the kernel image
is loaded.

More details:
This is 2.6.26 kernel on x86-64 platform, using the default x86_64 config.
I'm not booting with any option. Kernel image starts from
0xffffffff80000000. kernel_text starts from 0xffffffff80200000. From the
comments in head64.S, I suppose we can use 512M for kernel image, to
0xffffffffa000000 where the module starts. But my experiments shows the
maximum kernel image size is from 0xffffffff80200000 to 0xffffffff82000000
(30MB).

Here are some of the experiments I did:
(1) increase the bss size to let it pass 0xffffffff82000000, then kernel
    won't boot.
(2) change the linker-script to move the bss section of a good kernel,
     making part of the section pass 0xffffffff82000000, then the kernel
     becomes not bootable.
(3) change the linker-script to move the bss section of a good kernel, not
     letting it pass 0xffffffff82000000. the result kernel can boot.
(4) keep all sections intact and move PHYSICAL_START to make the end of
     kernel image pass 0xffffffff82000000. Kernel won't boot
(5) keep all sections intact and move PHYSICAL_START, not letting the kernel
     image pass 0xffffffff82000000. the result kernel can boot.

So it looks this not related to the kernel size, but to the address
0xffffffff82000000. what is special for this address? I could not find any
documentation (or source reference) to this address.
In the head_64.S, we actually initialized the PMD entries for all the
possible 512MB space. I think we should be able to use it. In a booted
kernel, the PMD entries for 0xffffffff82000000 is zeroed out (when I dump
the kernel page table). so I guess this address is not used by other part of
kernel.

I tried kernel 2.6.27 and it seems to have the same issue.

Any comment?

-Rong
