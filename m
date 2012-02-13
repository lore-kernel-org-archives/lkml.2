Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab2BMNGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 08:06:05 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:56961 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab2BMNGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 08:06:02 -0500
Subject: Re: [PATCH 06/13] firewire-sbp-target: Add sbp_fabric.{c,h}
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Chris Boot <bootc@bootc.net>
Cc: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        stefanr@s5r6.in-berlin.de
In-Reply-To: <1328989452-20921-7-git-send-email-bootc@bootc.net>
References: <4E4BD560.4010806@bootc.net>
	 <1328989452-20921-1-git-send-email-bootc@bootc.net>
	 <1328989452-20921-7-git-send-email-bootc@bootc.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Feb 2012 05:06:00 -0800
Message-ID: <1329138360.9333.399.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-02-11 at 19:44 +0000, Chris Boot wrote:
> This serves as further glue between the target framework and SBP-2, in
> this case dealing with SCSI command submission and data in/out.
> 
> Signed-off-by: Chris Boot <bootc@bootc.net>
> Cc: Andy Grover <agrover@redhat.com>
> Cc: Clemens Ladisch <clemens@ladisch.de>
> Cc: Nicholas A. Bellinger <nab@linux-iscsi.org>
> Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>  drivers/target/sbp/sbp_fabric.c |  321 +++++++++++++++++++++++++++++++++++++++
>  drivers/target/sbp/sbp_fabric.h |   32 ++++
>  2 files changed, 353 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/target/sbp/sbp_fabric.c
>  create mode 100644 drivers/target/sbp/sbp_fabric.h
> 
> diff --git a/drivers/target/sbp/sbp_fabric.c b/drivers/target/sbp/sbp_fabric.c
> new file mode 100644
> index 0000000..edc6fda
> --- /dev/null
> +++ b/drivers/target/sbp/sbp_fabric.c
> @@ -0,0 +1,321 @@
> +/*
> + * SBP2 target driver (SCSI over IEEE1394 in target mode)
> + *
> + * Copyright (C) 2011  Chris Boot <bootc@bootc.net>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software Foundation,
> + * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + */
> +

<SNIP>

> +int sbp_new_cmd(struct se_cmd *se_cmd)
> +{
> +	struct sbp_target_request *req = container_of(se_cmd,
> +			struct sbp_target_request, se_cmd);
> +	int ret;
> +
> +	ret = transport_generic_allocate_tasks(se_cmd, req->cmd_buf);
> +	if (ret)
> +		return ret;
> +
> +	return transport_generic_map_mem_to_cmd(se_cmd, NULL, 0, NULL, 0);
> +}
> +

Because sbp_scsi_cmnd.c:sbp_handle_command() is using the new
target_submit_cmd() logic, target-core will not be calling
TFO->new_cmd_map() -> sbp_new_cmd() for setup here.

Go ahead and drop this now.

> +
> +u32 sbp_get_task_tag(struct se_cmd *se_cmd)
> +{
> +	struct sbp_target_request *req = container_of(se_cmd,
> +			struct sbp_target_request, se_cmd);
> +
> +	/* only used for printk and family? */
> +	return (u32)req->orb_pointer;
> +}
> +

So an the ABORT_TASK TMR patches use TFO->get_task_tag() to locate a
referenced tag to locate the se_cmd descriptor.  Since we don't
support TMRs yet in sbp, this value will only be used for informational
purposes.

> +
> +int sbp_queue_data_in(struct se_cmd *se_cmd)
> +{
> +	struct sbp_target_request *req = container_of(se_cmd,
> +			struct sbp_target_request, se_cmd);
> +	int ret;
> +
> +	if (!req->data_len) {
> +		req->status.status |= cpu_to_be32(
> +			STATUS_BLOCK_RESP(STATUS_RESP_ILLEGAL_REQUEST) |
> +			STATUS_BLOCK_DEAD(0) |
> +			STATUS_BLOCK_LEN(1) |
> +			STATUS_BLOCK_SBP_STATUS(SBP_STATUS_UNSPECIFIED_ERROR));
> +		sbp_send_status(req);
> +		pr_err("sbp_queue_data_in: no initiator data buffers\n");
> +		return 0;
> +	}
> +
> +	if (req->data_dir != DMA_FROM_DEVICE) {
> +		pr_err("sbp_queue_data_in: incorrect data direction\n");
> +		return -EINVAL;
> +	}
> +
> +	if (req->data_len != se_cmd->data_length) {
> +		pr_warn("sbp_write_pending: dodgy data length (%d != %d)\n",
> +			req->data_len, se_cmd->data_length);
> +	}
> +
> +	req->data_buf = kmalloc(se_cmd->data_length, GFP_KERNEL);
> +	if (!req->data_buf)
> +		return -ENOMEM;
> +
> +	sg_copy_to_buffer(se_cmd->t_data_sg,
> +		se_cmd->t_data_nents,
> +		req->data_buf,
> +		se_cmd->data_length);
> +
> +	ret = sbp_rw_data(req);
> +	if (ret) {
> +		req->status.status |= cpu_to_be32(
> +			STATUS_BLOCK_RESP(STATUS_RESP_TRANSPORT_FAILURE) |
> +			STATUS_BLOCK_DEAD(0) |
> +			STATUS_BLOCK_LEN(1) |
> +			STATUS_BLOCK_SBP_STATUS(SBP_STATUS_UNSPECIFIED_ERROR));
> +		sbp_send_status(req);
> +		return ret;
> +	}
> +
> +	return sbp_send_sense(req);
> +}
> +
> +/*
> + * Called after command (no data transfer) or after the write (to device)
> + * operation is completed
> + */
> +int sbp_queue_status(struct se_cmd *se_cmd)
> +{
> +	struct sbp_target_request *req = container_of(se_cmd,
> +			struct sbp_target_request, se_cmd);
> +
> +	return sbp_send_sense(req);
> +}
> +

Thanks!

--nab

