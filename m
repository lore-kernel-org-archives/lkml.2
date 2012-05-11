Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760832Ab2EKRGH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 13:06:07 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:56108 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab2EKRGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 13:06:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Daniel Lezcano <dlezcano@fr.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4FAD0555.4090906@parallels.com> (Pavel Emelyanov's message of
	"Fri, 11 May 2012 16:25:57 +0400")
References: <4FAD0524.3000307@parallels.com> <4FAD0555.4090906@parallels.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Fri, 11 May 2012 10:05:48 -0700
Message-ID: <87d36a7imr.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+ecfW6qnZ8HCn1ilHsw7+XufvAFFCWcZg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Pavel Emelyanov <xemul@parallels.com>
X-Spam-Relay-Country: XX
Subject: Re: [PATCH 2/2] ns: Add proc_ns_operations for mount namespaces
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov <xemul@parallels.com> writes:

> Currently LXC by default creates a container in a new mount
> namespace. Thus in order to explore it we have to
>
> a) find out, that a new mount namespace is in use
> b) enter this other namespace
>
> This patch solves both -- allows us to distinguish one mount
> namespace from another by comparing its inode numbers and lets
> us enter a mount namespace with the setns system call.

There are two significant bugs with your patch.

You do not set fs->root or fs->pwd to values in the new mount namespace,
I don't believe there is anywhere else in the vfs where this is possible
except possible fchdir.

It is easily possible to create a reference counting cycle by bind
mounting the current mount namespace into itself.

Not that I am opposed to the concept I have just been dusting my patch
for this same functionality off.

Eric



> Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
> ---
>  fs/namespace.c          |   45 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/proc/namespaces.c    |    1 +
>  include/linux/proc_fs.h |    2 ++
>  3 files changed, 48 insertions(+), 0 deletions(-)
>
> diff --git a/fs/namespace.c b/fs/namespace.c
> index e608199..9467904 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -20,6 +20,7 @@
>  #include <linux/fs_struct.h>	/* get_fs_root et.al. */
>  #include <linux/fsnotify.h>	/* fsnotify_vfsmount_delete */
>  #include <linux/uaccess.h>
> +#include <linux/proc_fs.h>
>  #include "pnode.h"
>  #include "internal.h"
>  
> @@ -2633,3 +2634,47 @@ bool our_mnt(struct vfsmount *mnt)
>  {
>  	return check_mnt(real_mount(mnt));
>  }
> +
> +static void *mntns_get(struct task_struct *task)
> +{
> +	struct mnt_namespace *mn = NULL;
> +	struct nsproxy *nsproxy;
> +
> +	rcu_read_lock();
> +	nsproxy = task_nsproxy(task);
> +	if (nsproxy) {
> +		mn = nsproxy->mnt_ns;
> +		get_mnt_ns(mn);
> +	}
> +	rcu_read_unlock();
> +
> +	return mn;
> +}
> +
> +static void mntns_put(void *ns)
> +{
> +	put_mnt_ns(ns);
> +}
> +
> +static int mntns_install(struct nsproxy *nsproxy, void *ns)
> +{
> +	put_mnt_ns(nsproxy->mnt_ns);
> +	get_mnt_ns(ns);
> +	nsproxy->mnt_ns = ns;
> +	return 0;
> +}
> +
> +static u64 mntns_get_id(void *_ns)
> +{
> +	struct mnt_namespace *ns = _ns;
> +	return ns->root->mnt_id;
> +}
> +
> +const struct proc_ns_operations mntns_operations = {
> +	.name		= "mnt",
> +	.type		= CLONE_NEWNS,
> +	.get		= mntns_get,
> +	.put		= mntns_put,
> +	.install	= mntns_install,
> +	.get_id		= mntns_get_id,
> +};
> diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
> index b6c7560..e0399dd 100644
> --- a/fs/proc/namespaces.c
> +++ b/fs/proc/namespaces.c
> @@ -24,6 +24,7 @@ static const struct proc_ns_operations *ns_entries[] = {
>  #ifdef CONFIG_IPC_NS
>  	&ipcns_operations,
>  #endif
> +	&mntns_operations,
>  };
>  
>  static const struct file_operations ns_file_operations = {
> diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
> index e5ee83a..f6311b4 100644
> --- a/include/linux/proc_fs.h
> +++ b/include/linux/proc_fs.h
> @@ -252,6 +252,8 @@ struct proc_ns_operations {
>  extern const struct proc_ns_operations netns_operations;
>  extern const struct proc_ns_operations utsns_operations;
>  extern const struct proc_ns_operations ipcns_operations;
> +extern const struct proc_ns_operations mntns_operations;
> +
>  
>  union proc_op {
>  	int (*proc_get_link)(struct dentry *, struct path *);
