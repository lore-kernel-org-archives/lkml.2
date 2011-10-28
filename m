Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933120Ab1J1Sre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 14:47:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932668Ab1J1Src (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 14:47:32 -0400
Date: Fri, 28 Oct 2011 20:47:29 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        ohering@suse.com, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
In-Reply-To: <1319645321-9770-1-git-send-email-kys@microsoft.com>
Message-ID: <alpine.LNX.2.00.1110282026360.3541@pobox.suse.cz>
References: <1319645321-9770-1-git-send-email-kys@microsoft.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Oct 2011, K. Y. Srinivasan wrote:

> The hv_mouse.c implements a hid compliant mouse driver for use on a 
> Hyper-V based system. This driver is currently in the staging area and
> as part of the effort to move this driver out of staging, I had posted
> the driver code for community review a few weeks ago. This current patch
> addresses all the review comments I have gotten to date.
> 
> As per Greg's suggestion, this patch does not get rid of the code from
> the staging area. Once the mouse driver lands under the hid directory,
> we will cleanup the staging directory.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

K.Y,,

first, thanks a lot for your efforts on working on this driver. Porting it 
to HID infrastructure definitely is a huge and proper step.

> ---
>  drivers/hid/Kconfig    |    6 +
>  drivers/hid/Makefile   |    1 +
>  drivers/hid/hv_mouse.c |  592 ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 599 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/hid/hv_mouse.c
> 
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index 1130a89..068dd97 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -613,6 +613,12 @@ config HID_ZYDACRON
>  	---help---
>  	Support for Zydacron remote control.
>  
> +config HYPERV_MOUSE
> +	tristate "Microsoft Hyper-V mouse driver"
> +	depends on HYPERV
> +	---help---
> +	  Select this option to enable the Hyper-V mouse driver.
> +
>  endmenu
>  
>  endif # HID_SUPPORT
> diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
> index 0a0a38e..436ac2e 100644
> --- a/drivers/hid/Makefile
> +++ b/drivers/hid/Makefile
> @@ -76,6 +76,7 @@ obj-$(CONFIG_HID_ZYDACRON)	+= hid-zydacron.o
>  obj-$(CONFIG_HID_WACOM)		+= hid-wacom.o
>  obj-$(CONFIG_HID_WALTOP)	+= hid-waltop.o
>  obj-$(CONFIG_HID_WIIMOTE)	+= hid-wiimote.o
> +obj-$(CONFIG_HYPERV_MOUSE)	+= hv_mouse.o

I'd prefer a bit to follow the current naming of the drivers in 
drivers/hid directory ... all the device-specific (vendor-specific) 
drivers currently are called hid-<vendor> or similar.

We could talk about changing this naming scheme, but before we reach any 
conclusion on this, I'd prefer this to stay for all drivers if possible.

>  obj-$(CONFIG_USB_HID)		+= usbhid/
>  obj-$(CONFIG_USB_MOUSE)		+= usbhid/
> diff --git a/drivers/hid/hv_mouse.c b/drivers/hid/hv_mouse.c
> new file mode 100644
> index 0000000..dd42411
> --- /dev/null
> +++ b/drivers/hid/hv_mouse.c
> @@ -0,0 +1,592 @@
> +/*
> + *  Copyright (c) 2009, Citrix Systems, Inc.
> + *  Copyright (c) 2010, Microsoft Corporation.
> + *  Copyright (c) 2011, Novell Inc.
> + *
> + *  This program is free software; you can redistribute it and/or modify it
> + *  under the terms and conditions of the GNU General Public License,
> + *  version 2, as published by the Free Software Foundation.
> + *
> + *  This program is distributed in the hope it will be useful, but WITHOUT
> + *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + *  more details.
> + */
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/completion.h>
> +#include <linux/input.h>
> +#include <linux/hid.h>
> +#include <linux/hiddev.h>
> +#include <linux/hyperv.h>
> +
> +
> +struct hv_input_dev_info {
> +	unsigned int size;
> +	unsigned short vendor;
> +	unsigned short product;
> +	unsigned short version;
> +	unsigned short reserved[11];
> +};
> +
> +/* The maximum size of a synthetic input message. */
> +#define SYNTHHID_MAX_INPUT_REPORT_SIZE 16
> +
> +/*
> + * Current version
> + *
> + * History:
> + * Beta, RC < 2008/1/22        1,0
> + * RC > 2008/1/22              2,0
> + */
> +#define SYNTHHID_INPUT_VERSION_MAJOR	2
> +#define SYNTHHID_INPUT_VERSION_MINOR	0
> +#define SYNTHHID_INPUT_VERSION		(SYNTHHID_INPUT_VERSION_MINOR | \
> +					 (SYNTHHID_INPUT_VERSION_MAJOR << 16))
> +
> +
> +#pragma pack(push, 1)
> +/*
> + * Message types in the synthetic input protocol
> + */
> +enum synthhid_msg_type {
> +	SYNTH_HID_PROTOCOL_REQUEST,
> +	SYNTH_HID_PROTOCOL_RESPONSE,
> +	SYNTH_HID_INITIAL_DEVICE_INFO,
> +	SYNTH_HID_INITIAL_DEVICE_INFO_ACK,
> +	SYNTH_HID_INPUT_REPORT,
> +	SYNTH_HID_MAX
> +};
> +
> +/*
> + * Basic message structures.
> + */
> +struct synthhid_msg_hdr {
> +	enum synthhid_msg_type type;
> +	u32 size;
> +};
> +
> +struct synthhid_msg {
> +	struct synthhid_msg_hdr header;
> +	char data[1]; /* Enclosed message */
> +};
> +
> +union synthhid_version {
> +	struct {
> +		u16 minor_version;
> +		u16 major_version;
> +	};
> +	u32 version;
> +};
> +
> +/*
> + * Protocol messages
> + */
> +struct synthhid_protocol_request {
> +	struct synthhid_msg_hdr header;
> +	union synthhid_version version_requested;
> +};
> +
> +struct synthhid_protocol_response {
> +	struct synthhid_msg_hdr header;
> +	union synthhid_version version_requested;
> +	unsigned char approved;
> +};
> +
> +struct synthhid_device_info {
> +	struct synthhid_msg_hdr header;
> +	struct hv_input_dev_info hid_dev_info;
> +	struct hid_descriptor hid_descriptor;
> +};
> +
> +struct synthhid_device_info_ack {
> +	struct synthhid_msg_hdr header;
> +	unsigned char reserved;
> +};
> +
> +struct synthhid_input_report {
> +	struct synthhid_msg_hdr header;
> +	char buffer[1];
> +};
> +
> +#pragma pack(pop)
> +
> +#define INPUTVSC_SEND_RING_BUFFER_SIZE		(10*PAGE_SIZE)
> +#define INPUTVSC_RECV_RING_BUFFER_SIZE		(10*PAGE_SIZE)

Where does the '10' constant come from? Is it completely arbitrary, or 
does it some real background?

> +
> +#define NBITS(x) (((x)/BITS_PER_LONG)+1)

Where is this macro needed? (I wouldn't notice normally, but I have 
wondered why you can't use BIT_WORD and found that I can't seem to find a 
place where this macro would actually be used :) ).

> +
> +enum pipe_prot_msg_type {
> +	PIPE_MESSAGE_INVALID,
> +	PIPE_MESSAGE_DATA,
> +	PIPE_MESSAGE_MAXIMUM
> +};
> +
> +
> +struct pipe_prt_msg {
> +	enum pipe_prot_msg_type type;
> +	u32 size;
> +	char data[1];
> +};
> +
> +struct  mousevsc_prt_msg {
> +	enum pipe_prot_msg_type type;
> +	u32 size;
> +	union {
> +		struct synthhid_protocol_request request;
> +		struct synthhid_protocol_response response;
> +		struct synthhid_device_info_ack ack;
> +	};
> +};
> +
> +/*
> + * Represents an mousevsc device
> + */
> +struct mousevsc_dev {
> +	struct hv_device	*device;
> +	bool			init_complete;
> +	struct mousevsc_prt_msg	protocol_req;
> +	struct mousevsc_prt_msg	protocol_resp;
> +	/* Synchronize the request/response if needed */
> +	struct completion	wait_event;
> +	int			dev_info_status;
> +
> +	struct hid_descriptor	*hid_desc;
> +	unsigned char		*report_desc;
> +	u32			report_desc_size;
> +	struct hv_input_dev_info hid_dev_info;
> +	bool			connected;
> +	struct hid_device       *hid_device;
> +};
> +
> +
> +static struct mousevsc_dev *alloc_input_device(struct hv_device *device)
> +{
> +	struct mousevsc_dev *input_dev;
> +
> +	input_dev = kzalloc(sizeof(struct mousevsc_dev), GFP_KERNEL);
> +
> +	if (!input_dev)
> +		return NULL;
> +
> +	input_dev->device = device;
> +	hv_set_drvdata(device, input_dev);
> +	init_completion(&input_dev->wait_event);
> +
> +	return input_dev;
> +}
> +
> +static void free_input_device(struct mousevsc_dev *device)
> +{
> +	kfree(device->hid_desc);
> +	kfree(device->report_desc);
> +	hv_set_drvdata(device->device, NULL);
> +	kfree(device);
> +}
> +
> +
> +static void mousevsc_on_receive_device_info(struct mousevsc_dev *input_device,
> +				struct synthhid_device_info *device_info)
> +{
> +	int ret = 0;
> +	struct hid_descriptor *desc;
> +	struct mousevsc_prt_msg ack;
> +
> +	/* Assume success for now */
> +	input_device->dev_info_status = 0;
> +
> +	memcpy(&input_device->hid_dev_info, &device_info->hid_dev_info,
> +		sizeof(struct hv_input_dev_info));
> +
> +	desc = &device_info->hid_descriptor;
> +	WARN_ON(desc->bLength == 0);
> +
> +	input_device->hid_desc = kzalloc(desc->bLength, GFP_ATOMIC);
> +
> +	if (!input_device->hid_desc)
> +		goto cleanup;
> +
> +	memcpy(input_device->hid_desc, desc, desc->bLength);
> +
> +	input_device->report_desc_size = desc->desc[0].wDescriptorLength;
> +	if (input_device->report_desc_size == 0)
> +		goto cleanup;
> +	input_device->report_desc = kzalloc(input_device->report_desc_size,
> +					  GFP_ATOMIC);
> +
> +	if (!input_device->report_desc)
> +		goto cleanup;
> +
> +	memcpy(input_device->report_desc,
> +	       ((unsigned char *)desc) + desc->bLength,
> +	       desc->desc[0].wDescriptorLength);
> +
> +	/* Send the ack */
> +	memset(&ack, 0, sizeof(struct mousevsc_prt_msg));
> +
> +	ack.type = PIPE_MESSAGE_DATA;
> +	ack.size = sizeof(struct synthhid_device_info_ack);
> +
> +	ack.ack.header.type = SYNTH_HID_INITIAL_DEVICE_INFO_ACK;
> +	ack.ack.header.size = 1;
> +	ack.ack.reserved = 0;
> +
> +	ret = vmbus_sendpacket(input_device->device->channel,
> +			&ack,
> +			sizeof(struct pipe_prt_msg) - sizeof(unsigned char) +
> +			sizeof(struct synthhid_device_info_ack),
> +			(unsigned long)&ack,
> +			VM_PKT_DATA_INBAND,
> +			VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
> +	if (ret != 0)
> +		goto cleanup;
> +
> +	complete(&input_device->wait_event);
> +
> +	return;
> +
> +cleanup:
> +	kfree(input_device->hid_desc);
> +	input_device->hid_desc = NULL;
> +
> +	kfree(input_device->report_desc);
> +	input_device->report_desc = NULL;
> +
> +	input_device->dev_info_status = -1;
> +	complete(&input_device->wait_event);
> +}
> +
> +static void mousevsc_on_receive(struct hv_device *device,
> +				struct vmpacket_descriptor *packet)
> +{
> +	struct pipe_prt_msg *pipe_msg;
> +	struct synthhid_msg *hid_msg;
> +	struct mousevsc_dev *input_dev = hv_get_drvdata(device);
> +	struct synthhid_input_report *input_report;
> +
> +	pipe_msg = (struct pipe_prt_msg *)((unsigned long)packet +
> +						(packet->offset8 << 3));
> +
> +	if (pipe_msg->type != PIPE_MESSAGE_DATA)
> +		return;
> +
> +	hid_msg = (struct synthhid_msg *)&pipe_msg->data[0];
> +
> +	switch (hid_msg->header.type) {
> +	case SYNTH_HID_PROTOCOL_RESPONSE:
> +		memcpy(&input_dev->protocol_resp, pipe_msg,
> +		       pipe_msg->size + sizeof(struct pipe_prt_msg) -
> +		       sizeof(unsigned char));

Is there any guarantee anywhere that packet doesn't get corrupted (either 
maliciously or not)?

Seems to me like we are taking it 'raw' in mousevsc_on_channel_callback() 
without any sanity checking.

If not, second argument of this memcpy() could easily overflow, causing 
quite some memory corruption, right?

Actually the question of sanity of the raw packet is much more general one 
throughout this driver. I am not very familiar with things in drivers/hv, 
hence the question.

> +		complete(&input_dev->wait_event);
> +		break;
> +
> +	case SYNTH_HID_INITIAL_DEVICE_INFO:
> +		WARN_ON(pipe_msg->size < sizeof(struct hv_input_dev_info));
> +
> +		/*
> +		 * Parse out the device info into device attr,
> +		 * hid desc and report desc
> +		 */
> +		mousevsc_on_receive_device_info(input_dev,
> +			(struct synthhid_device_info *)&pipe_msg->data[0]);
> +		break;
> +	case SYNTH_HID_INPUT_REPORT:
> +		input_report =
> +			(struct synthhid_input_report *)&pipe_msg->data[0];
> +		if (!input_dev->init_complete)
> +			break;
> +		hid_input_report(input_dev->hid_device,
> +				HID_INPUT_REPORT, input_report->buffer,
> +				input_report->header.size, 1);
> +		break;
> +	default:
> +		pr_err("unsupported hid msg type - type %d len %d",
> +		       hid_msg->header.type, hid_msg->header.size);
> +		break;
> +	}
> +
> +}
> +
> +static void mousevsc_on_channel_callback(void *context)
> +{
> +	const int packet_size = 0x100;
> +	int ret;
> +	struct hv_device *device = context;
> +	u32 bytes_recvd;
> +	u64 req_id;
> +	struct vmpacket_descriptor *desc;
> +	unsigned char	*buffer;
> +	int	bufferlen = packet_size;
> +
> +	buffer = kmalloc(bufferlen, GFP_ATOMIC);
> +	if (!buffer)
> +		return;
> +
> +	do {
> +		ret = vmbus_recvpacket_raw(device->channel, buffer,
> +					bufferlen, &bytes_recvd, &req_id);
> +
> +		switch (ret) {
> +		case 0:
> +			if (bytes_recvd <= 0) {
> +				kfree(buffer);
> +				return;
> +			}
> +			desc = (struct vmpacket_descriptor *)buffer;
> +
> +			switch (desc->type) {
> +			case VM_PKT_COMP:
> +				break;
> +
> +			case VM_PKT_DATA_INBAND:
> +				mousevsc_on_receive(device, desc);
> +				break;
> +
> +			default:
> +				pr_err("unhandled packet type %d, tid %llx len %d\n",
> +				   desc->type,
> +				   req_id,
> +				   bytes_recvd);
> +				break;
> +			}
> +
> +			break;
> +
> +		case -ENOBUFS:
> +			kfree(buffer);
> +			/* Handle large packet */
> +			bufferlen = bytes_recvd;
> +			buffer = kmalloc(bytes_recvd, GFP_ATOMIC);
> +
> +			if (buffer == NULL) {

I'd prefer if (!buffer) here, but not a big deal.

> +				return;
> +			}
> +			break;
> +		}
> +	} while (1);

Again, not being familiar with 'hv' infrastructure at all, this inifite 
loop makes me to ask -- in what context does it run? Why do we need it?

It seems to me that it's some kind of infinite loop for event-driven 
programming, which is not something we do in kernel (outside of kernel 
threads, perhaps, with very careful handling).

> +
> +}
> +
> +static int mousevsc_connect_to_vsp(struct hv_device *device)
> +{
> +	int ret = 0;
> +	int t;
> +	struct mousevsc_dev *input_dev = hv_get_drvdata(device);
> +	struct mousevsc_prt_msg *request;
> +	struct mousevsc_prt_msg *response;
> +
> +

No need for two spaces here.

> +	request = &input_dev->protocol_req;
> +
> +	memset(request, 0, sizeof(struct mousevsc_prt_msg));
> +
> +	request->type = PIPE_MESSAGE_DATA;
> +	request->size = sizeof(struct synthhid_protocol_request);
> +
> +	request->request.header.type = SYNTH_HID_PROTOCOL_REQUEST;
> +	request->request.header.size = sizeof(unsigned int);
> +	request->request.version_requested.version = SYNTHHID_INPUT_VERSION;
> +
> +

Here as well.

> +	ret = vmbus_sendpacket(device->channel, request,
> +				sizeof(struct pipe_prt_msg) -
> +				sizeof(unsigned char) +
> +				sizeof(struct synthhid_protocol_request),
> +				(unsigned long)request,
> +				VM_PKT_DATA_INBAND,
> +				VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
> +	if (ret != 0)

Just if (ret) ... ?

> +		goto cleanup;
> +
> +	t = wait_for_completion_timeout(&input_dev->wait_event, 5*HZ);
> +	if (t == 0) {

if (!t)

> +		ret = -ETIMEDOUT;
> +		goto cleanup;
> +	}
> +
> +	response = &input_dev->protocol_resp;
> +
> +	if (!response->response.approved) {
> +		pr_err("synthhid protocol request failed (version %d)\n",
> +		       SYNTHHID_INPUT_VERSION);
> +		ret = -ENODEV;
> +		goto cleanup;
> +	}
> +
> +	t = wait_for_completion_timeout(&input_dev->wait_event, 5*HZ);
> +	if (t == 0) {
> +		ret = -ETIMEDOUT;
> +		goto cleanup;
> +	}
> +
> +	/*
> +	 * We should have gotten the device attr, hid desc and report
> +	 * desc at this point
> +	 */
> +	if (input_dev->dev_info_status)
> +		ret = -ENOMEM;
> +
> +cleanup:
> +
> +	return ret;
> +}
> +
> +static int mousevsc_hid_open(struct hid_device *hid)
> +{
> +	return 0;
> +}
> +
> +static int mousevsc_hid_start(struct hid_device *hid)
> +{
> +	return 0;
> +}
> +
> +static void mousevsc_hid_close(struct hid_device *hid)
> +{
> +}
> +
> +static void mousevsc_hid_stop(struct hid_device *hid)
> +{
> +}
> +
> +static struct hid_ll_driver mousevsc_ll_driver = {
> +	.open = mousevsc_hid_open,
> +	.close = mousevsc_hid_close,
> +	.start = mousevsc_hid_start,
> +	.stop = mousevsc_hid_stop,
> +};
> +
> +static struct hid_driver mousevsc_hid_driver;
> +
> +static int mousevsc_probe(struct hv_device *device,
> +			const struct hv_vmbus_device_id *dev_id)
> +{
> +	int ret = 0;
> +	struct mousevsc_dev *input_dev;
> +	struct hid_device *hid_dev;
> +
> +	input_dev = alloc_input_device(device);
> +
> +	if (!input_dev)
> +		return -ENOMEM;
> +
> +	input_dev->init_complete = false;
> +
> +	ret = vmbus_open(device->channel,
> +		INPUTVSC_SEND_RING_BUFFER_SIZE,
> +		INPUTVSC_RECV_RING_BUFFER_SIZE,
> +		NULL,
> +		0,
> +		mousevsc_on_channel_callback,
> +		device
> +		);
> +
> +	if (ret != 0) {
> +		free_input_device(input_dev);
> +		return ret;
> +	}
> +
> +
> +	ret = mousevsc_connect_to_vsp(device);
> +
> +	if (ret != 0)
> +		goto probe_err0;
> +
> +	/* workaround SA-167 */
> +	if (input_dev->report_desc[14] == 0x25)
> +		input_dev->report_desc[14] = 0x29;
> +
> +	hid_dev = hid_allocate_device();
> +	if (IS_ERR(hid_dev)) {
> +		ret = PTR_ERR(hid_dev);
> +		goto probe_err0;
> +	}
> +
> +	hid_dev->ll_driver = &mousevsc_ll_driver;
> +	hid_dev->driver = &mousevsc_hid_driver;
> +	hid_dev->bus = BUS_VIRTUAL;
> +	hid_dev->vendor = input_dev->hid_dev_info.vendor;
> +	hid_dev->product = input_dev->hid_dev_info.product;
> +	hid_dev->version = input_dev->hid_dev_info.version;
> +	input_dev->hid_device = hid_dev;
> +
> +	sprintf(hid_dev->name, "%s", "Microsoft Vmbus HID-compliant Mouse");
> +
> +	ret = hid_parse_report(hid_dev, input_dev->report_desc,
> +				input_dev->report_desc_size);
> +
> +	if (ret) {
> +		hid_err(hid_dev, "parse failed\n");
> +		goto probe_err1;
> +	}
> +
> +	ret = hid_hw_start(hid_dev, HID_CONNECT_HIDINPUT | HID_CONNECT_HIDDEV);
> +
> +	if (ret) {
> +		hid_err(hid_dev, "hw start failed\n");
> +		goto probe_err1;
> +	}
> +
> +	input_dev->connected = true;
> +	input_dev->init_complete = true;
> +
> +	return ret;
> +
> +probe_err1:
> +	hid_destroy_device(hid_dev);
> +
> +probe_err0:
> +	vmbus_close(device->channel);
> +	free_input_device(input_dev);
> +	return ret;
> +}
> +
> +
> +static int mousevsc_remove(struct hv_device *dev)
> +{
> +	struct mousevsc_dev *input_dev = hv_get_drvdata(dev);
> +
> +	vmbus_close(dev->channel);
> +
> +	if (input_dev->connected) {
> +		hidinput_disconnect(input_dev->hid_device);
> +		input_dev->connected = false;
> +		hid_destroy_device(input_dev->hid_device);
> +	}
> +
> +	free_input_device(input_dev);
> +
> +	return 0;
> +}
> +
> +static const struct hv_vmbus_device_id id_table[] = {
> +	/* Mouse guid */
> +	{ VMBUS_DEVICE(0x9E, 0xB6, 0xA8, 0xCF, 0x4A, 0x5B, 0xc0, 0x4c,
> +		       0xB9, 0x8B, 0x8B, 0xA1, 0xA1, 0xF3, 0xF9, 0x5A) },
> +	{ },
> +};
> +
> +MODULE_DEVICE_TABLE(vmbus, id_table);
> +
> +static struct  hv_driver mousevsc_drv = {
> +	.name = "mousevsc",
> +	.id_table = id_table,
> +	.probe = mousevsc_probe,
> +	.remove = mousevsc_remove,
> +};
> +
> +static int __init mousevsc_init(void)
> +{
> +	return vmbus_driver_register(&mousevsc_drv);
> +}
> +
> +static void __exit mousevsc_exit(void)
> +{
> +	vmbus_driver_unregister(&mousevsc_drv);
> +}
> +
> +MODULE_LICENSE("GPL");
> +MODULE_VERSION(HV_DRV_VERSION);
> +module_init(mousevsc_init);
> +module_exit(mousevsc_exit);

Thanks again for porting this to HID bus, I am looking forward to having 
this finalized.

-- 
Jiri Kosina
SUSE Labs
