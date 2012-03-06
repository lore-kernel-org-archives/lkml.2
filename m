Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177Ab2CFBfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 20:35:11 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40655 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758066Ab2CFBfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 20:35:09 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of yhlu.kernel@gmail.com designates 10.236.78.72 as permitted sender) smtp.mail=yhlu.kernel@gmail.com; dkim=pass header.i=yhlu.kernel@gmail.com
MIME-Version: 1.0
In-Reply-To: <1330669703-20176-1-git-send-email-zhenzhong.duan@oracle.com>
References: <1330669703-20176-1-git-send-email-zhenzhong.duan@oracle.com>
Date: Mon, 5 Mar 2012 17:35:09 -0800
X-Google-Sender-Auth: GmbknNPdqfmGqaYyuAEDkZk4sT0
Message-ID: <CAE9FiQV3CyB1YRPDxFu-jGr73+Qwpkn4O4QYYZvBJcyZA5Gouw@mail.gmail.com>
Subject: Re: [PATCH] Initialize max_pfn_mapped as initial ident mapping size
 for x86_64
From: Yinghai Lu <yinghai@kernel.org>
To: zhenzhong.duan@oracle.com, Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, joe.jin@oracle.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 1, 2012 at 10:28 PM,  <zhenzhong.duan@oracle.com> wrote:
> From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
>
> It's better to initialize max_pfn_mapped as initial ident
> mapping size but not initial kernel map size for x86_64.
> This is also in accordance with i386 code.
>
> It lead to page tables allocation to as high as 1G for init_memory_mapping,
> this will allow larger crashkernel reservation.

it is not that simple.

whole history:
before following patch, on x86_64, for low memory (under 4g) pgtable
will be allocated just under TOML
and even those memory is not mapped directly. because now we are using
early_ioremap to access those
page table.

but looks it has problem with S4 resume. so good_end is set to initial
mapped high address.
(that is 512M). So page table will just below 512M
but crash kernel is allocated below 768M. so will have no chance to
get 512M porting for crashkernel.

Now your patch just set initial mapping limit to 1g. but according to
arch/x86/kernel/head_64.S
we only have initial mapping to 512M.

So you can not just simply set to 1G,  that will confuse early
memblock allocator.

We may update find_early_table_space() to use 1G as good_end for
x86_64 that will be less confusing.

also even in that case, you still need to double check if S4 resume is
broken again.


Or We can change KERNL_IMAGE_SIZE to 1G?

Or we need to dig out when S4 resume is broken at first place when we
put page table near TOML.


Thanks

       Yinghai

commit 8548c84da2f47e71bbbe300f55edb768492575f7
Author: Takashi Iwai <tiwai@suse.de>
Date:   Sun Oct 23 23:19:12 2011 +0200

    x86: Fix S4 regression

    Commit 4b239f458 ("x86-64, mm: Put early page table high") causes a S4
    regression since 2.6.39, namely the machine reboots occasionally at S4
    resume.  It doesn't happen always, overall rate is about 1/20.  But,
    like other bugs, once when this happens, it continues to happen.

    This patch fixes the problem by essentially reverting the memory
    assignment in the older way.

    Signed-off-by: Takashi Iwai <tiwai@suse.de>
    Cc: <stable@kernel.org>
    Cc: Rafael J. Wysocki <rjw@sisk.pl>
    Cc: Yinghai Lu <yinghai.lu@oracle.com>
    [ We'll hopefully find the real fix, but that's too late for 3.1 now ]
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 3032644..87488b9 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -63,9 +63,8 @@ static void __init find_early_table_space(unsigned
long end, int use_pse,
 #ifdef CONFIG_X86_32
        /* for fixmap */
        tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
-
-       good_end = max_pfn_mapped << PAGE_SHIFT;
 #endif
+       good_end = max_pfn_mapped << PAGE_SHIFT;

        base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
        if (base == MEMBLOCK_ERROR)
