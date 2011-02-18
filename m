Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811Ab1BSAA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 19:00:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758768Ab1BSAAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 19:00:19 -0500
Date: Fri, 18 Feb 2011 15:59:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com,
        dhowells@redhat.com
Subject: Re: [PATCH 6/9] user namespaces: convert all capable checks in
 kernel/sys.c
Message-Id: <20110218155928.ebfdbbf3.akpm@linux-foundation.org>
In-Reply-To: <20110217150342.GF26395@mail.hallyn.com>
References: <20110217150224.GA26334@mail.hallyn.com>
	<20110217150342.GF26395@mail.hallyn.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Feb 2011 15:03:42 +0000
"Serge E. Hallyn" <serge@hallyn.com> wrote:

> This allows setuid/setgid in containers.  It also fixes some
> corner cases where kernel logic foregoes capability checks when
> uids are equivalent.  The latter will need to be done throughout
> the whole kernel.
> 
>
> ...
>
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -118,17 +118,29 @@ EXPORT_SYMBOL(cad_pid);
>  
>  void (*pm_power_off_prepare)(void);
>  
> +/* called with rcu_read_lock, creds are safe */
> +static inline int set_one_prio_perm(struct task_struct *p)
> +{
> +	const struct cred *cred = current_cred(), *pcred = __task_cred(p);
> +
> +	if (pcred->user->user_ns == cred->user->user_ns &&
> +	    (pcred->uid  == cred->euid ||
> +	     pcred->euid == cred->euid))
> +		return 1;
> +	if (ns_capable(pcred->user->user_ns, CAP_SYS_NICE))
> +		return 1;
> +	return 0;
> +}

uninline.  Document return value?

>
> ...
>

