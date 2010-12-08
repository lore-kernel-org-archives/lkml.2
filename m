Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab0LHT7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 14:59:52 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9589 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099Ab0LHT7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 14:59:48 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6190"; a="65824665"
Message-ID: <4CFFE3B2.1060600@codeaurora.org>
Date: Wed, 08 Dec 2010 11:59:46 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Jeff Ohlstein <johlstei@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>
Subject: Re: [PATCH v2 2/6] msm: Secure Channel Manager (SCM) support
References: <1291782501-3909-1-git-send-email-johlstei@codeaurora.org> <1291782501-3909-3-git-send-email-johlstei@codeaurora.org> <20101208165317.GP9777@n2100.arm.linux.org.uk>
In-Reply-To: <20101208165317.GP9777@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2010 08:53 AM, Russell King - ARM Linux wrote:
>
> Ok, so the real command bytes come after this struct scm_command structure.
> So why not do this:
>
> +struct scm_command {
> +	u32	len;
> +	u32	buf_offset;
> +	u32	resp_hdr_offset;
> +	u32	id;
> +	u32	cmdwds[0];
> +};
>
> and
>
> 		cmd->buff_offset = offsetof(struct scm_command, cmdwds);
>
> sizeof(struct scm_command) will still be 32, but now you can do:
[snip]
>> +/**
>> + * scm_get_command_buffer() - Get a pointer to a command buffer
>> + * @cmd: command
>> + *
>> + * Returns a pointer to the command buffer of a command.
>> + */
>> +static inline void *scm_get_command_buffer(const struct scm_command *cmd)
>> +{
>> +	return (void *)cmd + cmd->buf_offset;
>
> and here becomes:
> 	return (void *)cmd->cmdwds;
> if it's necessary for it to exist at all.
>

Ok. I was thinking that the command should be treated the same as the
response, since the padding between the response header and response
buffer can be arbitrary (and not under our control). This isn't true for
the command header and command buffer since we define the padding.

I still like the idea of scm_get_command_buffer() though since it duals
scm_get_response_buffer().

>> +int scm_call(u32 svc_id, u32 cmd_id, const void *cmd_buf, size_t cmd_len,
>> +		void *resp_buf, size_t resp_len)
>> +{
>> +	int ret;
>> +	struct scm_command *cmd;
>> +	struct scm_response *rsp;
>> +	dma_addr_t handle;
>> +
>> +	cmd = alloc_scm_command(cmd_len, resp_len, &handle);
>> +	if (!cmd)
>> +		return -ENOMEM;
>> +
>> +	cmd->id = (svc_id << 10) | cmd_id;
>> +	if (cmd_buf)
>> +		memcpy(scm_get_command_buffer(cmd), cmd_buf, cmd_len);
>> +	wmb();
>> +
>> +	mutex_lock(&scm_lock);
>> +	ret = __scm_call(handle);
>> +	mutex_unlock(&scm_lock);
>> +	if (ret)
>> +		goto out;
>> +
>> +	rsp = scm_command_to_response(cmd);
>> +	do {
>> +		rmb();
>> +	} while (!rsp->is_complete);
>
> Hmm, this seems weird.  Doesn't the SMC call only return once the request
> has been completed?

No. __scm_call() returns once the request has been accepted. scm_call()
returns once the request has completed. Multiple scm_command's can be in
flight at the same time on the secure side.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

