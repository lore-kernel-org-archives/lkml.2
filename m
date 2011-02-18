Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab1BRDbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:31:19 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:42088 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab1BRDbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:31:17 -0500
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
	<20110217150257.GA26395@mail.hallyn.com>
Date: Thu, 17 Feb 2011 19:31:04 -0800
In-Reply-To: <20110217150257.GA26395@mail.hallyn.com> (Serge E. Hallyn's
	message of "Thu, 17 Feb 2011 15:02:57 +0000")
Message-ID: <m1k4gy81dz.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19YnOdGzbq7VRnII6cY9HDuhgsmEMVsGa0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/9] Add a user_namespace as creator/owner of uts_namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> copy_process() handles CLONE_NEWUSER before the rest of the
> namespaces.  So in the case of clone(CLONE_NEWUSER|CLONE_NEWUTS)
> the new uts namespace will have the new user namespace as its
> owner.  That is what we want, since we want root in that new
> userns to be able to have privilege over it.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

>
> Changelog:
> 	Feb 15: don't set uts_ns->user_ns if we didn't create
> 		a new uts_ns.
>
> Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
> ---
>  include/linux/utsname.h |    3 +++
>  init/version.c          |    2 ++
>  kernel/nsproxy.c        |    5 +++++
>  kernel/user.c           |    8 ++++++--
>  kernel/utsname.c        |    4 ++++
>  5 files changed, 20 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/utsname.h b/include/linux/utsname.h
> index 69f3997..85171be 100644
> --- a/include/linux/utsname.h
> +++ b/include/linux/utsname.h
> @@ -37,9 +37,12 @@ struct new_utsname {
>  #include <linux/nsproxy.h>
>  #include <linux/err.h>
>  
> +struct user_namespace;
> +
>  struct uts_namespace {
>  	struct kref kref;
>  	struct new_utsname name;
> +	struct user_namespace *user_ns;
>  };
>  extern struct uts_namespace init_uts_ns;
>  
> diff --git a/init/version.c b/init/version.c
> index adff586..97bb86f 100644
> --- a/init/version.c
> +++ b/init/version.c
> @@ -21,6 +21,7 @@ extern int version_string(LINUX_VERSION_CODE);
>  int version_string(LINUX_VERSION_CODE);
>  #endif
>  
> +extern struct user_namespace init_user_ns;
>  struct uts_namespace init_uts_ns = {
>  	.kref = {
>  		.refcount	= ATOMIC_INIT(2),
> @@ -33,6 +34,7 @@ struct uts_namespace init_uts_ns = {
>  		.machine	= UTS_MACHINE,
>  		.domainname	= UTS_DOMAINNAME,
>  	},
> +	.user_ns = &init_user_ns,
>  };
>  EXPORT_SYMBOL_GPL(init_uts_ns);
>  
> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> index f74e6c0..034dc2e 100644
> --- a/kernel/nsproxy.c
> +++ b/kernel/nsproxy.c
> @@ -74,6 +74,11 @@ static struct nsproxy *create_new_namespaces(unsigned long flags,
>  		err = PTR_ERR(new_nsp->uts_ns);
>  		goto out_uts;
>  	}
> +	if (new_nsp->uts_ns != tsk->nsproxy->uts_ns) {
> +		put_user_ns(new_nsp->uts_ns->user_ns);
> +		new_nsp->uts_ns->user_ns = task_cred_xxx(tsk, user)->user_ns;
> +		get_user_ns(new_nsp->uts_ns->user_ns);
> +	}
>  
>  	new_nsp->ipc_ns = copy_ipcs(flags, tsk->nsproxy->ipc_ns);
>  	if (IS_ERR(new_nsp->ipc_ns)) {
> diff --git a/kernel/user.c b/kernel/user.c
> index 5c598ca..9e03e9c 100644
> --- a/kernel/user.c
> +++ b/kernel/user.c
> @@ -17,9 +17,13 @@
>  #include <linux/module.h>
>  #include <linux/user_namespace.h>
>  
> +/*
> + * userns count is 1 for root user, 1 for init_uts_ns,
> + * and 1 for... ?
> + */
>  struct user_namespace init_user_ns = {
>  	.kref = {
> -		.refcount	= ATOMIC_INIT(2),
> +		.refcount	= ATOMIC_INIT(3),
>  	},
>  	.creator = &root_user,
>  };
> @@ -47,7 +51,7 @@ static struct kmem_cache *uid_cachep;
>   */
>  static DEFINE_SPINLOCK(uidhash_lock);
>  
> -/* root_user.__count is 2, 1 for init task cred, 1 for init_user_ns->creator */
> +/* root_user.__count is 2, 1 for init task cred, 1 for init_user_ns->user_ns */
>  struct user_struct root_user = {
>  	.__count	= ATOMIC_INIT(2),
>  	.processes	= ATOMIC_INIT(1),
> diff --git a/kernel/utsname.c b/kernel/utsname.c
> index 8a82b4b..a7b3a8d 100644
> --- a/kernel/utsname.c
> +++ b/kernel/utsname.c
> @@ -14,6 +14,7 @@
>  #include <linux/utsname.h>
>  #include <linux/err.h>
>  #include <linux/slab.h>
> +#include <linux/user_namespace.h>
>  
>  static struct uts_namespace *create_uts_ns(void)
>  {
> @@ -40,6 +41,8 @@ static struct uts_namespace *clone_uts_ns(struct uts_namespace *old_ns)
>  
>  	down_read(&uts_sem);
>  	memcpy(&ns->name, &old_ns->name, sizeof(ns->name));
> +	ns->user_ns = old_ns->user_ns;
> +	get_user_ns(ns->user_ns);
>  	up_read(&uts_sem);
>  	return ns;
>  }
> @@ -71,5 +74,6 @@ void free_uts_ns(struct kref *kref)
>  	struct uts_namespace *ns;
>  
>  	ns = container_of(kref, struct uts_namespace, kref);
> +	put_user_ns(ns->user_ns);
>  	kfree(ns);
>  }
