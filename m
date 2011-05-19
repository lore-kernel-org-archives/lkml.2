Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112Ab1ESSAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:00:09 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53427 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756881Ab1ESSAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:00:07 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: samsonov@krista.ru
Cc: linux-kernel@vger.kernel.org
Subject: Re: proc/base.c patch
References: <20110519155330.514349f1@wks1198.krista.ru>
Date: Thu, 19 May 2011 11:00:01 -0700
In-Reply-To: <20110519155330.514349f1@wks1198.krista.ru> (samsonov@krista.ru's
	message of "Thu, 19 May 2011 15:53:30 +0400")
Message-ID: <m1pqne371a.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19zVlVFxoXqTGrut0KGwx+Z6CzdOgCklFw=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

samsonov@krista.ru writes:


Thank you for splitting your patches up.

There are still a few things wrong with this patch.

- It is against an ancient release.
  Does this apply and has it been tested against a recent kernel?
  Patches are only applied to the most recent of kernels, tested
  there and then backported if it makes sense.

- You do not describe why you want to make proc directories writable.
  Descriptions of what you are trying to do and why are expected
  to accompany kernel patches.

And finally the biggest issue.  Virtual proc directories are by their
very nature have no concept of userspace writing to them.  Telling
userspace that those directories are writable makes no sense, and
can only lead to confusion as far as I can see.

Eric


> --- ./linux-2.6.33.4.orig/fs/proc/base.c	2010-05-13 02:04:27.000000000 +0400
> +++ ./linux-2.6.33.4/fs/proc/base.c	2011-05-16 15:36:29.385923198 +0400
> @@ -2570,11 +2570,11 @@
>  static const struct inode_operations proc_task_inode_operations;
>  
>  static const struct pid_entry tgid_base_stuff[] = {
> -	DIR("task",       S_IRUGO|S_IXUGO, proc_task_inode_operations, proc_task_operations),
> -	DIR("fd",         S_IRUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
> -	DIR("fdinfo",     S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
> +	DIR("task",       S_IWUSR|S_IRUGO|S_IXUGO, proc_task_inode_operations, proc_task_operations),
> +	DIR("fd",         S_IWUSR|S_IRUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
> +	DIR("fdinfo",     S_IRUSR|S_IWUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
>  #ifdef CONFIG_NET
> -	DIR("net",        S_IRUGO|S_IXUGO, proc_net_inode_operations, proc_net_operations),
> +	DIR("net",        S_IRUGO|S_IWUSR|S_IXUGO, proc_net_inode_operations, proc_net_operations),
>  #endif
>  	REG("environ",    S_IRUSR, proc_environ_operations),
>  	INF("auxv",       S_IRUSR, proc_pid_auxv),
> @@ -2608,7 +2608,7 @@
>  	REG("pagemap",    S_IRUSR, proc_pagemap_operations),
>  #endif
>  #ifdef CONFIG_SECURITY
> -	DIR("attr",       S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
> +	DIR("attr",       S_IRUGO|S_IWUSR|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
>  #endif
>  #ifdef CONFIG_KALLSYMS
>  	INF("wchan",      S_IRUGO, proc_pid_wchan),
> @@ -2767,7 +2767,7 @@
>  	if (!inode)
>  		goto out;
>  
> -	inode->i_mode = S_IFDIR|S_IRUGO|S_IXUGO;
> +	inode->i_mode = S_IFDIR|S_IRUSR|S_IWUSR|S_IXUSR|S_IRGRP|S_IXGRP;
>  	inode->i_op = &proc_tgid_base_inode_operations;
>  	inode->i_fop = &proc_tgid_base_operations;
>  	inode->i_flags|=S_IMMUTABLE;
> @@ -2909,8 +2909,8 @@
>   * Tasks
>   */
>  static const struct pid_entry tid_base_stuff[] = {
> -	DIR("fd",        S_IRUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
> -	DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
> +	DIR("fd",        S_IRUSR|S_IWUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
> +	DIR("fdinfo",    S_IRUSR|S_IWUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
>  	REG("environ",   S_IRUSR, proc_environ_operations),
>  	INF("auxv",      S_IRUSR, proc_pid_auxv),
>  	ONE("status",    S_IRUGO, proc_pid_status),
> @@ -2942,7 +2942,7 @@
>  	REG("pagemap",    S_IRUSR, proc_pagemap_operations),
>  #endif
>  #ifdef CONFIG_SECURITY
> -	DIR("attr",      S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
> +	DIR("attr",      S_IRUGO|S_IWUSR|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
>  #endif
>  #ifdef CONFIG_KALLSYMS
>  	INF("wchan",     S_IRUGO, proc_pid_wchan),
> @@ -3008,7 +3008,7 @@
>  
>  	if (!inode)
>  		goto out;
> -	inode->i_mode = S_IFDIR|S_IRUGO|S_IXUGO;
> +	inode->i_mode = S_IFDIR|S_IRUSR|S_IWUSR|S_IXUSR|S_IRGRP|S_IXGRP;
>  	inode->i_op = &proc_tid_base_inode_operations;
>  	inode->i_fop = &proc_tid_base_operations;
>  	inode->i_flags|=S_IMMUTABLE;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
