Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122Ab0CaT5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 15:57:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35549 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756934Ab0CaT5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 15:57:10 -0400
Date: Wed, 31 Mar 2010 12:56:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vitaliy Gusev <vgusev@openvz.org>
Cc: Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bsdacct: delete timer with sync intension
Message-Id: <20100331125637.3ce5e8a1.akpm@linux-foundation.org>
In-Reply-To: <201003251735.10907.vgusev@openvz.org>
References: <201003251735.10907.vgusev@openvz.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Mar 2010 17:35:10 +0300
Vitaliy Gusev <vgusev@openvz.org> wrote:

> acct_exit_ns --> acct_file_reopen deletes timer without
> check timer execution on other CPUs. So acct_timeout() can
> change an unmapped memory.
> 

That sounds ugly.

> 
> ---
>  kernel/acct.c |   17 +++++++++--------
>  1 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/acct.c b/kernel/acct.c
> index a6605ca..6ac80ca 100644
> --- a/kernel/acct.c
> +++ b/kernel/acct.c
> @@ -353,17 +353,18 @@ restart:
>  
>  void acct_exit_ns(struct pid_namespace *ns)
>  {
> -	struct bsd_acct_struct *acct;
> +	struct bsd_acct_struct *acct = ns->bacct;
>  
> -	spin_lock(&acct_lock);
> -	acct = ns->bacct;
> -	if (acct != NULL) {
> -		if (acct->file != NULL)
> -			acct_file_reopen(acct, NULL, NULL);
> +	if (acct == NULL)
> +		return;
>  
> -		kfree(acct);
> -	}
> +	del_timer_sync(&acct->timer);
> +	spin_lock(&acct_lock);
> +	if (acct->file != NULL)
> +		acct_file_reopen(acct, NULL, NULL);
>  	spin_unlock(&acct_lock);
> +
> +	kfree(acct);
>  }
>  

Is this sufficient?  acct_file_reopen() does a del_timer(), so
acct_timeout() could be running concurrently with acct_file_reopen(),
but acct_file_reopen() is merrily altering data at *acct.

Perhaps acct_file_reopen() should be using del_timer_sync()?



check_free_space() is doing a similar thing:

	        del_timer(&acct->timer);
	        acct->needcheck = 0;

the currently-running timer handler now goes and sets needcheck again!


Methinks the whole thing needs a bit of a rethink, bearing in mind how
del_timer() actually works.

