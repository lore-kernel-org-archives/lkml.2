Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab1KGBEz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 20:04:55 -0500
Received: from mail2.microsoft.com ([131.107.115.215]:44169 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965Ab1KGBEy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 20:04:54 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "joe@perches.com" <joe@perches.com>,
        "jkosina@suse.cz" <jkosina@suse.cz>
Subject: RE: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
Thread-Topic: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
Thread-Index: AQHMlb5tFmjUXJbXLkiQVEJ5ygNb75WeV3qAgAJF/pA=
Date: Mon, 7 Nov 2011 01:04:53 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481AA68580@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1319841316-29136-1-git-send-email-kys@microsoft.com>
 <20111105064739.GA31111@core.coreip.homeip.net>
In-Reply-To: <20111105064739.GA31111@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.24]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Saturday, November 05, 2011 2:48 AM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> joe@perches.com; jkosina@suse.cz
> Subject: Re: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
> 
> Hi KY,

Dimitry,

Let me begin by thanking you for taking the time to review. I have incorporated
pretty much all your suggestions. These changes have cleaned up the code 
considerably. I will send the patch out that incorporates these changes shortly. I will
also send out the next version of the patch to move the mouse driver out of staging.
More details in-line.
 
> Can we call it mousevsc_alloc_device?
Done.
> 
> > +{
> > +	struct mousevsc_dev *input_dev;
> > +
> > +	input_dev = kzalloc(sizeof(struct mousevsc_dev), GFP_KERNEL);
> > +
> > +	if (!input_dev)
> > +		return NULL;
> > +
> > +	input_dev->device = device;
> > +	hv_set_drvdata(device, input_dev);
> > +	init_completion(&input_dev->wait_event);
> > +
> > +	return input_dev;
> > +}
> > +
> > +static void free_input_device(struct mousevsc_dev *device)
> 
> Can we call it mousevsc_free_device?

Done.

> This could probably be:
> 
> 	static const mousevsc_prt_msg ack = {
> 		.type = PIPE_MESSAGE_DATA,
> 		.size = sizeof(struct synthhid_device_info_ack),
> 		.ack = {
> 			.header = {
> 				.type = SYNTH_HID_INITIAL_DEVICE_INFO_ACK,
> 				.size = 1,
> 			},
> 			.reserved = 0,
> 		},
> 	};
> 

Done.

> 
> > +
> > +	/* Assume success for now */
> > +	input_device->dev_info_status = 0;
> > +
> > +	memcpy(&input_device->hid_dev_info, &device_info->hid_dev_info,
> > +		sizeof(struct hv_input_dev_info));
> > +
> 
> or simply:
> 
> 	input_device->hid_dev_info = device_info->hid_dev_info;

Done.

> 
> > +	desc = &device_info->hid_descriptor;
> > +	WARN_ON(desc->bLength == 0);
> 
> Should also goto cleanup as such descriptor is not usable.

Done.

> 
> > +
> > +	input_device->hid_desc = kzalloc(desc->bLength, GFP_ATOMIC);
> > +
> > +	if (!input_device->hid_desc)
> 
> if you do
> 
> 		input_device->dev_info_status = -ENOMEM;
> 
> you could use it later instead of defaulting to -ENOMEM.
> 
> > +		goto cleanup;
> > +
> > +	memcpy(input_device->hid_desc, desc, desc->bLength);
> > +
> > +	input_device->report_desc_size = desc->desc[0].wDescriptorLength;
> > +	if (input_device->report_desc_size == 0)
> 
> 		input_device->dev_info_status = -EINVAL;
> 
> > +		goto cleanup;
> > +	input_device->report_desc = kzalloc(input_device->report_desc_size,
> > +					  GFP_ATOMIC);
> > +
> > +	if (!input_device->report_desc)
> 
> 		input_device->dev_info_status = -ENOMEM;
> 
> > +		goto cleanup;
> > +
> > +	memcpy(input_device->report_desc,
> > +	       ((unsigned char *)desc) + desc->bLength,
> > +	       desc->desc[0].wDescriptorLength);
> > +
> > +	/* Send the ack */
> > +	memset(&ack, 0, sizeof(struct mousevsc_prt_msg));
> > +
> > +	ack.type = PIPE_MESSAGE_DATA;
> > +	ack.size = sizeof(struct synthhid_device_info_ack);
> > +
> > +	ack.ack.header.type = SYNTH_HID_INITIAL_DEVICE_INFO_ACK;
> > +	ack.ack.header.size = 1;
> > +	ack.ack.reserved = 0;
> > +
> > +	ret = vmbus_sendpacket(input_device->device->channel,
> > +			&ack,
> > +			sizeof(struct pipe_prt_msg) - sizeof(unsigned char) +
> > +			sizeof(struct synthhid_device_info_ack),
> > +			(unsigned long)&ack,
> > +			VM_PKT_DATA_INBAND,
> > +
> 	VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
> > +	if (ret != 0)
> 
> 		input_device->dev_info_status = ret;
> 
> > +		goto cleanup;
> > +
> > +	complete(&input_device->wait_event);
> > +
> > +	return;
> > +
> > +cleanup:
> > +	kfree(input_device->hid_desc);
> > +	input_device->hid_desc = NULL;
> > +
> > +	kfree(input_device->report_desc);
> > +	input_device->report_desc = NULL;
> 
> Do you have to clean it up here? You still need to clean it up in main
> unwind path so consolidate both error and success path and just signal
> completion and let main code figure it all out.


Done.

> > +
> > +static void mousevsc_on_channel_callback(void *context)
> > +{
> > +	const int packet_size = 0x100;
> > +	int ret;
> > +	struct hv_device *device = context;
> > +	u32 bytes_recvd;
> > +	u64 req_id;
> > +	struct vmpacket_descriptor *desc;
> > +	unsigned char	*buffer;
> > +	int	bufferlen = packet_size;
> > +
> > +	buffer = kmalloc(bufferlen, GFP_ATOMIC);
> > +	if (!buffer)
> > +		return;
> > +
> > +	do {
> > +		ret = vmbus_recvpacket_raw(device->channel, buffer,
> > +					bufferlen, &bytes_recvd, &req_id);
> > +
> > +		switch (ret) {
> > +		case 0:
> > +			if (bytes_recvd <= 0) {
> > +				kfree(buffer);
> > +				return;
> > +			}
> > +			desc = (struct vmpacket_descriptor *)buffer;
> > +
> > +			switch (desc->type) {
> > +			case VM_PKT_COMP:
> > +				break;
> > +
> > +			case VM_PKT_DATA_INBAND:
> > +				mousevsc_on_receive(device, desc);
> > +				break;
> > +
> > +			default:
> > +				pr_err("unhandled packet type %d, tid %llx len
> %d\n",
> > +				   desc->type,
> > +				   req_id,
> > +				   bytes_recvd);
> > +				break;
> > +			}
> > +
> > +			break;
> > +
> > +		case -ENOBUFS:
> > +			kfree(buffer);
> > +			/* Handle large packet */
> > +			bufferlen = bytes_recvd;
> > +			buffer = kmalloc(bytes_recvd, GFP_ATOMIC);
> 
> Instead of potentially ever-increasing buffer that you also allocate
> (and it looks like leaking on every callback invocation) can you just
> repeat the read if you know that there are more data and use single
> pre-allocated buffer?

The ring-buffer protocol is such that we need to consume the full message.
Also, why do you say we are leaking memory?

> 
> > +
> > +			if (!buffer)
> > +				return;
> > +
> > +			break;
> > +		}
> > +	} while (1);
> > +
> > +}
> > +
> > +static int mousevsc_connect_to_vsp(struct hv_device *device)
> > +{
> > +	int ret = 0;
> > +	int t;
> > +	struct mousevsc_dev *input_dev = hv_get_drvdata(device);
> > +	struct mousevsc_prt_msg *request;
> > +	struct mousevsc_prt_msg *response;
> > +
> > +	request = &input_dev->protocol_req;
> > +
> > +	memset(request, 0, sizeof(struct mousevsc_prt_msg));
> > +
> > +	request->type = PIPE_MESSAGE_DATA;
> > +	request->size = sizeof(struct synthhid_protocol_request);
> > +
> > +	request->request.header.type = SYNTH_HID_PROTOCOL_REQUEST;
> > +	request->request.header.size = sizeof(unsigned int);
> > +	request->request.version_requested.version =
> SYNTHHID_INPUT_VERSION;
> >
> 
> This is constant data; just do the same as with ack in
> on_receive_device_info. It does not need to be a part of input_dev, does
> it?

Done.

> 
> > +	ret = vmbus_sendpacket(device->channel, request,
> > +				sizeof(struct pipe_prt_msg) -
> > +				sizeof(unsigned char) +
> > +				sizeof(struct synthhid_protocol_request),
> > +				(unsigned long)request,
> > +				VM_PKT_DATA_INBAND,
> > +
> 	VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
> > +	if (ret)
> > +		goto cleanup;
> > +
> > +	t = wait_for_completion_timeout(&input_dev->wait_event, 5*HZ);
> > +	if (!t) {
> > +		ret = -ETIMEDOUT;
> > +		goto cleanup;
> > +	}
> > +
> > +	response = &input_dev->protocol_resp;
> > +
> > +	if (!response->response.approved) {
> > +		pr_err("synthhid protocol request failed (version %d)\n",
> > +		       SYNTHHID_INPUT_VERSION);
> > +		ret = -ENODEV;
> > +		goto cleanup;
> > +	}
> > +
> > +	t = wait_for_completion_timeout(&input_dev->wait_event, 5*HZ);
> 
> 5 seconds? That's a long time of HV to respond...

Well, this is a safe number! We never wait this long.

> 
> > +	if (!t) {
> > +		ret = -ETIMEDOUT;
> > +		goto cleanup;
> > +	}
> > +
> > +	/*
> > +	 * We should have gotten the device attr, hid desc and report
> > +	 * desc at this point
> > +	 */
> > +	if (input_dev->dev_info_status)
> > +		ret = -ENOMEM;
> 
> Just do
> 
> 	ret = input_dev->dev_info_status;

Done.

> 
> unconditionally.
> 
> > +
> > +cleanup:
> > +
> > +	return ret;
> > +}
> > +
> > +static int mousevsc_hid_open(struct hid_device *hid)
> > +{
> > +	return 0;
> > +}
> > +
> > +static int mousevsc_hid_start(struct hid_device *hid)
> > +{
> > +	return 0;
> > +}
> > +
> > +static void mousevsc_hid_close(struct hid_device *hid)
> > +{
> > +}
> > +
> > +static void mousevsc_hid_stop(struct hid_device *hid)
> > +{
> > +}
> > +
> > +static struct hid_ll_driver mousevsc_ll_driver = {
> > +	.open = mousevsc_hid_open,
> > +	.close = mousevsc_hid_close,
> > +	.start = mousevsc_hid_start,
> > +	.stop = mousevsc_hid_stop,
> > +};
> > +
> > +static struct hid_driver mousevsc_hid_driver;
> > +
> > +static int mousevsc_probe(struct hv_device *device,
> > +			const struct hv_vmbus_device_id *dev_id)
> > +{
> > +	int ret = 0;
> > +	struct mousevsc_dev *input_dev;
> > +	struct hid_device *hid_dev;
> > +
> > +	input_dev = alloc_input_device(device);
> > +
> > +	if (!input_dev)
> > +		return -ENOMEM;
> > +
> > +	input_dev->init_complete = false;
> 
> Should this also be in alloc_input_device()?

Done.

> 
> > +
> > +	ret = vmbus_open(device->channel,
> > +		INPUTVSC_SEND_RING_BUFFER_SIZE,
> > +		INPUTVSC_RECV_RING_BUFFER_SIZE,
> > +		NULL,
> > +		0,
> > +		mousevsc_on_channel_callback,
> > +		device
> > +		);
> > +
> 
> This blank line is extra IMO.
> 
> > +	if (ret != 0) {
> > +		free_input_device(input_dev);
> > +		return ret;
> 
> Please do not mix error unwinding with gotos and unwinding in error
> handling branches.

Done.
> 
> > +	}
> > +
> > +	ret = mousevsc_connect_to_vsp(device);
> > +
> 
> This blank line is extra IMO.
> 
> > +	if (ret != 0)
> > +		goto probe_err0;
> > +
> > +	/* workaround SA-167 */
> > +	if (input_dev->report_desc[14] == 0x25)
> > +		input_dev->report_desc[14] = 0x29;
> > +
> > +	hid_dev = hid_allocate_device();
> > +	if (IS_ERR(hid_dev)) {
> > +		ret = PTR_ERR(hid_dev);
> > +		goto probe_err0;
> > +	}
> > +
> > +	hid_dev->ll_driver = &mousevsc_ll_driver;
> > +	hid_dev->driver = &mousevsc_hid_driver;
> 
> You are not really hid driver; you are more of a "provider" so why do
> you need to set hid_dev->driver in addition to hid_dev->ll_driver?
> 
True, but hid_parse_report() expects that the driver field be set; so I
need to fake this.
 
> > +	hid_dev->bus = BUS_VIRTUAL;
> > +	hid_dev->vendor = input_dev->hid_dev_info.vendor;
> > +	hid_dev->product = input_dev->hid_dev_info.product;
> > +	hid_dev->version = input_dev->hid_dev_info.version;
> > +	input_dev->hid_device = hid_dev;
> > +
> > +	sprintf(hid_dev->name, "%s", "Microsoft Vmbus HID-compliant Mouse");
> 
> strlcpy?
> 
> > +
> > +	ret = hid_parse_report(hid_dev, input_dev->report_desc,
> > +				input_dev->report_desc_size);
> > +
> > +	if (ret) {
> > +		hid_err(hid_dev, "parse failed\n");
> > +		goto probe_err1;
> > +	}
> > +
> > +	ret = hid_hw_start(hid_dev, HID_CONNECT_HIDINPUT |
> HID_CONNECT_HIDDEV);
> 
> Why do you need to call hid_hw_start instead of letting HID core figure
> it out for you?

I am not a hid expert; but all  hid low level drivers appear to do this.
Initially, I was directly invoking hid_connect() directly and based on your
Input, I chose to use hid_hw_start() which all other drivers are using.

> 
> > +
> > +	if (ret) {
> > +		hid_err(hid_dev, "hw start failed\n");
> > +		goto probe_err1;
> > +	}
> > +
> > +	input_dev->connected = true;
> > +	input_dev->init_complete = true;
> > +
> > +	return ret;
> > +
> > +probe_err1:
> > +	hid_destroy_device(hid_dev);
> > +
> > +probe_err0:
> > +	vmbus_close(device->channel);
> > +	free_input_device(input_dev);
> > +	return ret;
> > +}
> > +
> > +
> > +static int mousevsc_remove(struct hv_device *dev)
> > +{
> > +	struct mousevsc_dev *input_dev = hv_get_drvdata(dev);
> > +
> > +	vmbus_close(dev->channel);
> > +
> > +	if (input_dev->connected) {
> 
> Can we even get here if input_dev->connected == false?
> 
> > +		hidinput_disconnect(input_dev->hid_device);
> 
> You did not explicitly connect hidinput; leave disconnecting to the HID
> core as well.
> 
> It looks like all that is needed is:
> 
> static int mousevsc_remove(struct hv_device *dev)
> {
> 	struct mousevsc_dev *mouse = hv_get_drvdata(dev);
> 
> 	vmbus_close(dev->channel);
> 	hid_destroy_device(mouse->hid_device);
> 	mousevcs_free_device(mouse);
> 
> 	return 0;
> }

Done.

> 
> > +		input_dev->connected = false;
> > +		hid_destroy_device(input_dev->hid_device);
> > +	}
> > +
> > +	free_input_device(input_dev);
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct hv_vmbus_device_id id_table[] = {
> > +	/* Mouse guid */
> > +	{ VMBUS_DEVICE(0x9E, 0xB6, 0xA8, 0xCF, 0x4A, 0x5B, 0xc0, 0x4c,
> > +		       0xB9, 0x8B, 0x8B, 0xA1, 0xA1, 0xF3, 0xF9, 0x5A) },
> > +	{ },
> > +};
> > +
> > +MODULE_DEVICE_TABLE(vmbus, id_table);
> > +
> > +static struct  hv_driver mousevsc_drv = {
> > +	.name = KBUILD_MODNAME,
> > +	.id_table = id_table,
> > +	.probe = mousevsc_probe,
> > +	.remove = mousevsc_remove,
> > +};
> > +
> > +static int __init mousevsc_init(void)
> > +{
> > +	return vmbus_driver_register(&mousevsc_drv);
> > +}
> > +
> > +static void __exit mousevsc_exit(void)
> > +{
> > +	vmbus_driver_unregister(&mousevsc_drv);
> > +}
> > +
> > +MODULE_LICENSE("GPL");
> > +MODULE_VERSION(HV_DRV_VERSION);
> > +module_init(mousevsc_init);
> > +module_exit(mousevsc_exit);
> > --
> > 1.7.4.1
> >
> 
> Thanks.

Thank you!

K. Y

