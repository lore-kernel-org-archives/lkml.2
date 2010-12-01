Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab0LACuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 21:50:37 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36125 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab0LACuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 21:50:35 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nelson Elhage <nelhage@ksplice.com>
Subject: Re: [PATCH v2] do_exit(): Make sure we run with get_fs() == USER_DS.
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1291170456-22580-1-git-send-email-nelhage@ksplice.com>
References: <20101130174947.5ccc3778.akpm@linux-foundation.org> <1291170456-22580-1-git-send-email-nelhage@ksplice.com>
Message-Id: <20101201115018.ABAE.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  1 Dec 2010 11:50:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If a user manages to trigger an oops with fs set to KERNEL_DS, fs is not
> otherwise reset before do_exit(). do_exit may later (via mm_release in fork.c)
> do a put_user to a user-controlled address, potentially allowing a user to
> leverage an oops into a controlled write into kernel memory.
> 
> A more logical place to put this might be when we know an oops has occurred,
> before we call do_exit(), but that would involve changing every architecture, in
> multiple places. Let's just stick it in do_exit instead.
> 
> Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
> ---
>  kernel/exit.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 21aa7b3..68899b3 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -914,6 +914,14 @@ NORET_TYPE void do_exit(long code)
>  	if (unlikely(!tsk->pid))
>  		panic("Attempted to kill the idle task!");
>  
> +	/*
> +	 * If do_exit is called because this processes oopsed, it's possible
> +	 * that get_fs() was left as KERNEL_DS, so reset it to USER_DS before
> +	 * continuing. This is relevant at least for clearing clear_child_tid in
> +	 * mm_release.
> +	 */
> +	set_fs(USER_DS);

"This is relevant" is no good explanation ;)
Please recognize this is tricky code and Please consider to write more 
careful and looooong comments.

Thanks.


