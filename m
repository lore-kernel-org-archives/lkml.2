Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab0JGVP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:15:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50618 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756225Ab0JGVPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:15:22 -0400
Date: Thu, 7 Oct 2010 14:09:19 -0700
From: Greg KH <gregkh@suse.de>
To: Brokhman Tatyana <tlinder@codeaurora.org>
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Matthew Wilcox <willy@linux.intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH v3] usb: usb3.0 ch9 definitions
Message-ID: <20101007210919.GA26660@suse.de>
References: <1286476470-15265-1-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286476470-15265-1-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 08:34:28PM +0200, Brokhman Tatyana wrote:
> Adding SuperSpeed usb definitions as defined by ch9 of the USB3.0 spec.
> This patch is a preparation for adding SuperSpeed support to the gadget
> framework.
> 
> Signed-off-by: Brokhman Tatyana <tlinder@codeaurora.org>

Is this still a [RFC] or is it something that you think should be
applied to the tree?

> ---
>  include/linux/usb/ch9.h |   58 ++++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 57 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/usb/ch9.h b/include/linux/usb/ch9.h
> index da2ed77..a779b86 100644
> --- a/include/linux/usb/ch9.h
> +++ b/include/linux/usb/ch9.h
> @@ -123,8 +123,23 @@
>  #define USB_DEVICE_A_ALT_HNP_SUPPORT	5	/* (otg) other RH port does */
>  #define USB_DEVICE_DEBUG_MODE		6	/* (special devices only) */
>  
> +/*
> + * New Feature Selectors as added by USB 3.0
> + * See USB 3.0 spec Table 9-6
> + */
> +#define USB_DEVICE_U1_ENABLE	48	/* dev may initiate U1 transition */
> +#define USB_DEVICE_U2_ENABLE	49	/* dev may initiate U2 transition*/
> +#define USB_DEVICE_LTM_ENABLE	50	/* dev may send LTM*/
> +#define USB_INTRF_FUNC_SUSPEND	0	/* function suspend*/
> +
> +#define USB_INTR_FUNC_SUSPEND_OPT_MASK	0xFF00
> +
>  #define USB_ENDPOINT_HALT		0	/* IN/OUT will STALL */
>  
> +/* Bit array elements as returned by the USB_REQ_GET_STATUS request. */
> +#define USB_DEV_STAT_U1_ENABLED		2	/* transition into U1 state */
> +#define USB_DEV_STAT_U2_ENABLED		3	/* transition into U2 state */
> +#define USB_DEV_STAT_LTM_ENABLED	4	/* Latency tolerance messages*/
>  
>  /**
>   * struct usb_ctrlrequest - SETUP data for a USB device control request
> @@ -675,6 +690,7 @@ struct usb_bos_descriptor {
>  	__u8  bNumDeviceCaps;
>  } __attribute__((packed));
>  
> +#define USB_DT_BOS_SIZE		5
>  /*-------------------------------------------------------------------------*/
>  
>  /* USB_DT_DEVICE_CAPABILITY:  grouped with BOS */
> @@ -712,16 +728,56 @@ struct usb_wireless_cap_descriptor {	/* Ultra Wide Band */
>  	__u8  bReserved;
>  } __attribute__((packed));
>  
> +/* USB 2.0 Extension descriptor */
>  #define	USB_CAP_TYPE_EXT		2
>  
>  struct usb_ext_cap_descriptor {		/* Link Power Management */
>  	__u8  bLength;
>  	__u8  bDescriptorType;
>  	__u8  bDevCapabilityType;
> -	__u8  bmAttributes;
> +	__u32 bmAttributes;
>  #define USB_LPM_SUPPORT			(1 << 1)	/* supports LPM */
>  } __attribute__((packed));

This structure just got bigger?  How is that going to affect existing
users of it?  And shoudn't that be in __le32 format instead of __u32?


>  
> +#define USB_DT_USB_EXT_CAP_SIZE	7
> +
> +/*
> + * SuperSpeed USB Capability descriptor: Defines the set of SuperSpeed USB
> + * specific device level capabilities
> + */
> +#define		USB_SS_CAP_TYPE		3
> +struct usb_ss_cap_descriptor {		/* Link Power Management */
> +	__u8  bLength;
> +	__u8  bDescriptorType;
> +	__u8  bDevCapabilityType;
> +	__u8  bmAttributes;
> +#define USB_LTM_SUPPORT			(1 << 1) /* supports LTM */
> +	__u16 wSpeedSupported;

__le16?

> +#define USB_LOW_SPEED_OPERATION		(1)	 /* Low speed operation */
> +#define USB_FULL_SPEED_OPERATION	(1 << 1) /* Full speed operation */
> +#define USB_HIGH_SPEED_OPERATION	(1 << 2) /* High speed operation */
> +#define USB_5GBPS_OPERATION		(1 << 3) /* Operation at 5Gbps */
> +	__u8  bFunctionalitySupport;
> +	__u8  bU1devExitLat;
> +	__u16 bU2DevExitLat;

__le16?  I'm guessing these fields haven't actually been used for
anything?

> +} __attribute__((packed));
> +
> +#define USB_DT_USB_SS_CAP_SIZE	10
> +
> +/*
> + * Container ID Capability descriptor: Defines the instance unique ID used to
> + * identify the instance across all operating modes
> + */
> +#define	CONTAINER_ID_TYPE	4
> +struct usb_ss_container_id_descriptor {
> +	__u8  bLength;
> +	__u8  bDescriptorType;
> +	__u8  bDevCapabilityType;
> +	__u8  bReserved;
> +	__u8  ContainerID[16]; /* 128-bit number */

Is this number in any specific endian format?  If so, you're going to
have a hard time handling it as an array of bytes, aren't you?  How is
this going to be managed?

thanks,

greg k-h
