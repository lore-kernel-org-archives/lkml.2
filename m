Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551Ab2L2EFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 23:05:49 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:34145 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab2L2EFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 23:05:45 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vasily Kulikov <segoon@openwall.com>
Cc: Containers <containers@lists.linux-foundation.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
References: <20121228175627.GA7683@cachalot>
Date: Fri, 28 Dec 2012 20:05:32 -0800
In-Reply-To: <20121228175627.GA7683@cachalot> (Vasily Kulikov's message of
	"Fri, 28 Dec 2012 21:56:27 +0400")
Message-ID: <87wqw15wqb.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18WfIxXnDG/gJe/fHp507OBV3O7xaXZX3I=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4998]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Vasily Kulikov <segoon@openwall.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH/RFC] user_ns: fix missing limiting of user_ns counts
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vasily Kulikov <segoon@openwall.com> writes:

> Currently there is completely no limiting in number of user namespaces
> created by unprivileged users.  One can freely create thousands of
> user_ns'es and exhaust kernel memory without even bumping in
> RLIMIT_NPROC or similar.

First for a proper sense of scale it will take roughly 14,000 to consume
a megabyte.  So it will take hundreds of millions of user namespaces to
eat up all of kernel memory.

That said I have no objects to a patch that implemnts sysctls for
maximum limits.

> Even more -- it allows user to overflow kernel stack theoretically
> allowing user to overwrite some important kernel data.  The problem is
> that free_user_ns() may also free its parent user_namespace recursively
> calling free_user_ns().  As kernel stack is very limited, it leads to
> kernel stack overflow.

Yes.  Gcc can't turn a tail call into a jump in even the most basic
cases apparently.  So we need to adopt the solution of the pid
namespace.  Patch to follow shortly.

> The code needs several checks.  First, noone should be able to create
> user_ns of arbitrary depth.  Besides kernel stack overflow one could
> create too big depth to DoS processes belonging to other users by
> forcing them to loop a long time in cap_capable called from some
> ns_capable() (e.g. in case one does smth like "ls -R /proc").

Where do you get a ns_capable call from "ls -R /proc" ?

> Second,
> non-privileged users must not be able to overlimit some count of
> namespaces to not be able to exhaust kernel memory.

> The included patch is a basic fix for both or them.  Both values are
> hardcoded here to 100 max depth and 1000 max in total.  I'm not sure how
> better to make them configurable.  Looks like it needs some sysctl value
> like kernel.max_user_ns_per_user, but also something more configurable
> like new rlimit'ish limit may be created for user_ns needs.  E.g. in
> case root wants one user to contain hundreds of private containers
> (container owner user), but he doesn't want anybody to fill the kernel
> with hundreds of containers multiplied by number of system users (equals
> to thousands).
>
> I'm not sure how it is an approved way for user_ns.  Eric?

An per user limit for user namespaces is pretty much useless, as it is
expected that many user namespaces will be allocated multiple uids to play
with.  My current target is to modify newuser allocate 10,000 uids for
each user by default.

Other than a global limit the recommended solution is some kind of
control group.

With that said I am starting to think there may be a good argument for
per userns limits that apply to a user namespace and all of it's
children.  But for that to really make sense requires showing that
control groups can't do the job well.   I think there might be a
reasonable argument there.

> A related issue which is NOT FIXED HERE is limits for all resources
> available for containerized pseudo roots.  E.g. I succeeded creating
> thousands of veth network devices without problems by a non-root user,
> there seems no limit in number of network devices.  I suspect it is
> possible to setup routing and net_ns'es the way it will be very
> time-consuming for kernel to handle IP packets inside of ksoftirq, which
> is not counted as this user scheduler time.   I suppose the issue is not
> veth-specific, almost all newly available for unprivileged users code
> pathes are vulnerable to DoS attacks.

veth at least should process packets synchronously so I don't see how
you will get softirq action.  There is also for whatever it is worth
the network memory control group, that should limit networking things.
I haven't had a chance to look how sane it is in practice.

> Signed-off-by: Vasily Kulikov <segoon@openwall.com>
> -- 
>  include/linux/sched.h   |    3 +++
>  kernel/user_namespace.c |   26 ++++++++++++++++++++++++++
>  2 files changed, 29 insertions(+)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 206bb08..479940e 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -706,6 +706,9 @@ struct user_struct {
>  #ifdef CONFIG_EPOLL
>  	atomic_long_t epoll_watches; /* The number of file descriptors currently watched */
>  #endif
> +#ifdef CONFIG_USER_NS
> +	atomic_t user_namespaces; /* How many user_ns does this user created? */
> +#endif
>  #ifdef CONFIG_POSIX_MQUEUE
>  	/* protected by mq_lock	*/
>  	unsigned long mq_bytes;	/* How many bytes can be allocated to mqueue? */
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index 2b042c4..a52c4e8 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -45,6 +45,16 @@ static void set_cred_user_ns(struct cred *cred, struct user_namespace *user_ns)
>  	cred->user_ns = user_ns;
>  }
>  
> +static long get_user_ns_depth(struct user_namespace *ns)
> +{
> +	long depth;
> +
> +	for (depth = 1; ns != &init_user_ns; ns = ns->parent)
> +		depth++;
> +
> +	return depth;
> +}
> +
>  /*
>   * Create a new user namespace, deriving the creator from the user in the
>   * passed credentials, and replacing that user with the new root user for the
> @@ -56,6 +66,7 @@ static void set_cred_user_ns(struct cred *cred, struct user_namespace *user_ns)
>  int create_user_ns(struct cred *new)
>  {
>  	struct user_namespace *ns, *parent_ns = new->user_ns;
> +	struct user_struct *user = current->cred->user;
>  	kuid_t owner = new->euid;
>  	kgid_t group = new->egid;
>  	int ret;
> @@ -68,6 +79,18 @@ int create_user_ns(struct cred *new)
>  	    !kgid_has_mapping(parent_ns, group))
>  		return -EPERM;
>  
> +	/* Too long user_ns chains, might overflow kernel stack on kref_put() */
> +	if (get_user_ns_depth(parent_ns) > 100)
> +		return -ENOMEM;
> +
> +	atomic_inc(&user->user_namespaces);
> +	/* FIXME: probably it's better to configure the number
> +	 *        instead of hardcoding 1000 */
> +	if (atomic_read(&user->user_namespaces) > 1000) {
> +		atomic_dec(&user->user_namespaces);
> +		return -ENOMEM;
> +	}
> +
>  	ns = kmem_cache_zalloc(user_ns_cachep, GFP_KERNEL);
>  	if (!ns)
>  		return -ENOMEM;
> @@ -108,10 +131,13 @@ void free_user_ns(struct kref *kref)
>  {
>  	struct user_namespace *parent, *ns =
>  		container_of(kref, struct user_namespace, kref);
> +	struct user_struct *user = find_user(ns->owner);
>  
>  	parent = ns->parent;
>  	proc_free_inum(ns->proc_inum);
>  	kmem_cache_free(user_ns_cachep, ns);
> +	if (user)
> +		atomic_dec(&user->user_namespaces);
>  	put_user_ns(parent);
>  }
>  EXPORT_SYMBOL(free_user_ns);
