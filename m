Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab0LHW5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 17:57:07 -0500
Received: from tundra.namei.org ([65.99.196.166]:41607 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756256Ab0LHW5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 17:57:04 -0500
Date: Thu, 9 Dec 2010 09:56:48 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
cc: Eric Paris <eparis@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] syslog: check cap_syslog when dmesg_restrict
In-Reply-To: <20101208151901.GA20557@mail.hallyn.com>
Message-ID: <alpine.LRH.2.00.1012090956220.13177@tundra.namei.org>
References: <20101208151901.GA20557@mail.hallyn.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Dec 2010, Serge E. Hallyn wrote:

> Eric Paris pointed out that it doesn't make sense to require
> both CAP_SYS_ADMIN and CAP_SYSLOG for certain syslog actions.
> So require CAP_SYSLOG, not CAP_SYS_ADMIN, when dmesg_restrict
> is set.
> 
> (I'm also consolidating the now common error path)
> 
> Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>

Applied.

(Please cc the lsm list with security patches).

> ---
>  Documentation/sysctl/kernel.txt |    2 +-
>  kernel/printk.c                 |   20 ++++++++++----------
>  2 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
> index 209e158..5740671 100644
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -219,7 +219,7 @@ dmesg_restrict:
>  This toggle indicates whether unprivileged users are prevented from using
>  dmesg(8) to view messages from the kernel's log buffer.  When
>  dmesg_restrict is set to (0) there are no restrictions.  When
> -dmesg_restrict is set set to (1), users must have CAP_SYS_ADMIN to use
> +dmesg_restrict is set set to (1), users must have CAP_SYSLOG to use
>  dmesg(8).
>  
>  The kernel config option CONFIG_SECURITY_DMESG_RESTRICT sets the default
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 0712380..0cecba0 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -279,18 +279,12 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
>  	 * at open time.
>  	 */
>  	if (type == SYSLOG_ACTION_OPEN || !from_file) {
> -		if (dmesg_restrict && !capable(CAP_SYS_ADMIN))
> -			return -EPERM;
> +		if (dmesg_restrict && !capable(CAP_SYSLOG))
> +			goto warn; /* switch to return -EPERM after 2.6.39 */
>  		if ((type != SYSLOG_ACTION_READ_ALL &&
>  		     type != SYSLOG_ACTION_SIZE_BUFFER) &&
> -		    !capable(CAP_SYSLOG)) {
> -			/* remove after 2.6.38 */
> -			if (capable(CAP_SYS_ADMIN))
> -				WARN_ONCE(1, "Attempt to access syslog with "
> -				  "CAP_SYS_ADMIN but no CAP_SYSLOG "
> -				  "(deprecated and denied).\n");
> -			return -EPERM;
> -		}
> +		    !capable(CAP_SYSLOG))
> +			goto warn; /* switch to return -EPERM after 2.6.39 */
>  	}
>  
>  	error = security_syslog(type);
> @@ -434,6 +428,12 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
>  	}
>  out:
>  	return error;
> +warn:
> +	/* remove after 2.6.39 */
> +	if (capable(CAP_SYS_ADMIN))
> +		WARN_ONCE(1, "Attempt to access syslog with CAP_SYS_ADMIN "
> +		  "but no CAP_SYSLOG (deprecated and denied).\n");
> +	return -EPERM;
>  }
>  
>  SYSCALL_DEFINE3(syslog, int, type, char __user *, buf, int, len)
> -- 
> 1.7.0.4
> 

-- 
James Morris
<jmorris@namei.org>
