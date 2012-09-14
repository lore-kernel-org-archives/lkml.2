Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab2INQhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 12:37:34 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:59840 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab2INQhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 12:37:32 -0400
MIME-Version: 1.0
In-Reply-To: <87ligdrscn.fsf@rustcorp.com.au>
References: <87obl9rsg2.fsf@rustcorp.com.au> <87ligdrscn.fsf@rustcorp.com.au>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Fri, 14 Sep 2012 13:37:10 -0300
Message-ID: <CAMOw1v6Qy1wHhRcPQkyhDe7LrGaM_qRdhufr8YtHnfp5pTPFAA@mail.gmail.com>
Subject: Re: [PATCH 2/2] module: wait when loading a module which is currently initializing.
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>, Jon Masters <jonathan@jonmasters.org>,
        linux-modules <linux-modules@vger.kernel.org>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On Fri, Sep 14, 2012 at 4:11 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> The original module-init-tools module loader used a fnctl lock on the
> .ko file to avoid attempts to simultaneously load a module.
> Unfortunately, you can't get an exclusive fcntl lock on a read-only
> fd, making this not work for read-only mounted filesystems.
> module-init-tools has a hacky sleep-and-loop for this now.
>
> It's not that hard to wait in the kernel, and only return -EEXIST once
> the first module has finished loading (or continue loading the module
> if the first one failed to initialize for some reason).  It's also
> consistent with what we do for dependent modules which are still loading.
>
> Suggested-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  kernel/module.c |   28 ++++++++++++++++++++++++++--
>  1 file changed, 26 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/module.c b/kernel/module.c
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2845,6 +2845,20 @@ static int post_relocation(struct module
>         return module_finalize(info->hdr, info->sechdrs, mod);
>  }
>
> +/* Is this module of this name done loading?  No locks held. */
> +static bool finished_loading(const char *name)
> +{
> +       struct module *mod;
> +       bool ret;
> +
> +       mutex_lock(&module_mutex);
> +       mod = find_module(name);
> +       ret = !mod || mod->state != MODULE_STATE_COMING;
> +       mutex_unlock(&module_mutex);
> +
> +       return ret;
> +}

Much cleaner than we had before :-)

> +
>  /* Allocate and load the module: note that size of section 0 is always
>     zero, and we rely on this for optional sections. */
>  static struct module *load_module(void __user *umod,
> @@ -2852,7 +2866,7 @@ static struct module *load_module(void _
>                                   const char __user *uargs)
>  {
>         struct load_info info = { NULL, };
> -       struct module *mod;
> +       struct module *mod, *old;
>         long err;
>
>         pr_debug("load_module: umod=%p, len=%lu, uargs=%p\n",
> @@ -2918,8 +2932,18 @@ static struct module *load_module(void _
>          * function to insert in a way safe to concurrent readers.
>          * The mutex protects against concurrent writers.
>          */
> +again:
>         mutex_lock(&module_mutex);
> -       if (find_module(mod->name)) {
> +       if ((old = find_module(mod->name)) != NULL) {
> +               if (old->state == MODULE_STATE_COMING) {
> +                       /* Wait in case it fails to load. */
> +                       mutex_unlock(&module_mutex);
> +                       err = wait_event_interruptible(module_wq,
> +                                              finished_loading(mod->name));
> +                       if (err)
> +                               goto free_arch_cleanup;
> +                       goto again;

I wonder if we should indeed retry in case the module failed to load
or if we should just skip straight to returning the error code. We
don't have the return code for the failed load, but maybe we can
fabricate one here.

Thoughts?

cheers,
Lucas De Marchi
