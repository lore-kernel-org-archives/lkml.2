Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab1I3Ali (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 20:41:38 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40953 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab1I3Alh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 20:41:37 -0400
Date: Thu, 29 Sep 2011 20:41:33 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Andrew Morton <akpm00@gmail.com>
cc: Josh Boyer <jwboyer@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Kosina <jkosina@suse.cz>, hongjiu.lu@intel.com,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: [RFC PATCH] binfmt_elf: Fix PIE execution with randomization
 disabled
In-Reply-To: <20110929141929.43df799d.akpm00@gmail.com>
Message-ID: <alpine.LFD.2.02.1109291958210.9106@xanadu.home>
References: <20110929195359.GJ16720@zod.bos.redhat.com> <20110929141929.43df799d.akpm00@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Sep 2011, Andrew Morton wrote:

> On Thu, 29 Sep 2011 15:53:59 -0400
> Josh Boyer <jwboyer@redhat.com> wrote:
> 
> > We've had a bug report[1] of some PIE programs getting a SIGKILL upon exec
> > if you disable address randomization with:
> > 
> > 	echo 0 > /proc/sys/kernel/randomize_va_space
> > 
> > I tracked this down to get_unmapped_area_prot returning -ENOMEM because
> > the address being passed in is larger than TASK_SIZE - len for the bss
> > section of the test executable.  That filters back to set_brk returning
> > an error to load_elf_binary and the SIGKILL being sent around line 872
> > of binfmt_elf.c.
> > 
> > H.J. submitted an upstream bug report [2] as well, but got no feedback
> > and we can't view it with kernel.org being down anyway.  He came up with
> > the patch below as well, which is what I'm sending on for comments.  The
> > changelog is my addition, so if that is wrong yell at me.
> > 
> > I wanted to get some more eyes on this, because the current code sets
> > load_bias to 0 unconditionally on CONFIG_X86 or CONFIG_ARM.  I have no
> > idea why that is.  The original execshield patches had an #ifdef on
> > __i386__ but the patch that was commited to add PIE support has the
> > CONFIG_X86 setting.
> > 
> 
> It appears that Nicolas understood what's going on in there when he
> wrote e4eab08d6050ad0 ("ARM: 6342/1: fix ASLR of PIE executables"). 
> Alas, that patch's changelog is rather useless.
> 
> Help?

Well, in order to obtain randomization, the addr argument to elf_map() 
must be zero to eventually let arch_get_unmapped_area() do its job of 
selecting a random address.

Since only X86 supported ASLR at the time, I simply did the same for ARM 
i.e. let load_bias be set to 0 so elf_map() would get a zero address.

> Also, please: review and test?
> 
> >  #if defined(CONFIG_X86) || defined(CONFIG_ARM)
> > -			load_bias = 0;
> > +			if (vaddr)
> > +				load_bias = 0;
> > +			else
> > +				load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE);
> >  #else
> >  			load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
> >  #endif

Simply looking at this patch, I don't see how the second argument to 
elf_map() called as follows could ever be zero anymore, effectively 
breaking ASLR.

                error = elf_map(bprm->file, load_bias + vaddr, elf_ppnt,
                                elf_prot, elf_flags, 0);


Nicolas
