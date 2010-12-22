Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab0LVXOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 18:14:00 -0500
Received: from mail.perches.com ([173.55.12.10]:2832 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139Ab0LVXN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 18:13:58 -0500
Subject: Re: [PATCH v6] kptr_restrict for hiding kernel pointers
From: Joe Perches <joe@perches.com>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, jmorris@namei.org,
        eric.dumazet@gmail.com, tgraf@infradead.org, eugeneteo@kernel.org,
        kees.cook@canonical.com, mingo@elte.hu, davem@davemloft.net,
        a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
        eparis@parisplace.org
In-Reply-To: <1293058439.9820.317.camel@dan>
References: <1293058439.9820.317.camel@dan>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 15:13:56 -0800
Message-ID: <1293059636.26543.21.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-22 at 17:53 -0500, Dan Rosenberg wrote:
> Add the %pK printk format specifier and
> the /proc/sys/kernel/kptr_restrict sysctl.

trivial comments.

> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
[]
> @@ -201,6 +201,8 @@ extern int sscanf(const char *, const char *, ...)
>  extern int vsscanf(const char *, const char *, va_list)
>  	__attribute__ ((format (scanf, 2, 0)));
>  
> +extern int kptr_restrict;	/* for sysctl */

I think this extern should go into printk.h

> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
[]
> @@ -1035,6 +1038,30 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>  		return buf + vsnprintf(buf, end - buf,
>  				       ((struct va_format *)ptr)->fmt,
>  				       *(((struct va_format *)ptr)->va));
> +	case 'K':
[]
> +		else if (!kptr_restrict)
> +			break;		/* %pK does not obscure pointers */
> +
> +		else if ((kptr_restrict != 2) &&
> +		    has_capability_noaudit(current, CAP_SYSLOG))
> +			break;		/* privileged apps expose pointers,
> +					   unless kptr_restrict is 2 */
> +

I think this more readable as:

		else if ((kptr_restrict == 0)) ||
			 (kptr_restrict == 1 &&
			  has_capability_noaudit(current, CAP_SYSLOG)))
			break;


