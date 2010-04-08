Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758954Ab0DHSmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 14:42:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:49477 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758867Ab0DHSmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 14:42:22 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19swbh0Jl1ssetUeJB1EoZqwSFMQMDXtgNi6YpRHn
	E07RrkJdLbtkgU
Message-ID: <4BBE2389.5010802@gmx.de>
Date: Thu, 08 Apr 2010 20:42:17 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 02/16] viafb: use proper pci config API
References: <1270746946-12467-1-git-send-email-corbet@lwn.net> <1270746946-12467-3-git-send-email-corbet@lwn.net>
In-Reply-To: <1270746946-12467-3-git-send-email-corbet@lwn.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.40000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

something I am wondering about is whether we can't simply do:
viaparinfo->memsize = pci_resource_len(pdev, 0);
I suppose that this is not possible meaning that the pci len can be 
longer than the actual memory but I just wanted to use the moment to 
make sure.

Jonathan Corbet schrieb:
> From: Harald Welte <laforge@gnumonks.org>
> 
> This patch alters viafb to use the proper Linux in-kernel API to access
> PCI configuration space, rather than poking at I/O ports by itself.
> 
> Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
> ---
>  drivers/video/via/hw.c |   64 +++++++++++++++++++++++++++++------------------
>  drivers/video/via/hw.h |    4 +-
>  2 files changed, 41 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
> index ea0f8ec..f2e4bda 100644
> --- a/drivers/video/via/hw.c
> +++ b/drivers/video/via/hw.c
> @@ -2542,24 +2542,37 @@ static void disable_second_display_channel(void)
>  	viafb_write_reg_mask(CR6A, VIACR, BIT6, BIT6);
>  }
>  
> +static u_int16_t via_function3[] = {
> +	CLE266_FUNCTION3, KM400_FUNCTION3, CN400_FUNCTION3, CN700_FUNCTION3,
> +	CX700_FUNCTION3, KM800_FUNCTION3, KM890_FUNCTION3, P4M890_FUNCTION3,
> +	P4M900_FUNCTION3, VX800_FUNCTION3, VX855_FUNCTION3,
> +};
> +
> +/* Get the BIOS-configured framebuffer size from PCI configuration space
> + * of function 3 in the respective chipset */
>  int viafb_get_fb_size_from_pci(void)
>  {
> -	unsigned long configid, deviceid, FBSize = 0;
> -	int VideoMemSize;
> -	int DeviceFound = false;
> -
> -	for (configid = 0x80000000; configid < 0x80010800; configid += 0x100) {
> -		outl(configid, (unsigned long)0xCF8);
> -		deviceid = (inl((unsigned long)0xCFC) >> 16) & 0xffff;
> -
> -		switch (deviceid) {
> -		case CLE266:
> -		case KM400:
> -			outl(configid + 0xE0, (unsigned long)0xCF8);
> -			FBSize = inl((unsigned long)0xCFC);
> -			DeviceFound = true;	/* Found device id */
> -			break;
> +	int i;
> +	u_int8_t offset = 0;
> +	u_int32_t FBSize;
> +	u_int32_t VideoMemSize;
> +
> +	/* search for the "FUNCTION3" device in this chipset */
> +	for (i = 0; i < ARRAY_SIZE(via_function3); i++) {

Would it be possible to replace this loop with a lookup table that uses 
the fact that we already know which IGP we have?
Yeah, that's not a bug it only feels a bit awkward to do it this way.

> +		struct pci_dev *pdev;
> +
> +		pdev = pci_get_device(PCI_VENDOR_ID_VIA, via_function3[i],
> +				      NULL);
> +		if (!pdev)
> +			continue;
> +
> +		DEBUG_MSG(KERN_INFO "Device ID = %x\n", pdev->device);
>  
> +		switch (pdev->device) {
> +		case CLE266_FUNCTION3:
> +		case KM400_FUNCTION3:
> +			offset = 0xE0;
> +			break;
>  		case CN400_FUNCTION3:
>  		case CN700_FUNCTION3:
>  		case CX700_FUNCTION3:
> @@ -2569,21 +2582,22 @@ int viafb_get_fb_size_from_pci(void)
>  		case P4M900_FUNCTION3:
>  		case VX800_FUNCTION3:
>  		case VX855_FUNCTION3:
> -			/*case CN750_FUNCTION3: */
> -			outl(configid + 0xA0, (unsigned long)0xCF8);
> -			FBSize = inl((unsigned long)0xCFC);
> -			DeviceFound = true;	/* Found device id */
> -			break;
> -
> -		default:
> +		/*case CN750_FUNCTION3: */
> +			offset = 0xA0;
>  			break;
>  		}
> -
> -		if (DeviceFound)
> +		
> +		if (!offset)
>  			break;
> +
> +		pci_read_config_dword(pdev, offset, &FBSize);
> +		pci_dev_put(pdev);
>  	}
>  
> -	DEBUG_MSG(KERN_INFO "Device ID = %lx\n", deviceid);
> +	if (!offset) {
> +		printk(KERN_ERR "cannot determine framebuffer size\n");
> +		return -EIO;

This function was not designed to return an error (memsize is not 
checked). Either return a default value (let's say 8MB) or add a check 
for memsize.

> +	}
>  
>  	FBSize = FBSize & 0x00007000;
>  	DEBUG_MSG(KERN_INFO "FB Size = %x\n", FBSize);
> diff --git a/drivers/video/via/hw.h b/drivers/video/via/hw.h
> index b874d95..f67a56a 100644
> --- a/drivers/video/via/hw.h
> +++ b/drivers/video/via/hw.h
> @@ -822,8 +822,8 @@ struct iga2_crtc_timing {
>  };
>  
>  /* device ID */
> -#define CLE266              0x3123
> -#define KM400               0x3205
> +#define CLE266_FUNCTION3    0x3123
> +#define KM400_FUNCTION3     0x3205
>  #define CN400_FUNCTION2     0x2259
>  #define CN400_FUNCTION3     0x3259
>  /* support VT3314 chipset */

Thanks,

Florian Tobias Schandinat
