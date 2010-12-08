Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab0LHPju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 10:39:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755829Ab0LHPjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 10:39:49 -0500
Subject: Re: [PATCH] syslog: check cap_syslog when dmesg_restrict
From: Eric Paris <eparis@redhat.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
        dwalsh@redhat.com, Kees Cook <kees.cook@canonical.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101208151901.GA20557@mail.hallyn.com>
References: <20101208151901.GA20557@mail.hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Dec 2010 10:39:40 -0500
Message-ID: <1291822780.3072.40.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 15:19 +0000, Serge E. Hallyn wrote:
> Eric Paris pointed out that it doesn't make sense to require
> both CAP_SYS_ADMIN and CAP_SYSLOG for certain syslog actions.
> So require CAP_SYSLOG, not CAP_SYS_ADMIN, when dmesg_restrict
> is set.
> 
> (I'm also consolidating the now common error path)
> 
> Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
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

Doesn't this return -EPERM right now?  I think the code might be
incorrect today as well......

I thought the flow was supposed to be

if (capable(CAP_SYSLOG))
	all good
else if (capable(CAP_SYS_ADMIN))
	WARN, but still good for now
else
	EPERM

But it looks to me like the flow is

if (capable(CAP_SYSLOG))
	all good
else if (capable(CAP_SYS_ADMIN))
	WARN, EPERM
else
	EPERM

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


