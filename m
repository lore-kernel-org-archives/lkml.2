Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab1HHQLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 12:11:55 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:44450 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752485Ab1HHQLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 12:11:54 -0400
Subject: Re: [PATCH] autofs4: Use no_printk() for no-op DPRINTK() and use
 __VA_ARGS__ too
From: Joe Perches <joe@perches.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org, autofs@linux.kernel.org,
        Ian Kent <raven@themaw.net>
In-Reply-To: <20110808151038.17366.38130.stgit@warthog.procyon.org.uk>
References: <20110808151038.17366.38130.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 09:11:52 -0700
Message-ID: <1312819912.1643.9.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-08 at 16:10 +0100, David Howells wrote:
> Use no_printk() for autofs's no-op DPRINTK() to prevent unused statements from
> becoming accidentally obsolete, and use __VA_ARGS__ too as that's the standard
> way.
[]
> diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
> index 475f9c5..c3a419f 100644
> --- a/fs/autofs4/autofs_i.h
> +++ b/fs/autofs4/autofs_i.h
> @@ -40,13 +40,17 @@
>  /* #define DEBUG */
>  
>  #ifdef DEBUG
> -#define DPRINTK(fmt, args...)				\
> +#define DPRINTK(fmt, ...)				\
>  do {							\
>  	printk(KERN_DEBUG "pid %d: %s: " fmt "\n",	\
> -		current->pid, __func__, ##args);	\
> +		current->pid, __func__, ##__VA_ARGS__);	\
>  } while (0)
>  #else
> -#define DPRINTK(fmt, args...) do {} while (0)
> +#define DPRINTK(fmt, ...)					\
> +do {								\
> +	no_printk(KERN_DEBUG "pid %d: %s: " fmt "\n",		\
> +		  current->pid, __func__, ##__VA_ARGS__);	\
> +} while (0)

single statement macros don't need do {} while (0),
and this could be

#define DPRINTK(fmt, args...)					\
	pr_debug("pid %d: %s: " fmt "\n",			\
		 current->pid, __func__, ##__VA_ARGS__)

When using dynamic debug __func__ and pid are unnecessary as
these can be added to any pr_debug output with '+f' and '+t'
so I think those should not be added either.

I think the DPRINTK macro should be removed altogether and
pr_debug should be used instead.


