Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab0FBCLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 22:11:20 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51683 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513Ab0FBCLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 22:11:19 -0400
Date: Tue, 1 Jun 2010 19:10:29 -0700
From: Brandon Philips <brandon@ifup.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of
 module libcrc32c"
Message-ID: <20100602021029.GD10332@jenkins.ifup.org>
References: <201005252300.07739.rjw@sisk.pl>
 <201006011051.25636.rusty@rustcorp.com.au>
 <alpine.LFD.2.00.1005312011490.3637@i5.linux-foundation.org>
 <201006011452.06843.rusty@rustcorp.com.au>
 <alpine.LFD.2.00.1006010722160.3637@i5.linux-foundation.org>
 <alpine.LFD.2.00.1006011052340.8175@i5.linux-foundation.org>
 <20100601232430.GC10332@jenkins.ifup.org>
 <alpine.LFD.2.00.1006011638540.8175@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006011638540.8175@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:51 Tue 01 Jun 2010, Linus Torvalds wrote:
> On Tue, 1 Jun 2010, Brandon Philips wrote:
> > When I tested a Kernel with Rusty's modules branch pulled onto
> > 2.6.35-rc1 I got duplicate sysfs path errors:
> Hmm. Yeah, the module_mutex used to be held across the whole "find -> add" 
> state, but isn't any more.

Right.

> > To fix this we need to make sure that we only have one copy of a
> > module going through load_module at a time.  Patch suggestion
> > follows which boots without errors. I am sure there is a better
> > way to do what it does ;)
> 
> I think Rusty may have made the lock a bit _too_ finegrained there,
> and didn't add it to some places that needed it. It looks, for
> example, like PATCH 1/2 actually drops the lock in places where it's
> needed ("find_module()" is documented to need it, but now
> load_module() didn't hold it at all when it did the find_module()).

Right, I noticed that too and held the lock in the patch I sent.

> Rather than adding a new "module_loading" list, I think we should be
> able to just use the existing "modules" list, and just fix up the
> locking a bit.
>
> In fact, maybe we could just move the "look up existing module" a
> bit later - optimistically assuming that the module doesn't exist,
> and then just undoing the work if it turns out that we were wrong,
> just before adding ourselves to the list.
>
> A patch something like the appended (TOTALLY UNTESTED!)

FWIW, I tried this same idea initially and it breaks because the
kobject EEXIST is coming from mod_sysfs_init() which happens further
up in load_module() before the list_add_rcu().

I also tried the obvious variation of moving the list_add_rcu() up
to where the find_module is but got:

[    5.495549] sd 0:0:1:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    5.496931] ehci_hcd: Unknown symbol usb_hcd_resume_root_hub (err 0)
[    5.497002] ehci_hcd: Unknown symbol usb_hcd_pci_probe (err 0)
[    5.497070] ehci_hcd: Unknown symbol usb_hcd_unlink_urb_from_ep (err 0)

Feeling a bit like GoldiLocks I gave up and sent the modules_loading
patch to illustrate the issue. :)

I will keep working out all the interdependencies to see if I can get
something to boot without something like the modules_loading list.

Cheers,

	Brandon

> diff --git a/kernel/module.c b/kernel/module.c
> index a1f46a5..21f7ffa 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2198,11 +2198,6 @@ static noinline struct module *load_module(void __user *umod,
>  		goto free_mod;
>  	}
>  
> -	if (find_module(mod->name)) {
> -		err = -EEXIST;
> -		goto free_mod;
> -	}
> -
>  	mod->state = MODULE_STATE_COMING;
>  
>  	/* Allow arches to frob section contents and sizes.  */
> @@ -2486,6 +2481,13 @@ static noinline struct module *load_module(void __user *umod,
>  	 * The mutex protects against concurrent writers.
>  	 */
>  	mutex_lock(&module_mutex);
> +
> +	if (find_module(mod->name)) {
> +		err = -EEXIST;
> +		/* This will also unlock the mutex */
> +		goto already_exists;
> +	}
> +
>  	list_add_rcu(&mod->list, &modules);
>  	mutex_unlock(&module_mutex);
>  
> @@ -2511,6 +2513,7 @@ static noinline struct module *load_module(void __user *umod,
>  	mutex_lock(&module_mutex);
>  	/* Unlink carefully: kallsyms could be walking list. */
>  	list_del_rcu(&mod->list);
> + already_exists:
>  	mutex_unlock(&module_mutex);
>  	synchronize_sched();
>  	module_arch_cleanup(mod);
