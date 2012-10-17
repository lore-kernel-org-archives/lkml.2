Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab2JQO1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:27:10 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:38750 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757191Ab2JQO1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:27:07 -0400
MIME-Version: 1.0
In-Reply-To: <CACM3HyEpypULRWUc5ZnLnZ=uOWf3_j=9PXZiJrT_BXyGcQe9yg@mail.gmail.com>
References: <20121016223508.GR2616@ZenIV.linux.org.uk>
	<CACM3HyEpypULRWUc5ZnLnZ=uOWf3_j=9PXZiJrT_BXyGcQe9yg@mail.gmail.com>
Date: Wed, 17 Oct 2012 16:27:06 +0200
Message-ID: <CAHTX3dKDsOiUwtXxAUj-F4Y4rO+UZZDR4ufx_nxf+vuhmz46WA@mail.gmail.com>
Subject: Re: new execve/kernel_thread design
From: Michal Simek <monstr@monstr.eu>
To: Jonas Bonn <jonas@southpole.se>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Richard Kuo <rkuo@codeaurora.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Lennox Wu <lennox.wu@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Mundt <lethal@linux-sh.org>, Chris Zankel <chris@zankel.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/17 Jonas Bonn <jonas@southpole.se>:
> On 17 October 2012 00:35, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>
>> Not even a tentative patchset: hexagon, openrisc, tile, xtensa.
>>
>
> I did most of the OpenRISC conversion last weekend... the
> kernel_thread bits work fine but I end up with the init thread dying
> with what I've got now for kernel_execve.  Once I've got that sorted
> out, I'll pass this along to you.

I am testing the Microblaze conversion and I see the similar problem
with GENERIC_KERNEL_EXECVE
(commit: http://git.kernel.org/?p=linux/kernel/git/viro/signal.git;a=commit;h=6aa044199aed5b541eba7fe7f25efdfb3a655a58)

I have look at the patch and I have found this.
(From description above: a kernel thread can become a userland
process.  The primitive is kernel_execve())

In  init/main.c:795/run_init_process() kernel_execve is called.
In old style, kernel_execve is called which runs microblaze
kernel_execve which calls __NR_execve as syscall.
In entry.S user exception detects that jump comes from kernel space
and save pt_regs on the current stack
and calls sys_execve and then microblaze_execve with 4th argument
which is pointer to pt_regs, etc.

In the patch above there is directly used current_pt_regs() function
which works good for newly created threads
when pt_regs are exactly in current_pt_regs() position but not for
pt_regs which are saved on the stack
which is the init task case.

Also this is the reason why microblaze has implementation for calling
_user_exception from the kernel space.
I believe that it is called just once for /init.

My question is how should /init be called? Because I need to save
pt_regs to current_pt_regs() position where
generic kernel_execve expects it.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
