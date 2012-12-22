Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340Ab2LVLsP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 06:48:15 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:40881 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab2LVLsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 06:48:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 11/25] pm: don't use [delayed_]work_pending()
Date: Sat, 22 Dec 2012 12:53:29 +0100
Message-ID: <1652427.IL3F6yol0I@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1356141435-17340-12-git-send-email-tj@kernel.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org> <1356141435-17340-12-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 21, 2012 05:57:01 PM Tejun Heo wrote:
> There's no need to test whether a (delayed) work item in pending
> before queueing, flushing or cancelling it.  Most uses are unnecessary
> and quite a few of them are buggy.

Can you please say why they are buggy?

> Remove unnecessary pending tests from pm autosleep and qos.  Only
> compile tested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: linux-pm@vger.kernel.org
> ---
> Please let me know how this patch should be routed.  I can take it
> through the workqueue tree if necessary.

I can take it.  I will send a pull request with fixes later in the cycle
(maybe even before -rc2).

Thanks,
Rafael


>  kernel/power/autosleep.c | 2 +-
>  kernel/power/qos.c       | 9 +++------
>  2 files changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/power/autosleep.c b/kernel/power/autosleep.c
> index ca304046..c6422ff 100644
> --- a/kernel/power/autosleep.c
> +++ b/kernel/power/autosleep.c
> @@ -66,7 +66,7 @@ static DECLARE_WORK(suspend_work, try_to_suspend);
>  
>  void queue_up_suspend_work(void)
>  {
> -	if (!work_pending(&suspend_work) && autosleep_state > PM_SUSPEND_ON)
> +	if (autosleep_state > PM_SUSPEND_ON)
>  		queue_work(autosleep_wq, &suspend_work);
>  }
>  
> diff --git a/kernel/power/qos.c b/kernel/power/qos.c
> index 9322ff7..587ddde 100644
> --- a/kernel/power/qos.c
> +++ b/kernel/power/qos.c
> @@ -359,8 +359,7 @@ void pm_qos_update_request(struct pm_qos_request *req,
>  		return;
>  	}
>  
> -	if (delayed_work_pending(&req->work))
> -		cancel_delayed_work_sync(&req->work);
> +	cancel_delayed_work_sync(&req->work);
>  
>  	if (new_value != req->node.prio)
>  		pm_qos_update_target(
> @@ -386,8 +385,7 @@ void pm_qos_update_request_timeout(struct pm_qos_request *req, s32 new_value,
>  		 "%s called for unknown object.", __func__))
>  		return;
>  
> -	if (delayed_work_pending(&req->work))
> -		cancel_delayed_work_sync(&req->work);
> +	cancel_delayed_work_sync(&req->work);
>  
>  	if (new_value != req->node.prio)
>  		pm_qos_update_target(
> @@ -416,8 +414,7 @@ void pm_qos_remove_request(struct pm_qos_request *req)
>  		return;
>  	}
>  
> -	if (delayed_work_pending(&req->work))
> -		cancel_delayed_work_sync(&req->work);
> +	cancel_delayed_work_sync(&req->work);
>  
>  	pm_qos_update_target(pm_qos_array[req->pm_qos_class]->constraints,
>  			     &req->node, PM_QOS_REMOVE_REQ,
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
