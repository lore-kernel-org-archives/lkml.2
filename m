Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816Ab1CCVdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 16:33:51 -0500
Received: from xenotime.net ([184.105.210.51]:42928 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758251Ab1CCVdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 16:33:50 -0500
Date: Thu, 3 Mar 2011 13:33:43 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [REVIEW] NVM Express driver
Message-Id: <20110303133343.afc01f8b.rdunlap@xenotime.net>
In-Reply-To: <20110303204749.GY3663@linux.intel.com>
References: <20110303204749.GY3663@linux.intel.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Mar 2011 15:47:49 -0500 Matthew Wilcox wrote:


> diff --git a/drivers/block/nvme.c b/drivers/block/nvme.c
> new file mode 100644
> index 0000000..a8549df
> --- /dev/null
> +++ b/drivers/block/nvme.c
> @@ -0,0 +1,1622 @@
> +/*
> + * NVM Express device driver
> + * Copyright (c) 2011, Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
> + */


> +static int nvme_major;
> +module_param(nvme_major, int, 0);
> +
> +static int use_threaded_interrupts;
> +module_param(use_threaded_interrupts, int, 0);

Please add MODULE_PARM_DESC() for the parameters.


> +/**
> + * alloc_cmdid - Allocate a Command ID
> + * @param nvmeq The queue that will be used for this command
> + * @param ctx A pointer that will be passed to the handler
> + * @param handler The ID of the handler to call
> + *

That's not quite kernel-doc notation, but /** in kernel code signifies
beginning of kernel-doc notation, so please change it to kernel-doc
notation (or drop the /**). [in multiple places]

> + * Allocate a Command ID for a queue.  The data passed in will
> + * be passed to the completion handler.  This is implemented by using
> + * the bottom two bits of the ctx pointer to store the handler ID.
> + * Passing in a pointer that's not 4-byte aligned will cause a BUG.
> + * We can change this if it becomes a problem.
> + */
> +static int alloc_cmdid(struct nvme_queue *nvmeq, void *ctx, int handler,
> +							unsigned timeout)
> +{
> +	int depth = nvmeq->q_depth - 1;
> +	struct nvme_cmd_info *info = nvme_cmd_info(nvmeq);
> +	int cmdid;
> +
> +	BUG_ON((unsigned long)ctx & 3);
> +
> +	do {
> +		cmdid = find_first_zero_bit(nvmeq->cmdid_data, depth);
> +		if (cmdid >= depth)
> +			return -EBUSY;
> +	} while (test_and_set_bit(cmdid, nvmeq->cmdid_data));
> +
> +	info[cmdid].ctx = (unsigned long)ctx | handler;
> +	info[cmdid].timeout = jiffies + timeout;
> +	return cmdid;
> +}
> +
> +static int alloc_cmdid_killable(struct nvme_queue *nvmeq, void *ctx,
> +						int handler, unsigned timeout)
> +{
> +	int cmdid;
> +	wait_event_killable(nvmeq->sq_full,
> +		(cmdid = alloc_cmdid(nvmeq, ctx, handler, timeout)) >= 0);
> +	return (cmdid < 0) ? -EINTR : cmdid;
> +}
> +
> +/* If you need more than four handlers, you'll need to change how
> + * alloc_cmdid and nvme_process_cq work.  Consider using a special
> + * CMD_CTX value instead, if that works for your situation.
> + */

Please use the common multi-line comment format: [in multiple places]

/*
 * If you need more than four handlers, you'll need to change how
 * alloc_cmdid and nvme_process_cq work.  Consider using a special
 * CMD_CTX value instead, if that works for your situation.
 */



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
