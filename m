Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab0FPChT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 22:37:19 -0400
Received: from ozlabs.org ([203.10.76.45]:35258 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754308Ab0FPChR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 22:37:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Yehuda Sadeh <yehuda@hq.newdream.net>
Subject: Re: [PATCH 1/1] module: initialize module dynamic debug later
Date: Wed, 16 Jun 2010 12:07:13 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       yehudasa@gmail.com, sage@newdream.net
References: <b419ab1fe660cb24a32e63f9c2da2301b3ff1278.1276647544.git.yehuda@hq.newdream.net>
In-Reply-To: <b419ab1fe660cb24a32e63f9c2da2301b3ff1278.1276647544.git.yehuda@hq.newdream.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006161207.14257.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jun 2010 09:56:37 am Yehuda Sadeh wrote:
> We should initialize the module dynamic debug datastructures
> only after determining that the module is not loaded yet. This
> fixes a bug that introduced in 2.6.35-rc2, where when a trying
> to load a module twice, we also load it's dynamic printing data
> twice which causes all sorts of nasty issues. Also handle
> the dynamic debug cleanup later on failure.
> 
> Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>

Hi Yehuda,

  Thanks for tracking this down.  One minor comment:

>  #if defined(CONFIG_DYNAMIC_DEBUG)
> -extern int ddebug_remove_module(char *mod_name);
> +extern int ddebug_remove_module(const char *mod_name);
>  
>  #define __dynamic_dbg_enabled(dd)  ({	     \
>  	int __ret = 0;							     \
> @@ -73,7 +73,7 @@ extern int ddebug_remove_module(char *mod_name);
>  
>  #else
>  
> -static inline int ddebug_remove_module(char *mod)
> +static inline int ddebug_remove_module(const char *mod)
>  {
>  	return 0;
>  }

This implies we don't need the #ifdef here:

> +static void dynamic_debug_remove(struct _ddebug *debug)
> +{
> +#ifdef CONFIG_DYNAMIC_DEBUG
> +	if (debug)
> +		ddebug_remove_module(debug->modname);
> +#endif
> +}
> +

So I removed it.  It'd be nice to have a similar wrapper in the header
for ddebug_add_module so we can avoid the #ifdef there too, but that's
a separate patch.

Applied!
Rusty.
