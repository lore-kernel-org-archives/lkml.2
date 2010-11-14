Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab0KNFHO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 00:07:14 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49927 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab0KNFHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 00:07:11 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Steven J. Magnani" <steve@digidescorp.com>
Subject: Re: [PATCH][RESEND] nommu: yield CPU periodically while disposing large VM
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1289507596-17613-1-git-send-email-steve@digidescorp.com>
References: <1289507596-17613-1-git-send-email-steve@digidescorp.com>
Message-Id: <20101112101645.DFF9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun, 14 Nov 2010 14:07:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Depending on processor speed, page size, and the amount of memory a process
> is allowed to amass, cleanup of a large VM may freeze the system for many
> seconds. This can result in a watchdog timeout.
> 
> Make sure other tasks receive some service when cleaning up large VMs.
> 
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> ---
> diff -uprN a/mm/nommu.c b/mm/nommu.c
> --- a/mm/nommu.c	2010-10-21 07:42:23.000000000 -0500
> +++ b/mm/nommu.c	2010-10-21 07:46:50.000000000 -0500
> @@ -1656,6 +1656,7 @@ SYSCALL_DEFINE2(munmap, unsigned long, a
>  void exit_mmap(struct mm_struct *mm)
>  {
>  	struct vm_area_struct *vma;
> +	unsigned long next_yield = jiffies + HZ;
>  
>  	if (!mm)
>  		return;
> @@ -1668,6 +1669,11 @@ void exit_mmap(struct mm_struct *mm)
>  		mm->mmap = vma->vm_next;
>  		delete_vma_from_mm(vma);
>  		delete_vma(mm, vma);
> +		/* Yield periodically to prevent watchdog timeout */
> +		if (time_after(jiffies, next_yield)) {
> +			cond_resched();
> +			next_yield = jiffies + HZ;
> +		}

If watchdog tiemr interval is less than HZ, this logic doesn't work. right?
If so, I would suggest just remove time_after() and call cond_resched() every time
because cond_resched is no-op if TIF_NEED_RESCHED is not setted.



