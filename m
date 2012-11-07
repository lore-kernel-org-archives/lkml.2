Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab2KGTUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 14:20:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53006 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab2KGTUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 14:20:17 -0500
Date: Wed, 7 Nov 2012 11:20:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: ebiederm@xmission.com, devel@openvz.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, jmorris@namei.org
Subject: Re: [PATCH 2/4] ipc: convert prepare_copy() from macro to function
Message-Id: <20121107112016.d9321efe.akpm@linux-foundation.org>
In-Reply-To: <20121107100500.22846.143.stgit@localhost.localdomain>
References: <20121107100317.22846.94715.stgit@localhost.localdomain>
	<20121107100500.22846.143.stgit@localhost.localdomain>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Nov 2012 13:05:00 +0300
Stanislav Kinsbursky <skinsbursky@parallels.com> wrote:

> This code works if CONFIG_CHECKPOINT_RESTORE is disabled.
> 
> ...
>
> --- a/ipc/msg.c
> +++ b/ipc/msg.c
> @@ -803,8 +803,15 @@ static inline void free_copy(struct msg_msg *copy)
>  		free_msg(copy);
>  }
>  #else
> -#define prepare_copy(buf, sz, msgflg, msgtyp, copy_nr)	ERR_PTR(-ENOSYS)
>  #define fill_copy(copy_nr, msg_nr, msg, copy)		NULL
> +
> +static inline struct msg_msg *prepare_copy(void __user *buf, size_t bufsz,
> +					   int msgflg, long *msgtyp,
> +					   unsigned long *copy_number)
> +{
> +	return ERR_PTR(-ENOSYS);
> +}
> +
>  static inline void free_copy(struct msg_msg *copy)
>  {
>  }
> @@ -819,7 +826,7 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
>  	int mode;
>  	struct ipc_namespace *ns;
>  	struct msg_msg *copy = NULL;
> -	unsigned long __maybe_unused copy_number;
> +	unsigned long __maybe_unused copy_number = 0;

The __maybe_unused here makes no sense.  I'll remove it.

>  
>  	if (msqid < 0 || (long) bufsz < 0)
>  		return -EINVAL;
