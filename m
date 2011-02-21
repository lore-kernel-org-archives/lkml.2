Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab1BUKEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 05:04:09 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:54378 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab1BUKEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 05:04:06 -0500
Message-ID: <4D623886.3010505@free.fr>
Date: Mon, 21 Feb 2011 11:03:50 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: Andrew Morton <akpm@osdl.org>, Oleg Nesterov <oleg@redhat.com>,
        LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com,
        dhowells@redhat.com
Subject: Re: [PATCH 1/4] userns: let clone_uts_ns() handle setting uts->user_ns
References: <20110221040156.GA12580@mail.hallyn.com>
In-Reply-To: <20110221040156.GA12580@mail.hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2011 05:01 AM, Serge E. Hallyn wrote:
> To do so we need to pass in the task_struct who'll get the utsname,
> so we can get its user_ns.
>
> Signed-off-by: Serge E. Hallyn<serge.hallyn@canonical.com>
> ---


>   include/linux/utsname.h |   10 ++++++----
>   kernel/nsproxy.c        |    7 +------
>   kernel/utsname.c        |   12 +++++++-----
>   3 files changed, 14 insertions(+), 15 deletions(-)
>
> diff --git a/include/linux/utsname.h b/include/linux/utsname.h
> index 85171be..165b17b 100644
> --- a/include/linux/utsname.h
> +++ b/include/linux/utsname.h
> @@ -52,8 +52,9 @@ static inline void get_uts_ns(struct uts_namespace *ns)
>   	kref_get(&ns->kref);
>   }
>
> -extern struct uts_namespace *copy_utsname(unsigned long flags,
> -					struct uts_namespace *ns);
> +extern struct uts_namespace *copy_utsname(struct task_struct *tsk,
> +					  unsigned long flags,
> +					  struct uts_namespace *ns);

Why don't we pass 'user_ns' instead of 'tsk' ? that will look 
semantically clearer for the caller no ?
(example below).

>   extern void free_uts_ns(struct kref *kref);
>
>   static inline void put_uts_ns(struct uts_namespace *ns)
> @@ -69,8 +70,9 @@ static inline void put_uts_ns(struct uts_namespace *ns)
>   {
>   }
>
> -static inline struct uts_namespace *copy_utsname(unsigned long flags,
> -					struct uts_namespace *ns)
> +static inline struct uts_namespace *copy_utsname(struct task_struct *tsk,
> +						 unsigned long flags,
> +						 struct uts_namespace *ns)
>   {
>   	if (flags&  CLONE_NEWUTS)
>   		return ERR_PTR(-EINVAL);
> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> index b6dbff2..ffa6b67 100644
> --- a/kernel/nsproxy.c
> +++ b/kernel/nsproxy.c
> @@ -69,16 +69,11 @@ static struct nsproxy *create_new_namespaces(unsigned long flags,
>   		goto out_ns;
>   	}
>
> -	new_nsp->uts_ns = copy_utsname(flags, tsk->nsproxy->uts_ns);
> +	new_nsp->uts_ns = copy_utsname(tsk, flags, tsk->nsproxy->uts_ns);
>   	if (IS_ERR(new_nsp->uts_ns)) {
>   		err = PTR_ERR(new_nsp->uts_ns);
>   		goto out_uts;
>   	}

...

new_nsp->uts_ns = copy_utsname(flags, tsk->nsproxy->uts_ns, task_cred_xxx(tsk, user)->user_ns);

...

> -	if (new_nsp->uts_ns != tsk->nsproxy->uts_ns) {
> -		put_user_ns(new_nsp->uts_ns->user_ns);
> -		new_nsp->uts_ns->user_ns = task_cred_xxx(tsk, user)->user_ns;
> -		get_user_ns(new_nsp->uts_ns->user_ns);
> -	}
>
>   	new_nsp->ipc_ns = copy_ipcs(flags, tsk->nsproxy->ipc_ns);
>   	if (IS_ERR(new_nsp->ipc_ns)) {
> diff --git a/kernel/utsname.c b/kernel/utsname.c
> index a7b3a8d..9462580 100644
> --- a/kernel/utsname.c
> +++ b/kernel/utsname.c
> @@ -31,7 +31,8 @@ static struct uts_namespace *create_uts_ns(void)
>    * @old_ns: namespace to clone
>    * Return NULL on error (failure to kmalloc), new ns otherwise
>    */
> -static struct uts_namespace *clone_uts_ns(struct uts_namespace *old_ns)
> +static struct uts_namespace *clone_uts_ns(struct task_struct *tsk,
> +					  struct uts_namespace *old_ns)
>   {
>   	struct uts_namespace *ns;
>
> @@ -41,8 +42,7 @@ static struct uts_namespace *clone_uts_ns(struct uts_namespace *old_ns)
>
>   	down_read(&uts_sem);
>   	memcpy(&ns->name,&old_ns->name, sizeof(ns->name));
> -	ns->user_ns = old_ns->user_ns;
> -	get_user_ns(ns->user_ns);
> +	ns->user_ns = get_user_ns(task_cred_xxx(tsk, user)->user_ns);
>   	up_read(&uts_sem);
>   	return ns;
>   }
> @@ -53,7 +53,9 @@ static struct uts_namespace *clone_uts_ns(struct uts_namespace *old_ns)
>    * utsname of this process won't be seen by parent, and vice
>    * versa.
>    */
> -struct uts_namespace *copy_utsname(unsigned long flags, struct uts_namespace *old_ns)
> +struct uts_namespace *copy_utsname(struct task_struct *tsk,
> +				   unsigned long flags,
> +				   struct uts_namespace *old_ns)
>   {
>   	struct uts_namespace *new_ns;
>
> @@ -63,7 +65,7 @@ struct uts_namespace *copy_utsname(unsigned long flags, struct uts_namespace *ol
>   	if (!(flags&  CLONE_NEWUTS))
>   		return old_ns;
>
> -	new_ns = clone_uts_ns(old_ns);
> +	new_ns = clone_uts_ns(tsk, old_ns);
>
>   	put_uts_ns(old_ns);
>   	return new_ns;

