Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab2INQlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 12:41:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44448 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab2INQli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 12:41:38 -0400
MIME-Version: 1.0
In-Reply-To: <87obl9rsg2.fsf@rustcorp.com.au>
References: <87obl9rsg2.fsf@rustcorp.com.au>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Fri, 14 Sep 2012 13:41:18 -0300
Message-ID: <CAMOw1v4LydKrkxCMNqX3QJex9KEUBHaEv-QF0yfwpM4WjEWx8w@mail.gmail.com>
Subject: Re: [PATCH 1/2] module: fix symbol waiting when module fails before init
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>, Jon Masters <jonathan@jonmasters.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 4:09 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> We use resolve_symbol_wait(), which blocks if the module containing
> the symbol is still loading.  However:
>
> 1) The module_wq we use is only woken after calling the modules' init
>    function, but there are other failure paths after the module is
>    placed in the linked list where we need to do the same thing.
>
> 2) wake_up() only wakes one waiter, and our waitqueue is shared by all
>    modules, so we need to wake them all.
>
> 3) wake_up_all() doesn't imply a memory barrier: I feel happier calling
>    it after we've grabbed and dropped the module_mutex, not just after
>    the state assignment.
>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  kernel/module.c |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/module.c b/kernel/module.c
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2959,7 +2959,7 @@ static struct module *load_module(void _
>         /* Unlink carefully: kallsyms could be walking list. */
>         list_del_rcu(&mod->list);
>         module_bug_cleanup(mod);
> -
> +       wake_up_all(&module_wq);
>   ddebug:
>         dynamic_debug_remove(info.debug);
>   unlock:
> @@ -3034,7 +3034,7 @@ SYSCALL_DEFINE3(init_module, void __user
>                 blocking_notifier_call_chain(&module_notify_list,
>                                              MODULE_STATE_GOING, mod);
>                 free_module(mod);
> -               wake_up(&module_wq);
> +               wake_up_all(&module_wq);
>                 return ret;
>         }
>         if (ret > 0) {
> @@ -3046,9 +3046,8 @@ SYSCALL_DEFINE3(init_module, void __user
>                 dump_stack();
>         }
>
> -       /* Now it's a first class citizen!  Wake up anyone waiting for it. */
> +       /* Now it's a first class citizen! */
>         mod->state = MODULE_STATE_LIVE;
> -       wake_up(&module_wq);
>         blocking_notifier_call_chain(&module_notify_list,
>                                      MODULE_STATE_LIVE, mod);
>
> @@ -3071,6 +3070,7 @@ SYSCALL_DEFINE3(init_module, void __user
>         mod->init_ro_size = 0;
>         mod->init_text_size = 0;
>         mutex_unlock(&module_mutex);
> +       wake_up_all(&module_wq);
>
>         return 0;
>  }

Ack.

cheers,
Lucas De Marchi
