Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab2AaBA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 20:00:57 -0500
Received: from ozlabs.org ([203.10.76.45]:53869 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558Ab2AaBAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 20:00:55 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Dmitry Antipov <dmitry.antipov@linaro.org>
Subject: Re: [PATCH 3/3] module: use ZERO_OR_NULL_PTR allocation pointer checking
In-Reply-To: <1327913080-8850-1-git-send-email-dmitry.antipov@linaro.org>
References: <1327913080-8850-1-git-send-email-dmitry.antipov@linaro.org>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 31 Jan 2012 09:42:52 +1030
Message-ID: <87ty3clr7v.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jan 2012 12:44:40 +0400, Dmitry Antipov <dmitry.antipov@linaro.org> wrote:
> Use ZERO_OR_NULL_PTR allocation pointer checking where allocation
> function may return ZERO_SIZE_PTR.
> 
> Signed-off-by: Dmitry Antipov <dmitry.antipov@linaro.org>
> ---
>  kernel/module.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index 2c93276..5183f91 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -438,7 +438,7 @@ static int percpu_modalloc(struct module *mod,
>  	}
>  
>  	mod->percpu = __alloc_reserved_percpu(size, align);
> -	if (!mod->percpu) {
> +	if (unlikely(ZERO_OR_NULL_PTR(mod->percpu))) {
>  		printk(KERN_WARNING
>  		       "%s: Could not allocate %lu bytes percpu data\n",
>  		       mod->name, size);

printk() is marked __cold.  You don't need unlikely() here.

> @@ -2652,7 +2652,7 @@ static int move_module(struct module *mod, struct load_info *info)
>  	 * after the module is initialized.
>  	 */
>  	kmemleak_ignore(ptr);
> -	if (!ptr && mod->init_size) {
> +	if (unlikely(ZERO_OR_NULL_PTR(ptr)) && mod->init_size) {
>  		module_free(mod, mod->module_core);
>  		return -ENOMEM;
>  	}

You want to just change this to:

        if (!ptr) {

Thanks,
Rusty.
