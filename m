Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232Ab1JOGgl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 02:36:41 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38996 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750802Ab1JOGgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 02:36:39 -0400
Message-ID: <1318660596.6035.27.camel@Joe-Laptop>
Subject: Re: [PATCH 1/1] Staging: hv: mousevsc: Move the mouse driver out of
 staging
From: Joe Perches <joe@perches.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, dmitry.torokhov@gmail.com,
        linux-input@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>
Date: Fri, 14 Oct 2011 23:36:36 -0700
In-Reply-To: <1318658907-16698-1-git-send-email-kys@microsoft.com>
References: <1318658907-16698-1-git-send-email-kys@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 23:08 -0700, K. Y. Srinivasan wrote:
> In preparation for moving the mouse driver out of staging, seek community
> review of the mouse driver code.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

Just some stylistic things, none of which should
prevent any code movement.

> +++ b/drivers/hid/hv_mouse.c
[]
> +struct mousevsc_dev {
> +	struct hv_device	*device;
> +	unsigned char		init_complete;

bool?

[]
> +static void mousevsc_on_channel_callback(void *context)
> +{
> +	const int packetSize = 0x100;
> +	int ret = 0;
> +	struct hv_device *device = (struct hv_device *)context;
> +
> +	u32 bytes_recvd;
> +	u64 req_id;
> +	unsigned char packet[0x100];
		[packetSize];

> +	struct vmpacket_descriptor *desc;
> +	unsigned char	*buffer = packet;
> +	int	bufferlen = packetSize;
> +
> +
trivial extra blank line

> +	do {
> +		ret = vmbus_recvpacket_raw(device->channel, buffer,
> +					bufferlen, &bytes_recvd, &req_id);
> +
> +		if (ret == 0) {
> +			if (bytes_recvd > 0) {
> +				desc = (struct vmpacket_descriptor *)buffer;
> +
> +				switch (desc->type) {
> +				case VM_PKT_COMP:
> +					break;
> +
> +				case VM_PKT_DATA_INBAND:
> +					mousevsc_on_receive(
> +						device, desc);
> +					break;
> +
> +				default:
> +					pr_err("unhandled packet type %d, tid %llx len %d\n",
> +						   desc->type,
> +						   req_id,
> +						   bytes_recvd);
> +					break;
> +				}
> +
> +				/* reset */
> +				if (bufferlen > packetSize) {
> +					kfree(buffer);
> +
> +					buffer = packet;
> +					bufferlen = packetSize;
> +				}
> +			} else {
> +				if (bufferlen > packetSize) {
> +					kfree(buffer);
> +
> +					buffer = packet;
> +					bufferlen = packetSize;
> +				}
> +				break;
> +			}
> +		} else if (ret == -ENOBUFS) {
> +			/* Handle large packet */
> +			bufferlen = bytes_recvd;
> +			buffer = kzalloc(bytes_recvd, GFP_ATOMIC);
> +
> +			if (buffer == NULL) {
> +				buffer = packet;
> +				bufferlen = packetSize;
> +				break;
> +			}
> +		}
> +	} while (1);

This do {} while (1); seems like it could be simpler,
less indented and less confusing if it used continues
or gotos like below (if I wrote it correctly...)

loop:
	ret = vmbus_bus_recvpacket_raw(device->channel, buffer,
				       bufferlen, &bytes_recvd, &req_id);
	switch (ret) {
	case -ENOBUFS:
		/* Handle large packet */
		bufferlen = bytes_recvd;
		buffer = kzalloc(bytes_recvd, GFP_ATOMIC);
/*
Why kzalloc and not kmalloc?
The stack variable packet is not memset to 0,
why should buffer be zeroed?
*/
		if (!buffer)
			return;
		goto loop;
	case 0:
		if (bytes_recvd <= 0)
			goto loop;
		desc = (struct vmpacket_descriptor *)buffer;

		switch (desc->type) {
		case VM_PKT_COMP:
			break;
		case VM_PKT_DATA_INBAND:
			mousevsc_on_receive(device, desc);
			break;
		default:
			pr_err("unhandled packet type %d, tid %llx len %d\n",
			       desc->type, req_id, bytes_recvd);
			break;
		}
		/* reset to original buffers */
		if (bufferlen > packetSize) {
			kfree(buffer);
			buffer = packet;
			bufferlen = packetSize;
		}
	}
	goto loop;
}

> +
> +static int mousevsc_connect_to_vsp(struct hv_device *device)
> +{
[]
> +	if (!response->response.approved) {
> +		pr_err("synthhid protocol request failed (version %d)",
> +		       SYNTHHID_INPUT_VERSION);

Missing \n at end of format string

[]
> +static int mousevsc_on_device_add(struct hv_device *device)
> +{
[]
> +	ret = vmbus_open(device->channel,
> +		INPUTVSC_SEND_RING_BUFFER_SIZE,
> +		INPUTVSC_RECV_RING_BUFFER_SIZE,
> +		NULL,
> +		0,
> +		mousevsc_on_channel_callback,
> +		device
> +		);

Nicer if aligned to open paren I think.

	ret = vmbus_open(device->channel,
			 INPUTVSC_SEND_RING_BUFFER_SIZE,
			 INPUTVSC_RECV_RING_BUFFER_SIZE,
			 NULL, 0, mousevsc_on_channel_callback,
			 device);


