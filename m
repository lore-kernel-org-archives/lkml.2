Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab0KIKln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 05:41:43 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47677 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007Ab0KIKll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 05:41:41 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Figo.zhang" <figo1802@gmail.com>
Subject: Re: [PATCH]oom-kill: direct hardware access processes should get bonus
Cc: kosaki.motohiro@jp.fujitsu.com, lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>,
        "rientjes@google.com" <rientjes@google.com>
In-Reply-To: <1288662213.10103.2.camel@localhost.localdomain>
References: <1288662213.10103.2.camel@localhost.localdomain>
Message-Id: <20101109193913.BC98.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  9 Nov 2010 19:41:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> the victim should not directly access hardware devices like Xorg server,
> because the hardware could be left in an unpredictable state, although 
> user-application can set /proc/pid/oom_score_adj to protect it. so i think
> those processes should get 3% bonus for protection.
> 
> Signed-off-by: Figo.zhang <figo1802@gmail.com>

I was surprised this issue is still there. This was pointed out half year 
ago already :-/


> ---
> mm/oom_kill.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 4029583..df6a9da 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -195,10 +195,12 @@ unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
>  	task_unlock(p);
>  
>  	/*
> -	 * Root processes get 3% bonus, just like the __vm_enough_memory()
> -	 * implementation used by LSMs.
> +	 * Root and direct hardware access processes get 3% bonus, just like the
> +	 * __vm_enough_memory() implementation used by LSMs.
>  	 */

This comment is incorrect. LSM is care only CAP_SYS_ADMIN.

> -	if (has_capability_noaudit(p, CAP_SYS_ADMIN))
> +	if (has_capability_noaudit(p, CAP_SYS_ADMIN) ||
> +	    has_capability_noaudit(p, CAP_SYS_RESOURCE) ||
> +	    has_capability_noaudit(p, CAP_SYS_RAWIO))
>  		points -= 30;

But yes. OOM need to care both CAP_SYS_RESOURCE and CAP_SYS_RAWIO.

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




