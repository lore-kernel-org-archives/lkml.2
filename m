Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab3ABPOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 10:14:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56333 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814Ab3ABPN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 10:13:58 -0500
Date: Wed, 2 Jan 2013 09:13:44 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Li Zefan <lizefan@huawei.com>
Cc: ebiederm@xmission.com, Containers <containers@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] userns: Allow unprivileged reboot
Message-ID: <20130102151344.GA5822@sergelap>
References: <50DBC2E0.3040908@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50DBC2E0.3040908@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Li Zefan (lizefan@huawei.com):
> In a container with its own pid namespace and user namespace, rebooting
> the system won't reboot the host, but terminate all the processes in
> it and thus have the container shutdown, so it's safe.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Thanks, Li.

fwiw,
Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

-serge

> ---
>  kernel/sys.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 265b376..24d1ef5 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -433,11 +433,12 @@ static DEFINE_MUTEX(reboot_mutex);
>  SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
>  		void __user *, arg)
>  {
> +	struct pid_namespace *pid_ns = task_active_pid_ns(current);
>  	char buffer[256];
>  	int ret = 0;
>  
>  	/* We only trust the superuser with rebooting the system. */
> -	if (!capable(CAP_SYS_BOOT))
> +	if (!ns_capable(pid_ns->user_ns, CAP_SYS_BOOT))
>  		return -EPERM;
>  
>  	/* For safety, we require "magic" arguments. */
> @@ -453,7 +454,7 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
>  	 * pid_namespace, the command is handled by reboot_pid_ns() which will
>  	 * call do_exit().
>  	 */
> -	ret = reboot_pid_ns(task_active_pid_ns(current), cmd);
> +	ret = reboot_pid_ns(pid_ns, cmd);
>  	if (ret)
>  		return ret;
>  
> -- 
> 1.8.0.2
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
