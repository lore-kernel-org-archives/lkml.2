Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759364Ab0KPUI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:08:59 -0500
Received: from mail.perches.com ([173.55.12.10]:1470 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758461Ab0KPUI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:08:58 -0500
Subject: Re: [PATCH] ipc: explicitly clear stack memory for shminfo
From: Joe Perches <joe@perches.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Hugh Dickins <hughd@google.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Vasiliy Kulikov <segooon@gmail.com>
In-Reply-To: <1289937508-19458-1-git-send-email-kees.cook@canonical.com>
References: <1289937508-19458-1-git-send-email-kees.cook@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 12:08:56 -0800
Message-ID: <1289938136.28741.198.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 11:58 -0800, Kees Cook wrote:
> This fixes a kernel stack memory contents leak by explicitly clearing
> the shminfo structure on the kernel stack before it is populated and
> copied back to userspace.
> diff --git a/ipc/shm.c b/ipc/shm.c
> index 7d3bb22..1d3d41f 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -531,6 +531,7 @@ static inline unsigned long copy_shminfo_to_user(void __user *buf, struct shminf
>  	    {
>  		struct shminfo out;
>  
> +		memset(&out, 0, sizeof(out));
>  		if(in->shmmax > INT_MAX)
>  			out.shmmax = INT_MAX;
>  		else

Hi Kees.

Trivial size optimization:

Perhaps it's better to use
	struct type var = {};
instead of
	struct type var;
	memset(&var, 0, sizeof(var));

At least for x86, gcc produces very slightly smaller code
when there are other automatic variables like:

Larger:
	struct type var;
	struct type var2;
	memset(&var, 0, sizeof(var));
Smaller:
	struct type var = {};
	struct type var2;

On the other hand, memset is more obvious.

