Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933348Ab2KEWG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 17:06:29 -0500
Received: from [204.155.152.216] ([204.155.152.216]:44787 "EHLO shutemov.name"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932222Ab2KEWG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 17:06:28 -0500
Date: Tue, 6 Nov 2012 00:08:03 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, andi@firstfloor.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v3 1/8] x86: Improve __phys_addr performance by making
 use of carry flags and inlining
Message-ID: <20121105220803.GA26132@shutemov.name>
References: <20121105185657.10205.27419.stgit@gitlad.jf.intel.com>
 <20121105190332.10205.22300.stgit@gitlad.jf.intel.com>
 <20121105202425.GA25671@shutemov.name>
 <5098360C.6090805@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5098360C.6090805@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 01:56:28PM -0800, Alexander Duyck wrote:
> On 11/05/2012 12:24 PM, Kirill A. Shutemov wrote:
> > On Mon, Nov 05, 2012 at 11:04:06AM -0800, Alexander Duyck wrote:
> >> This patch is meant to improve overall system performance when making use of
> >> the __phys_addr call.  To do this I have implemented several changes.
> >>
> >> First if CONFIG_DEBUG_VIRTUAL is not defined __phys_addr is made an inline,
> >> similar to how this is currently handled in 32 bit.  However in order to do
> >> this it is required to export phys_base so that it is available if __phys_addr
> >> is used in kernel modules.
> >>
> >> The second change was to streamline the code by making use of the carry flag
> >> on an add operation instead of performing a compare on a 64 bit value.  The
> >> advantage to this is that it allows us to significantly reduce the overall
> >> size of the call.  On my Xeon E5 system the entire __phys_addr inline call
> >> consumes a little less than 32 bytes and 5 instructions.  I also applied
> >> similar logic to the debug version of the function.  My testing shows that the
> >> debug version of the function with this patch applied is slightly faster than
> >> the non-debug version without the patch.
> >>
> >> When building the kernel with the first two changes applied I saw build
> >> warnings about __START_KERNEL_map and PAGE_OFFSET constants not fitting in
> >> their type.  In order to resolve the build warning I changed their type from
> >> UL to ULL.
> > What kind of warning messages did you see?
> > It's strange: sizeof(unsinged long) == sizeof(unsinged long long) on
> > x86_64
> 
> One of the warnings is included below:
> 
> In file included from /usr/src/kernels/linux-next/arch/x86/include/asm/page_types.h:37,
>                  from /usr/src/kernels/linux-next/arch/x86/include/asm/pgtable_types.h:5,
>                  from /usr/src/kernels/linux-next/arch/x86/include/asm/boot.h:11,
>                  from arch/x86/realmode/rm/../../boot/boot.h:26,
>                  from arch/x86/realmode/rm/../../boot/regs.c:19,
>                  from arch/x86/realmode/rm/regs.c:1:
> /usr/src/kernels/linux-next/arch/x86/include/asm/page_64_types.h: In function '__phys_addr_nodebug':
> /usr/src/kernels/linux-next/arch/x86/include/asm/page_64_types.h:63: warning: integer constant is too large for 'unsigned long' type
> /usr/src/kernels/linux-next/arch/x86/include/asm/page_64_types.h:66: warning: integer constant is too large for 'unsigned long' type
> /usr/src/kernels/linux-next/arch/x86/include/asm/page_64_types.h:66: warning: integer constant is too large for 'unsigned long' type
> 
> The warnings all seemed to originate from several different spots
> throughout the x86 tree.  All of the warning messages include
> arch/x86/boot/boot.h:26 and then from there up the included from list is
> always the same.

Realmode code compiles with -m32. I guess it's just wrong that it tries to
include <asm/page_64_types.h>.

-- 
 Kirill A. Shutemov
