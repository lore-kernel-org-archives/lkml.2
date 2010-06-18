Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593Ab0FRDkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 23:40:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57631 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab0FRDkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 23:40:03 -0400
X-Authority-Analysis: v=1.1 cv=GMC9ctHN+mfn2UjahXKMz1Fs9q6RIMVHs8P/za7PD7k= c=1 sm=0 a=T3_1zqPJo9IA:10 a=yQWWgrYGNuUA:10 a=kj9zAlcOel0A:10 a=Nqdp4+S2FArj7gZzHVn+tA==:17 a=hBqU3vQJAAAA:8 a=VwQbUJbxAAAA:8 a=6Z8wsCYITTUo1erDffsA:9 a=qq5irti3vwrqNZ9Axb0A:7 a=pDScThKfQYjzeVGBhkGcU-70Rx4A:4 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=4gZ4WExUoD4A:10 wl=env:18 a=Nqdp4+S2FArj7gZzHVn+tA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.120.198.24
Date: Thu, 17 Jun 2010 22:40:22 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2.6.29.6 - 2.6.35-rc3] CRED: Release spinlock before
 commit_creds().
Message-ID: <20100618034022.GA3500@hallyn.com>
References: <201006180308.o5I38O34094551@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006180308.o5I38O34094551@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tetsuo Handa (penguin-kernel@I-love.SAKURA.ne.jp):
> reparent_to_kthreadd() is calling commit_creds() with tasklist_lock held. But
> commit_creds() calls key_fsuid_changed()/key_fsgid_changed()/proc_id_connector()
> which may sleep. Release tasklist_lock before calling commit_creds().
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

The reparenting is done in current context, so current_cred can't go
away, and init_cred can't go away.  And I can't think of anything
nefarious anyone could do to the task on account of the previous
credentials (as a result of the reparenting) before commit_creds()
completes.  So it looks good to me, but David might know of a reason
why it isn't...  Anyway:

Acked-by: Serge E. Hallyn <serge@hallyn.com>

> ---
>  kernel/exit.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- security-testing-2.6.orig/kernel/exit.c
> +++ security-testing-2.6/kernel/exit.c
> @@ -348,8 +348,8 @@ static void reparent_to_kthreadd(void)
>  	       sizeof(current->signal->rlim));
>  
>  	atomic_inc(&init_cred.usage);
> -	commit_creds(&init_cred);
>  	write_unlock_irq(&tasklist_lock);
> +	commit_creds(&init_cred);
>  }
>  
>  void __set_special_pids(struct pid *pid)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
