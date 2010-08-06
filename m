Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761291Ab0HFMrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 08:47:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162Ab0HFMru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 08:47:50 -0400
Date: Fri, 6 Aug 2010 14:44:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Zhang, Wei-Jovi (NSN - CN/Hangzhou)" <wei-jovi.zhang@nsn.com>
Cc: akpm@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]exit.c: support larger exit code
Message-ID: <20100806124456.GA9107@redhat.com>
References: <14414B36FFA0F1418CB707361EAA199A0194F7D2@CNBEEXC006.nsn-intra.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14414B36FFA0F1418CB707361EAA199A0194F7D2@CNBEEXC006.nsn-intra.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06, Zhang, Wei-Jovi (NSN - CN/Hangzhou) wrote:
>
> Nowadays userspace application use systemcall exit/exit_group only
> support one byte exit code.
> In some cases this exit code range is too small for some "big
> application"(like telecom software, 255 is not enough).
>
> So we can give some "big application" a chance to get larger exit code
> from child process.
> For other application don't want use larger exit code, they can use
> marco WEXITSTATUS to get lower one byte exit code.
>
> #define WEXITSTATUS(status)   __WEXITSTATUS (__WAIT_INT (status))
> --- stdlib.h
> #define       __WEXITSTATUS(status)   (((status) & 0xff00) >> 8)
> --- usrbits/waitstatus.h
>
>
> diff --git a/kernel/exit.c b/kernel/exit.c
> index ceffc67..8b13676 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -1045,7 +1045,7 @@ EXPORT_SYMBOL(complete_and_exit);
>
>  SYSCALL_DEFINE1(exit, int, error_code)
>  {
> -       do_exit((error_code&0xff)<<8);
> +       do_exit(error_code << 8);
>  }
>
>  /*
> @@ -1086,7 +1086,7 @@ do_group_exit(int exit_code)
>   */
>  SYSCALL_DEFINE1(exit_group, int, error_code)
>  {
> -       do_group_exit((error_code & 0xff) << 8);
> +       do_group_exit(error_code << 8);
>         /* NOTREACHED */
>         return 0;
>  }

Hmm. Looking at this patch, I am wondering what was the reason for the
current one-byte limitation.

I think the patch is fine. si_status, wo_stat are int too, so I do not
see any possibility for truncation before reporting to user-space.

Oleg.

