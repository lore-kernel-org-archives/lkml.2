Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab0LHQxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 11:53:48 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54931 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab0LHQxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 11:53:46 -0500
Date: Wed, 8 Dec 2010 16:53:17 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jeff Ohlstein <johlstei@codeaurora.org>
Cc: Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>
Subject: Re: [PATCH v2 2/6] msm: Secure Channel Manager (SCM) support
Message-ID: <20101208165317.GP9777@n2100.arm.linux.org.uk>
References: <1291782501-3909-1-git-send-email-johlstei@codeaurora.org> <1291782501-3909-3-git-send-email-johlstei@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291782501-3909-3-git-send-email-johlstei@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 08:28:17PM -0800, Jeff Ohlstein wrote:
> From: Stephen Boyd <sboyd@codeaurora.org>
> 
> SCM is the protocol used to communicate between the secure and
> non-secure code executing on the applications processor. The
> non-secure side uses a physically contiguous buffer to pass
> information to the secure side; where the buffer conforms to a
> format that is agreed upon by both sides. The use of a buffer
> allows multiple pending requests to be in flight on the secure
> side. It also benefits use cases where the command or response
> buffer contains large chunks of data.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/mach-msm/Kconfig  |    4 +
>  arch/arm/mach-msm/Makefile |    1 +
>  arch/arm/mach-msm/scm.c    |  280 ++++++++++++++++++++++++++++++++++++++++++++
>  arch/arm/mach-msm/scm.h    |   41 +++++++
>  4 files changed, 326 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-msm/scm.c
>  create mode 100644 arch/arm/mach-msm/scm.h
> 
> diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
> index 31e5fd6..ab5338f 100644
> --- a/arch/arm/mach-msm/Kconfig
> +++ b/arch/arm/mach-msm/Kconfig
> @@ -44,6 +44,7 @@ config ARCH_MSM8X60
>  	select CPU_V7
>  	select MSM_V2_TLMM
>  	select MSM_GPIOMUX
> +	select MSM_SCM if SMP
>  
>  endchoice
>  
> @@ -164,4 +165,7 @@ config MSM_GPIOMUX
>  
>  config MSM_V2_TLMM
>  	bool
> +
> +config MSM_SCM
> +	bool
>  endif
> diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
> index b5a7b07..eed503b 100644
> --- a/arch/arm/mach-msm/Makefile
> +++ b/arch/arm/mach-msm/Makefile
> @@ -18,6 +18,7 @@ obj-$(CONFIG_MSM_PROC_COMM) += clock.o
>  obj-$(CONFIG_ARCH_QSD8X50) += sirc.o
>  obj-$(CONFIG_MSM_SMD) += smd.o smd_debug.o
>  obj-$(CONFIG_MSM_SMD) += last_radio_log.o
> +obj-$(CONFIG_MSM_SCM) += scm.o
>  
>  obj-$(CONFIG_MACH_TROUT) += board-trout.o board-trout-gpio.o board-trout-mmc.o devices-msm7x00.o
>  obj-$(CONFIG_MACH_HALIBUT) += board-halibut.o devices-msm7x00.o
> diff --git a/arch/arm/mach-msm/scm.c b/arch/arm/mach-msm/scm.c
> new file mode 100644
> index 0000000..85ed2cc
> --- /dev/null
> +++ b/arch/arm/mach-msm/scm.c
> @@ -0,0 +1,280 @@
> +/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> + * 02110-1301, USA.
> + */
> +
> +#include <linux/slab.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/errno.h>
> +#include <linux/err.h>
> +#include <linux/dma-mapping.h>
> +
> +#include <asm/cacheflush.h>
> +
> +#include "scm.h"
> +
> +#define SCM_ENOMEM		-5
> +#define SCM_EOPNOTSUPP		-4
> +#define SCM_EINVAL_ADDR		-3
> +#define SCM_EINVAL_ARG		-2
> +#define SCM_ERROR		-1
> +#define SCM_INTERRUPTED		1
> +
> +static DEFINE_MUTEX(scm_lock);
> +
> +/**
> + * struct scm_command - one SCM command buffer
> + * @len: total available memory for command and response
> + * @buf_offset: start of command buffer
> + * @resp_hdr_offset: start of response buffer
> + * @id: command to be executed
> + *
> + * An SCM command is layed out in memory as follows:
> + *
> + *	------------------- <--- struct scm_command
> + *	| command header  |
> + *	------------------- <--- scm_get_command_buffer()
> + *	| command buffer  |
> + *	------------------- <--- struct scm_response and
> + *	| response header |      scm_command_to_response()
> + *	------------------- <--- scm_get_response_buffer()
> + *	| response buffer |
> + *	-------------------
> + *
> + * There can be arbitrary padding between the headers and buffers so
> + * you should always use the appropriate scm_get_*_buffer() routines
> + * to access the buffers in a safe manner.
> + */
> +struct scm_command {
> +	u32	len;
> +	u32	buf_offset;
> +	u32	resp_hdr_offset;
> +	u32	id;
> +};
> +
> +/**
> + * struct scm_response - one SCM response buffer
> + * @len: total available memory for response
> + * @buf_offset: start of response data relative to start of scm_response
> + * @is_complete: indicates if the command has finished processing
> + */
> +struct scm_response {
> +	u32	len;
> +	u32	buf_offset;
> +	u32	is_complete;
> +};
> +
> +/**
> + * alloc_scm_command() - Allocate an SCM command
> + * @cmd_size: size of the command buffer
> + * @resp_size: size of the response buffer
> + * @handle: dma handle
> + *
> + * Allocate an SCM command, including enough room for the command
> + * and response headers as well as the command and response buffers.
> + *
> + * Returns a valid &scm_command on success or %NULL if the allocation fails.
> + */
> +static struct scm_command *alloc_scm_command(size_t cmd_size, size_t resp_size,
> +		dma_addr_t *handle)
> +{
> +	struct scm_command *cmd;
> +	size_t len = sizeof(*cmd) + sizeof(struct scm_response) + cmd_size +
> +		resp_size;
> +
> +	cmd = dma_alloc_coherent(NULL, len, handle, GFP_KERNEL);
> +	if (cmd) {
> +		cmd->len = len;
> +		cmd->buf_offset = sizeof(*cmd);

Ok, so the real command bytes come after this struct scm_command structure.
So why not do this:

+struct scm_command {
+	u32	len;
+	u32	buf_offset;
+	u32	resp_hdr_offset;
+	u32	id;
+	u32	cmdwds[0];
+};

and

		cmd->buff_offset = offsetof(struct scm_command, cmdwds);

sizeof(struct scm_command) will still be 32, but now you can do:

> +		cmd->resp_hdr_offset = cmd->buf_offset + cmd_size;
> +	}
> +	return cmd;
> +}
> +
> +/**
> + * free_scm_command() - Free an SCM command
> + * @cmd: command to free
> + * @handle: dma handle
> + *
> + * Free an SCM command.
> + */
> +static inline void free_scm_command(struct scm_command *cmd, dma_addr_t handle)
> +{
> +	dma_free_coherent(NULL, cmd->len, cmd, handle);
> +}
> +
> +/**
> + * scm_command_to_response() - Get a pointer to a scm_response
> + * @cmd: command
> + *
> + * Returns a pointer to a response for a command.
> + */
> +static inline struct scm_response *scm_command_to_response(
> +		const struct scm_command *cmd)
> +{
> +	return (void *)cmd + cmd->resp_hdr_offset;
> +}
> +
> +/**
> + * scm_get_command_buffer() - Get a pointer to a command buffer
> + * @cmd: command
> + *
> + * Returns a pointer to the command buffer of a command.
> + */
> +static inline void *scm_get_command_buffer(const struct scm_command *cmd)
> +{
> +	return (void *)cmd + cmd->buf_offset;

and here becomes:
	return (void *)cmd->cmdwds;
if it's necessary for it to exist at all.

> +}
> +
> +/**
> + * scm_get_response_buffer() - Get a pointer to a response buffer
> + * @rsp: response
> + *
> + * Returns a pointer to a response buffer of a response.
> + */
> +static inline void *scm_get_response_buffer(const struct scm_response *rsp)
> +{
> +	return (void *)rsp + rsp->buf_offset;
> +}
> +
> +static int scm_remap_error(int err)
> +{
> +	switch (err) {
> +	case SCM_ERROR:
> +		return -EIO;
> +	case SCM_EINVAL_ADDR:
> +	case SCM_EINVAL_ARG:
> +		return -EINVAL;
> +	case SCM_EOPNOTSUPP:
> +		return -EOPNOTSUPP;
> +	case SCM_ENOMEM:
> +		return -ENOMEM;
> +	}
> +	return -EINVAL;
> +}
> +
> +static u32 smc(dma_addr_t cmd_addr)
> +{
> +	int context_id;
> +	register u32 r0 asm("r0") = 1;
> +	register u32 r1 asm("r1") = (u32)&context_id;
> +	register u32 r2 asm("r2") = (u32)cmd_addr;
> +	asm(
> +		__asmeq("%0", "r0")
> +		__asmeq("%1", "r0")
> +		__asmeq("%2", "r1")
> +		__asmeq("%3", "r2")
> +		"smc	#0	@ switch to secure world\n"
> +		: "=r" (r0)
> +		: "r" (r0), "r" (r1), "r" (r2)
> +		: "r3");
> +	return r0;
> +}
> +
> +static int __scm_call(const dma_addr_t cmd)
> +{
> +	int ret;
> +
> +	/*
> +	 * Flush the entire cache here so callers don't have to remember
> +	 * to flush the cache when passing physical addresses to the secure
> +	 * side in the buffer.
> +	 */
> +	flush_cache_all();
> +	do {
> +		ret = smc(cmd);
> +		if (ret < 0) {
> +			ret = scm_remap_error(ret);
> +			break;
> +		}
> +	} while (ret == SCM_INTERRUPTED);
> +
> +	return ret;
> +}
> +
> +/**
> + * scm_call() - Send an SCM command
> + * @svc_id: service identifier
> + * @cmd_id: command identifier
> + * @cmd_buf: command buffer
> + * @cmd_len: length of the command buffer
> + * @resp_buf: response buffer
> + * @resp_len: length of the response buffer
> + *
> + * Sends a command to the SCM and waits for the command to finish processing.
> + */
> +int scm_call(u32 svc_id, u32 cmd_id, const void *cmd_buf, size_t cmd_len,
> +		void *resp_buf, size_t resp_len)
> +{
> +	int ret;
> +	struct scm_command *cmd;
> +	struct scm_response *rsp;
> +	dma_addr_t handle;
> +
> +	cmd = alloc_scm_command(cmd_len, resp_len, &handle);
> +	if (!cmd)
> +		return -ENOMEM;
> +
> +	cmd->id = (svc_id << 10) | cmd_id;
> +	if (cmd_buf)
> +		memcpy(scm_get_command_buffer(cmd), cmd_buf, cmd_len);
> +	wmb();
> +
> +	mutex_lock(&scm_lock);
> +	ret = __scm_call(handle);
> +	mutex_unlock(&scm_lock);
> +	if (ret)
> +		goto out;
> +
> +	rsp = scm_command_to_response(cmd);
> +	do {
> +		rmb();
> +	} while (!rsp->is_complete);

Hmm, this seems weird.  Doesn't the SMC call only return once the request
has been completed?
