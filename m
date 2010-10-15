Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab0JOPC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 11:02:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37930 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139Ab0JOPC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 11:02:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fno31KxgmqDzf5CQLDg9HDtxjNf0hq7W5akIrziaqk23aTGbLcty8Dxuwn12rTNLPi
         VwXHZU6lKU1CGQuDMEtagmKK7iuHHsxOI9BswgKn2tPm2xuGx1VrqyLE0fEYvuV15H4+
         wG8v0aTukCp4l9nhMr/SWVZR5ubdBZOyto0yc=
Date: Fri, 15 Oct 2010 16:01:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC][PATCH 5/7] jump_label: atomic_t interface
Message-ID: <20101015140137.GC5334@nowhere>
References: <20101014203404.222133139@chello.nl> <20101014203625.501657727@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101014203625.501657727@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 10:34:09PM +0200, Peter Zijlstra wrote:
> Add an interface to allow usage of jump_labels with atomic counters
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/jump_label_ref.h |   44 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
> 
> Index: linux-2.6/include/linux/jump_label_ref.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6/include/linux/jump_label_ref.h
> @@ -0,0 +1,44 @@
> +#ifndef _LINUX_JUMP_LABEL_REF_H
> +#define _LINUX_JUMP_LABEL_REF_H
> +
> +#include <linux/jump_label.h>
> +#include <asm/atomic.h>
> +
> +#ifdef HAVE_JUMP_LABEL
> +
> +static inline void jump_label_inc(atomic_t *key)
> +{
> +	if (atomic_add_return(1, key) == 1)
> +		jump_label_enable(key);
> +}
> +
> +static inline void jump_label_dec(atomic_t *key)
> +{
> +	if (atomic_dec_and_test(key))
> +		jump_label_disable(key);
> +}



Nice. I was trying to find a more self-explanatory name,
like jump_label_get/put or jump_label_inc_enable/jump_label_dec_disable.

But in fact the current name looks good eventually.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>




> +#else /* !HAVE_JUMP_LABEL */
> +
> +static inline void jump_label_inc(atomic_t *key)
> +{
> +	atomic_inc(key);
> +}
> +
> +static inline void jump_label_dec(atomic_t *key)
> +{
> +	atomic_dec(key);
> +}
> +
> +#undef JUMP_LABEL
> +#define JUMP_LABEL(key, label)						\
> +do {									\
> +	if (unlikely(__builtin_choose_expr(				\
> +	      __builtin_types_compatible_p(typeof(key), atomic_t *),	\
> +	      atomic_read((atomic_t *)(key)), *(key))))			\
> +		goto label;						\
> +} while (0)
> +
> +#endif /* HAVE_JUMP_LABEL */
> +
> +#endif /* _LINUX_JUMP_LABEL_REF_H */
> 
> 

