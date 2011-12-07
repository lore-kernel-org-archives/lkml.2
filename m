Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab1LGAa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 19:30:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43947 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab1LGAaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 19:30:55 -0500
Date: Tue, 6 Dec 2011 16:30:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add refcount type and refcount misuse debugging
Message-Id: <20111206163054.f5e916e3.akpm@linux-foundation.org>
In-Reply-To: <20111206230107.GA22471@p183.telecom.by>
References: <20111206230107.GA22471@p183.telecom.by>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Dec 2011 02:01:07 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> There is quite a lot of idiomatic code which does
> 
> 	if (atomic_dec_and_test(&obj->refcnt))
> 		[destroy obj]
> 
> Bugs like double-frees in this case are dereferred and it may not be
> immediately obvious that double-free has happened.
> 
> The answer is to wrap reference count debugging to every such operation.
> 
> Enter _refcnt_t (non-atomic version), refcnt_t (atomic version) datatypes
> and CONFIG_DEBUG_REFCNT config option.
> 
> The latter directly checks for
> a) GET on dead object
> b) PUT on dead object (aka double PUT)
> (and indirectly for memory corruptions turning positive integers into negative)
> 
> All of this has basic idea coming from grsecurity/PaX's CONFIG_PAX_REFCOUNT code.
> The main difference is that developer has to opt in into new code.
> 
> Convert struct proc_dir_entry for a start.
> 

Fair enough.

Does _refcnt_t need to exist?

The use of a leading _ to denote the nonatomic variant is a bit odd but
I guess it's better than putting "_nonatomic" at the end of everything.

How much code bloat will all this cause, and is there anything that can be
done to reduce it?

>  Very ligthly tested.

erk.

>
> ...
>
> --- /dev/null
> +++ b/include/linux/refcnt.h
> @@ -0,0 +1,89 @@
> +/*
> + * Use these types iff
> + * a) object is created with refcount 1, and
> + * b) every GET does +1, and
> + * c) every PUT does -1, and
> + * d) once refcount reaches 0, object is destroyed.
> + *
> + * Do not use otherwise.
> + *
> + * Use underscored version if refcount manipulations are under
> + * some sort of locking already making additional atomicity unnecessary.
> + */
> +#ifndef _LINUX_REFCNT_H
> +#define _LINUX_REFCNT_H
> +#include <linux/types.h>
> +#include <asm/atomic.h>

linux/atomic.h is more modern.

> +#ifdef CONFIG_DEBUG_REFCNT
> +#include <asm/bug.h>
> +#endif

This is a bit risky.  It means that a .c file such as

#include <linux/refcnt.h>
foo()
{
	BUG();
}

will compile OK with CONFIG_DEBUG_REFCNT=y and will fail with
CONFIG_DEBUG_REFCNT=n.  This makes Randy send more emails.  Suggest
removal of the ifdef.

> +typedef struct {
> +	int _n;

The code would look nicer if the unneeded _ was removed.

> +} _refcnt_t;
> +#define _REFCNT_INIT	((_refcnt_t){ ._n = 1 })
>
> ...
>
> +typedef struct {
> +	atomic_t _n;

s/_//

> +} refcnt_t;
> +#define REFCNT_INIT	((refcnt_t){ ._n = ATOMIC_INIT(1) })
> +
>
> ...
>
