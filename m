Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098Ab1BJWmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 17:42:10 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:33811
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755870Ab1BJWmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 17:42:08 -0500
Date: Thu, 10 Feb 2011 22:43:01 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Gergely Nagy <algernon@balabit.hu>,
        david@lang.hm, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Marc Koschewski <marc@osknowledge.org>,
        lkml <linux-kernel@vger.kernel.org>, James Morris <jmorris@namei.org>,
        Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [PATCH 1/1] cap_syslog: don't refuse cap_sys_admin for now (v3)
Message-ID: <20110210224301.GA26562@mail.hallyn.com>
References: <20110210144057.GA7193@mail.hallyn.com>
 <AANLkTin-2uDkjPuSPmUE_HZdpxk9zd=Qop=nf==jsyLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin-2uDkjPuSPmUE_HZdpxk9zd=Qop=nf==jsyLA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Linus Torvalds (torvalds@linux-foundation.org):
> On Thu, Feb 10, 2011 at 6:40 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
> >
> > Please apply.
> 
> Hmm. So I detest the duplication and the ugly resulting code.  It was
> a bit hard to follow before, now it's just nasty.
> 
> Why not make this all into some nicer helper functions instead -
> something simple like the attached?
> 
> UNTESTED! I'm not going to apply it unless I get acks/tested-by's.
> 
>                                   Linus

It looks correct (and much nicer indeed)

Acked-by: Serge Hallyn <serge@hallyn.com>

Setting up a box to actually test on...

thanks,
-serge

>  kernel/printk.c |   54 +++++++++++++++++++++++++++++++++++-------------------
>  1 files changed, 35 insertions(+), 19 deletions(-)
> 
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 2ddbdc7..f51214c 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -262,25 +262,47 @@ int dmesg_restrict = 1;
>  int dmesg_restrict;
>  #endif
>  
> +static int syslog_action_restricted(int type)
> +{
> +	if (dmesg_restrict)
> +		return 1;
> +	/* Unless restricted, we allow "read all" and "get buffer size" for everybody */
> +	return type != SYSLOG_ACTION_READ_ALL && type != SYSLOG_ACTION_SIZE_BUFFER;
> +}
> +
> +static int check_syslog_permissions(int type, bool from_file)
> +{
> +	/*
> +	 * If this is from /proc/kmsg and we've already opened it, then we've
> +	 * already the capabilities checks at open time.
> +	 */
> +	if (from_file && type != SYSLOG_ACTION_OPEN)
> +		return 0;
> +
> +	if (syslog_action_restricted(type)) {
> +		if (capable(CAP_SYSLOG))
> +			return 0;
> +		/* For historical reasons, accept CAP_SYS_ADMIN too, with a warning */
> +		if (capable(CAP_SYS_ADMIN)) {
> +			WARN_ONCE(1, "Attempt to access syslog with CAP_SYS_ADMIN "
> +				 "but no CAP_SYSLOG (deprecated).\n");
> +			return 0;
> +		}
> +		return -EPERM;
> +	}
> +	return 0;
> +}
> +
>  int do_syslog(int type, char __user *buf, int len, bool from_file)
>  {
>  	unsigned i, j, limit, count;
>  	int do_clear = 0;
>  	char c;
> -	int error = 0;
> +	int error;
>  
> -	/*
> -	 * If this is from /proc/kmsg we only do the capabilities checks
> -	 * at open time.
> -	 */
> -	if (type == SYSLOG_ACTION_OPEN || !from_file) {
> -		if (dmesg_restrict && !capable(CAP_SYSLOG))
> -			goto warn; /* switch to return -EPERM after 2.6.39 */
> -		if ((type != SYSLOG_ACTION_READ_ALL &&
> -		     type != SYSLOG_ACTION_SIZE_BUFFER) &&
> -		    !capable(CAP_SYSLOG))
> -			goto warn; /* switch to return -EPERM after 2.6.39 */
> -	}
> +	error = check_syslog_permissions(type, from_file);
> +	if (error)
> +		goto out;
>  
>  	error = security_syslog(type);
>  	if (error)
> @@ -423,12 +445,6 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
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

