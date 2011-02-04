Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab1BDWEJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 17:04:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751829Ab1BDWEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 17:04:07 -0500
Date: Fri, 4 Feb 2011 14:03:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        Marcus Meissner <meissner@suse.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Eugene Teo <eugeneteo@kernel.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, Len Brown <len.brown@intel.com>,
        Changli Gao <xiaosuo@gmail.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>
Subject: Re: [PATCH v2] use %pK for /proc/kallsyms and /proc/modules
Message-Id: <20110204140351.f9066af0.akpm@linux-foundation.org>
In-Reply-To: <20110127004129.GH4981@outflux.net>
References: <20110127004129.GH4981@outflux.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jan 2011 16:41:29 -0800
Kees Cook <kees.cook@canonical.com> wrote:

> In an effort to reduce kernel address leaks that might be used to
> help target kernel privilege escalation exploits, this patch uses
> %pK when displaying addresses in /proc/kallsyms, /proc/modules, and
> /sys/module/*/sections/*.
> 
> Note that this changes %x to %p, so some legitimately 0 values in
> /proc/kallsyms would have changed from 00000000 to "(null)". To avoid
> this, "(null)" is not used when using the "K" format. Anything that was
> already successfully parsing "(null)" in addition to full hex digits
> should have no problem with this change. (Thanks to Joe Perches for
> the suggestion.)
> 
> ...
>
> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -477,12 +477,10 @@ static int s_show(struct seq_file *m, void *p)
>  		 */
>  		type = iter->exported ? toupper(iter->type) :
>  					tolower(iter->type);
> -		seq_printf(m, "%0*lx %c %s\t[%s]\n",
> -			   (int)(2 * sizeof(void *)),
> +		seq_printf(m, "%pK %c %s\t[%s]\n",
>  			   iter->value, type, iter->name, iter->module_name);
>  	} else
> -		seq_printf(m, "%0*lx %c %s\n",
> -			   (int)(2 * sizeof(void *)),
> +		seq_printf(m, "%pK %c %s\n",
>  			   iter->value, iter->type, iter->name);
>  	return 0;
>  }

kernel/kallsyms.c: In function 's_show':
kernel/kallsyms.c:481: warning: format '%p' expects type 'void *', but argument 3 has type 'long unsigned int'
kernel/kallsyms.c:484: warning: format '%p' expects type 'void *', but argument 3 has type 'long unsigned int'
kernel/module.c: In function 'module_sect_show':
kernel/module.c:1171: warning: format '%p' expects type 'void *', but argument 3 has type 'long unsigned int'
kernel/module.c:1171: warning: format '%p' expects type 'void *', but argument 3 has type 'long unsigned int'

I'm struggling to see how this could have been compile-time or runtime
tested?

