Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab1CPUIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 16:08:25 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:33947 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab1CPUIU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 16:08:20 -0400
From: Richard Weinberger <richard@nod.at>
To: Kees Cook <kees.cook@canonical.com>
Subject: Re: [PATCH] [RFC] Make it easier to harden /proc/
Date: Wed, 16 Mar 2011 21:08:16 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.25.20-0.7-pae; KDE/4.4.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, serge@hallyn.com,
        eparis@redhat.com, jmorris@namei.org, eugeneteo@kernel.org,
        drosenberg@vsecurity.com
References: <1300303907-22627-1-git-send-email-richard@nod.at> <20110316195549.GZ5466@outflux.net>
In-Reply-To: <20110316195549.GZ5466@outflux.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103162108.17127.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees,

Am Mittwoch 16 März 2011, 20:55:49 schrieb Kees Cook:
> Hi Richard,
> 
> On Wed, Mar 16, 2011 at 08:31:47PM +0100, Richard Weinberger wrote:
> > When containers like LXC are used a unprivileged and jailed
> > root user can still write to critical files in /proc/.
> > E.g: /proc/sys/kernel/{sysrq, panic, panic_on_oops, ... }
> > 
> > This new restricted attribute makes it possible to protect such
> > files. When restricted is set to true root needs CAP_SYS_ADMIN
> > to into the file.
> 
> I was thinking about this too. I'd prefer more fine-grained control
> in this area, since some sysctl entries aren't strictly controlled by
> CAP_SYS_ADMIN (e.g. mmap_min_addr is already checking CAP_SYS_RAWIO).
> 
> How about this instead?

Good Idea.
May we should also consider a per-directory restriction.
Every file in /proc/sys/{kernel/, vm/, fs/, dev/} needs a protection.
It would be much easier to set the protection on the parent directory
instead of protecting file by file...

> Signed-off-by: Kees Cook <kees.cook@canonical.com>
> ---
> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> index 8eb2522..5c5cfab 100644
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -149,6 +149,10 @@ static ssize_t proc_sys_call_handler(struct file
> *filp, void __user *buf, if (sysctl_perm(head->root, table, write ?
> MAY_WRITE : MAY_READ)) goto out;
> 
> +	if (write && !cap_isclear(table->write_caps) &&
> +            !cap_issubset(table->write_caps,
> current_cred()->cap_permitted)) +		goto out;
> +
>  	/* if that can happen at all, it should be -EINVAL, not -EISDIR */
>  	error = -EINVAL;
>  	if (!table->proc_handler)
> diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
> index 11684d9..4e05493 100644
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -1018,6 +1018,7 @@ struct ctl_table
>  	void *data;
>  	int maxlen;
>  	mode_t mode;
> +	kernel_cap_t write_caps;	/* Capabilities required to write */
>  	struct ctl_table *child;
>  	struct ctl_table *parent;	/* Automatically set */
>  	proc_handler *proc_handler;	/* Callback for text formatting */

