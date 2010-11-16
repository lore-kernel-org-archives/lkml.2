Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572Ab0KPUQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:16:37 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33002 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759390Ab0KPUQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:16:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oeSJezMbYHJWRW0Z9cJWmu39KOFRbdVhlZKb7uWHp8vYeGyd3p22CA603H/9VypofW
         /cFUfRPJPRcdWRaigESa4+J1CwSG6vBDKiul2f5kMEnXUO4oXjTg3NGik3zQzrX81kSt
         ZkeU4fp2nD8URwZ5LylkAG80FQNhtKW1RWT40=
Date: Tue, 16 Nov 2010 23:16:20 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Joe Perches <joe@perches.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Hugh Dickins <hughd@google.com>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH] ipc: explicitly clear stack memory for shminfo
Message-ID: <20101116201620.GA11278@albatros>
References: <1289937508-19458-1-git-send-email-kees.cook@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289937508-19458-1-git-send-email-kees.cook@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kees,

On Tue, Nov 16, 2010 at 11:58 -0800, Kees Cook wrote:
> This fixes a kernel stack memory contents leak by explicitly clearing
> the shminfo structure on the kernel stack before it is populated and
> copied back to userspace.
> 
> Signed-off-by: Kees Cook <kees.cook@canonical.com>
> Acked-by: Pekka Enberg <penberg@kernel.org>
> ---
>  ipc/shm.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
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
> -- 
> 1.7.2.3

Can you please clarify what fields (padding bytes?) are uninitialized
here?  I see this struct shminfo definition:

    /* Obsolete, used only for backwards compatibility */
    struct	shminfo {
        int shmmax;
        int shmmin;
        int shmmni;
        int shmseg;
        int shmall;
    };

And this filling:

		if(in->shmmax > INT_MAX)
			out.shmmax = INT_MAX;
		else
			out.shmmax = (int)in->shmmax;

		out.shmmin	= in->shmmin;
		out.shmmni	= in->shmmni;
		out.shmseg	= in->shmseg;
		out.shmall	= in->shmall; 

		return copy_to_user(buf, &out, sizeof(out));

As I see all five fields are set anyway, no padding bytes here, correct?


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
