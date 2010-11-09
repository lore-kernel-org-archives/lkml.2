Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab0KILVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 06:21:12 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48418 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab0KILVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 06:21:10 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/1][2nd resend] sys_unshare: remove the dead CLONE_THREAD/SIGHAND/VM code
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Ying Han <yinghan@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Roland McGrath <roland@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        JANAK DESAI <janak@us.ibm.com>
In-Reply-To: <20101105174343.GB19469@redhat.com>
References: <20101105174142.GA19469@redhat.com> <20101105174343.GB19469@redhat.com>
Message-Id: <20101109201742.BCA1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  9 Nov 2010 20:21:07 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Cleanup: kill the dead code which does nothing but complicates the code
> and confuses the reader.
> 
> sys_unshare(CLONE_THREAD/SIGHAND/VM) is not really implemented, and I doubt
> very much it will ever work. At least, nobody even tried since the original
> "unshare system call -v5: system call handler function" commit
> 99d1419d96d7df9cfa56bc977810be831bd5ef64 was applied more than 4 years ago.
> 
> And the code is not consistent. unshare_thread() always fails unconditionally,
> while unshare_sighand() and unshare_vm() pretend to work if there is nothing
> to unshare.
> 
> Remove unshare_thread(), unshare_sighand(), unshare_vm() helpers and related
> variables and add a simple CLONE_THREAD | CLONE_SIGHAND| CLONE_VM check into
> check_unshare_flags().
> 
> Also, move the "CLONE_NEWNS needs CLONE_FS" check from check_unshare_flags()
> to sys_unshare(). This looks more consistent and matches the similar
> do_sysvsem check in sys_unshare().
> 
> Note: with or without this patch "atomic_read(mm->mm_users) > 1" can give
> a false positive due to get_task_mm().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Acked-by: Roland McGrath <roland@redhat.com>
> ---
> 
>  kernel/fork.c |  123 +++++++++++-----------------------------------------------
>  1 file changed, 25 insertions(+), 98 deletions(-)
> 
> --- 2.6.37/kernel/fork.c~unshare-killcrap	2010-11-05 18:03:28.000000000 +0100
> +++ 2.6.37/kernel/fork.c	2010-11-05 18:09:52.000000000 +0100
> @@ -1522,38 +1522,24 @@ void __init proc_caches_init(void)
>  }
>  
>  /*
> - * Check constraints on flags passed to the unshare system call and
> - * force unsharing of additional process context as appropriate.
> + * Check constraints on flags passed to the unshare system call.
>   */
> -static void check_unshare_flags(unsigned long *flags_ptr)
> +static int check_unshare_flags(unsigned long unshare_flags)
>  {
> +	if (unshare_flags & ~(CLONE_THREAD|CLONE_FS|CLONE_NEWNS|CLONE_SIGHAND|
> +				CLONE_VM|CLONE_FILES|CLONE_SYSVSEM|
> +				CLONE_NEWUTS|CLONE_NEWIPC|CLONE_NEWNET))
> +		return -EINVAL;

Please put WARN_ON_ONCE() explicitly. That's good way to find hidden
user if exist and getting better bug report.

And, I've reveied this patch and I've found no fault. but I will not put
my ack because I think I haven't understand original intention perhaps.

Anyway, thanks Oleg.



