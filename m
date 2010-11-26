Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab0KZC7B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 21:59:01 -0500
Received: from xenotime.net ([72.52.115.56]:41869 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752488Ab0KZC66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 21:58:58 -0500
Date: Thu, 25 Nov 2010 18:58:57 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Eric Paris <eparis@redhat.com>,
        LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        "Christopher J. PeBenito" <cpebenito@tresys.com>
Subject: Re: [PATCH 1/1] Define CAP_SYSLOG
Message-Id: <20101125185857.fa237ddf.rdunlap@xenotime.net>
In-Reply-To: <20101125171132.GA25703@mail.hallyn.com>
References: <20101125171132.GA25703@mail.hallyn.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Nov 2010 17:11:32 +0000 Serge E. Hallyn wrote:

> Privileged syslog operations currently require CAP_SYS_ADMIN.  Split
> this off into a new CAP_SYSLOG privilege which we can sanely take away
> from a container through the capability bounding set.
> 
> With this patch, an lxc container can be prevented from messing with
> the host's syslog (i.e. dmesg -c).
> 
> Changelog: mar 12 2010: add selinux capability2:cap_syslog perm
> Changelog: nov 22 2010:
> 	. port to new kernel
> 	. add a WARN_ONCE if userspace isn't using CAP_SYSLOG
> 
> Signed-off-by: Serge Hallyn <serge.hallyn@ubuntu.com>
> Acked-by: Andrew G. Morgan <morgan@kernel.org>
> Acked-By: Kees Cook <kees.cook@canonical.com>
> Cc: James Morris <jmorris@namei.org>
> Cc: Michael Kerrisk <mtk.manpages@gmail.com>
> Cc: Stephen Smalley <sds@tycho.nsa.gov>
> Cc: "Christopher J. PeBenito" <cpebenito@tresys.com>
> Cc: Eric Paris <eparis@parisplace.org>
> ---
>  include/linux/capability.h          |    7 +++++--
>  kernel/printk.c                     |    8 +++++++-
>  security/selinux/include/classmap.h |    2 +-
>  3 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/capability.h b/include/linux/capability.h
> index 90012b9..fb16a36 100644
> --- a/include/linux/capability.h
> +++ b/include/linux/capability.h
> @@ -246,7 +246,6 @@ struct cpu_vfs_cap_data {
>  /* Allow configuration of the secure attention key */
>  /* Allow administration of the random device */
>  /* Allow examination and configuration of disk quotas */
> -/* Allow configuring the kernel's syslog (printk behaviour) */
>  /* Allow setting the domainname */
>  /* Allow setting the hostname */
>  /* Allow calling bdflush() */
> @@ -352,7 +351,11 @@ struct cpu_vfs_cap_data {
>  
>  #define CAP_MAC_ADMIN        33
>  
> -#define CAP_LAST_CAP         CAP_MAC_ADMIN
> +/* Allow configuring the kernel's syslog (printk behaviour) */
> +
> +#define CAP_SYSLOG           34
> +
> +#define CAP_LAST_CAP         CAP_SYSLOG
>  
>  #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
>  
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 9a2264f..111cdc2 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -283,8 +283,14 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
>  			return -EPERM;
>  		if ((type != SYSLOG_ACTION_READ_ALL &&
>  		     type != SYSLOG_ACTION_SIZE_BUFFER) &&
> -		    !capable(CAP_SYS_ADMIN))
> +		    !capable(CAP_SYSLOG)) {
> +			/* remove after 2.6.28 */

	Is this supposed to say: after 2.6.38 ??

> +			if (capable(CAP_SYS_ADMIN))
> +				WARN_ONCE(1, "Attempt to access syslog with "
> +				  "CAP_SYS_ADMIN but no CAP_SYSLOG "
> +				  "(deprecated and denied).\n");
>  			return -EPERM;
> +		}
>  	}
>  
>  	error = security_syslog(type);
> diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
> index 8858d2b..7ed3663 100644
> --- a/security/selinux/include/classmap.h
> +++ b/security/selinux/include/classmap.h
> @@ -142,7 +142,7 @@ struct security_class_mapping secclass_map[] = {
>  	    "node_bind", "name_connect", NULL } },
>  	{ "memprotect", { "mmap_zero", NULL } },
>  	{ "peer", { "recv", NULL } },
> -	{ "capability2", { "mac_override", "mac_admin", NULL } },
> +	{ "capability2", { "mac_override", "mac_admin", "syslog", NULL } },
>  	{ "kernel_service", { "use_as_override", "create_files_as", NULL } },
>  	{ "tun_socket",
>  	  { COMMON_SOCK_PERMS, NULL } },
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
