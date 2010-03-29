Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab0C2K50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 06:57:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:33268 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232Ab0C2K5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 06:57:25 -0400
Subject: Re: [PATCH] drivers/macintosh: Correct potential double free
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Julia Lawall <julia@diku.dk>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1003291138520.21896@ask.diku.dk>
References: <Pine.LNX.4.64.1003291138520.21896@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 21:57:15 +1100
Message-ID: <1269860235.7101.13.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-29 at 11:39 +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The conditionals were testing different values, but then all freeing the
> same one, which could result in a double free.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)

Thanks. I'll stick that in my -next branch as soon as I open it :-)

Cheers,
Ben.

> // <smpl>
> @@
> expression x,e;
> identifier f;
> iterator I;
> statement S;
> @@
> 
> *kfree(x);
> ... when != &x
>     when != x = e
>     when != I(x,...) S
> *x
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/macintosh/windfarm_pm91.c   |    9 +++------
>  1 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/macintosh/windfarm_pm91.c b/drivers/macintosh/windfarm_pm91.c
> index bea9916..3442732 100644
> --- a/drivers/macintosh/windfarm_pm91.c
> +++ b/drivers/macintosh/windfarm_pm91.c
> @@ -687,12 +687,9 @@ static int __devexit wf_smu_remove(struct platform_device *ddev)
>  		wf_put_control(cpufreq_clamp);
>  
>  	/* Destroy control loops state structures */
> -	if (wf_smu_slots_fans)
> -		kfree(wf_smu_cpu_fans);
> -	if (wf_smu_drive_fans)
> -		kfree(wf_smu_cpu_fans);
> -	if (wf_smu_cpu_fans)
> -		kfree(wf_smu_cpu_fans);
> +	kfree(wf_smu_slots_fans);
> +	kfree(wf_smu_drive_fans);
> +	kfree(wf_smu_cpu_fans);
>  
>  	return 0;
>  }


