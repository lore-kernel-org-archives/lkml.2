Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab1KDP0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 11:26:16 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:53766 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755863Ab1KDP0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 11:26:12 -0400
X-Sasl-enc: HxHRjtrBQPVLmJ1toH6jvJhI9x1ANuk9oP7NdSInXgql 1320420372
Date: Fri, 4 Nov 2011 08:25:32 -0700
From: Greg KH <greg@kroah.com>
To: Borislav Petkov <bp@amd64.org>
Cc: linux-stable <stable@vger.kernel.org>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] x86, amd: Avoid cache aliasing penalties on AMD
 family 15h
Message-ID: <20111104152532.GB29754@kroah.com>
References: <20111104112209.GB8020@aftab>
 <1320405995-10199-1-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320405995-10199-1-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 12:26:32PM +0100, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Upstream commit: dfb09f9b7ab03fd367740e541a5caf830ed56726
> 
> This patch provides performance tuning for the "Bulldozer" CPU. With its
> shared instruction cache there is a chance of generating an excessive
> number of cache cross-invalidates when running specific workloads on the
> cores of a compute module.
> 
> This excessive amount of cross-invalidations can be observed if cache
> lines backed by shared physical memory alias in bits [14:12] of their
> virtual addresses, as those bits are used for the index generation.
> 
> This patch addresses the issue by clearing all the bits in the [14:12]
> slice of the file mapping's virtual address at generation time, thus
> forcing those bits the same for all mappings of a single shared library
> across processes and, in doing so, avoids instruction cache aliases.
> 
> It also adds the command line option "align_va_addr=(32|64|on|off)" with
> which virtual address alignment can be enabled for 32-bit or 64-bit x86
> individually, or both, or be completely disabled.
> 
> This change leaves virtual region address allocation on other families
> and/or vendors unaffected.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> Link: http://lkml.kernel.org/r/1312550110-24160-2-git-send-email-bp@amd64.org
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> ---
>  Documentation/kernel-parameters.txt |   13 ++++++
>  arch/x86/include/asm/elf.h          |   31 +++++++++++++
>  arch/x86/kernel/cpu/amd.c           |   13 ++++++
>  arch/x86/kernel/sys_x86_64.c        |   81 +++++++++++++++++++++++++++++++++-
>  arch/x86/mm/mmap.c                  |   15 ------
>  arch/x86/vdso/vma.c                 |    9 ++++
>  6 files changed, 144 insertions(+), 18 deletions(-)

I really feel nervous adding this patch to the -stable tree(s).  It's
bigger than "just a bugfix" and it adds new functionality.

I'm aware that it is needed for your new hardware, which is great, but
it doesn't really follow the Documentation/stable_kernel_rules.txt
requirements, does it?

I need an ACK from the x86 maintainers before I'm going to be
comfortable adding this, and then the other, patches in this series.

Peter, Ingo, Thomas, your opinions?

thanks,

greg k-h
