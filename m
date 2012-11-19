Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab2KSWPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 17:15:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52271 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab2KSWPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 17:15:09 -0500
Date: Mon, 19 Nov 2012 14:14:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH] audit: catch possible NULL audit buffers
Message-Id: <20121119141458.883e6535.akpm@linux-foundation.org>
In-Reply-To: <20121119220051.GA16851@www.outflux.net>
References: <20121119220051.GA16851@www.outflux.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2012 14:00:51 -0800
Kees Cook <keescook@chromium.org> wrote:

> It's possible for audit_log_start() to return NULL. Handle it in the
> various callers.
> 
> ...
>
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -272,6 +272,8 @@ static int audit_log_config_change(char *function_name, int new, int old,
>  	int rc = 0;
>  
>  	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
> +	if (unlikely(!ab))
> +		return rc;

Returning success here looks suspicious.  audit_do_config_change() will
fail to take its wtf-just-happened action (which
audit_log_config_change() duplicates, btw).

Meanwhile audit_receive_msg() is off living in a happy land where
nothing ever goes wrong.

>  	audit_log_format(ab, "%s=%d old=%d auid=%u ses=%u", function_name, new,
>  			 old, from_kuid(&init_user_ns, loginuid), sessionid);
>  	if (sid) {
> @@ -619,6 +621,8 @@ static int audit_log_common_recv_msg(struct audit_buffer **ab, u16 msg_type,
>  	}
>  
>  	*ab = audit_log_start(NULL, GFP_KERNEL, msg_type);
> +	if (unlikely(!*ab))
> +		return rc;

Also looks fishy.

>  	audit_log_format(*ab, "pid=%d uid=%u auid=%u ses=%u",
>  			 task_tgid_vnr(current),
>  			 from_kuid(&init_user_ns, current_uid()),
>
> ...
>
