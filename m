Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab0JCQmD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 12:42:03 -0400
Received: from netrider.rowland.org ([192.131.102.5]:44586 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753618Ab0JCQmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 12:42:01 -0400
Date: Sun, 3 Oct 2010 12:41:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: tlinder <tlinder@codeaurora.org>
cc: USB list <linux-usb@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH 2/2] usb:gadget: Add SuperSpeed support to the Gadget
 Framework
In-Reply-To: <1286092937-29191-1-git-send-email-tlinder@codeaurora.org>
Message-ID: <Pine.LNX.4.44L0.1010031236540.26676-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Oct 2010, tlinder wrote:

> From: Tatyana Linder <tlinder@codeaurora.org>
> 
> This patch adds the SuperSpeed functionality to the gadget framework.
> In order not to force all the FDs to supply SuperSpeed descriptors when
> operating in SuperSpeed mode the following approach was taken:
> If we're operating in SuperSpeed mode and the FD didn't supply SuperSpeed
> descriptors, the composite layer will automatically create SuperSpeed
> descriptors with default values.
> Support for new SuperSpeed BOS descriptor was added.
> Support for SET_FEATURE and GET_STATUS requests in SuperSpeed mode was
> added.

...

> diff --git a/include/linux/usb/ch9.h b/include/linux/usb/ch9.h
> index da2ed77..69e528a 100644
> --- a/include/linux/usb/ch9.h
> +++ b/include/linux/usb/ch9.h
> @@ -125,6 +125,20 @@
>  
>  #define USB_ENDPOINT_HALT		0	/* IN/OUT will STALL */
>  
> +/**
> + * New Feature Selectors as added by USB 3.0
> + * See USB 3.0 spec Table 9-6
> + */
> +#define USB_DEVICE_U1_ENABLE		48	/*enables the upstream port to
> +						initiate requests for transition
> +						into U1 state*/
> +#define USB_DEVICE_U2_ENABLE		49	/*enables the upstream port to
> +						initiate requests for transition
> +						into U2 state*/
> +#define USB_DEVICE_LTM_ENABLE		50	/*enables the devise to send
> +						Latency tolerance messages.*/
> +#define USB_INTRF_FUNC_SUSPEND		0	/*function suspend*/
> +

Since these are device and interface features, they belong before the
endpoint feature above, not after it.

> +/*SuperSpeed USB Capability descriptor: Defines the set of SuperSpeed USB
> +  specific device level capabilities*/
> +#define	SS_USB_CAP_TYPE		3

This should be USB_SS_CAP_TYPE.

> +struct ss_usb_cap_descriptor {		/* Link Power Management */
> +	__u8  bLength;
> +	__u8  bDescriptorType;
> +	__u8  bDevCapabilityType;
> +	__u8  bmAttributes;
> +#define USB_LTM_SUPPORT			(1 << 1) /* supports LTM */
> +	__u16 wSpeedSupported;
> +#define USB_LOW_SPEED_OPERATION		(1)	 /* Low speed operation */
> +#define USB_FULL_SPEED_OPERATION	(1 << 1) /* Full speed operation */
> +#define USB_HIGH_SPEED_OPERATION	(1 << 2) /* High speed operation */
> +#define USB_5GBPS_OPERATION		(1 << 3) /* Operation at 5Gbps */
> +	__u8  bFunctionalitySupport;
> +	__u8  bU1devExitLat;
> +	__u16 bU2DevExitLat;
> +} __attribute__((packed));

Similarly, this should usb_ss_cap_descriptor (by analogy with 
usb_otg_descriptor or usb_wireless_cap_descriptor).

> +#define USB_DT_SS_USB_CAP_SIZE	10
> +
> +/*Container ID Capability descriptor: Defines the instance unique ID used to
> +  identify the instance across all operating modes*/
> +#define	CONTAINER_ID_TYPE	4
> +struct ss_usb_container_id_descriptor {
> +	__u8  bLength;
> +	__u8  bDescriptorType;
> +	__u8  bDevCapabilityType;
> +	__u8  bReserved;
> +	__u8  ContainerID[16]; /*128-bit number*/
> +} __attribute__((packed));
> +
> +#define USB_DT_SS_CONTN_ID_SIZE	20

And this should be usb_ss_container_id_descriptor.

Alan Stern

