Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab2HaQmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 12:42:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56458 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754479Ab2HaQma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 12:42:30 -0400
References: <5017AE48.5090108@redhat.com> <1346430699-19894-1-git-send-email-stefan.bader@canonical.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <1346430699-19894-1-git-send-email-stefan.bader@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] x86/mm: Limit 2/4M size calculation to x86_32
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 31 Aug 2012 09:41:50 -0700
To: Stefan Bader <stefan.bader@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Avi Kivity <avi@redhat.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
        Tejun Heo <tj@kernel.org>,
        Konrad Rezeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Message-ID: <a6b71e0f-d2d3-44b5-a939-f909ea3fdccc@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not saying we shouldn't patch the regression, but this house of cards *needs* to be replaced with something robust and correct by construction.

Stefan Bader <stefan.bader@canonical.com> wrote:

>Avi wrote:
>>The fact that the check is only done on i386 and not on x86_64
>> may come from one of
>>
>> - an oversight
>> - by the time x86_64 processors came along, the problem with
>>   conflicting sizes was resolved
>> - the whole thing is bogus
>>
>> Copying hpa who may be in a position to find out which.
>
>Talking to hpa it is more of the last. For more than just this
>reason. Since the whole area of initial page tables seems to be
>rather sensitive and easy to break there have been discussions
>and plans to come up with a rewrite to improve on all those
>shortcomings.
>
>The detail I am not agreeing with hpa is the fixup for the
>immediate breakage at head. IMO right now the code just has
>regressed and that should be fixed as soon as possible.
>Plus doing a specific and small fix allows that to be applicable
>to stable (which again still depends on things being upstream).
>
>Hence the re-send in the hope that on the larger scale the may
>be agreement on the immediate fix. I am not doubting the usefulness
>or need of a better solution, but I think that having a remedy of
>the current situation just until then has enough benefit to be
>considered.
>
>-Stefan
>
>
>
>From 1d5cc3971716a039c91abc18cb6f9bcbe5dde490 Mon Sep 17 00:00:00 2001
>From: Stefan Bader <stefan.bader@canonical.com>
>Date: Fri, 13 Jul 2012 15:16:33 +0200
>Subject: [PATCH] x86/mm: Limit 2/4M size calculation to x86_32
>
>commit 722bc6b (x86/mm: Fix the size calculation of mapping tables)
>did modify the extra space calculation for mapping tables in order
>to make up for the first 2/4M memory range using 4K pages.
>However this setup is only used when compiling for 32bit. On 64bit
>there is only the trailing area of 4K pages (which is already added).
>
>The code was already adapted once for things went wrong on a 8TB
>machine (bd2753b x86/mm: Only add extra pages count for the first
>memory
>range during pre-allocation early page table space), but it looks a bit
>like it currently would overdo things for 64bit.
>I only noticed while bisecting for the reason I could not make a crash
>kernel boot (which ended up on this patch).
>
>Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
>Cc: stable@vger.kernel.org # v3.5
>Cc: WANG Cong <xiyou.wangcong@gmail.com>
>Cc: Yinghai Lu <yinghai@kernel.org>
>Cc: Tejun Heo <tj@kernel.org>
>---
> arch/x86/mm/init.c |    3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>
>diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
>index e0e6990..28a1c99 100644
>--- a/arch/x86/mm/init.c
>+++ b/arch/x86/mm/init.c
>@@ -60,10 +60,11 @@ static void __init find_early_table_space(struct
>map_range *mr, unsigned long en
> 		extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
> #ifdef CONFIG_X86_32
> 		extra += PMD_SIZE;
>-#endif
>+
> 		/* The first 2/4M doesn't use large pages. */
> 		if (mr->start < PMD_SIZE)
> 			extra += mr->end - mr->start;
>+#endif
> 
> 		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
> 	} else
>-- 
>1.7.10.4

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
