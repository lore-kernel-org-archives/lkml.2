Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab2JRQ2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 12:28:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757237Ab2JRQ2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 12:28:02 -0400
Date: Thu, 18 Oct 2012 13:27:46 -0300
From: Flavio Leitner <fbl@redhat.com>
To: Dave Young <dyoung@redhat.com>
Cc: Dave Young <hidave.darkstar@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>, ianfang.cn@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: kexec/kdump kernel fails to start
Message-ID: <20121018132746.66a6bf1d@obelix.rh>
In-Reply-To: <507FA2B3.3080403@redhat.com>
References: <20120904143215.5bbbb2a4@obelix.rh>
	<CAM_iQpVVCjJ0Bde9RS9Rm-0RJ=CtTyX3eUH45+oaaepvdAvAmQ@mail.gmail.com>
	<20120923202727.GA28937@mwanda>
	<CAE9FiQX-R1L-0LDZNTbk-a6SUog+=tTrdwcfr0QUczH_PLMMpw@mail.gmail.com>
	<20120929071318.GA7444@gmail.com>
	<CABqxG0czidut37LkwqH2_D44ng-HWHudjgZr9w8csqnGVUT0rA@mail.gmail.com>
	<507FA2B3.3080403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2012 14:33:23 +0800
Dave Young <dyoung@redhat.com> wrote:
[...]
> Just see Yinghai's coments, later init_memory_mapping cleanup
> will also address the 4k pages in first 2/4M, so revert them should be better.
> https://lkml.org/lkml/2012/9/4/533
> 
> Here is a patch for the reverting:
> ---
> x86 mm: Revert find_early_table_space fix
> 
> 722bc6b16771ed80871e1fd81c86d3627dda2ac8 Try to address the issue that the
> first 2/4M should use 4k pages if PSE enabled. but extra counts should only
> valid for x86_32. This commit cause kdump regression, kdump kernel hangs happens
> with it. 
> 
> As Yinghai Lu said they should be reverted. see below post:
> https://lkml.org/lkml/2012/9/4/533 
> 
> As there's a later fix to above fix which is bd2753b2dda7bb43c7468826de75f49c6a7e8965
> So we need revert both of these two commits.
> 
> Tested kdump on physical and virutual machines. 
> 
> Reverted commits:
> commit 722bc6b16771ed80871e1fd81c86d3627dda2ac8
> Author: WANG Cong <xiyou.wangcong@gmail.com>
> Date:   Mon Mar 5 15:05:13 2012 -0800
> 
>     x86/mm: Fix the size calculation of mapping tables
>     
>     For machines that enable PSE, the first 2/4M memory region still uses
>     4K pages, so needs more PTEs in this case, but
>     find_early_table_space() doesn't count this.
>     
>     This patch fixes it.
>     
>     The bug was found via code review, no misbehavior of the kernel
>     was observed.
>     
>     Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
>     Cc: Yinghai Lu <yinghai@kernel.org>
>     Cc: Tejun Heo <tj@kernel.org>
>     Cc: <ianfang.cn@gmail.com>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Link: http://lkml.kernel.org/n/tip-kq6a00qe33h7c7ais2xsywnh@git.kernel.org
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> commit bd2753b2dda7bb43c7468826de75f49c6a7e8965
> Author: Yinghai Lu <yinghai@kernel.org>
> Date:   Wed Jun 6 10:55:40 2012 -0700
> 
>     x86/mm: Only add extra pages count for the first memory range during pre-allocatio
>     
>     Robin found this regression:
>     
>     | I just tried to boot an 8TB system.  It fails very early in boot with:
>     | Kernel panic - not syncing: Cannot find space for the kernel page tables
>     
>     git bisect commit 722bc6b16771ed80871e1fd81c86d3627dda2ac8.
>     
>     A git revert of that commit does boot past that point on the 8TB
>     configuration.
>     
>     That commit will add up extra pages for all memory range even
>     above 4g.
>     
>     Try to limit that extra page count adding to first entry only.
>     
>     Bisected-by: Robin Holt <holt@sgi.com>
>     Tested-by: Robin Holt <holt@sgi.com>
>     Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>     Cc: WANG Cong <xiyou.wangcong@gmail.com>
>     Cc: Linus Torvalds <torvalds@linux-foundation.org>
>     Cc: Andrew Morton <akpm@linux-foundation.org>
>     Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     Link: http://lkml.kernel.org/r/CAE9FiQUj3wyzQxtq9yzBNc9u220p8JZ1FYHG7t%3DMOzJ%3D9B
>     Signed-off-by: Ingo Molnar <mingo@kernel.org>
> 
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  arch/x86/mm/init.c |   22 +++++++++-------------
>  1 file changed, 9 insertions(+), 13 deletions(-)

The patch looks good.

I reproduced the issue with last upstream
commit 43c422eda99b894f18d1cca17bcd2401efaf7bd0
and confirmed that it does work with the patch applied.

thanks a lot!

Acked-by: Flavio Leitner <fbl@redhat.com>
Tested-by: Flavio Leitner <fbl@redhat.com>

fbl
