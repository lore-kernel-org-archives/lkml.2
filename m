Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab1BUObP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 09:31:15 -0500
Received: from www.tglx.de ([62.245.132.106]:41801 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab1BUObN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 09:31:13 -0500
Date: Mon, 21 Feb 2011 15:30:56 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] debugobjects: print more data
In-Reply-To: <20110221142329.GA6105@redhat.com>
Message-ID: <alpine.LFD.2.00.1102211530090.2701@localhost6.localdomain6>
References: <20110221142329.GA6105@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Feb 2011, Stanislaw Gruszka wrote:
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -276,6 +276,7 @@ config TIMER_STATS
>  config DEBUG_OBJECTS
>  	bool "Debug object operations"
>  	depends on DEBUG_KERNEL
> +	select KALLSYMS

Again, we don't enforce kallsyms with DO

>  	help
>  	  If you say Y here, additional code will be inserted into the
>  	  kernel to track the life time of various objects and validate
> diff --git a/lib/debugobjects.c b/lib/debugobjects.c
> index deebcc5..d5fcdeb 100644
> --- a/lib/debugobjects.c
> +++ b/lib/debugobjects.c
> @@ -14,6 +14,7 @@
>  #include <linux/debugfs.h>
>  #include <linux/slab.h>
>  #include <linux/hash.h>
> +#include <linux/kallsyms.h>

Please remove.

>  
>  #define ODEBUG_HASH_BITS	14
>  #define ODEBUG_HASH_SIZE	(1 << ODEBUG_HASH_BITS)
> @@ -253,10 +254,13 @@ static void debug_print_object(struct debug_obj *obj, char *msg)
>  
>  	if (limit < 5 && obj->descr != descr_test) {
>  		limit++;
> -		WARN(1, KERN_ERR "ODEBUG: %s %s (active state %u) "
> -				 "object type: %s\n",
> +		printk(KERN_ERR "ODEBUG: %s %s (active state %u) "
> +				"object type: %s\n",
>  			msg, obj_states[obj->state], obj->astate,
>  			obj->descr->name);
> +		dump_stack();
> +		if (obj->descr->print)
> +			obj->descr->print(obj->object);
>  	}
>  	debug_objects_warnings++;
>  }
> -- 
> 1.7.1
> 
