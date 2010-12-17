Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab0LQXKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 18:10:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37262 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755577Ab0LQXKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 18:10:45 -0500
Date: Fri, 17 Dec 2010 15:09:40 -0800
From: Greg KH <gregkh@suse.de>
To: rmorell@nvidia.com
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Benoit Goby <benoit@android.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Ming Lei <tom.leiming@gmail.com>, Jacob Pan <jacob.jun.pan@intel.com>,
        Olof Johansson <olof@lixom.net>, Erik Gilling <konkers@android.com>,
        Colin Cross <ccross@android.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] USB: ehci: tegra: Align DMA transfers to 32 bytes
Message-ID: <20101217230940.GB21147@suse.de>
References: <1292623129-26361-1-git-send-email-rmorell@nvidia.com>
 <1292623129-26361-3-git-send-email-rmorell@nvidia.com>
 <20101217223502.GB19418@suse.de>
 <20101217224221.GE25105@morell.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101217224221.GE25105@morell.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 02:42:21PM -0800, rmorell@nvidia.com wrote:
> On Fri, Dec 17, 2010 at 02:35:02PM -0800, Greg KH wrote:
> > On Fri, Dec 17, 2010 at 01:58:49PM -0800, Robert Morell wrote:
> > > The Tegra2 USB controller doesn't properly deal with misaligned DMA
> > > buffers, causing corruption.  This is especially prevalent with USB
> > > network adapters, where skbuff alignment is often in the middle of a
> > > 4-byte dword.
> > > 
> > > To avoid this, allocate a temporary buffer for the DMA if the provided
> > > buffer isn't sufficiently aligned.
> > > 
> > > Signed-off-by: Robert Morell <rmorell@nvidia.com>
> > > Reviewed-by: Scott Williams <scwilliams@nvidia.com>
> > > Reviewed-by: Janne Hellsten <jhellsten@nvidia.com>
> > > ---
> > >  drivers/usb/host/ehci-tegra.c |   94 +++++++++++++++++++++++++++++++++++++++++
> > >  include/linux/usb.h           |    1 +
> > >  2 files changed, 95 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
> > > index d990c1c..a75e4db 100644
> > > --- a/drivers/usb/host/ehci-tegra.c
> > > +++ b/drivers/usb/host/ehci-tegra.c
> > > @@ -32,6 +32,10 @@
> > >  #define TEGRA_USB_USBMODE_HOST			(3 << 0)
> > >  #define TEGRA_USB_PORTSC1_PTC(x)		(((x) & 0xf) << 16)
> > >  
> > > +#define TEGRA_USB_DMA_ALIGN 32
> > > +
> > > +#define URB_ALIGNED_TEMP_BUFFER 0x80000000
> > > +
> > >  struct tegra_ehci_context {
> > >  	bool valid;
> > >  	u32 command;
> > > @@ -457,6 +461,94 @@ static int tegra_ehci_bus_resume(struct usb_hcd *hcd)
> > >  }
> > >  #endif
> > >  
> > > +struct temp_buffer {
> > > +	void *kmalloc_ptr;
> > > +	void *old_xfer_buffer;
> > > +	u8 data[0];
> > > +};
> > > +
> > > +static void free_temp_buffer(struct urb *urb)
> > > +{
> > > +	enum dma_data_direction dir;
> > > +	struct temp_buffer *temp;
> > > +
> > > +	if (!(urb->transfer_flags & URB_ALIGNED_TEMP_BUFFER))
> > > +		return;
> > > +
> > > +	dir = usb_urb_dir_in(urb) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
> > > +
> > > +	temp = container_of(urb->transfer_buffer, struct temp_buffer,
> > > +			    data);
> > > +
> > > +	if (dir == DMA_FROM_DEVICE)
> > > +		memcpy(temp->old_xfer_buffer, temp->data,
> > > +		       urb->transfer_buffer_length);
> > > +	urb->transfer_buffer = temp->old_xfer_buffer;
> > > +	kfree(temp->kmalloc_ptr);
> > > +
> > > +	urb->transfer_flags &= ~URB_ALIGNED_TEMP_BUFFER;
> > > +}
> > > +
> > > +static int alloc_temp_buffer(struct urb *urb, gfp_t mem_flags)
> > > +{
> > > +	enum dma_data_direction dir;
> > > +	struct temp_buffer *temp, *kmalloc_ptr;
> > > +	size_t kmalloc_size;
> > > +	void *data;
> > > +
> > > +	if (urb->num_sgs || urb->sg ||
> > > +	    urb->transfer_buffer_length == 0 ||
> > > +	    !((uintptr_t)urb->transfer_buffer & (TEGRA_USB_DMA_ALIGN - 1)))
> > > +		return 0;
> > > +
> > > +	dir = usb_urb_dir_in(urb) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
> > > +
> > > +	/* Allocate a buffer with enough padding for alignment */
> > > +	kmalloc_size = urb->transfer_buffer_length +
> > > +		sizeof(struct temp_buffer) + TEGRA_USB_DMA_ALIGN - 1;
> > > +
> > > +	kmalloc_ptr = kmalloc(kmalloc_size, mem_flags);
> > > +	if (!kmalloc_ptr)
> > > +		return -ENOMEM;
> > > +
> > > +	/* Position our struct temp_buffer such that data is aligned */
> > > +	temp = PTR_ALIGN(kmalloc_ptr + 1, TEGRA_USB_DMA_ALIGN) - 1;
> > > +
> > > +	temp->kmalloc_ptr = kmalloc_ptr;
> > > +	temp->old_xfer_buffer = urb->transfer_buffer;
> > > +	if (dir == DMA_TO_DEVICE)
> > > +		memcpy(temp->data, urb->transfer_buffer,
> > > +		       urb->transfer_buffer_length);
> > > +	urb->transfer_buffer = temp->data;
> > > +
> > > +	BUILD_BUG_ON(!(URB_ALIGNED_TEMP_BUFFER & URB_DRIVER_PRIVATE));
> > 
> > See below why this should be removed
> > 
> > > +	urb->transfer_flags |= URB_ALIGNED_TEMP_BUFFER;
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int tegra_ehci_map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
> > > +				      gfp_t mem_flags)
> > > +{
> > > +	int ret;
> > > +
> > > +	ret = alloc_temp_buffer(urb, mem_flags);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	ret = usb_hcd_map_urb_for_dma(hcd, urb, mem_flags);
> > > +	if (ret)
> > > +		free_temp_buffer(urb);
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +static void tegra_ehci_unmap_urb_for_dma(struct usb_hcd *hcd, struct urb *urb)
> > > +{
> > > +	usb_hcd_unmap_urb_for_dma(hcd, urb);
> > > +	free_temp_buffer(urb);
> > > +}
> > > +
> > >  static const struct hc_driver tegra_ehci_hc_driver = {
> > >  	.description		= hcd_name,
> > >  	.product_desc		= "Tegra EHCI Host Controller",
> > > @@ -472,6 +564,8 @@ static const struct hc_driver tegra_ehci_hc_driver = {
> > >  	.shutdown		= tegra_ehci_shutdown,
> > >  	.urb_enqueue		= ehci_urb_enqueue,
> > >  	.urb_dequeue		= ehci_urb_dequeue,
> > > +	.map_urb_for_dma	= tegra_ehci_map_urb_for_dma,
> > > +	.unmap_urb_for_dma	= tegra_ehci_unmap_urb_for_dma,
> > >  	.endpoint_disable	= ehci_endpoint_disable,
> > >  	.endpoint_reset		= ehci_endpoint_reset,
> > >  	.get_frame_number	= ehci_get_frame,
> > > diff --git a/include/linux/usb.h b/include/linux/usb.h
> > > index 35fe6ab..cd07173 100644
> > > --- a/include/linux/usb.h
> > > +++ b/include/linux/usb.h
> > > @@ -975,6 +975,7 @@ extern int usb_disabled(void);
> > >  #define URB_SETUP_MAP_SINGLE	0x00100000	/* Setup packet DMA mapped */
> > >  #define URB_SETUP_MAP_LOCAL	0x00200000	/* HCD-local setup packet */
> > >  #define URB_DMA_SG_COMBINED	0x00400000	/* S-G entries were combined */
> > > +#define URB_DRIVER_PRIVATE	0x80000000	/* For driver-private use */
> > 
> > Um, what?  You are using this for a build check, which seems pointless
> > as you already modified the code to not need this.
> > 
> > So it doesn't look like this is needed, right?
> 
> The intention was to reserve space in the URB flags for
> implementation-specific use.

Yes, but _which_ driver are you talking about here?  You didn't say that
this was a HCD-only flag, right?

> This placeholder should keep anybody from adding driver-agnostic flags
> to that mask.  The BUILD_BUG_ON is intended to make sure that the
> driver private space doesn't move out from under the Tegra-specific
> flag.

I still don't like it, it feels like a hack that is not going to be able
to be maintained very well.

And I still think the individual drivers should be fixed...

thanks,

greg k-h
