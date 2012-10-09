Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab2JIGpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:45:23 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55021 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab2JIGpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:45:19 -0400
MIME-Version: 1.0
In-Reply-To: <5073C357.6080805@zytor.com>
References: <1349757558-10856-1-git-send-email-yinghai@kernel.org>
	<5073BF32.7040003@zytor.com>
	<CAE9FiQWUg0wmMLANmshxob3ftxa2xY9mUSivzsWCGkJ2_==_Qg@mail.gmail.com>
	<5073C357.6080805@zytor.com>
Date: Mon, 8 Oct 2012 23:45:18 -0700
X-Google-Sender-Auth: eTWzpVMP6Es1ayOX0Y7WUHrU24M
Message-ID: <CAE9FiQVz1pZh17F9D2g+94W5S1Nf6hE9ttLd7JVL_DnkT2KxLg@mail.gmail.com>
Subject: Re: [PATCH -v2 00/10] x86: Use BRK to pre mapping page table to make
 xen happy
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>, Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 8, 2012 at 11:25 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/09/2012 02:21 PM, Yinghai Lu wrote:
>>>
>>> Hi Yinghai,
>>>
>>> This patchset doesn't apply on top of tip:x86/mm2, starting at patch 08/10.
>>
>> sorry for that. I refresh my base to current linus/master and tip/master.
>>
>> could be some change there.
>>
>> could solve it:
>> 1. update x86/mm2 to linus/master
>> 2. or i resend the patch again with x86/mm2 as base.
>>
>> please let me know which one you like.
>>
>
> If it doesn't have cross-dependencies on other code, x86/mm2 is probably
> the best base; if there are other dependencies then that's fine, but we
> need to know what they are.  We don't want to create unnecessary tangles
> among topic branches, it makes Linus very unhappy.

old one in tip/x86/mm2:

void __init xen_init_mmu_ops(void)
{
        x86_init.mapping.pagetable_reserve = xen_mapping_pagetable_reserve;
        x86_init.paging.pagetable_setup_start = xen_pagetable_setup_start;
        x86_init.paging.pagetable_setup_done = xen_pagetable_setup_done;
        pv_mmu_ops = xen_mmu_ops;

in linus/master
2178 void __init xen_init_mmu_ops(void)
2179 {
2180         x86_init.mapping.pagetable_reserve = xen_mapping_pagetable_reserve;
2181         x86_init.paging.pagetable_init = xen_pagetable_init;
2182         pv_mmu_ops = xen_mmu_ops;
2183
2184         memset(dummy_mapping, 0xff, PAGE_SIZE);
2185 }

cause by commit:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=c711288727a62f74d48032e56e51333dd104bf58

rej:
--- arch/x86/xen/mmu.c
+++ arch/x86/xen/mmu.c
@@ -2169,7 +2165,7 @@

 void __init xen_init_mmu_ops(void)
 {
-       x86_init.mapping.pagetable_reserve = xen_mapping_pagetable_reserve;
+       x86_init.mapping.make_range_readwrite = xen_make_range_readwrite;
        x86_init.paging.pagetable_init = xen_pagetable_init;
        pv_mmu_ops = xen_mmu_ops;
