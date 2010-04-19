Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab0DSPWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 11:22:31 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49264 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755067Ab0DSPWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 11:22:30 -0400
Subject: Re: [Kgdb-bugreport] [PATCH 4/5] kgdb: Use atomic operators
 whichuse barriers
From: Will Deacon <will.deacon@arm.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       kgdb-bugreport@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-arm@vger.kernel.org
In-Reply-To: <4BB649E3.5060606@windriver.com>
References: <1270233145-29335-1-git-send-email-jason.wessel@windriver.com>
	 <1270233145-29335-2-git-send-email-jason.wessel@windriver.com>
	 <1270233145-29335-3-git-send-email-jason.wessel@windriver.com>
	 <1270233145-29335-4-git-send-email-jason.wessel@windriver.com>
	 <1270233145-29335-5-git-send-email-jason.wessel@windriver.com>
	 <alpine.LFD.2.00.1004021205080.3634@i5.linux-foundation.org>
	 <4BB64762.6040806@windriver.com>  <4BB649E3.5060606@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 16:21:56 +0100
Message-ID: <1271690516.17500.2.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Apr 2010 15:22:00.0148 (UTC) FILETIME=[0E6BB140:01CADFD4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

> Here is the revised patch, which is going into the kgdb-fixes branch.
> 
> Thanks,
> Jason.
> 
> --
> From: Jason Wessel <jason.wessel@windriver.com>
> Subject: [PATCH] kgdb: Use atomic operators which use barriers
> 
> The cpu_relax() does not mandate that there is an smp memory barrier.
> As a result on the arm smp architecture the kernel debugger can hang
> on entry from time to time, as shown by the kgdb regression tests.
> 
> The solution is simply to use the atomic operators which include a
> proper smp memory barrier, instead of using atomic_set().
> 
> Tested-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> ---
>  kernel/kgdb.c |   15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> --- a/kernel/kgdb.c
> +++ b/kernel/kgdb.c
> @@ -1379,8 +1379,7 @@ acquirelock:
>  	 * Make sure the above info reaches the primary CPU before
>  	 * our cpu_in_kgdb[] flag setting does:
>  	 */
> -	smp_wmb();
> -	atomic_set(&cpu_in_kgdb[cpu], 1);
> +	atomic_inc(&cpu_in_kgdb[cpu]);

As Dmitry pointed out here:

http://lkml.org/lkml/2010/4/8/214

This bit of code looks broken, especially since the comment has been left
alone by the patch. I think commit ae6bf53e should be reverted because
semantically all it does is remove the smp_wmb() above.

Please let me know what you think,

Will



