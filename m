Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab1A0VdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 16:33:00 -0500
Received: from mailhub.stratus.com ([134.111.1.18]:58316 "EHLO
	mailhub5.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab1A0Vc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 16:32:59 -0500
X-Greylist: delayed 2003 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Jan 2011 16:32:59 EST
Date: Thu, 27 Jan 2011 16:32:55 -0500
From: Bandan Das <bandan.das@stratus.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] qla2xxx: Fix possible race that could hang kthread_stop()
Message-ID: <20110127213255.GG31955@stratus.com>
References: <20110127205922.GF31955@stratus.com>
 <1296162757.3050.69.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296162757.3050.69.camel@mulgrave.site>
Company: Stratus Technologies
X-Disclaimer: This email will auto delete in 5 days, nah.. I am kidding!
User-Agent: Mutt/1.5.20 (2009-08-17)
X-OriginalArrivalTime: 27 Jan 2011 21:32:55.0888 (UTC) FILETIME=[C2C75D00:01CBBE69]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> That's not really the accepted way to fix these race conditions because
> of the double check of kthread_should_stop(); this is 
> James
> 
> ---
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index c194c23..15ce69e 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3282,10 +3282,10 @@ qla2x00_do_dpc(void *data)
>  
>  	set_user_nice(current, -20);
>  
> +	set_current_state(TASK_INTERRUPTIBLE);
>  	while (!kthread_should_stop()) {
>  		DEBUG3(printk("qla2x00: DPC handler sleeping\n"));
>  
> -		set_current_state(TASK_INTERRUPTIBLE);
>  		schedule();
>  		__set_current_state(TASK_RUNNING);
>  
> @@ -3454,7 +3454,9 @@ qla2x00_do_dpc(void *data)
>  		qla2x00_do_dpc_all_vps(base_vha);
>  
>  		ha->dpc_active = 0;
> +		set_current_state(TASK_INTERRUPTIBLE);
>  	} /* End of while(1) */
> +	__set_current_state(TASK_RUNNING);
>  
>  	DEBUG(printk("scsi(%ld): DPC handler exiting\n", base_vha->host_no));
>  
Yes, this looks more clean and will take care of the problem I am hitting.


Bandan
