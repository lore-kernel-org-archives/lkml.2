Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab1BDQEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 11:04:35 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:52384
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752974Ab1BDQEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 11:04:34 -0500
Date: Fri, 4 Feb 2011 16:05:13 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: James Morris <jmorris@namei.org>
Cc: Gergely Nagy <algernon@balabit.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: CAP_SYSLOG, 2.6.38 and user space
Message-ID: <20110204160513.GB17396@mail.hallyn.com>
References: <1296733177.14846.26.camel@moria>
 <20110203153252.GA24153@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110203153252.GA24153@mail.hallyn.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Serge E. Hallyn (serge@hallyn.com):
> >From 2d7408541dd3a6e19a4265b028233789be6a40f4 Mon Sep 17 00:00:00 2001
> From: Serge Hallyn <serge@peq.(none)>
> Date: Thu, 3 Feb 2011 09:26:15 -0600
> Subject: [PATCH 1/1] cap_syslog: don't refuse cap_sys_admin for now
> 
> At 2.6.39 or 2.6.40, let's add a sysctl which defaults to 0.  When
> 0, refuse if cap_sys_admin, if 1, then allow.  This will allow
> users to acknowledge (permanently, if they must, using /etc/sysctl.conf)
> that they've seen the syslog message about cap_sys_admin being
> deprecated for syslog.
> 
> Signed-off-by: Serge Hallyn <serge@hallyn.com>
> ---
>  kernel/printk.c |   26 ++++++++++++++++----------
>  1 files changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 2ddbdc7..bc56386 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -274,12 +274,24 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
>  	 * at open time.
>  	 */
>  	if (type == SYSLOG_ACTION_OPEN || !from_file) {
> -		if (dmesg_restrict && !capable(CAP_SYSLOG))
> -			goto warn; /* switch to return -EPERM after 2.6.39 */
> +		if (dmesg_restrict && !capable(CAP_SYSLOG)) {
> +			/* remove after 2.6.39 */
> +			if (capable(CAP_SYS_ADMIN))
> +				WARN_ONCE(1, "Attempt to access syslog with CAP_SYS_ADMIN "
> +				  "but no CAP_SYSLOG (deprecated).\n");
> +			else
> +				return -EPERM;
> +		}
>  		if ((type != SYSLOG_ACTION_READ_ALL &&
>  		     type != SYSLOG_ACTION_SIZE_BUFFER) &&
> -		    !capable(CAP_SYSLOG))
> -			goto warn; /* switch to return -EPERM after 2.6.39 */
> +		     !capable(CAP_SYSLOG)) {
> +			/* remove after 2.6.39 */
> +			if (capable(CAP_SYS_ADMIN))
> +				WARN_ONCE(1, "Attempt to access syslog with CAP_SYS_ADMIN "
> +				  "but no CAP_SYSLOG (deprecated).\n");
> +			else
> +				return -EPERM;
> +		}
>  	}
>  
>  	error = security_syslog(type);
> @@ -423,12 +435,6 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
>  	}
>  out:
>  	return error;
> -warn:
> -	/* remove after 2.6.39 */
> -	if (capable(CAP_SYS_ADMIN))
> -		WARN_ONCE(1, "Attempt to access syslog with CAP_SYS_ADMIN "
> -		  "but no CAP_SYSLOG (deprecated and denied).\n");
> -	return -EPERM;
>  }
>  
>  SYSCALL_DEFINE3(syslog, int, type, char __user *, buf, int, len)
> -- 
> 1.7.2.3
> 

James, do you mind taking this patch?

thanks,
-serge
