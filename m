Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab0HYHGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 03:06:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48715 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287Ab0HYHGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 03:06:44 -0400
Message-ID: <4C74C0FA.3010304@zytor.com>
Date: Wed, 25 Aug 2010 00:06:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix CONFIG_VMSPLIT_1G and 2G_OPT trampoline
References: <alpine.LSU.2.00.1008242235120.2515@sister.anvils> <20100825063041.GA25259@aftab>
In-Reply-To: <20100825063041.GA25259@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2010 11:30 PM, Borislav Petkov wrote:
> From: Hugh Dickins <hughd@google.com>
> Date: Wed, Aug 25, 2010 at 01:44:12AM -0400
> 
>> rc2 kernel crashes when booting second cpu on this CONFIG_VMSPLIT_2G_OPT
>> laptop: whereas cloning from kernel to low mappings pgd range does need
>> to limit by both KERNEL_PGD_PTRS and KERNEL_PGD_BOUNDARY, cloning kernel
>> pgd range itself must not be limited by the smaller KERNEL_PGD_BOUNDARY.
> 
> Yep, makes sense.
> 
> In looking around for other swapper_pg_dir manipulations, there's this
> piece in <arch/x86/kernel/reboot.c:machine_real_restart()>:
> 
>        /* Remap the kernel at virtual address zero, as well as offset zero
>           from the kernel segment.  This assumes the kernel segment starts at
>           virtual address PAGE_OFFSET. */
>        memcpy(swapper_pg_dir, swapper_pg_dir + KERNEL_PGD_BOUNDARY,
>                sizeof(swapper_pg_dir [0]) * KERNEL_PGD_PTRS);
> 
> and we're cloning to low mappings here but still take KERNEL_PGD_PTRS.
> 
> In the CONFIG_VMSPLIT_2G_OPT case, KERNEL_PGD_BOUNDARY and
> KERNEL_PGD_PTRS are 480 and 544, respectively, and IINM, and we end up
> overwriting the virtual mappings beginning at PAGE_OFFSET.
> 
> I guess this doesn't matter on reboot or am I missing something else?
> 

It doesn't matter on reboot, but the right thing would be to switch to
the trampoline page table here.  Same with suspend.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

