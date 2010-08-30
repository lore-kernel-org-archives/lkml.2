Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab0H3TDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 15:03:34 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:38925 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab0H3TDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 15:03:32 -0400
Date: Mon, 30 Aug 2010 21:03:30 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] init: add sys-wrapper.h
Message-ID: <20100830190330.GB12921@merkur.ravnborg.org>
References: <1283189270-7274-1-git-send-email-namhyung@gmail.com> <1283189270-7274-2-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283189270-7274-2-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung Kim.

Some very basic comments.

On Tue, Aug 31, 2010 at 02:27:49AM +0900, Namhyung Kim wrote:
> sys-wrapper.h contains wrapper functions for various syscalls used in init
> code. This wrappers handle proper address space conversion so that it can
> remove a lot of warnings from sparse.
> 
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  init/sys-wrapper.h |  230 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 230 insertions(+), 0 deletions(-)
>  create mode 100644 init/sys-wrapper.h
> 
> diff --git a/init/sys-wrapper.h b/init/sys-wrapper.h
> new file mode 100644
> index 0000000..9aa904c
> --- /dev/null
> +++ b/init/sys-wrapper.h
> @@ -0,0 +1,230 @@
> +/*
> + * init/sys-wrapper.h
Drop the filename - it has a tendency to get outdated.

> + *
> + * Copyright (C) 2010  Namhyung Kim <namhyung@gmail.com>
> + *
> + * wrappers for various syscalls for use in the init code
> + *
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public
> + * License v2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public
> + * License along with this program; if not, write to the
> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> + * Boston, MA 021110-1307, USA.
> + */
Drop the license text. The kernel is covered by GPL v2 anyway.

> +
> +#include <linux/fs.h>
> +#include <linux/types.h>
> +#include <linux/fcntl.h>
> +#include <linux/dirent.h>
> +#include <linux/syscalls.h>
> +

I usually see the inverse christmas tree recommended, that is the longest name first.


> +
> +#define kern_sys_call(call, ...)		\
> +({						\
> +	long result;				\
> +	mm_segment_t old_fs = get_fs();		\
> +	set_fs(KERNEL_DS);			\
> +	result = call(__VA_ARGS__);		\
> +	set_fs(old_fs);				\
> +	result;					\
> +})
> +

Personal preference...
Replace kern_ with kernel_ all over.

> +static inline int kern_sys_mount(char *dev_name, char *dir_name, char *type,
> +				 unsigned long flags, void *data)
> +{
> +	return kern_sys_call(sys_mount,
> +			     (char __user __force *) dev_name,
> +			     (char __user __force *) dir_name,
> +			     (char __user __force *) type,
> +			     flags,
> +			     (void __user __force *) data);
> +}
> +

I have not tried to investigate the sparse annotations.
But I wonder whay strings are "(char __user __force *)".
Is this because the sting usually come from userspace?


	Sam
