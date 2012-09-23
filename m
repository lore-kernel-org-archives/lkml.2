Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab2IWP0S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 11:26:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61860 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab2IWP0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 11:26:15 -0400
Message-ID: <505F2A01.7010109@gmail.com>
Date: Sun, 23 Sep 2012 23:25:53 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        Julia Lawall <julia@diku.dk>, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 01/40] PCI: fix default vga ref_count
References: <CAE9FiQWFcVNKMnV1qaHchwCXfZuMpyxf_f7GQy3FZid9YuLD3w@mail.gmail.com> <1348080894-23412-1-git-send-email-yinghai@kernel.org> <1348080894-23412-2-git-send-email-yinghai@kernel.org>
In-Reply-To: <1348080894-23412-2-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2012 02:54 AM, Yinghai Lu wrote:
> when __ARCH_HAS_VGA_DEFAULT_DEVICE is not defined, aka EFIFB is not used,
> for static path, vga_default setting is through vga_arbiter_add_pci_device.
> and later x86 pci_fixup_video, will skip setting again.
> - subsys_initcall(vga_arb_device_init) come first to call vga_arbiter_add_pci_device. It will call pci_get_dev to hold one reference.
> 
> for hotplug add path, even vga_arbiter_add_pci_device is called via notifier,
> but it will check VGA_RSRC_LEGACY_MASK that is not set for hotplug path.
> So x86 pci_fixup_video will take over to call vga_set_default_device().
> It will not hold one refrence.
> 
> Later for hotplug remove path, vga_arbiter_del_pci_device that does not check
> VGA_RSRC_LEGACY_MASK will call put_device and it will cause ref_count to
> decrease extra. that will have that pci device get deleted early wrongly.
> 
> Need to make get/put balance for both cases.
> 
> -v2: According to Bjorn, update vga_set_default_device instead...
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: x86@kernel.org
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Julia Lawall <julia@diku.dk>
> Cc: Matthew Garrett <mjg@redhat.com>
> ---
>  drivers/gpu/vga/vgaarb.c |   14 +++++++++-----
>  1 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
> index b6852b7..0888951e 100644
> --- a/drivers/gpu/vga/vgaarb.c
> +++ b/drivers/gpu/vga/vgaarb.c
> @@ -141,6 +141,12 @@ EXPORT_SYMBOL_GPL(vga_default_device);
>  
>  void vga_set_default_device(struct pci_dev *pdev)
>  {
> +	if (vga_default)
> +		pci_dev_put(vga_default);
> +
> +	if (pdev)
> +		pdev = pci_dev_get(pdev);
> +
>  	vga_default = pdev;
>  }
Seems it could be simplified as
void vga_set_default_device(struct pci_dev *pdev)
{
	pci_dev_put(vga_default);
 	vga_default = pci_dev_get(pdev);
}
--Gerry

>  #endif
> @@ -577,7 +583,7 @@ static bool vga_arbiter_add_pci_device(struct pci_dev *pdev)
>  #ifndef __ARCH_HAS_VGA_DEFAULT_DEVICE
>  	if (vga_default == NULL &&
>  	    ((vgadev->owns & VGA_RSRC_LEGACY_MASK) == VGA_RSRC_LEGACY_MASK))
> -		vga_default = pci_dev_get(pdev);
> +		vga_set_default_device(pdev);
>  #endif
>  
>  	vga_arbiter_check_bridge_sharing(vgadev);
> @@ -613,10 +619,8 @@ static bool vga_arbiter_del_pci_device(struct pci_dev *pdev)
>  	}
>  
>  #ifndef __ARCH_HAS_VGA_DEFAULT_DEVICE
> -	if (vga_default == pdev) {
> -		pci_dev_put(vga_default);
> -		vga_default = NULL;
> -	}
> +	if (vga_default == pdev)
> +		vga_set_default_device(NULL);
>  #endif
>  
>  	if (vgadev->decodes & (VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM))
> 

