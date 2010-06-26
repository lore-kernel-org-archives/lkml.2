Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab0FZUEd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 16:04:33 -0400
Received: from shutemov.name ([188.40.19.243]:52426 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975Ab0FZUEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 16:04:32 -0400
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Jun 2010 16:04:32 EDT
Date: Sat, 26 Jun 2010 22:54:57 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Anton Blanchard <anton@samba.org>
Cc: akpm@linux-foundation.org, mingo@elte.hu, arjan@linux.intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Make lib/bug.c WARN implementation match the
 kernel/panic.c one
Message-ID: <20100626195457.GA32393@shutemov.name>
References: <20100626191059.GA2345@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100626191059.GA2345@kryten>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 27, 2010 at 05:10:59AM +1000, Anton Blanchard wrote:
> 
> There are a few issues with the exception based WARN implementation in
> lib/bug.c:
> 
> - Inconsistent printk flags. The "cut here" line is printed at KERN_EMERG, so
>   the console and all logged in users see the single line:
> 
> ------------[ cut here ]------------
> 
>   for each WARN. Fix this so we print everything at KERN_WARNING to match the
>   kernel/panic.c version.
> 
> - The lib/bug.c WARN would print "Badness at". Change it to match the
>   kernel/panic.c version which prints "WARNING: at". 
> 
> - Print the list of modules, similar to kernel/panic.c of modules, similar to
>   kernel/panic.c
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
> 
> Index: linux-2.6/lib/bug.c
> ===================================================================
> --- linux-2.6.orig/lib/bug.c	2010-06-26 06:09:59.000000000 +1000
> +++ linux-2.6/lib/bug.c	2010-06-26 06:24:28.000000000 +1000
> @@ -136,8 +136,6 @@ enum bug_trap_type report_bug(unsigned l
>  
>  	bug = find_bug(bugaddr);
>  
> -	printk(KERN_EMERG "------------[ cut here ]------------\n");
> -
>  	file = NULL;
>  	line = 0;
>  	warning = 0;
> @@ -156,19 +154,24 @@ enum bug_trap_type report_bug(unsigned l
>  
>  	if (warning) {
>  		/* this is a WARN_ON rather than BUG/BUG_ON */
> +		printk(KERN_WARNING "------------[ cut here ]------------\n");
> +
>  		if (file)
> -			printk(KERN_ERR "Badness at %s:%u\n",
> +			printk(KERN_WARNING "WARNING: at %s:%u\n",
>  			       file, line);
>  		else
> -			printk(KERN_ERR "Badness at %p "
> +			printk(KERN_WARNING "WARNING: at %p "
>  			       "[verbose debug info unavailable]\n",
>  			       (void *)bugaddr);
>  
> +        	print_modules();
>  		show_regs(regs);
>  		add_taint(BUG_GET_TAINT(bug));
>  		return BUG_TRAP_TYPE_WARN;
>  	}
>  
> +	printk(KERN_EMERG "------------[ cut here ]------------\n");
> +

Hm... Why do you use KERN_EMERG here?

>  	if (file)
>  		printk(KERN_CRIT "kernel BUG at %s:%u!\n",
>  		       file, line);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
 Kirill A. Shutemov
