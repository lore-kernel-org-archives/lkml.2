Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab2CMFbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 01:31:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41839 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab2CMFbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 01:31:21 -0400
MIME-Version: 1.0
In-Reply-To: <65a23329-d843-4859-8b7b-430f12882492@zmail14.collab.prod.int.phx2.redhat.com>
References: <5535e246-b7c0-4f69-a27b-1abbadd42db0@zmail14.collab.prod.int.phx2.redhat.com>
	<65a23329-d843-4859-8b7b-430f12882492@zmail14.collab.prod.int.phx2.redhat.com>
Date: Mon, 12 Mar 2012 22:31:21 -0700
X-Google-Sender-Auth: sB4f2Qyaw5G29rsCt99n7ESlPP0
Message-ID: <CAE9FiQU9C=5YAa3DPcx8E9yVckSX5JbLdS=TC90jA8wz1pjzmw@mail.gmail.com>
Subject: Re: crash dump memory reservation regression
From: Yinghai Lu <yinghai@kernel.org>
To: CAI Qian <caiqian@redhat.com>, Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2012 at 8:00 PM, CAI Qian <caiqian@redhat.com> wrote:
> commit 3661ca66a42e306aaf53246fb75aec1ea01be0f0
> x86, memblock: Fix crashkernel allocation
>
> introduced a regression that crashkernel=512M
> according to bisecting will fail like this,
>
> crashkernel reservation failed - No suitable area found.
> The full dmesg can be found here.
>
> http://people.redhat.com/qcai/dmesg.bad

The reason is: we put pagetable for [0,2g) just blow 512M.

Later we have other patches that will put pagetable for [0,2g) just
below 2g. even at that time we only can access 512M, because we use
early_ioremap to access page table.

But that good_end part get reverted in following because it cause s4
resume fail.

So there will be pagetable around just below 512M again. So you have
no chance to get 512M below 768M.

Solution will be:
1.  remove the good_end setting for 64 bit again. and root cause S4 resume.
2.  get page low?
3.  fix kdump, and make kdump could take two ranges, one is small
segment below 512M, other part could be more than 4G.

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
