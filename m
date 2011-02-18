Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab1BRDUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:20:07 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:58237 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab1BRDUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:20:04 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: LSM <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com,
        dhowells@redhat.com
References: <20110217150224.GA26334@mail.hallyn.com>
	<20110217150349.GG26395@mail.hallyn.com>
Date: Thu, 17 Feb 2011 19:19:58 -0800
In-Reply-To: <20110217150349.GG26395@mail.hallyn.com> (Serge E. Hallyn's
	message of "Thu, 17 Feb 2011 15:03:49 +0000")
Message-ID: <m1oc6a81wh.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/KnUpYe63dZixKcU0ZeGKACX6JnZsSz24=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 7/9] add a user namespace owner of ipc ns
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Changelog:
> 	Feb 15: Don't set new ipc->user_ns if we didn't create a new
> 		ipc_ns.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

>
> Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
> ---
>  include/linux/ipc_namespace.h |    3 +++
>  ipc/msgutil.c                 |    3 +++
>  ipc/namespace.c               |    9 +++++++--
>  kernel/nsproxy.c              |    5 +++++
>  4 files changed, 18 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
> index 5195298..46d2eb4 100644
> --- a/include/linux/ipc_namespace.h
> +++ b/include/linux/ipc_namespace.h
> @@ -24,6 +24,7 @@ struct ipc_ids {
>  	struct idr ipcs_idr;
>  };
>  
> +struct user_namespace;
>  struct ipc_namespace {
>  	atomic_t	count;
>  	struct ipc_ids	ids[3];
> @@ -56,6 +57,8 @@ struct ipc_namespace {
>  	unsigned int    mq_msg_max;      /* initialized to DFLT_MSGMAX */
>  	unsigned int    mq_msgsize_max;  /* initialized to DFLT_MSGSIZEMAX */
>  
> +	/* user_ns which owns the ipc ns */
> +	struct user_namespace *user_ns;
>  };
>  
>  extern struct ipc_namespace init_ipc_ns;
> diff --git a/ipc/msgutil.c b/ipc/msgutil.c
> index f095ee2..d91ff4b 100644
> --- a/ipc/msgutil.c
> +++ b/ipc/msgutil.c
> @@ -20,6 +20,8 @@
>  
>  DEFINE_SPINLOCK(mq_lock);
>  
> +extern struct user_namespace init_user_ns;
> +
>  /*
>   * The next 2 defines are here bc this is the only file
>   * compiled when either CONFIG_SYSVIPC and CONFIG_POSIX_MQUEUE
> @@ -32,6 +34,7 @@ struct ipc_namespace init_ipc_ns = {
>  	.mq_msg_max      = DFLT_MSGMAX,
>  	.mq_msgsize_max  = DFLT_MSGSIZEMAX,
>  #endif
> +	.user_ns = &init_user_ns,
>  };
>  
>  atomic_t nr_ipc_ns = ATOMIC_INIT(1);
> diff --git a/ipc/namespace.c b/ipc/namespace.c
> index a1094ff..aa18899 100644
> --- a/ipc/namespace.c
> +++ b/ipc/namespace.c
> @@ -11,10 +11,11 @@
>  #include <linux/slab.h>
>  #include <linux/fs.h>
>  #include <linux/mount.h>
> +#include <linux/user_namespace.h>
>  
>  #include "util.h"
>  
> -static struct ipc_namespace *create_ipc_ns(void)
> +static struct ipc_namespace *create_ipc_ns(struct ipc_namespace *old_ns)
>  {
>  	struct ipc_namespace *ns;
>  	int err;
> @@ -43,6 +44,9 @@ static struct ipc_namespace *create_ipc_ns(void)
>  	ipcns_notify(IPCNS_CREATED);
>  	register_ipcns_notifier(ns);
>  
> +	ns->user_ns = old_ns->user_ns;
> +	get_user_ns(ns->user_ns);
> +
>  	return ns;
>  }
>  
> @@ -50,7 +54,7 @@ struct ipc_namespace *copy_ipcs(unsigned long flags, struct ipc_namespace *ns)
>  {
>  	if (!(flags & CLONE_NEWIPC))
>  		return get_ipc_ns(ns);
> -	return create_ipc_ns();
> +	return create_ipc_ns(ns);
>  }
>  
>  /*
> @@ -105,6 +109,7 @@ static void free_ipc_ns(struct ipc_namespace *ns)
>  	 * order to have a correct value when recomputing msgmni.
>  	 */
>  	ipcns_notify(IPCNS_REMOVED);
> +	put_user_ns(ns->user_ns);
>  }
>  
>  /*
> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> index 034dc2e..b6dbff2 100644
> --- a/kernel/nsproxy.c
> +++ b/kernel/nsproxy.c
> @@ -85,6 +85,11 @@ static struct nsproxy *create_new_namespaces(unsigned long flags,
>  		err = PTR_ERR(new_nsp->ipc_ns);
>  		goto out_ipc;
>  	}
> +	if (new_nsp->ipc_ns != tsk->nsproxy->ipc_ns) {
> +		put_user_ns(new_nsp->ipc_ns->user_ns);
> +		new_nsp->ipc_ns->user_ns = task_cred_xxx(tsk, user)->user_ns;
> +		get_user_ns(new_nsp->ipc_ns->user_ns);
> +	}
>  
>  	new_nsp->pid_ns = copy_pid_ns(flags, task_active_pid_ns(tsk));
>  	if (IS_ERR(new_nsp->pid_ns)) {
