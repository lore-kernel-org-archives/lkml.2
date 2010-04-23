Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab0DWCZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 22:25:27 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:55114 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058Ab0DWCZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 22:25:24 -0400
Date: Thu, 22 Apr 2010 19:25:22 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>, linux-doc@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Magnus Damm <damm@igel.co.jp>
Subject: Re: [linux-pm] [PATCH 2/9] PM: suspend_block: Add driver to access
 suspend blockers from user-space
Message-ID: <20100423022522.GB32490@count0.beaverton.ibm.com>
References: <1271984938-13920-1-git-send-email-arve@android.com>
 <1271984938-13920-2-git-send-email-arve@android.com>
 <1271984938-13920-3-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1271984938-13920-3-git-send-email-arve@android.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 06:08:51PM -0700, Arve Hjønnevåg wrote:
> Add a misc device, "suspend_blocker", that allows user-space processes
> to block auto suspend. The device has ioctls to create a suspend_blocker,
> and to block and unblock suspend. To delete the suspend_blocker, close
> the device.
> 
> Signed-off-by: Arve Hjønnevåg <arve@android.com>
> ---
>  Documentation/power/suspend-blockers.txt |   17 ++++
>  include/linux/suspend_block_dev.h        |   25 ++++++
>  kernel/power/Kconfig                     |    9 ++
>  kernel/power/Makefile                    |    1 +
>  kernel/power/user_suspend_blocker.c      |  128 ++++++++++++++++++++++++++++++
>  5 files changed, 180 insertions(+), 0 deletions(-)
>  create mode 100644 include/linux/suspend_block_dev.h
>  create mode 100644 kernel/power/user_suspend_blocker.c
> 
> diff --git a/Documentation/power/suspend-blockers.txt b/Documentation/power/suspend-blockers.txt
> index 1c48514..877bd8c 100644
> --- a/Documentation/power/suspend-blockers.txt
> +++ b/Documentation/power/suspend-blockers.txt
> @@ -95,3 +95,20 @@ if (list_empty(&state->pending_work))
>  else
>  	suspend_block(&state->suspend_blocker);
>  
> +User-space API
> +==============
> +
> +To create a suspend_blocker from user-space, open the suspend_blocker device:
> +    fd = open("/dev/suspend_blocker", O_RDWR | O_CLOEXEC);
> +then call:
> +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_INIT(strlen(name)), name);

Why not initialize the user suspend blocker struct by default and then
allow each BLOCK to specify the name? Also, my guess is it's not
really a name so much as a description of why we're blocking suspend,
right?

Should the kernel reject empty strings or strings composed only of
"non-printing" characters?

> +
> +To activate a suspend_blocker call:
> +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_BLOCK);
> +
> +To unblock call:
> +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_UNBLOCK);

lsof will show which tasks hold the device open but not which ones
are blocking suspend. If merely keeping the device open corresponded to
blocking suspend then this would be obvious and no ioctls would be
necessary -- just write() the name/description.

Do you block/unblock often enough that frequent open/close of the device are
a problem? Or has this idea been considered and discarded for other reasons?

> +
> +To destroy the suspend_blocker, close the device:
> +    close(fd);
> +

<snip>

> diff --git a/kernel/power/user_suspend_blocker.c b/kernel/power/user_suspend_blocker.c
> new file mode 100644
> index 0000000..a9be6f4
> --- /dev/null
> +++ b/kernel/power/user_suspend_blocker.c
> @@ -0,0 +1,128 @@
> +/* kernel/power/user_suspend_block.c
> + *
> + * Copyright (C) 2009-2010 Google, Inc.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/fs.h>
> +#include <linux/miscdevice.h>
> +#include <linux/module.h>
> +#include <linux/uaccess.h>
> +#include <linux/slab.h>
> +#include <linux/suspend_blocker.h>
> +#include <linux/suspend_block_dev.h>
> +
> +enum {
> +	DEBUG_FAILURE	= BIT(0),
> +};
> +static int debug_mask = DEBUG_FAILURE;
> +module_param_named(debug_mask, debug_mask, int, S_IRUGO | S_IWUSR | S_IWGRP);
> +
> +static DEFINE_MUTEX(ioctl_lock);

nit: Usually locks protect data -- not functions.

Couldn't this be part of the user_suspend_blocker struct? That would allow
the description/name to change as described above.

> +
> +struct user_suspend_blocker {
> +	struct suspend_blocker	blocker;
> +	char			name[0];
> +};

<snip>

Cheers,
	-Matt Helsley
