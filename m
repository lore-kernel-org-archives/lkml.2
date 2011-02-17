Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab1BQKlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 05:41:40 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:28744 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752755Ab1BQKli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 05:41:38 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <1297763645-23274-1-git-send-email-ian.campbell@citrix.com>
References: <1297763645-23274-1-git-send-email-ian.campbell@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Feb 2011 10:41:25 +0000
Message-ID: <1297939285.16356.1480.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] xen: suspend and resume system devices when running
 PVHVM
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=R50lirqlHffDPPkwUlkuVa99MrvKdVWo//yz83qex8g= c=1 sm=0 a=v05gZNKIfk4A:10 a=IkcTkHD0fZMA:10 a=mLnsDVdbAAAA:8 a=tHz9FfFoAAAA:8 a=ZfRw4ET0AAAA:8 a=XVma2Aec4MMWt5U-l2oA:9 a=X_1mmrVe1pW-28JQxQCLM7KPZW4A:4 a=QEXdDO2ut3YA:10 a=6O0IECtVFhoA:10 a=KciULlu47koA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I stuck this patch in a git branch since I wanted to base some future
work on it. Please pull instead of taking the patch if you see this in
time.

The following changes since commit 100b33c8bd8a3235fd0b7948338d6cbb3db3c63d:
  Linus Torvalds (1):
        Linux 2.6.38-rc4

are available in the git repository at:

  git://xenbits.xen.org/people/ianc/linux-2.6.git for-linus/bugfixes

Ian Campbell (1):
      xen: suspend and resume system devices when running PVHVM

 drivers/xen/manage.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)
        
Ian.

On Tue, 2011-02-15 at 09:54 +0000, Ian Campbell wrote:
> Otherwise we fail to properly suspend/resume all of the emulated devices.
> 
> Something between 2.6.38-rc2 and rc3 appears to have exposed this
> issue, but it's always been wrong not to do this.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>
> ---
>  drivers/xen/manage.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
> index db8c4c4..2417727 100644
> --- a/drivers/xen/manage.c
> +++ b/drivers/xen/manage.c
> @@ -37,11 +37,19 @@ static enum shutdown_state shutting_down = SHUTDOWN_INVALID;
>  #ifdef CONFIG_PM_SLEEP
>  static int xen_hvm_suspend(void *data)
>  {
> +	int err;
>  	struct sched_shutdown r = { .reason = SHUTDOWN_suspend };
>  	int *cancelled = data;
>  
>  	BUG_ON(!irqs_disabled());
>  
> +	err = sysdev_suspend(PMSG_SUSPEND);
> +	if (err) {
> +		printk(KERN_ERR "xen_hvm_suspend: sysdev_suspend failed: %d\n",
> +		       err);
> +		return err;
> +	}
> +
>  	*cancelled = HYPERVISOR_sched_op(SCHEDOP_shutdown, &r);
>  
>  	xen_hvm_post_suspend(*cancelled);
> @@ -53,6 +61,8 @@ static int xen_hvm_suspend(void *data)
>  		xen_timer_resume();
>  	}
>  
> +	sysdev_resume();
> +
>  	return 0;
>  }
>  

-- 
Ian Campbell
Current Noise: Godflesh - Locust Furnace

We can embody the truth, but we cannot know it.
		-- Yates

