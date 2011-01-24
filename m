Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab1AXQg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 11:36:59 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:48682 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753675Ab1AXQg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 11:36:56 -0500
Date: Mon, 24 Jan 2011 11:36:55 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Robert Morell <rmorell@nvidia.com>
cc: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Benoit Goby <benoit@android.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Ming Lei <tom.leiming@gmail.com>, Jacob Pan <jacob.jun.pan@intel.com>,
        Oliver Neukum <oliver@neukum.org>, Olof Johansson <olof@lixom.net>,
        Erik Gilling <konkers@android.com>, Colin Cross <ccross@android.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 2/2] USB: ehci: tegra: Align DMA transfers to 32 bytes
In-Reply-To: <1295559715-14264-3-git-send-email-rmorell@nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1101241132420.2030-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jan 2011, Robert Morell wrote:

> The Tegra2 USB controller doesn't properly deal with misaligned DMA
> buffers, causing corruption.  This is especially prevalent with USB
> network adapters, where skbuff alignment is often in the middle of a
> 4-byte dword.
> 
> To avoid this, allocate a temporary buffer for the DMA if the provided
> buffer isn't sufficiently aligned.
> 
> Signed-off-by: Robert Morell <rmorell@nvidia.com>
> ---
>  drivers/usb/host/ehci-tegra.c |   92 +++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 92 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
> index 2341904..7cdfc65 100644
> --- a/drivers/usb/host/ehci-tegra.c
> +++ b/drivers/usb/host/ehci-tegra.c
> @@ -32,6 +32,8 @@
>  #define TEGRA_USB_USBMODE_HOST			(3 << 0)
>  #define TEGRA_USB_PORTSC1_PTC(x)		(((x) & 0xf) << 16)
>  
> +#define TEGRA_USB_DMA_ALIGN 32
> +
>  struct tegra_ehci_context {
>  	bool valid;
>  	u32 command;
> @@ -461,6 +463,94 @@ static int tegra_ehci_bus_resume(struct usb_hcd *hcd)
>  }
>  #endif
>  
> +struct temp_buffer {
> +	void *kmalloc_ptr;
> +	void *old_xfer_buffer;
> +	u8 data[0];
> +};
> +
> +static void free_temp_buffer(struct urb *urb, int status)
> +{
> +	enum dma_data_direction dir;
> +	struct temp_buffer *temp;
> +
> +	if (!(urb->transfer_flags & URB_ALIGNED_TEMP_BUFFER))
> +		return;
> +
> +	dir = usb_urb_dir_in(urb) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
> +
> +	temp = container_of(urb->transfer_buffer, struct temp_buffer,
> +			    data);
> +
> +	if (dir == DMA_FROM_DEVICE && !status)
> +		memcpy(temp->old_xfer_buffer, temp->data,
> +			urb->transfer_buffer_length);

Even if status is nonzero, there may be valid data in the buffer.  You 
should skip that test.

No other problems that I can see.

Alan Stern


