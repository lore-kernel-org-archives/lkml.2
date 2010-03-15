Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965572Ab0CORY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 13:24:56 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:35754 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965510Ab0CORYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 13:24:55 -0400
Message-ID: <4B9E6CE1.3070202@oracle.com>
Date: Mon, 15 Mar 2010 10:22:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Ossama Othman <ossama.othman@intel.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Intel Restricted Access Region Handler
References: <1268558064-7973-1-git-send-email-ossama.othman@intel.com>
In-Reply-To: <1268558064-7973-1-git-send-email-ossama.othman@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B9E6D5E.014A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/10 01:14, Ossama Othman wrote:
> The Intel Restricted Access Region Handler provides a buffer allocation
> mechanism to RAR users.  Since the intended usage model is to lock out
> CPU access to RAR (the CPU will not be able to access RAR memory), this
> driver does not access RAR memory, and merely keeps track of what areas
> of RAR memory are in use.  It has it's own simple allocator that does
> not rely on existing kernel allocators (SLAB, etc) since those
> allocators are too tightly coupled with the paging mechanism, which isn't
> needed for the intended RAR use cases.
> 
> An mmap() implementation is provided for debugging purposes to simplify
> RAR memory access from the user space.  However, it will effectively be
> a no-op when RAR access control is enabled since the CPU will not be
> able to access RAR.
> 
> This driver should not be confused with the rar_register driver.  That
> driver exposes an interface to access RAR registers on the Moorestown
> platform.  The RAR handler driver relies on the rar_register driver for
> low level RAR register reads and writes.
> 
> Signed-off-by: Ossama Othman <ossama.othman@intel.com>
> ---
>  drivers/staging/Kconfig                   |    2 +
>  drivers/staging/Makefile                  |    1 +
>  drivers/staging/memrar/Kconfig            |   15 +
>  drivers/staging/memrar/Makefile           |    2 +
>  drivers/staging/memrar/memrar.h           |  160 +++++
>  drivers/staging/memrar/memrar_allocator.c |  432 +++++++++++++
>  drivers/staging/memrar/memrar_allocator.h |  141 +++++
>  drivers/staging/memrar/memrar_handler.c   |  948 +++++++++++++++++++++++++++++
>  8 files changed, 1701 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/memrar/Kconfig
>  create mode 100644 drivers/staging/memrar/Makefile
>  create mode 100644 drivers/staging/memrar/memrar.h
>  create mode 100644 drivers/staging/memrar/memrar_allocator.c
>  create mode 100644 drivers/staging/memrar/memrar_allocator.h
>  create mode 100644 drivers/staging/memrar/memrar_handler.c
> 
> diff --git a/drivers/staging/memrar/Makefile b/drivers/staging/memrar/Makefile
> new file mode 100644
> index 0000000..a3336c0
> --- /dev/null
> +++ b/drivers/staging/memrar/Makefile
> @@ -0,0 +1,2 @@
> +obj-$(CONFIG_MRST_RAR_HANDLER)	+= memrar.o
> +memrar-y			:= memrar_allocator.o memrar_handler.o
> diff --git a/drivers/staging/memrar/memrar.h b/drivers/staging/memrar/memrar.h
> new file mode 100644
> index 0000000..7a09e7d
> --- /dev/null
> +++ b/drivers/staging/memrar/memrar.h
> @@ -0,0 +1,160 @@
> +/*
> + *      RAR Handler (/dev/memrar) internal driver API.
> + *      Copyright (C) 2009 Intel Corporation. All rights reserved.
> + *
> + *      This program is free software; you can redistribute it and/or
> + *      modify it under the terms of version 2 of the GNU General
> + *      Public License as published by the Free Software Foundation.
> + *
> + *      This program is distributed in the hope that it will be
> + *      useful, but WITHOUT ANY WARRANTY; without even the implied
> + *      warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
> + *      PURPOSE.  See the GNU General Public License for more details.
> + *      You should have received a copy of the GNU General Public
> + *      License along with this program; if not, write to the Free
> + *      Software Foundation, Inc., 59 Temple Place - Suite 330,
> + *      Boston, MA  02111-1307, USA.
> + *      The full GNU General Public License is included in this
> + *      distribution in the file called COPYING.
> + */
> +
> +
> +#ifndef _MEMRAR_H
> +#define _MEMRAR_H
> +
> +#include <linux/ioctl.h>
> +#include <linux/types.h>
> +
> +
> +/*
> + * @struct RAR_stat
> + *
> + * @brief This structure is used for @c RAR_HANDLER_STAT ioctl and for
> + *        @c RAR_get_stat() user space wrapper function.
> + */

Don't use doxygen or whatever that is in the Linux kernel.
Use kernel-doc notation as described in Documentation/kernel-doc-nano-HOWTO.txt.

In many places/multiple files.


> +struct RAR_stat {
> +	/* Type of RAR memory (e.g., audio vs. video) */
> +	__u32 type;
> +
> +	/*
> +	* Total size of RAR memory region.
> +	*/
> +	__u32 capacity;
> +
> +	/* Size of the largest reservable block. */
> +	__u32 largest_block_size;
> +};


Thanks.

-- 
~Randy
