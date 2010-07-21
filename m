Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776Ab0GUVew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 17:34:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758595Ab0GUVeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 17:34:50 -0400
Date: Wed, 21 Jul 2010 14:34:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, hare@suse.de,
        trenn@suse.de, yehuda@hq.newdream.net, stable@kernel.org
Subject: Re: [PATCH] dynamic debug: move ddebug_remove_module() down into
 free_module()
Message-Id: <20100721143423.5782c6ee.akpm@linux-foundation.org>
In-Reply-To: <20100714200056.GB2871@redhat.com>
References: <20100714200056.GB2871@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jul 2010 16:00:57 -0400
Jason Baron <jbaron@redhat.com> wrote:

> move the call to ddebug_remove_module() down into free_module(). In this way
> it should be called from all error paths. Currently, we are missing the
> remove if the module init routine fails.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> Reported-by: Thomas Renninger <trenn@suse.de>
> Tested-by: Thomas Renninger <trenn@suse.de>
> CC: akpm@linux-foundation.org
> CC: andi@firstfloor.org
> CC: hare@suse.de
> CC: trenn@suse.de
> CC: yehuda@hq.newdream.net
> CC: linux-kernel@vger.kernel.org

Crappy changelog doesn't describe the bug we're fixing.  It should.

It's

	echo "file ec.c +p" >/sys/kernel/debug/dynamic_debug/control

causes an oops, yes?

> diff --git a/kernel/module.c b/kernel/module.c
> index 5d2d281..6c56282 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -787,7 +787,6 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
>  
>  	/* Store the name of the last unloaded module for diagnostic purposes */
>  	strlcpy(last_unloaded_module, mod->name, sizeof(last_unloaded_module));
> -	ddebug_remove_module(mod->name);
>  
>  	free_module(mod);
>  	return 0;
> @@ -1550,6 +1549,9 @@ static void free_module(struct module *mod)
>  	remove_sect_attrs(mod);
>  	mod_kobject_remove(mod);
>  
> +	/* Remove dynamic debug info */
> +	ddebug_remove_module(mod->name);
> +
>  	/* Arch-specific cleanup. */
>  	module_arch_cleanup(mod);

Should we backport this into 2.6.34.x?  Earlier?
